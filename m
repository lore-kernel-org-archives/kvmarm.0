Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792603684;
	b=OGTMV+y58Gw6uYCrF0nFwQHw0mw2zZkll9sLs4W079ighV8z6x1UsUrkHcJjphSGQRwj
	 ifiYq4/IZ+R8hRAY4Sm2XFThuho1fwM4WlxlfnzfkjQtNP78722Kb4JQ3A7YDjbkojUCL
	 UdbKiR9LDY8caUDmatXT1nOBzwT6tTWYkFlmMUQI4usFE94IvdpgV4ItXChyJ+pEzhOjO
	 yYPFA3yl1LlyHzl+3Lkdtr7dnb/AxWZrIigsYU+F6kJUSbgEesRhyfSpxz1pcSTy2FRkV
	 EEzxSz3jSPrfE0e3LtT7qyTaACx64+fYzU6jmvc6NT+9PWfyQ7S8GH8OKoVcly5ZHbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792603684;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ATB87aCd6j+g+5XwXpIsJ9vvLP6d9ZfYn5z6fPjTfwE=;
	b=Hzl6X41qdxCF2Iw0BIeN2LGsC7KYYpck0AR3xbvL+sKOgu+WI86Ok+smV5pEkAXY39TE
	 PtdsY6hHj+8L8xzETtQcA9L9kWONPOmbTdcgugQCJKAxjrk5rKM4IiGkEIct5MX8XPV/d
	 8miFx2WBxwORYBaw6v1qFIWcEf15obLKjQKZEkMVwTygQFblsT1WrivJeqHzq1yJ7BAFm
	 5MAeSxQH4s/5WITDbNa0wfAEbJDer7gM2saiqkm8iCuRUEvrk/r7cz/0PyQoZCEyzka1z
	 WijvhQf1llv30HPc9RQ3j2PYB5ZdVyEPCHtCI5iDtfzFbd6wP6WfFraue/Qzx5Sez9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=OdDZWL8c;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F17E606A321
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 17:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F17E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=OdDZWL8c
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3a1f628b1d1so10057651fa.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 10:28:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792603681; cv=none;
        d=google.com; s=arc-20260327;
        b=HmocmNr3v8cacT0iJuBbefWaBJzpbxf3LKZh7YmLGI2LR/46mKHv4wtDJVUpoF8WpW
         RH8XSr02rHOGKJVYvgf6Sk6VG8Z9/4mOmNNRRmA3fhax/JtpGp4wRNGr5zr0sHOFyiU4
         3ThFebz1my3ACvgezB/SZkXAQLCoSdBquvDDXZCtjr3tzuUHiky+AGc8vvRhec6QTD6+
         NdUiz4BqbPtLK2hWgOo74oNWhBF7V011SUK6gOhN6h03vdjHFKQujwahepRYz+XvcZK9
         beC6Zqk5DOaqmczl3K7bCS6FrfRW2b7iyx2r4trlU6kbswA93owQl0GGC6H5nvs/FGvv
         uU/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ATB87aCd6j+g+5XwXpIsJ9vvLP6d9ZfYn5z6fPjTfwE=;
        fh=WmEctAQ1J17sSStD8PljPVk2I+p7JmgKRcbzclU0dB4=;
        b=eSYsqhKSThByhY/t40D8jZK+Qs3MtXbMzKhVsBdzuws4j3vjsAL0PtMCyCfQnp07Qm
         rDPxtgNhHS2hL3vfxslKmcy3BFoEphLek9PuPTU1CQvfuADdzowNGU4ODKkTkPFNw6yD
         CByBHvJDjxIpu/XvGOmQRzOpa5UDOJvJ9/CttAAznOkLpkwunr1Y9kl+EhcPb2w955N2
         Neb40Lm02F8zYaDkGy2kpoIh/qiXboA1A4p44rGVODBrCQ69iADufTECGaqBgJhoJJWh
         cbgDlJ3XWT8cJBXvVQ4BdIbx+G9c0o0v2TexBBiZggZsppjSR2FFgByOL10l/fXownfb
         MFgA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792603681; x=1793208481; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ATB87aCd6j+g+5XwXpIsJ9vvLP6d9ZfYn5z6fPjTfwE=;
        b=OdDZWL8cza71VEo9RpiAqpueag+qSmqM4xAOkVHLMOAUOkkBnLemdkTMxfXivAdKoo
         JoLG3TRqwqxeGQ4rooobxJKxF7Wv7NA+rNUrLMN7VB4g14EtP0SLKAimbiSjpo8IdeL0
         yY057Mik1bvjYsHoR3qsEMS9LORUv7t4698MylmZj1guKNQtu9jMDfcX1DkVMvqPQS3Q
         3Q45Qvk2rrqm60sG2Cj6ILbm2ma4chmeA1zboBeQZrIiAdI/GDbNP3X0gsLrAcFhNH5p
         9z1JtzjAxYUk24HomzVZmexNRsJhcKEbICxR+/S95KOA1yJ7N6muwjECv+5+UzdndHOb
         BNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792603681; x=1793208481;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ATB87aCd6j+g+5XwXpIsJ9vvLP6d9ZfYn5z6fPjTfwE=;
        b=d5Dm1W+alEBAKNPks6NkUcIMWKiEQlS2V6z6cChzig/c7GgbX8EJlKir4YGi15jjtm
         +VpsjC8qKf33CbelE8YGJsOP+C4+G13Qasj8rC5tTGZVWThjUlU62loOsz8d+gswqe7U
         xH0V8JnFPj6abBHlex9Yq8iDw0VxF0wwWJ/dyY4LsGeCUWGf7xcdjWymr4HV5jLdOVCx
         l+Xo0oCo2ZI8ULjHQpVTF67Ja7B9V+l17Fxwbie9Sti+L97Uw08DoXZpfC0roUTJL54r
         ZIHKprsCG4Yb/pmtBjPQWzNRTjMyo04kPCvhv4VZGoO2Wj6tcKN2cuUACUNvxw3byGY1
         cH0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxAD8LUpeoajdjdDSmiVLDnOUzg0q87z1Yir4ERlVQvTr0ZcqcWjIko5mD+eqLVXU0KQl5pd7E=@lists.linux.dev
