Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792702448;
	b=Cnx/Xnw8MBwUj5Qt9nteZfK2xb0e2El9U1Nn+1P7siBWzkFh6/4XDZuj4pA0MifKuq2V
	 elkB3sQQuuO7ifwh5HsHBOfTJtUxqNUAPwUg8LkdeQ894x93v15hd0KWoMME1SMfnwFER
	 C77RFH3p8/5pfGQx/XvrnR0bPKIajnzmStEU93rwHsmqOTSi9Ur8KeLEIYR4ij+dtxBnE
	 bdR5VYylVidWBsbpajsWSjDfp0ZrElnJPtshveOwoFbwextAqpYKxB4TubvgTLLMa5Am8
	 Yx0ii8A/i4R2U8f/8nXhmQIr65X74ZEQUZIQC85n/CB0JkX/KYok8H4RRn6Z95vyXNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702448;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
	b=f8eN49C8pOLE5YLv71nN0mzzj++DcmOK5Gxr79ywBj54PlLWH+pZImcm5xzi1/JKn0d7
	 0dYtmAwvLUpVCdYhnqwxByO48JqgsfHgeOYIqxBsqQzzP/tygBA5AKHbiDeOYJbjwGWVe
	 9ZJmUXAdzg2dofU1xHT1wCcDb5V9B6KW5o2pRdekJm/+h5ZzR+3HrZyKMTQhFY5S+iqV+
	 Vbgo1kF7tScBcWTq7h17zRq2HNO5ksy2VPKYaT6YJCM+/J+WPX6MvO4wmS1WxZKc5ZPMR
	 1n5woLw2TMY4glZXqB+kUPxAgtV6b0TCKRaaGnnDvISJ4FpiqtHwtGjKH5Sv68vwuyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=VdVH63vb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FE1606A31B
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 20:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8FE1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=VdVH63vb
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so235841a12.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 13:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792702446; cv=none;
        d=google.com; s=arc-20260327;
        b=csDeV7WzvVI2aeSvZCmNXcJsli1e1FtdvAeqNTy7ndVDJAZy5zyDHDYWKyX2XyItt6
         3aMit9W/36bpQXN7uP28nWlAmBNwNS8wk3MrDQbibPibfLbLYnOpL3IvMWkU37LquSA9
         5mq3DHeOCVhXNxKmT2XB7xwURKxUKL+t19KyWJ70WMOIqGCr35kTpko6Q3NCn5WDvDJB
         TjeHSCWumg501wP+autX62JuB9XWOBsDd+Hdy0IWSCQukvZFyAIUUN9B9ibmDlca+tFx
         n+xAo6gNplLlz1TcDkIKKlSHSy1PCKhYOebHzJkLOsOFJKKxh41M4yBJk8Wg5/ZUpALO
         Gutw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
        fh=vDcVTwIHihkzd6zTOwsUj2x58YKDvof2TUy1MzhcgQU=;
        b=jsQfezPW/kmnhGh/DNgxnC0jSdPeAkSz4c1zaPdOY1dmONDUdWlrfp9G63X7caYTV2
         C5kHEvgfT46cKsbrwWiOOZkj8RgBNzxQO+3IP+Fg/XFoc1/7Y0OIV2oxPLJwVUNWsXNd
         4Sngf9jI6U4wwzhcYOVK7rwLlJEPW/peYIXmSch8PrBuxP8W2NKBXsz0PGUVfyG6JQeq
         7Jpfu0e3QQMtvphu/dj1wd7FnvjGbvDF0dDznCqq+eBaijbLwzkQeGGaCYe248MxXE1S
         Clbg0zf7QNdMmwacrzl72dCcfohOLW9LJNdQ9dRm9GvH4MeIL3xb8v2YruWzgrslsNq/
         QcAA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792702446; x=1793307246; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
        b=VdVH63vb9xA8RkT7KWzbSVlWrBVOx+ImJJbH9fAseT+6IlStbk92F61SsEQc91MEVL
         yf6rsGBqlAATCj5KV7sOmITHmY+iYukqYTNkmAucj9rfJJCLw7xGf7lwzOBEn4vgkz4f
         UWdM7/uCFOZLTrmNw7/w//a16bh9QIUi9/uptGl7lBUfCs50jkaCeUC9YkgoetLswVtQ
         aW5odN4kKcW0gRnR+L095hrlYbntWgQvi+m2Jnw/lD7KJjBicbtJ2loesm/lumlzBrmL
         O9hwFp83uCronAW2UHdRQczUt9RX2KQfTkbiWcyRyb0oIa/RGg5AD4jQsNpdSdE9PdY4
         cwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792702446; x=1793307246;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
        b=gvqdRkwsSa5vxp+HVPDTEiIay4wfALyncdA2wwG8KHc5XRRdWkIf1Zd+JMXA40zTCZ
         uEBnavhsmtFWjf6KIRkS58oOziRvLqFZ7sKT3YVsjpnqxlbUngIKxOBtU6KWXmrAxzrR
         JG4df7q7zAS+Uz8RFyALfShyMIKS6oNC3wTETgUfj3NkYuQWiTvnnc9DCoi9BvfaFA+Y
         CJfKYNDHXjBs4ynIhEV9xXm7Vcd29vseXsLjLDed3on3/elESRL8Xqjjjjk8cqW5qWZd
         KZgmMgjZo8VEwErHpSHaD7M+4wnv5q9/GlkKS1IWqyt6OemLmMU3juPRI7lmGZVYNVse
         4QFQ==
