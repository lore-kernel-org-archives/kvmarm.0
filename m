Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4064D9F9A
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550970; cv=none; b=prGIttorNYBNQpwc5wMrjWyjy51DzI13hUbc3Docu1dlTsxB/cvsN2knDSek7Jg2i04TrSYXUc/LupZKuK50+QKUF5tlurnI5pae7DIIgI7iN+2UvwqU6M3e7bLxQYHVpcZ44NqiYkxjIzmkGZAiabeyVUNiyulX3wF1JUT3R7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550970; c=relaxed/simple;
	bh=E/Ji881uQaW/i00G0d8e6H03txxk72xTLZrN8dDV8ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tg1EZhhH2mzHIS7mem83yFLGOoPPZBDkk+Es53ozaGgVf2DAl+FqKjP3xeUabTjQoFsIWlhlaGnzC71paFga+f90VBPOJC72g6UhAAkN/dmKH56vi92QhhtnoYdwgdqBgvqzaV0Bm2cR1IZpEioglf4G5uHWRS88dcojWJ5UeB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ReGnb7p0; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ReGnb7p0"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so877507566b.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 06:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791550967; x=1792155767; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=19+fSLDw62bv9wKAJomFIb9fA14T6XtF00e9ZBRQsYg=;
        b=ReGnb7p04ALcxOWozpdZvQ3eO5kMwPXkQjxaiDsrOwM6sP+tqzeVDrliNE4CBRHO2G
         jruM8Imu6NV/Tfvld7SOZBJEQOqibbID7SGe24mRYLYyYVtHzCInkceNhOsRCax+1Kas
         K4gSYNDhc2/4it+uaRRkIjac/BqhnSK48iKtEYfJMYggYnjP053DhEFelB+gGlaaZqBy
         5TpBqMO0Vprdgi9LGXdKjkb/cDXnIbNVAN3UaN/1ScEAoFV3AdvriBRY6OU1NHXu8055
         lRT32+Pyp789gxIFR/uIGfHRjt7rSQ/MxesYr4R8ICsEtMPVmb18juUcgtt/Z3B4Owan
         hF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791550967; x=1792155767;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=19+fSLDw62bv9wKAJomFIb9fA14T6XtF00e9ZBRQsYg=;
        b=DLlmxWZOrN0eh5PVi5QK8Oy+oinUI7csXvCBCS6CiuLk3a4I8Fa+UEQQyvoZG0TaK7
         Npxae9J9tUkxsX2+dLt4ab2Qc2LZX/ZDFYHSu6wNfN/GtYd2Uofyvvs/dMQHx3f3Ivtm
         tA+3OVW56XTOMPNp3vHMdZm9cqimz7SL78HDITMyRWjxWBef4xWkd3pA3AeLMLmQvzoQ
         bdGMp0eXSwUnLtV+zQJOBPvmNX8WMlX7V2rnl+I+IBKLi+63C1/CXA2STpkgPB67CyWx
         GoTuGmvq/K1Rn1OwX499zHOOPKwroRJo69CtKLvRclj3ArKdIZrw0YK0zk69I2mFxo/k
         Xu9w==
X-Forwarded-Encrypted: i=1; AKwUvBxStAyZo+pmCkeAVON9hPGtJh8wnUuTiDARlin1MM9zo6UlaABBCJXGMIu+32moWWB6fl4rR1c=@lists.linux.dev
X-Gm-Message-State: AFq9FYL7MYud0xUvYtXVOd0NRlIYfCx/VEyHJUH9FFBgcC4vJvxJO6xy
	QZhalxkzfnBICuiJ+8CEzCBrAaAJN914+gXEOIBChtQrV+Iz+EVcsBxNuXp3wFrjTA==
X-Gm-Gg: AYBFou0XxNsEjS3CH7KZHPrrUgEM/gr7cLaacSWSMcIObUYYmBG6Uzc8hpZPgWUP5W+
	aGQmptxVygZBXtps0FxiyRxXX5s7YbQQ2EVhlXCETTDTXo2CvaB4jfU8VQKZOGYFDeDsNnp0UZ9
	eUGo5D6TzeanXsKM398p9pknTy0jW6Co/M0iU3IhM4B4x9NS7QNmhuTDIFkXrQFJhW1ItEbq1wB
	5lsyaHBen6tDZIlr4t5E6XL19hNWjVlNcPQ05SK6mfjyfDex6JXOM7Oh5WySPgnm6mBGxsDjc++
	PDVlIQjLVot68podHYxFG8Uul4vjuiguy9gH2uFtfs01VFlrP+FHNLh3YPjQHR5WadBOgPJTA7m
	NXWci1s2eeXUv41kZZ5+srtpRoO/3MglvXxcTz8RpWkpOlzdR9R4i6iuBUN6iPJJouVd2gQnZKx
	sd14bgrUeGYcPPC7No2qstF9RSWjZ53MjKadmgpEcVf+rfbyl2665dfBm3nrJYENh/n0vqzT1WO
	mD/3Gf4+HurUhvW27zQC0tUDagXXDSyrAjCPhglCZrYMn6PRm3Pbw==
X-Received: by 2002:a17:907:8687:b0:c16:4e5:944a with SMTP id a640c23a62f3a-c31aa02a1ebmr190818466b.21.1791550966562;
        Fri, 09 Oct 2026 06:02:46 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9acdb6dsm3670054f8f.48.2026.10.09.06.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 06:02:45 -0700 (PDT)
Date: Fri, 9 Oct 2026 14:02:41 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v1 1/3] KVM: arm64: Add ESR class to the hyp_enter hyp
 event