X-Gm-Message-State: AFq9FYI2xRN97i6v51tV+UpAe9wVRZwNuBZeTD/Wu3gZtVzX7LzNHQFG
	DYL2vyNiIKsT3b+jaM6H0pr8rgNZCoM58ly0dKw3AqePfZtdl/m5glT0zysMJixJu1A1lZ0+tnf
	fNeA/v67Ft5L9WTz1RfmJMF7ibESiylTZZJxysVoM1Q==
X-Gm-Gg: AYBFou0AZO2T2b8oauNTiffurtLccIlWlicDOo92e2p6tZH8bwZEcZk6OmcTfsk6rXX
	461mnXt1JBOrS+v2ut+Cgswf38VEqSu3mW1QAsNT2iIiVU2HPYsKUdx1SUn0Z4MYWvkQEf/q0dQ
	NCXogUlEfyB/yZ6v8rsHue+asnYqHjnu4Jg8YJ4rW+FhCWMvFvAGNmr5/02Kl8KXVm10wT3guOj
	/ztSk1uRSbXWWPp1yDg0cD9+5Mo9L6XwZrlP4oGnS8ThXKUH1Z1yFau6RHhp1jJMdYAper/h2PB
	PUJhR8nt7PNW6SD2yrqHQGb8lMehf700R8nuv1J0X/qoD6jNAG2BBr6+ukd4RXzuL9buJtnPOxS
	aw8hQ6O0AhYUfaNZnEEY33YaaXYDJlHHYjycxmYPdWJ4/qS39D2ro8tt7FXsS2RlQ+a4=
X-Received: by 2002:a2e:bea4:0:b0:3a9:ddd6:d820 with SMTP id
 38308e7fff4ca-3ac441e1f3fmr8894321fa.29.1792603681065; Wed, 21 Oct 2026
 10:28:01 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
In-Reply-To: <20261021152527.375070-4-tarunsahu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:27:22 -0400
X-Gm-Features: AclHuK-WBKHeqPjK3TFDH7FIxwj-s0SfsTYZy4-2_LVQqDo3KQno9mB27NKpnh0
Message-ID: <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
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
> LUO and its file handlers validate handed-over state with monolithic
> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> structure, even an optional additive one, must bump the string, which
> breaks live update between adjacent kernels. Replace the string in
> struct luo_ser with a feature header, so that the target kernel can
> accept or reject the source kernel state per feature.
>
> struct luo_feature_hdr is a fixed 128-byte header: the serialized

This patch is all wrong; 128 bytes is far too large. For every _ser
struct, we only need 8 bytes instead.

The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
30 feature flags + 2 reserved bits for flags extension). The last two
bits of the flags indicate whether an extended flags field is present.
Each extended flags field is 8 bytes, and its last two bits indicate
that yet another extended flags field follows.

