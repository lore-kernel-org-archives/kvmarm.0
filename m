Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508B64BA9E5
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615222; cv=none; b=qjFBbQ0UXNSpRBzBPforlBMf/yDB3NIHNQhXXWiS3qLYy7/HVFS68LGEHSGK11bRJ3qo6Y1OhjG6ngGLo6Qc/oYSHMB7V5rSLF8k1h7WjcLy7E3zOvNixdVakcPJJ3KtGMjK5gw6oUOyDJAppIP5BJ6y8OGBQqFy8yrkPgXiUJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615222; c=relaxed/simple;
	bh=l3ORBw25VBHuO9/QShaOCA8lDym8+HicrdjPsN7WVCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ElqxWVxswp+SouiHIHnTVsiF3py0RDGYpIjoqxsjbTyV0RbN1xZd6tcBozrCU001qjyJoTKnaXW/1nLLee4/mbCPJI5uo/SGx6kIgVdlM73LeBDUTRi7/Ts59oR07Y+4Cy6wVO/1M8qZdNzbBTI02GtZ5zVXZmwYemMDnU3Advw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pg3UyFhG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pg3UyFhG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2D941655;
	Mon, 28 Sep 2026 10:06:52 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D781A3F763;
	Mon, 28 Sep 2026 10:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790615216; bh=l3ORBw25VBHuO9/QShaOCA8lDym8+HicrdjPsN7WVCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pg3UyFhGL87jwI8JRH6Ob6zwnj5pzjfyjAtFtarpZmIqYPkhiE6mJmdP5s1ZxFQKK
	 0tVd2MMNOwezmekw2I7kHcqKjiJUSioMECKIOf/9PC9pbSEfiWD4EPdtmJp3SgZFio
	 ayRzZ71dNjdEYWYlPeEvmaajQraIcMRHUTXZf/NA=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 21/22] KVM: arm64: selftests: Test AT emulation for FEAT_HAFT
Date: Mon, 28 Sep 2026 18:06:46 +0100
Message-ID: <arqeptfuCm4W5T-3@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-22-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-22-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:42:00AM -0700, Oliver Upton wrote:
> Test that KVM's AT emulation sets the access flag on table descriptors
> when FEAT_HAFT is enabled at stage-1. Additionally, add test coverage
> that asserts the access flag is clear on table/page descriptors when the
> AT instruction generates an access flag fault.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/at.c | 74 +++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
> index d7289f3df04f..fb7399736f44 100644
> --- a/tools/testing/selftests/kvm/arm64/at.c
> +++ b/tools/testing/selftests/kvm/arm64/at.c
> @@ -13,10 +13,11 @@
>  
>  enum {
>  	CLEAR_ACCESS_FLAG,
> -	TEST_ACCESS_FLAG,
> +	ASSERT_ACCESS_FLAG_SET,
> +	ASSERT_ACCESS_FLAG_CLEAR,

Rename Test_AF to ASSERT_ACCESS_FLAG_SET, and add a new test to 
check if the AF is clear.

>  };
>  
> -static u64 *ptep_hva;
> +static u64 *page_ptep, *table_ptep;
>  

So tables' AF can be checked.

>  #define copy_el2_to_el1(reg)						\
>  	write_sysreg_s(read_sysreg_s(SYS_##reg##_EL1), SYS_##reg##_EL12)
> @@ -45,11 +46,12 @@ do {											\
>  		__GUEST_ASSERT(fsc == ESR_ELx_FSC_ACCESS_L(3),				\
>  			       "AT "#op": expected access flag fault (par: %lx)",	\
>  			       par);							\
> +		GUEST_SYNC(ASSERT_ACCESS_FLAG_CLEAR);					\
>  	} else {									\
>  		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_ATTR, par), MAIR_ATTR_NORMAL);	\
>  		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_SH, par), PTE_SHARED >> 8);	\
>  		GUEST_ASSERT_EQ(par & SYS_PAR_EL1_PA, TEST_ADDR);			\
> -		GUEST_SYNC(TEST_ACCESS_FLAG);						\
> +		GUEST_SYNC(ASSERT_ACCESS_FLAG_SET);					\

If fault is expected, check if the AF is clear,
if fault is not expected, check if the AF is set.

