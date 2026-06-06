Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ACF27A462
	for <kvmarm@lists.linux.dev>; Sat,  6 Jun 2026 08:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780735934; cv=none; b=L0qdvpSXbrKCCtSCasaMbt1XeoZtgUXU05Dgsfti1XXEoW27yA4z9xuoh/EGhLJ/1ujZO3i71x3uqUaXnbSTbHOrdTod3u/tfQbaa9r7T5NC1b/fPqsxmQBeIq9l2LruuQu4yqfj5mNawSIx6Ek1RgLsP+CO7iuOHv5ltkA5npI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780735934; c=relaxed/simple;
	bh=+kbh0gHAGN1Nm1W2jDsmmhIgy8fJvPtq+uaJxP3HWs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FISw2Cf7q7bpEeY6d1JF97pptnTbCOc33tzHUMYkJNKCBjX+9aizr2wzLS2ki2g7/qBOSxuhQ11DVmX7xJGPCYQ+C9BSwAtFv320TcR59AR6BihgTNhHAz4byyvZ958NwXO2h47FK4LWlFNFxu5jnwsMM/zS95+tS9+NA+LBS7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qWPx/VFd; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qWPx/VFd"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c132ac5ec2so26771315ad.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Jun 2026 01:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780735932; x=1781340732; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2yhw+U5U0mRKAveZkpb01TNee8kz0XAwdmr1c41j2p0=;
        b=qWPx/VFdlSuHXn103gDSn4A3+J1b1r46JaKiHysbInim0ZcUWxVcw6NEXPCAdZr9QT
         l3cctd1tXFY/i8Xcrl2ecDOWtN5n80zjg97C3wj0JWQFCf/ZouCZ69r6Mdi5/kvsmuCO
         I3qDG/GfgG70nC0NqBEeLUktvjdwvFpdX5CSVZlstc0wtM+wmul7Zp564liWnxValCf2
         9udTEzl3chYq84yidtj5hfxO4nIJRnA5k2LR8szF3bpUdaOBIpgFlF5s4CaFkgwip2Z8
         E+1beJYGIG1BHm3bBKAzaJsB5st8g8XM4rNOb+iN1TSjpD1iN+OTtLffVrI4VvowazOV
         aAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780735932; x=1781340732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yhw+U5U0mRKAveZkpb01TNee8kz0XAwdmr1c41j2p0=;
        b=gxZDXvxt0lgZ7yb/b9BtlYrNfmBtlhLROjt3P1azYC4dpkT/glqr+MGqlaq53yOoC1
         o5p4q58tbZnNEePZI0120R3QvTPdTn1K9sa3Fkwj6LwquStiLGEGoTqhrLo5cCqeQKBM
         RLz2OPf7HDp9kxoNtPAj0niUVN5z4tmGzdNqYUllkXNYBDoX5BmqKSt9aC9AGfXnw5yi
         iiCZE0U/GlSWV8CiRXuknj1Vt2z9KH1PlXNzk8C++NDHWZi2BNmRgNubvUmv+YL+eMhG
         SuVV65Trdi0V0aCn3Yf+BqCXhcu/ZhMqtU8zYvJkhYSgaMSI2Wlr4puu3AYSIBIutGWH
         E9UA==
X-Forwarded-Encrypted: i=1; AFNElJ966035Eex1/VGJ6udss2wS3g4Yt/tOGzyC7wyVbWUCv2Wb5ZZwMfjrY9Zoeu6vVXVL7PCBemM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRlN+c/nEmcTt8HtpIdbFNsbTaEr/c+XLIi4A0+bQdfA6zzLj2
	Lu4ANc6oT47X5Vfwyv2+AlEer5fNHmadC1K0lWonJltxDi6TfyEaokKI
X-Gm-Gg: Acq92OGAh5kl4JKaFm+5hKnI9Nw2U6kxfHSyI3E7OngT0qWjB0JXjwfZegOH5jWpMOg
	oZq1DGz+CHwxqiW5gE4EyYP+8Jm2wta+9ar+ewa1Cl8wh6sh3B07zYKTUrQBRpic40N03Pr7N/r
	siZv1QiRxXge5XeiC2w0702Hu9guvCNqgD+zOOZDbImshCBkyGF0uuRHm4DjOA116Oo1c4n9gKL
	WKKdwxndzSKNow9OJbRnGT6Grs8iJAbeY242Lv87JGknAHvaFiYarMPmBCU0lVCwB0dTaKJum0s
	9lKBEqgwGeLy9X6bTBMB8GeHRy3gnCLSy1CdH9FiOVm/Rr4Xwequ6pYGi97jXC80K/vAgZLDtkw
	yvFW/2mOgGrrLvcnX/4+OdKwcGvm8vV142AVG9yueMFhbY3pOyAOyQIGKCS63GyJ/ejA+VuY7Bz
	LlIb07EbY4QAFmAF6i+W9YpuF88YUDtchJARp/TFAO/EZQcvYUhO9trQ==
