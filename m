Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0832BCF7F
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759947477; cv=none; b=QS5qE6MMUlWhYP+Xvrn5onb2h8u5R9tZqOR6N8CQSfFtHq4+6chJxNENI+JHheo192CMvIPkxU0HYO995o0n7TdEVnSdazbU/juFcwp2nXZitpwOQ5dqfnONGrMU4ytSxkl9ZeLdJjiMRASmeXDUY14kxpNe2lWu9FcJAmoURQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759947477; c=relaxed/simple;
	bh=qQD834JrMCLTFWZVnaUvLkZ40i1lASCwnpzKRhds7k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJq2iCKRUO8ob9I8fFadKUSqE2f6Awj0MbwcsJ87DSciFjeHXlYbww1Lnlf1ViDOpAtDr1Ow6C913wdjCCVCvBWgDEWP8LIvWdSP60TqNZrLhjSc0QwZYLIEvwj4mPDDt3A0MhMcjSxx+WxxfsaEpSv6WCKaWX6+EZB/YIZEPs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 645C422FC;
	Wed,  8 Oct 2025 11:17:47 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1B923F738;
	Wed,  8 Oct 2025 11:17:54 -0700 (PDT)
Date: Wed, 8 Oct 2025 19:17:52 +0100
From: Leo Yan <leo.yan@arm.com>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, alexandru.elisei@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Check cpu_has_spe() before initializing
 PMSCR_EL1 in VHE
Message-ID: <20251008181752.GD77665@e132581.arm.com>
References: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
 <aOVckTSJET5ORY1n@linux.dev>
 <861pndzn4w.wl-maz@kernel.org>
 <20251008124040.GC77665@e132581.arm.com>
 <20251008165058.lcwiapdnar6hvw3b@hu-mojha-hyd.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008165058.lcwiapdnar6hvw3b@hu-mojha-hyd.qualcomm.com>

On Wed, Oct 08, 2025 at 10:20:58PM +0530, Mukesh Ojha wrote:

[...]

> > > To me, this smells a lot more like some sort of papering over a
> > > firmware bug. Why isn't SPE available the first place?
> > 
> > TF-a grants permission to non-secure world [1], only access from secure
> > world or realm will trap to EL3.
> > 
> > So yes, it would be good to check if any issue in firmware.
> 
> We have our own implementation of EL3 and not using TF-A.

If you don't fix your firmware, you won't be able to use Arm SPE with
the Linux kernel.

> I believe, we should check in a similar way as we are doing for nVHE
> case.
> 
> if (host_data_test_flag(HAS_SPE))
> 	write_sysreg_el1(0, SYS_PMSCR);

The document Documentation/arch/arm64/booting.rst does not state that
permission for Arm SPE is mandatory, and the SPE driver [2] can
tolerate the lack of permission. So I'm fine with applying your patch
to fix the boot issue.

Thanks,
Leo

[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/perf/arm_spe_pmu.c#n1084
