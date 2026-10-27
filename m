Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793122189;
	b=CU8YIvmFu4AKcMkF6IZ5ngDpTGKRND9rykP4cCenufXlURTgC89vrL4fcqlaXO4YsXWC
	 xIl8pCyJ9JhK4Fzy5qCGVTiPvF76MenynRSlUiRdW5xHe9frg410vqShwyAgbE3OmmYcE
	 nusRWvs379Iin/M1qGY24f+WPVHhCHXSRztf5tWyLzLJUe1gpDPDn+hmjrqzEyDbxjWct
	 xFldj5Zf8dozF2Ia3iTwN/rNJTxMlNVW4i714TWrA2+tJ5lqnSnypbHUclhmeP7v1vF4C
	 2AOmHnkhx5egj3FeqT79doQ3BF8stYm7knFpigLopP6CgU/W9lDi9JbUBiybdU35rUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122189;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BnI1ypDPlmui1Fn2L3S4sqAodoDBEGGvrnjTOR08vd0=;
	b=H8R3tOSu9zfPPyhRmLMaUFO4nnLrOiJJ4QyheV+2MWqRDq8REudTrUfraWu4sISbvJF9
	 d9AGwUcetI6ib6wowUsP3IZAYtftadYULn4OAs9QlE0tKUgRbAH85yHFLYBVAom4btW5D
	 h6MNdtb1k7AxM3NVb4+Q7OzyTCUBpEZwWFYQ4U4+tiRJ2OnV7G9XtsQzPcU+Ic/w4/u2X
	 6M+XhR38Dka8+86l1abFbJdUthITQMM1jbMpBtmUibsEc2hyxSs8DPtB3w2wZDglk44SS
	 UR9wmwHJx9jcJILaySGJ0xI+hydZ6vQEU4y6C/n2Hoy5tPA25a2/OxgDC/0WH1b/jVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JnukGCmU;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE12606A31D
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 17:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DE12606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JnukGCmU
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76CB01650;
	Tue, 27 Oct 2026 10:29:44 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03EA93F7B4;
	Tue, 27 Oct 2026 10:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793122187; bh=Px2Eb/FcnI3Ov0Mt8j5f3nVtsWHdzfl3d+dvv9q4c3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JnukGCmUw/pTUGbxSJRJln9Shqph1UdbZJ11e8Rw/XWFSYh2PALvpdxDCrDVUdYar
	 LzIMetk442+RLA1OwGDhiPXdCEN11FcDbAV7sW3W6KSaRWtPR5IOK52cwHFsvOA4lN
	 FVsMGnDA/gqePHcu3rFELPNmZ5TUvTU4GXnL+wus=
Date: Tue, 27 Oct 2026 17:29:43 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Reenable MTE on VHE guest exit
Message-ID: <auDfhwB0oWFreEY2@arm.com>
References: <20261026082305.2515705-1-maz@kernel.org>
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
In-Reply-To: <20261026082305.2515705-1-maz@kernel.org>

On Mon, Oct 26, 2026 at 08:23:03AM +0000, Marc Zyngier wrote:
> Upton taking an exception, the CPU sets PSTATE.TCO to ensure that no
> tag fault can be taken while handling the exception. It is SW's job to
> eventually clear it when it is safe to do so.
> 
> It appears that when MTE is enabled and that the kernel is running
> VHE, nothing eventually clears TCO when we come back from the guest,
> so things such as KASAN_HW_TAGS will not work until the next exit to
> userspace.
> 
> This series aims at fixing this. This is not a stable candidate, as
> KASAN is only a debug option.
> 
> Marc Zyngier (2):
>   arm64: Add return value to mte_disable_tco_entry()
>   KVM: arm64: Reenable MTE tag checking on exit from guest when running
>     VHE
> 
>  arch/arm64/include/asm/mte.h    | 10 +++++++---
>  arch/arm64/kvm/hyp/vhe/switch.c |  7 +++++++
>  2 files changed, 14 insertions(+), 3 deletions(-)

For both patches:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
