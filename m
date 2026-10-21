Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792625335;
	b=dbYqfknPKhWLcTb94pKNNgpri/X8P9qK3Aspj9ucRwb/26vOfNZGHgXQT10/G1uBUxOa
	 NOv+Z+ofElM34p3eHj9eO1sfGiY60km0AcrzP9VlhRjj6ALRfziHk6zXdS4Vjzu9P03u3
	 9qC+f7BJdfPsDcrq3fdom/JDz671EMGa9OY57++JVz5D55P0w6WCrzR4MH1QiDwg+wAsb
	 5HVHThzUUoTrjvOtQcEx+rRZTy6BTeutzUMRhRw6GVWXq2uoricS8McoSA/uXp4+MtK8d
	 idh1D+tITJD5W9OomaYVW0Y/JuPATnf8s4AHMHnqhfvleTlS8vlGG6qCcyg2c5F1zRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792625335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=j1gtu/2ECGchElAdjQsJmcTzWPpoWAuSh1B1l3W6hUU=;
	b=mMiEoaVz8PsFd5WJM1HJ2va5a2sai23MfBoT8xxJswvqkjTGouTc5Ho27MYHn1krPvGQ
	 DUZGH7Rt5WimZq8bGTkaWLBOJjmJMnSlYD8JzV2WvkIUxiIdydfPA1qWXXE7RUd/9ZDAL
	 KT+RyhdNHPUG9AobigPcpHc5WgFLwkYUehqCBq2+OBTckZ8KCyIGWWQZIyKD38JrJuTWr
	 cwDOQqh9HorRAUHpLEC2L7UuHfn/49GxwsCpm9299nZtdvEWjHxggQCP4neVfyU00ys1y
	 K3LGH4Ue3W/PdlcEH2iWVpPX+nxiYqL6b8l0wCOPiaOGH16zkt5Kk4WWtbVkg7n12Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=YUCZi4LO;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17904606A31F
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17904606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=YUCZi4LO
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ccce6d9abfeso735744a12.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792625334; x=1793230134; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j1gtu/2ECGchElAdjQsJmcTzWPpoWAuSh1B1l3W6hUU=;
        b=YUCZi4LOA7RH/48y0hWgxZwp7PlxCi36ZdebY/Ku/CyAofuNZdMHO8xdSYudRDvDc5
         mgO2rK6IkQ5HmGIoKkDdSn9gggqIRzy8a3EkaHBRxTBvYqOg6hFBajoy8FP0N9MjDfEI
         WO5PN1HlXYsAAuvg+y9BzjzDbBHQH7F+oto4kNtsZuTET2ZmO4ImqaY6mhWkwrvQv3u1
         ZJH+sxTD+QsPgZoJHAYxBub0yFQ4OaqoS3cP6q2/YM18AHcMTGEPSm6Rp7rdsAOSFTZl
         b87FghollJ4S0V9OH8tOghaoP1bayw/qetUXnfQfvcr1XNZZ576rvV87Al9He0UERtvE
         vbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792625334; x=1793230134;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j1gtu/2ECGchElAdjQsJmcTzWPpoWAuSh1B1l3W6hUU=;
        b=ECOjQqzrhk15cQ/Z0x1mDNu5Pjz/UFXPE/2WXBkOj1zA615Gk/NR0UmECflej7P2Rl
         CI3ZGl2ou7V5Kx0JJ22lgpOllmOhFmim6h27h5qt4mJLRIScwT5HN82g7x7YzG7M0pNs
         VSF1VdrRbll3z9dTwCGz43rr6H5sJFW3zyutDfz7KB8CLFMzJRlNdoH9dVbgJnYzRK0o
         Vtsp+3kE3D5kMPVQBMBtJmToCIea2iOr7bi4z+8vhu0aP8TRusIKeV+N0M9iUph1eCWh
         SyYVoJ+ZH8nTfXOgl0r32GJMp0hcdswf9VbVjD9AWZBRLaCOsgrwgEcKacjoldC1BW+S
         GBgA==
X-Forwarded-Encrypted: i=1; AKwUvBwK4mnsg5qCprENu8GFXttqeZItXhhKRY+et76LfUf5zQHVXdeIxqHBaYdaoLUAjUM0rhNdsx0=@lists.linux.dev
X-Gm-Message-State: AFq9FYL00OilmGqQg6Vli0XAc7djh8kcTwiuRXYDz9/gmySBtMtyCDCi
	oPO7juwRCy+jSFLLJHoO9BIc0E9s+iNUdkOz4FwQF4dQ7tJS33QzYMe4v1W6LY9GwQ==
X-Gm-Gg: AYBFou3pldDJZqDwkOa9ngm3T0YBIgpuIkBA6TmM+cLfnEmB/luadDwuBfZLqq4BR/x
	NK0ricj1TXfmfFtwmNFCs4KUTLL9CCmuiJckNXWcoTjKCrirP9HciYCLzjf2k8S2tRgkZ4S7QD4
	OgxATPCB+y29eKrrEemgkZfUzNtgJ+zvtYEhypgKhOlDcL5ohNKCeXjlZ8s2W6t9Ghk6QtKuDSp
	odGLBeNrJunniQBeefHEvC7ino1Ve/KeU+Rzuf+O7cQuGBbZ2T75ePSGcEp5VAeRc9sEFF/q9rY
	aedZ2FUiG9twx1ohr1UgPxz3m17X7F5X69EVUXKglmlnD9/vwM7OwnqPai229ozhKYdUP0zXWi3
	gICw7+a0SMklvXaEh7bJR3lqY8yNjlB+X12n7DfAgRHoD0ARi3q1IhyTZpLhUKzGkaikm7EUnjD
	0UiBoLLxixJ3gbXS0iwcwL3wvTqmA05rdKYZ0agBE/1Uh21z8AOzQISMOGfaFD0GkFPtrQTrJ/0
	o0nIt519Mm3LPRDrEB9TIfHEx6yuy6Hw+b47f0FQUNnIfQp/m+CUWVREcvpBruWgWbRh/5QU6cn
	Ob86if8efZzteS5m
