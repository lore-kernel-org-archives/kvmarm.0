Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FFD359A8D
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776178692; cv=none; b=IiAWYCBdFKOiRiBKHEKt5t1nyf1aVMJhMmNitDvhJyA9GZmrThsIgLp2OefYWyybYgV8/UcWOy9TVyBF9P1Hk02mV7sK/HULJ5U8GQVLnQrV6iEKWunw/y5u2zSCkFgRyjWLKXrZEJ0hHB0ed064mdxpr28+Bshj/iIZXL8z3ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776178692; c=relaxed/simple;
	bh=sCp9n5HRN9iqBodk4pKoIEAc1YaYInYT8WmwHZDxBv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puqkcpKl5cEFZxq7WA1fc9qKFdjbp5qMVrZ+vu2X0FapGaydMrT5hEyzPk1Hyo5SfJu4nJT+zwwl5DKHcS8tAtswwoct2vEet7o9jNAFI8jKIkrU+c2GvhIrcil7/+t/7UPgeHBf++6tlR+1YB2WVMZH7Msx/OI2o3l05zFoXdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BqkVUL/i; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BqkVUL/i"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48374014a77so78030375e9.3
        for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 07:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776178689; x=1776783489; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CZXc1G4AWwe3GuaS5rvpotOJKX0XtTzUPyknVjNY0u0=;
        b=BqkVUL/iUz84t4ohyDB/KCnb/P6bTenpvTvOZHMIwEfSjDi0HLgcWUDwRmpJcpWC3T
         F1PoRC17T36P7gl3KqQxd4WB78omrwMuCP+37bTzD7ukGTPzX9sjLmPF9C847xztb1wb
         7/4XqO22I8dpJVUNawpE39AENUlz54PCBlkg2+cblGHsjozfuce6SwH8mnMrRiYa56/L
         56uQnV5a+PtbY8l911/L+W1II89lSmm0jwNzxyZ5PkpnD/AEVBPabQf+QrudlOhgwxZb
         4njIUdSfRoxAattJ/3WbkCN8xae0O/8hORPD4yYtsihqZbpLElD+tknUaGYNrjskx0Qx
         WjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776178689; x=1776783489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZXc1G4AWwe3GuaS5rvpotOJKX0XtTzUPyknVjNY0u0=;
        b=n47gQ7ZGYtJoY9LFqH5Iu923USBQe5KxCpAdc74EFxxOfEdKr78OSaJ4waiYrH4nI3
         GhxHGdn5B+eEvyBJLYy09It24E3AjV0Q5+pnToTyxDABIUIlhVz9RxZ6vXIXPnniLnZP
         ceD0OmzBSlYNHF/Pn3ek8+/cZUMoLZY/vW25MSbWwS9lPzC5Nye9GQGeTSAmjLoykXRD
         3Z3zYR2mL1Ik4vT5elUmnaHevA5u0ZntoB3wz2ybcG3UC4hCRWdPLJFg0ghL4XV25fJa
         cm2ht5LZ0Ls/gWGJNKy/2fDGqg4foLcew94pq6FNkAcAJWisGBUzed5YfnLKJLSqrUuW
         SjIQ==
X-Forwarded-Encrypted: i=1; AFNElJ+P/o2YFk97/9IdxnxnAAh8513c/MKsquTEHTqvuzKgqORS4iRh3uSQcEFcRK/pptbEYzIIPCM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNMO9YIC8QxZAEm87Vja6IJQlhP3nxiXjCLgJKtzMBuMcMqEhE
	mCJ+Ps0MDrfF7TFJHTN0AfTTUmhmwgC3lu6SWaNyLUc/h0ciHgb6S7DoVcE34NqPLA==
