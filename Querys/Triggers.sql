

create Trigger DeleteCliente on BIBLIOTECA.Pessoa instead of Delete
as
	declare @id as int;
	select @id=id from deleted;
	delete from BIBLIOTECA.Socio where id_cliente=@id;
	delete from BIBLIOTECA.Nao_Socio where id_cliente=@id;
	update BIBLIOTECA.Emprestimo set cliente=null where cliente=@id
	delete from BIBLIOTECA.Cliente where id_cliente=@id
	delete from BIBLIOTECA.Autor where id_autor=@id;
	delete from BIBLIOTECA.Funcionario where id_funcionario=@id;
	delete from BIBLIOTECA.Pessoa where id=@id

go

create Trigger DeleteLivro on Biblioteca.Livro instead of Delete
as
	declare @isbn as varchar(50);
	select @isbn=ISBN from deleted;
	delete from BIBLIOTECA.Escreve where id_livro=@isbn;
	delete from BIBLIOTECA.Livros_Exemplares where ISBN=@isbn;
	delete from BIBLIOTECA.Livro where ISBN=@isbn;
go
