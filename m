Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020130;
	b=Uc/zrlEQ9TTC6xq7MsjTFMx8Qe7dPyiL1Ax5A4BsDTX3gZ65ZwD1bZtt/w+19DxFGD4+
	 riPiP/mKpvSvyKL+eQ68N0hlANzcP+ax1T6xyyttJfgy66xGXzDhqvygIvYXqOPWLO3AA
	 ILmMzTEPBHDA89MF4Tlg2/tjAASQ4XN6cUhrwfuN9XU5H1X0RUlUo5RaxR5PtZuazaXqx
	 FV0glFseiSiVkHj/sKW7AK7QJ2cNsXuX4rwTmDp83bqRdEobEcLDanPwbAUuLNTVFeZae
	 yhUETqjD1ZPgxJyBxUtOE6DrzJIDfGkWN+03Rv95RmX6dduRxOZFkyp7gdrpXIkl8vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020130;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=QFUFENIciwLZFoUCVayw48AKayBa+G1hl0ibvcGBtzQ=;
	b=Ec031qSWob2HmlpjIUclKluBPSjwwVxAbNsyHe4Wq9OQ5Ht/lWyu1WWChECUI6nOfO5Z
	 hBBrF2upUXGwMTW/C6gbfBykr19eZOSAp/uBc5Y70QbPVIIV9CsjrjyVTU7Xk9IfVgoEi
	 mYpS7QQObYIedCKYEh+FJV1jzfe5ZojaAyLtVI1JxZ/Uj1URfkMQhB/1/hZs1lGNEgPJ4
	 hpT1rGnVVhEWZLCXEgq2dqqBDAOnl0XeNkfRfnjvAKHZnEygT+IXtm9Z/qZqko9p/Zo68
	 Jl0IZGT6zMncYPkhgZb0c6cjcgCB7Jzi9qXHMq+sV4vQMPVK/bxjcaKcRJIdXxApyDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rXv6cfjV;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC68606A31A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 13:08:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFC68606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rXv6cfjV
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c247f6687dcso446461266b.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 06:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793020128; x=1793624928; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QFUFENIciwLZFoUCVayw48AKayBa+G1hl0ibvcGBtzQ=;
        b=rXv6cfjV7YJbhHuotVMcPsx05uWCKJd495bAusdli/pCBOn5hDfkPUt3SIO7CHUxBI
         beC0fyMJ7KFqSuOnr1I8DVpWrHFlefPIrc5ikqNPjtxS9G4QvQjfidTHpDDRo5t/AEUd
         LKU5Pd9LFAvqHLz+qJeA2twG0NmPJBda+5jmy/CKIBXW9wi3tmdgjJEEy/7ZvwtiBttu
         ymTJMP6+1BWMKhWfWy8MiZGqFJN1NmJ1ezTfUGLkxJH+a3tUH2SJN2DbcsJrc1LZkzX8
         8gmr9bZIYhfC6bPddyFB81DDnHMX0SgMKRneLjPwOLw82j9iLdzO5M9ncN4/UO+IR593
         KJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793020128; x=1793624928;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QFUFENIciwLZFoUCVayw48AKayBa+G1hl0ibvcGBtzQ=;
        b=cJERn6n/sLMgEjVzxZlS8uFlpFOmsKEIGqc3MgkJBGxD6pI/c3MP+ipmWAM26b463N
         Mq+Yw9CAabX9msG+y6JjDjhiryjaEZrBMWBSdCz0/cdNVAXF29bqyCF42BsttflKZQcB
         yZ5brpTEXIG0HQ5To2nkeaeDctYqszubWcIGv5Lky8FTuzBB1/aAQxZQ58pQDjSD6u/Q
         iIltOTNZaUiganVU9gH0ONrG0aTpoEa+rxIg5ghHYsvrWlqiZVAvRf9tZ2lyKyRqtTfs
         b3+Zv5WWS8ilUcgkBf7Ak+ZaifkFdLD+LTGPtPB/VqCkzdfseL5A5+gis9tY7ivzMtKr
         9rKg==
X-Forwarded-Encrypted: i=1; AKwUvBwql4GJNnA767iQFXliBZcsvysS4oTvEVG/2fh15+2DaHRQHCr96Lny/7lqocjxrs6GxJxjT9k=@lists.linux.dev
X-Gm-Message-State: AFq9FYKzYakARQBs1bMt6gh+IizV2i9PBxkK3OvwZHvelanVzD5MCqxy
	Wjp7cGUe+nLLSQpeoqzfcL+bqM1EZ9SwtA2mZC4vQgBpYiSEyXNNkFAfpeScSc4uXQ==
