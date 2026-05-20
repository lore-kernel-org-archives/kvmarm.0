Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971B73161BA
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292178; cv=none; b=JV7GtL5ulDN81y/QensRVYz8VO+1fvCpFCBJTHAwcr3vefaoR0AZndYHP1tCdKvnTRc/thiVLsi7W0CEeAzdC4AP5NfkvnRS+dW49sTX2AkOPXZRfp8+j9Hb04tF4SlfbsdRK6Qz2TWMZZG5EkxN89XKhmq4JsqFHOw3EDuAmd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292178; c=relaxed/simple;
	bh=LyR3f2rA2pylGWpWBsh0adMCtpvnTTewxkTOdQ5JS1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dP6VeLMU1kbaZmhQPnHgY42i0B5lbBFfWoX+74VNBWkxJZMMBB/jXNaQC7B3zR3cpv1kQKP4XlMzfgOft8qijbR18g0CHWd5cAAxokpIuf2J9n7przAjaHyy0YK/Vw/CrRkvPd+U3bhPe+sWG0a5PBtwJuMTJUXCMNbayWT4QBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kq/wTmYA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kq/wTmYA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDBEE25DE;
	Wed, 20 May 2026 08:49:29 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B15663F632;
	Wed, 20 May 2026 08:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779292174; bh=LyR3f2rA2pylGWpWBsh0adMCtpvnTTewxkTOdQ5JS1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kq/wTmYAH+1FbSrYpYAuk5sk/9cgXMPXVVLu0qrSsw+iqZ93zDPhuE7r3tI7HuUk1
	 rvA8xVsBgmyW/cdeY/pSqgHH/Jj/j/PfztVJaymJn8njok2rE+WjaDBEj2hcF43P+7
	 Qq0n0Qg/ljel32xV5yE0eLSBeGoGt+6NX2uqd0+E=
Date: Wed, 20 May 2026 16:49:30 +0100
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
Subject: Re: [kvm-unit-tests PATCH v2 6/7] lib: arm64: Add guest-internal
 exception handling (EL1)
Message-ID: <20260520154930.GC4037194@e124191.cambridge.arm.com>
References: <20260413204630.1149038-1-jingzhangos@google.com>
 <20260413204630.1149038-7-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204630.1149038-7-jingzhangos@google.com>

On Mon, Apr 13, 2026 at 01:46:29PM -0700, Jing Zhang wrote:
> Implement the infrastructure for managed guests to handle their own
> exceptions at EL1. This allows guests to manage internal traps
> independently of the EL2 host.
> 
> Changes include:
> - 'guest_el1_vectors': A dedicated EL1 vector table for guests,
>   supporting synchronous exceptions, IRQs, FIQs, and SErrors.
> - 'guest_context': A per-guest metadata structure tracked via
>   TPIDR_EL1, containing a dispatch table for guest-internal handlers.
> - 'guest_el1_c_handler': C-level dispatcher that executes registered
>   guest handlers or triggers an HVC trap back to the host for unhandled
>   exceptions.
> - Integrated setup: guest_create() now allocates and maps the guest
>   context, while the context switch logic ensures VBAR_EL1 and
>   TPIDR_EL1 are correctly saved and restored.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  lib/arm64/asm-offsets.c |  2 ++
>  lib/arm64/asm/guest.h   | 26 ++++++++++++++
>  lib/arm64/asm/sysreg.h  |  1 +
>  lib/arm64/guest.c       | 39 +++++++++++++++++++++
>  lib/arm64/guest_arch.S  | 78 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 146 insertions(+)
> 
> diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
> index ceeecce5..fc9f28fb 100644
> --- a/lib/arm64/asm-offsets.c
> +++ b/lib/arm64/asm-offsets.c
> @@ -37,11 +37,13 @@ int main(void)
>  	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
>  	OFFSET(GUEST_VTTBR_OFFSET, guest, vttbr_el2);
>  	OFFSET(GUEST_SCTLR_OFFSET, guest, sctlr_el1);
> +	OFFSET(GUEST_VBAR_OFFSET, guest, vbar_el1);
>  	OFFSET(GUEST_SP_EL1_OFFSET, guest, sp_el1);
>  	OFFSET(GUEST_ESR_OFFSET, guest, esr_el2);
>  	OFFSET(GUEST_FAR_OFFSET, guest, far_el2);
>  	OFFSET(GUEST_HPFAR_OFFSET, guest, hpfar_el2);
>  	OFFSET(GUEST_EXIT_CODE_OFFSET, guest, exit_code);
> +	OFFSET(GUEST_TPIDR_EL1_OFFSET, guest, tpidr_el1);
>  
>  	return 0;
>  }
> diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
> index b99641ef..8b40f3a5 100644
> --- a/lib/arm64/asm/guest.h
> +++ b/lib/arm64/asm/guest.h
> @@ -29,6 +29,26 @@ enum guest_handler_result {
>  struct guest;
>  typedef enum guest_handler_result (*guest_handler_t)(struct guest *guest);
>  
> +/*
> + * Guest EL1 Exception Frame (pushed to guest stack by asm stub)
> + * We use a simplified frame: x0-x30, elr, spsr. size = 33*8
> + */
> +struct guest_el1_regs {
> +	unsigned long regs[31];
> +	unsigned long elr;
> +	unsigned long spsr;
> +};

This struct is not a multiple of 16 (currently 264), it's convention to keep
stack aligned to 16-bytes so maybe add a dummy field.

Also you can add a DEFINE() for sizeof(guest_el1_regs) in
lib/arm64/asm-offsets.c, to avoid needing to hardcode the size in asm.

Thanks,
Joey

> +
> +typedef void (*guest_el1_handler_t)(struct guest_el1_regs *regs, unsigned int esr);
> +
> +/*
 
[..]
