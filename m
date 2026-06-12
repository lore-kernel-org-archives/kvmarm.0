Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB4837AA99
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 23:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781305662; cv=none; b=uGMNAAt71JdqW9X5cms3Q6nT93GSuZzLbpBIsTMQk1/Fp8G+2DUooEugwPPEkKGLq05ukw2AbTWLOga8a9BzwWr35X7GYp61evlTRShBS74UYXQBsQlG+2bISvoPSerlyQYQanCnxT8nljzlHCuQKxTihkq9IO40e8YFWqkGCcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781305662; c=relaxed/simple;
	bh=YBrqrwHyEinMJud+wSOxqD1Dzh0Zrmog//tJakBkST8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=moKr4QzsLGAnG2MU7dxomm7QFqdqzgFaa6XoDtIRkRxSyC5274LLE2Lu+NVSBtlpY6KoXgnw1+Emy3Ulg5v4Z52818HK8m5YaJdKnXxoc9MszqUGOoQ7U+UQ19e+iqeEDHCUfQHHZkMo9BTuRjuUFrJTIfGcF2Hlhc4+wxkK59E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P59EVxRP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P59EVxRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EF81F00A3A;
	Fri, 12 Jun 2026 23:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781305660;
	bh=l4Z6iPCoEVif5czqX7mpOnEGf86eCdSIsJaNrDC+CNs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=P59EVxRPXaqSh1gsxSJZOl4h4HUMAMliJTXhJNvmxyRBMEmmHIR54xiHms+N0/WOq
	 Wc7k7bkAlNeHYrplgG+/CIOkKu7NJfViXhhrpR+7o5X8JQagPhzGisx0RhjUOvYc+d
	 h2M/Po7cCcycl0HvgmWnJeiGJNzTILw/cgOzmmfWBOOnVKXWgi/e68TpcqVEkOZqMB
	 mq2DaT4ndw0Hx1xhUezPfQHCYAY83w/IJ0f+ax2xFaxfwFkkHKqv4pZOMWDgz2+6ip
	 iI4HRtkiRovbzuV9+S75qS3blsWaUxfBgXp6AvvzdG6kKuvQHKd6JH3C2vKC2IYrTA
	 +40cCeCmP5gAg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5C9B0F4006A;
	Fri, 12 Jun 2026 19:07:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 12 Jun 2026 19:07:39 -0400
X-ME-Sender: <xms:O5EsasWXLEW7BfEs00q2LOU9UGNxJD8cSyX8hmuNQw6AjmRdF9fjqg>
    <xme:O5EsauDizZYmqNrKG1kG7XvyhWVjSF-XTC2CAzI1HcX2RJkVGSdX2p8IWW5WD4VsJ
    SdkkiTQB44YrKdpeLAmbtCMthxV8ac7Uw-ZwfiZYvjLEcY3EyvLuyQ>
X-ME-Received: <xmr:O5EsagWVT7RSGKTAb2dRsQ753FoYwqJVH5pl_ky2k-XpQPdMjviWPxKxCJQheRyhGJb0wiAI1S-0GXFJUT2sz-213Xqnx7xQvsg>
X-ME-Proxy-Cause: dmFkZTEJDXZbVWi1dWDhXfR3V8OFIFiukzmdYSaS1v+Di3g5XrlCcZQ2QlKQoSOmWsLUgI
    fFYKOPBvXSD2ZDBY5QNO9ZOLn4eJl4GE23lbKDOq9+RQnuQznFY+fZe2+MOTgIWBnUIR5c
    ngPc3VFH7ztEHkppv8h4DL/BcASSCwg+98kWriWtVY2EdphbtpA4jwK+n/gNLhr985JXpV
    +wCZ4KiAal7aBY0rnSZmnNYNkmEmzhTnfb56Ezfu6V39YKqbO1wtNlmYEzB20t5yaXEQDr
    VvT7qPO88nnScuZGDmAjNdUC4T2R3ssLj+NJikJAwvx/9Jvnz0VW9GvTyn8bW1OyQ5DNsb
    aL1Io+iSKFP9VyhFtluoCMXLJ1J99LlVqAbTC69H04hf4ASy496Hfl9japnmqVgoUHhXhL
    5G6bFTlaIqCLCnTvM/KaqRqVntbjZtTtrhdynyW5KPUtVanarfQRLdydRQ1Q3uaCMX6CXX
    Xl6E86OWrLbEUcHk+0JUrOM8o3CaMfdulStNuOtYNdihXP1YjItSJGiTLUq817GD0JNEm9
    lo4QflSOqWvm9DspG1du14Vhh5Ec0T0gB/+Pxt09JU+vhhQPpJ6qamChF5Ry85Y+9SGcq3
    vs0yMtOD8M8QXLdjNJ3bYO+TUItd3ggWkvxH3zvl8lCB17ryr3QvFTpU/onw
