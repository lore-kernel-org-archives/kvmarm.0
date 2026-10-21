Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792626948;
	b=GVuEE7hb1QokQWMijDtRto7qBKQfQDNTJ/W2/QPoV9bQLEgIUhuDa1oCatJATqpDQpJG
	 s3TRf+S79zAZbE/aeiCgScHjpPHA2CtbHpV5pFwZVesfu9ECWbjr9J44zfl58cc0v07VW
	 jH/GKapM67vp3Cn/TBpkyp9CAaI61pT7+JKifTA2XJPNCmsAjQYfGOBrDg23Gl0CxmALN
	 aVLshPVWEQX2yLYyresU2qbPZrIDE+nBrQntiDKpptXcFUpkwnRJJ8Yh+phqIcTf7SZBK
	 rgKGdVgKvLt3c2q7jC4JEaI7KI5aqbVN2El5j510aEde6j0EwalkiAfvithcOQFcR8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792626948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=1fqUHRqztpFhXjrNb+RX+YalUvUHW60343cq6Q4Whxw=;
	b=LQ6h0eHVOL9p8TKzI1l1x6WMlxhF7ewKaAe1dbaEM63/s/GlUmHA1WslAvbcz90ltJ/C
	 muviNbhiwoKMrmUwulipwbbM/XFDgfB2+/hjV2BQThOj5t+Y9t9vBgkT7Bfinm4khxKkd
	 +R2Br1AgGfzSHz570aLbbFe3V5y2RQRiO5hHptTWlfua0lEf7QffpEmeFb+em8oNnAWKQ
	 Ny7iQ/wat0mm01PZaLXHM/SB06IkzrdtWbwv3ZRYW2TKDsdgmtTK15v9rcFk0qgSlN6Qe
	 9YWKQimmSokl1ecInrRfjuMPceqNE7pg1ho2FGTldx25LFMznAbSTVcU5aJAi6HSu7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=L+vnhoHf;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0163E606A31E
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:55:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0163E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=L+vnhoHf
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2dd76b1361dso8788065ad.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 16:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792626947; x=1793231747; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1fqUHRqztpFhXjrNb+RX+YalUvUHW60343cq6Q4Whxw=;
        b=L+vnhoHf4ZKWO8AQ7qVKnrKcbki85jfVHirWnaua2gVXYYcjUk3gBL1rTemxDZMA+P
         L6C3Gx7+GdHTQ7AiozC49aSHM8FcdVhFzwlQyiHJKQvrFyapKkZ8Z6hrOvYFpKFyDlWo
         9Q9gVE/PJ33cMNe+ev7wOb/rFH62es23e1wuaBL2ZYApo5sBm9eVZuQsGudZgv0zsmjU
         BXBYOD3LFPpX+0JPTLQcmKse9fIwU16Skud49P9BSK+g5zq552ZptBMtzi1KWFUJJuN+
         ruOvH3CN2xCVERdNpOeeclXsXmHPr990DuCTYAIi/oMHTtuCGDqiho4QkcaZ5/1mKn6I
         eAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792626947; x=1793231747;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1fqUHRqztpFhXjrNb+RX+YalUvUHW60343cq6Q4Whxw=;
        b=g6wBXeJUKrotmZ7GVi4R7flJURr783Fg9D9wMmLhTXCgduks9BgAcDoUOv3i+Nk7/P
         MklFwlVOoG3QEYDKm5r3RxsqnO1rr+b38HJyn28ef+28L3+kidjJeYVVXQ0aqF1Y+qHA
         apdJIP811nRmAvR+/PkkVuKjEYD3IlFl8jzcFpyuoykyaEjT8tjt8qNptfMbZt1EK1P+
         48C/BsUfI/Pf/1+RW4ekODgYqLR8oNjthRZxvoQKOdiENG6m6eyEA6ap9Fi289NGX83E
         vk/Yo+MUfCY+DZMkmp5FmUdvg0t2z5uQnxeN38IgBpUr7yBcI2aV8kPqs7/20+6CZ5z5
         0Bwg==
X-Forwarded-Encrypted: i=1; AKwUvBzYckjRROthIAj05chNgt5byW7K9spTz8+/N8Os9V9amF6qlb48RPCASmI1BZZx6ZUmBcg5sTU=@lists.linux.dev
X-Gm-Message-State: AFq9FYJY/Vd58sv+RQfec8ISv2iDwje7HG4WTvW6pOtB6686NOjWRcHg
	OJLD1wJ+iLXN/ec568tIuYIEQGHfxVcPLQ/BL/Qr3034lUUuBp6k7KS+qrMrlDmrKQ==
