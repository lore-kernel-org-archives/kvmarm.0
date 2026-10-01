Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371D930567B;
	Thu,  1 Oct 2026 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790853914; cv=none; b=u6fTWh9e1suJ/CBoNY/FnnobKvDCK4GQFV4IawV8xGAbpO+r8Cx2+T9EBzI0Aumlg/pXaHHGBAh9EoWPIl0i4ObKjVxQFa61esXZJDxCOdrWRkKbXm7Fpnzb8EQaElaGrnR/00Lp5vZJHnY5zUcSq8tSefVlYmUKvXyocjq/kO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790853914; c=relaxed/simple;
	bh=9iQustlKXedPfxD6468ectf9eqxW981RXqIAmyO0YO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BL+b1crM14o1bm0BVq2YRTi1DltewzYAkf23aV0mG0nucg4RIYLqoxOEPt964eh83iXHfKHYdXaSEHzl08qsIslIfNUwqUxclLzPjnEXaPENp4D7lGTTiihE0nL5ALTqLq0dOMylQDEnoxDoRojJhiFTja241VxJlOYEXg7fdlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQ+WV61L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQ+WV61L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412DC1F000FF;
	Thu,  1 Oct 2026 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853912;
	bh=ZB4CVX7E1Xre6KKEpAV9B8cnUUstEGRG620gq2FNLsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fQ+WV61Lw5u06qdd/aZ5/p3/kEYIPYO5BjaRGUtonb2nbK7kch8wQCLhFQb99+JLq
	 xdEWUwF/7RfXeCqNT9own/sQE9tldnd64O3IWsFCm2wcvc+jfRpx5EF6GHBlMU4mNs
	 TirA85Zk3iJo4mIYz7k2O/jCAIRfc67Qbt9vQpDoRincLnOt8CWgKosYhPFfixVVT7
	 P88jDvZ9EzFX3HzN97+Qg7jSV0X7ttCpr+mrFrqe5vZR9i+9mtSGIHHuRCS2Lcpikf
	 lh+vfkqJWuiWTeMSEjCzLU66qp6ydSUprHv3hGlRQk7FXght6DTf0WDvgNzjHjhYDb
	 93v6riPxWrfbA==
Date: Thu, 1 Oct 2026 12:25:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Mark Brown <broonie@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with S1PIE
 or S1POE but not TCR2
Message-ID: <ar47ZOMYvcxlbwY8@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
 <20260930220551.014471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260930220551.014471F000FF@smtp.kernel.org>

On Wed, Sep 30, 2026 at 10:05:50PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] kvm: arm64: TOCTOU race bypasses S1PIE/TCR2 ID register validation
> --
>
> commit ecf3602b27fe0cb6f8ce76b1a8c6698e3dee08f4
> Author: Mark Brown <broonie@kernel.org>
>
> KVM: arm64: Refuse to start a guest with S1PIE or S1POE but not TCR2
>
> This commit adds validation to reject starting a guest with FEAT_S1PIE or
> FEAT_S1POE enabled if FEAT_TCR2 is disabled, as the hypervisor requires
> TCR2 to properly context-switch these registers.
>
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 44aae52c473d7..3ae293798b270 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
>
> [ ... ]
>
> > @@ -5928,6 +5946,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
> >  		kvm_vgic_finalize_idregs(kvm);
> >  	}
> >
> > +	if (!kvm_validate_id_regs(vcpu->kvm))
> > +		return -EINVAL;
> > +
>
> [Severity: Critical]
> Does this introduce a Time-Of-Check to Time-Of-Use (TOCTOU) regression
> that bypasses the S1PIE/TCR2 ID register check?
>
> If Thread A executes the first KVM_RUN, it passes this kvm_validate_id_regs()
> check because the invalid configuration hasn't been set yet. The config_lock
> is then released.
>
> Thread B could then execute KVM_SET_ONE_REG for the ID register, take
> config_lock, and inject the invalid S1PIE=1/TCR2=0 configuration via
> set_id_reg() in arch/arm64/kvm/sys_regs.c, bypassing the immutability check
> because KVM_ARCH_FLAG_HAS_RAN_ONCE is not yet set.
>
> When Thread A proceeds to execute kvm_calculate_traps(), it reads the
> maliciously modified ID registers and disables the traps, before finally
> setting KVM_ARCH_FLAG_HAS_RAN_ONCE in kvm_arch_vcpu_run_pid_change() in
> arch/arm64/kvm/arm.c.
>
> This regression allows KVM to configure traps based on S1PIE, disabling the
> trap for PIRE0_EL1, but skipping context-switching the register because TCR2
> is disabled. Could this allow the guest to directly overwrite the host's
> physical PIRE0_EL1 register?

Isn't this just a pre-existing issue and the one addressed by [0]?

https://lore.kernel.org/kvmarm/20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org/

I don't think it's related to patch 2/15 in any case.

>
> >  	return 0;
> >  }
>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20260930-arm64-gcs-v21-0-3556644cd927@kernel.org?part=2
>

--
Cheers, Lorenzo