Message-ID: <asjl8czHAD017Bha@google.com>
References: <20261009084529.462577-1-vdonnefort@google.com>
 <20261009084529.462577-2-vdonnefort@google.com>
 <CA+EHjTwNTarWqSc_XVXGFT6mHUZD=QuTeVWrd087jUtexxCScg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwNTarWqSc_XVXGFT6mHUZD=QuTeVWrd087jUtexxCScg@mail.gmail.com>

On Fri, Oct 09, 2026 at 12:30:56PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 09 Oct 2026 09:45:27 +0100, Vincent Donnefort
> <vdonnefort@google.com> wrote:
> 
> [...]
> > To distinguish between a trap from host and from guest, add a "from="
> > field, which has 3 possibilities: "host", "vcpu" or "firmware". This
> > value can be deducted based on the existing vcpu field.
> 
> nit: "deduced". Also, "firmware" comes from the reason rather than
> from the vcpu field.
> 
> [...]
> > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> 
> [...]
> > @@ -10,15 +10,10 @@
> >  #ifndef __HYP_ENTER_EXIT_REASON
> >  #define __HYP_ENTER_EXIT_REASON
> >  enum hyp_enter_exit_reason {
> > -        HYP_REASON_SMC,
> > -        HYP_REASON_HVC,
> > -        HYP_REASON_SYS,
> > +        HYP_REASON_SMC = ESR_ELx_EC_MAX + 1,
> 
> This header now uses ESR_ELx_EC_MAX, so it should include <asm/esr.h>
> rather than rely on its includers.
> 
> >          HYP_REASON_PSCI,
> > -        HYP_REASON_HOST_ABORT,
> > -        HYP_REASON_GUEST_EXIT,
> > -        HYP_REASON_ERET_HOST,
> > -        HYP_REASON_ERET_GUEST,
> > -        HYP_REASON_UNKNOWN        /* Must be last */
> > +        HYP_REASON_IRQ,
> > +        HYP_REASON_ERET,
> >  };
> 
> Aren't fixed trace points ABI? This changes the raw values of the
> reason field (1 was hvc and is now WFx) and the strings it prints.
> Keeping the old values and recording the EC in a new field would avoid
> that.

The event format is described precisely in events/hypervisor/hyp_enter/format.
Any tooling should use that, so it doesn't seem like ABI to me. Also, this is
behind NVHE_EL2_DEBUG. The only precedent I know is in kernel/sched/ where there
are only tracepoints to avoid having trace events. 

Finally, we do not expose (yet :)) the raw interface. So this part is definitely
not ABI.

I tried to avoid having the EC separately to keep the event as small as
possible.

> 
> [...]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> [...]
> > @@ -213,7 +213,7 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
> >          write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
> >          write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
> >
> > -        trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
> > +        trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
> >          __host_enter(host_ctxt);
> 
> This also replaces the PSCI, ERET_HOST and ERET_GUEST exit reasons
> with a single ERET, which the commit message doesn't mention.

ERET_HOST is now "to=host reason=eret" and ERET_GUEST "to=guest reason=ERET".

This one here could be considered a bug fix and I could make it a separate
patch?

> 
> [...]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> 
> [...]
> > @@ -324,13 +324,15 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >          __debug_switch_to_guest(vcpu);
> >
> >          do {
> > -                trace_hyp_exit(host_ctxt, HYP_REASON_ERET_GUEST);
> > +                trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
> >
> >                  /* Jump in the fire! */
> >                  exit_code = __guest_enter(vcpu);
> >
> >                  /* And we're baaack! */
> > -                trace_hyp_enter(host_ctxt, HYP_REASON_GUEST_EXIT);
> > +                trace_hyp_enter(host_ctxt,
> > +                                ARM_EXCEPTION_CODE(exit_code) == ARM_EXCEPTION_IRQ ?
> > +                                HYP_REASON_IRQ : ESR_ELx_EC(read_sysreg_el2(SYS_ESR)));
> >          } while (fixup_guest_exit(vcpu, &exit_code));
> 
> Could ESR_EL2 be read only when the event is enabled? The read happens
> even when tracing is disabled or compiled out, so every non-IRQ guest
> exit now does an extra one: with NVHE_EL2_DEBUG=n, __kvm_vcpu_run()
> goes from two reads of ESR_EL2 to three.

Hum, that's a good point. I was thinking about having a HYP_REASON_ESR that when
sent actually read the ESR. But then handle_trap() would read it twice, unless
this one still gives the esr directly.

Alternatively, I thought of moving the esr_el2 = read_sysreg_el2(SYS_ESR) out of
__fixup_guest_exit(). But it didn't look nice.

WDYS?

> 
> [...]
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> [...]
> >  static const char *__hyp_enter_exit_reason_str(u8 reason)
> >  {
> [...]
> > +        if (reason <= ESR_ELx_EC_MAX) {
> > +                int i;
> > +
> > +                for (i = 0; i < ARRAY_SIZE(class); i++) {
> > +                        if (class[i].mask == reason)
> > +                                return class[i].name;
> > +                }
> > +
> > +                return "UNKNOWN_ESR";
> > +        }
> 
> Could this print the EC value when it isn't in the table?
> kvm_arm_exception_class has no entry for ILL, BTI, SME or GCS among
> others, so an ARM_EXCEPTION_IL exit (EC 0x0E) shows up as UNKNOWN_ESR.

I can extend kvm_arm_exception_class. Having a dynamic format string is not
possible here.

> 
> Cheers,
> /fuad

-- 
Vincent
