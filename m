Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792604337;
	b=h7gHU6QtR++XzRDcJtXYaJ79pTAi//vMDb/KQBnR+2G5qt5zEoropBELJ2JTJjfr3PcD
	 npHqS9Pp7AYT6ZAk4HjEGgrCdHgCA3fzkciA/nhZzR0QBhwadY5uVnj6cNQ/Jk/lLBea+
	 yR6Gis2uDfvoxlpIXJPucsDvzuVrImtouPOmYokm6le8s61EVDiodbZ/XSLHS4aP5uiow
	 6aAnLv6Xk5hyH+jlDfTnWP5F/xOwnTL0vwsLiLWitx0OJ06/Byefp46nVzLryqdtrW2Qr
	 GM1I7p+mlYH4d/1nQ03lM4vEYmiDkqPqzMY8g5obg0rKg6afQp2ct7v+igRpTQTmqSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
	b=WuBgZjmaYzua00Or8Yp3g5GRvKa6zOwUcHBDUCeqAbiFAAgVI8P+rtDoHL9hg6Az1e6H
	 RrwILB9es750n9CDjhyW6dG+U3QsGkx6s1pZaDM9SadXaO/ZpGAO9jxaVxbqUA7XbqsVU
	 DMUu0GxkQ/fZ2kU+A9ECQpG0QViG/oCq4qGiFKgwJ14CV0rNk+6gsvquVv/EN7kzdOk9d
	 GmhyZwJVAfVMRzH4xElAMVI8yiLms1nOa38paS+/vgWKrtsF3JBHpxHsjFYG6CjzSzk/l
	 n7BTms/+2nm2F2A8u0dwXDv6kIf+0SqMOpl2cIivFBBUNSs2TKzKOQV7QaQ0IE6lzoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b="R/wfDvdV";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.176
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D5606A31F
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 17:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F8D5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=R/wfDvdV
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3ab4891fc73so9079801fa.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 10:38:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792604334; cv=none;
        d=google.com; s=arc-20260327;
        b=PxobZbF4nVRn84a1Y02mB8czM5jIjaYvWWZr85yAqa/tRyWigHlKEF8kEC3EiyJftI
         6CZLeJzCswMRyFrukaZPWNovWG9MrOqhsa1cs4ovZib3IBdYVcTwuZg3L3mF/1CUHCz7
         5IdpL9qnJAmfZ5AIOxc/pHYXIyqzneIJ02JYcXXXGAijyB7faPKlqBc0vavh8ablTU9/
         +480IAVkhpEyY9TKMl3ym2dPu2Di76yus02hXlykdEyGvMS77TZ5jPbteER9AQhFuqFf
         67KzbFa1R8A6mUxIo5tobCQAXdrF8ommAUo2TAYJOkXzNzHLXHlVO79b7sD19syfrNI4
         LZ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
        fh=54thBwpvQ1BmRXHT3CJcELiBZSakDZ7K30fXvzIKgkQ=;
        b=dSZzaULScpLHycP7Uc2EsOQj1XEeGt2jSrTB4WeSSYD9McAdbeolckAQggJh71dStm
         sf5ENa3K2RYLJWqYm/6xnjfjAFYj2DxEhcIILR62I4LIAAqp0u5HIyuMBHS7ealxvKAS
         xI/hkqmVyel3I+y97pNR7nwJIKwXJJh18jqcrQ8LU5HagmFN7CXOmQNGTSZGnXoRjh+0
         MtVEsVGlPvj21apbMnqVWAwSmT/kKjSHpEotdvEJtBjcy+r0iXVNYuOGipmJM/5bki4e
         TRWPR/4yqsbY8yhLUVwtWZC0/lH0msdwBEiWgxLZcVYld8UAHZMBi2FT9s0HqVcR/KFH
         avqA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792604334; x=1793209134; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
        b=R/wfDvdVrvYoxRq/P0hL7dIWM53cGYo2XM5VWIuNyxBHA/4uki1P3pUaRl76FNNfod
         2mIEWmjmu8wC0gnNoI885fYYFsjJiefti/EROuTof03fdrWI89gdxH7RfcwVOVqCzxmd
         YVNG5rErKF6ruwuGHNxS1f+12rXnmyR7VQ8lzVaexft4ELXULUVIRSqVWD03Kw+ZlLQX
         hPDWiFUlu49jzUHOPMTRh+6dvnVMnGt2z7T9foSOQPTxTWoxv/GvInZl7uMYyW7Jkok5
         NKgehHsNocX33z/s6dqGORYEZbVrGRSc8lhB+mC1kEAtGnpfg+aG+beE3xhjcj83s6xK
         cohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604334; x=1793209134;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
        b=zMEC+oLF5h/lrWV1F8iBy6T9v56+W7cyM9inmyaJwH8zfhVWhBgTiBit+Y41snroZt
         t8UsDkdH2glR+jFUwsjgIFPS7460txvdNbhEaBm9/R04RB6Dp9i5Imv2/1KAXYBfT/Gj
         pu7RHQJq7RcTfvTXhmFMUISon45IRtXBiakWqY7pw6QgVeVXn4GRiSU8ZkzPKhCllTZA
         tAjTuH3jRcCeGeGxzegT7RiWDNZzrDPGvw442fyEPTxTItkI9HsXmF1zV23Mx7ydLOFh
         QmMfWfQTkt+6dM1JwWv44WhovXdARqkMyeYHfzcSNfGmQCDFKvRuF2giYLaVQsjMYV1s
         KbMA==