X-Forwarded-Encrypted: i=1; AKwUvBzszsLY0k9xJa82CB1bWOBftdjZkhCnU4X3UeJsHGAdKa/d1UgMmK4RBydFfG4u35qxLKsMcp8=@lists.linux.dev
X-Gm-Message-State: AFq9FYKdEguISd0SqVchi1U9uPkpwbSqFCtoD1qR2Hc40GI7BjvK+FZG
	t/oUmpMYlQvwjm1cxFcDPkQ5dIA2gazuVz1n4VmI2DLgImJVNMHUpjwo8SZF6YSY0YbgGp/Uc9t
	LT27O5YuuZb89+buq4WtAU8Hd0bXruDrNbuzI67eK4g==
X-Gm-Gg: AYBFou0VFPmeYRbvhDzRX1DxAuoxgk8TYuj2KpzMoei4TlF+Qd1LdQwI7IMBtsRBsxz
	cjUVub1ZV+3DObbcVMF1Q1SiN7nV0m3NAg/+tn0noNg98riwjPs7wHs9IzQlLX7LNlESsH/8fZw
	bQQJjMeOJsJ977iLiRKEdxuiXU2qs6FtMRknkJBjSSm7IJHLE5hJD9C0FVwwp8XhuCEfZPF0G5B
	LHZ9uJIWEMDDjb42AgV7wwzMU33/fJGhlwcG2GldsSJPagWQVX0cDFCrwo7mtkMl0v5emtqyaGh
	Mlnqllotc/+h67mYXpOM/547FL5PhPnrZmds4Xt4v5r5FIw1WROQNSaoW4+h13QQ/Q5YBeJPBFw
	OhIOu3WOjvBxoqTuQfzLMeY/Fgoh/ZtsoSiHm1T3dMfwDzXzYh4osgJ3n/xIWRLS5/ZXI
X-Received: by 2002:a05:6402:321c:b0:6b1:c299:b3f8 with SMTP id
 4fb4d7f45d1cf-6b432c1a486mr859420a12.33.1792702445990; Thu, 22 Oct 2026
 13:54:05 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com> <atpNFEFIlqAoYIwH@google.com>
In-Reply-To: <atpNFEFIlqAoYIwH@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Oct 2026 16:53:28 -0400
X-Gm-Features: AclHuK_o-bcMo-_bEmG9OJEk39HO6mWdZ96jtolFahfwsqDnw1LYQXgLWQ4gcJk
Message-ID: <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 1:51=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-22 12:11 AM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 11:53=E2=80=AFPM David Matlack <dmatlack@google=
.com> wrote:
>
> > > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, paylo=
ad_type) \
> > > >     struct name {                                                  =
         \
> > > >         __u32 size;                                                =
         \
> > > >         __u32 flags;                                               =
         \
> > > >         __u64 ext_flags[ext_flags_count];                          =
         \
> > > >         payload_type payload;                                      =
         \
> > > >     };                                                             =
         \
> > > >     static_assert(sizeof(struct name) =3D=3D (expected_size),      =
             \
> > > >                   "LUO struct " #name " size mismatch!")
> > > >
> > > > For example:
> > > >
> > > > struct luo_memfd_payload {
> > > >     __u64 pos;
> > > >     __u64 size;
> > > > };
> > > >
> > > > DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);
> > >
> > > This looks pretty reasonable but I would name the payload
> > > luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
> > > should never be used directly since the offset of the payload in that
> > > struct is only valid in the current kernel. So I would give that
> > > struct a special name that makes it obvious you shouldn't be using it=
.
> >
> > Lets drop the fourth macro argument and generate the combined struct na=
me:
> >
> > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)          =
    \
