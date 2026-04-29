Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D7123EAB7
	for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474057; cv=none; b=SOSVD7EeYa4GaoLJoPMFTtMXXH5KG0Rb6jcVJ0rUGEY9/JaMVOieFXz42FkaMhi54Q0bFzK3yI7M/Fmay71YeSd6AiTsxfMwDpt+p8RqYXsiamb1kfaQJ9HhS94mIDUVeP+Ur8jfnmdHTIuSYP2g9U8rI/+hKa/97f7YNd2toxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474057; c=relaxed/simple;
	bh=2in3eMiiZSrAVpz+caYg5ek9hYdKy1xEMKSOlwXlxGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGBhICyi158ekjdpPunmF9LhYNHNr7mLm+scScSb6bQdKLO9s40E65bOoInyi2Wto3XG1sx5WiXWJ+1W1ETanz7XuBHz9qZOz3+QrNsSe2FVrQHywLOZH5HcNUXqElaqKvsUi3kQOskbASmdRyhat6iRgyZWQJfVKFf+S5IqB3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hVaZ6Kzd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hVaZ6Kzd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6DD71596;
	Wed, 29 Apr 2026 07:47:29 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31DAB3F62B;
	Wed, 29 Apr 2026 07:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777474055; bh=2in3eMiiZSrAVpz+caYg5ek9hYdKy1xEMKSOlwXlxGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hVaZ6Kzd/kGLPBLVw+0LROWBbTXrmk6tl7YkVzOUysNEZu2l1mX7JmRlcFlHNiNdZ
	 lqcSWYf6rU7rOuP7hccaH6bNuM4A0tJIFzZevxL7DnIKMUa+V46kcwprLhdSXgsm31
	 yFkc80/QwkIlP7HOjiJdAjKAqbuBFL+cef0Yrhfo=
Date: Wed, 29 Apr 2026 15:47:21 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, 
	KVMARM <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, 
	Andrew Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Mingwei Zhang <mizhang@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [kvm-unit-tests PATCH v2 7/7] arm64: Add Stage-2 MMU demand
 paging test
Message-ID: <rzf7qwao73tdzu5xm47atmbul4j5qjll2patehuxgliync72vr@2trwlhhhvhn6>
References: <20260413204630.1149038-1-jingzhangos@google.com>
 <20260413204630.1149038-8-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204630.1149038-8-jingzhangos@google.com>