X-Forwarded-Encrypted: i=1; AKwUvBziNB1dFVUria/nrSgoAes/L20EddQqpWZ/vDxzgDtgYFofCi78QMyO5yS5o4WgK2OdsZfm9L0=@lists.linux.dev
X-Gm-Message-State: AFq9FYIMtYFp4O9wkMReaZaqfl5FUHofS3dgIrNJTxXp1PJtUKKvLWml
	Ryhoh0xagdXHOpg0b0g3Qe3o55VrwLi//1M/iFtK2EwLIkcVHD5qAvGHlKkc97L0V1U8hwC8t2r
	Ap2Ep/YEl0h1wOOqbTL2X3DysZRv+WzDMLhG6xzN5ng==
X-Gm-Gg: AYBFou3PAZL6fPOJu3ibHlTVsaNrEEcfCI8g36TvfhmImeXQw1zAgYVGa1mpZ21BgP7
	WdWsiofpbU4jca1fkwbdNm3qEpCHOGxdcyySD4cR1EXCbSU8zRMc+we4N6mtrdzfiJm6qlcTYie
	iA2NWj/y5xNRKw8pS7YCU7+RpJZLQOj0PZ9BrthuwcnGFy9Jb7cZi3exz4OKz+QtAZN0b6NoETY
	owhbc28T+ExdmMlcaVgLUdbI93/NFY2e8lil3tEc/X8ro7PlkdL/NBFF5Tlz2JG+iFsP9ZX3RFS
	+FCrT0z1G8n3Q8gR0vyoPu9OowK6Wh4JE1riLb3JKgrgLgzxBB6Si+svyImDYQn/O/p0R4qJ2fq
	xT7U13FrHVOIDjEIEUKuqkvPHJuWqhvczgfZLPX24N/mkvdbOlYriCUmUBXKS6jpP/zc=
X-Received: by 2002:a05:651c:4210:b0:3ab:473f:4340 with SMTP id
 38308e7fff4ca-3ac44229527mr7899791fa.25.1792604334224; Wed, 21 Oct 2026
 10:38:54 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-5-tarunsahu@google.com>