X-Received: by 2002:a05:6a00:448b:b0:88b:7278:ebf4 with SMTP id d2e1a72fcca58-8a089dc6e77mr2781314b3a.18.1792625333734;
        Wed, 21 Oct 2026 16:28:53 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a08933aec9sm1368611b3a.2.2026.10.21.16.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:28:52 -0700 (PDT)
Date: Wed, 21 Oct 2026 23:28:48 +0000
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
Message-ID: <atlKsD-aJB3mJr2j@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com>
 <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
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
In-Reply-To: <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>

On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 2:47 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Oct 21, 2026 at 11:40 AM <tarunsahu@google.com> wrote:
> > >
> > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > >
> > > > On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> > > >>
> > > >> LUO and its file handlers validate handed-over state with monolithic
> > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> > > >> structure, even an optional additive one, must bump the string, which
> > > >> breaks live update between adjacent kernels. Replace the string in
> > > >> struct luo_ser with a feature header, so that the target kernel can
> > > >> accept or reject the source kernel state per feature.
> > > >>
> > > >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > > >
> > > > This patch is all wrong; 128 bytes is far too large. For every _ser
> > > > struct, we only need 8 bytes instead.
> > >
> > > NOO, It is not. It is intended to avoid complex mess with unnecessary
> > > over-engineering.
> 
> 128-byte per serialized struct is not starter.
> 
> > >
> > > >
> > > > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > > > 30 feature flags + 2 reserved bits for flags extension). The last two
> > > > bits of the flags indicate whether an extended flags field is present.
> > > > Each extended flags field is 8 bytes, and its last two bits indicate
> > > > that yet another extended flags field follows.
> > >
> > > If we will have dynamic extension of flags, Think about this.
> >
> > To support dynamic extensions in a backward compatible way you want
> > something like this:
> >
> > struct luo_feature_hdr {
> >    size
> >    flags
> 
> __u32 size
> __u32 flags
> 
> >    extensions  // offset of first luo_feature_extensions (or 0)
> 
> __u64 extensions[0]  --> but the size should be specificed in
> declaration macro that I showed in the next patch.

I think you may have misunderstood what I meant. In my proposal,
extensions is an offset to the first extension, not an array of
extensions that immediately follow the header.

If the extensions immediately follow the header, then the number of
extensions is baked into the struct layout. Every field after them sits
at an offset that depends on how many extensions there are. If we ever
need one more extension, all the fields shift and old and new kernels
can no longer read each other's struct. That is the problem Tarun
pointed out. So in practice the number of extensions is fixed forever
when the struct is first declared, and we have to guess up front how
many features a struct will ever need. That's the same as Tarun's
128-byte header, just with a smaller guess.

What I'm proposing is a linked list of extensions, where each link is
an offset from the start of the struct. A new extension is never
inserted into the middle of the struct. It is appended at the end along
with the new fields that need it, like any other new field, so existing
field offsets never change.

Something like this:

struct luo_ser_hdr {
	__u32 flags;
	__u32 next;    /* Offset of first struct luo_ser_ext, or 0 */
};

struct luo_ser_ext {
	__u32 flags;
	__u32 next;    /* Offset of next struct luo_ser_ext, or 0 */
};

That's the same 8 bytes as your proposal. And because "is there an
extension" is next != 0 instead of reserved flag bits, all of the flag
bits are available for features.

For example, a struct starts out like this:

struct foo_ser {
	struct luo_ser_hdr hdr;        /* hdr.next = 0 */
	__u64 a;
	__u64 b;
};

Over time we add features and fields until the header flags run out.
Then we add one more feature, FOO_FEAT_C, which needs a new field c:

struct foo_ser {
	struct luo_ser_hdr hdr;        /* hdr.next = offsetof(struct foo_ser, ext1) */
	__u64 a;
	__u64 b;
	/* ... fields added for features in hdr.flags ... */
	struct luo_ser_ext ext1;    /* ext1.next = 0 */
	__u64 c;
};

- a, b, and every other existing field stay at the same offsets. Both
kernels can keep casting the KHO memory directly to struct foo_ser.
No memcpy() or variable offset math.

- An old kernel that knows nothing about ext1 can still find it by
following hdr.next, because the chain describes itself. So the old
kernel can still reject the struct if ext1 has a required feature it
doesn't support, and ignore ext1 otherwise.

- A new kernel receiving the struct from an old kernel sees
hdr.next == 0. It treats every feature in ext1 as absent and never
touches c, so it never reads past the end of the old, smaller struct.

The only rule for subsystems is that a field can only be accessed after
checking its feature, which a LUO helper can do by walking the chain:

if (luo_ser_has_feature(&ser->hdr, FOO_FEAT_C))
    c = ser->c;

If we keep size in the header, this is where it would be useful: LUO
can check that every next offset is within size and strictly increasing
(so there are no loops) before walking the chain.

> 
> > }
> >
> > struct luo_feature_extentions {
> >     flags
> >     extensions // offset of next luo_feature_extensions (or 0)
> > }
> >
> > And then an example serialization struct would be:
> >
> > struct foo_ser {
> >     struct luo_feature_hdr header;
> >     ... fields ...
> >     struct luo_feature_extension extensions1;
> >     ... fields ...
> >     struct luo_feature_extension extensions2;
> > }