> structure size from the source kernel followed by 15 chained u64 feature
> flags entries. The fixed size keeps payload field offsets identical in
> every kernel, regardless of how many flags entries a source kernel uses.
>
> Each feature has a 2-bit pair (req, active) state (enum luo_feat_state:
> LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entry
> holds 31 features, and bits [63:62] =3D 0b11 chain to the next entry (465
> features in total). Each subsystem defines its feature states as a
> static const u8 array indexed by its feature enum, which
> luo_feature_hdr_init() packs into 64-bit flags entries with
> LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header from
> the source kernel against its own feature array via
> luo_feature_hdr_validate() according to the per-feature (req, active)
> truth table:
>
>   Source Target Action
>   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without active=
)
>   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
>   (0,0)  (0,0)  Accept: feature absent
>   (0,0)  (0,1)  Accept: feature absent
>   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
>   (0,1)  (0,0)  Accept: ignore payload data
>   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
>   (x,1)  (x,1)  Accept: use payload data
>
> The relative order and offsets of fields in serialized structures must
> remain unchanged as features are added or retired. New fields are always
> appended at the end of the structure under a new feature flag, and
> retired fields are kept in place so that the offsets of subsequent
> fields never shift. If the type or format of a field needs to change, the
> existing field and feature are kept intact (and retired when no longer
> needed) and a new feature flag with a new appended field of the new type
> is added.
>
> In the target kernel, fields of a LUO_FEAT_REQUIRED feature are
> guaranteed to be present once luo_feature_hdr_validate() succeeds,
> whereas fields of a LUO_FEAT_OPTIONAL feature should be accessed only
> after verifying that the feature is active in the source kernel header:
>
>   if (luo_feature_is_active(&ser->features, FEAT_X))
>           val =3D ser->x_field;
>
> All current struct luo_ser fields (liveupdate_num, sessions_pa, flbs_pa)
> belong to LUO_CORE_FEAT_CORE (LUO_FEAT_REQUIRED in luo_core_features).
> Future changes add new entries to enum luo_core_feature before
> LUO_CORE_FEAT_MAX.
>
> Signed-off-by: Logan Odell <loganodell@google.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/luo.h  | 345 +++++++++++++++++++++++++++++++----
>  kernel/liveupdate/luo_core.c |  27 ++-
>  2 files changed, 332 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 5fb2f46425d7..be35cfbfdb2b 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -9,19 +9,53 @@
>   * DOC: Live Update Orchestrator ABI
>   *
>   * Live Update Orchestrator uses the stable Application Binary Interface
> - * defined below to pass state from a pre-update kernel to a post-update
> - * kernel. The ABI is built upon the Kexec HandOver framework and regist=
ers
> - * the central `struct luo_ser` via the KHO raw subtree API.
> + * defined below to pass state from a source kernel to a target kernel.
> + * The ABI is built upon the Kexec HandOver framework and registers the
> + * central `struct luo_ser` via the KHO raw subtree API.
>   *
> - * This interface is a contract. Any modification to the structure field=
s,
> - * compatible strings, or the layout of the `__packed` serialization
> - * structures defined here constitutes a breaking change. Such changes r=
equire
> - * incrementing the version number in the relevant `_COMPATIBLE` string =
to
> - * prevent a new kernel from misinterpreting data from an old kernel.
> + * This interface is a contract. Serialized structures start with a fixe=
d
> + * 128-byte feature header (`struct luo_feature_hdr`) holding the source
> + * kernel's structure `size` and 15 chained 64-bit feature flags entries
> + * (`flags[LUO_FEAT_NR_FLAGS]`). Each entry encodes up to 31 features as
> + * 2-bit `0b<req><active>` pairs (`enum luo_feat_state`), with
> + * `LUO_FEAT_EXT_MASK` in bits `[63:62]` chaining to the next entry (up =
to
> + * 465 features total). Because the header size is fixed at 128 bytes,
> + * payload field offsets do not depend on how many flags entries a sourc=
e
> + * kernel uses.
>   *
> - * Changes are allowed provided the compatibility version is incremented=
;
> - * however, backward/forward compatibility is only guaranteed for kernel=
s
> - * supporting the same ABI version.
> + * Truth table (`(req,active)` pairs per feature)::
> + *
> + *   Source Target Action
> + *   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without ac=
tive)
> + *   (x,x)  (1,0)  Reject -EINVAL: invalid target kernel (req without ac=
tive)
> + *   (0,0)  (0,0)  Accept: feature absent
> + *   (0,0)  (0,1)  Accept: feature absent
> + *   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the featur=
e
> + *   (0,1)  (0,0)  Accept: ignore payload data
> + *   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the featur=
e
> + *   (x,1)  (x,1)  Accept: use payload data
> + *
> + * The relative order and offsets of fields in serialized structures mus=
t
> + * remain unchanged as features are added or retired. New fields are alw=
ays
> + * appended at the end of the structure under a new feature flag, and
> + * retired fields are kept in place so that the offsets of subsequent
> + * fields never shift. If a field's type or format needs to change, the
> + * existing field and feature are kept intact (and retired when no longe=
r
> + * needed) and a new feature flag with a new appended field of the new t=
ype
> + * is added.
> + *
> + * In the target kernel, fields of a `LUO_FEAT_REQUIRED` feature are
> + * guaranteed to be present once `luo_feature_hdr_validate()` succeeds,
> + * whereas fields of a `LUO_FEAT_OPTIONAL` feature should be accessed on=
ly
> + * after verifying that the feature is active in the source kernel's hea=
der::
> + *
> + *   if (luo_feature_is_active(&ser->features, FEAT_X))
> + *           val =3D ser->x_field;
> + *
> + * All current `struct luo_ser` fields (`liveupdate_num`, `sessions_pa`,
> + * `flbs_pa`) belong to `LUO_CORE_FEAT_CORE` (`LUO_FEAT_REQUIRED` in
> + * `luo_core_features`). Future changes add new entries to
> + * `enum luo_core_feature` before `LUO_CORE_FEAT_MAX`.
>   *
>   * KHO Structure Overview:
>   *   The entire LUO state is encapsulated within a single KHO entry name=
d "LUO".
> @@ -30,8 +64,9 @@
>   * Serialization Structures:
>   *   - struct luo_ser:
>   *     The central ABI structure that contains the overall state of the =
LUO.
> - *     It includes the compatibility string, the liveupdate-number, and =
pointers
> - *     to sessions and FLBs.
> + *     It includes the feature header (with struct size and 2-bit featur=
e flag
> + *     pairs), and the core feature (`LUO_CORE_FEAT_CORE`) fields: the
> + *     liveupdate-number and pointers to sessions and FLBs.
>   *
>   *   - struct luo_session_ser:
>   *     Metadata for a single session, including its name and a physical =
pointer
> @@ -40,8 +75,9 @@
>   *
>   *   - struct luo_file_ser:
>   *     Metadata for a single preserved file. Contains the handler `name`=
 string
