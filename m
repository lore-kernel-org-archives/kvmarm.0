Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792639976;
	b=imV/netGQLcYQJO+Mihv55zPxZlsJTH+7K9WrAIB6df96o1F/tfn6M7mCVqud0Q3uVw7
	 BkMsbu5WQCVSgLohZHsf0iA5KJCqQJO496mmTj+pcITZrEUQyZmyXPqs3woNIECCYWoJS
	 N11KvEB4hMTx+R2Uba4yPc/WO2KdkaiAlLqACRG2Gu85Jl1Nfa4K+IXcJmYQYScX2pQOL
	 qGCg5ZkWwI0Wrr7h33NfnuYCGnyNAxMDWVgJFq6Hi/rW6VVSz/DMNA6KMBUzzOCTfIFZ1
	 NHeykTShpxU0DtFd3Ze79lOcmdFJg2LnA+6MeKScI0frkWUYbVMUwVX85Hsj+s3Nymg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639976;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
	b=35Cx0i6yfuo0MYpfLnutN51Rmx7xlgIum7RAl5Ym0mPTGygUpwt9IBqrGG97xf83WSGS
	 w7hnrdcUywwp+wR+UnjBHnZ/cbln8UW9ERF0gw+7NQyW5jxT1qkZdq1Wam75Ga4S/LHEs
	 qtYUO8qA1mYOJv2zI+9OHCsOF74gwPbmA0sV7AOn0ICd9VVV8g+pg/0zULm9Um/cgYf3z
	 GXxI7KsRXnZYqfU9mmYRctZ6g76hBJBXJ4qrPQDyFS/2VCjqy/8v8Ld80OXhEu7i1epHp
	 IXUd0zdLCD6et2o9dAqE8g+JGXWy/3pBquAX4upjirqx2JZ8G/3yRg3A5W6U31nHsQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E72F606A31F
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 03:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E72F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6aa8d04fcddso1125837a12.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 20:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792639974; cv=none;
        d=google.com; s=arc-20260327;
        b=Kek7yiDZakoa3bInq5EiTYQD/OEJZFOv11j9TBZfZVM8JX30K9ZPZ0TxpBFLaABTh3
         9gQKeKUmaXTRC6UOAfpvxe934pMlvUV8HgSEpd0GgjgoXN0aYmKwh11satkdp6jnQzOd
         Itra2egN1qj9qIssyK6WQepgm/lkhLqeAis4TKZZ2iI8MxWgsB67MuVavdVOhrG4Qbnm
         RLfGieV/Ja5tThGGa7au7NN2xpPKhEZyn2ZW2H+L6eCXQuVayRa0jIRww4MHl5sdvTFd
         r33voIlbfiskSgoAZ2Wwn4a2Wir+WFCCdwQa8Skv8Q0lK0lUFOUTNTG/Y1TL3NbbpzQz
         +fwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
        fh=qzkiLjJnFnTzWQOolXAUt5sjrP7+/rqyMlyZLfXkUKY=;
        b=soZhn4TWdPLlHjVkols6iRtLppbU3nVrm10XVaO53SnUdzMEHOAbvPS8aDuP94CQkJ
         HGj006caeu5xXdogJgUC6gsGoGmHIkUWmA5FgXeyFQ5mtyKszKAv/BwCiVjHTtf5HT0F
         YbNhtoJBrFXuzBQ72G6xd/XHeIX5qqjN9V6gSh4+2Y3aRRW0/X7gzlN8Hn3fADMac/YC
         DYfldUsTc2Kr3YO5Jw0RyEUZAz86nBoHksjRR9SGbICKnfgQyGEFN4lBTvBzpDzw5i0i
         bWFGHfUBQKwEiyN/w8tgEmf4FrFDBfnDKzyvgu8P0eyDX5IjS3XqYI5j4a0MY9qrBpQ6
         MMuA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792639974; x=1793244774; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
        b=MAOdH7CWr37HRbLm+JO1m1M5MRTMBJVBuOH0TQoNB8Y+lleuCNtNLCHkW1ngrRtmat
         Z9KEO8tRxoOU6OGiG8QBG0eO3bDW7dOlK3o/SPK75c5OVf7Rdj0HksLspeExW5o94cS9
         z0ga0MmgXweKbHnxEq5WGrgtli/seV1wCzdwc+FPP+CLGurFb14MQ+KBqfrrwH6kktTx
         +DCvxcStQUyYccmp0J9wPG1MMrc1vFrIQ9L8Z7z8vV7ZUzcZdF29hZDJYOkUKpx6qhQE
         mKQOd55T+yqt088SkwSCRMchDZ1QNrbE+cCKm34flS2s/hypkUc3Tw2mkZ+DrxaJqY2k
         mGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792639974; x=1793244774;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
        b=z+j7Pu6NN9gyOnK4cliRSZL5lMEWbZHMLhb3wBaZi3hH7deoQfHxVpes4524YWmJ7b
         2d5anQes9ZTWjzpXFJiHA9g4EHSULW6212vUev6YZLChnn7zvvOneqD6y7tpT3o5V83N
         jQK0I0cb7oGyRfuisEgjU0NmnOk/RVgJ9VhMZsOjY4nUxLEbCkBqT9Yzyw68uxU+v6WJ
         gsEmNOLdZ625weZleDq6fDGQUSM2mHuEkdb5Yp+WW9V3UQu1ChDzRHJlIL88raXyR8CN
         ++QJOY5m8CTuXUFK3vLCFqWc/MpBrRjEa9N+K3lcnlRG+l+71w0r3na4VxGCQeaJXyzB
         sqfw==