On Mon, Apr 13, 2026 at 01:46:30PM -0700, Jing Zhang wrote:
> Introduce a new test case to validate Stage-2 MMU fault handling. The
> test verifies that the hypervisor correctly identifies and handles
> Stage-2 data aborts triggered by a guest accessing unmapped memory.
> 
> The test performs the following:
> - Sets up a guest with Stage-1 disabled, using identity-mapped host
>    code and shared data in the Stage-2 page tables.
> - Triggers a Stage-2 data abort by accessing a specific unmapped IPA.
> - Catches the exception in the host, verifies the fault address,
>    and dynamically maps a new page to resolve the fault.
> - Resumes the guest to confirm the memory access completes successfully
>    and the fault handler functioned as expected.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arm/Makefile.arm64    |   1 +
>  arm/stage2-mmu-test.c | 107 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 108 insertions(+)
>  create mode 100644 arm/stage2-mmu-test.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 9026fd71..e547f92d 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -67,6 +67,7 @@ tests += $(TEST_DIR)/cache.$(exe)
>  tests += $(TEST_DIR)/debug.$(exe)
>  tests += $(TEST_DIR)/fpu.$(exe)
>  tests += $(TEST_DIR)/mte.$(exe)
> +tests += $(TEST_DIR)/stage2-mmu-test.$(exe)
>  
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>  
> diff --git a/arm/stage2-mmu-test.c b/arm/stage2-mmu-test.c
> new file mode 100644
> index 00000000..0df4704b
> --- /dev/null
> +++ b/arm/stage2-mmu-test.c
> @@ -0,0 +1,107 @@
> +/*
> + * ARM64 Stage-2 MMU Demand Paging Test
> + *
> + * This test validates stage-2 data abort handling by purposefully
> + * accessing unmapped memory in the guest and verifying that the
> + * host correctly handles the fault by mapping the page.
> + *
> + * Copyright (C) 2026 Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <asm/io.h>
> +#include <asm/smp.h>
> +#include <asm/guest.h>
> +#include <asm/stage2_mmu.h>
> +
> +#define TEST_PAGE_IPA		0x40000000UL
> +#define FAULT_ADDR_IPA		0x50000000UL
> +#define TEST_DATA		0xBEEFCAFEUL
> +
> +static volatile bool handled = false;
> +
> +static void guest_code(void)
> +{
> +	volatile unsigned long *test_va = (void *)TEST_PAGE_IPA;
> +	volatile unsigned long *fault_va = (void *)FAULT_ADDR_IPA;
> +
> +	*fault_va = *test_va;
> +
> +	if (*fault_va == *test_va)
> +		handled = true;
> +
> +	asm("hvc #0");
> +}
> +
> +static enum guest_handler_result guest_exception_handler(struct guest *guest)
> +{
> +	unsigned long far, ec;
> +	unsigned long *fixup_page;
> +
> +	ec = guest->esr_el2 >> ESR_ELx_EC_SHIFT;
> +
> +	if (ec == ESR_ELx_EC_HVC64) {
> +		report_info("CPU%d: Guest exited via HVC.", smp_processor_id());
> +		return GUEST_ACTION_EXIT;
> +	}
> +
> +	if (ec == ESR_ELx_EC_DABT_LOW) {
> +		far = guest->far_el2;
> +		if (far == FAULT_ADDR_IPA) {
> +			fixup_page = alloc_page();
> +			s2mmu_map(guest->s2mmu, FAULT_ADDR_IPA,
> +				  virt_to_phys(fixup_page), PAGE_SIZE, S2_MAP_RW);
> +			report(true, "Caught stage-2 fault at 0x%lx", far);
> +		} else {
> +			report(false, "Unexpected fault address: 0x%lx", far);
> +		}
> +	} else {
> +		report(false, "Unexpected exception class: 0x%lx", ec);
> +	}
> +
> +	return GUEST_ACTION_RESUME;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct guest *guest;
> +	unsigned long *test_page;
> +	unsigned long code_va_base, code_pa_base, data_base;
> +
> +	report_prefix_push("stage2-mmu");
> +
> +	guest = guest_create(smp_processor_id(), guest_code, S2_PAGE_4K);

As Marc pointed out ([1]), 4K is not guaranteed to work at stage-2, so
we should check ID_AA64MMFR0_EL1.TGran*_2 before creating s2.

On the same note, the minimum value of guest VTCR_EL2.T0SZ is bounded by
the implemented PA size i.e. ID_AA64MMFR0_EL1.PARange. Therefore in
s2mmu_enable() (patch 2) just doing 64 - VA_BITS can generate an
unsupported T0SZ.

Thanks,
Wei-Lin Chang

[1]: https://lore.kernel.org/kvmarm/86mrzw468z.wl-maz@kernel.org/

> +
> +	/* Map host code: IPA(VA) -> PA */
> +	/* We use the host VA as the Guest IPA because guest stage 1 is disabled. */
> +	code_va_base = (unsigned long)guest_code;
> +	code_pa_base = virt_to_phys((void *)guest_code);
> +
> +	/* Align to 2MB to use block descriptors where possible */
> +	code_va_base = code_va_base & ~(SZ_2M - 1);
> +	code_pa_base = code_pa_base & ~(SZ_2M - 1);
> +	s2mmu_map(guest->s2mmu, code_va_base, code_pa_base, SZ_2M, S2_MAP_RW);
> +
> +	/* Identity map the shared variable */
> +	data_base = virt_to_phys((void *)&handled) & PAGE_MASK;
> +	s2mmu_map(guest->s2mmu, data_base, data_base, PAGE_SIZE, S2_MAP_RW);
> +
> +	/* Map test data page */
> +	test_page = alloc_page();
> +	*test_page = TEST_DATA;
> +	s2mmu_map(guest->s2mmu, TEST_PAGE_IPA, virt_to_phys(test_page), PAGE_SIZE, S2_MAP_RW);
> +
> +	guest_install_handler(guest, ELx_LOW_SYNC_64, guest_exception_handler);
> +
> +	report_info("CPU%d: entering guest...", smp_processor_id());
> +
> +	guest_run(guest);
> +
> +	report(handled, "Stage-2 fault handling test completed");
> +	guest_destroy(guest);
> +
> +	return report_summary();
> +}
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 
