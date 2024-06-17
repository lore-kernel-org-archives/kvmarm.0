Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F12194A6D
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 09:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718617182; cv=none; b=jdkGsM6B7Dy1l+2wyJ+PgK6cki9qB7AmCjPh0hrY06WrYgK9nIENG5Xn5LF/kWC/vlsLyr+Yv+hF+qb/GL7cTLSzGXkE7ZOwKJAK3J7/0R5VsoP5ly3A8pc4ZOOm4cDWR/USXKDZ+0QxBcrJKMB6rDOmUNgWPQpuYWQmoqrI7a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718617182; c=relaxed/simple;
	bh=82Kgz56fEOBwI0Oe2j7E2biK3+jLx5BWv7jf30JXV/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttMlLX3W6mEVCsd8wmnHyE4W6lr7JnLCM3RTFpBxLK0votSGKfgvuwUBloWLRAT+dXoG6uutM84VOCVSSIv8LVnkWeMYwVqBOJv3jjVjKA4FAhp0s04RY3IJR4ly50hTxdI61sOzWgn565T5eZSHG5ov0q46OhFeahFRSO9xTxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF7BEDA7;
	Mon, 17 Jun 2024 02:40:03 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEC6D3F64C;
	Mon, 17 Jun 2024 02:39:36 -0700 (PDT)
Date: Mon, 17 Jun 2024 10:39:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, catalin.marinas@arm.com,
	Mark Brown <broonie@kernel.org>, James Clark <james.clark@arm.com>,
	Rob Herring <robh@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Suzuki Poulose <suzuki.poulose@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-perf-users@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH V18 6/9] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
Message-ID: <ZnAEVlVZFR3DLHHb@J2N7QTR9R3>
References: <20240613061731.3109448-1-anshuman.khandual@arm.com>
 <20240613061731.3109448-7-anshuman.khandual@arm.com>
 <ZmxgZqxXWnRqwbDC@J2N7QTR9R3.cambridge.arm.com>
 <774a63cb-21e6-4ef2-b2ab-0ff8937523b2@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <774a63cb-21e6-4ef2-b2ab-0ff8937523b2@arm.com>

On Mon, Jun 17, 2024 at 12:15:15PM +0530, Anshuman Khandual wrote:
> 
> 
> On 6/14/24 20:53, Mark Rutland wrote:
> > On Thu, Jun 13, 2024 at 11:47:28AM +0530, Anshuman Khandual wrote:
> >> Disable the BRBE before we enter the guest, saving the status and enable it
> >> back once we get out of the guest. This avoids capturing branch records in
> >> the guest kernel or userspace, which would be confusing the host samples.
> > 
> > It'd be good to explain why we need to do this for nVHE, but not for
> > VHE. I *think* that you're relying on BRBCR_EL2.EL0HBRE being ignored
> > when HCR_EL2.TGE == 0, and BRBCR_EL1.E{1,0}BRE being initialized to 0
> > out-of-reset.
> 
> That's right, there is no possibility for the host and guest BRBE config
> to overlap.
> 
> > What should a user do if they *want* samples from a guest? Is that
> 
> That is not supported currently. But in order to enable capturing guest
> branch samples from inside the host - BRBCR_EL2 configs need to migrate
> into BRBCR_EL1 when the guest runs on the cpu.
> 
> > possible to do on other architectures, or do is that always prevented?
> 
> I am not sure about other architectures, but for now this falls within
> guest support which might be looked into later. But is not the proposed
> patch complete in itself without any further guest support ?

My concern here is ABI rather than actual support.

It's not clear to me how this works across architectures, and we should
have some idea of how this would work (e.g. if we're going to require
new ABI or not), so that we don't have to break ABI later on.

Mark.

