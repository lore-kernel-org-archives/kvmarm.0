Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792637867;
	b=bx1wcoY3PrI+s0QTpgoP+OACVX20k77Q1eiUko85JjSFjQTyvnfFIeAJaXkC/yvuQ3f6
	 1ejHaDwQciEfNJwtxin2flhS+8ZBSzcAd7CXFN+mvFkLg9qSNLwFzhzhMtfu5aCyT8RwF
	 bEO9UWKk/pVCk0M2t2/z1OugnEgA5sf6r2erTg+acq9C9Ui0k4Nks7KBwL43N64SXXLzd
	 mAIKQ0n8Ar5dtWGUsggqm8eJ0BX2cbtNjJBHYAZgTh7mdFGq6V01ng9BhPMEL07L9mJE2
	 rajq4ED3EqxTYmXK5JnT5TcYK16EEwZjVB0t1uE1bcbahkb9bD9PNnhxsjbP6ZC29rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792637867;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=9EhJunI31x30V5twb29p5JvXR/ZnOh8avGc16eTeBG0=;
	b=sxgLCSmiuyWSZH6NUg2UUMaqljcn5nFSPfBLcze4HVMPln2UBD0kGwBBhhKStBpw7eqY
	 QVm8ABulKM5O5nLKxuplkwxHMjrqGuaX0Yr/HKfKB/aC1Y9W4TmvLtWrUpgXZsztis9Uh
	 bKgtdpe8o6832Jfte8TdITiHEaZp2VGM3eO55aeuonSmaHGwk0YRkzlGFHzZ0Xocon7eZ
	 J8tIJyZpjLYA0HxaqJuaiWSNStzFzpFz/4V3Uu77wC2GBHHD2mvptjRRdJVHafpSVjwQC
	 pRV+ZsV0SsoFUBsKFSHI1lwmC7NV37NvshETR13sAPlQPwYLBp0+bq7fGiQi/1QfOLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=hos3tnLO;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C8F606A321
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 02:57:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94C8F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=hos3tnLO
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4b1f7e8f4so534384a12.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792637866; x=1793242666; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9EhJunI31x30V5twb29p5JvXR/ZnOh8avGc16eTeBG0=;
        b=hos3tnLOFDTILPkqaLcWcGCkCVDk8LrxUIKOaQAu8pYx3b+hb9cDcwmLTDANMJw/gA
         nRdZQbOdM+LnZXSk9OxBAdo8uioy9aE0f3zSlmtmPa2itvIZEWe4IK64NaVUAExNBLXe
         qae7/BwEZAifiF2+Gi9WLqyisDE1y4MhbKUkVGBDHhExXplVHOFobDx4ubGsoUGlrOfy
         hdXncyIbC2lBqo9SKgArgUSWXDcPYGsLGIt6ZE7Wg8QkZcWbDeubxeXHM2XdSYVXfoXO
         7HBPQJmsFKp4gcj2JuB6YvtUoySQcggHJPuhv244MUlnnir/ZkPMAsdxHrG2JIxdEWl8
         apcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637866; x=1793242666;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9EhJunI31x30V5twb29p5JvXR/ZnOh8avGc16eTeBG0=;
        b=GnYFc+ja/B7ZXzwto4XtQOpXMcY7mjj3qgIvGNMLpV0NiWDD86nuwMh+jDINM89ZeM
         tmf7kEAhDfo9vp1W+hZKNLd7l2EXKLUFwHwexVx+fsUQT1e6qAwOVWCSLcuTxBKBqOv7
         qmGIberNTeRZxvNXjecgwDtvLy8MOlpAuX84UV1+vdt1DR6OKds/J92ODb8lyn33PTYt
         kJHqCsQbtF6heGcQv3qOZwzlJSMHF8VkZ+iC4Q1Vglt/kvWFH7TUjFH7wtbxNQnF2Dnf
         2GrDJGhzTmb3t7IoZxLVvXA+MUPhlO3S1wLbI5kB8hTmpS8fu6UrtARQcZsSFpswolGP
         5pDA==
X-Forwarded-Encrypted: i=1; AKwUvBxhWjRsxi4seFMqA3SDCjqv0h08n01nYBAWu9Snpf8G0BbahNvOg7wE5K7n/1KEiOiMez00TQY=@lists.linux.dev
X-Gm-Message-State: AFq9FYIyb30eAy+skA/o1b4ZB7W6zfOTaKZLkO2UcSB5P+OM2mOX8qH3
	F5WH0OYo2m8IURoCUSAw0Fgf2FAKdnbdnF3sl8i+jBMDw9QuPn1UwW2F4pX1mLcODw==
