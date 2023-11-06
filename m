Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E6918E05
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 11:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zmskUZWy"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-41cbf31da84so28060141cf.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 03:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699270930; x=1699875730; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sHi6HNfMoiiRWrk//ou0On9wauTiypiZpuQxJoOASgE=;
        b=zmskUZWyayHk6uA/5ZlPcKoMQ1BEERQKV7pltVV8OXlpXXJLRaIxMhPjcAvvNsrvGU
         sKkhac3t4ujDbySsR7Q2i1G96oVc5Aw0qe7pX5/cGMUW+F3v6KXzR9Ms+hA4252l0+KS
         80+1zpHZfdGiGhZ+N2w364hP+Y0W6SvHsf/zjDdFGwxLAFbxbY/ud41U4AuwcOCNhrTY
         YeGmVl2uCrF9Wyq3miCGrtUAGRezgNpaPzVfG7CVJZcTGe8gdpXjix6Wpsw6Esjjx/aK
         02nrNvUp6Reqr4XPZjmfSHd2CPKsdj/vwOPg0oY/50odb2nTF158qevry+6mlXL6PXpJ
         kSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699270930; x=1699875730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sHi6HNfMoiiRWrk//ou0On9wauTiypiZpuQxJoOASgE=;
        b=nf7mkazpTkiHhY/kPGBNO5VVhXbGy35Tet8G9H2CvYb7f3Dz6YXVbnwyjfEew9vCKM
         CHth8hE/9JWVnowHc4L4b9FLGsx0+YVb6Vdj+ehEH7zvRVyI1d+2eaBqGOsvDcXmiRsI
         CfYSKe6nfyXFGYxvnCqV+TycZCdebPGpt3e0QMzA0xgkA1B61J940V3jLCmOUE+A4g4H
         UKg3FsTJ4ojTBKPzLuQzCP1jOpnwwWt22zYNZw/BBqrZAsKZOMBXoLW1WnkI9LQXViBu
         h07YZZOK+76Q8XE9WCPmR40fi5JL11FfDPWBL0ZnC8zhU/4Zh57HnIWR7zGvmnTvBVBx
         rfdQ==
X-Gm-Message-State: AOJu0YyzKV2iSg3mkwlEdUasIy918ALOSMmhLv87AmjLWEDMt7ncUvXW
	vMw41Biy3C9tSkMRGs6nUMSrYtLAvkOvIjBYSyKhlw==
X-Google-Smtp-Source: AGHT+IFqtL+i8IMlADOUnxNtS9BqYz4IVdy1FTYYXRfD2pg+wEXN2AL/1eIHCBiP2/6Ge2uIUEuwBkXjW7tgEM1U/80=
X-Received: by 2002:a05:6214:dcf:b0:672:549c:15e8 with SMTP id
 15-20020a0562140dcf00b00672549c15e8mr32468533qvt.55.1699270929722; Mon, 06
 Nov 2023 03:42:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-15-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-15-pbonzini@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 6 Nov 2023 11:41:33 +0000
