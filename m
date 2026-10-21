Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792603079;
	b=A2v09I28ylGlrvAMZ+fejEulk/sez98CcQ6u/oXM+yU59K/uQ7Gpl5iThLoMquvZk3qE
	 LQ4AbRbeIjCcuXGj97V5knnGPeixK1WNTMXJBImMvZCLWhSY00Yw3/3T0uU+dl7d2bMz8
	 spWmRFKyh1OWiW8iDK5EO6nS+s+CtuVu7DFGlgTGY5JI8Jae1UqslUpSRrbiZisO2Saht
	 OdtjyocjV439X1/rGUPZ8MEL6jcj1ZYnZCj9jb8qmhCPswVMquoUACOuwdwdgv/5XfzW1
	 CRkQgX1HLwQ0Hav03/lHjEPi5s3PqF/e7u2yK6K8KHUMbol2QY9ydXSi6V9P8lqblsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792603079;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
	b=v6S6kBq+PvPGxIgz3A04UtTa1+cKyRjHZ6SOdqh0Cwqo8//iHObHvsXrZ4glICPAbUw4
	 TrzjH8FkBp8y5FDUVT2bgM6PZJmBI0d87P/TqSPdl75ME+evjXvgCuCh4eToBYPaDgKln
	 IIadrbMPzy2UZYOYBIR/uggq1+8BPKUVbdBT5DsnZsQ1leW7JwGzDN8DEVcBzMF5Pjdx1
	 6E1F3TV94YuuDAFkIeLboJtZHy+jbLKIQTK5Pg+fJ/dXF+CDMPQbP2SKjdGxPpea3g0y5
	 7tSGwhTUF58uNfpSsFBxT5KV0YAl2S6nEkBboaVAYppxZ/Ub1D5TyZF7YZe31V+6O2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=g12Tkn3T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C301606A31A
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 17:17:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C301606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=g12Tkn3T
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c3fd91337baso138587666b.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 10:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792603077; cv=none;
        d=google.com; s=arc-20260327;
        b=HldBcuSTD/Q6Mhz9mkpm3BKKcXQh8E6JXsbTrtn/LZ1WRiWfPSXMH39PEGfKPqvpvT
         jSpjQDQEHhD0DTv9egIe2UmsWrlz/PRn4dQEllg3TaJy5zAjzwadLJprFDJE41XtOn2v
         keeu65+21RVPyoZfDBbmr1uNJy6iDYmJksrc7cthMzst8jsjdesnTJDwGVyazf7R8dqG
         jzYv5Ro0LMzj0L7lG7D4uPwYOFr/2ctkBU3YBQJzwF59K/MI9F2ekTD/cnm8oGVKwxbR
         bvFJmWiyu+dhDJ0Lf/hWryBZ1nCKtX5+0FKp9DuFy1RdCfAdjkea06OnmEAPt44cXW3K
         Xbdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
        fh=W5Yz0O5w3qECeoybKwNo2o1vA2tDk8PPwiacAr31MQs=;
        b=JQn1hz/pMSITJ1QbQYnF6qOnQ0vrBftNYqH7wtnSTx7HeiCqoMQxqg18Yf8sRsh2u+
         n31ZxRQZbf2JWd6HLdHdlonwwRM4GuD2CDg9+YbR4VfJT6dTHUHfb3fs2GtomUfJV/qt
         nY5hdCl1ccyJFa+ilB70eQ8EemR5ZOSJX3v4aZ22mUU69ka+/2xMbz0Sb+IYtbKxOVfs
         t//Q5G1WTb5HOehJhJzdvDXyV3MlCVTpBtDTALTCaMv3BK9oUB2lAMCwt3LebRdXX8b9
         FdzQNMWbIOS2arnUvVzQQL3AuF38+eH7kNHualIrdgsLl9fzVK0fmIFkVLK9WDZkPpNB
         1uhw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792603077; x=1793207877; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
        b=g12Tkn3Ta1gTWf3sdSu3duMy7egupVtdcyYPHm3pgGccNeeCq+vbVuxvysJASDqyiR
         kXLm2RNjwzztkQREZUjNZTLJ9nj1GKM/N8vvnxkfJ7bQPX1LSzrwQmyT/DLiuqNIHwTo
         u5AcxQhBgMx3rhBtSstcrYYAKHRB4cjGuGjvUH7+vGTpOk77lP/j/eOAvPV+QImmsqAx
         /x2uQvUOGG8xI+/8XY9dMzZjvMvXq1Mzssk/mAromT8s+X5b2A6WvHioWI2gg65zlV5J
         58gMII83riQzdGlk+ANEaRYdYHpIycGvpYkIMBYIwBdcxifPfBovYyvqMNfhg+La03Q9
         b7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792603077; x=1793207877;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
        b=Zig3IKR87rGYWZqQzzeXKM/6+mCTKpHNaMvmQVv1MX7z1Fg74/q4FGjeUoHrnQXgQU
         Spe3nrE/aiV3JPanU77LsHY5T3WlkihDljNL67L9Jyx94Z0uDyPmHORGlPZVfUhWNkBm
         XM7nZ0ZlfUmEXm2YFonGfgiT/gwW6n1rkSbCx1jB712reTNX1X5J797jM0q9PGX/Fusw
         nAx/kPQGKWF21gOhyBeBIMo2SUB3m/7m/zXaGuewWTXRcOb8dwyKCkUtsCez0XDUGS7B
         yu1gsoZ1roJVWgY+hef2AhHE5/7QZkikjjDN65m6jdKwFtcrbZ8UK22NuhYrsJgr7n2s
         H/PA==
