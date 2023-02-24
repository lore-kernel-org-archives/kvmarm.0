Received: from out-43.mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F383220
	for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 18:36:32 +0000 (UTC)
Date: Fri, 24 Feb 2023 18:36:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1677263789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EsjdFfT3WIVIStv91sTwvYp/k4Cco0RtXYYhSN2jo8g=;
	b=OQv9SozBYfKxZ3lBlV2ee1KmUxzSknEZIE2JhrQjifKoWxxwquNBjWnXTxJtlmefYB3+he
	RUNcPDcB2+Ab+gvJ1/ndkGOkzeLOsb1CJ9Rem36WmvkmHG9THs0mJBHE31yom14gnwelWe
	glH1eicPUplYZos4CXWI9k1YYdEcSAM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, nd@arm.com
Subject: Re: [PATCH 08/18] KVM: arm64: nv: Handle HCR_EL2.NV system register
 traps
Message-ID: <Y/kDp9nYrAmYuh6y@linux.dev>
References: <20230209175820.1939006-1-maz@kernel.org>
 <20230209175820.1939006-9-maz@kernel.org>
 <20230224173915.GA17407@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224173915.GA17407@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Joey,

On Fri, Feb 24, 2023 at 05:39:15PM +0000, Joey Gouly wrote:
> I'm having an issue with this commit where a VCPU is getting a CNTVOFF_EL2 set
> to 0, so it sees the same time as the host system, and the other VCPU has the
> correct offset.

Yikes!

> The flow of execution looks like this:
> 	KVM_CREATE_VCPU 0 (VMM) ->
> 		kvm_timer_vcpu_init ->
> 			update_vtimer_cntvoff (VCPU0.CNTVOFF_EL2=kvm_phys_timer_read)
> 	KVM_ARM_VCPU_INIT (VMM) ->
> 		kvm_arch_vcpu_ioctl_vcpu_init ->
> 			kvm_vcpu_set_target ->
> 				kvm_reset_vcpu ->
> 					kvm_reset_sys_regs (VCPU0.CNTVOFF_EL2=0)
> 
> 	KVM_CREATE_VCPU 1 (VMM) ->
> 		kvm_timer_vcpu_init ->
> 			update_vtimer_cntvoff (VCPU0.CNTVOFF_EL2=VCPU1.CNTVOFF_EL2=kvm_phys_timer_read)
> 	KVM_ARM_VCPU_INIT (VMM) ->
> 		kvm_arch_vcpu_ioctl_vcpu_init ->
> 			kvm_vcpu_set_target ->
> 				kvm_reset_vcpu ->
> 					kvm_reset_sys_regs (VCPU1.CNTVOFF_EL2=0)
> 
> 	At this point VCPU0 has CNTVOFF_EL2 == kvm_phys_timer_read, and VCPU1
> 	has CNTVOFF_EL2 == 0.
> 
> The VCPUs having different CNTVOFF_EL2 valuess is just a symptom of the fact that
> CNTVOFF_EL2 is now reset in kvm_reset_sys_regs.

Right, and the fundamental problem at hand is that we used CNTVOFF_EL2
to stash the _host's_ offset even though we are trying to change the
meaning of it to be part of the virtual EL2's context.

> The following patch gets it booting again, but I'm sure it's not the right fix.

I'd rather we just break the host away from using the shadow reg
altogether and separately track the host offset. As it so happens Marc
has a patch that does exactly that [*].

Marc, do you want to resend that patch in isolation addressing the
feedback and link to this bug report?

[*] https://lore.kernel.org/kvmarm/20230216142123.2638675-6-maz@kernel.org/

-- 
Thanks,
Oliver
