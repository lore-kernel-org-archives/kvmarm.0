Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792641189;
	b=alWUSr8kJQzjBdQGWITWaZoV1q94YEw+Oabj5vzs0Qh3LQZnJLTplu1HERGBVIJZfhgV
	 BR9Yjn/jwdQY9MH0uhA7CTg9hfyq9YG2B2a8aDsLGQa5rQvmpt4drki+d4akZnJD24tR1
	 zEAP3JDjnkQPpa6r5QGpS0uBEEXJYOfb+kRv7j2izkXJPny7jxsE3hGS0VK66ZM+XpVfc
	 ppbOixhU7zzr1Q4rS1MlyndNhQz5gLFI6k/ztgCVpD53lmBeUbcviz7qYMd+8BeTRaGIk
	 76SVJqvcpnV5OLCn/UsoPnupUyLgbywudWsmpdIB9Zv3ydIk1h+OqYIQgw2ov8nsLQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792641189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
	b=wwICGIRD2G0V1V4X2c4UGfrfCu5XKxmMJjjeoVv6cr0TKVGzAZTsuYGbMD0APMP67uaK
	 wZQhkutwD9rsheBbWrdYjjWdCEVmZzhWB2/Fm+3OBkvuvAm7xp+3nDaQ2MjeqKA9naI4V
	 yhIk/zA+3VDVSEDt9taidXXpNlSga91xnxkpt0ssFAYMygaoKV1fZ0khTcEvk6ZmkQVVf
	 sM6V81zzgmySAO/JztnmMAblWLnQFqaWc3C6Z4lnZbmxpkKtQ4N63AaS+gqIMkG2pvcVv
	 sxlOqQ5mP3XHd1Gqx7SxPtCzz6s9exIZqAIxd5SLFXFfDkN39H6yrrQSeZ7LlolMYUw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZsLxY9BP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBDF606A31B
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 03:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDBDF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZsLxY9BP
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c3fd91337baso198845866b.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 20:53:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792641187; cv=none;
        d=google.com; s=arc-20260327;
        b=iH7RqL0CCXLQ6fXIsPFQEcKiYgiUW3hiha9kZp2VMgNAdesEAXccjHQevRjMi6sqKT
         IsjGUhFsdFyos6yuqPFA2qfwvl6V+tzIOnPTRAYoRWCKnwR0AZBsxKK4/IY0WcFG0Adl
         N9Bi9VzjREKZUy/CN5G7X1TxHqZBBqPQ5kcq/rAD1XvhAgC73vsAmTYEPtCfj1bTIbDA
         2cBGZ81EutK06NCT++I9AHe9cIhBVXapaUtLO2y7NOUdaEcQc3PtfCjnm8HX5UVOJlO8
         CVcterr9eNUMQILbvJVC+hMbHpvAOY4xuTdZg1acNi5i/Rgz4V37kMlmzYQ2WG8D+xqV
         fvzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
        fh=qBInSPqKtdxzQMqfjeyOZ480h54b6wvlc//6u6JTxTY=;
        b=Ca3VK6nmuiaMBzwmIivg7KGHiv09ErfzLPuesxrHRYd0UK462AnTaS5/FAH4Ze1NJV
         qcym5zKcZrY5Tnmd3G9j0bbdX3B8TuITYLNA5aEPF+JQf74Sbiz83rsfI3CnqlnqCipw
         TXCWNw3trQwoBJNgPzQFS0OJdvecLMdKDmfKfraygyjRdk1JnSIs6R2M/8Jk4TazMD72
         X62OFde0q0F6abG7GSQ2HDJVU67VA/sZFi5zoxd/IXF6g9cRyXFSihLN0T6n58sPfk4q
         e33jFMBLeiCUiknSpVYYQs5jKwZpqsRVbdkJsTDxIS+m03rcWXbv7Nl6BLd54DAhvxTz
         WizQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792641187; x=1793245987; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
        b=ZsLxY9BPtW4SjliSWDxCTvfeSt2P3TTGpb0qR1/+occkuS4ETmzDV+IVxsz5+QDpbV
         QbKMGFe2q8M59Z9sSxB2+U1CywA/hrO79PYZbsNVOwlfKAHlNje09iegkJqfyto5pzCm
         DYtZm2OOmkv1l9YCvY6PDMeR4ckcdCP9dBeILnbm6wpIIokkWtsvrJZpQAG4v4u0oXRt
         mCC9x5BIHFaqFXTpVq2U5OwPZgDBR4XSqLs5xMhPZA3eEje5N65+qO4GrVevB5UVoxsO
         dCXZwHhsotQ17xn46318NYwIUldJtf2nHWYWpPt51VAANiXOgCV0nXyvfiFLqRPc7umB
         mYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641187; x=1793245987;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
        b=xbUm+59ops/S2jGkFKQsGuliI5f8BOuIbgdL0v7ByCwnvJbxI6S1N5aY9ilrnYOs0X
         mmYANDu2SmvgqIv9gmarfPfvzsT5+OTb5zTJrO+28alUrm+VG31BEGgK1PXSaEGcYoJ+
         1bUMSIw0lgYP0MQP8lY+0Zw5BOuNLI55skDUOO385cW2bA8cuFYoCQoit/0wVqeHxk0i
         qDtnyyGLX9aUUKzUleeKQUjTzMd/iV7qvOj+1Yw7hKUAxHcDet0F/LqxEZeGJFLT5hzl
         w7U41eL6oeikQuQ0+RiHlPttKCRYXofTUrCDKfU/UcQoaTzQZHLnq50+mTZkxa/EOBhA
         u4Og==