X-Forwarded-Encrypted: i=1; AKwUvBw6Gs7i42UIuHXseCqcnifo7nvBHUxzqYv6dVh9x8vTVQTjwR4cAHhQ/JDnw4Tld8DezX6oVwM=@lists.linux.dev
X-Gm-Message-State: AFq9FYKvEFPwYoP3u/5M4enLwLz4gFQtl+nxe9kduNRh/muWgjYw+blH
	tTvkttBo1QclwMQM7g+BUyF6v1ef1vnV88m+z95wPSnxBa+vmOmtLLgx+OgaqfK50osxmABOg3E
	CFp1ojBug2L4w8bv+lK7Mg96Vp3hFgVewRWsoDOmUOQ==
X-Gm-Gg: AYBFou2YM8vcf6FAABJ0YYp95IMrRTYM1qwO/m1WYNAb3pF8R3cQ2dAix49gl3l4BoE
	ccjJQdGGegbK8MQ4/QhzTJAIOaHi4CsXrffADRYwjE7YYgAT9swopu7PmetEYYhPMVrF4wZZXr9
	m9B8vKkiTzkuZKhdQ2Zak1JQPibgBfvXDdK23lxt5XcmiNJzvOeYAGupKHPZFFYiI2+bCyFeA9a
	Cj6xdlvRj6Zf/BHRkB7lsaNUP+EZiac3SpZeTaCJvnMrpHAA6A/Kk5YQMWzFNfuCSwXOuacRnGl
	dyXTZpWhvIonAd2sE8q5G2a8S0DLY+gBDGAGYJA7nI17AuaDLe+q8HglvS6zJ5mcWcHC2SEP4qL
	R9LzyI+G4fo264Xl6wjLe5aFrfMPehHlM+/JEerTkImeZ6e5/qJpTjwelyAbNZSQo6cM=
X-Received: by 2002:a17:906:f597:b0:c3e:f39b:2286 with SMTP id
 a640c23a62f3a-c4678f7c6cemr225893866b.0.1792603076743; Wed, 21 Oct 2026
 10:17:56 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-3-tarunsahu@google.com>
