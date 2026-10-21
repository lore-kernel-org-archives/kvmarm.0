Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602716;
	b=PjnKgVqD4sQT5u2AtxTnfN6bsr/vyCkkbOs58lNnqFnIIf50etG14k2/0H6BPQv9oFDG
	 wNCfDoMAV1BQccu5hB+DoRdtG0O3tft+hDycUuZ84iLlCm3mhFZ/xbjL8NZBYzzNI7LcQ
	 7ub2jwf9V9QFfdshsZAoswRD150MiifBhFa6qUgehVR8XHXm3zZBlECs4OBPUflwPujS7
	 z9sU2wxFT14TWt6+VOD70Z+vcY78buYnannsLuytP3eyF79XrkKPqZD9ey1oNke4w8Al3
	 RSTKikDMycue68qdMwpFNOETKSBuJTyip6NCFL4FE2zFXvwIL266nfz2zLviLVNh8Cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602716;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0dZmwG2qXYFHvXS2nyFYmhn57US6TkC0O+xVZVFMFkQ=;
	b=g3aRL5s8xrS/X2XjoUbTejcU15YuhwnJUkwGx1tFkhr0HNXAwRCom7Tw/EleitElIejX
	 u0n+4toUNUdVatoNnfcmvzncNThAgDmucc+z+acB5Br2w/0pENpALyn0pcU1lfUWGO2+u
	 9kbBvXKGLElXgGLz+tMVQyXtB6kk5lu78mQpbZBJKIs5mR44J57zlaoYQ23Ig6LYKXK9C
	 SXqzp2X+Ma0neeXlwgXOoLe5F2uD9HUcxh1S8TA7ZG3PQEeGPuqNmOVHTfQFeoQWvlYEO
	 DWil1fP9GKzPlZI3RZ7+YvhKr+j+HZG2myAfxsbAAj/3hrOx9wxRMrOqndLAoGYGE7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=huCRQsoQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F50B60A2616
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 17:11:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F50B60A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=huCRQsoQ
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b1aa4d71e7so1073348a12.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 10:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792602713; cv=none;
        d=google.com; s=arc-20260327;
        b=OiNfgs/7CmcwBDmujZiQpvJcY1ZXNqHPP9S8RJ/tjiu2MfWz5GutAwAW1qeaCRWpPf
         Wtz2k/BorgvrE1bznBUhySK9RpYSzFnJZKjz+bYd9xMfPFI35uobwuqpSVmv21iL9NHZ
         fBRETFsR4T8NSNVxja6USwfWf58Dj00j2EVXNY/cDB5uocXgqWE7uzhAObVGpCxIVc4N
         uG0UXf7AMOWcVUDNsZwIWp/HVxp32OYdJZhJyrTPqa9wdULVnI3vkzpkjMEM2vvWuOak
         0Rc6sf1SdLy1gPfO7gqumrTzdGveGQgOdy5ufF/nHyuH8s1jTuwZqX78c+s6ncC9fI+U
         JXeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0dZmwG2qXYFHvXS2nyFYmhn57US6TkC0O+xVZVFMFkQ=;
        fh=pUriMOnDJPHhQPeahu6UOLbrgkBtJJOUfFCMsp0UyH4=;
        b=GG/QX1TBewd8KZj7Cn3kYeRRU8RP+dsaK05b23wqlXMBHALQsSFIUvhTqpJKUwqHjG
         ml5vr9QDH2+3lnHW2qlMKY3eMC1FKuaiSjE8q1KLe35cKR/29DxkSAI9qSb9xk9UuMP4
         9S8pKe24Kvi9m5+BOdUx3DfhSm28re7L0m9ZeilDPx2nZZCydt5Pvi9L61JHV0U/qfmE
         sVofgiaT00sBaPO3AaHEjPM1N4ibaZBqvKEFY8xW2B8veQmRroLlq9c8XKHRs6ACQ8BE
         fBgLw2BMmboKcVgMoXW4V0IZ96+eM2jtmj/1BNtfkbP2OSPTpEfUc9zBeMIo51pjRSdy
         6BZw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792602713; x=1793207513; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0dZmwG2qXYFHvXS2nyFYmhn57US6TkC0O+xVZVFMFkQ=;
        b=huCRQsoQxyPq8OF0GKBDV0W4th2r2nnndWZLqWa7twbxMR185J9e6YZu+VFTdSnofp
         bcIgcLVO9KiJR9KOYYKX8VvVwRrG4zKrIR02aqXS1AP5ZazjqAttjNbbY2Mh/ox3OoLt
         46TzsIr016a61n1USK3f3K+asAcs3ta1tDxeP3rw1/jfvb6m2irHGqQd9qjrnkPnxIEw
         0fb3h7fkFFtuxZuskFfyGSnLaxvJv7cVFSNHo7Wgd5LCEnioHGLlEpJDAhLS8oBfDLpT
         tW8piv9JcLBv0ap3XPJGf32KWX6iwYCy8DVosr2gaMOgmQNCLgqq+iRXJF3CXwLlSN7K
         MYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792602713; x=1793207513;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0dZmwG2qXYFHvXS2nyFYmhn57US6TkC0O+xVZVFMFkQ=;
        b=OzUEVrEwVjBj+EbSOLBuV5BZxwCj55UuChLrDufQWjb4z+gdk78Z2fNcVcqZQzp+F/
         fwY/0v3ifvnrBIFhHIZk/nEYFzGs82hf3igKq17ztxEfOVjLGiXNhN3NeALKS8XxHn4d
         H3h0Y0oOBlJg52r2r2Ist9jDqydq3+rBpifHsufqd0FStfq0aZTVhJefHPJrI21doD4+
         jDP0qUI203f0e3cFI9o17HbycK0jzjU5VjkaILJEQOKew8mEj/xea45Nl0iqe9YPxsNe
         tgPrdP2yfQUv6fcvEndMT3+Qtk3VeNoWDjl/UC6adYJgUmGHH5upPqAjPN6r7hXVNGB2
         MfHA==