X-ME-Proxy: <xmx:O5Esas-JpWaqtyuBUxQT17fhEmc3A2gP3VDEOKrFGwXRkHyq0BMdcQ>
    <xmx:O5Esamn_4yVPWbvirZegfSCN5xEHFNBrHWG6QTUL705GNOar8dJ0Vg>
    <xmx:O5EsanJHtm2vJS5foGBWbQl6rGnD6xB-Avd9YnSlmzhuzZfeVr1aSg>
    <xmx:O5EsaspAtn0tZxi8290aSDSph_1CT0x4Te6T-uEEdVr03kyGmBSGiQ>
    <xmx:O5EsakRxFm_NX6lZNtxUMm8ycxZvTjj1Vziuk8xPU7epbDt4FN8vifXD>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Jun 2026 19:07:38 -0400 (EDT)
Date: Fri, 12 Jun 2026 16:07:37 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Steven Price <steven.price@arm.com>, 
 Gavin Shan <gshan@redhat.com>, 
 kvm@vger.kernel.org, 
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 Marc Zyngier <maz@kernel.org>, 
 Will Deacon <will@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Joey Gouly <joey.gouly@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Christoffer Dall <christoffer.dall@arm.com>, 
 Fuad Tabba <tabba@google.com>, 
 linux-coco@lists.linux.dev, 
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
 Shanker Donthineni <sdonthineni@nvidia.com>, 
 Alper Gun <alpergun@google.com>, 
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
 Emi Kisanuki <fj0570is@fujitsu.com>, 
 Vishal Annapurve <vannapurve@google.com>, 
 WeiLin.Chang@arm.com, 
 Lorenzo.Pieralisi2@arm.com
Message-ID: <6a2c91398fad5_a003b10027@djbw-dev.notmuch>
In-Reply-To: <50d70588-2ebc-4c9b-98ec-68f3d04a9d21@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-11-steven.price@arm.com>
 <872ce762-0a83-42a4-bbe8-b21ea6f4e1cf@redhat.com>
 <50d70588-2ebc-4c9b-98ec-68f3d04a9d21@arm.com>
Subject: Re: [PATCH v14 10/44] arm64: RMI: Add support for SRO
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Steven Price wrote:
[..]
> > alloc_pages_exact() will fail if the requested size exceeds the maximal
> > allowed
> > size (1 << MAX_PAGE_ORDER). The maximal size is usually smaller than
> > PUD_SIZE
> > but PUD_SIZE is allowed by the RMM.
> 
> This is an area where to be honest I'm really not sure what to do.
> Technically the RMM is allowed to ask for a contiguous range of 512GB
> pages (on a 4K system - larger with larger page sizes) - but clearly no
> real OS is going to be able to provide anything like that.
> 
> In practise we don't expect the RMM to do anything so crazy. It's not
> really clear to be whether even 2MB (PMD_SIZE) is needed. But the spec
> is written to be generic.
> 
> So my current approach is to calculate the required size and pass it
> into alloc_pages_exact(). For "stupidly large" values this will fail and
> Linux just doesn't support an RMM which attempts this. If there is ever
> a usecase which needs this then we'd need to find a different method of
> providing the memory (most likely some form of carveout to avoid
> fragmentation). But my view is we should wait for that usecase to be
> identified first.

Just some comparison comments as I am also going through the TDX patches
which enable "Extension SEAMCALLs". These new SEAMCALLs are similar to
the SRO mechanism [1].

TDX asks for an upfront delegation of memory at init time using
alloc_contig_pages() that is never returned until entire module is
shutdown. alloc_contig_pages() is not subject to the MAX_ORDER limit,
but not sure that alloc_contig_pages() is suitable for small+dynamic
runtime memory add / release that SRO potentially wants to do?

Does SRO always balance the size of RMI_OP_MEM_REQ_DONATE with
RMI_OP_MEM_REQ_RECLAIM, or might some donate requests be a one way
donation like TDX? Just poking to see if there is a path to preallocate
a pool vs the fine grained per-operation alloc/free.

[1]: http://lore.kernel.org/20260522034128.3144354-3-yilun.xu@linux.intel.com