In-Reply-To: <20261021152527.375070-3-tarunsahu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:17:19 -0400
X-Gm-Features: AclHuK-IkiswuL9j-om2-Yvi6ZhWxvxntziJi6QKVuLB1ELR4YcI0vWO7hzjpeA
Message-ID: <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in the
 preserve ioctl
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.com> =
wrote:
>
> Currently luo_preserve_file() iterates over luo_file_handler_list and
> picks the first registered handler whose .can_preserve() callback
> returns true. When a subsystem introduces a new, backwards-incompatible
> file handler alongside an existing one for the same file type, userspace
> has no way to choose which handler preserves a file descriptor, nor can
> the kernel keep the existing rollback-safe handler as the default while
> allowing callers to opt into the new handler.

That is not how it will work. If we are in the .can_preserve() call,
it means the user has already decided which file handlers to use. We
need to do that before any preservation happens; otherwise, we could
run into conflicts on FLBs i.e. FH of different version require
different FLBs.

Therefore, there should be a luoctl call (i.e via a new ioctl to set
compatability) that provides the kernel with the specs file of the
target kernel we are updating to, allowing the kernel to select the
compatible file handlers. Since .can_preserve() is called when the
user is already preserving files, the specification must have already
been supplied, or the kernel should fall back to using the default
(i.e., latest) file handlers.

