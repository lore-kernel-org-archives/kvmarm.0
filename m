Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A53DA7F5;
	Mon, 15 Jun 2026 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781517954; cv=none; b=cpVJRaYzvQiLwQPIHRBr+ttu3WvplxBFAwLR5EVik39dX3pALzdstMojEXFK/kMe8Wj0FjrfgdRtsMjPkPN5tndEznGqe2zd9rdxoNfGgEI0u8g/lbKD2kgSf18O9Z0q8CfZtuoYVN80D0Jq6lH154j5g7b7HXPBtot+HJMWbY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781517954; c=relaxed/simple;
	bh=OKQfWFagaFzNVZtDJ0SPphtyEMKB/uQZ4647RGEST5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alHPHr2K3mvm6CrwSS6AKQs04+EZ4RHUqE5w19ednTOd3H6Re/A3uHZSIzYu3eMFo/wUtTdbXYjtF++tODdHvTbJNd0A8Z3Rotd5PeAmLNOhyFnBj++Y8VylBF3YxRtrgeGo9CjMbNbzFq1tcEUPFFKxtO1wFltOaLQhN2sxSvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwVYscLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwVYscLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA1C1F000E9;
	Mon, 15 Jun 2026 10:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781517952;
	bh=ny9fmkEzONcVs1e5iE8VcrCvNlMLooF3aRovoZzxOnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PwVYscLwLhiJJdb+Hvdhutlv/vueIApMWJs9iI2ewp31Z2K7vt2UZRpBFwgxIG5EH
	 NxqZQaBujMwPQV/dpIKyQceymaStGgC81Qi82u1S7o9Eu5GPPDSHJ4MbzwxqOZ6C3x
	 rPkzZrcu1GT8/HPdzqgJIEYGxvBgoqivC664QFCTbofWU7Z+97MntiDMSl/add1U2e
	 77B4160ITB40fMKBTCNvMHKlUR1DSqYJqT0YAEd2VqyF25zXqSP/wz/2PDMt6sA1Pv
	 ofQDwUuySJe8jVRIgXMVMgZxAYPMVkg6FGCoHLYMDIxG+c8kOAlEzFOESurbBdJP71
	 6uWWrgwelVvfQ==
Date: Mon, 15 Jun 2026 11:05:46 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception
 into a pVM
Message-ID: <ai_OevUNS-OACPm7@willie-the-truck>
References: <20260612113414.1022901-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612113414.1022901-1-tabba@google.com>

On Fri, Jun 12, 2026 at 12:34:14PM +0100, Fuad Tabba wrote:
> When pKVM injects a synchronous exception into a protected guest, it
> re-enters without restoring the guest's EL1 sysregs and writes the EL1
> exception registers to hardware by hand: ESR_EL1 and ELR_EL1, but not
> SPSR_EL1. enter_exception64() sets SPSR_EL1 (the interrupted PSTATE)
> only in memory, so the guest's handler reads a stale SPSR_EL1 and
> restores the wrong PSTATE on eret.
> 
> Write SPSR_EL1 alongside the other exception registers.
> 
> Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
> Reported-by: sashiko <sashiko@sashiko.dev>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 8c3fbb413a06..1a7d5cd16d72 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -268,6 +268,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
>  
>  	write_sysreg_el1(esr, SYS_ESR);
>  	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> +	write_sysreg_el1(read_sysreg_el2(SYS_SPSR), SYS_SPSR);
>  	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
>  	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
>  }

Is SPSR_EL1 not set in enter_exception64() using vcpu_cpsr(vcpu), which
*is* set here? I'm just a bit wary of the report, as I'd have expected
fireworks if we weren't initialising the guest's SPSR on the exception
injection path.

Will