X-Forwarded-Encrypted: i=1; AKwUvBzN9JZHo9ZNdKDTPiw0VkE7GHBJLfs/yagCRvFXUERQEkREavsn3G4gATiaA1+4vgGvFGVyzgY=@lists.linux.dev
X-Gm-Message-State: AFq9FYKVDxYvneldaxbM6ukec3BfgVuQGsmDxWF/8S6JAqpJfi1CYqL9
	mpbn+w2+XVyRpTms9YM5e4c/kWIhgUYl/kevGbZS/AvpkO9o4Jvmm/kxGwOvXHvNQPS5iY+ksXG
	DX8dLYMhJoiKyT++veMouMgYd1l7iw3Os2I+cvGpn
X-Gm-Gg: AYBFou1Kcj7NtXe1Urc+CR1uvlkNcFloWcUqy+RkLNoaPwdPnTwlYwieCIBUdDQUUw5
	8wbaaGSifouWEFYzwrVLhQTS1IdzUtLoYr5r+P+YHOlAWMkMQBr68OHe1sSMlj6wbwpkT2i0RII
	RCWycLnJsL57D0JArfmof24zSRSq/NAmSYxyJEod4YdfwSYve0sBe4CRcxrJVIEhFE4D+om7IE2
	gDyGXMGV2AJzjDSx5R3aQrUUNCpDx4rPAMj3Iu9Ms+gDA6l3DvlmSjSLmHONv7a0GKKNIPsNYRw
	E3QdJ49A72joXuAf6TMkztDBWYl1QOH846B75HTsr/HwWaB3ONNzRjHilG1LVxz4BWvdKWpU9o8
	IunZYElZWp6e5TPwL701PBxolYsrreycrlSv1gw==
X-Received: by 2002:a17:906:dc89:b0:c40:f9ea:7387 with SMTP id
 a640c23a62f3a-c46791a979emr355026566b.6.1792641186777; Wed, 21 Oct 2026
 20:53:06 -0700 (PDT)
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
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
In-Reply-To: <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 21 Oct 2026 20:52:39 -0700
X-Gm-Features: AclHuK_94mheSr-cOV0RjUmA5boG8AcWT7XfL_o8Cm1BzPA_mpTiDbYCVzKwGVg
Message-ID: <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Pasha Tatashin <pasha.tatashin@soleen.com>
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

On Wed, Oct 21, 2026 at 8:32=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Wed, Oct 21, 2026 at 10:57=E2=80=AFPM David Matlack <dmatlack@google.c=
om> wrote:
> >
> > On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> > > On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@googl=
e.com> wrote:
> > > >
> > > > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > > > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@g=
oogle.com> wrote:
> > > > > >
> > > > > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com>=
 wrote:
> > > > > > >
> > > > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > > > >
> > > > > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <taruns=
ahu@google.com> wrote:
> > > > > > > >>
> > > > > > > >> LUO and its file handlers validate handed-over state with =
monolithic
> > > > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change t=
o a serialized
> > > > > > > >> structure, even an optional additive one, must bump the st=
ring, which
> > > > > > > >> breaks live update between adjacent kernels. Replace the s=
tring in
> > > > > > > >> struct luo_ser with a feature header, so that the target k=
ernel can
> > > > > > > >> accept or reject the source kernel state per feature.
> > > > > > > >>
> > > > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the ser=
ialized
> > > > > > > >
> > > > > > > > This patch is all wrong; 128 bytes is far too large. For ev=
ery _ser
> > > > > > > > struct, we only need 8 bytes instead.
> > > > > > >
> > > > > > > NOO, It is not. It is intended to avoid complex mess with unn=
ecessary
> > > > > > > over-engineering.
> > > > >
> > > > > 128-byte per serialized struct is not starter.
> > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > The first 4 bytes are the size, and the next 4 bytes are fl=
ags (i.e.,
> > > > > > > > 30 feature flags + 2 reserved bits for flags extension). Th=
e last two
> > > > > > > > bits of the flags indicate whether an extended flags field =
is present.
> > > > > > > > Each extended flags field is 8 bytes, and its last two bits=
 indicate
