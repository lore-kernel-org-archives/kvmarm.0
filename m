Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C17541760
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 02:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736129910; cv=none; b=A745P2T+46cGtaj/4p8Xj+4LMBVjiVHXfMRzVZ5nlPIcdxTFqaw5fsFOCIvSOz5wKdTwWAqEOYZp2p/oHeTU9nreOV5QFho6LytnTVl5zyv+qWXQT/93/8z7OjT1F3R34xtQKcRtrYPng4ZQqEdTSd6sMbiYXI244fqSjY1oXFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736129910; c=relaxed/simple;
	bh=TpJBngqm5TssDDgdGPDvuC68gCm66HR25l2nMZ81g5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OkrHG2C5Nhg7G+5euhUXZisL+Mymp8zYlI3oROhUqkL+U6jIR34PLy+ES5rsjyaSAA9tY/2FlnOeYvB/PlcPVYLvn++Yd+n5+FUlGgrmtgKweZ6xSGIDULyoy87+N2EcbU1f29R7/yJdSOYkYXoKGHVCmAJBW77x41uyjN8pPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=ZMzsJy4z; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="ZMzsJy4z"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ee9a780de4so14655513a91.3
        for <kvmarm@lists.linux.dev>; Sun, 05 Jan 2025 18:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1736129906; x=1736734706; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c3FJfKlQLbEvoXC4i0ViMWpomAcv0lK5A9XqztX79Kg=;
        b=ZMzsJy4zXHAUN8SGXaoTTsNHuOFpl1yVKAH8Pvu8a3wtJeKWmTLg6Qjuqve78MxHb+
         IBRgwoVKhuCBSZbgvnhNggs4QGubUkflTXaHIjLx+8ouG2TyP4Z7KjxzKtimTHtyc+c8
         WTjs69WYF4AZedq5724aroG+eJMpCkzaivDKwDVTu5nvgl+mOyB797x+RGR9yySDqEAx
         fXzJbxV9kFOxYlcwGOzR2umCtoBlXmgNBQqGDxJY9lXsnZWAkCJgJC0cfXlthlAlVMYJ
         FxC2+oYOxaxSLDSuOSusz0eDTMKXj+y8nme1XrFXgSoLL8QZ4hzi4S4WvNsQVGjfOnfE
         e+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736129906; x=1736734706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3FJfKlQLbEvoXC4i0ViMWpomAcv0lK5A9XqztX79Kg=;
        b=pE23dV4S5oQvJ8ueesho/6NlZ+AgsXyKUl1SY7MIUCd8a0OXWAtUn4IK5FK6A4YLrw
         XfgGZiyqa2tTDSqVWpvabsOrbqlojzmndpe87Tjh1uGrrH/oV59GnUY3tTqGDvr2ViZa
         Jy+T8fLnCgmk1EsSNYV6YRR5FkvJj5ceCzU8E/ZThjZ8coho4y1vfremeG8AGO/audgO
         i5LI4XgPDXGowBl96zghg1OMbUv08ZBeH4F6ScDdEaX1V2NLtfgGQTiJBFSeVkh61DFl
         optGi79hj0rQTFQXhJGRf8kBu2gFeuYjzHG08xhsI8T/wAgJVrX+nBzXiF+2OGERL0l+
         86+A==
X-Forwarded-Encrypted: i=1; AJvYcCVTR609dd7KC7PVaEMf+hSb2sycP5u2JOpiNxyi5+3ivRrE1k+gLNGqroBgv0GqJ4tiVBR10Vw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzH/5SK9FE8F3mn7L5YmymzV6EFvUNaB6SWkMkMYat81ewQsJgU
	8wQ47ndg8/+Y8TAcklffcpzfnXuFzg1P8KMdm28jIKQOX91Z+hIz6PKgIp+e+J0hLxKdjHH+csh
	pnqAxIY0SICki3unxVmZyj2NjsXMlB+uaCU6yxEnM8V+He+eFxljdC/TuSDWwhIQ=
X-Gm-Gg: ASbGncvckFg0JoKwOWksAqMoLs+YQ8vyl36UyDW+VeuC6JEFA8O7yRm941keBOz9K9m
	Fl55pFUxlgoioV2bQ4H+OpjQJsoiBuBbHc6637bdkL/jYN+9ZUaA8LgcUe5nczEzBTEhGbYgX+N
	4YEbPQDTSru5r9AD+52qwdy/Diqa7kvpP6gNS3yzoefL5G8pouI2Gno3Gvr1E4gTQmRoME6iohC
	AekhipuszVqOnpYhf+HqmCTnH71eljsh8FyAZZ3xgl6aM2DKTX5Nk52TwVKNZsI1q/j0eIix2h/
	negoJ9M6zI6P3hz1Igo=
X-Google-Smtp-Source: AGHT+IGE8R9wiGHsmz58x7rugsfqF4Xs7KaBBCUmHfCSZU9wMJhEA7KbG8rFzAqei36mZzEJGHa3mQ==
X-Received: by 2002:a17:90a:d88c:b0:2ea:59e3:2d2e with SMTP id 98e67ed59e1d1-2f452e22528mr87032884a91.10.1736129906353;
        Sun, 05 Jan 2025 18:18:26 -0800 (PST)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4477ec656sm32253706a91.30.2025.01.05.18.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 18:18:25 -0800 (PST)
