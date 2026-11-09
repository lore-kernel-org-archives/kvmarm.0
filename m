Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242969;
	b=BSE8FDxuNvmeZ8q9D8QF3QO2+i04HlTy7/JNiujNw+oaMetEbn6r78rR7oX8XkLi3kC/
	 l6PaUt8F+z93HIONF08kzwaDmsEJ7g6yVlLXqxC9jwOLcia4qrO/tQw6WobeJb6GSgc9g
	 OY31wHRvtmiaQgYFRY+uGrTKhi4Squ6I/qwhn+0qNlp5XxfLkZe6grHQaTlAjqZGkDHJI
	 Vp/vgCTppZxnstDXFydrZCHGXYTVui94tIjdZ3eAowa1O1/0MkRsnvxgUFS1D5yVHqkgG
	 t173ycSq8JPI4fsrsG7+1k4j2WKHr5lyXgnaFfRnObaOuXWCJv337+c76pOFsFf1C6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242969;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=J27zal7hELG8Gbcu6fDl/kcMSZoP3JlKcYtsr74J9Gc=;
	b=VV3/Gi+GX7qGPpbtl3JdARd9bcfKtLFmqOq8EvClYOskb3yYRB3XyVKUh1RJwdz/bZoC
	 qbJDWUJRnJwcC+RAA+3aEbsZOFnE/KDiwOUmYeMgvZrzPJMfmqsW4eY71nZalTiXmcFEb
	 zyAtqoqrkqyV3l/8UYn61g3qaVBFR47EGQ0v4ICCz4zi9c1c3MMcvF5m8wnmwYWDY1VRx
	 Bz2HTVi/y2ZigjcPY+CbWtAUkD/lEAWiO9gXJyGBbhf2ub3aC/gJw5pDqfjz6ayYYVvrB
	 5NCqKhcx4xLYsXAsQDxrXl4C5i6McVCQmNLM/t0zxbC45WuaRH4YSzBSzeN/bVmKhRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z8Vn7Kha;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F71606A321
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 16:49:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59F71606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z8Vn7Kha
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6534B1477;
	Mon,  9 Nov 2026 08:49:25 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3CD53F85F;
	Mon,  9 Nov 2026 08:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794242968; bh=w8rU7CQJ64lNlKKK+j5ZJHQoFxPI6PmycS36GXvhykQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8Vn7Kha82ppU7tOXCxPrarJzmVMg2ZebC5bXazkpGijHK+qWemMh+5NP2k0kz8CA
	 ZVOSSt7Rf62cBM2BPcE2hPvzTW7C+nti+nNKk6XD/xrhrcHC7ZLxxNCcKdXC8zdR2L
	 3wFHftJjestVz/DnwPCszNF7V8Hx4W8cZsSZRSW8=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 4/8] KVM: arm64: nv: Treat the VNCR GICv3 registers as hidden from user
Date: Mon,  9 Nov 2026 16:49:24 +0000
Message-ID: <avH5lLFaHLd79nig@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104192124.3932743-5-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org> <20261104192124.3932743-5-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 11:21:20AM -0800, Oliver Upton wrote:
> KVM's emulation of sysreg traps will soon need to evaluate the
> visibility of a sysreg prior to the effects of the L1 hypervisor's traps
> to cope with instructions that intersect with a CGT but lack a
> corresponding FGU bit (I know, not enough TLAs).
> 
> The VNCR GICv3 registers are marked as hidden from both user/guest on
> the basis that KVM never handles these traps locally and unconditinally
> relies on VNCR redirection. But an L1 hypervisor could trap these.
> 
> Remap the visibility as being specific to user accesses, giving the

nit:
visibility is specific to guest accesses, right? 

(non-visibility is specific to user accesses)

> indication that guest accesses to the sysreg are legal at least from an
> architecture POV. Note that the guest side of the visibility was a bit
> belt-and-braces as the bad_vncr_trap() accessor will act as a backstop
> against any unexpected local trap handling.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 870dcb25d0d7..0b21b454242c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1020,10 +1020,10 @@ static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	return mpidr;
>  }
>  
> -static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
> -				      const struct sys_reg_desc *r)
> +static unsigned int hidden_user_visibility(const struct kvm_vcpu *vcpu,
> +					   const struct sys_reg_desc *r)
>  {
> -	return REG_HIDDEN;
> +	return REG_USER_HIDDEN;
>  }
>  
>  static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
> @@ -2757,7 +2757,7 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
>  #define EL2_REG_VNCR_FILT(name, vis)			\
>  	EL2_REG_FILTERED(name, bad_vncr_trap, reset_val, 0, vis)
>  #define EL2_REG_VNCR_GICv3(name)			\
> -	EL2_REG_VNCR_FILT(name, hidden_visibility)
> +	EL2_REG_VNCR_FILT(name, hidden_user_visibility)
>  #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
>  
>  #define TIMER_REG(name, vis)					   \
> -- 
> 2.47.3
> 

Other than the nit, LGTM.
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
