Received: from out-198.mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D971B278
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 18:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iGsEJTbQ"
Date: Mon, 23 Oct 2023 18:24:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698085497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QChXizP9EOxkwbrFQch52NiZrZiX3EIsRZVyKac4G8c=;
	b=iGsEJTbQ/pmMU0i2n2T//fvlwiheDsxmxNhjnWiFSsNvn4EPsecSVhGKbgbtV895dlfywq
	IFjdHTrBHuojcaQo0vPWHH9hRFTHd4Lqd1F5YmaOKrheubFebH5vabBSjt7EM/OUgS6urb
	MG1CLX6vy1Wu+Y/7MI/oyahdTxTzOPk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Ananta <rananta@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 02/13] KVM: arm64: PMU: Set the default PMU for the
 guest before vCPU reset
Message-ID: <ZTa6cigtBpyq5IwD@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-3-rananta@google.com>
 <8634y162q5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634y162q5.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 23, 2023 at 11:40:50AM +0100, Marc Zyngier wrote:

[...]

> > +static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +
> > +	/*
> > +	 * When the vCPU has a PMU, but no PMU is set for the guest
> > +	 * yet, set the default one.
> > +	 */
> > +	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
> > +	    kvm_arm_set_default_pmu(kvm))
> > +		return -EINVAL;
> 
> nit: I'm not keen on re-interpreting the error code. If
> kvm_arm_set_default_pmu() returns an error, we should return *that*
> particular error, and not any other. Something like:

The code took this shape because I had an issue with returning ENODEV on
the KVM_ARM_VCPU_INIT ioctl, which is not a documented error code.
Now that the vCPU flags are sanitised early in the ioctl, KVM has
decided at this point that vPMU is a supported feature.

Given that, I think ENODEV is fine now as the unexpected return value
would indicate a bug in KVM.

> Hmmm. Contrary to what the commit message says, the default PMU is not
> picked at reset time, but at the point where the target is set (the
> very first vcpu init). Which is pretty different from reset, which
> happens more than once.
> 
> I also can't say I'm over the moon with yet another function that does
> a very tiny bit of initialisation outside of the rest of the code that
> performs the vcpu init. Following things is an absolute maze...

I'm fine with this being inlined into __kvm_vcpu_set_target() so long as
we maintain the clear distinction between one-time setup and vCPU reset.

-- 
Thanks,
Oliver
