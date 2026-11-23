Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432118;
	b=f5iIUr/LWuIAWGgjfuctbRkPd+tWIUAiBqls9tUZZzv0AtiAkp9aVgn+INrrVzCdOBsb
	 tUHdo3j+GKqYz7IYFMWfgOnnV0tPGqE0KWaZUoIe2DQiokJQFobX5rDCtudgGJYA5Jj/D
	 qyzSZeVg4Yi7IwyQ16/tFVFLm/cTnYMp3EW/pe2uiv7h7wztO2xodaYNSgTCoLyt5WXmt
	 u4MXCwtVhhgNSWbmuwNSupUwbbd8MQpSsM4LYqvefCx46yjmEnmB9MfMyWicn6YVuiLWR
	 ABq3xzQsRZ7SxQtCg9TImZ641SCaMhPngqlPKnFmiMRmeflZfiTRxPTyiU538bqK3qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432118;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=2ahVaClWdiwyy5fxyONnLYFCAROTD31eA1TLqeeKJiU=;
	b=5mzoCsh0a9JIatAAAAFBgHh3wDaGaINjnqc7xpIUfL+K2wdBgTMpErc+yTRZcek3ELH9
	 U8ahe1ilnggQn9BiGpdsgE/nFAVrGEa6IlNPAWAvhta3xDUoBnBvf23oPtQIJrQ6YHvqu
	 v2abzohy+V5SvEClLAhmwU19NqyZAdQW9VrGNw6loE4uRCnsMoqB8wIcjw7fkkmblwkbC
	 cn8V3vdNrY8/PNVpsTOdnUoueDHNGcLu0BeSx6aDSvSME/L77ihN9VgJcqxBXs7yfesgA
	 m8bk6SuflTP1d1H6JfCvu8nIF6uqfw54+bmvL1nRVwCX4np0oTuef6QG28k7DXVtVIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=bt2VSFp9;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420D8606A32C
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:08:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 420D8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=bt2VSFp9
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-490f38e9688so2172092f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 03:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795432116; x=1796036916; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ahVaClWdiwyy5fxyONnLYFCAROTD31eA1TLqeeKJiU=;
        b=bt2VSFp9CIIAltQoi/VreeqHhrjZCe3/unTtCON4zB+A0oZFMGKySEjraE6MUGQN3r
         m4ILlqbuLaSFqoTdq9ydkf4Py/apERKnFMM/F7WrnH7AhRcEdz6PSVSdiAiufobJ7J1v
         rFLG1epRyRUkYfSD+Mtqc/Q3BSOesqzC27BSQB6IUS0c2S+Pl+66MtW5RyohXnCA50cc
         i+ciYSdn+UiMNdFey/9xSHlpjeffIZU2QqCLK704Xf3Z72LwySNEVwY3zT6yO3r4hbg7
         WAZ3kQVBT4fPV+och1t2W1rFpqG0xKvKvm1T31c9CX1/wUmmzFgur7omWb8fjNb3M82Y
         sWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795432116; x=1796036916;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2ahVaClWdiwyy5fxyONnLYFCAROTD31eA1TLqeeKJiU=;
        b=KcQpXvoMqjhIp9Xh7B0g7U13hljtvuXtXb6VkfHkizCx6WJGrnESXumMZQa+lsBKzT
         SJV4Y5XF/0SncL2HWiYy5Lr/sO93CX6xhNi11Y0un61ZrkfHCDwus48pdrNyoEoIacA6
         ZunKHaeWkApmId67UO3yDWMJhPolX0PGWkDD42ulnLXN4KNIltsgHmlUaK0Dqp+Gcgji
         I2uTn8GBa4UpUVtMQdQgftph2plo1eqGfjIcexn2n7wdSTnOKeisxP490I8ZcHI7vysQ
         opmbwa31eKd+8FTWuKfgzKTNKHB2+nYx+BQOGp8JpI9PpXqaDu9+/PcRwUogO0AFDfnd
         ilOA==