>
> Append char handler[LIVEUPDATE_HNDL_NAME_LENGTH] to struct
> liveupdate_session_preserve_fd immediately after token, keeping
> IOCTL_OP min_size at offsetofend(..., token) so callers passing the
> original 16-byte structure continue to work:
> - When handler is empty (all-zero, or zero-filled when userspace
>   passes the 16-byte structure), luo_preserve_file() selects the first
>   registered handler whose .can_preserve() callback accepts the fd.
> - When handler is non-empty, it must be null-terminated within
>   LIVEUPDATE_HNDL_NAME_LENGTH bytes (returning -EINVAL otherwise);
>   luo_preserve_file() looks up the registered handler with that exact
>   name (returning -ENOENT if unknown) and verifies that its
>   .can_preserve() callback accepts the fd (returning -EINVAL if not).
>
> The retrieve ioctl is unchanged because the handler is identified by the
> name stored in the serialized payload from the source kernel.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/uapi/linux/liveupdate.h  | 12 +++++++++---
>  kernel/liveupdate/luo_file.c     | 21 ++++++++++++++++++---
>  kernel/liveupdate/luo_internal.h |  3 ++-
>  kernel/liveupdate/luo_session.c  |  7 ++++++-
>  4 files changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupd=
ate.h
> index 509c6236720d..2413b19dabc1 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -126,9 +126,14 @@ struct liveupdate_ioctl_retrieve_session {
>
>  /**
>   * struct liveupdate_session_preserve_fd - ioctl(LIVEUPDATE_SESSION_PRES=
ERVE_FD)
> - * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
> - * @fd:    Input; The user-space file descriptor to be preserved.
> - * @token: Input; An opaque, unique token for preserved resource.
> + * @size:    Input; sizeof(struct liveupdate_session_preserve_fd)
> + * @fd:      Input; The user-space file descriptor to be preserved.
> + * @token:   Input; An opaque, unique token for preserved resource.
> + * @handler: Input; Optional null-terminated file handler name (max leng=
th
> + *           %LIVEUPDATE_HNDL_NAME_LENGTH including null terminator) sel=
ecting
> + *           which registered handler preserves @fd. If empty (all-zero,=
 or
> + *           omitted when passing the 16-byte structure), the kernel sel=
ects
> + *           the first registered handler whose .can_preserve() accepts =
@fd.
>   *
>   * Holds parameters for preserving a file descriptor.
>   *
> @@ -152,6 +157,7 @@ struct liveupdate_session_preserve_fd {
>         __u32           size;
>         __s32           fd;
>         __aligned_u64   token;
> +       char            handler[LIVEUPDATE_HNDL_NAME_LENGTH];
>  };
>
>  #define LIVEUPDATE_SESSION_PRESERVE_FD                                 \
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index fb81239bedf3..be20e0f1e0aa 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -207,6 +207,8 @@ static bool luo_token_is_used(struct luo_file_set *fi=
le_set, u64 token)
>   * @file_set: The file_set to which the preserved file will be added.
>   * @token:    A unique, user-provided identifier for the file.
>   * @fd:       The file descriptor to be preserved.
> + * @handler:  Optional NUL-terminated handler name. If NULL or empty, th=
e first
> + *            registered handler whose .can_preserve() accepts @fd is se=
lected.
>   *
>   * This function orchestrates the first phase of preserving a file. Upon=
 entry,
>   * it takes a reference to the 'struct file' via fget(), effectively mak=
ing LUO
> @@ -238,11 +240,13 @@ static bool luo_token_is_used(struct luo_file_set *=
file_set, u64 token)
>   *         -EBUSY if the file descriptor is already preserved by another=
 session.
>   *         -EBADF if the file descriptor is invalid.
>   *         -ENOSPC if the file_set is full.
> - *         -ENOENT if no compatible handler is found for the file type.
> + *         -ENOENT if no matching handler is registered or accepts @fd.
> + *         -EINVAL if the named handler cannot preserve @fd.
>   *         -ENOMEM on memory allocation failure.
>   *         Other erros might be returned by .preserve().
>   */
> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
> +                     const char *handler)
>  {
>         struct liveupdate_file_op_args args =3D {0};
>         struct liveupdate_file_handler *fh;
> @@ -266,6 +270,18 @@ int luo_preserve_file(struct luo_file_set *file_set,=
 u64 token, int fd)
>         err =3D -ENOENT;
>         down_read(&luo_register_rwlock);
>         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> +               if (handler && handler[0]) {
> +                       if (strcmp(fh->name, handler))
> +                               continue;
> +                       if (!fh->ops->can_preserve(fh, file)) {
> +                               err =3D -EINVAL;
> +                               break;
> +                       }
> +                       if (try_module_get(fh->ops->owner))
> +                               err =3D 0;
> +                       break;
> +               }
> +
>                 if (fh->ops->can_preserve(fh, file)) {
>                         if (try_module_get(fh->ops->owner))
>                                 err =3D 0;
> @@ -274,7 +290,6 @@ int luo_preserve_file(struct luo_file_set *file_set, =
u64 token, int fd)
>         }
>         up_read(&luo_register_rwlock);
>
> -       /* err is still -ENOENT if no handler was found */
>         if (err)
>                 goto err_fput;
>
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_int=
ernal.h
> index dac6644bfb18..911ffedec9f3 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -101,7 +101,8 @@ int __init luo_session_setup_incoming(u64 sessions_pa=
);
>  int luo_session_serialize(void);
>  int luo_session_deserialize(void);
>
> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
> +                     const char *handler);
>  void luo_file_unpreserve_files(struct luo_file_set *file_set);
>  int luo_file_freeze(struct luo_file_set *file_set,
>                     struct luo_file_set_ser *file_set_ser);
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index f48e9a4185f9..194ef45907c1 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -266,8 +266,13 @@ static int luo_session_preserve_fd(struct luo_sessio=
n *session,
>         struct liveupdate_session_preserve_fd *argp =3D ucmd->cmd;
>         int err;
>
> +       if (strnlen(argp->handler, sizeof(argp->handler)) =3D=3D
> +           sizeof(argp->handler))
> +               return -EINVAL;
> +
>         guard(mutex)(&session->mutex);
> -       err =3D luo_preserve_file(&session->file_set, argp->token, argp->=
fd);
> +       err =3D luo_preserve_file(&session->file_set, argp->token, argp->=
fd,
> +                               argp->handler);
>         if (err)
>                 return err;
>
> --
> 2.56.0.212.g129ede20d9-goog
>
