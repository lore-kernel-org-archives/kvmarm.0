Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1D27E0E8;
	Fri, 19 Dec 2025 20:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766174493; cv=none; b=lJcdq5B4BvZPwtOVQW1PQWnXx481EMnXyK7KbdhQm7ul2+A4lFAz3hPPomgHNmVy06NLSsUZyXxWxI9x3+2BkxRELxzyzOA+vmDG2xrBFeUpqbL+yvqd+w7/Wbi2Y4pNAdHd1i57gy4dxGcIf5x0neyTNxW75pAaigekS3kd2Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766174493; c=relaxed/simple;
	bh=8pUZmGCDJ1FRjMBboLacZFWGbm4ILMwIQXmKN3FO6Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5uF355IdE6uJ4PZFeYZ9qoMzm9ZMNy7n5QVgEQHc/eOEzQjb+mfCOZ9jB0Am8utEeltZGSkcUj8YA7VknzACfCgmgt0p5AvHVcANePZI/yeQlnIwwiHm27XrTviPwq/AsiCC+KKJh/N/s86YZmlRDl99+Th1UPCuiahEaYJf+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0sXO6BT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0sXO6BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C417C4CEF1;
	Fri, 19 Dec 2025 20:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766174492;
	bh=8pUZmGCDJ1FRjMBboLacZFWGbm4ILMwIQXmKN3FO6Ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r0sXO6BT/vcNQGDrlB9yBfVJqM3igby0cJbL1l7VI6hqkx+rcosg37YWD5nBa4oXk
	 jL5voRf92E0kYiIhGXQkB01F/PuPRT2zQDHjK3pP6M2K77IDVHr5xgx6Wb8/a17QeS
	 YpO3PZTSpa0drljnYZdeZW/9kGCqacQxrr0WtKv0OFK2CB4C1dddB0lqZ1GIVed3nW
	 2r4LMfMJvdTEoy6+/azwDLAiv3VhYTMro/lg8Cs8Qtaa34pLaYGtSADdrp42wTmMbp
	 KC96hXht+fPuZju0WMp4q4QLqRlbSxkowxodLa3gF39b1I6DsTOFSuXZkNvFfEJn9N
	 OJYwXBH/I5URA==
Date: Fri, 19 Dec 2025 12:01:30 -0800
From: Oliver Upton <oupton@kernel.org>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, reinette.chatre@intel.com,
	rohit.mathew@arm.com, scott@os.amperecomputing.com,
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com, catalin.marinas@arm.com, will@kernel.org,
	corbet@lwn.net, maz@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 05/45] KVM: arm64: Preserve host MPAM configuration
 when changing traps
Message-ID: <aUWvGjGyU7DUW8MI@kernel.org>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-6-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219181147.3404071-6-ben.horgan@arm.com>

Hi Ben,

On Fri, Dec 19, 2025 at 06:11:07PM +0000, Ben Horgan wrote:
> When kvm enables or disables MPAM traps to EL2 it clears all other bits in
> MPAM2_EL2.  Notably, it clears the partition ids (PARTIDs) and performance
> monitoring groups (PMGs). Avoid changing these bits in anticipation of
> adding support for MPAM in the kernel. Otherwise, on a VHE system with the
> host running at EL2 where MPAM2_EL2 and MPAM1_EL1 access the same register,
> any attempt to use MPAM to monitor or partition resources for kernel space
> would be foiled by running a KVM guest. Additionally, MPAM2_EL2.EnMPAMSM is
> always set to 0 which causes MPAMSM_EL1 to always trap. Keep EnMPAMSM set
> to 1 when not in a guest so that the kernel can use MPAMSM_EL1.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index c5d5e5b86eaf..63195275a8b8 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -269,7 +269,8 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  
>  static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>  {
> -	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> +	u64 clr = MPAM2_EL2_EnMPAMSM;
> +	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
>  
>  	if (!system_supports_mpam())
>  		return;
> @@ -279,18 +280,21 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>  		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
>  	} else {
>  		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> -		r |= MPAM2_EL2_TIDR;
> +		set |= MPAM2_EL2_TIDR;
>  	}
>  
> -	write_sysreg_s(r, SYS_MPAM2_EL2);
> +	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);

I'd recommend documenting that writes to MPAM1_EL1 are followed by an
ISB. Otherwise it isn't obvious here where context synchronization is
happening (if at all).

Thanks,
Oliver
