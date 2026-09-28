Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F59F367F26
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790611320; cv=none; b=TfTirWbpFs5aPLjRL9d9sFeueLhW719b6mPZnNVaCms+BPPXcQV4apNdH7z3DIP+Ys1zz7Jl2YUjrId1mKPaL1wWiWGOsUf6/u6uk5Aw2lBWzL5k55XH5Alu0qxnx5C+IvjxdAV+MZXEJpvggm8WgX9SEWaGBLYd3HwQuTCD/ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790611320; c=relaxed/simple;
	bh=P57+Mq0JBY8tMh9uwDgpAXGb5R4q7qXPEcatPTTVm2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=IS4PaifhI3PvQVjnK1xuv7/WYN3/pC7cxtqQdjQ7YqgerNoQgHBSrSoJoDZzAcTzmjJ2vaqzuZVN9hDNTT5lWTSoUA5bYmqfYRdLzledtPnfCyY//VIR42Mft/xWihBInE/gdYj51iDqyVNJivgXi5GIFyLtYsKRwvUA0lXTcSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MqYb9ccQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MqYb9ccQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 670811655;
	Mon, 28 Sep 2026 09:01:54 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D34E3F763;
	Mon, 28 Sep 2026 09:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790611317; bh=P57+Mq0JBY8tMh9uwDgpAXGb5R4q7qXPEcatPTTVm2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqYb9ccQ+S/rDF3her3n4aoiwwRrYE39ExWodPdewQIVolQ9s2H+R7jHQCT7UHPiq
	 KktClRnlG6mV3RVeLFQkbP2MevcQAaudfEjlrb4JbZHcly6G7Ec0oRHU44/BnlUUCM
	 UipbAozfyrxqUr5UBS8TTco7ZFElY247BR+MgygM=
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
Subject: Re: [PATCH 20/22] KVM: arm64: selftests: Only test AF behavior for emulated AT insns
Date: Mon, 28 Sep 2026 17:01:48 +0100
Message-ID: <arqPbFRxSVfYTuRS@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-21-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-21-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:59AM -0700, Oliver Upton wrote:
> The original intent of the test was to test KVM's slowpath AT emulation,
> specifically including a test for KVM's IMP DEF choice that AT
> instructions set the access flag.
> 
> While it is possible to force AT instructions to take the slow path in
> KVM, this is only effective for an out-of-context regime wherein the
> stage-2 translations are guaranteed to be invalid. As such, the
> inclusion of AT S1E2* instructions muddied this a bit, as they operate
> on the in-context EL2&0 regime.
> 
> Restore the original intent of the test and get rid of the AT S1E2* test
> cases entirely.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/at.c | 38 ++++++++++++++++----------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
> index ce5d312ef6ba..d7289f3df04f 100644
> --- a/tools/testing/selftests/kvm/arm64/at.c
> +++ b/tools/testing/selftests/kvm/arm64/at.c
> @@ -13,6 +13,7 @@
>  
>  enum {
>  	CLEAR_ACCESS_FLAG,
> +	TEST_ACCESS_FLAG,
>  };
>  
>  static u64 *ptep_hva;
> @@ -48,21 +49,12 @@ do {											\
>  		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_ATTR, par), MAIR_ATTR_NORMAL);	\
>  		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_SH, par), PTE_SHARED >> 8);	\
>  		GUEST_ASSERT_EQ(par & SYS_PAR_EL1_PA, TEST_ADDR);			\
> +		GUEST_SYNC(TEST_ACCESS_FLAG);						\
>  	}										\
>  } while (0)
>  
>  static void test_at(bool expect_fault)
>  {
> -	test_at_insn(S1E2R, expect_fault);
> -	test_at_insn(S1E2W, expect_fault);

This seems to be the getting rid of AT S1E2* tests.

> -
> -	/* Reuse the stage-1 MMU context from EL2 at EL1 */
> -	copy_el2_to_el1(SCTLR);
> -	copy_el2_to_el1(MAIR);
> -	copy_el2_to_el1(TCR);
> -	copy_el2_to_el1(TTBR0);
> -	copy_el2_to_el1(TTBR1);
> -
>  	/* Disable stage-2 translation and enter a non-host context */
>  	write_sysreg(0, vtcr_el2);
>  	write_sysreg(0, vttbr_el2);
> @@ -71,11 +63,21 @@ static void test_at(bool expect_fault)
>  
>  	test_at_insn(S1E1R, expect_fault);
>  	test_at_insn(S1E1W, expect_fault);
> +
> +	sysreg_clear_set(hcr_el2, 0, HCR_EL2_TGE | HCR_EL2_VM);
> +	isb();

Setting bits that were clean in the start.

>  }
>  
>  static void guest_code(void)
>  {
> -	sysreg_clear_set(tcr_el1, TCR_HA, 0);
> +	/* Reuse the stage-1 MMU context from EL2 at EL1 */
> +	copy_el2_to_el1(SCTLR);
> +	copy_el2_to_el1(MAIR);
> +	copy_el2_to_el1(TCR);
> +	copy_el2_to_el1(TTBR0);
> +	copy_el2_to_el1(TTBR1);

Set them only once instead of on every test, since they should not change.

> +
> +	sysreg_clear_set_s(SYS_TCR_EL12, TCR_HA, 0);
>  	isb();
>  
>  	test_at(true);
> @@ -83,7 +85,11 @@ static void guest_code(void)
>  	if (!SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, read_sysreg(id_aa64mmfr1_el1)))
>  		GUEST_DONE();
>  
> -	sysreg_clear_set(tcr_el1, 0, TCR_HA);
> +	/*
> +	 * KVM's software PTW makes the implementation choice that the AT
> +	 * instruction sets the access flag.
> +	 */
> +	sysreg_clear_set_s(SYS_TCR_EL12, 0, TCR_HA);

clear_set -> clear_set_s and added some docs

>  	isb();
>  	test_at(false);
>  
> @@ -96,8 +102,8 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
>  	case CLEAR_ACCESS_FLAG:
>  		/*
>  		 * Delete + reinstall the memslot to invalidate stage-2
> -		 * mappings of the stage-1 page tables, allowing KVM to
> -		 * potentially use the 'slow' AT emulation path.
> +		 * mappings of the stage-1 page tables, forcing KVM to
> +		 * use the 'slow' AT emulation path.

After the removal of AT S1E2*, this should always cause KVM to use the 
slow path.

>  		 *
>  		 * This and clearing the access flag from host userspace
>  		 * ensures that the access flag cannot be set speculatively
> @@ -106,6 +112,10 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
>  		clear_bit(__ffs(PTE_AF), ptep_hva);
>  		vm_mem_region_reload(vcpu->vm, vcpu->vm->memslots[MEM_REGION_PT]);
>  		break;
> +	case TEST_ACCESS_FLAG:
> +		TEST_ASSERT(test_bit(__ffs(PTE_AF), ptep_hva),
> +			    "Expected access flag to be set (desc: %lu)", *ptep_hva);
> +		break;

For testing the access flag when a fault is not expected, during the AT 
test.

If I got the reasonings above correctly, then FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