X-Gm-Message-State: APuU4Z/WZvHdI8XSz7DuOnqrNFEwoQ4zUmH7c9ilTuu1tuueckqXXW6i
	kpJAlwAFiWvYRmair+SLCDzqu4jV85s0pbuGbrVB7+EuZE7IueOOhe47mjSK/y0aqbg=
X-Gm-Gg: AZFdTZfbrsuJ8X5PGcbxc42cd+6+9cTAH57AXSANPWoV0NvRFlW8L7neICt6WXtlgmW
	aY21RFPck2vBcIOrqOfzxUOk+jazWM10zVtfROgGeqw3dZVhru0uIMzhWKyIZ2pUgiSpU3oVcwy
	AKTP6/WJ7dqn8w4waeA9HaMjRw/UoNrkq2JkXxGqQmy6nAwKFplzQd8wIb5q/unUSPoyFZbS1Qg
	xZDMTsOahPNVG+ZrPqtrRxQPjgNdeZuRwrY0l3jxo4rXMjLI/RjXbrSHywEpvOTuz8Ub5EDfPGE
	osEy8EPmmt+SBtnctSfGPrBFkLJRANgF8YDTb4lzn9cBGskrvuURokElpxBacb+5IITmiCxmfCq
	BuSh+wOOD71LtoZ0J2GjG+MFKL+4Wzf32nfgXirqqtxopjt6XMViWsuLjKp17CSWEUUaZ0oca/B
	CbI6aMlpxOXy7FRxxJUnZzVbXFmbbHZvlhR5cgOtz4EZunWUXiKRHN9yXeflTkctsrgobjcVefK
	JI1g+0vj1Z22LW6mTljyS13aY2JS0dnoagffCz19cJK3QTkc8cnEHtgVvBAPnAaIh++nknAeUV1
	TWvnAikWcoQdX79Qe0buxPqtpPVDnlQuQggO+IX3
X-Received: by 2002:a05:6000:40ce:b0:488:8347:a110 with SMTP id ffacd0b85a97d-4abafd02fa0mr23222776f8f.7.1795432116203;
        Mon, 23 Nov 2026 03:08:36 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b34e9c3ffesm5162435f8f.19.2026.11.23.03.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:08:35 -0800 (PST)
Date: Mon, 23 Nov 2026 14:08:32 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH] KVM: arm64: nv: Re-inject a stored SError after the exit
 is handled
Message-ID: <awQesKJZd0gKpLJx@stanley.mountain>
References: <20261123-double_exception-v1-1-cd82b59a232d@pereq.eu>
 <sashiko-outbox-229065@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-229065@kernel.org>

Yep.  These are sort of existing bugs which my patch makes worse...

Claude had previously told me it would review patches to see if they
expose any new bugs, but now it's saying that promise only extented to
"crash fixes" and not to "warnings like this".  :P

Anyway, I will send these fixes.

regards,
dan carpenter


