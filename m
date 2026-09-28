Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4684DF4B9;
	Mon, 28 Sep 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607139; cv=none; b=jZjIetwoa4zlHALqnU5Ij3q+/BYWhXFys+fo9qv9ZmukTXsf2qLgkqWKlBsUcHcDtC7Rz/WtEGER7kiv2gNXBQCKqP8JBFTqpNlaFfXtGNmXP8wSPyqYsa/hVUP1JEOBY/tbA3kVWyOb82zc9DJQnxoIMmS4ambMjwOROShVwAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607139; c=relaxed/simple;
	bh=eCKmarELPP+tkmgPLsxqei9z0l7o8F47blhbFo6PLGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yqb30pWuyzEFAblEt+JkSPCL4SHlrDXAqO3sgZr8ZjoWI5HR/qH4rlgOXAuhT+BpZRjGWhzKDP2/TE9+wevYYcQ9ZRM/K9ORBiDFBnHhqj2fogzqoVpQB+6AuLUjEg9CHK4dyObxPJHO3i44qWC8wWAhDesIb3PKka8fVdQ42go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5/6Vexf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5/6Vexf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD52F1F00893;
	Mon, 28 Sep 2026 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790607138;
	bh=iyr4NlLoxv6GaNC3SrdEUGuR321vIy25LjTkZeQG1eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H5/6VexfmD1YPlou6xloCimV9QRguPtrF8QRjrw4xjAOGvd+KkOUeCenFHqpRBt/Q
	 07Ia7DlGUiF7CQj+W7TMbGQYlRWEzPfNXbVGSgFP4VCwveBDoJWD8ZmXe6sdAhjGH9
	 5Fc54nBFZsPn+WRjq5JRUplNI5ex8Ptt8Z9D6oLfCVJQBIOHa5cOQ6k85USeYjLYqO
	 vsNU+K93+LmFmgZSBYBVkdw9/MvE0dyb8CqfdLR4AhhvY5n5L8Ac65O0rZ2MVAiO3q
	 bCrTpCt/k0biI8TnpMBoe1hpHOZDU1F1fWdtBeaervXCJWzrBodrgBtEm76g5Zh35b
	 6SCx+iwrmCGKw==
Date: Mon, 28 Sep 2026 15:52:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] KVM: arm64: ID register finalisation fixes
Message-ID: <arp-IPET_HWSE85u@gremlin>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>

On Tue, Sep 01, 2026 at 07:18:47PM +0100, Mark Brown wrote:
> While looking at some feature enablement I noticed that there are some
> scenarios where we can end up with an inconsistently configured vCPU due
> to finalizing configuration based on ID registers before we have blocked
> writes to the ID registers. This series aims to clean up these issues.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Ran the 3/3 test locally and confirmed the test fails without 2/3, passes
with it.

Also got our AI overloads to test 1/3 locally by flipping
ID_AA64PFR0_EL1.GIC after vGIC creation:

Before:
	GIC field after vGIC create: 1
	GIC field after userspace write: 0
	GIC field after first run:     1
	HFGRTR_EL2 written 0000008000000000 read back 0000000000000000
	RESULT: FAIL - ICC_IGRPENn_EL1 forced RES0 (NV masks computed with GIC=0)

After:
	GIC field after vGIC create: 1
	GIC field after userspace write: 0
	GIC field after first run:     1
	HFGRTR_EL2 written 0000008000000000 read back 0000008000000000
	RESULT: PASS - ICC_IGRPENn_EL1 writable (NV masks match GIC=IMP)

So for the whole series:

Tested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v3:
> - Rebase onto v7.3-rc1.
> - Explain why KVM_ARCH_FLAG_ID_REGS_INITIALIZED is not reused.
> - Pull in Fuad's test cases.
> - Link to v2: https://patch.msgid.link/20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org
>
> Changes in v2:
> - Also replace the kvm_vm_has_ran_once() usage in kvm_set_vm_id_rg() and
>   kvm_vm_finalize_sys_regs() with kvm_id_regs_final().
> - Link to v1: https://patch.msgid.link/20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org
>
> ---
> Fuad Tabba (1):
>       KVM: arm64: selftests: Check ID regs are immutable after a failed run
>
> Mark Brown (2):
>       KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
>       KVM: arm64: Block ID register changes after we rely on the values
>
>  arch/arm64/include/asm/kvm_host.h               |   8 ++
>  arch/arm64/kvm/arm.c                            |   2 +-
>  arch/arm64/kvm/sys_regs.c                       |  57 ++++++++-----
>  arch/arm64/kvm/sys_regs.h                       |   2 +-
>  arch/arm64/kvm/vgic/vgic-init.c                 |   6 +-
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 106 +++++++++++++++++++++++-
>  6 files changed, 153 insertions(+), 28 deletions(-)
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260729-kvm-arm64-idreg-final-77cbc46b558a
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
>

--
Cheers, Lorenzo