>  	}										\
>  } while (0)
>  
> @@ -68,6 +70,14 @@ static void test_at(bool expect_fault)
>  	isb();
>  }
>  
> +static bool guest_has_haft(void)
> +{
> +	u64 mmfr1 = read_sysreg(id_aa64mmfr1_el1);
> +
> +	return SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, mmfr1) >=
> +		ID_AA64MMFR1_EL1_HAFDBS_HAFT;
> +}
> +
>  static void guest_code(void)
>  {
>  	/* Reuse the stage-1 MMU context from EL2 at EL1 */
> @@ -93,9 +103,43 @@ static void guest_code(void)
>  	isb();
>  	test_at(false);
>  
> +	if (!guest_has_haft())
> +		GUEST_DONE();

Previous HAF test ends here, all below is about HAFT.

> +
> +	sysrec_clear_set_s(SYS_HCRX_EL2, 0, HCRX_EL2_TCR2En);
> +	sysreg_clear_set_s(SYS_TCR2_EL12, 0, TCR2_EL1_HAFT);
> +	isb();
> +	test_at(false);

No trapping when writing to TCR2_EL1, then write to TCR2_EL12 (can redirect 
to TCR_EL1) to enable HAFT. When tested, AF should be set, and a fault is 
not expected. Seems right.

> +
> +	/* The effective value of HAFT is 0 if HA is 0 */
> +	sysreg_clear_set_s(SYS_TCR_EL12, TCR_HA, 0);
> +	isb();
> +	test_at(true);

Now clears TCR_EL21.HA, which means HAFT should not work as well, not 
setting a AF for neither, and causing a fault. Assert will test if both 
pte and ptet AF will be zeroed. 
Seems right for testing HAFT -> HA dependency.

> +
> +	/* The effective value of HAFT is 0 if HCRX_EL2.TCR2En is 0 */
> +	sysreg_clear_set_s(SYS_HCRX_EL2, HCRX_EL2_TCR2En, 0);
> +	sysreg_clear_set_s(SYS_TCR_EL12, 0, TCR_HA);
> +	isb();
> +	test_at(false);

Cleans HCRX_EL2_TCR2En then re-enables HA, which means HA should be 
enabled, but HAFT should not.

Since it expect not to fault, it means it's expecting the flags to be set, 
running ASSERT_ACCESS_FLAG_SET. That will check if the pte.AF==1, then 
since HCRX_EL2_TCR2En=0, vcpu_haft_enabled() returns 0, and 
ASSERT_ACCESS_FLAG_SET checks if ptet.AF==0.

Seems correct so far.

It's kind of hard to follow all the flag status by the test routine alone,  
though. The previous test was just a single flag, which was always set when 
a fault did not happen. Now we have two flags, and the second one which 
don't directly relate to the faulting.

Thanks to that, the testing logic of the second flag has to happen in the 
handle_sync code, which seems decoupled from the guest test.

Maybe it could be more clear if test_at() received parameters related to 
ptet_af_set as well, and we could have a second GUEST_SYNC to check if the 
ptet.AF is either set or reset, based on that parameter?

Or maybe I am overthinking this.

In any case, seems to test the feature correctly. 

With the fix of sashiko's typo, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo



> +
>  	GUEST_DONE();
>  }
>  
> +static bool vcpu_haft_enabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 mmfr1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR1_EL1));
> +	u8 hafdbs = SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, mmfr1);
> +	u64 tcr2, hcrx;
> +

> +	/* FEAT_HAFT implies FEAT_TCRX, FEAT_HCX */
> +	if (hafdbs < ID_AA64MMFR1_EL1_HAFDBS_HAFT)
> +		return false;
> +
> +	hcrx = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCRX_EL2));
> +	tcr2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR2_EL1));
> +	return hcrx & HCRX_EL2_TCR2En && tcr2 & TCR2_EL1_HAFT;
> +}
> +
>  static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
>  {
>  	switch (uc->args[1]) {
> @@ -109,12 +153,25 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
>  		 * ensures that the access flag cannot be set speculatively
>  		 * and is reliably cleared at the time of the AT instruction.
>  		 */
> -		clear_bit(__ffs(PTE_AF), ptep_hva);
> +		clear_bit(__ffs(PTE_AF), page_ptep);
> +		clear_bit(__ffs(PTE_AF), table_ptep);
>  		vm_mem_region_reload(vcpu->vm, vcpu->vm->memslots[MEM_REGION_PT]);
>  		break;
> -	case TEST_ACCESS_FLAG:
> -		TEST_ASSERT(test_bit(__ffs(PTE_AF), ptep_hva),
> -			    "Expected access flag to be set (desc: %lu)", *ptep_hva);
> +	case ASSERT_ACCESS_FLAG_SET:
> +		TEST_ASSERT(test_bit(__ffs(PTE_AF), page_ptep),
> +			    "Expected access flag to be set (desc: %lu)", *page_ptep);
> +		if (!vcpu_haft_enabled(vcpu))
> +			TEST_ASSERT(!test_bit(__ffs(PTE_AF), table_ptep),
> +				    "Expected access flag to be clear (desc: %lu)", *table_ptep);
> +		else
> +			TEST_ASSERT(test_bit(__ffs(PTE_AF), table_ptep),
> +				    "Expected access flag to be set (desc: %lu)", *table_ptep);
> +		break;
> +	case ASSERT_ACCESS_FLAG_CLEAR:
> +		TEST_ASSERT(!test_bit(__ffs(PTE_AF), page_ptep),
> +			    "Expected access flag to be clear (desc: %lu)", *page_ptep);
> +		TEST_ASSERT(!test_bit(__ffs(PTE_AF), table_ptep),
> +			    "Expected access flag to be clear (desc: %lu)", *table_ptep);
>  		break;
>  	default:
>  		TEST_FAIL("Unexpected SYNC arg: %lu", uc->args[1]);
> @@ -158,7 +215,8 @@ int main(void)
>  	kvm_arch_vm_finalize_vcpus(vm);
>  
>  	virt_map(vm, TEST_ADDR, TEST_ADDR, 1);
> -	ptep_hva = virt_get_pte_hva_at_level(vm, TEST_ADDR, 3);
> +	page_ptep = virt_get_pte_hva_at_level(vm, TEST_ADDR, 3);
> +	table_ptep = virt_get_pte_hva_at_level(vm, TEST_ADDR, 2);
>  	run_test(vcpu);
>  
>  	kvm_vm_free(vm);
> -- 
> 2.47.3
> 
