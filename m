Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6D12BDC2B
	for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 22:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755122514; cv=none; b=GIZ3C1eVNaqOq+IknsrQBYi7ikh85qdzed42mEFY+NdzMpY6NUvKKY8fAuZUQz5TsQRl+w79wOn9TKRAIWoEXm0ahDSUsHZXbPRF2RcDm4GVxaoywbqZJeZuzbuSDF18M1JzYDoMUMNFwwAf/Za/r5xzG/gR/6TD3EM6ehmyU9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755122514; c=relaxed/simple;
	bh=RH+90nQ0r0rQd7AUFhTs/1Hi439AwUXYx50x6ncYXEk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZwmpWduxDJztmFUmeOPBXTmGGBzdRA6q86mGUtr35ztuRdV1K6fFiP9+fU+li8Y7t06uDw6e2YymqtZHQo72XRH3wgEsWNTmBKjBCoUPG7Wb+fCI3b+LeA0YLfx6Us7E+9/YTVydfwpDctzwu556p27K+8UfaZ+w614kApcsJk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZUNoDDPE; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZUNoDDPE"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-88432e1f068so41876939f.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 15:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755122512; x=1755727312; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lffc0WMub0rTiOOasAgzp27lbUXwGqsfsYixfeu01z4=;
        b=ZUNoDDPEtUlEuUtdVxAUCUWBlzUUWeZk40E5ztnvTnR8IkgfTriXlbrdZJFAPg9GRZ
         8iTNlWQaMg4fvUX+1DuvelTQ8tj3t7MsYrtaZwgHfSusociC3Z61UWPpSMI3YAjCFyie
         Xocjk0HM5pytupifU4spcrn8dxtc8cKyK0nPr7FvdTpYYqygEFxeJgrsz/16W78Zv0Js
         GoKhN49ZD+Cfp1SFcBZ5ebD7w9ZMwDl0pCbMmE0Dh6zFyUj6YZOktL8vJyuI6ers2Kb+
         gnpjp8QLZg9Yhg6ddquyP6E6s8rvDyOERcs7GRNvVPsPHMzZd8U4NDb5vS0NZWxRNsWA
         /Dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755122512; x=1755727312;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lffc0WMub0rTiOOasAgzp27lbUXwGqsfsYixfeu01z4=;
        b=lPrLEmGdwgeHKww2X7p6O+7m+LSnkjL5VZFNH6j3e5tjj2RO9Nx4x7zbMs7OQZp6Yl
         zdW37cmsUWwtwjFhGUKbsUhIofOQ3T/MD3K5Zo1e/qK9H06fYMfnqJVftP3iAK2IVyw1
         lK2CRgfEocX1gjZPHORwL/CDIOuOctxjJf/C4lR5dYdMbdrm4GqVMjVvTY3aL2JzaV+h
         kiclkLFsxs1+KB6bzDvdS/4D1GrD8ZJS0zXlBVJ95etpRRzIIKmHOPtQZHfga1lDL9R+
         Jvk9TsTMmjKIt4StK1UQBzyC0Q9kakNvU8eWxAEKdgHk1GQeHukUkd+WHQqShOkbCzvz
         ROvg==
X-Forwarded-Encrypted: i=1; AJvYcCWiwVjUrPX1FhGQdiEL+WW3oeqzVY+B74Jz+GnNlBbsyx/efktcmfP1N5qzEirIP4gEami3dew=@lists.linux.dev
X-Gm-Message-State: AOJu0YzeK7kTCe4vTo2a3QP85W3C9b9WZfQafILEp+yKTqwxQqFDPFlH
	/Ps2eRt9axpD+OJoPfsvhvFAYtiZQSVZxh6lhiYgMA0o/1X8w3LR62tHJvN1F0wi9Ob9oFz8lEm
	P4hq/BwvlhiXHHkO18qEl8IoVUA==
X-Google-Smtp-Source: AGHT+IG5r8vYJD9ejnNmOkd2D/b3gPNw0HLwazt4Xo6qZB5BPCocG+3nQgDyMNKMBq/qXmrpxMezac4YdgIdTVzxSA==
X-Received: from iosu8.prod.google.com ([2002:a05:6602:29a8:b0:87c:58a2:24c5])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:26cd:b0:86a:84f:7a45 with SMTP id ca18e2360f4ac-8843382aa8cmr146631439f.8.1755122511931;
 Wed, 13 Aug 2025 15:01:51 -0700 (PDT)
Date: Wed, 13 Aug 2025 22:01:50 +0000
In-Reply-To: <20250714225917.1396543-11-coltonlewis@google.com> (message from
 Colton Lewis on Mon, 14 Jul 2025 22:59:04 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntwm76ricx.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 10/23] KVM: arm64: Writethrough trapped PMEVTYPER register
From: Colton Lewis <coltonlewis@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Colton Lewis <coltonlewis@google.com> writes:

> With FGT in place, the remaining trapped registers need to be written
> through to the underlying physical registers as well as the virtual
> ones. Failing to do this means delaying when guest writes take effect.

> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm64/kvm/sys_regs.c | 28 +++++++++++++++++++++++++++-
>   1 file changed, 27 insertions(+), 1 deletion(-)

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b3f97980b11f..704e5d45ce52 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1036,6 +1036,30 @@ static bool access_pmu_evcntr(struct kvm_vcpu  
> *vcpu,
>   	return true;
>   }

> +static bool writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct  
> sys_reg_params *p,
> +				   u64 reg, u64 idx)
> +{
> +	u64 eventsel;
> +
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
> +		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
> +	else
> +		eventsel = p->regval & kvm_pmu_evtyper_mask(vcpu->kvm);
> +
> +	if (vcpu->kvm->arch.pmu_filter &&
> +	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
> +		return false;

I made a mistake here. The thing tested in the pmu_filter should be &
kvm_pmu_event_mask(), not & kvm_pmu_evtyper_mask()

Then, the value written to the register should be &
kvm_pmu_evtyper_mask()

There might be a similar mistake in Patch 17 where I enforce the filter
at vcpu load time.

> +
> +	__vcpu_assign_sys_reg(vcpu, reg, eventsel);
> +
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
> +		write_pmccfiltr(eventsel);
> +	else
> +		write_pmevtypern(idx, eventsel);
> +
> +	return true;
> +}
> +
>   static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct  
> sys_reg_params *p,
>   			       const struct sys_reg_desc *r)
>   {
> @@ -1062,7 +1086,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu  
> *vcpu, struct sys_reg_params *p,
>   	if (!pmu_counter_idx_valid(vcpu, idx))
>   		return false;

> -	if (p->is_write) {
> +	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
> +		writethrough_pmevtyper(vcpu, p, reg, idx);
> +	} else if (p->is_write) {
>   		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
>   		kvm_vcpu_pmu_restore_guest(vcpu);
>   	} else {
> --
> 2.50.0.727.gbf7dc18ff4-goog
