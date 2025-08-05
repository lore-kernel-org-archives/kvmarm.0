Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B1524168D
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754404558; cv=none; b=D2KX9DitSDecaBZc1qsXMB0M9/oIxswa7qlDdTpDmChyEM/HUqhzuTJt/3iedMnfJDhwHEGBtYVRaarIolNxVNTUgAy0PuvPTBvPJhgCG1GZmb8vpzvApAX0L5hK+4g9N7brqIIf6v/Vz8ZN4ELJweU9ZxdxASJk85Ldjt4jqOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754404558; c=relaxed/simple;
	bh=mjTR2Ac96dwJ78Vr6Hwbo17H1JiZ8AXdWSfQTVJfiaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYw8vVL+Eps20Cw5WEmsot2Q53aQ4DFi0Ut8e2L55hCc35rLtbbVz0ScYCTgOtEj6+7I0mf3PEWYjhIfp8QrSJ4frTr0eDOoGxoAiFHPECFgGOb3zD73L89zL9f3TwnpbJDfWaKjlQYZGfU8Hsn9Sr9wBeWGVQEgZ6o6kJOhxMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qyF9co85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qyF9co85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCFEC4CEF0;
	Tue,  5 Aug 2025 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754404558;
	bh=mjTR2Ac96dwJ78Vr6Hwbo17H1JiZ8AXdWSfQTVJfiaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qyF9co85JxIkRBe1+1ACJbgutEe+7iTw+i/nSgoCMpNAZHGybkxyiwF/Fx+5eBqIL
	 mU2BJRoQ3a0OfQRC9z9C/QqB91BnGzxgAvzpLxYoPXZR8JPjcwjkwMUPXKGiBA4hh+
	 UWG8Wm+fO0tgoI5O5yjRTYlcSBwFH50QvH5oCOOwZCTWI84E6RB13Ib/MPRS4ZOQdI
	 3FiqpjbngRxL/icPeztDPZ+aBKj6LWl2uNJ3w5FO9FOe5M8SOvvR1ZxrkYiIMXXk8g
	 rGThlW4GTFjaPP5rPHGZ5d1Smhkj2UwU+2tbp9BT67H5F0XdV/RdgP3y1JCpQrBjyn
	 Ks6KSBDg2U+KA==
Date: Tue, 5 Aug 2025 15:35:52 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com,
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v1 3/4] KVM: arm64: Sync protected guest VBAR_EL1 on
 injecting an undef exception
Message-ID: <aJIWyNwWAAaCf_cw@willie-the-truck>
References: <20250805135617.831971-1-tabba@google.com>
 <20250805135617.831971-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805135617.831971-4-tabba@google.com>

On Tue, Aug 05, 2025 at 02:56:16PM +0100, Fuad Tabba wrote:
> In pKVM, a race condition can occur if a guest updates its VBAR_EL1
> register and, before a vCPU exit synchronizes this change, the
> hypervisor needs to inject an undefined exception into a protected
> guest.
> 
> In this scenario, the vCPU still holds the stale VBAR_EL1 value from
> before the guest's update. When pKVM injects the exception, it ends up
> using the stale value.
> 
> Explicitly read the live value of VBAR_EL1 from the guest and update the
> vCPU value immediately before pending the exception. This ensures the
> vCPU's value is the same as the guest's and that the exception will be
> handled at the correct address upon resuming the guest.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index bbd60013cf9e..b34b10be1ad7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -253,6 +253,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  
>  	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
>  	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> +	vcpu_write_sys_reg(vcpu, read_sysreg_el1(SYS_VBAR), VBAR_EL1);

You say "in pKVM" in the commit message, but why isn't this applicable
to !VHE in general?

Will