X-Forwarded-Encrypted: i=1; AKwUvBz5mPD80QR8a8w2znzPrv09Xtwcoyt5F/WXKz6k1pik1jZFb47GJoqKQBTvcFx09/l0Ka3/4yI=@lists.linux.dev
X-Gm-Message-State: AFq9FYLUT+QSnlxxOTNsxuWA9UAqyvbJzX5gJ0rih/RLL8rmDLE8TwuQ
	GemQ6S0920NHPDQFcKu7wt9P5RxlJm2W8UYWvvJJFbxh6aqsMMZdx15/ZwNkfaSdHjgk69oMS1W
	a2UbKxF6Jigthmomyle8xssCzSRIhML4Lnc6qMpi+EA==
X-Gm-Gg: AYBFou2Qdrsk4c4cZGvSgPChobANN5m7rPfI1po9/Pw+MXnwdzdwNEMZOts95+GOYH2
	kF/sFWFy9XAGnPNnr6jtj3UWwmyKB9Ef9ctRRM5gCfHtU8BdGby45hDt6gGEexJPFtyTDXxvXD9
	QnsVfIiCC7C1AI8a1+e3+URmOvPoBvKu2xKSjptlru3SuE4O5I5et2jFhJoeLdOi4FkYYxN5viB
	ShfeKdUlSwv8v61S3FsS+NYrFpO8tFQuAUpoEwl78QiGspQpLqhlUh/Ka/WcLUUgVVqoJzR6Swv
	iTVzfFTe/mmRTbWODITKcVOP/gQUOuQClrE+qZCs6JX+UzDPwWTR0puka7C0ja+xfggJsBPhv1E
	51h/nW0e4YKlvZ2hmlcsVQd5wHrpz4WxFY9lpxk8IEnpeVoUT9go/Ta6ZXeR8Q3kwFvq2
X-Received: by 2002:a05:6402:2355:b0:6af:d794:4a8 with SMTP id
 4fb4d7f45d1cf-6b41d595e9cmr1157408a12.12.1792639974111; Wed, 21 Oct 2026
 20:32:54 -0700 (PDT)
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
 <atl7peoVHdP5hz7z@google.com>
In-Reply-To: <atl7peoVHdP5hz7z@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 23:32:17 -0400
X-Gm-Features: AclHuK8_AnwdTvKegXWFQaKFyzs_ctZH_O_1uRYIa-PRh8yAhLXciiK9Gp-4xIE
Message-ID: <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
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

On Wed, Oct 21, 2026 at 10:57=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@goo=
gle.com> wrote:
> > > > >
> > > > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> w=
rote:
> > > > > >
> > > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > > >
> > > > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsah=
u@google.com> wrote:
> > > > > > >>
> > > > > > >> LUO and its file handlers validate handed-over state with mo=
nolithic
> > > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to =
a serialized
> > > > > > >> structure, even an optional additive one, must bump the stri=
ng, which
> > > > > > >> breaks live update between adjacent kernels. Replace the str=
ing in
> > > > > > >> struct luo_ser with a feature header, so that the target ker=
nel can
> > > > > > >> accept or reject the source kernel state per feature.
> > > > > > >>
> > > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the seria=
lized
> > > > > > >
> > > > > > > This patch is all wrong; 128 bytes is far too large. For ever=
y _ser
> > > > > > > struct, we only need 8 bytes instead.
> > > > > >
> > > > > > NOO, It is not. It is intended to avoid complex mess with unnec=
essary
> > > > > > over-engineering.
> > > >
> > > > 128-byte per serialized struct is not starter.
> > > >
> > > > > >
> > > > > > >
> > > > > > > The first 4 bytes are the size, and the next 4 bytes are flag=
s (i.e.,
> > > > > > > 30 feature flags + 2 reserved bits for flags extension). The =
last two
> > > > > > > bits of the flags indicate whether an extended flags field is=
 present.