X-Forwarded-Encrypted: i=1; AKwUvByq5//t8EYaFImxJgoUFOtJRYN3R435DStnA9d/afV1ZXiTOAN6bowEZZLak6nu+sIU/rzqjX4=@lists.linux.dev
X-Gm-Message-State: AFq9FYJPUQ7pto60R6j4tXRCJFBZnWJJop3ZejgBacENrdDWHB+tJFbq
	qTjI8jQm12/Fe6lo3OiNA8ve9rE11Bc86g4FpSx55ppc3Mhk1DK+lIgSPYEuPj4ZFS/jxXDJOoc
	CCKdP8vx0KsDHSXnWPV5lYQHOEdNeQ6cqjLPNwaLKQg==
X-Gm-Gg: AYBFou1dqvT20/a+zU7oZk7D3fH2dp0uLOKYfY1hOtrxuXkyAhTNMmKD0/eun8Bsn9f
	LVXWrQPb5YHImuleOODkSmEZ5gmQ3JPooQVBPMcpEN23dCE43jGFmb4R2Dy0uW2pXJjnPRzlb7L
	hIrNxaYEFNb2vD39WS120PGcAINhmGr3lIANlEjnkGWKzXAtI+fBgGxhVkeZyLzumQqOphj57vH
	XYfK4Emi1TgNMUrne9KAeW5gNfiXtAzFGmWRFbvXnyQw28Rz/hA3MGVqoCmlNWbEodcvZNgJ05c
	/UG5Jrx0mHj/sXJlmW89AKo4s7HrZV9b+b52z+kFEnMDae9DKcFqO57Bkl+zOvwThzLtf0MwRms
	D32o/ADsRl2lZbsFMYXZlvjNxjHqWDHWyPEFicxjl+BNJTvhdg97AyXIF0pB+SmfMEQ4=
X-Received: by 2002:a05:6402:4605:b0:6b3:cfe7:e63b with SMTP id
 4fb4d7f45d1cf-6b408e9ed02mr1698255a12.18.1792602713236; Wed, 21 Oct 2026
 10:11:53 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-2-tarunsahu@google.com>
In-Reply-To: <20261021152527.375070-2-tarunsahu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:11:15 -0400
X-Gm-Features: AclHuK8TU_9QorqKwdB1IiAEe43iCDvX4K6RbayRIdBi-vUMyoLzY8HFCe80BmI
Message-ID: <CA+CK2bC_wc4LxvHe0TREbBP7esYW3pcMNtkGK-kqvf6MyvOh2g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] liveupdate: Rename handler compatible to name
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
> File handler and File-Lifecycle-Bound (FLB) identifiers name the