X-Gm-Gg: AYBFou0AKoNxaQjRZ8eYR/jkijA0kHKg2ryMGESxf2pXnJS4HaBMkgqT8+C7XJuBtpw
	PLNL7SsUngYhji8yqRO7cAgtnsMtSHzTCe7ZApqYH+CkoqEqCpkF9Q5ot9vm/UAOQMR6LryctxU
	z/JyK9RGHyUEIiMboHPSFCHHEqneBwgGqeKLPvV7yR986JjnHiHrumcxpB42Cbk7W4iftiIMPAS
	t/DUQCjufBP+FE/h1v/GhCHKZaPxHnFW4IIBFcPIa2/O3JR6GoZU/RX0IrckubQ7on93II2GD1N
	MYOAQTVmT4don6OnWANUx+3H7JS0gpGPlbZ4W2lPBSgHcMUBnwB1lU2/7rcy0AG4nWRM3WYDe0S
	QClkGp1zJY1SOgInCMp0eIrVX3nyQGT40npxerzVZAcMGSbXhBB/MuS/BNbKMkn4hl8cMfJwpoI
	NM3TIT1LHAKwf1NWb9uUalDwmmwwanl4wULouxrbxv2oXeo3JkVBSPYgEp9Yk3u1wZHSceHjdA4
	JBkB9lmcoZNRFF2onf7YodaVy4Or+vJCFWJ7MgVE5ZpcKcWujwcsEFe4IYW4qpB9UPM4Xkogr5R
	ke+8YoQ0u5/S6dISe1b0j7Ft
X-Received: by 2002:a17:907:3ccc:b0:c40:6ed9:b962 with SMTP id a640c23a62f3a-c46bdc2a4b5mr786978166b.26.1793020127574;
        Mon, 26 Oct 2026 06:08:47 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd4e99a2sm323829166b.24.2026.10.26.06.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 06:08:43 -0700 (PDT)
Date: Mon, 26 Oct 2026 13:08:39 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH v1] KVM: arm64: Use the host kvm_host_data for
 nr_event_counters
Message-ID: <at9Q1-tbXDcRbeyq@google.com>
References: <20261023092007.3918848-1-vdonnefort@google.com>
 <86cxt0zj6u.wl-maz@kernel.org>
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
In-Reply-To: <86cxt0zj6u.wl-maz@kernel.org>

On Fri, Oct 23, 2026 at 01:37:45PM +0100, Marc Zyngier wrote:
> On Fri, 23 Oct 2026 10:20:07 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > nr_event_counters is only used by the host to populate mdcr_el2.
> > However, host_data_ptr() for pKVM switches between the hypervisor copy
> > of kvm_host_data before it is deprivileged to the host copy after.
> > 
> > So kvm_init_host_debug_data() initialises nr_event_counters in the
> > hypervisor's kvm_host_data, while kvm_arm_setup_mdcr_el2() reads the
> > host copy which is 0. With a HPMN of 0, this stops programmable event
> > counters from counting a non-protected guest.
> > 
> > Always use the host copy for nr_event_counters.
> > 
> > Fixes: 2417218f2f23 ("KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts")
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > ---
> >  arch/arm64/kvm/debug.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index f4d7b12045e8..a00771339c62 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -44,7 +44,7 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >  	 * to disable guest access to the profiling and trace buffers
> >  	 */
> >  	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
> > -					 *host_data_ptr(nr_event_counters));
> > +					 __this_cpu_read(kvm_host_data.nr_event_counters));
> >  	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
> >  				MDCR_EL2_TPMS |
> >  				MDCR_EL2_TTRF |
> > @@ -80,8 +80,8 @@ void kvm_init_host_debug_data(void)
> >  								   ID_AA64DFR0_EL1_PMUVer_SHIFT);
> >  
> >  	if (pmuv3_implemented(pmuver))
> > -		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
> > -							      read_sysreg(pmcr_el0));
> > +		__this_cpu_write(kvm_host_data.nr_event_counters,
> > +				 FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0)));
> >  
> >  	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
> >  	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
> > 
> 
> This really looks like the wrong approach.
> 
> host_data_ptr() should be reliable, and always point at the correct
> data, irrespective of the backend. If host_data_ptr() returns a
> pointer to stale data on pKVM, then it is purely a pKVM bug, and
> that's what needs fixing by synchronising the two copies by whatever
> means necessary.

I'll update both copies and make a common series Fuad.

Thanks

-- 
Vincent


> 
> Randomly picking a different accessor is not an acceptable outcome.
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