> >     struct name##_hdr {                                                =
    \
> >         __u32 size;                                                    =
    \
> >         __u32 flags;                                                   =
    \
> >         __u64 ext_flags[ext_flags_count];                              =
    \
> >         struct name payload;                                           =
    \
> >     };                                                                 =
    \
> >     static_assert(sizeof(struct name##_hdr) =3D=3D (expected_size),    =
        \
> >                   "LUO struct " #name " size mismatch!")
> >
> > For example:
> >
> > struct luo_memfd_ser {
> >     __u64 pos;
> >     __u64 size;
> > };
> >
> > DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);
>
> I think we are getting close, bu I have two remaining concerns:
>
>  * Reserving bits in each flags word for continuation leaves gaps
>    in the flag space that users have to know to skip.

Yes, but callers should never manipulate the raw flag words directly,
and we can provide simple accessor macros or inlines that take a
contiguous feature ID (0, 1, 2, ...)

enum luo_memfd_feats {
    LUO_MEMFD_FEAT_HUGETLB =3D 0,
    LUO_MEMFD_FEAT_SEALS   =3D 1,
    /* ... */
    LUO_MEMFD_FEAT_FOO     =3D 15, /* Automatically lands in
ext_flags[0] bits 0:1 */
    LUO_MEMFD_NR_FEATS
};

if (luo_ser_get_feat(hdr, LUO_MEMFD_FEAT_HUGETLB)) {
    /* handle hugetlb */
}

>  * struct name##_hdr only matches structs written by the current kernel
>    (in terms of length of array and offset of payload).

This is not an issue on the incoming path, we never cast incoming data
to struct name##_hdr or access ->payload directly. Instead, we parse
the incoming buffer, dynamically compute the header size from the
continuation bits, and cast the payload offset to "struct name *"
based on the negotiated feature flags.

>
> How about this instead:
>
> struct luo_ser_hdr {
>     __u32 size;        /* Size of header + payload in bytes */
>     __u32 nr_flags;    /* Number of features encoded in flags[] */
>     __u64 flags[];
> };
>
> Each feature occupies 2 bits of flags[], so feature N is always bits
> [2N+1:2N] of flags[N / 32], with no gaps:
>
>   00: Feature not present
>   01: Feature present, safe to ignore if not supported
>   11: Feature present, must be supported by the next kernel
>   10: Invalid
>
> The length of flags[] and the header size are computed directly rather
> than by walking continuation bits:
>
> static inline u32 luo_ser_nr_flag_words(const struct luo_ser_hdr *hdr)
> {
>     return DIV_ROUND_UP(hdr->nr_flags, 32);
> }
>
> static inline size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr)
> {
>     return struct_size(hdr, flags, luo_ser_nr_flag_words(hdr));
> }
>
> static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> {
>     return (void *)hdr + luo_ser_hdr_size(hdr);
> }
>
> and bounds checking is just luo_ser_hdr_size(hdr) <=3D hdr->size. The
> payload is always 8-byte aligned.
>
> Payload structs are then declared on their own, with no header:
>
> struct luo_memfd_ser {
>     __u64 pos;
>     __u64 size;
> };
> LUO_SER_ASSERT_SIZE(luo_memfd_ser, 16);
>
> The static_assert covers the payload to catch embedded structs changing
> size.  Asserting the header doesn't add anything since its size varies
> by kernel. And because flags[] is a flexible array, the header can't be
> embedded in front of a payload in a combined struct; it can only be
> reached through luo_ser_payload().
>
> I think the only downside is that the header increases to 16-bytes when
> there is at least 1 flag. But I don't think we need to be so concerned
> about an 8 byte difference...

I would prefer to keep the default header at 8 bytes. With 15 features
fitting directly inside the base __u32 flags word, adding the first 15
features to a struct keeps the header at 8 bytes and does not shift
the payload.

Computation-wise it is also very similar: for the 99% of structs that
have <=3D 15 features, LUO_FLAGS_CONT is 0, so computing the header size
is just a single bit test with no loop. Even if a struct ever needs
ext_flags, the loop will walk at most one or two extra words.

Pasha
