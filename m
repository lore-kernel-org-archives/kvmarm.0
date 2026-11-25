Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795598057;
	b=rG35eAWWGqJYVRPSLzHcLPbmhf4A0APWojlvuNJZ6IhTYCxFzN/ngMmA28t+X/h85/z+
	 yd7v27Z23bVlWItAvTOOqUoSx4oFUBn+CL2pBoUOGtX6VmsuX1oCXITtz61rA9SmdvpKK
	 VbvGCDsR3Gl0vuPOXquvDa5+Fx9Qa8lXyW5OSbOM/QRXYA0m0EZFy3zLGIbi1Ovy6o5wj
	 V+/T07x6bhtqQmigDlfhkmxERMm6whufi2F8eLGImyRK0BU7AHquMN1IJaVwx8eWh7aYr
	 hiT9xDmScQ5jL8fXJCq4NmWodxlzqZ7hkTTaIkk2sQ470j6UCo0KtFpn0Kz7nTLcRJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598057;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=zqTNPD7bC5qKrIZEQgWRFxdczrnAZu0gT9xHLYWFyDM=;
	b=aTxUvyETxdHeSeihLdBMXdJ+AopUeDLgWKEkDaUryLJ984QPL6NXDPVm6qCakK75efLd
	 P8LkNYb80O99UnMNugtoFMjoWdtb16Gd0xSKnkUZX0PRTL1Uz7zoqfQgdaXeiAvOcQbgF
	 EYZ3wwTgeABd4j0XqK2O+3JjTp4Zxv7of3KvDY1NWC2OIlBiiV052mLoyWsYRyAh22p2U
	 Fmknk+xwVBgIuObUAJ9EWxkpVqOkYmiPLPXFh1DaFh2DDwongTpNfwSgsJO4gx4ZO+Ue1
	 Y6AUqL+XJb/K8ztnTayGcDsY0TcIw7HkZv9poJIHDr3jiMGYhssJMSMIn9CdScm80/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b="O/thzJS2";
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B62606A693
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 09:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81B62606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=O/thzJS2
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so3429448f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 01:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795598055; x=1796202855; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zqTNPD7bC5qKrIZEQgWRFxdczrnAZu0gT9xHLYWFyDM=;
        b=O/thzJS2cCBhcjf+pKLdn/A41J8Hp6d1sqg9InTW9ILw1K6v31HOvVwzwcZ2wNsyiW
         wI5DKa6/Ec34nAoxwOOR0gLPWJwaFWVeBlGa0mGmlachhG14ja84Jo8jEy+y5A2RZhH4
         tWTXan4iUqYSnhLySf/kYVK/aR0v86cykJeHQ1CarwkY6omK85UsHWrbDMpwPqEwJZes
         HjJfJJ/wb87fGjG/f3m19RlW20vat7deXny18R1net6uqkfwDh7wI9Dw4SSq4LeYhdJf
         7LvJmRxW+DItx5vOZCz8Isrt/pYxHtWaZtPFQWw4RpA926n64k+RbMlPOKVnXi1hPgBF
         QCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795598055; x=1796202855;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zqTNPD7bC5qKrIZEQgWRFxdczrnAZu0gT9xHLYWFyDM=;
        b=JNIno5ptqSAjRI5+3SKOP7g+wx9K3ZS7whI9HwXmFOGRhUN6XrzXfHP3rc2OZ91FM0
         QOcw9Gh5i18LbIsuDrm1pdQu1UdQ2lrw0OaVdVzuJKPy7luO2cfURoFYuAkzAbEPBtJh
         AdfCDheJBbL7sgx3qEgg9xjl4uwubnS5/olgYu1MfystfbHCbVJfpWbh6RnzFbf9HagE
         mgVr6Qflkw+85Jng1cYaviCX+CESNGFAOsfrscccR2QpU7ag/VE9xjP5p3nemI8wL7bx
         gXurvo89fbwYZnKHEEC6KHUjx5A+eB9KTt+IJ0N0JkakbJZ4+QsLRQXQAqpBXT08YUu7
         k1tw==
X-Gm-Message-State: APuU4Z/5zekpSN+6kU0TKVQB1Tm6okcKqJt9bEnt6gVnO3Vtlc1Q2H60
	DcIKy2DylugvCdYALb8JY1iUdrdUFA9cAdosxZyq0By/Rm9YjHed4bsYitqFZLD5gfw=