> > > > > > > Each extended flags field is 8 bytes, and its last two bits i=
ndicate
> > > > > > > that yet another extended flags field follows.
> > > > > >
> > > > > > If we will have dynamic extension of flags, Think about this.
> > > > >
> > > > > To support dynamic extensions in a backward compatible way you wa=
nt
> > > > > something like this:
> > > > >
> > > > > struct luo_feature_hdr {
> > > > >    size
> > > > >    flags
> > > >
> > > > __u32 size
> > > > __u32 flags
> > > >
> > > > >    extensions  // offset of first luo_feature_extensions (or 0)
> > > >
> > > > __u64 extensions[0]  --> but the size should be specificed in
> > > > declaration macro that I showed in the next patch.
> > >
> > > I think you may have misunderstood what I meant. In my proposal,
> > > extensions is an offset to the first extension, not an array of
> > > extensions that immediately follow the header.
> > >
> > > If the extensions immediately follow the header, then the number of
> > > extensions is baked into the struct layout. Every field after them si=
ts
> > > at an offset that depends on how many extensions there are. If we eve=
r
> > > need one more extension, all the fields shift and old and new kernels
> > > can no longer read each other's struct. That is the problem Tarun
> >
> > We can structure it cleanly by nesting the payload: something like
> > struct { struct header {...}h; struct serialize_data { ... }p; };
> > That way, the header can expand dynamically at the front, while all
> > fields inside `serialize_data` stay at fixed offsets relative to the
> > start
> > of the payload.
> >
> > Since the header size is self-describing via continuation bits (e.g.,
> > the last two bits indicating whether another flag word follows), LUO
> > can
> > easily compute where the payload begins in the incoming blob. This
> > keeps the implementation simple, avoids linked lists of offsets.
>
> Oh interesting. I agree a dynamically sized header at the front can work
> and is simpler than a linked list.
>
> So the header and the payload need to be separate, and the payload is
> located with pointer arithmetic on the header. For example:
>
> struct luo_ser_hdr {
>     u32 size;    /* Size of the payload in bytes */
>     u32 flags;    /* Bits [31:30] indicate an extension word follows */
>     /* u64 extension words follow while the continuation bits are set */
> };
>
> /* Size of the header, including any extension words. */
> size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);
>
> static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> {
>     return (void *)hdr + luo_ser_hdr_size(hdr);
> }
>
> On preserve:
>
>     hdr =3D kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(*ser=
));
>     luo_ser_hdr_init(hdr, sizeof(*ser), ...);
>     ser =3D luo_ser_payload(hdr);
>     ...
>     args->serialized_data =3D virt_to_phys(hdr);
>
> On retrieve:
>
>     hdr =3D phys_to_virt(args->serialized_data);
>     err =3D luo_ser_hdr_validate(hdr, ...);
>     if (err)
>         return err;
>
>     ser =3D luo_ser_payload(hdr);
>
> What would size mean in luo_ser_hdr? The size of the payload or the size
> of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing so
> maybe it's just the size of the payload?

> What would size mean in luo_ser_hdr? The size of the payload or the size
> of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing so
> maybe it's just the size of the payload?

Either works, but having size cover the combined hdr + payload
provides a few extra guarantees:

1. A single static_assert validates the entire serialized struct at
compile time, including the header and the number of ext_flags
elements.
2. Bounds checking while traversing the header continuation bits on
retrieve: we can sanity-check that luo_ser_hdr_size(hdr) <=3D hdr->size
so we never walk past the end of the serialized blob if there is
memory corruption.

If we declare the payload struct separately and pass it into the
macro, handlers also get a clean type for luo_ser_payload(hdr):

#define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_type)=
 \
    struct name {                                                          =
 \
        __u32 size;                                                        =
 \
        __u32 flags;                                                       =
 \
        __u64 ext_flags[ext_flags_count];                                  =
 \
        payload_type payload;                                              =
 \
    };                                                                     =
 \
    static_assert(sizeof(struct name) =3D=3D (expected_size),              =
     \
                  "LUO struct " #name " size mismatch!")

For example:

struct luo_memfd_payload {
    __u64 pos;
    __u64 size;
};

DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);