In-Reply-To: <20261021152527.375070-5-tarunsahu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:38:17 -0400
X-Gm-Features: AclHuK9EmTvcDrSPqjt_gHIG_UhFcRBGzP6kEtdhbGsx9XevNkAWoOmg1utImw8
Message-ID: <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature header
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
> Embed the fixed-size 128-byte struct luo_feature_hdr at the start of
> struct memfd_luo_ser and define enum memfd_luo_feature
> (MEMFD_LUO_FEAT_CORE and MEMFD_LUO_FEAT_MAX) for memfd preservation.
>
> All current struct memfd_luo_ser fields (pos, size, seals, flags,
> nr_folios, folios) and MEMFD_LUO_ALL_SEALS belong to
> MEMFD_LUO_FEAT_CORE (LUO_FEAT_REQUIRED in memfd_luo_features). Future
> changes add new entries to enum memfd_luo_feature before
> MEMFD_LUO_FEAT_MAX and append any new fields to the end of struct
> memfd_luo_ser so existing field offsets never shift.
>
> Signed-off-by: Logan Odell <loganodell@google.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/memfd.h | 35 ++++++++++++++++++++++++++++++-----
>  mm/memfd_luo.c                | 14 ++++++++++++++
>  2 files changed, 44 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.=
h
> index 371ffd108a79..f0b5235a408d 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -13,6 +13,7 @@
>
>  #include <linux/types.h>
>  #include <linux/kho/abi/kexec_handover.h>
> +#include <linux/kho/abi/luo.h>
>
>  /**
>   * DOC: memfd Live Update ABI
> @@ -21,11 +22,20 @@
>   * reboot using the LUO.
>   *
>   * The state is serialized into a packed structure `struct memfd_luo_ser=
`
> - * which is handed over to the next kernel via the KHO mechanism.
> + * which is handed over to the target kernel via the KHO mechanism.
>   *
> - * This interface is a contract. Any modification to the structure layou=
t
> - * constitutes a breaking change. Such changes require incrementing the
> - * version number in the MEMFD_LUO_FH_COMPATIBLE string.
> + * This interface is a contract. `struct memfd_luo_ser` starts with a fi=
xed
> + * 128-byte `struct luo_feature_hdr`. The relative order and offsets of
> + * fields must remain unchanged as features are added or retired: new fi=
elds
> + * are appended at the end of `struct memfd_luo_ser` under a new feature
> + * flag in `enum memfd_luo_feature` (before `MEMFD_LUO_FEAT_MAX`), and
> + * retired fields are kept in place so subsequent offsets never shift. I=
n
> + * the target kernel, fields of a `LUO_FEAT_REQUIRED` feature are guaran=
teed
> + * present once `luo_feature_hdr_validate()` succeeds, whereas fields of=
 a
> + * `LUO_FEAT_OPTIONAL` feature should be accessed only after checking
> + * `luo_feature_is_active()`. All current fields (`pos`, `size`, `seals`=
,
> + * `flags`, `nr_folios`, `folios`) and `MEMFD_LUO_ALL_SEALS` belong to
> + * `MEMFD_LUO_FEAT_CORE` (`LUO_FEAT_REQUIRED` in `memfd_luo_features`).
>   */
>
>  /**
> @@ -58,7 +68,7 @@ struct memfd_luo_folio_ser {
>
>  /*
>   * The set of seals this version supports preserving. If support for any=
 new
> - * seals is needed, add it here and bump version.
> + * seals is needed, gate them behind a new feature flag.
>   */
>  #define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
>                              F_SEAL_SHRINK | \
> @@ -67,8 +77,22 @@ struct memfd_luo_folio_ser {
>                              F_SEAL_FUTURE_WRITE | \
>                              F_SEAL_EXEC)
>
> +/**
> + * enum memfd_luo_feature - Feature indices for &struct memfd_luo_ser.
> + * @MEMFD_LUO_FEAT_CORE: Core feature covering `pos`, `size`, `seals`, `=
flags`,
> + *                       `nr_folios`, `folios`, and %MEMFD_LUO_ALL_SEALS=
.
> + * @MEMFD_LUO_FEAT_MAX:  Number of defined &enum memfd_luo_feature featu=
res.
> + */
> +enum memfd_luo_feature {
> +       MEMFD_LUO_FEAT_CORE =3D 0,
> +       MEMFD_LUO_FEAT_MAX,
> +};
> +
> +static_assert((int)MEMFD_LUO_FEAT_MAX <=3D LUO_FEAT_MAX);
> +
>  /**
>   * struct memfd_luo_ser - Main serialization structure for a memfd.
> + * @features:  ABI feature and size header for memfd_luo_ser.
>   * @pos:       The file's current position (f_pos).
>   * @size:      The total size of the file in bytes (i_size).
>   * @seals:     The seals present on the memfd. The seals are uABI so it =
is safe
> @@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
>   *             struct memfd_luo_folio_ser.
>   */
>  struct memfd_luo_ser {
> +       struct luo_feature_hdr features;

I have not looked into this yet, but I would prefer to use some kind
of macro constructor for serialized structs. That way, they will
automatically include the header, making it easier to search the code
for what is actually preserved versus what exists only in this kernel.

So, I think something like this:
/* Base serialization header: 4 bytes total size, 4 bytes flags */
struct luo_ser_hdr {
    __u32 total_size;
    __u32 flags;
};

#define LUO_SER_INIT_HDR(obj, _flags) do {           \
    (obj)->hdr.total_size =3D sizeof(*(obj));          \
    (obj)->hdr.flags =3D (_flags);                     \
} while (0)

