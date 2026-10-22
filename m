Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792627492;
	b=DQ6IHOgLLnb8RW5TaGxEdl38OGgubuWh7DHktDMKbeG28qLnrwRegwgb4tNP7EVKRr4c
	 /i5acD+77Ginijk48IsZQIPUfLI6zPWZGtZVqmf2YaiiKjVNj0+mNpNYaMGtWWxkYVlGy
	 XBpZXxSvd5hGnvva4HaEj846gin4nqriuSGghFwognpwJuclRGY743g5Gkf8FKolboTy4
	 +F1IW/IRZP/Z/xjkRpVPuMcoUWynoTdLwZ8P/F3NQ8oUL+VBrKTDFUO97rl3P1VVh7wvZ
	 FoEvByLcZazw/Nli1dERQ2BrRT7e8u7U/3LE1YGrp7ksvM4171AeLIKfdR7X4T2/F8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792627492;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
	b=3+p8dyYyiOJUFDNO6IhQpgvCDS7ImMbSRKY3mXtXE+BSE0SMS874Tg65Y7rnm8gtmyCx
	 oLUmpPeQRGUAIGhXH7iqEvqL+BkfHidRPymjYFWMJWDICeJXOg/+OHQ+0otNB0+OnEABz
	 vzqVBdlmxmeeN7OXpEjBYZx4nlD5Y5H1/qTV7x0T8Vj7R5flGZ4/OCHZWEamPTRVG/ytJ
	 XS6MpLYmUCrml9otXp6L4uviyXmqB5o22LM3RL2H7c9tzu8GxYMkmTfs5hLMzDALdu1Ry
	 YdvoycAzR4S0dsSfGi0Lu7EXkChyEzlWRm5a0v2fExf9I0XnwIukTGVOtNOBu05JBHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PFE7lRva;
	arc=fail smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79377606A31D
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 00:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79377606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PFE7lRva
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso168529366b.2
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 17:04:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792627491; cv=none;
        d=google.com; s=arc-20260327;
        b=W1eKpNAHz2rSuJ7sRvHFLgHdoEg3tF13+YFWnjwQm8NbFvQFsG3AOtZHzqpSBX4/wq
         X/5uv5B3s+k/qab4Cjj2EjsC6w1pEjZ9MT0Cq7l99mZlonscRmvENeV85OZxUslqTytw
         JbZGWXt2/SoUaH4VFF09rY6lyWdI6/WFbW3kC0XvCx7BO6tNDvymODOsY0S/I4TIWWDD
         RMZf7AsOPVIZyFG210QiDDq0SrGpDpGln6pTnPNOt4wBjCTa755TQN9/Mq6SQsvvYp3K
         O9J2ktSMpugMCgioCzAAEX8zy8SxMdk5g1KB2r420yQokqcxmGT20GJ14jnIWUqpSfRc
         aJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
        fh=5M8C3RKMtbmSEkcz3p3jxY5Oadn1tDfwcVuesoLjtz4=;
        b=CS/DmTJcLsbjraLrMJLM0pyopQahAi3Ehi8YOHOKpNp5aaDqz1vxmlgMqChtmxI5gn
         6iI0bIppTyjPaPIFCNBlJXHtJJELSWl01zStNX/mEe+ZOT2SiVya16IbD8M6e6zcfV4x
         XDMOdkMkbW7GB5IekVxnMU1V3i4WG7fzbzsj7FpHd/X2VE9+iVHgT8akRU76Q1AArqeg
         kJYiijynzWKoZR5zsTJyaZHlS00wxRLNALWgJPuem0EG9lwZbHQq7dEfQOxCyMk+hTVm
         p5UUsahL/Ufb3txQ3Y9uf1Wi+OA+WxcJte6Bkh5q50j1wRLMo8NEGIOsJKPrmOPFIoeD
         WFog==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792627491; x=1793232291; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
        b=PFE7lRvaLr5R+mBeTiEyI9aaEry1bjiSJkbYSt9R+Qppwef3fMRtRSu2/10AAaEs0B
         t4O1IcNA/TgvyXsYgcbR5caxG2bo3yW9HcuYM8bEgNIsY7xyi3K/Oj2LnrZGPeRXaQqv
         3nbnm7oznTggfA1dxqMiZImcaIb+TBOuFznJPX3903+8QuVWYo7Y67sep7WrfDOyhd9+
         8Gh11/TKCxTVsXmgj/MUyntb44IxzukJyYDHxyNsfGB0PpeS9JdGNMxcqogcWRNjAX+C
         M3vRGofdScpNirDQYfIBaeBIpb/z2cBp+BwTYVYgTIGAhLcMzh8Q3fzyY0yx+QEjZbbG
         3aMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792627491; x=1793232291;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
        b=qClTMehQAYl+lFdwMNGVCoiXPE0BWFqXp3AyjvzX53bEjrsf4AmNtsWh2Ykb0B32mY
         /AbXGNydxPtDAHd1r7DTN+fTj96Lwd1dtakc0udUD/LJ885BQTb8TwNsfTDNs086Nh7g
         /Z3oOaQgkJVzPu4j+ddcxeLDZUq1ts4Vk+1GjtKKEWU0hBy3bSnbG/bEqGWby5kjsokT
         NfGhlD3GdjDHBC+EQ3WD4ebgZepKa/a1OVs/bPCX6BXEq5glIKVULqD5C5xBP9erRHHG
         CzbhGkY/mfWlcXyble7nd/zlxbAVH2+4V3HUbPy5k70YDVMOVkK9REsmMYt7eeOYHiJW
         ERQg==