> - *     to find the correct handler in the new kernel, a user-provided `t=
oken`
> - *     for identification, and an opaque `data` handle for the handler t=
o use.
> + *     to find the correct handler in the target kernel, a user-provided
> + *     `token` for identification, and an opaque `data` handle for the h=
andler
> + *     to use.
>   *
>   *   - struct luo_flb_header_ser:
>   *     Header for the FLB array. Contains the total page count of the
> @@ -57,20 +93,265 @@
>  #ifndef _LINUX_KHO_ABI_LUO_H
>  #define _LINUX_KHO_ABI_LUO_H
>
> -#include <linux/align.h>
> +#include <linux/array_size.h>
> +#include <linux/bits.h>
> +#include <linux/bug.h>
> +#include <linux/build_bug.h>
> +#include <linux/errno.h>
>  #include <linux/kho/abi/block.h>
> +#include <linux/types.h>
>  #include <uapi/linux/liveupdate.h>
>
>  /*
>   * The LUO state is registered under this KHO entry name.
>   */
>  #define LUO_KHO_ENTRY_NAME     "LUO"
> -#define LUO_ABI_COMPATIBLE     "luo-v5"
> -#define LUO_ABI_COMPAT_LEN     ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
> +
> +#define LUO_FEAT_PER_FLAGS     31
> +#define LUO_FEAT_NR_FLAGS      15
> +#define LUO_FEAT_MAX           (LUO_FEAT_NR_FLAGS * LUO_FEAT_PER_FLAGS)
> +#define LUO_FEAT_EXT_MASK      GENMASK_ULL(63, 62)
> +#define LUO_FEAT_ACTIVE_MASK   (0x5555555555555555ULL & ~LUO_FEAT_EXT_MA=
SK)
> +#define LUO_FEAT_REQ_MASK      (0xaaaaaaaaaaaaaaaaULL & ~LUO_FEAT_EXT_MA=
SK)
> +
> +#define LUO_FEAT_FLAGS_IDX(f)  ((unsigned int)(f) / LUO_FEAT_PER_FLAGS)
> +#define LUO_FEAT_SLOT(f)       ((unsigned int)(f) % LUO_FEAT_PER_FLAGS)
> +
> +#define LUO_FEAT_ACTIVE(f)     BIT_ULL(2 * LUO_FEAT_SLOT(f))
> +#define LUO_FEAT_REQ(f)                BIT_ULL(2 * LUO_FEAT_SLOT(f) + 1)
> +
> +/**
> + * enum luo_feat_state - 2-bit state of a LUO feature (`0b<req><active>`=
).
> + * @LUO_FEAT_DISABLED: Feature is inactive (`req=3D0, active=3D0`).
> + * @LUO_FEAT_OPTIONAL: Feature is active and optional (`req=3D0, active=
=3D1`).
> + * @LUO_FEAT_REQUIRED: Feature is active and required (`req=3D1, active=
=3D1`).
> + */
> +enum luo_feat_state {
> +       LUO_FEAT_DISABLED =3D 0b00,
> +       LUO_FEAT_OPTIONAL =3D 0b01,
> +       LUO_FEAT_REQUIRED =3D 0b11,
> +};
> +
> +/**
> + * struct luo_feature_hdr - Fixed 128-byte header for serialized LUO ABI=
 structures.
> + * @size:  Size in bytes of the source kernel's enclosing serialized str=
ucture.
> + * @flags: Chained 64-bit feature flags entries (`0 .. LUO_FEAT_NR_FLAGS=
 - 1`).
> + *         Each entry holds 31 2-bit feature pairs (`[2*slot + 1 : 2*slo=
t]`)
> + *         plus %LUO_FEAT_EXT_MASK in bits `[63:62]` when the next entry=
 is
> + *         active.
> + */
> +struct luo_feature_hdr {
> +       u64 size;
> +       u64 flags[LUO_FEAT_NR_FLAGS];
> +} __packed;