X-Gm-Gg: AeBDietvSyMUnhUGn3jrDlKXeQ3dKxVM13iuMC3agaHC/96pWVWMbev2OGF0IDCyFNM
	QATf6J++JNFfG3mR+Ng7b5hvs7w2PSpzWA3F2rHAn9R5SMhpoPOH9VsQ16W85k4mPU94/pvDNxk
	i4RYXzxdNCsI6UOo+v4g2ehP68QE43UzGeUH7ePSW5RfALQhwNv+o0VxurKu/O8XpmGfekvGB5I
	02vD4y+I4sGqbNZ7FIT+3bTBfL0x1zQfg9mvVcOXMM0yJ1sCzK/U/LcmzyKgI0Gag2Ov4VCYSSp
	I2ACkWi6eafqF6/BhiPDraSx5U9Ng4RGKIkbXWFAtm2EjSBKyr7JE9kFyPu5Uwoa/pp4Qjjikq8
	xLJcPpvfl3yxli0ETbugmPGeCOPV3+vZ7l8zTIqLnqHJywsDJQDtcHSZ5tgJdnsAIyPnV/8joNF
	2G8y8sdskbUF1Pgj3G6siuPmcLTq8LnBPpAhuWLuH1CNXxiRWjT6SIK/sUYGoyI5tOL8oUjhf+i
	AYAZMgkOoKzTX49
X-Received: by 2002:a05:600c:3acf:b0:485:35a4:939f with SMTP id 5b1f17b1804b1-488d68a8275mr205934955e9.28.1776178689003;
        Tue, 14 Apr 2026 07:58:09 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5d85ae9sm170426105e9.3.2026.04.14.07.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 07:58:08 -0700 (PDT)
Date: Tue, 14 Apr 2026 15:58:04 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Re-allow hyp tracing HVCs for [nh]VHE
Message-ID: <ad5V_GuLY77xl8gw@google.com>
References: <20260414100231.1859687-1-vdonnefort@google.com>
 <86ik9t387m.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ik9t387m.wl-maz@kernel.org>

On Tue, Apr 14, 2026 at 03:52:29PM +0100, Marc Zyngier wrote:
> On Tue, 14 Apr 2026 11:02:31 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > The introduction of __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM excluded hyp
> > tracing HVCs from the common [nh]VHE/pKVM list. Re-allow them.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 37414440cee7..11dcdf434971 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -72,6 +72,14 @@ enum __kvm_host_smccc_func {
> >  	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
> >  	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
> >  	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_load,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_unload,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_enable,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_reset,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
> >  	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
> >  	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
> >  	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
> > @@ -100,14 +108,6 @@ enum __kvm_host_smccc_func {
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_load,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_unload,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_enable,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_reset,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
> > -	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
> >  };
> >  
> >  #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 73f2e0221e70..8f7582d57ab5 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -709,6 +709,14 @@ static const hcall_t host_hcall[] = {
> >  	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
> >  	HANDLE_FUNC(__kvm_flush_cpu_context),
> >  	HANDLE_FUNC(__kvm_timer_set_cntvoff),
> > +	HANDLE_FUNC(__tracing_load),
> > +	HANDLE_FUNC(__tracing_unload),
> > +	HANDLE_FUNC(__tracing_enable),
> > +	HANDLE_FUNC(__tracing_swap_reader),
> > +	HANDLE_FUNC(__tracing_update_clock),
> > +	HANDLE_FUNC(__tracing_reset),
> > +	HANDLE_FUNC(__tracing_enable_event),
> > +	HANDLE_FUNC(__tracing_write_event),
> >  	HANDLE_FUNC(__vgic_v3_save_aprs),
> >  	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
> >  	HANDLE_FUNC(__vgic_v5_save_apr),
> > @@ -735,14 +743,6 @@ static const hcall_t host_hcall[] = {
> >  	HANDLE_FUNC(__pkvm_vcpu_load),
> >  	HANDLE_FUNC(__pkvm_vcpu_put),
> >  	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
> > -	HANDLE_FUNC(__tracing_load),
> > -	HANDLE_FUNC(__tracing_unload),
> > -	HANDLE_FUNC(__tracing_enable),
> > -	HANDLE_FUNC(__tracing_swap_reader),
> > -	HANDLE_FUNC(__tracing_update_clock),
> > -	HANDLE_FUNC(__tracing_reset),
> > -	HANDLE_FUNC(__tracing_enable_event),
> > -	HANDLE_FUNC(__tracing_write_event),
> >  };
> 
> Why isn't it sufficient to reorder the enum?
> 
> Thanks,
> 
> 	M.

It is, I just thought we might want to keep both in the same order. WDYS?

> 
> -- 
> Without deviation from the norm, progress is not possible.
