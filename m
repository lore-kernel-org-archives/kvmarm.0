Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4F27462;
	Fri, 19 Dec 2025 20:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766175025; cv=none; b=s39w12FFT6HzRo5oZxrHLhI0oeIoSwsPgNquzmxbvdr44dXbajLMQc39gSSziGuM200OEb8OWVntwsOFFKosai1yz8Og3/gjEw4xI7jfpcdP2llX1ttyxcKaWQ2x+bow3Y6Z3epHuLP81tCyG8VVLcDCq/a59dPYQbQ+RdWX6Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766175025; c=relaxed/simple;
	bh=cuuf9jwjA23EzGC5CEmDMJAVh8R6FAC6fbYSEHdZ0YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDK+PEGXGF3sr8c79hsyl2xt8tmUw7q9OB3+2c+o5aj6pCFG681xaEGALhL/ccfaCTireHChRwdHeLSuuUua72UpCPKLB5Po4hDQUPSbjqQyBEWN+KcX11YyUMyr5NESRIxjokkh6aY+GNu3ixOidvHUgJ/2s/EDKuUPHYcIB58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kS7I0nik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kS7I0nik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44087C4CEF1;
	Fri, 19 Dec 2025 20:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766175024;
	bh=cuuf9jwjA23EzGC5CEmDMJAVh8R6FAC6fbYSEHdZ0YI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kS7I0nik4rKzjaRGYHq7ke+Ygk3K1YlBzsIDyra2D4j7O9Rk4NgKW0sByHuNafIiT
	 3GZhm1DNorrXaNdVXsPwqDOXSdWh5pY/2BBxvi2UEQlfk6uUX4Z25nU8gXQkcj2jk+
	 sXcvB9BoQcjuJexcPe0Zu27TEMNkD6MFQjplpEKeoWreKuOoYe4bMWvtKj7TYQDX9t
	 R9hfYUSlmNqDk8GhpcaGDqLE8RtcAiIvfVFH6NTtWzheNjgCFMwKV28qOGKvrt8z4t
	 Ecnbm34MSou6sd3PVHpLmejn/SZpIDeetPMvCFuJoyUb9eKBKA1GspXWoWyrhKTEy9
	 epA2mbfFk5S2w==
Date: Fri, 19 Dec 2025 12:10:22 -0800
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
Subject: Re: [PATCH v2 13/45] KVM: arm64: Force guest EL1 to use user-space's
 partid configuration
Message-ID: <aUWxLp2GUk2_p58e@kernel.org>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-14-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219181147.3404071-14-ben.horgan@arm.com>

On Fri, Dec 19, 2025 at 06:11:15PM +0000, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> While we trap the guest's attempts to read/write the MPAM control
> registers, the hardware continues to use them. Guest-EL0 uses KVM's
> user-space's configuration, as the value is left in the register, and
> guest-EL1 uses either the host kernel's configuration, or in the case of
> VHE, the UNKNOWN reset value of MPAM1_EL1.
> 
> We want to force the guest-EL1 to use KVM's user-space's MPAM
> configuration. On nVHE rely on MPAM0_EL1 and MPAM1_EL1 always being
> programmed the same and on VHE copy MPAM0_EL1 into the guest's
> MPAM1_EL1. There is no need to restore as this is out of context once TGE
> is set.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Drop the unneeded __mpam_guest_load() in nvhre and the MPAM1_EL1 save restore
> Defer EL2 handling until next patch
> ---
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index f28c6cf4fe1b..a2e8f6187675 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -183,6 +183,16 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
>  }
>  NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
>  
> +/*
> + * The _EL0 value was written by the host's context switch and belongs to the
> + * VMM. Copy this into the guest's _EL1 register.
> + */
> +static inline void __mpam_guest_load(void)
> +{
> +	if (system_supports_mpam())
> +		write_sysreg_el1(read_sysreg_s(SYS_MPAM0_EL1), SYS_MPAM1);

nit: I'd prefer using a mask to extract the fields of interest, guarding
against future architecture doing something silly with the RES0 fields
of these registers.

Thanks,
Oliver
