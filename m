Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B201FDE31;
	Thu,  1 Oct 2026 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859525; cv=none; b=QOG0PDH20KEepJyNQfNpzSyhI+Dew6a0kbKFmwQrkJ0TScDHj7lvhbrrxioqFKwA59YZjZp47AiJNoNSxGdHaSV/OZZdVj3EDTzmYTyACAxPIq4K7G0t9Z5MjO2QgA7mER1BHJ/DNV9WMevjM80M3ZmtvWquffCEcUTx+Ip2g8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859525; c=relaxed/simple;
	bh=weZVC+SDGzZZWfiF/GwygFk7zdR+r8AfKnlAZb1gUMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fooBBptP9dZSw8/0gx/fg67QhFaoTibV49+2ctimvIkanQzsb6GW+gpWS094Zr1Ii/t9ZulFLHCe7DUmk4ad1nNftDk3jFMa8L9klmf1zZvH768ZXpIpAx9ENI1BwLUuJ7Q+L74ybch1PsWNO3Ui74tTzOCg00NBlzqDiWLf2w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g9AVJug1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g9AVJug1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33A72497;
	Thu,  1 Oct 2026 05:58:40 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C879F3F85F;
	Thu,  1 Oct 2026 05:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790859523; bh=weZVC+SDGzZZWfiF/GwygFk7zdR+r8AfKnlAZb1gUMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g9AVJug1MjC/YjRWCqkfe7HbKIGnHgNws/5ZDp00SJD8kp37BFpOu0gXPNauTPfI+
	 IHxC4kCwwyboG2Lu2OkI3LZQK6RvbGqaG3XlH+R7ITZhN1obN8g7uXZRtOJjmmwuwf
	 Z38xa3Czv10sIGb7BizmWgDu9Ddek0qyPqXBRfRM=
Date: Thu, 1 Oct 2026 13:58:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v21 8/9] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Message-ID: <ar5Y_pHBUQHbXr85@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-9-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001084555.1456543-9-suzuki.poulose@arm.com>

On Thu, Oct 01, 2026 at 09:45:54AM +0100, Suzuki K Poulose wrote:
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index 5d005054f3c6c..e3503aba646e2 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -53,6 +53,17 @@ static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
>  	}
>  }
>  
> +/*
> + * rmi_smccc_invoke_once: Invoke the RMI call and return the results. Do not
> + * retry the command. Let the caller deal with RMI_BUSY or RMI_BLOCKED.
> + */
> +static inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *regs)
> +{
> +	struct arm_smccc_1_2_regs args = *regs;
> +
> +	arm_smccc_1_2_invoke(&args, regs);
> +}

Nit: I don't think we need to copy to args since there's no retry here.

That said, the SMCCC call clobbers regs->a0. We should write a comment
in case the caller thinks it can just retry with the same regs.
Alternatively, we could pass args and res structures separately.

> +/**
> + * rmi_rec_destroy() - Destroy a REC
> + * @rec: PA of the target REC
> + * @sro: Allocated SRO context to be used
> + *
> + * Destroys a REC. The REC must not be running.
> + *
> + * Return: 0 on success, positive RMI result code or negative Linux error code
> + */
> +static inline long rmi_rec_destroy(unsigned long rec,
> +				   struct rmi_sro_state *sro)
> +{
> +	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_REC_DESTROY, rec);
> +}
> +
> +/**
> + * rmi_rec_enter() - Enter a REC
> + * @rec: PA of the target REC
> + * @run_ptr: PA of RecRun structure
> + *
> + * Starts (or continues) execution within a REC.
> + *
> + * Return: RMI return code
> + */
> +static inline long rmi_rec_enter(unsigned long rec, unsigned long run_ptr)

Nit: should probably be __always_inline. rmi_rec_destroy() and
rmi_smccc_invoke_once() as well.

Not for this series but something claude spotted in the integration
branch - kvm_rec_enter() is noinstr. On this path, we end up in
arm_smccc_1_1_get_conduit() which is not noinstr (again, that's for the
other series; here just __always_inline should suffice).

> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_REC_ENTER, rec, run_ptr,
> +	};
> +
> +	rmi_smccc_invoke_once(&regs);
> +	return regs.a0;

Should this use RMI_RESULT_STATUS(regs.a0)?

The rest looks fine to me.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