#define DECLARE_LUO_SER(name, expected_size, members)       \
    struct name {                                           \
        struct luo_ser_hdr hdr;                             \
        members                                             \
    };                                                      \
    static_assert(sizeof(struct name) =3D=3D (expected_size),   \
                  "LUO struct " #name " size mismatch!")

Usage:
/*
 * Header:  8 bytes (hdr: 4 bytes total_size + 4 bytes flags)
 * Payload: 8 (pos) + 8 (size) + 4 (seals) + 4 (_pad) =3D 24 bytes
 * Total:   32 bytes
 */
DECLARE_LUO_SER(memfd_luo_ser, 32,
    __u64 pos;
    __u64 size;
    __u32 seals;
    __u32 _pad;
);

struct memfd_luo_ser *ser;
...
LUO_SER_INIT_HDR(ser, 0);

Thanks,
Pasha

>         u64 pos;
>         u64 size;
>         u32 seals;
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 64f8b8cb75bd..ea1f4c8cd259 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -84,6 +84,10 @@
>
>  #include "internal.h"
>
> +static const u8 memfd_luo_features[MEMFD_LUO_FEAT_MAX] =3D {
> +       [MEMFD_LUO_FEAT_CORE] =3D LUO_FEAT_REQUIRED,
> +};
> +
>  static int memfd_luo_preserve_folios(struct file *file,
>                                      struct kho_vmalloc *kho_vmalloc,
>                                      struct memfd_luo_folio_ser **out_fol=
ios_ser,
> @@ -284,6 +288,8 @@ static int memfd_luo_preserve(struct liveupdate_file_=
op_args *args)
>                 goto err_free_ser;
>         }
>
> +       luo_feature_hdr_init(&ser->features, sizeof(*ser),
> +                            memfd_luo_features);
>         ser->pos =3D args->file->f_pos;
>         inode_size =3D i_size_read(inode);
>
> @@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file=
_op_args *args)
>         if (!ser)
>                 return -EINVAL;
>
> +       err =3D luo_feature_hdr_validate(&ser->features, memfd_luo_featur=
es);
> +       if (err) {
> +               pr_err("memfd_luo_ser feature header validation failed (s=
ize=3D%llu, flags[0]=3D%#llx): %pe\n",
> +                      ser->features.size, ser->features.flags[0],
> +                      ERR_PTR(err));
> +               goto free_ser;
> +       }
> +
>         /* Make sure the file only has seals supported by this version. *=
/
>         if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
>                 err =3D -EOPNOTSUPP;
> --
> 2.56.0.212.g129ede20d9-goog
>
