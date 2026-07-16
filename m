Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA37331A57
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 10:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784199170; cv=none; b=mh3vU80XRAX4ePrwiavIGysfDJ9DRYteLnf+6Pu/S+wFJ9LbFVLaaRChKHbdU8wvJ15gKny52HiSGNUdAclKFduoQXwv1hZD7Fr1WJvH4hmVzcuXSwgOycVYaO/WdArRSv4CWC1H6JMucDl0rPhYng8rvc+wIi/Y4JuzOi0PD10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784199170; c=relaxed/simple;
	bh=TAfcUCm/FJRtFHstBcSY6HRJHtBTxuvxYMJlg5wYuG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAFMYe7x9CGkzd49gWoKI/YZ7jW7eRUI+YEoyElawDlthidvnURCuLfiP00pMsOHxHT22Yo3QviKSDXSoicQatF0Gm33R6W/4W4kqezhxcGplMc9rWI+pCFu/+oVbXZOczB4T5WFtYee0W4PkpoFgdke8fxrbDxukj4/nvATgSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z0TP9OOw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z0TP9OOw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7611339;
	Thu, 16 Jul 2026 03:52:43 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F40A03F7B4;
	Thu, 16 Jul 2026 03:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784199167; bh=TAfcUCm/FJRtFHstBcSY6HRJHtBTxuvxYMJlg5wYuG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z0TP9OOwkIMvZ272QpmYDzD1w0Nl8JaKp06EN5WyxC32thIqsC52Kl6jN+Xgz/J/u
	 x5JXf7MEvPzmEYmCDg0XNLboWyUvHAHHLOFySWD3jodc56mMpJwDcjMjBNVUGaqunj
	 vHEmwagoZtmUJTKjAsCiKdQDKtR6gAgaZBZt6bwA=
Date: Thu, 16 Jul 2026 11:52:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 02/29] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>

Hi Mark,

This generally looks good, but I have a few thoughts below. The key
things are:

(1) I think the commit message could be clearer. I've provided some
    suggested wording below.

(2) There are a couple of trivial bits to change in the code, commented
    below.

(3) AFAICT there's a latent bug where ZCR_ELx[63:4] aren't always reset
    before returning to userspace when we have a return from idle. We
    get away with that because those bits haven't been allocated yet,
    but given that they're RES0, we should reset them to avoid
    unexpected behaviour once they are allocated a meaning in future.
    
    This patch happens to fix that, but for the sake of stable I think
    we should have a preparatory patch to reset ZCR_ELx when returning
    from idle. For example, rename sme_suspend_exit() to
    fpsimd_suspend_exit(), and add the appropriate logic there.

On Thu, Jul 09, 2026 at 07:27:23PM +0100, Mark Brown wrote:
> Currently we enable EL0 and EL1 access to FA64 and ZT0 at boot and leave
> them enabled throughout the runtime of the system. When we add KVM support
> we will need to make this configuration dynamic, these features may be
> disabled for some KVM guests. Since the host kernel saves the floating
> point state for non-protected guests and we wish to avoid KVM having to
> reload the floating point state needlessly on guest reentry let's move the
> configuration of these enables to the floating point state reload.

This description is hard to follow.

How about:

| arm64/fpsimd: Configure all ZCR/SMCR bits when loading task state
|
| Currently, when loading a task's SVE and/or SME state, we configure
| ZCR_ELx.LEN and/or SMCR_ELx.LEN with read-modify-write sequences,
| preserving all other bits of the registers (e.g. SMCR_ELx.{FA64,ZT0}).
| This relies on all the other bits already holding the expected value
| for the task.
|
| It would be simpler and more robust to configure all the bits without
| a read-modify-write sequence:
|
| * Doing so will remove the need to configure these registers during
|   feature detection and when returning from idle, simplifying the code
|   and removing some redundant writes to the registers.
|
| * Doing so will permit KVM to clobber other bits of the registers when
|   no task state is bound. Along with other changes (e.g. when saving
|   state), this will make it possible for KVM to expose a different
|   configuration to guests (e.g. disabling ZT0 for vCPUs, even if ZT0
|   is exposed to userspace).
|
| When SVE and/or SME is not exposed to userspace (and userspace access
| it prevented by CPACR_ELx.{ZEN,SMEN}), the values of ZCR_ELx and
| SMCR_ELx are immaterial, as all functionality affected by those
| registers will be trapped. Thus there is no need to reset those
| registers to ensure correct behaviour when SVE and/or SME is not used
| by a task.

I've deliberately avoided detail on how KVM saves or relaods state,
because there are a large number of interacting pieces there, and I
don't think it's material beyond "this change is a step towards allowing
KVM to expose a different configuration to vCPUs".

> Provide a helper task_smcr() which generates the value of SMCR_EL1 to
> use based on the task struct and use it when we set the vector length
> SMCR_EL1, currently while handling SME access traps or FP state load.
> 
> For consistency handle ZCR_EL1 the same way, currently the only field it
> has is the LEN so the change is less meaningful there.

I think we can drop this part of the description.

> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h |  2 --
>  arch/arm64/kernel/cpufeature.c  |  2 --
>  arch/arm64/kernel/fpsimd.c      | 72 ++++++++++++++++++-----------------------
>  3 files changed, 31 insertions(+), 45 deletions(-)

[...]

> @@ -402,12 +421,13 @@ static void task_fpsimd_load(void)
>  
>  	/* Restore SME, override SVE register configuration if needed */
>  	if (system_supports_sme()) {
> -		unsigned long sme_vl = task_get_sme_vl(current);
> -
> -		/* Ensure VL is set up for restoring data */
> +		/*
> +		 * Ensure VL is set up for restoring data.  KVM might
> +		 * disable subfeatures so we reset them each time.
> +		 */

Let's delete the comment.

The existing principle that we must restore the length before the data
also applies to ZCR_ELx (which has no similar comment), and the general
principle that KVM might clobber the register is common to all the
FPSIMD/SVE/SME registers.

>  		if (test_thread_flag(TIF_SME)) {
> -			unsigned long vq = sve_vq_from_vl(sme_vl);
> -			sysreg_clear_set_s(SYS_SMCR_EL1, SMCR_ELx_LEN, vq - 1);
> +			sysreg_cond_update_s(SYS_SMCR_EL1, task_smcr(current));
> +			isb();
>  		}

What's the ISB for? That mysteriously appeared in v11 without
explanation. It wasn't in the original code, prior versions of the
series, or my suggested rework with the task_smcr() helper.

I don't believe it's necessary to add an ISB here.

Mark.