On Mon, Nov 23, 2026 at 10:42:10AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] KVM: arm64: nv: duplicate SError injection when
>   NESTED_SERROR_PENDING is set
> - [Medium] KVM: arm64: nv: premature SError re-injection in
>   kvm_nested_flush_hwstate()
> --
> 
> commit a6e9a58a0688b0de9bbbb40738acfc3f5921f92e
> Author: Dan Carpenter <dan@pereq.eu>
> 
> KVM: arm64: nv: Re-inject a stored SError after the exit is handled
> 
> This commit defers SError re-injection for nested guests from
> kvm_nested_sync_hwstate() to kvm_nested_flush_hwstate() so that exit
> handlers can record their exception or PC increment before the SError is
> re-injected, and updates kvm_arch_vcpu_runnable() to treat a deliverable
> stored SError as a wakeup condition.
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 78d5b18dbd2d6..f063c01c565a0 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -2213,8 +2213,11 @@ void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu)
> >  	if (!vcpu_has_nv(vcpu))
> >  		return;
> >  
> > -	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
> > +	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING))) {
> > +		/* Commit the exit handler's exception first */
> > +		__kvm_adjust_pc(vcpu);
> >  		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
> > +	}
> >  
> >  	vgic_v3_nested_update_mi(vcpu);
> >  
> 
> [Severity: Medium]
> Can re-injecting NESTED_SERROR_PENDING here run prematurely when guest
> entry is subsequently aborted?
> 
> In kvm_arch_vcpu_ioctl_run(), kvm_nested_flush_hwstate() runs before
> checking ret <= 0 or kvm_vcpu_exit_request(), and inside
> kvm_nested_flush_hwstate() the SError is re-injected before
> vgic_v3_nested_update_mi() and the KVM_REQ_GUEST_HYP_IRQ_PENDING check:
> 
> arch/arm64/kvm/nested.c:kvm_nested_flush_hwstate() {
> 	...
> 	vgic_v3_nested_update_mi(vcpu);
> 
> 	if (vgic_state_is_nested(vcpu) && kvm_vgic_vcpu_pending_irq(vcpu))
> 		kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
> }
> 
> If L2 has PSTATE.A == 1 (with HCR_EL2.AMO == 0 and HCRX_EL2.TMEA == 0) and
> NESTED_SERROR_PENDING set while an L1 IRQ or maintenance interrupt is
> pending, kvm_nested_flush_hwstate() clears NESTED_SERROR_PENDING, sets
> HCR_EL2_VSE in *vcpu_hcr(vcpu), and posts KVM_REQ_GUEST_HYP_IRQ_PENDING.
> kvm_vcpu_exit_request() then aborts guest entry without calling
> kvm_nested_sync_hwstate(), and on the next loop iteration
> check_nested_vcpu_requests() -> kvm_inject_nested_irq() switches the vCPU
> to L1 vEL2 with HCR_EL2_VSE still set in vcpu->arch.hcr_el2 even when TGE
> and AMO are clear.  Similarly, if PSTATE.A == 0 in L2 or if ret <= 0 exits
> to userspace, pend_serror_exception() pends the SError into L2 state that
> gets committed by __kvm_adjust_pc() even though L2 was never entered.
> 
> > @@ -2231,18 +2234,11 @@ void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
> >  
> >  	/*
> >  	 * We previously decided that an SError was deliverable to the guest.
> > -	 * Reap the pending state from HCR_EL2 and...
> > +	 * Reap the pending state from HCR_EL2, and re-inject it from
> > +	 * kvm_nested_flush_hwstate() once the exit has been handled.
> >  	 */
> >  	if (unlikely(__test_and_clear_bit(__ffs(HCR_EL2_VSE), hcr)))
> >  		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
> > -
> > -	/*
> > -	 * Re-attempt SError injection in case the deliverability has changed,
> > -	 * which is necessary to faithfully emulate WFI the case of a pending
> > -	 * SError being a wakeup condition.
> > -	 */
> > -	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
> > -		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
> >  }
> 
> [Severity: Medium]
> Does leaving NESTED_SERROR_PENDING set across handle_exit() and exits to
> userspace cause a duplicate SError injection when kvm_inject_serror_esr()
> is called before the next kvm_nested_flush_hwstate()?
> 
> Because kvm_inject_serror_esr() does not clear NESTED_SERROR_PENDING when
> it delivers an SError via kvm_inject_nested_serror(),
> pend_serror_exception(), or HCR_EL2_VSE, a KVM_GET_VCPU_EVENTS followed by
> KVM_SET_VCPU_EVENTS in __kvm_arm_vcpu_set_events() injects and immediately
> commits the SError via commit_pending_events() while NESTED_SERROR_PENDING
> remains set:
> 
> arch/arm64/kvm/guest.c:__kvm_arm_vcpu_set_events() {
> 	...
> 	if (has_esr)
> 		ret = kvm_inject_serror_esr(vcpu, esr);
> 	else
> 		ret = kvm_inject_serror(vcpu);
> 
> 	commit_pending_events(vcpu);
> }
> 
> On the subsequent KVM_RUN, kvm_nested_flush_hwstate() sees
> NESTED_SERROR_PENDING still set and injects a second SError into the
> guest.  The same double injection happens in-kernel if handle_exit() calls
> kvm_handle_guest_sea() -> kvm_inject_serror() while NESTED_SERROR_PENDING
> is set.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261123-double_exception-v1-1-cd82b59a232d@pereq.eu?part=1