X-Gm-Gg: AYBFou25379rHM67aQHUo4yUW06bp3ztjKDi0Z1gq6qTnXciMy8MHlFN1nWA7F1yriJ
	AqOa1lHW1i0A6Vu1WiDaNrFIM+shCGq02us7d72iRv92/Y89s36CqR51hBjAoLNFeB0Dx18Axfg
	E8T16EKaVCoRuUCZ8UgOyi/qoSb/Imi8DvjzX8hi3q4p3Lv+m04jmK0Dk5xWOlSJWp8/7/eut9w
	9wBP7oqXar90bmflXEGK4zCAPhYsprgD99T8ErQbdoKeM6uJds/KRHk+5uh4dyTtOBW50ehGo8g
	ImNJEmVmS5q3rctWkJH4CEoH5C65H2eLxnZqeNdUdkPJtRlDrCcOkCXYdU+w1Nj49b+n8ZEBOP+
	sU7ytx2v/BuUdz8FbF//0QG40s7OqlipC1gbTD8FIHz98v/uDDqJxmhqeBdBVoZ2kOeA30SYr/L
	4kA5NfgV+b1/9Vc37d14zFkfZFI2UX6iGmnyRylXpz2Nv9DAjznJW0whcbsc6pmMGr+imugk1tH
	/ZOMLcW1CrFKmuaNGRNOs2Vmz8Hexvp2gq7mIjjL63wW+AztPCFDJ5/pVJr2RZ3CFy6u53f/idT
	Zcnlu+QEjVewLaqA
X-Received: by 2002:a17:90b:3ec8:b0:3ac:adce:60ad with SMTP id 98e67ed59e1d1-3ad86e96c9emr2886416a91.22.1792637865925;
        Wed, 21 Oct 2026 19:57:45 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada495315dsm2092370a91.15.2026.10.21.19.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:57:45 -0700 (PDT)
Date: Thu, 22 Oct 2026 02:57:41 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>,
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <atl7peoVHdP5hz7z@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com>
 <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>

On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 7:28 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > On Wed, Oct 21, 2026 at 2:47 PM David Matlack <dmatlack@google.com> wrote:
> > > >
> > > > On Wed, Oct 21, 2026 at 11:40 AM <tarunsahu@google.com> wrote:
> > > > >
> > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > >
> > > > > > On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> > > > > >>
> > > > > >> LUO and its file handlers validate handed-over state with monolithic
> > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> > > > > >> structure, even an optional additive one, must bump the string, which
> > > > > >> breaks live update between adjacent kernels. Replace the string in
> > > > > >> struct luo_ser with a feature header, so that the target kernel can
> > > > > >> accept or reject the source kernel state per feature.
> > > > > >>
> > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > > > > >
> > > > > > This patch is all wrong; 128 bytes is far too large. For every _ser
> > > > > > struct, we only need 8 bytes instead.
> > > > >
> > > > > NOO, It is not. It is intended to avoid complex mess with unnecessary
> > > > > over-engineering.
> > >
> > > 128-byte per serialized struct is not starter.
> > >
> > > > >
> > > > > >
> > > > > > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > > > > > 30 feature flags + 2 reserved bits for flags extension). The last two
> > > > > > bits of the flags indicate whether an extended flags field is present.
> > > > > > Each extended flags field is 8 bytes, and its last two bits indicate
> > > > > > that yet another extended flags field follows.
> > > > >
> > > > > If we will have dynamic extension of flags, Think about this.
> > > >
> > > > To support dynamic extensions in a backward compatible way you want
> > > > something like this:
> > > >
> > > > struct luo_feature_hdr {
> > > >    size
> > > >    flags
> > >
> > > __u32 size
> > > __u32 flags
> > >
> > > >    extensions  // offset of first luo_feature_extensions (or 0)
> > >
> > > __u64 extensions[0]  --> but the size should be specificed in
> > > declaration macro that I showed in the next patch.
> >
> > I think you may have misunderstood what I meant. In my proposal,
> > extensions is an offset to the first extension, not an array of
> > extensions that immediately follow the header.
> >
> > If the extensions immediately follow the header, then the number of
> > extensions is baked into the struct layout. Every field after them sits
> > at an offset that depends on how many extensions there are. If we ever
> > need one more extension, all the fields shift and old and new kernels
> > can no longer read each other's struct. That is the problem Tarun
> 
> We can structure it cleanly by nesting the payload: something like
> struct { struct header {...}h; struct serialize_data { ... }p; };
> That way, the header can expand dynamically at the front, while all
> fields inside `serialize_data` stay at fixed offsets relative to the
> start
> of the payload.
> 
> Since the header size is self-describing via continuation bits (e.g.,
> the last two bits indicating whether another flag word follows), LUO
> can
> easily compute where the payload begins in the incoming blob. This
> keeps the implementation simple, avoids linked lists of offsets.

Oh interesting. I agree a dynamically sized header at the front can work
and is simpler than a linked list.

So the header and the payload need to be separate, and the payload is
located with pointer arithmetic on the header. For example:

struct luo_ser_hdr {
    u32 size;    /* Size of the payload in bytes */
    u32 flags;    /* Bits [31:30] indicate an extension word follows */
    /* u64 extension words follow while the continuation bits are set */
};

/* Size of the header, including any extension words. */
size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);

static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
{
    return (void *)hdr + luo_ser_hdr_size(hdr);
}

On preserve:

    hdr = kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(*ser));
    luo_ser_hdr_init(hdr, sizeof(*ser), ...);
    ser = luo_ser_payload(hdr);
    ...
    args->serialized_data = virt_to_phys(hdr);

On retrieve:

    hdr = phys_to_virt(args->serialized_data);
    err = luo_ser_hdr_validate(hdr, ...);
    if (err)
        return err;

    ser = luo_ser_payload(hdr);

What would size mean in luo_ser_hdr? The size of the payload or the size
of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing so
maybe it's just the size of the payload?