Date: Mon, 6 Jan 2025 10:19:10 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Bjorn Andersson <andersson@kernel.org>, 
	Christoffer Dall <christoffer.dall@arm.com>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Chase Conklin <chase.conklin@arm.com>, Eric Auger <eauger@redhat.com>, r09922117@csie.ntu.edu.tw
Subject: Re: [PATCH v2 02/12] KVM: arm64: nv: Sync nested timer state with
 FEAT_NV2
Message-ID: <fqiqfjzwpgbzdtouu2pwqlu7llhnf5lmy4hzv5vo6ph4v3vyls@jdcfy3fjjc5k>
References: <20241217142321.763801-1-maz@kernel.org>
 <20241217142321.763801-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217142321.763801-3-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Marc and other KVM ARM developers,

I am trying to learn about NV and I have a few questions wile reading
the code and comments:

On Tue, Dec 17, 2024 at 02:23:10PM +0000, Marc Zyngier wrote:
> Emulating the timers with FEAT_NV2 is a bit odd, as the timers
> can be reconfigured behind our back without the hypervisor even
> noticing. In the VHE case, that's an actual regression in the
> architecture...

I'm curious why you implied NV2 isn't a regression in the nVHE case? In
my understanding without NV2 and ECV, an nVHE guest hypervisor would
directly program CNT{P, V}_*_EL0 registers without traps, and with NV2,
those accesses would be turned into memory accesses to the VNCR page,
delaying the set up of the timer until the next exit.
So NV2 also makes it worse for an nVHE guest hypervisor. What have I
missed here?

> 
> Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c  | 44 ++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/arm.c         |  3 +++
>  include/kvm/arm_arch_timer.h |  1 +
>  3 files changed, 48 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 1215df5904185..ee5f732fbbece 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -905,6 +905,50 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  		kvm_timer_blocking(vcpu);
>  }
>  
> +void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * When NV2 is on, guest hypervisors have their EL1 timer register
> +	 * accesses redirected to the VNCR page. Any guest action taken on
> +	 * the timer is postponed until the next exit, leading to a very
> +	 * poor quality of emulation.
> +	 */
> +	if (!is_hyp_ctxt(vcpu))
> +		return;
> +
> +	if (!vcpu_el2_e2h_is_set(vcpu)) {
> +		/*
> +		 * A non-VHE guest hypervisor doesn't have any direct access
> +		 * to its timers: the EL2 registers trap (and the HW is
> +		 * fully emulated), while the EL0 registers access memory
> +		 * despite the access being notionally direct. Boo.

Reading this part of the comment I understand it as for an nVHE guest
hypervisor, the timer map would look like:

map->emul_vtimer == vcpu_hvtimer(vcpu)  /* EL2 HW is fully emulated */
map->emul_ptimer == vcpu_hptimer(vcpu)  /* EL2 HW is fully emulated */
map->direct_vtimer == vcpu_vtimer(vcpu) /* EL0 notionally direct */
map->direct_ptimer == vcpu_ptimer(vcpu) /* EL0 notionally direct */

But looking at get_timer_map() I see we enter the first nested if
statement, regardless of whether the guest hypervisor is VHE or nVHE,
since it checks like the following:

if (vcpu_has_nv(vcpu)) {
	if (is_hyp_ctxt(vcpu)) {
		map->direct_vtimer == vcpu_hvtimer(vcpu);
		map->direct_ptimer == vcpu_hptimer(vcpu);
		map->emul_vtimer == vcpu_vtimer(vcpu);
		map->emul_ptimer == vcpu_ptimer(vcpu);
	} else {
		[...]
	}
} else if (...) {
	[...]
} else {
	[...]
}

Which contradicts what the above comment says.
What did I misunderstand?

Thank you so much, any guidance is much appreciated.

Wei-Lin Chang

> +		 *
> +		 * We update the hardware timer registers with the
> +		 * latest value written by the guest to the VNCR page
> +		 * and let the hardware take care of the rest.
> +		 */
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL);
> +	} else {
> +		/*
> +		 * For a VHE guest hypervisor, the EL2 state is directly
> +		 * stored in the host EL1 timers, while the emulated EL0
> +		 * state is stored in the VNCR page. The latter could have
> +		 * been updated behind our back, and we must reset the
> +		 * emulation of the timers.
> +		 */
> +		struct timer_map map;
> +		get_timer_map(vcpu, &map);
> +
> +		soft_timer_cancel(&map.emul_vtimer->hrtimer);
> +		soft_timer_cancel(&map.emul_ptimer->hrtimer);
> +		timer_emulate(map.emul_vtimer);
> +		timer_emulate(map.emul_ptimer);
> +	}
> +}
> +
>  /*
>   * With a userspace irqchip we have to check if the guest de-asserted the
>   * timer and if so, unmask the timer irq signal on the host interrupt
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a102c3aebdbc4..fa3089822f9f3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1228,6 +1228,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>  			kvm_timer_sync_user(vcpu);
>  
> +		if (vcpu_has_nv(vcpu))
> +			kvm_timer_sync_nested(vcpu);
> +
>  		kvm_arch_vcpu_ctxsync_fp(vcpu);
>  
>  		/*
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index fd650a8789b91..6e3f6b7ff2b22 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -98,6 +98,7 @@ int __init kvm_timer_hyp_init(bool has_gic);
>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
> +void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
>  void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
>  void kvm_timer_update_run(struct kvm_vcpu *vcpu);
> -- 
> 2.39.2
> 