Please use FLB directly, no need to spell it out.

> registered handler or FLB rather than a monolithic compatibility version.
> Rename compatible to name across LUO headers, structures, and consumers:
> - struct liveupdate_file_handler and struct luo_file_ser name field
> - LIVEUPDATE_HNDL_NAME_LENGTH (in include/uapi/linux/liveupdate.h) and
>   MEMFD_LUO_FH_NAME
> - struct liveupdate_flb name field, LIVEUPDATE_FLB_NAME_LENGTH,
>   PCI_LUO_FLB_NAME, and LIVEUPDATE_TEST_FLB_NAME
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  drivers/pci/liveupdate.c        | 10 ++++----
>  include/linux/kho/abi/luo.h     | 26 +++++++++----------
>  include/linux/kho/abi/memfd.h   |  4 +--
>  include/linux/kho/abi/pci.h     |  2 +-
>  include/linux/liveupdate.h      | 18 +++++--------
>  include/uapi/linux/liveupdate.h |  3 +++
>  kernel/liveupdate/luo_file.c    | 45 +++++++++++++++++----------------
>  kernel/liveupdate/luo_flb.c     | 16 ++++++------
>  lib/tests/liveupdate.c          | 22 ++++++++--------
>  mm/memfd_luo.c                  |  2 +-
>  10 files changed, 73 insertions(+), 75 deletions(-)
>
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 51695782ed42..3cf01d7d615c 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -424,7 +424,7 @@ static struct liveupdate_flb_ops pci_liveupdate_flb_o=
ps =3D {
>
>  static struct liveupdate_flb pci_liveupdate_flb =3D {
>         .ops =3D &pci_liveupdate_flb_ops,
> -       .compatible =3D PCI_LUO_FLB_COMPATIBLE,
> +       .name =3D PCI_LUO_FLB_NAME,
>  };
>
>  static void pci_liveupdate_flb_put_outgoing(void)
> @@ -667,13 +667,13 @@ static struct pci_flb_incoming *pci_liveupdate_flb_=
get_incoming(void)
>
>         /*
>          * Live Update is enabled and there is incoming FLB data, but non=
e of it
> -        * matches pci_liveupdate_flb.compatible.
> +        * matches pci_liveupdate_flb.name.
>          */
>         if (ret =3D=3D -ENOENT)
>                 return NULL;
>
>         /*
> -        * There is incoming FLB data that matches pci_liveupdate_flb.com=
patible
> +        * There is incoming FLB data that matches pci_liveupdate_flb.nam=
e
>          * but retrieve failed (pci_flb_retrieve() returned an error or L=
UO
>          * failed to acquire a reference to pci_liveupdate_flb_ops.owner)=
.
>          */
> @@ -998,7 +998,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
>   */
>  int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
>  {
> -       pr_debug("Registering file handler \"%s\"\n", fh->compatible);
> +       pr_debug("Registering file handler \"%s\"\n", fh->name);
>         return liveupdate_register_flb(fh, &pci_liveupdate_flb);
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> @@ -1009,7 +1009,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
>   */
>  void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
>  {
> -       pr_debug("Unregistering file handler \"%s\"\n", fh->compatible);
> +       pr_debug("Unregistering file handler \"%s\"\n", fh->name);
>         liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 288076de6d4a..5fb2f46425d7 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -39,9 +39,9 @@
>   *     Multiple blocks are linked via the `next` field in the header.
>   *
>   *   - struct luo_file_ser:
> - *     Metadata for a single preserved file. Contains the `compatible` s=
tring to
> - *     find the correct handler in the new kernel, a user-provided `toke=
n` for
> - *     identification, and an opaque `data` handle for the handler to us=
e.
> + *     Metadata for a single preserved file. Contains the handler `name`=
 string
> + *     to find the correct handler in the new kernel, a user-provided `t=
oken`
> + *     for identification, and an opaque `data` handle for the handler t=
o use.
>   *
>   *   - struct luo_flb_header_ser:
>   *     Header for the FLB array. Contains the total page count of the
> @@ -49,9 +49,9 @@
>   *     that follow.
>   *
>   *   - struct luo_flb_ser:
> - *     Metadata for a single preserved global object. Contains its `name=
`
> - *     (compatible string), an opaque `data` handle, and the `count`
> - *     number of files depending on it.
> + *     Metadata for a single preserved global object. Contains its FLB `=
name`
> + *     string, an opaque `data` handle, and the `count` number of files
> + *     depending on it.
>   */
>
>  #ifndef _LINUX_KHO_ABI_LUO_H
> @@ -84,18 +84,16 @@ struct luo_ser {
>         u64 flbs_pa;
>  } __packed;
>
> -#define LIVEUPDATE_HNDL_COMPAT_LENGTH  48
> -
>  /**
>   * struct luo_file_ser - Represents the serialized preserves files.
> - * @compatible:  File handler compatible string.
> + * @name:        File handler name string.

We are renaming from cpmaptible to name; I am not sure that is
necessary. We can still use compatible for the same purpose as name.
Unless it really bothers people, but for me 'compatible' works just
the same.

>   * @data:        Private data
>   * @token:       User provided token for this file
>   *
>   * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_file_ser {
> -       char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> +       char name[LIVEUPDATE_HNDL_NAME_LENGTH];
>         u64 data;
>         u64 token;
>  } __packed;
> @@ -134,7 +132,7 @@ struct luo_session_ser {
>  } __packed;

Unreleated to this patch, but should be handled by this work, let's
remove all the '__packed' attributes, the are not needed, we will
explicitly fill in all the holes, with reserved fields.

>
>  /* The max size is set so it can be reliably used during in serializatio=
n */
> -#define LIVEUPDATE_FLB_COMPAT_LENGTH   48
> +#define LIVEUPDATE_FLB_NAME_LENGTH     48
>
>  /**
>   * struct luo_flb_header_ser - Header for the serialized FLB data block.
> @@ -156,7 +154,7 @@ struct luo_flb_header_ser {
>
>  /**
>   * struct luo_flb_ser - Represents the serialized state of a single FLB =
object.
> - * @name:    The unique compatibility string of the FLB object, used to =
find the
> + * @name:    The unique name string of the FLB object, used to find the
>   *           corresponding &struct liveupdate_flb handler in the new ker=
nel.
>   * @data:    The opaque u64 handle returned by the FLB's .preserve() ope=
ration
>   *           in the old kernel. This handle encapsulates the entire stat=
e needed
> @@ -172,14 +170,14 @@ struct luo_flb_header_ser {
>   * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_flb_ser {
> -       char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
> +       char name[LIVEUPDATE_FLB_NAME_LENGTH];
>         u64 data;
>         u64 count;
>  } __packed;
>
>  /* Kernel Live Update Test ABI */
>  #ifdef CONFIG_LIVEUPDATE_TEST
> -#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)      "liveupdate-test-flb-v" #=
i
> +#define LIVEUPDATE_TEST_FLB_NAME(i)    "liveupdate-test-flb-v" #i
>  #endif
>
>  #endif /* _LINUX_KHO_ABI_LUO_H */
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.=
h
> index 08b10fea2afc..371ffd108a79 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -87,7 +87,7 @@ struct memfd_luo_ser {
>         struct kho_vmalloc folios;
>  } __packed;
>
> -/* The compatibility string for memfd file handler */
> -#define MEMFD_LUO_FH_COMPATIBLE        "memfd-v2"
> +/* The name string for memfd file handler */
> +#define MEMFD_LUO_FH_NAME      "memfd-v2"
>
>  #endif /* _LINUX_KHO_ABI_MEMFD_H */
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> index 9485ed73c351..973ca5b26dbd 100644
> --- a/include/linux/kho/abi/pci.h
> +++ b/include/linux/kho/abi/pci.h
> @@ -23,7 +23,7 @@
>   * incrementing the version number in the PCI_LUO_FLB_VERSION number.
>   */
>
> -#define PCI_LUO_FLB_COMPATIBLE "pci"
> +#define PCI_LUO_FLB_NAME "pci"
>  #define PCI_LUO_FLB_VERSION 2
>
>  /**
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 6051abc0612c..475da5fc22ee 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -90,10 +90,8 @@ struct liveupdate_file_ops {
>  /**
>   * struct liveupdate_file_handler - Represents a handler for a live-upda=
table file type.
>   * @ops:                Callback functions
> - * @compatible:         The compatibility string (e.g., "memfd-v1", "vfi=
ofd-v1")
> - *                      that uniquely identifies the file type this hand=
ler
> - *                      supports. This is matched against the compatible=
 string
> - *                      associated with individual &struct file instance=
s.
> + * @name:               Unique handler name string (e.g., "memfd-v2"), m=
atched
> + *                      against &struct luo_file_ser.name in the target =
kernel.
>   *
>   * Modules that want to support live update for specific file types shou=
ld
>   * register an instance of this structure. LUO uses this registration to
> @@ -102,7 +100,7 @@ struct liveupdate_file_ops {
>   */
>  struct liveupdate_file_handler {
>         const struct liveupdate_file_ops *ops;
> -       const char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> +       const char name[LIVEUPDATE_HNDL_NAME_LENGTH];
>
>         /* private: */
>
> @@ -209,11 +207,9 @@ struct luo_flb_private {
>  /**
>   * struct liveupdate_flb - A global definition for a shared data object.
>   * @ops:         Callback functions
> - * @compatible:  The compatibility string (e.g., "iommu-core-v1"
> - *               that uniquely identifies the FLB type this handler
> - *               supports. This is matched against the compatible string
> - *               associated with individual &struct liveupdate_flb
> - *               instances.
> + * @name:        The FLB name string (e.g., "iommu-core-v1") that unique=
ly
> + *               identifies this FLB type. In the target kernel, it is
> + *               matched against the name stored in &struct luo_flb_ser.
>   *
>   * This struct is the "template" that a driver registers to define a sha=
red,
>   * file-lifecycle-bound object. The actual runtime state (the live objec=
t,
> @@ -221,7 +217,7 @@ struct luo_flb_private {
>   */
>  struct liveupdate_flb {
>         const struct liveupdate_flb_ops *ops;
> -       const char compatible[LIVEUPDATE_FLB_COMPAT_LENGTH];
> +       const char name[LIVEUPDATE_FLB_NAME_LENGTH];
>
>         /* private: */
>         struct luo_flb_private __private private;
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupd=
ate.h
> index 4043d4038712..509c6236720d 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -46,6 +46,9 @@
>  /* The maximum length of session name including null termination */
>  #define LIVEUPDATE_SESSION_NAME_LENGTH 64
>
> +/* The maximum length of file handler name including null termination */
> +#define LIVEUPDATE_HNDL_NAME_LENGTH 48
> +
>  /* The /dev/liveupdate ioctl commands */
>  enum {
>         LIVEUPDATE_CMD_BASE =3D 0x00,
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a39992da504f..fb81239bedf3 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -50,7 +50,7 @@
>   *
>   * 2. Freeze (Pre-Reboot): Just before the kexec, luo_file_freeze() is c=
alled.
>   *    It iterates through all preserved files, calls their respective .f=
reeze()
> - *    operation, and serializes their final metadata (compatible string,=
 token,
> + *    operation, and serializes their final metadata (handler name, toke=
n,
>   *    and data handle) into a contiguous memory block for KHO.
>   *
>   * 3. Deserialize: After kexec, luo_file_deserialize() runs when session=
 gets
> @@ -220,7 +220,7 @@ static bool luo_token_is_used(struct luo_file_set *fi=
le_set, u64 token)
>   * 1. Validates that the @token is not already in use within the file_se=
t.
>   * 2. Ensures the file_set's memory for files serialization is allocated
>   *    (allocates if needed).
> - * 3. Iterates through registered handlers, calling can_preserve() to fi=
nd one
> + * 3. Iterates through registered handlers, calling .can_preserve() to f=
ind one
>   *    compatible with the given @fd.
>   * 4. Calls the handler's .preserve() operation, which saves the file's =
state
>   *    and returns an opaque private data handle.
> @@ -238,7 +238,7 @@ static bool luo_token_is_used(struct luo_file_set *fi=
le_set, u64 token)
>   *         -EBUSY if the file descriptor is already preserved by another=
 session.
>   *         -EBADF if the file descriptor is invalid.
>   *         -ENOSPC if the file_set is full.
> - *         -ENOENT if no compatible handler is found.
> + *         -ENOENT if no compatible handler is found for the file type.
>   *         -ENOMEM on memory allocation failure.
>   *         Other erros might be returned by .preserve().
>   */
> @@ -456,9 +456,10 @@ static void __luo_file_unfreeze(struct luo_file_set =
*file_set,
>   *    private data handle during this step.
>   *
>   * 2. Serializes Metadata: After a successful freeze, it copies the fina=
l file
> - *    metadata=E2=80=94the handler's compatible string, the user token, =
and the final
> - *    private data handle=E2=80=94into the pre-allocated contiguous memo=
ry buffer
> - *    (file_set->files) that will be handed over to the next kernel via =
KHO.
> + *    metadata - the handler's name string, the user token, and the fina=
l
> + *    private data handle - into the pre-allocated contiguous memory buf=
fer
> + *    (file_set->files) that will be handed over to the target kernel vi=
a
> + *    KHO.
>   *
>   * Error Handling (Rollback):
>   * This function is atomic. If any handler's .freeze() operation fails, =
the
> @@ -495,13 +496,13 @@ int luo_file_freeze(struct luo_file_set *file_set,
>                 err =3D luo_file_freeze_one(file_set, luo_file);
>                 if (err < 0) {
>                         pr_warn("Freeze failed for token[%#0llx] handler[=
%s] err[%pe]\n",
> -                               luo_file->token, luo_file->fh->compatible=
,
> +                               luo_file->token, luo_file->fh->name,
>                                 ERR_PTR(err));
>                         goto err_unfreeze;
>                 }
>
> -               strscpy(file_ser->compatible, luo_file->fh->compatible,
> -                       sizeof(file_ser->compatible));
> +               strscpy(file_ser->name, luo_file->fh->name,
> +                       sizeof(file_ser->name));
>                 file_ser->data =3D luo_file->serialized_data;
>                 file_ser->token =3D luo_file->token;
>         }
> @@ -747,7 +748,7 @@ static int luo_file_deserialize_one(struct luo_file_s=
et *file_set,
>
>         down_read(&luo_register_rwlock);
>         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> -               if (!strcmp(fh->compatible, ser->compatible)) {
> +               if (!strcmp(fh->name, ser->name)) {
>                         if (try_module_get(fh->ops->owner))
>                                 handler_found =3D true;
>                         break;
> @@ -756,9 +757,9 @@ static int luo_file_deserialize_one(struct luo_file_s=
et *file_set,
>         up_read(&luo_register_rwlock);
>
>         if (!handler_found) {
> -               pr_warn("No registered handler for compatible '%.*s'\n",
> -                       (int)sizeof(ser->compatible),
> -                       ser->compatible);
> +               pr_warn("No registered handler for name '%.*s'\n",
> +                       (int)sizeof(ser->name),
> +                       ser->name);
>                 return -ENOENT;
>         }
>
> @@ -789,9 +790,9 @@ static int luo_file_deserialize_one(struct luo_file_s=
et *file_set,
>   * in-memory linked list of 'struct luo_file' instances.
>   *
>   * For each serialized entry, it performs the following steps:
> - *   1. Reads the 'compatible' string.
> + *   1. Reads the handler 'name' string.
>   *   2. Searches the global list of registered file handlers for one tha=
t
> - *      matches the compatible string.
> + *      matches the handler name.
>   *   3. Allocates a new 'struct luo_file'.
>   *   4. Populates the new structure with the deserialized data (token, p=
rivate
>   *      data handle) and links it to the found handler. The 'file' point=
er is
> @@ -884,9 +885,9 @@ void luo_file_set_destroy(struct luo_file_set *file_s=
et)
>  /**
>   * liveupdate_register_file_handler - Register a file handler with LUO.
>   * @fh: Pointer to a caller-allocated &struct liveupdate_file_handler.
> - * The caller must initialize this structure, including a unique
> - * 'compatible' string and a valid 'fh' callbacks. This function adds th=
e
> - * handler to the global list of supported file handlers.
> + * The caller must initialize this structure, including a unique 'name'
> + * string and valid 'fh' callbacks. This function adds the handler to th=
e
> + * global list of supported file handlers.
>   *
>   * Context: Typically called during module initialization for file types=
 that
>   * support live update preservation.
> @@ -908,11 +909,11 @@ int liveupdate_register_file_handler(struct liveupd=
ate_file_handler *fh)
>         }
>
>         down_write(&luo_register_rwlock);
> -       /* Check for duplicate compatible strings */
> +       /* Check for duplicate handler names */
>         list_private_for_each_entry(fh_iter, &luo_file_handler_list, list=
) {
> -               if (!strcmp(fh_iter->compatible, fh->compatible)) {
> -                       pr_err("File handler registration failed: Compati=
ble string '%s' already registered.\n",
> -                              fh->compatible);
> +               if (!strcmp(fh_iter->name, fh->name)) {
> +                       pr_err("File handler registration failed: Handler=
 name '%s' already registered.\n",
> +                              fh->name);
>                         err =3D -EEXIST;
>                         goto err_unlock;
>                 }
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index cd715a7c1d99..222c6d7f821e 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -178,7 +178,7 @@ static int luo_flb_retrieve_one(struct liveupdate_flb=
 *flb)
>                 return -ENODATA;
>
>         for (int i =3D 0; i < fh->header_ser->count; i++) {
> -               if (!strcmp(fh->ser[i].name, flb->compatible)) {
> +               if (!strcmp(fh->ser[i].name, flb->name)) {
>                         private->incoming.data =3D fh->ser[i].data;
>                         refcount_set(&private->incoming.count, fh->ser[i]=
.count);
>                         found =3D true;
> @@ -337,7 +337,7 @@ static void luo_flb_unregister_one(struct liveupdate_=
file_handler *fh,
>
>         if (!found) {
>                 pr_warn("Failed to unregister FLB '%s': not found in file=
 handler '%s'\n",
> -                       flb->compatible, fh->compatible);
> +                       flb->name, fh->name);
>                 return;
>         }
>
> @@ -442,9 +442,9 @@ int liveupdate_register_flb(struct liveupdate_file_ha=
ndler *fh,
>                 if (luo_flb_global.count =3D=3D LUO_FLB_MAX)
>                         return -ENOSPC;
>
> -               /* Check that compatible string is unique in global list =
*/
> +               /* Check that FLB name is unique in global list */
>                 list_private_for_each_entry(gflb, &luo_flb_global.list, p=
rivate.list) {
> -                       if (!strcmp(gflb->compatible, flb->compatible))
> +                       if (!strcmp(gflb->name, flb->name))
>                                 return -EEXIST;
>                 }
>
> @@ -596,9 +596,9 @@ void __init luo_flb_setup_incoming(u64 flbs_pa)
>   * preserved (i.e., its reference count is greater than zero), it writes=
 its
>   * metadata into the memory region designated for Kexec Handover.
>   *
> - * The serialized data includes the FLB's compatibility string, its opaq=
ue
> - * data handle, and the final reference count. This allows the new kerne=
l to
> - * find the appropriate handler and reconstruct the FLB's state.
> + * The serialized data includes the FLB's name string, its opaque
> + * data handle, and the final reference count. This allows the target
> + * kernel to find the appropriate FLB and reconstruct its state.
>   *
>   * Context: Called from liveupdate_reboot() just before kho_finalize().
>   */
> @@ -614,7 +614,7 @@ void luo_flb_serialize(void)
>                 long count =3D refcount_read(&private->outgoing.count);
>
>                 if (count > 0) {
> -                       strscpy(fh->ser[i].name, gflb->compatible,
> +                       strscpy(fh->ser[i].name, gflb->name,
>                                 sizeof(fh->ser[i].name));
>                         fh->ser[i].data =3D private->outgoing.data;
>                         fh->ser[i].count =3D count;
> diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
> index 4c08a7c6fb78..e4df09eed1f3 100644
> --- a/lib/tests/liveupdate.c
> +++ b/lib/tests/liveupdate.c
> @@ -17,7 +17,7 @@
>  static const struct liveupdate_flb_ops test_flb_ops;
>  #define DEFINE_TEST_FLB(i) {                                           \
>         .ops =3D &test_flb_ops,                                          =
 \
> -       .compatible =3D LIVEUPDATE_TEST_FLB_COMPATIBLE(i),               =
 \
> +       .name =3D LIVEUPDATE_TEST_FLB_NAME(i),                           =
 \
>  }
>
>  /* Number of Test FLBs to register with every file handler */
> @@ -34,7 +34,7 @@ static int test_flb_preserve(struct liveupdate_flb_op_a=
rgs *argp)
>  {
>         ptrdiff_t index =3D argp->flb - test_flbs;
>
> -       pr_info("%s: preserve was triggered\n", argp->flb->compatible);
> +       pr_info("%s: preserve was triggered\n", argp->flb->name);
>         argp->data =3D TEST_FLB_MAGIC_BASE + index;
>
>         return 0;
> @@ -42,7 +42,7 @@ static int test_flb_preserve(struct liveupdate_flb_op_a=
rgs *argp)
>
>  static void test_flb_unpreserve(struct liveupdate_flb_op_args *argp)
>  {
> -       pr_info("%s: unpreserve was triggered\n", argp->flb->compatible);
> +       pr_info("%s: unpreserve was triggered\n", argp->flb->name);
>  }
>
>  static int test_flb_retrieve(struct liveupdate_flb_op_args *argp)
> @@ -52,11 +52,11 @@ static int test_flb_retrieve(struct liveupdate_flb_op=
_args *argp)
>
>         if (argp->data =3D=3D expected_data) {
>                 pr_info("%s: found flb data from the previous boot\n",
> -                       argp->flb->compatible);
> +                       argp->flb->name);
>                 argp->obj =3D (void *)argp->data;
>         } else {
>                 pr_err("%s: ERROR - incorrect data handle: %llx, expected=
 %llx\n",
> -                      argp->flb->compatible, argp->data, expected_data);
> +                      argp->flb->name, argp->data, expected_data);
>                 return -EINVAL;
>         }
>
> @@ -69,10 +69,10 @@ static void test_flb_finish(struct liveupdate_flb_op_=
args *argp)
>         void *expected_obj =3D (void *)(TEST_FLB_MAGIC_BASE + index);
>
>         if (argp->obj =3D=3D expected_obj) {
> -               pr_info("%s: finish was triggered\n", argp->flb->compatib=
le);
> +               pr_info("%s: finish was triggered\n", argp->flb->name);
>         } else {
>                 pr_err("%s: ERROR - finish called with invalid object\n",
> -                      argp->flb->compatible);
> +                      argp->flb->name);
>         }
>  }
>
> @@ -103,7 +103,7 @@ static void liveupdate_test_init(void)
>                 err =3D liveupdate_flb_get_incoming(flb, &obj);
>                 if (err && err !=3D -ENODATA && err !=3D -ENOENT) {
>                         pr_err("liveupdate_flb_get_incoming for %s failed=
: %pe\n",
> -                              flb->compatible, ERR_PTR(err));
> +                              flb->name, ERR_PTR(err));
>                 }
>
>                 if (!err)
> @@ -124,18 +124,18 @@ void liveupdate_test_register(struct liveupdate_fil=
e_handler *fh)
>                 err =3D liveupdate_register_flb(fh, flb);
>                 if (err) {
>                         pr_err("Failed to register %s %pe\n",
> -                              flb->compatible, ERR_PTR(err));
> +                              flb->name, ERR_PTR(err));
>                 }
>         }
>
>         err =3D liveupdate_register_flb(fh, &test_flbs[0]);
>         if (!err || err !=3D -EEXIST) {
>                 pr_err("Failed: %s should be already registered, but got =
err: %pe\n",
> -                      test_flbs[0].compatible, ERR_PTR(err));
> +                      test_flbs[0].name, ERR_PTR(err));
>         }
>
>         pr_info("Registered %d FLBs with file handler: [%s]\n",
> -               TEST_NFLBS, fh->compatible);
> +               TEST_NFLBS, fh->name);
>  }
>
>  MODULE_LICENSE("GPL");
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 6b68220275eb..64f8b8cb75bd 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -602,7 +602,7 @@ static const struct liveupdate_file_ops memfd_luo_fil=
e_ops =3D {
>
>  static struct liveupdate_file_handler memfd_luo_handler =3D {
>         .ops =3D &memfd_luo_file_ops,
> -       .compatible =3D MEMFD_LUO_FH_COMPATIBLE,
> +       .name =3D MEMFD_LUO_FH_NAME,
>  };
>
>  static int __init memfd_luo_init(void)
> --
> 2.56.0.212.g129ede20d9-goog
>
