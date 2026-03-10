Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F563D16EC
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164483; cv=none; b=nOp9j9IeTaIv+yrojFSZd7b/z6ljWgZDzg+dOIfZAcd4ibVb6ybb1OGzD8+KI2RPmfFfF72IvPwU8EITFI7JIjEKKPsAHpo/saGtSCA9+HeC7pqNxW6qtPmWoeeVLlyD6gCmqiejg6mmuT6RtFu8BIhEDKz9qAP3rGdy0Gt0rTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164483; c=relaxed/simple;
	bh=h6wX9bvSTg0EpRJUQR4zDHbLnYrAdWbUVIF7pSFBWPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbI8x1/ixn12MWo6kbwYas0M8RdAyw5aCcCGc9tvRnwaHbF7hZFEdNXGvig8Klr4qKx45RG5Ok+ky9fgFoi9pD5cCWVDQ93/+rjWkz4o7mGuKfkSQGBAoxYONDFt9Ral916rwWPAFFfuYSHrex1tpLedh6JsvECrLpZc0bMQb38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D7141596;
	Tue, 10 Mar 2026 10:41:15 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DD4C3F694;
	Tue, 10 Mar 2026 10:41:18 -0700 (PDT)
Date: Tue, 10 Mar 2026 17:41:07 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH RESEND 2/2] KVM: arm64: nv: Expose shadow page tables in
 debugfs
Message-ID: <2c42eqpjf4m7teualhtgor6kzv7bk2rot4iwdivj6jf7zpe4m6@s3aqt53czzif>
References: <20260308231829.864983-1-weilin.chang@arm.com>
 <20260308231829.864983-3-weilin.chang@arm.com>
 <20260310152604.GA3093715@e124191.cambridge.arm.com>
 <thetpwxswabflbntrrxfsxpej4scwq25qpviv2svmbj7br3w3d@mdrrhsuexsf4>
 <86bjgv7ho1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjgv7ho1.wl-maz@kernel.org>

On Tue, Mar 10, 2026 at 04:50:22PM +0000, Marc Zyngier wrote:
> On Tue, 10 Mar 2026 16:17:07 +0000,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > On Tue, Mar 10, 2026 at 03:26:04PM +0000, Joey Gouly wrote:
> 
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index 5d5a3bbdb95e..f88f6c4d646e 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -217,6 +217,10 @@ struct kvm_s2_mmu {
> > > >  	 */
> > > >  	bool	nested_stage2_enabled;
> > > >  
> > > > +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > > > +	struct dentry *shadow_pt_debugfs_dentry;
> > > > +#endif
> > > > +
> > > >  	/*
> > > >  	 * true when this MMU needs to be unmapped before being used for a new
> > > >  	 * purpose.
> > > > @@ -405,6 +409,9 @@ struct kvm_arch {
> > > >  	 * the associated pKVM instance in the hypervisor.
> > > >  	 */
> > > >  	struct kvm_protected_vm pkvm;
> > > > +
> > > > +	/* Nested virtualization info */
> > > > +	struct dentry *debugfs_nv_dentry;
> > > 
> > > Seems like this could be guarded with CONFIG_PTDUMP_STAGE2_DEBUGFS too, or is
> > > there a reason you didn't?
> > 
> > Right, I was thinking this "nested" directory can also hold other NV
> > related information in the future, that's why I didn't keep it behind
> > the option.
> 
> We can cross that bridge when we get there. In the meantime, I'd side
> with Joey and would rather not have a dangling pointer.

Sure!
Let me guard it with CONFIG_PTDUMP_STAGE2_DEBUGFS too.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