X-Gm-Gg: AYBFou2CjRabZk852kQGNm7WFF3N9OLOfnv2H4IDjdZp4Q25CwP/saqDW5YrZ9DtfRX
	ANvZWAdLSteysPnVv7sC0pEgE3N01+O5bca4WXrWBVKBZjbWw85S28zhk+zo0bTRydr/MpQ+nim
	CH6vTskjd48GoXiYn1zvIwYr512N+RZtdSCYPPaAPI1VQ3K1loBVbThTOH/chhEXViy3aECrEXE
	15o2pbWhR4T/n2y0LYYoTTzGlbzeHUt7mUvxhpRX/d/yJ8uvK+bzl9FeXLu0CPdWLrSlBGASw8p
	syeEDtCvkCi3ptg2dXLo1Ajb+jdXmLTTZ6kkvBogf5lLDwKzHuJvQ5ONc9B0MgbDmUtS1Q0/GOL
	4koCo7enCmG5o5PGsX5hoPGQAMa31bTOzH7lcxiMxh3aIwmqbQ4yjydt1hiQfuHmhg0DHDOwxXj
	ruC+W5WmQ4qsRFqBagyEFVEywePVje/nsWbRx0gYVUqOxSEJgCPXpjV3d672QblEnRji/pCluG0
	QgfDqETQ3KQt+IWWs5wMFRQWEEehFpjbjoqLX25qBouQm6FL2nBbcq+KoPK1no8PukDJxM/2f5Y
	bYwYUJr1rR0bkZzl
X-Received: by 2002:a17:902:f70d:b0:2e8:3190:73a with SMTP id d9443c01a7336-2ea44075412mr31011645ad.58.1792626946744;
        Wed, 21 Oct 2026 16:55:46 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b30829csm16784705ad.11.2026.10.21.16.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:55:44 -0700 (PDT)
Date: Wed, 21 Oct 2026 23:55:40 +0000
From: David Matlack <dmatlack@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <atlQ_Er0Ig7CCSxv@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021152527.375070-4-tarunsahu@google.com>

On 2026-10-21 03:25 PM, Tarun Sahu wrote:
> LUO and its file handlers validate handed-over state with monolithic
> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> structure, even an optional additive one, must bump the string, which
> breaks live update between adjacent kernels. Replace the string in
> struct luo_ser with a feature header, so that the target kernel can
> accept or reject the source kernel state per feature.
> 
> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> structure size from the source kernel followed by 15 chained u64 feature
> flags entries. The fixed size keeps payload field offsets identical in
> every kernel, regardless of how many flags entries a source kernel uses.
> 
> Each feature has a 2-bit pair (req, active) state (enum luo_feat_state:
> LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entry
> holds 31 features, and bits [63:62] = 0b11 chain to the next entry (465
> features in total). Each subsystem defines its feature states as a
> static const u8 array indexed by its feature enum, which
> luo_feature_hdr_init() packs into 64-bit flags entries with
> LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header from
> the source kernel against its own feature array via
> luo_feature_hdr_validate() according to the per-feature (req, active)
> truth table:
> 
>   Source Target Action
>   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without active)
>   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
>   (0,0)  (0,0)  Accept: feature absent
>   (0,0)  (0,1)  Accept: feature absent
>   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
>   (0,1)  (0,0)  Accept: ignore payload data
>   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
>   (x,1)  (x,1)  Accept: use payload data

I think we have different definitions of "required".

In the PCI series [1], required and optional flags describe the _data_
the previous kernel handed over, not the kernel itself. A required bit
means "this preserved state depends on feature X; a kernel that does
not understand X must not take it over". An optional bit means "the
data for X is here, but you can safely ignore it". The source kernel
only sets a bit when the preserved state actually uses the feature.

It's up to the FLB/FH retrieve how to handle the scenario where a
required bit is set that the target kernel does not understand. For the
PCI FLB we panic since failing to adopt the PCI state could lead to
memory corruption as preserved devices can be doing DMA.

The target kernel never requires anything from the source. If a
feature is absent, the target kernel must handle that, e.g. by
falling back to default behavior. If it can't, that is a compatibility
break and should be handled by the compatible string.

In this patch each kernel has a single static feature array that is used
both to generate the header and to validate the incoming header.  So if
kernel N marks a new feature X as required (so that older kernels reject
data they cannot understand), then kernel N will also reject every
kernel that does not have X, because of the (0,0) -> (1,1) row in the
truth table. That breaks forward updates from N-1 to N, and rollbacks
from N to N-1 even when **nothing being preserved uses X**. Therefore,
every new required feature becomes a compatible string bump.

I would drop the target-side required state entirely and let the source
kernel decide which flags to set for each Live Update based on what is
_actually_ preserved. Accessing a field added after the original struct
then always requires checking its flag.

At the end of the day it is up to userspace to never start using a
required feature while they can still rollback to a kernel that does not
support it. Cloud Providers know how to do this since Live Migration has
the same problem. This also means we must be very careful when adding
new required features, as they need some way for userspace to explicitly
opt-into them. I do _not_ think we should try to have some generic LUO
opt-in for required features. That is up to the File Handlers and FLBs,
as they have their own uAPI.

[1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/
