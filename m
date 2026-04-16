Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E356379EF6
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776353264; cv=none; b=hwRA955czapdJE8NTrp050dGGDlL7FIIoramdKobGa8hgjxAe6QNKonGZtxbeG4/eKLftKhC+Zy7xwMKBub5Gq7japiQK4BGsZCwdqCgwwIODf/QUiAy8AnVwukPrGKjuoYDmVmnQ8NVSMPRDmHqzB5YYeoga0QLgE4VBFm2hp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776353264; c=relaxed/simple;
	bh=RrSVZhRb/2YHI3qHut56F1bpePQNruaHOT1sIhRFKEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0dax8R84NkLJ0lceMiROr6urm+o5p6h8znvK2FF1CSiVfcLK/ySaSGbzhlwVvuSNhJXG36k6ZqDlI/4eLXavUlv/2vwsPjZiqmmAFKfQiWeKbIokfFIDdpXn+cv5P4ZEQLqJodMuNWcA3IadI/NLjxzhnJ7NwIFbKiWAFn/grc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qqrUgv0T; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qqrUgv0T"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 317FE2574;
	Thu, 16 Apr 2026 08:27:36 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CE593F7B4;
	Thu, 16 Apr 2026 08:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776353261; bh=RrSVZhRb/2YHI3qHut56F1bpePQNruaHOT1sIhRFKEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qqrUgv0TYOuhTH4KjdOr8AZ3lMjbabRsXjPaO8YJB5Y/907HgAHSKWkS2+ScRGXRu
	 jHMaLVxy3B/XH2p6bxwf/AFjTfmx2mEJ9YC6h5Ua33j0alKu7Vzxu6R4YZ1Z20qD20
	 UWanFVtgkKc/08sEAiWf/ZEO4PHgbQfpSMvmNt0M=
Date: Thu, 16 Apr 2026 16:27:38 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mingwei Zhang <mizhang@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/7] lib: arm64: Generalize ESR
 exception class definitions for EL2 support
Message-ID: <20260416152738.GB3142999@e124191.cambridge.arm.com>
References: <20260413204630.1149038-1-jingzhangos@google.com>
 <20260413204630.1149038-2-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204630.1149038-2-jingzhangos@google.com>

Hi,

On Mon, Apr 13, 2026 at 01:46:24PM -0700, Jing Zhang wrote:
> Generalize some Exception Syndrome Register (ESR) definitions by
> renaming EL1-specific macros to ELx equivalents. This allows these
> constants to be shared between EL1 and EL2, supporting the upcoming
> S2MMU library implementation.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  lib/arm64/asm/esr.h   |  5 +++--
>  lib/arm64/processor.c | 10 +++++-----
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
> index 335343c5..8437916f 100644
> --- a/lib/arm64/asm/esr.h
> +++ b/lib/arm64/asm/esr.h
> @@ -12,7 +12,7 @@
>  #define ESR_EL1_CM		(1 << 8)
>  #define ESR_EL1_IL		(1 << 25)
>  
> -#define ESR_EL1_EC_SHIFT	(26)
> +#define ESR_ELx_EC_SHIFT	(26)
>  #define ESR_EL1_EC_UNKNOWN	(0x00)
>  #define ESR_EL1_EC_WFI		(0x01)
>  #define ESR_EL1_EC_CP15_32	(0x03)
> @@ -25,12 +25,13 @@
>  #define ESR_EL1_EC_ILL_ISS	(0x0E)
>  #define ESR_EL1_EC_SVC32	(0x11)
>  #define ESR_EL1_EC_SVC64	(0x15)
> +#define ESR_ELx_EC_HVC64	(0x16)
>  #define ESR_EL1_EC_SYS64	(0x18)
>  #define ESR_EL1_EC_SVE		(0x19)
>  #define ESR_EL1_EC_IABT_EL0	(0x20)
>  #define ESR_EL1_EC_IABT_EL1	(0x21)
>  #define ESR_EL1_EC_PC_ALIGN	(0x22)
> -#define ESR_EL1_EC_DABT_EL0	(0x24)
> +#define ESR_ELx_EC_DABT_LOW	(0x24)
>  #define ESR_EL1_EC_DABT_EL1	(0x25)
>  #define ESR_EL1_EC_SP_ALIGN	(0x26)
>  #define ESR_EL1_EC_FP_EXC32	(0x28)

More work, but it probably makes sense to align all of them to Linux's naming?

So ESR_ELx_EC_DABT_CUR instead of ESR_EL1_EC_DABT_EL1 etc

You can check arch/arm64/include/asm/esr.h

Thanks,
Joey

> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index f9fea519..bde3caa5 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -48,7 +48,7 @@ static const char *ec_names[EC_MAX] = {
>  	[ESR_EL1_EC_IABT_EL0]		= "IABT_EL0",
>  	[ESR_EL1_EC_IABT_EL1]		= "IABT_EL1",
>  	[ESR_EL1_EC_PC_ALIGN]		= "PC_ALIGN",
> -	[ESR_EL1_EC_DABT_EL0]		= "DABT_EL0",
> +	[ESR_ELx_EC_DABT_LOW]		= "DABT_EL0",
>  	[ESR_EL1_EC_DABT_EL1]		= "DABT_EL1",
>  	[ESR_EL1_EC_SP_ALIGN]		= "SP_ALIGN",
>  	[ESR_EL1_EC_FP_EXC32]		= "FP_EXC32",
> @@ -82,7 +82,7 @@ void show_regs(struct pt_regs *regs)
>  
>  bool get_far(unsigned int esr, unsigned long *far)
>  {
> -	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
> +	unsigned int ec = esr >> ESR_ELx_EC_SHIFT;
>  
>  	asm volatile("mrs %0, far_el1": "=r" (*far));
>  
> @@ -90,7 +90,7 @@ bool get_far(unsigned int esr, unsigned long *far)
>  	case ESR_EL1_EC_IABT_EL0:
>  	case ESR_EL1_EC_IABT_EL1:
>  	case ESR_EL1_EC_PC_ALIGN:
> -	case ESR_EL1_EC_DABT_EL0:
> +	case ESR_ELx_EC_DABT_LOW:
>  	case ESR_EL1_EC_DABT_EL1:
>  	case ESR_EL1_EC_WATCHPT_EL0:
>  	case ESR_EL1_EC_WATCHPT_EL1:
> @@ -108,7 +108,7 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
>  {
>  	unsigned long far;
>  	bool far_valid = get_far(esr, &far);
> -	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
> +	unsigned int ec = esr >> ESR_ELx_EC_SHIFT;
>  	uintptr_t text = (uintptr_t)&_text;
>  
>  	printf("Load address: %" PRIxPTR "\n", text);
> @@ -158,7 +158,7 @@ void default_vector_sync_handler(enum vector v, struct pt_regs *regs,
>  				 unsigned int esr)
>  {
>  	struct thread_info *ti = thread_info_sp(regs->sp);
> -	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
> +	unsigned int ec = esr >> ESR_ELx_EC_SHIFT;
>  
>  	if (ti->flags & TIF_USER_MODE) {
>  		if (ec < EC_MAX && ti->exception_handlers[v][ec]) {
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 
