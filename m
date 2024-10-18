Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C682C18E350
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 21:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729285393; cv=none; b=Xv5/ljceRIgVDguaM6BWmHvTh/jkyUt4pqRi5tNk0TjARj1mi1AcJtcML9APSxp4c6/AUSKI+C11d7IytAxhANKou/ko5Ue751Bkbmm6vs+1c6LSle2pJXYOFOnXIoFm9dzXl+B4BsqtodksJqk84Vmmf5Y45k19Vwdk93+0GRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729285393; c=relaxed/simple;
	bh=lD+xgZ9PJuiAIBrLQfFdjsMYP4KvqFSc8lPY4NjCwWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEPZYbdrhkvowmw2syi24TSq2Rj9bUU2DjxCKDqw8Q1IFlzBMXLotGe930qc5cs2TowFHE8xkutMpaKR5+oruAUTflPHuhRcBTgDBRRljRciHCGqKqh47I62xacdkdgPXR6fEirUTjgLcjae2txuHOj2PyYoOacZEEwCBHZAxFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DuKgRci3; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DuKgRci3"
Date: Fri, 18 Oct 2024 21:03:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729285388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XNvuLASMj292AxqyahadmF64JemIStQYFSkvBYcRWwY=;
	b=DuKgRci3aTMt5dmKzlR0TedEQOb1IFvzme1b5Er/S54koUQMVym6/+s+fvRHSLTjyl+dzM
	G0/scqzfKEevZL0/i+kBlGdxaLhcj7K38kqzSNMy0dzGNcWczAu7YB5ITrRoJ6mfmjqOMo
	qQQbZNTr9hTMqO52/P6MY2kA8P/TPCo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Add tests for MMIO external
 abort injection
Message-ID: <ZxLNBh6h0Nb9QR0t@linux.dev>
References: <20241018194757.3685856-1-oliver.upton@linux.dev>
 <20241018194757.3685856-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018194757.3685856-3-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 18, 2024 at 07:47:57PM +0000, Oliver Upton wrote:
> Test that the plumbing exposed to userspace for injecting aborts in
> response to unexpected MMIO works as intended in two different flavors:
> 
>  - A 'normal' MMIO instruction (i.e. ESR_ELx.ISV=1)
> 
>  - An ISV=0 MMIO instruction with/without KVM_CAP_ARM_NISV_TO_USER
>    enabled
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/mmio_abort.c        | 158 ++++++++++++++++++
>  2 files changed, 159 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/mmio_abort.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 960cf6a77198..98957a99ead6 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -156,6 +156,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/aarch32_id_regs
>  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
> +TEST_GEN_PROGS_aarch64 += aarch64/mmio_abort
>  TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
>  TEST_GEN_PROGS_aarch64 += aarch64/psci_test
>  TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
> diff --git a/tools/testing/selftests/kvm/aarch64/mmio_abort.c b/tools/testing/selftests/kvm/aarch64/mmio_abort.c
> new file mode 100644
> index 000000000000..08c4afec1f28
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/mmio_abort.c
> @@ -0,0 +1,158 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * mmio_abort - Tests for userspace MMIO abort injection
> + *
> + * Copyright (c) 2024 Google LLC
> + */
> +#include "processor.h"
> +#include "test_util.h"
> +
> +#define MMIO_ADDR	0x8000000ULL
> +
> +#define ESR_ELx_FSC_EXTABT	(0x10)
> +
> +static u64 expected_abort_pc;
> +
> +static void expect_sea_handler(struct ex_regs *regs)
> +{
> +	GUEST_ASSERT_EQ(regs->pc, expected_abort_pc);
> +	GUEST_ASSERT(read_sysreg(esr_el1) & ESR_ELx_FSC_EXTABT);
> +

This needs to extract and compare the entire FSC field, I'll fix it the
next time around.

-- 
Thanks,
Oliver
