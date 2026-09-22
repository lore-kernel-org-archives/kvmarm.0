Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16F44DD3BB;
	Tue, 22 Sep 2026 22:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116281; cv=none; b=e544wq/zCgFF0stJQhdc9v64efHolwzpPM4TIez6plrBWO95A+EGdgRN8sGBhAYT+GDLUE88t9J3ox7mzSGu8Ib0zSZtl2lmYWnzCsW+9rLElfS5s6Ovp/v+bKlAi/oDe/uZJJSZwNtwVQRZrGH85+dzZgNdLvgES5ggE1fLk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116281; c=relaxed/simple;
	bh=Rpa/JhaOrTNxG9TXI4IZE4KyNsNWqjwf3WCmhD60xMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szHHuMFM59LwZCz5rgMvBdSzsiiSnYPuAbNBv5UM4n1I8GcbMwATpFsGJ8/HKu/kEH8Eol17P1XOPTS5t6/+3CLzlgm3cM8WFczE68+KNryWjZ9AYmqKeKK8Qp4WQlWtbT2sjvgEKMJG4x/AUrxnZk+6Sh5dUv6J68me0IJH3V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2fT1Cnb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2fT1Cnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A971F000FF;
	Tue, 22 Sep 2026 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116264;
	bh=SHdoMtqTcyEFnKcEGKtf+gXpBwhRndA3VPqIQwhO6u0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m2fT1CnbsmgDLs/vXAhUi2PVTPtWv77mptNg9sblMISCnW0xAzYZ1R25XouRGAjOV
	 Put7EPbRYBxpDjBnKTIdgahacBMn3ufCNKC4v0uYRLWYYL+/Rj/LJqne0KQXBtupdL
	 xOyDeiHhETN5ztTnyxtpKlXIyw3A8hweXtqpqcNyN8LfT1dYlVx+Fi9fjcdSK1L5lg
	 QUcDUChYP9Y/tDVyfA94SI7pt5OhjtBCipFTO9mpdRS1I/wrs6r8UbvvQcYpi6RPxG
	 brUkfPgIQmLxF5T7asvuadoVHci1b724RNcLuBskqrKciETeVAjqLGEcUXPV3wLEJ8
	 KmRDsqcxqpbyg==
Date: Tue, 22 Sep 2026 15:31:02 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>, James Clark <james.clark@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
Message-ID: <arMBpmlUi1Hm9hIB@kernel.org>
References: <20260922181430.3532371-1-fuad.tabba@linux.dev>
 <arLbbtuRuOrxlh1Y@kernel.org>
 <CA+EHjTx8JsXfrjKUbhhrfSmFPrWxyYaTbKqMeYAJPt-vqGfLvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx8JsXfrjKUbhhrfSmFPrWxyYaTbKqMeYAJPt-vqGfLvA@mail.gmail.com>

On Tue, Sep 22, 2026 at 10:09:37PM +0100, Fuad Tabba wrote:
> Hi Oliver,
> 
> On Tue, 22 Sep 2026 20:47:58 +0100, Oliver Upton <oupton@kernel.org> wrote:
> [...]
> > We can trim 3 instructions from this by using the read-trap bits as the
> > starting point for the write-trap bits, like below. It also makes clear
> > the point that most of our trap bits are symmetrical for read and write.
> 
> I did consider that, and went the other way for two reasons.
> 
> The read side has three bits with no write-side counterpart
> (nPMSSDATA, nSPMDEVAFF_EL1, nSPMID), so copying x0 into x2 writes ones
> into three RES0 bits of HDFGWTR2_EL2. Harmless today, but it's this
> bug in reverse: the first revision that defines one of those positions
> in the write register turns the copy into a silent behaviour change.
> Building each mask from its own register's names can't do that.

My thinking was that we could have a third block, but...

> It also matches __init_el2_fgt, which already keeps x0 and x2 apart
> for HDFGRTR_EL2 and HDFGWTR_EL2. And even in that form the copy would
> have to sit just before the msr_s, after the SPE block, or
> nPMSDSFR_EL1 only lands in x0.

new feature-specific initialization blocks will make this an absolute
mess. So I agree, this is the right fix.

Reviewed-by: Oliver Upton <oupton@kernel.org>

Best,
Oliver