X-Received: by 2002:a17:902:f78d:b0:2bf:175a:db61 with SMTP id d9443c01a7336-2c1e7b35b28mr81493275ad.7.1780735932557;
        Sat, 06 Jun 2026 01:52:12 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649d2dfsm116177535ad.75.2026.06.06.01.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 01:52:12 -0700 (PDT)
Date: Sat, 6 Jun 2026 17:52:08 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: tabba@google.com, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: Re: [PATCH v2 2/2] KVM: arm64: Bound used_lrs when flushing the pKVM
 hyp vCPU
Message-ID: <aiPfuAmM8JbtT6GY@v4bel>
References: <20260604151210.1304051-1-imv4bel@gmail.com>
 <20260604151210.1304051-3-imv4bel@gmail.com>
 <86zf19tlcu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zf19tlcu.wl-maz@kernel.org>

On Fri, Jun 05, 2026 at 09:58:09AM +0100, Marc Zyngier wrote:
> On Thu, 04 Jun 2026 16:12:03 +0100,
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > 
> > flush_hyp_vcpu() copies the host vGIC state into the hyp's private vCPU
> > on every run. The vGIC list register save and restore use used_lrs as
> > their loop bound and expect it to stay within the number of implemented
> > list registers. While this is generally the case, flush_hyp_vcpu()
> > copies vgic_v3 verbatim and does not enforce this, so a value provided
> > by the host is used at EL2 to index vgic_lr[] and access ICH_LR<n>_EL2
> > (host -> EL2).
> > 
> > Fix by clamping used_lrs to the number of implemented list registers
> > after the copy, as the trusted path already does in
> > vgic_flush_lr_state().
> > 
> > Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 02c5d6e5abcbf..cd807fdb11ba8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -7,6 +7,7 @@
> >  #include <hyp/adjust_pc.h>
> >  #include <hyp/switch.h>
> >  
> > +#include <asm/arch_gicv3.h>
> >  #include <asm/pgtable-types.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > @@ -142,6 +143,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  
> >  	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
> >  
> > +	/* Bound used_lrs by the number of implemented list registers. */
> > +	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> 
> There is no pKVM support without a GICv3 CPU interface, and absolutely
> everything already assumes it. Why do we need this extra check?
> 
> > +		hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
> > +			min_t(unsigned int,
> > +			      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
> > +			      (read_gicreg(ICH_VTR_EL2) & 0xf) + 1);
> > +
> 
> Reading ICH_VTR_EL2 on each entry is going to cause some really heavy
> trapping under NV, and we should avoid this.
> 
> kvm_vgic_global_state.nr_lr contains this information, and it should
> only be a matter of replicating it (or compute it once) at init time.

Does this approach look reasonable to you?

---

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 8d06b62e7188..25199769a1d6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -157,5 +157,6 @@ extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
 extern unsigned long kvm_nvhe_sym(hyp_nr_cpus);
+extern unsigned int kvm_nvhe_sym(hyp_vgic_nr_lr);

 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9453321ef8c6..891fe2c7b854 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2426,6 +2426,7 @@ static int __init init_subsystems(void)
 	switch (err) {
 	case 0:
 		vgic_present = true;
+		kvm_nvhe_sym(hyp_vgic_nr_lr) = kvm_vgic_global_state.nr_lr;
 		break;
 	case -ENODEV:
 	case -ENXIO:
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a8..8bb9362bc284 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -128,6 +128,9 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)

 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;

+	/* A guest context must keep a NULL __hyp_running_vcpu. */
+	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
+
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
@@ -139,6 +142,12 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)

 	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;

+	/* Bound used_lrs by the number of implemented list registers. */
+	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
+		min_t(unsigned int,
+		      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
+		      hyp_vgic_nr_lr);
+
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index d461981616d9..ebc6b4afc336 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -20,6 +20,7 @@
 #include <nvhe/trap_handler.h>

 unsigned long hyp_nr_cpus;
+unsigned int hyp_vgic_nr_lr;

 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
 			 (unsigned long)__per_cpu_start)

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.


Best regards,
Hyunwoo Kim