> > > > > > > > that yet another extended flags field follows.
> > > > > > >
> > > > > > > If we will have dynamic extension of flags, Think about this.
> > > > > >
> > > > > > To support dynamic extensions in a backward compatible way you =
want
> > > > > > something like this:
> > > > > >
> > > > > > struct luo_feature_hdr {
> > > > > >    size
> > > > > >    flags
> > > > >
> > > > > __u32 size
> > > > > __u32 flags
> > > > >
> > > > > >    extensions  // offset of first luo_feature_extensions (or 0)
> > > > >
> > > > > __u64 extensions[0]  --> but the size should be specificed in
> > > > > declaration macro that I showed in the next patch.
> > > >
> > > > I think you may have misunderstood what I meant. In my proposal,
> > > > extensions is an offset to the first extension, not an array of
> > > > extensions that immediately follow the header.
> > > >
> > > > If the extensions immediately follow the header, then the number of
> > > > extensions is baked into the struct layout. Every field after them =
sits
> > > > at an offset that depends on how many extensions there are. If we e=
ver
> > > > need one more extension, all the fields shift and old and new kerne=
ls
> > > > can no longer read each other's struct. That is the problem Tarun
> > >
> > > We can structure it cleanly by nesting the payload: something like
> > > struct { struct header {...}h; struct serialize_data { ... }p; };
> > > That way, the header can expand dynamically at the front, while all
> > > fields inside `serialize_data` stay at fixed offsets relative to the
> > > start
> > > of the payload.
> > >
> > > Since the header size is self-describing via continuation bits (e.g.,
> > > the last two bits indicating whether another flag word follows), LUO
> > > can
> > > easily compute where the payload begins in the incoming blob. This
> > > keeps the implementation simple, avoids linked lists of offsets.
> >
> > Oh interesting. I agree a dynamically sized header at the front can wor=
k
> > and is simpler than a linked list.
> >
> > So the header and the payload need to be separate, and the payload is
> > located with pointer arithmetic on the header. For example:
> >
> > struct luo_ser_hdr {
> >     u32 size;    /* Size of the payload in bytes */
> >     u32 flags;    /* Bits [31:30] indicate an extension word follows */
> >     /* u64 extension words follow while the continuation bits are set *=
/
> > };
> >
> > /* Size of the header, including any extension words. */
> > size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);
> >
> > static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> > {
> >     return (void *)hdr + luo_ser_hdr_size(hdr);
> > }
> >
> > On preserve:
> >
> >     hdr =3D kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(*s=
er));
> >     luo_ser_hdr_init(hdr, sizeof(*ser), ...);
> >     ser =3D luo_ser_payload(hdr);
> >     ...
> >     args->serialized_data =3D virt_to_phys(hdr);
> >
> > On retrieve:
> >
> >     hdr =3D phys_to_virt(args->serialized_data);
> >     err =3D luo_ser_hdr_validate(hdr, ...);
> >     if (err)
> >         return err;
> >
> >     ser =3D luo_ser_payload(hdr);
> >
> > What would size mean in luo_ser_hdr? The size of the payload or the siz=
e
> > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing s=
o
> > maybe it's just the size of the payload?
>
> > What would size mean in luo_ser_hdr? The size of the payload or the siz=
e
> > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing s=
o
> > maybe it's just the size of the payload?
>
> Either works, but having size cover the combined hdr + payload
> provides a few extra guarantees:
>
> 1. A single static_assert validates the entire serialized struct at
> compile time, including the header and the number of ext_flags
> elements.
> 2. Bounds checking while traversing the header continuation bits on
> retrieve: we can sanity-check that luo_ser_hdr_size(hdr) <=3D hdr->size
> so we never walk past the end of the serialized blob if there is
> memory corruption.
>
> If we declare the payload struct separately and pass it into the
> macro, handlers also get a clean type for luo_ser_payload(hdr):
>
> #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_typ=
e) \
>     struct name {                                                        =
   \
>         __u32 size;                                                      =
   \
>         __u32 flags;                                                     =
   \
>         __u64 ext_flags[ext_flags_count];                                =
   \
>         payload_type payload;                                            =
   \
>     };                                                                   =
   \
>     static_assert(sizeof(struct name) =3D=3D (expected_size),            =
       \
>                   "LUO struct " #name " size mismatch!")
>
> For example:
>
> struct luo_memfd_payload {
>     __u64 pos;
>     __u64 size;
> };
>
> DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);

This looks pretty reasonable but I would name the payload
luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
should never be used directly since the offset of the payload in that
struct is only valid in the current kernel. So I would give that
struct a special name that makes it obvious you shouldn't be using it.
