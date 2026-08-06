Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692C2448399
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012236; cv=none; b=BE4w7J6HI5qOfZMUqDm3dvojEIxHdgL6CvRO9WHmhb5MIl8BGmBNX+UKEs3W8qs+GexEznvfGjf01Ugih2Tl5emCNrk2lzFlOekhFaPQfB0Am7gP/FbysxefMGoe91hwrDyTQ5lDieFsM9ChqAOrKSfCR5N23r75n5ABLCuOSb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012236; c=relaxed/simple;
	bh=oAv50T8xwff7UHt0lxGZW6rlXPJ54zctMsKzlERzAgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEhHktlMavALqkrlHRw5JgZ7QLbjTb4zQ12CyoWSgmHZkB4e1EG3dIy/nsELZ9mDuqhuIK6L3SVfBBFaxj3wwfya5w4JlJYCY8LbUYPvEhegxMHxfb6shLn5CSa150gHbvGljbb9jkImEpYH3ezJZYrmXomlg5Ivty+UbSkd3h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x454Pjnm; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x454Pjnm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786012229; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=Eq6flyfzd4bdwnbjtjvmyFpLtE3ryk+Zs3DvD7iNvRQ=;
	b=x454PjnmHUTRBCSFmULHgVgyi3jJWH8oAI3WU1p8Wg2BESIjW5kUT15O6m2jYokhcX2JwRKXWyBCe6OU71U8smf5NZgcEROZEstFw4TfrRj/smjhW1kFHJmjEHKJeX/gODlvnmU+SlXQbKWaUS5RJdOHP0LqSHYMRE2vLdkMds4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8TiMfa_1786012228;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X8TiMfa_1786012228 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 18:30:29 +0800
Date: Thu, 6 Aug 2026 18:30:28 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Oliver Upton <oupton@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Message-ID: <cftn7d77lbuaby6hkkkxvcryl2ktnpkbda75dmnqhy2k7gcb6m@f7sy5flqka5d>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-5-fd8c40f5ad88@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-arm64-gcs-v18-5-fd8c40f5ad88@kernel.org>

On Mon, Aug 03, 2026 at 11:56:50PM +0800, Mark Brown wrote:
> As per DDI 0487 R_WTXBY we need to manage PSTATE.EXLOCK when entering an
> exception, when the exception is entered from a lower EL the bit is cleared
> while if entering from the same EL it is set to GCSCR_ELx.EXLOCKEN.
> Implement this behaviour in enter_exception64().
...
> +static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
> +				    unsigned long mode,
> +				    unsigned long target_mode)
> +{
> +	u64 gcscr;
> +
> +	if (!kvm_has_gcs(kern_hyp_va(vcpu->kvm)))
> +		return 0;
> +
> +	/* GCS can't be enabled for 32 bit */
> +	if (mode & PSR_MODE32_BIT)
> +		return 0;
> +
> +	/* When taking an exception to a higher EL EXLOCK is cleared. */
> +	if ((mode | PSR_MODE_THREAD_BIT) != target_mode)
> +		return 0;

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

> +
> +	/*
> +	 * When taking an exception to the same EL EXLOCK is set to
> +	 * the effective value of GCSR_ELx.EXLOCKEN.
> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		gcscr = __vcpu_read_sys_reg(vcpu, GCSCR_EL2);
> +	else
> +		gcscr = __vcpu_read_sys_reg(vcpu, GCSCR_EL1);
> +
> +	if (gcscr & GCSCR_ELx_EXLOCKEN)
> +		return PSR_EXLOCK_BIT;
> +
> +	return 0;
> +}
> +
>  /*
>   * This performs the exception entry at a given EL (@target_mode), stashing PC
>   * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
> @@ -154,6 +186,11 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	// PSTATE.BTYPE is set to zero upon any exception to AArch64
>  	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
>
> +	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
> +	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
> +	// exception level.  See ARM DDI 0487 R_WTXBY.
> +	new |= compute_exlock(vcpu, mode, target_mode);
> +
>  	new |= PSR_D_BIT;
>  	new |= PSR_A_BIT;
>  	new |= PSR_I_BIT;
>
> --
> 2.47.3
>