> 
> > 
> > Mark.
> > 
> >>
> >> Cc: Marc Zyngier <maz@kernel.org>
> >> Cc: Oliver Upton <oliver.upton@linux.dev>
> >> Cc: James Morse <james.morse@arm.com>
> >> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Cc: Will Deacon <will@kernel.org>
> >> Cc: kvmarm@lists.linux.dev
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> CC: linux-kernel@vger.kernel.org
> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >> ----
> >> Changes in V18:
> >>
> >> - Used host_data_ptr() to access host_debug_state.brbcr_el1 register
> >> - Changed DEBUG_STATE_SAVE_BRBE to use BIT(7)
> >> - Reverted back iflags as u8
> >>
> >>  arch/arm64/include/asm/kvm_host.h  |  3 +++
> >>  arch/arm64/kvm/debug.c             |  5 +++++
> >>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 31 ++++++++++++++++++++++++++++++
> >>  3 files changed, 39 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index 36b8e97bf49e..db922c10bd2a 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -579,6 +579,7 @@ struct kvm_host_data {
> >>  		u64 trfcr_el1;
> >>  		/* Values of trap registers for the host before guest entry. */
> >>  		u64 mdcr_el2;
> >> +		u64 brbcr_el1;
> >>  	} host_debug_state;
> >>  };
> >>  
> >> @@ -842,6 +843,8 @@ struct kvm_vcpu_arch {
> >>  #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
> >>  /* Save TRBE context if active  */
> >>  #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
> >> +/* Save BRBE context if active  */
> >> +#define DEBUG_STATE_SAVE_BRBE	__vcpu_single_flag(iflags, BIT(7))
> >>  
> >>  /* SVE enabled for host EL0 */
> >>  #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
> >> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> >> index ce8886122ed3..8fa648943f0f 100644
> >> --- a/arch/arm64/kvm/debug.c
> >> +++ b/arch/arm64/kvm/debug.c
> >> @@ -336,10 +336,15 @@ void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
> >>  	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
> >>  	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
> >>  		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
> >> +
> >> +	/* Check if we have BRBE implemented and available at the host */
> >> +	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT))
> >> +		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_BRBE);
> >>  }
> >>  
> >>  void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
> >>  {
> >>  	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
> >>  	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
> >> +	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_BRBE);
> >>  }
> >> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> >> index 53efda0235cf..97e861df1b45 100644
> >> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> >> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> >> @@ -79,6 +79,32 @@ static void __debug_restore_trace(u64 trfcr_el1)
> >>  	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
> >>  }
> >>  
> >> +static void __debug_save_brbe(u64 *brbcr_el1)
> >> +{
> >> +	*brbcr_el1 = 0;
> >> +
> >> +	/* Check if the BRBE is enabled */
> >> +	if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
> >> +		return;
> >> +
> >> +	/*
> >> +	 * Prohibit branch record generation while we are in guest.
> >> +	 * Since access to BRBCR_EL1 is trapped, the guest can't
> >> +	 * modify the filtering set by the host.
> >> +	 */
> >> +	*brbcr_el1 = read_sysreg_el1(SYS_BRBCR);
> >> +	write_sysreg_el1(0, SYS_BRBCR);
> >> +}
> >> +
> >> +static void __debug_restore_brbe(u64 brbcr_el1)
> >> +{
> >> +	if (!brbcr_el1)
> >> +		return;
> >> +
> >> +	/* Restore BRBE controls */
> >> +	write_sysreg_el1(brbcr_el1, SYS_BRBCR);
> >> +}
> >> +
> >>  void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
> >>  {
> >>  	/* Disable and flush SPE data generation */
> >> @@ -87,6 +113,9 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
> >>  	/* Disable and flush Self-Hosted Trace generation */
> >>  	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
> >>  		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
> >> +	/* Disable BRBE branch records */
> >> +	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_BRBE))
> >> +		__debug_save_brbe(host_data_ptr(host_debug_state.brbcr_el1));
> >>  }
> >>  
> >>  void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
> >> @@ -100,6 +129,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
> >>  		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
> >>  	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
> >>  		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
> >> +	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_BRBE))
> >> +		__debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
> >>  }
> >>  
> >>  void __debug_switch_to_host(struct kvm_vcpu *vcpu)
> >> -- 
> >> 2.25.1
> >>
