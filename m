Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B62230BEB
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 19:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752001229; cv=none; b=AtAWhtx2acB9FwD+y4y6v9FSQS4u65eLti2uuhfphm/01DEJABrKoIscdLBMhUU4gZs09O18YNxfxSPp3eEECW4VTO1WqkNmk+ZrlikqAk9R+cv+xos41pyqtPhpv+7hVFC77p0TQt9sQgkZyJu/LClP7G8w/efztuQHyFd0lF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752001229; c=relaxed/simple;
	bh=zGO8hIaKdyOQ3Hr0XEitlKKhNHfYv41AVGby8qB41Zs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jAgzj//ZNwrIpOIjYUnVWyrIsLVCvJoDSK/fnt4a/T5LaUCDOF/IlBPnz4bO+TiNa8Z7+mrX5CmJkACngGoVTgIdCXfCa1P2nfIg4Tb7NgWiCubZlZDWEpIkeX6BWpaPop57Zc6Mx6bwD8rrgM7KyFWwaSwnCEvZvxsAdbhd1sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gmQ1fqm8; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gmQ1fqm8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752001212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=28kR4Bff03PG5x5S/BzA//lI8ur9leBxDYsqlQZzVcM=;
	b=gmQ1fqm8J36b/SbAe0IQf4nBgr7UHo5TeTUdwUGIFWXmljH5wN5F0TYFGN6GUWOBLra4t+
	LZjf6zpyWATogty8+u3J3jDn9kJ57VlpefI1DjhLsbXn5CrJ8qG8E/VsKn7MCZtMfKKyNT
	JZNL0ATHJbqEyqq6RwBp/YfZzV45NFI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 00/27] KVM: arm64: SCTLR2, DoubleFault2, and NV external abort fixes
Date: Tue,  8 Jul 2025 12:00:03 -0700
Message-Id: <175200118986.1886525.3994257230667764158.b4-ty@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 08 Jul 2025 10:25:05 -0700, Oliver Upton wrote:
> v2: https://lore.kernel.org/kvmarm/20250616230308.1192565-1-oliver.upton@linux.dev/
> 
> v2 -> v3:
>  - Fix mask computation when SCLTR2_ELx.NMEA is set
>  - Consolidate TMEA handling for all aborts, spin off NMEA (Marc)
>  - Set up the fault context correctly for the injected abort (e.g.
>    not setting HPFAR_EL2 when UNKNOWN) (Marc)
>  - Don't use the guest hypervisor's VSESR when FEAT_RAS isn't
>    implemented for the guest (Marc)
> 
> [...]

Applied to next, thanks!

[01/27] arm64: Detect FEAT_SCTLR2
        https://git.kernel.org/kvmarm/kvmarm/c/bf49e73dde7d
[02/27] arm64: Detect FEAT_DoubleFault2
        https://git.kernel.org/kvmarm/kvmarm/c/e3fd66620f10
[03/27] KVM: arm64: Add helper to identify a nested context
        https://git.kernel.org/kvmarm/kvmarm/c/1d6fea7663b2
[04/27] KVM: arm64: Treat vCPU with pending SError as runnable
        https://git.kernel.org/kvmarm/kvmarm/c/aae35f4ffbf2
[05/27] KVM: arm64: nv: Respect exception routing rules for SEAs
        https://git.kernel.org/kvmarm/kvmarm/c/9aba641b9ec2
[06/27] KVM: arm64: nv: Honor SError exception routing / masking
        https://git.kernel.org/kvmarm/kvmarm/c/77ee70a07357
[07/27] KVM: arm64: nv: Add FEAT_RAS vSError sys regs to table
        https://git.kernel.org/kvmarm/kvmarm/c/211fced460f2
[08/27] KVM: arm64: nv: Use guest hypervisor's vSError state
        https://git.kernel.org/kvmarm/kvmarm/c/18fbc24707db
[09/27] KVM: arm64: nv: Advertise support for FEAT_RAS
        https://git.kernel.org/kvmarm/kvmarm/c/a99456abd834
[10/27] KVM: arm64: nv: Describe trap behavior of SCTLR2_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/0ead48acc935
[11/27] KVM: arm64: Wire up SCTLR2_ELx sysreg descriptors
        https://git.kernel.org/kvmarm/kvmarm/c/81fbef164766
[12/27] KVM: arm64: Context switch SCTLR2_ELx when advertised to the guest
        https://git.kernel.org/kvmarm/kvmarm/c/02dd33ec8831
[13/27] KVM: arm64: Enable SCTLR2 when advertised to the guest
        https://git.kernel.org/kvmarm/kvmarm/c/7fb7660b9c0b
[14/27] KVM: arm64: Describe SCTLR2_ELx RESx masks
        https://git.kernel.org/kvmarm/kvmarm/c/abc693fef30c
[15/27] KVM: arm64: Factor out helper for selecting exception target EL
        https://git.kernel.org/kvmarm/kvmarm/c/720ef4611c46
[16/27] KVM: arm64: nv: Ensure Address size faults affect correct ESR
        https://git.kernel.org/kvmarm/kvmarm/c/178ec0ae35f8
[17/27] KVM: arm64: Route SEAs to the SError vector when EASE is set
        https://git.kernel.org/kvmarm/kvmarm/c/fff97df2a0bd
[18/27] KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set
        https://git.kernel.org/kvmarm/kvmarm/c/ce66109cec86
[19/27] KVM: arm64: nv: Honor SError routing effects of SCTLR2_ELx.NMEA
        https://git.kernel.org/kvmarm/kvmarm/c/59b6d08666f0
[20/27] KVM: arm64: nv: Enable vSErrors when HCRX_EL2.TMEA is set
        https://git.kernel.org/kvmarm/kvmarm/c/1f1c08d9896c
[21/27] KVM: arm64: Advertise support for FEAT_SCTLR2
        https://git.kernel.org/kvmarm/kvmarm/c/075c2dc7367e
[22/27] KVM: arm64: Advertise support for FEAT_DoubleFault2
        https://git.kernel.org/kvmarm/kvmarm/c/a3c4a00dbe20
[23/27] KVM: arm64: Don't retire MMIO instruction w/ pending (emulated) SError
        https://git.kernel.org/kvmarm/kvmarm/c/bfb7a30b1986
[24/27] KVM: arm64: selftests: Add basic SError injection test
        https://git.kernel.org/kvmarm/kvmarm/c/2858ea3083f0
[25/27] KVM: arm64: selftests: Test SEAs are taken to SError vector when EASE=1
        https://git.kernel.org/kvmarm/kvmarm/c/a90aac553249
[26/27] KVM: arm64: selftests: Add SCTLR2_EL1 to get-reg-list
        https://git.kernel.org/kvmarm/kvmarm/c/55ea75f5b273
[27/27] KVM: arm64: selftests: Catch up set_id_regs with the kernel
        https://git.kernel.org/kvmarm/kvmarm/c/0b593ef12afc

--
Best,
Oliver