> +
> +static_assert(sizeof(struct luo_feature_hdr) =3D=3D 128);
> +
> +/**
> + * luo_feature_hdr_for_each_flags - Iterate over chained flags entries i=
n @hdr.
> + * @hdr: Pointer to the &struct luo_feature_hdr to iterate.
> + * @idx: Loop cursor of type `unsigned int` (`0 .. LUO_FEAT_NR_FLAGS - 1=
`).
> + */
> +#define luo_feature_hdr_for_each_flags(hdr, idx)                       \
> +       for ((idx) =3D 0; (idx) < LUO_FEAT_NR_FLAGS;                     =
 \
> +            (idx) =3D (((hdr)->flags[idx] & LUO_FEAT_EXT_MASK) =3D=3D   =
     \
> +                     LUO_FEAT_EXT_MASK) ? (idx) + 1 : LUO_FEAT_NR_FLAGS)
> +
> +/**
> + * luo_feature_hdr_get_flags - Get the flags entry containing feature @f=
eat.
> + * @hdr:  Pointer to the source kernel's feature header.
> + * @feat: Feature index (`0 .. LUO_FEAT_MAX - 1`).
> + *
> + * Return: The u64 flags entry containing @feat if the extension chain r=
eaches
> + *         it, or 0 otherwise.
> + */
> +static inline u64
> +luo_feature_hdr_get_flags(const struct luo_feature_hdr *hdr,
> +                         unsigned int feat)
> +{
> +       unsigned int target_idx =3D LUO_FEAT_FLAGS_IDX(feat);
> +       unsigned int idx;
> +
> +       if (target_idx >=3D LUO_FEAT_NR_FLAGS)
> +               return 0;
> +
> +       luo_feature_hdr_for_each_flags(hdr, idx) {
> +               if (idx =3D=3D target_idx)
> +                       return hdr->flags[idx];
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * luo_feature_is_active - Test whether feature @feat is active in @hdr.
> + * @hdr:  Pointer to the source kernel's feature header.
> + * @feat: Feature index (`0 .. LUO_FEAT_MAX - 1`).
> + *
> + * Return: true if the source kernel marked @feat active, false otherwis=
e.
> + */
> +static inline bool luo_feature_is_active(const struct luo_feature_hdr *h=
dr,
> +                                        unsigned int feat)
> +{
> +       return luo_feature_hdr_get_flags(hdr, feat) & LUO_FEAT_ACTIVE(fea=
t);
> +}
> +
> +/**
> + * luo_feature_is_req - Test whether feature @feat is required in @hdr.
> + * @hdr:  Pointer to the source kernel's feature header.
> + * @feat: Feature index (`0 .. LUO_FEAT_MAX - 1`).
> + *
> + * Return: true if the source kernel marked @feat required, false otherw=
ise.
> + */
> +static inline bool luo_feature_is_req(const struct luo_feature_hdr *hdr,
> +                                     unsigned int feat)
> +{
> +       return luo_feature_hdr_get_flags(hdr, feat) & LUO_FEAT_REQ(feat);
> +}
> +
> +/**
> + * luo_feature_pack_entry - Pack up to 31 feature states into a flags en=
try.
> + * @features:    Array of &enum luo_feat_state values indexed by feature=
 ID.
> + * @nr_features: Number of elements in @features.
> + * @idx:         Flags entry index (`0 .. LUO_FEAT_NR_FLAGS - 1`).
> + *
> + * Return: The packed 64-bit flags entry for @idx (without %LUO_FEAT_EXT=
_MASK).
> + */
> +static inline u64
> +luo_feature_pack_entry(const u8 *features, size_t nr_features,
> +                      unsigned int idx)
> +{
> +       unsigned int base =3D idx * LUO_FEAT_PER_FLAGS;
> +       unsigned int slot;
> +       u64 flags =3D 0;
> +
> +       for (slot =3D 0; slot < LUO_FEAT_PER_FLAGS && base + slot < nr_fe=
atures;
> +            slot++)
> +               flags |=3D (u64)(features[base + slot] & 0b11) << (2 * sl=
ot);
> +
> +       return flags;
> +}
> +
> +/**
> + * __luo_feature_hdr_init - Initialize a serialized LUO feature header.
> + * @hdr:         Pointer to the feature header to initialize.
> + * @size:        Byte size of the enclosing serialized structure.
> + * @features:    Array of &enum luo_feat_state values for the source ker=
nel.
> + * @nr_features: Number of elements in @features (`<=3D LUO_FEAT_MAX`).
> + */
> +static inline void
> +__luo_feature_hdr_init(struct luo_feature_hdr *hdr, u64 size,
> +                      const u8 *features, size_t nr_features)
> +{
> +       bool ext =3D false;
> +       int idx;
> +
> +       hdr->size =3D size;
> +       for (idx =3D LUO_FEAT_NR_FLAGS - 1; idx >=3D 0; idx--) {
> +               u64 flags =3D luo_feature_pack_entry(features, nr_feature=
s, idx);
> +
> +               WARN_ON_ONCE(((flags & LUO_FEAT_REQ_MASK) >> 1) &
> +                            ~(flags & LUO_FEAT_ACTIVE_MASK));
> +               if (ext)
> +                       flags |=3D LUO_FEAT_EXT_MASK;
> +               else if (flags)
> +                       ext =3D true;
> +               hdr->flags[idx] =3D flags;
> +       }
> +}
> +
> +/**
> + * luo_feature_hdr_init - Initialize a serialized LUO feature header.
> + * @hdr:      Pointer to the feature header to initialize.
> + * @size:     Byte size of the enclosing serialized structure.
> + * @features: Fixed-size `u8` array of &enum luo_feat_state entries.
> + */
> +#define luo_feature_hdr_init(hdr, size, features)                      \
> +({                                                                     \
> +       BUILD_BUG_ON(ARRAY_SIZE(features) > LUO_FEAT_MAX);              \
> +       __luo_feature_hdr_init(hdr, size, features,                     \
> +                              ARRAY_SIZE(features));                   \
> +})
> +
> +/**
> + * __luo_feature_hdr_validate - Validate a source kernel's LUO feature h=
eader
> + *                              against the target kernel's feature arra=
y.
> + * @hdr:         Pointer to the feature header from the source kernel.
> + * @features:    Array of &enum luo_feat_state values for the target ker=
nel.
> + * @nr_features: Number of elements in @features (`<=3D LUO_FEAT_MAX`).
> + *
> + * Return: 0 if compatible, -EINVAL on malformed header or `(req=3D1, ac=
tive=3D0)`
> + *         feature state, or -EOPNOTSUPP on required feature mismatch.
> + */
> +static inline int
> +__luo_feature_hdr_validate(const struct luo_feature_hdr *hdr,
> +                          const u8 *features, size_t nr_features)
> +{
> +       bool src_ext =3D true, target_ext =3D (nr_features > 0);
> +       unsigned int idx;
> +
> +       if (hdr->size < sizeof(*hdr))
> +               return -EINVAL;
> +
> +       for (idx =3D 0; idx < LUO_FEAT_NR_FLAGS && (src_ext || target_ext=
); idx++) {
> +               u64 src =3D src_ext ? hdr->flags[idx] : 0;
> +               u64 target =3D target_ext ?
> +                       luo_feature_pack_entry(features, nr_features, idx=
) : 0;
> +               u64 ext =3D src & LUO_FEAT_EXT_MASK;
> +               u64 src_act =3D src & LUO_FEAT_ACTIVE_MASK;
> +               u64 src_req =3D (src & LUO_FEAT_REQ_MASK) >> 1;
> +               u64 target_act =3D target & LUO_FEAT_ACTIVE_MASK;
> +               u64 target_req =3D (target & LUO_FEAT_REQ_MASK) >> 1;
> +
> +               if (ext && (ext !=3D LUO_FEAT_EXT_MASK ||
> +                           idx =3D=3D LUO_FEAT_NR_FLAGS - 1))
> +                       return -EINVAL;
> +               if (src_req & ~src_act)
> +                       return -EINVAL;
> +               if (WARN_ON_ONCE(target_req & ~target_act))
> +                       return -EINVAL;
> +               if ((src_req & ~target_act) || (target_req & ~src_act))
> +                       return -EOPNOTSUPP;
> +
> +               src_ext =3D (ext =3D=3D LUO_FEAT_EXT_MASK);
> +               target_ext =3D ((idx + 1) * LUO_FEAT_PER_FLAGS < nr_featu=
res);
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * luo_feature_hdr_validate - Validate a source kernel's LUO feature hea=
der
> + *                            against the target kernel's feature array.
> + * @hdr:      Pointer to the feature header from the source kernel.
> + * @features: Fixed-size `u8` array of &enum luo_feat_state entries.
> + *
> + * Return: 0 if compatible, -EINVAL on malformed header or feature state=
, or
> + *         -EOPNOTSUPP on required feature mismatch.
> + */
> +#define luo_feature_hdr_validate(hdr, features)                         =
       \
> +({                                                                     \
> +       BUILD_BUG_ON(ARRAY_SIZE(features) > LUO_FEAT_MAX);              \
> +       __luo_feature_hdr_validate(hdr, features,                       \
> +                                  ARRAY_SIZE(features));               \
> +})
> +
> +/**
> + * enum luo_core_feature - Feature indices for &struct luo_ser.
> + * @LUO_CORE_FEAT_CORE: Core feature covering `liveupdate_num`, `session=
s_pa`,
> + *                      and `flbs_pa`.
> + * @LUO_CORE_FEAT_MAX:  Number of defined &enum luo_core_feature feature=
s.
> + */
> +enum luo_core_feature {
> +       LUO_CORE_FEAT_CORE =3D 0,
> +       LUO_CORE_FEAT_MAX,
> +};
> +
> +static_assert((int)LUO_CORE_FEAT_MAX <=3D LUO_FEAT_MAX);
>
>  /**
>   * struct luo_ser - Centralized LUO ABI header.
> - * @compatible:     Compatibility string identifying the LUO ABI version=
.
> + * @features:       ABI feature and size header for luo_ser.
>   * @liveupdate_num: A counter tracking the number of successful live upd=
ates.
>   * @sessions_pa:    Physical address of the first session block header.
>   * @flbs_pa:        Physical address of the FLB header.
> @@ -78,7 +359,7 @@
>   * This structure is the root of all preserved LUO state.
>   */
>  struct luo_ser {
> -       char compatible[LUO_ABI_COMPAT_LEN];
> +       struct luo_feature_hdr features;
>         u64 liveupdate_num;
>         u64 sessions_pa;
>         u64 flbs_pa;
> @@ -90,7 +371,7 @@ struct luo_ser {
>   * @data:        Private data
>   * @token:       User provided token for this file
>   *
> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
> + * Layout changes must be gated by a required feature in &enum luo_core_=
feature.
>   */
>  struct luo_file_ser {
>         char name[LIVEUPDATE_HNDL_NAME_LENGTH];
> @@ -121,10 +402,10 @@ struct luo_file_set_ser {
>   *
>   * This structure is used to package session-specific metadata for trans=
fer
>   * between kernels via Kexec Handover. An array of these structures (one=
 per
> - * session) is created and passed to the new kernel, allowing it to reco=
nstruct
> - * the session context.
> + * session) is created and passed to the target kernel, allowing it to
> + * reconstruct the session context.
>   *
> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
> + * Layout changes must be gated by a required feature in &enum luo_core_=
feature.
>   */
>  struct luo_session_ser {
>         char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> @@ -145,7 +426,7 @@ struct luo_session_ser {
>   * This structure is located at the physical address specified by the
>   * flbs_pa in luo_ser.
>   *
> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
> + * Layout changes must be gated by a required feature in &enum luo_core_=
feature.
>   */
>  struct luo_flb_header_ser {
>         u64 pgcnt;
> @@ -155,19 +436,19 @@ struct luo_flb_header_ser {
>  /**
>   * struct luo_flb_ser - Represents the serialized state of a single FLB =
object.
>   * @name:    The unique name string of the FLB object, used to find the
> - *           corresponding &struct liveupdate_flb handler in the new ker=
nel.
> + *           corresponding &struct liveupdate_flb in the target kernel.
>   * @data:    The opaque u64 handle returned by the FLB's .preserve() ope=
ration
> - *           in the old kernel. This handle encapsulates the entire stat=
e needed
> - *           for restoration.
> + *           in the source kernel. This handle encapsulates the entire s=
tate
> + *           needed for restoration.
>   * @count:   The reference count at the time of serialization; i.e., the=
 number
>   *           of preserved files that depended on this FLB. This is used =
by the
> - *           new kernel to correctly manage the FLB's lifecycle.
> + *           target kernel to correctly manage the FLB's lifecycle.
>   *
>   * An array of these structures is created in a preserved memory region =
and
> - * passed to the new kernel. Each entry allows the LUO core to restore o=
ne
> - * global, shared object.
> + * passed to the target kernel. Each entry allows the LUO core to restor=
e
> + * one global, shared object.
>   *
> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
> + * Layout changes must be gated by a required feature in &enum luo_core_=
feature.
>   */
>  struct luo_flb_ser {
>         char name[LIVEUPDATE_FLB_NAME_LENGTH];
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index 1b2bda22902d..3627a206a79c 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -70,6 +70,10 @@ static struct {
>         u64 liveupdate_num;
>  } luo_global;
>
> +static const u8 luo_core_features[LUO_CORE_FEAT_MAX] =3D {
> +       [LUO_CORE_FEAT_CORE] =3D LUO_FEAT_REQUIRED,
> +};
> +
>  /*
>   * luo_register_rwlock - Protects registration of file handlers and FLBs=
.
>   */
> @@ -107,15 +111,21 @@ static int __init luo_early_startup(void)
>                 return 0;
>         }
>
> -       if (len < sizeof(*luo_ser)) {
> -               pr_err("LUO state is too small (%zu < %zu)\n", len, sizeo=
f(*luo_ser));
> -               return -EINVAL;
> +       luo_ser =3D phys_to_virt(luo_ser_phys);
> +       if (len < sizeof(luo_ser->features) || luo_ser->features.size > l=
en) {
> +               pr_err("LUO state size invalid (source kernel header size=
=3D%llu, KHO len=3D%zu)\n",
> +                      len >=3D sizeof(luo_ser->features) ? luo_ser->feat=
ures.size : 0,
> +                      len);
> +               err =3D -EINVAL;
> +               goto out_free_ser;
>         }
>
> -       luo_ser =3D phys_to_virt(luo_ser_phys);
> -       if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMP=
AT_LEN)) {
> -               pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_C=
OMPATIBLE);
> -               return -EINVAL;
> +       err =3D luo_feature_hdr_validate(&luo_ser->features, luo_core_fea=
tures);
> +       if (err) {
> +               pr_err("LUO state feature header validation failed (size=
=3D%llu, flags[0]=3D%#llx): %pe\n",
> +                      luo_ser->features.size, luo_ser->features.flags[0]=
,
> +                      ERR_PTR(err));
> +               goto out_free_ser;
>         }
>
>         luo_global.liveupdate_num =3D luo_ser->liveupdate_num;
> @@ -162,7 +172,8 @@ static int __init luo_state_setup(void)
>                 return PTR_ERR(luo_ser);
>         }
>
> -       strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->=
compatible));
> +       luo_feature_hdr_init(&luo_ser->features, sizeof(*luo_ser),
> +                            luo_core_features);
>         luo_ser->liveupdate_num =3D luo_global.liveupdate_num + 1;
>
>         luo_session_setup_outgoing(&luo_ser->sessions_pa);
> --
> 2.56.0.212.g129ede20d9-goog
>