Message-ID: <CA+EHjTwJyiyUnQpMZedqBa1QVdURH4C0ZcJ1nUY7TmuMjppReg@mail.gmail.com>
Subject: Re: [PATCH 14/34] fs: Rename anon_inode_getfile_secure() and anon_inode_getfd_secure()
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 5, 2023 at 4:32=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> The call to the inode_init_security_anon() LSM hook is not the sole
> reason to use anon_inode_getfile_secure() or anon_inode_getfd_secure().
> For example, the functions also allow one to create a file with non-zero
> size, without needing a full-blown filesystem.  In this case, you don't
> need a "secure" version, just unique inodes; the current name of the
> functions is confusing and does not explain well the difference with
> the more "standard" anon_inode_getfile() and anon_inode_getfd().
>
> Of course, there is another side of the coin; neither io_uring nor
> userfaultfd strictly speaking need distinct inodes, and it is not
> that clear anymore that anon_inode_create_get{file,fd}() allow the LSM
> to intercept and block the inode's creation.  If one was so inclined,
> anon_inode_getfile_secure() and anon_inode_getfd_secure() could be kept,
> using the shared inode or a new one depending on CONFIG_SECURITY.
> However, this is probably overkill, and potentially a cause of bugs in
> different configurations.  Therefore, just add a comment to io_uring
> and userfaultfd explaining the choice of the function.
>
> While at it, remove the export for what is now anon_inode_create_getfd().
> There is no in-tree module that uses it, and the old name is gone anyway.
> If anybody actually needs the symbol, they can ask or they can just use
> anon_inode_create_getfile(), which will be exported very soon for use
> in KVM.
>
> Suggested-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  fs/anon_inodes.c            | 46 +++++++++++++++++++++++--------------
>  fs/userfaultfd.c            |  5 ++--
>  include/linux/anon_inodes.h |  4 ++--
>  io_uring/io_uring.c         |  3 ++-
>  4 files changed, 36 insertions(+), 22 deletions(-)
>
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index 24192a7667ed..3d4a27f8b4fe 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -79,7 +79,7 @@ static struct file *__anon_inode_getfile(const char *na=
me,
>                                          const struct file_operations *fo=
ps,
>                                          void *priv, int flags,
>                                          const struct inode *context_inod=
e,
> -                                        bool secure)
> +                                        bool make_inode)
>  {
>         struct inode *inode;
>         struct file *file;
> @@ -87,7 +87,7 @@ static struct file *__anon_inode_getfile(const char *na=
me,
>         if (fops->owner && !try_module_get(fops->owner))
>                 return ERR_PTR(-ENOENT);
>
> -       if (secure) {
> +       if (make_inode) {
>                 inode =3D anon_inode_make_secure_inode(name, context_inod=
e);
>                 if (IS_ERR(inode)) {
>                         file =3D ERR_CAST(inode);
> @@ -149,13 +149,10 @@ struct file *anon_inode_getfile(const char *name,
>  EXPORT_SYMBOL_GPL(anon_inode_getfile);
>
>  /**
> - * anon_inode_getfile_secure - Like anon_inode_getfile(), but creates a =
new
> + * anon_inode_create_getfile - Like anon_inode_getfile(), but creates a =
new
>   *                             !S_PRIVATE anon inode rather than reuse t=
he
>   *                             singleton anon inode and calls the
> - *                             inode_init_security_anon() LSM hook.  Thi=
s
> - *                             allows for both the inode to have its own
> - *                             security context and for the LSM to enfor=
ce
> - *                             policy on the inode's creation.
> + *                             inode_init_security_anon() LSM hook.
>   *
>   * @name:    [in]    name of the "class" of the new file
>   * @fops:    [in]    file operations for the new file
> @@ -164,11 +161,19 @@ EXPORT_SYMBOL_GPL(anon_inode_getfile);
>   * @context_inode:
>   *           [in]    the logical relationship with the new inode (option=
al)
>   *
> + * Create a new anonymous inode and file pair.  This can be done for two
> + * reasons:
> + * - for the inode to have its own security context, so that LSMs can en=
force
> + *   policy on the inode's creation;
> + * - if the caller needs a unique inode, for example in order to customi=
ze
> + *   the size returned by fstat()
> + *
>   * The LSM may use @context_inode in inode_init_security_anon(), but a
> - * reference to it is not held.  Returns the newly created file* or an e=
rror
> - * pointer.  See the anon_inode_getfile() documentation for more informa=
tion.
> + * reference to it is not held.
> + *
> + * Returns the newly created file* or an error pointer.
>   */
> -struct file *anon_inode_getfile_secure(const char *name,
> +struct file *anon_inode_create_getfile(const char *name,
>                                        const struct file_operations *fops=
,
>                                        void *priv, int flags,
>                                        const struct inode *context_inode)
> @@ -181,7 +186,7 @@ static int __anon_inode_getfd(const char *name,
>                               const struct file_operations *fops,
>                               void *priv, int flags,
>                               const struct inode *context_inode,
> -                             bool secure)
> +                             bool make_inode)
>  {
>         int error, fd;
>         struct file *file;
> @@ -192,7 +197,7 @@ static int __anon_inode_getfd(const char *name,
>         fd =3D error;
>
>         file =3D __anon_inode_getfile(name, fops, priv, flags, context_in=
ode,
> -                                   secure);
> +                                   make_inode);
>         if (IS_ERR(file)) {
>                 error =3D PTR_ERR(file);
>                 goto err_put_unused_fd;
> @@ -231,10 +236,9 @@ int anon_inode_getfd(const char *name, const struct =
file_operations *fops,
>  EXPORT_SYMBOL_GPL(anon_inode_getfd);
>
>  /**
> - * anon_inode_getfd_secure - Like anon_inode_getfd(), but creates a new
> + * anon_inode_create_getfd - Like anon_inode_getfd(), but creates a new
>   * !S_PRIVATE anon inode rather than reuse the singleton anon inode, and=
 calls
> - * the inode_init_security_anon() LSM hook. This allows the inode to hav=
e its
> - * own security context and for a LSM to reject creation of the inode.
> + * the inode_init_security_anon() LSM hook.
>   *
>   * @name:    [in]    name of the "class" of the new file
>   * @fops:    [in]    file operations for the new file
> @@ -243,16 +247,24 @@ EXPORT_SYMBOL_GPL(anon_inode_getfd);
>   * @context_inode:
>   *           [in]    the logical relationship with the new inode (option=
al)
>   *
> + * Create a new anonymous inode and file pair.  This can be done for two
> + * reasons:
> + * - for the inode to have its own security context, so that LSMs can en=
force
> + *   policy on the inode's creation;
> + * - if the caller needs a unique inode, for example in order to customi=
ze
> + *   the size returned by fstat()
> + *
>   * The LSM may use @context_inode in inode_init_security_anon(), but a
>   * reference to it is not held.
> + *
> + * Returns a newly created file descriptor or an error code.
>   */
> -int anon_inode_getfd_secure(const char *name, const struct file_operatio=
ns *fops,
> +int anon_inode_create_getfd(const char *name, const struct file_operatio=
ns *fops,
>                             void *priv, int flags,
>                             const struct inode *context_inode)
>  {
>         return __anon_inode_getfd(name, fops, priv, flags, context_inode,=
 true);
>  }
> -EXPORT_SYMBOL_GPL(anon_inode_getfd_secure);
>
>  static int __init anon_inode_init(void)
>  {
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 56eaae9dac1a..7a1cf8bab5eb 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1033,7 +1033,7 @@ static int resolve_userfault_fork(struct userfaultf=
d_ctx *new,
>  {
>         int fd;
>
> -       fd =3D anon_inode_getfd_secure("[userfaultfd]", &userfaultfd_fops=
, new,
> +       fd =3D anon_inode_create_getfd("[userfaultfd]", &userfaultfd_fops=
, new,
>                         O_RDONLY | (new->flags & UFFD_SHARED_FCNTL_FLAGS)=
, inode);
>         if (fd < 0)
>                 return fd;
> @@ -2205,7 +2205,8 @@ static int new_userfaultfd(int flags)
>         /* prevent the mm struct to be freed */
>         mmgrab(ctx->mm);
>
> -       fd =3D anon_inode_getfd_secure("[userfaultfd]", &userfaultfd_fops=
, ctx,
> +       /* Create a new inode so that the LSM can block the creation.  */
> +       fd =3D anon_inode_create_getfd("[userfaultfd]", &userfaultfd_fops=
, ctx,
>                         O_RDONLY | (flags & UFFD_SHARED_FCNTL_FLAGS), NUL=
L);
>         if (fd < 0) {
>                 mmdrop(ctx->mm);
> diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
> index 5deaddbd7927..93a5f16d03f3 100644
> --- a/include/linux/anon_inodes.h
> +++ b/include/linux/anon_inodes.h
> @@ -15,13 +15,13 @@ struct inode;
>  struct file *anon_inode_getfile(const char *name,
>                                 const struct file_operations *fops,
>                                 void *priv, int flags);
> -struct file *anon_inode_getfile_secure(const char *name,
> +struct file *anon_inode_create_getfile(const char *name,
>                                        const struct file_operations *fops=
,
>                                        void *priv, int flags,
>                                        const struct inode *context_inode)=
;
>  int anon_inode_getfd(const char *name, const struct file_operations *fop=
s,
>                      void *priv, int flags);
> -int anon_inode_getfd_secure(const char *name,
> +int anon_inode_create_getfd(const char *name,
>                             const struct file_operations *fops,
>                             void *priv, int flags,
>                             const struct inode *context_inode);
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 8d1bc6cdfe71..22b98f47bb28 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3835,7 +3835,8 @@ static struct file *io_uring_get_file(struct io_rin=
g_ctx *ctx)
>                 return ERR_PTR(ret);
>  #endif
>
> -       file =3D anon_inode_getfile_secure("[io_uring]", &io_uring_fops, =
ctx,
> +       /* Create a new inode so that the LSM can block the creation.  */
> +       file =3D anon_inode_create_getfile("[io_uring]", &io_uring_fops, =
ctx,
>                                          O_RDWR | O_CLOEXEC, NULL);
>  #if defined(CONFIG_UNIX)
>         if (IS_ERR(file)) {
> --
> 2.39.1
>
>
