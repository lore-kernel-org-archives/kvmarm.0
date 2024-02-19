Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081B44C89
	for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708364099; cv=none; b=VqFriAySrQEAqnSsWUbfNByX2dKA3ogjFaqcuwN1uxk6hi3ILDz8LwtZ5kxiOa4RCfnxJMYPGEmT6un9xf4VfFiNG8IHVg17iT7UTbGnQ6htALihbjETKD4n87Gt0hbS6K0CrBmNhOCB649YzZ1gVoFNOVXtHQc0ds4TNH7TpDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708364099; c=relaxed/simple;
	bh=ezVUL0xkhPhjgCnUYuUc9lbrWTo6VPvXG6/p3QUtiTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9AhU1RiuEsRgjlXqUi5StF+/V/22eNRD5Daf1Z1zeF15m+p7w7TYDFGUh1M2qddllxp0llcu6CcUvnONCycrQH8hSiakIniyZuyXgxCU9DsZmnZUno42E65WaqreKhhpDjYeAk6h+NaIURwONKuDNpGqj7QwLjTLk8qs/SJK9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gFpOrpd1; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gFpOrpd1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708364094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=05C5ii9eHeGM6OHAdK+nFBVPyniWmsmrFwb7KXO058c=;
	b=gFpOrpd1vuh7iJqwdI8vQKHa/EL2R1gnK3fgWyUHymQLqX2jkNrqaFMMKQlMMu4N5GuOcA
	amCNN0okBdTslCDxk44IomX/nfWmeqUg1JCUMfqPN8QEp1Bw2O/Fm0zwdM3WhTgv5/B5h+
	QsVKDji05G3P7cQen9OusIDFTDntLys=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 00/26] KVM/arm64: VM configuration enforcement
Date: Mon, 19 Feb 2024 17:34:35 +0000
Message-ID: <170836405332.123390.1336178415163026364.b4-ty@linux.dev>
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 14 Feb 2024 13:18:01 +0000, Marc Zyngier wrote:
> This is the fourth version of this configurationm enforcement series
> after additional reviewing from Suzuki and Oliver. Many thanks to
> both.
> 
> I think I have taken most of the feedback into account, but please
> shout if I have ignored something.
> 
> [...]

Applied to kvmarm/next, thanks!

[01/26] arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
        https://git.kernel.org/kvmarm/kvmarm/c/aeddd5b214c8
[02/26] KVM: arm64: Add feature checking helpers
        https://git.kernel.org/kvmarm/kvmarm/c/c62d7a23b947
[03/26] KVM: arm64: nv: Add sanitising to VNCR-backed sysregs
        https://git.kernel.org/kvmarm/kvmarm/c/888f08807022
[04/26] KVM: arm64: nv: Add sanitising to EL2 configuration registers
        https://git.kernel.org/kvmarm/kvmarm/c/81ffcace31c2
[05/26] KVM: arm64: nv: Add sanitising to VNCR-backed FGT sysregs
        https://git.kernel.org/kvmarm/kvmarm/c/11adda4010ba
[06/26] KVM: arm64: nv: Add sanitising to VNCR-backed HCRX_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/d39051d39269
[07/26] KVM: arm64: nv: Drop sanitised_sys_reg() helper
        https://git.kernel.org/kvmarm/kvmarm/c/76b457a5cdea
[08/26] KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
        https://git.kernel.org/kvmarm/kvmarm/c/0beb14de740d
[09/26] KVM: arm64: nv: Correctly handle negative polarity FGTs
        https://git.kernel.org/kvmarm/kvmarm/c/9958d58779c9
[10/26] KVM: arm64: nv: Turn encoding ranges into discrete XArray stores
        https://git.kernel.org/kvmarm/kvmarm/c/fdd8e3452359
[11/26] KVM: arm64: Drop the requirement for XARRAY_MULTI
        https://git.kernel.org/kvmarm/kvmarm/c/52571d058b07
[12/26] KVM: arm64: nv: Move system instructions to their own sys_reg_desc array
        https://git.kernel.org/kvmarm/kvmarm/c/89bc63fabc8a
[13/26] KVM: arm64: Always populate the trap configuration xarray
        https://git.kernel.org/kvmarm/kvmarm/c/7fd498f473f1
[14/26] KVM: arm64: Register AArch64 system register entries with the sysreg xarray
        https://git.kernel.org/kvmarm/kvmarm/c/19f3e7ea29f8
[15/26] KVM: arm64: Use the xarray as the primary sysreg/sysinsn walker
        https://git.kernel.org/kvmarm/kvmarm/c/cc5f84fbb008
[16/26] KVM: arm64: Rename __check_nv_sr_forward() to triage_sysreg_trap()
        https://git.kernel.org/kvmarm/kvmarm/c/085eabaa74a1
[17/26] KVM: arm64: Add Fine-Grained UNDEF tracking information
        https://git.kernel.org/kvmarm/kvmarm/c/2fd8f31c32f0
[18/26] KVM: arm64: Propagate and handle Fine-Grained UNDEF bits
        https://git.kernel.org/kvmarm/kvmarm/c/f5a5a406b4b8
[19/26] KVM: arm64: Move existing feature disabling over to FGU infrastructure
        https://git.kernel.org/kvmarm/kvmarm/c/c5bac1ef7df6
[20/26] KVM: arm64: Streamline save/restore of HFG[RW]TR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/d196c20c6e58
[21/26] KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
        https://git.kernel.org/kvmarm/kvmarm/c/8ecdccb9e5db
[22/26] KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest
        https://git.kernel.org/kvmarm/kvmarm/c/58627b722ee2
[23/26] KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the guest
        https://git.kernel.org/kvmarm/kvmarm/c/b03e8bb5a906
[24/26] KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest
        https://git.kernel.org/kvmarm/kvmarm/c/84de212d739e
[25/26] KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking
        https://git.kernel.org/kvmarm/kvmarm/c/b80b701d5a67
[26/26] KVM: arm64: Add debugfs file for guest's ID registers
        https://git.kernel.org/kvmarm/kvmarm/c/891766581dea

--
Best,
Oliver