X-Forwarded-Encrypted: i=1; AKwUvBxpgdNMiTb2TmUXSq605OtjEIYyOZ4KvFe8kYPkmqZO04KMLnDy0iQDGRhx+eOgHmD1wAYaBk0=@lists.linux.dev
X-Gm-Message-State: AFq9FYKkZm2sSL/Ux185hPS6GglWY9i8x0sCMJaV+MiNzmoBMtadhs9t
	0Vre7ovV3vnx3Tnf8ox8FVl8F+Z7SxMI7sMWiNIk+3pa/wW1UhIz18kLPkqnlhBJLRxD4F166GL
	4I6CzSGn9zFT4KEmQ6t+jH7pu0eeddKvK9/eFBgfv
X-Gm-Gg: AYBFou31N9rZ2zKPCbC+SLUFsgjv2O/dj3ZLnMr3M831MHb0gfbrS2jWfdji3JPLVR+
	Bf2qddCWZtoMUuxlTgL5rRUZv+PHPMjDfSk+vqBD3kx7YG0dDD+uimFyWwIa4w/o0XI8weVeIt5
	cggaKmMBbUKYtUM41ERoCb8zsQWI6WCl1ILfUJAAVhRVQw4+B/Lq4dYn9piGFmL7XkQcELClxWg
	oojmD71WOWu97D97l1QRQGDLslI6AlN7abXMd2cKL5KNU41MnjAcUU8SZLtA/3I4stHmoclTXdB
	vUilleZ4dT2Lj9XQCFgny9M7WXGZCv8SeokflTnhSj4QZvFVCavUdg62U0sXh9PvlBeaNVwbZZ2
	Q/BMaDoTCtt7xCvBEMCI3BIWPMyJm2k+oOzImHQ==
X-Received: by 2002:a17:907:86a7:b0:c34:cf13:a930 with SMTP id
 a640c23a62f3a-c4679689896mr324348966b.34.1792627490183; Wed, 21 Oct 2026
 17:04:50 -0700 (PDT)
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
 <atlQ_Er0Ig7CCSxv@google.com>