X-Gm-Gg: AZFdTZfm/rr5qSI6XQXf+i+3aV6LvHlMeNlVn+tgK5TPxeN6VfekN5rZxkgN4zt/rR9
	/nkcyatofGYfkxGFHLV2NiMaPtxFDalhoHnmv9sxGfd+uGl7EfSiQ9aKhqPtqT68oe9Pq1owy1C
	ETWvyUIHjxOkE9VCy1eVb08oolELHjMfCfJoGt8dJ4WHxdmlUc/QJpFSwLPZ1arLfi1jLGejdQa
	5WI2BfC4R1fpJUG8bpM8zUTVjEiovJmYNLIgv11HlhtmCi0gS4UWxeAmX/UtK9J1lYnMfPI5uuL
	btqjXAAZI41uQzZAimh95zTfEiIqx/JdtVEC98aFHstj6vUqV/Nx5+qq+N7SUY5cr+ojdoryj+8
	x3KS1ZZXkZuf4NBX3BAqp/tBJlKoce2TWIEpx+K86fw0YraSHeHuJO5Op+vwva1Z6Uw6HceMjc8
	o0zQwB/fBmLrbe7MbWxGJ3EO0G5/06homZeZOvQXtDpWmgZL1zuTpYmikL6wXklmstUA30XST4y
	DNqS9BRzgWhFLu7dXLl2fteR+PFpnelZrwEoysKpr5V5dtYWNOYEavFNcv7N7Xp3tKDIpAwWMfJ
	OmrMvaKWKwPOXLkll3A=
X-Received: by 2002:a5d:64c9:0:b0:4a6:bc53:2478 with SMTP id ffacd0b85a97d-4abb0d5256fmr33657721f8f.13.1795598054777;
        Wed, 25 Nov 2026 01:14:14 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm34532100f8f.13.2026.11.25.01.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:14:14 -0800 (PST)
Date: Wed, 25 Nov 2026 12:14:10 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-s390@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH v2 2/8] KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1
 when resetting a vcpu
Message-ID: <awam4std0Zifdn9k@stanley.mountain>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
 <sashiko-outbox-232760@kernel.org>
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
In-Reply-To: <sashiko-outbox-232760@kernel.org>

Let me add the s390 maintainers to the CC list.

I considered doing it the way Sashiko suggests but s390 doesn't have the
__vcpu_assign_sys_reg() helpers so it broke the build.  The registers are
not the same so, either way, some of this is going to be specific to
arm64.  But Sashiko is correct that s390 probably keeps a stale SP_EL1
across a reset.  The s390 maintainers could probably take the selftest in
patch 8 and modify it for s390.  :)

The pKVM part was my fault.  I had a patch for that but I screwed up
and didn't include it.  Sorry!

I guess what I'd like to do is keep this patch as-is and let the s390
maintainers fix s390.  When I send v3, I will include the pKVM fix.

regards,
dan carpenter

#HashTagTopPostingRules!

On Wed, Nov 25, 2026 at 07:15:46AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] KVM: arm64: SP_EL1, ELR_EL1, and SPSR_EL1 unreset in
>   pkvm_reset_vcpu() and core
> --
> 
> commit d315f26d12c1dd260ed62612065ad5e34b6f9f03
> Author: Dan Carpenter <dan@pereq.eu>
> 
> KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1 when resetting a vcpu
> 
> This commit zeroes SP_EL1, ELR_EL1, and SPSR_EL1 in kvm_reset_vcpu() when
> resetting a vCPU.
> 
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 26081d2734087..9c1b42890c966 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -199,6 +199,9 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  
> >  	/* Reset core registers */
> >  	kvm_reset_vcpu_core(vcpu);
> > +	__vcpu_assign_sys_reg(vcpu, SP_EL1, 0);
> > +	__vcpu_assign_sys_reg(vcpu, ELR_EL1, 0);
> > +	__vcpu_assign_sys_reg(vcpu, SPSR_EL1, 0);
> >  	vcpu->mmio_needed = false;
> >  
> >  	/* Reset system registers */
> 
> [Severity: Medium]
> Should SP_EL1, ELR_EL1, and SPSR_EL1 be reset in the shared helpers instead
> of only in host kvm_reset_vcpu()?
> 
> For pKVM protected VMs, flush_hyp_vcpu() does not copy host_vcpu->arch.ctxt
> into hyp_vcpu->vcpu.arch.ctxt.  Instead, on PSCI CPU_ON,
> handle___kvm_vcpu_run() calls pkvm_reset_vcpu() at EL2:
> 
> arch/arm64/kvm/hyp/nvhe/pkvm.c:pkvm_reset_vcpu() {
> 	...
> 	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
> 	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> 
> 	/* Must be done after resetting sys registers. */
> 	kvm_reset_vcpu_psci(&hyp_vcpu->vcpu, reset_state);
> 	...
> }
> 
> Because neither kvm_reset_vcpu_core() nor pvm_sys_reg_reset_vals[] resets
> SP_EL1, ELR_EL1, or SPSR_EL1, a protected vCPU that cycles through PSCI
> CPU_OFF and CPU_ON re-enters in PSR_MODE_EL1h with stale SP_EL1, ELR_EL1,
> and SPSR_EL1 values.  Resetting *vcpu_sp_el1(vcpu) = 0 in
> kvm_reset_vcpu_core() (which also covers arch/s390/kvm/arm64/reset.c) and
> ensuring ELR_EL1 and SPSR_EL1 are reset for pvm_sys_reg_reset_vals[] as
> well would keep all vCPU reset paths consistent.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261125-double_exception-v2-0-224689d8a764@pereq.eu?part=2