In-Reply-To: <atlQ_Er0Ig7CCSxv@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 21 Oct 2026 17:04:22 -0700
X-Gm-Features: AclHuK9LuxkFhyY58-PllQ_xn35qEFAv5-F2hDjCZHaof6GARbd972qVOi8lSVA
Message-ID: <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 4:55=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-21 03:25 PM, Tarun Sahu wrote:
> > LUO and its file handlers validate handed-over state with monolithic
> > compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialize=
d
> > structure, even an optional additive one, must bump the string, which
> > breaks live update between adjacent kernels. Replace the string in
> > struct luo_ser with a feature header, so that the target kernel can
> > accept or reject the source kernel state per feature.
> >
> > struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > structure size from the source kernel followed by 15 chained u64 featur=
e
> > flags entries. The fixed size keeps payload field offsets identical in
> > every kernel, regardless of how many flags entries a source kernel uses=
.
> >
> > Each feature has a 2-bit pair (req, active) state (enum luo_feat_state:
> > LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entry
> > holds 31 features, and bits [63:62] =3D 0b11 chain to the next entry (4=
65
> > features in total). Each subsystem defines its feature states as a
> > static const u8 array indexed by its feature enum, which
> > luo_feature_hdr_init() packs into 64-bit flags entries with
> > LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header fr=
om
> > the source kernel against its own feature array via
> > luo_feature_hdr_validate() according to the per-feature (req, active)
> > truth table:
> >
> >   Source Target Action
> >   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without acti=
ve)
> >   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
> >   (0,0)  (0,0)  Accept: feature absent
> >   (0,0)  (0,1)  Accept: feature absent
> >   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
> >   (0,1)  (0,0)  Accept: ignore payload data
> >   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
> >   (x,1)  (x,1)  Accept: use payload data
>
> I think we have different definitions of "required".
>
> In the PCI series [1], required and optional flags describe the _data_
> the previous kernel handed over, not the kernel itself. A required bit
> means "this preserved state depends on feature X; a kernel that does
> not understand X must not take it over". An optional bit means "the
> data for X is here, but you can safely ignore it". The source kernel
> only sets a bit when the preserved state actually uses the feature.
>
> It's up to the FLB/FH retrieve how to handle the scenario where a
> required bit is set that the target kernel does not understand. For the
> PCI FLB we panic since failing to adopt the PCI state could lead to
> memory corruption as preserved devices can be doing DMA.
>
> The target kernel never requires anything from the source. If a
> feature is absent, the target kernel must handle that, e.g. by
> falling back to default behavior. If it can't, that is a compatibility
> break and should be handled by the compatible string.
>
> In this patch each kernel has a single static feature array that is used
> both to generate the header and to validate the incoming header.  So if
> kernel N marks a new feature X as required (so that older kernels reject
> data they cannot understand), then kernel N will also reject every
> kernel that does not have X, because of the (0,0) -> (1,1) row in the
> truth table. That breaks forward updates from N-1 to N, and rollbacks
> from N to N-1 even when **nothing being preserved uses X**. Therefore,
> every new required feature becomes a compatible string bump.
>
> I would drop the target-side required state entirely and let the source
> kernel decide which flags to set for each Live Update based on what is
> _actually_ preserved. Accessing a field added after the original struct
> then always requires checking its flag.
>
> At the end of the day it is up to userspace to never start using a
> required feature while they can still rollback to a kernel that does not
> support it. Cloud Providers know how to do this since Live Migration has
> the same problem. This also means we must be very careful when adding
> new required features, as they need some way for userspace to explicitly
> opt-into them. I do _not_ think we should try to have some generic LUO
> opt-in for required features. That is up to the File Handlers and FLBs,
> as they have their own uAPI.
>
> [1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@g=
oogle.com/

Oh and please see the follow-up PCI series to preserve BARs and bridge
windows for some examples of using optional_flags to extend struct
pci_ser with additional data without breaking backwards compatibility.
e.g. https://lore.kernel.org/linux-pci/20261019213054.3157159-5-dmatlack@go=
ogle.com/

I don't yet have a use-case for a required_flag.
