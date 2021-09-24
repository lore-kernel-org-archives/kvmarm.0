Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B01C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AE666141B
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5AE666141B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB0C40191;
	Fri, 24 Sep 2021 08:54:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0qQ2iwK612Ri; Fri, 24 Sep 2021 08:54:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 226ED4B1B3;
	Fri, 24 Sep 2021 08:54:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 604174B1C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n+934R6iAePq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:42 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 554E54B0DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:32 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 m1-20020a056000180100b0015e1ec30ac3so7987784wrh.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iSSWi58NWKOpw0/j/jthgGrijZ2kgwmPgBIUtV8ETrY=;
 b=YPs8fe54kX7jNCksdMFXe0yl0eg5/mV5V/gzTwhmbgLTmlcb/RfkH5tjD8pG9ykQI7
 4qHQSge5XK5NRfCYmF9+FR9qVClA0ZxZvGXQrNRTSlpydveHokALYA9t+7sl2sEi4i8K
 i6IG06/j1uJFNz94nZsXZIM/NqOhAWYJOW+oBT2D1jNBt/D8sjKIUvaXhfzaK63UDkM6
 RHekE5GpHYY+vDcJTV32Z70zHzoHPzx/JQD2Px5+LnYr13K0/uaGdyhvCqnCDZs+Ako+
 LpJP8KUeCbQodUcsenuY6SKU5OuodaMJefDk6yOTBf0RcF38yZgBqYjk0BGysIbgDT26
 pEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iSSWi58NWKOpw0/j/jthgGrijZ2kgwmPgBIUtV8ETrY=;
 b=wTOFJy8UwHUbAbwTSXTczhnS3VZ9MDaTgmA5WGjl7YjA7Uf7jnF+Noncv+0TaiSge4
 ejMmyh+z3qA/8jt01Otptvba1zlNEkvLSDRkGxT9vJFNLIk2Gf3tkmjD94NprNCjWggj
 6ejHEgyA+Ge29qcySuKaA/5HzVCWnURhPtv6b2fJNGhhNcjB4vYdHcFfcObI7TGwjaF5
 fE6dmz9/qAB3ZhauqNrZoG6ufCiCNnR7+j9koimZNlWvN1AK6Dzd93I5uhS4eqB4HYl+
 9/u4cnMcOaKeYyo9+f1U2ZpTz8XJCFUIjjYJYToH5Yo82yKfYfX/GBFGrs7klLvnszro
 gLCw==
X-Gm-Message-State: AOAM531tjMihDBhon2XcldEgSL011h0vdbVopHlPyRrpza2rbzg9G7Ru
 yMK+ZzVLjE/zwEPJ5cvYVBShvNbNqVDcLMgbINftnwG0lMODVJS8GOHuIq2gwReiO+1dp9w5ekX
 rydjV4n+RXXPN12/CSTzVH4EXOE9/z7AzXzicbRIGFIGhdO5R09hIu+NFLFnnw1aFDCc=
X-Google-Smtp-Source: ABdhPJwfXwizprVtGpfhH9CMgSvy4oJQcTlOwGhEYh7h/UCWQzWob21fBAkjNrZp9qiNYIRW3sxPzk3w1w==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c405:: with SMTP id
 k5mr1951606wmi.24.1632488071450; 
 Fri, 24 Sep 2021 05:54:31 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:43 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-15-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 14/30] KVM: arm64: reduce scope of vgic v2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

vgic v2 interface functions are passed vcpu, when the state
that they need is the vgic distributor, as well as the
kvm_cpu_context and the recently created vcpu_hyp_state. Reduce
the scope of its interface functions to these structs.

Pass the vgic distributor to fixup_guest_exit so that it's not
dependent on struct kvm for the vgic state. NOTE: this change to
fixup_guest_exit is temporary, and will be tidied up in in a
subsequent patch in this series.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h         |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h  |  4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c         |  4 +++-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 16 ++++++----------
 arch/arm64/kvm/hyp/vhe/switch.c          |  3 ++-
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2737e05a16b2..d9a8872a7efb 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -55,7 +55,7 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
  */
 #define __kvm_swab32(x)	___constant_swab32(x)
 
-int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
+int __vgic_v2_perform_cpuif_access(struct vgic_dist *vgic, struct kvm_cpu_context *ctxt, struct vcpu_hyp_state *hyps);
 
 void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 075719c07009..30fcfe84f609 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -424,7 +424,7 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  * the guest, false when we should restore the host state and return to the
  * main run loop.
  */
-static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgic, u64 *exit_code)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
@@ -486,7 +486,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			!kvm_vcpu_abt_iss1tw(vcpu);
 
 		if (valid) {
-			int ret = __vgic_v2_perform_cpuif_access(vcpu);
+			int ret = __vgic_v2_perform_cpuif_access(vgic, vcpu_ctxt, vcpu_hyps);
 
 			if (ret == 1)
 				goto guest;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index eadbf2ccaf68..164b0f899f7b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -172,6 +172,8 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	bool pmu_switch_needed;
@@ -230,7 +232,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &exit_code));
+	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index acd0d21394e3..787f973af43a 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -34,19 +34,15 @@ static bool __is_be(struct kvm_cpu_context *vcpu_ctxt)
  *  0: Not a GICV access
  * -1: Illegal GICV access successfully performed
  */
-int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
+int __vgic_v2_perform_cpuif_access(struct vgic_dist *vgic, struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_dist *vgic = &kvm->arch.vgic;
 	phys_addr_t fault_ipa;
 	void __iomem *addr;
 	int rd;
 
 	/* Build the full address */
-	fault_ipa  = kvm_vcpu_get_fault_ipa(vcpu);
-	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+	fault_ipa  = kvm_hyp_state_get_fault_ipa(vcpu_hyps);
+	fault_ipa |= kvm_hyp_state_get_hfar(vcpu_hyps) & GENMASK(11, 0);
 
 	/* If not for GICV, move on */
 	if (fault_ipa <  vgic->vgic_cpu_base ||
@@ -54,7 +50,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return 0;
 
 	/* Reject anything but a 32bit access */
-	if (kvm_vcpu_dabt_get_as(vcpu) != sizeof(u32)) {
+	if (kvm_hyp_state_dabt_get_as(vcpu_hyps) != sizeof(u32)) {
 		__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 		return -1;
 	}
@@ -65,11 +61,11 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 	}
 
-	rd = kvm_vcpu_dabt_get_rd(vcpu);
+	rd = kvm_hyp_state_dabt_get_rd(vcpu_hyps);
 	addr  = kvm_vgic_global_state.vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
-	if (kvm_vcpu_dabt_iswrite(vcpu)) {
+	if (kvm_hyp_state_dabt_iswrite(vcpu_hyps)) {
 		u32 data = ctxt_get_reg(vcpu_ctxt, rd);
 		if (__is_be(vcpu_ctxt)) {
 			/* guest pre-swabbed data, undo this for writel() */
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 395274532c20..f315058a50ca 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -111,6 +111,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
@@ -145,7 +146,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &exit_code));
+	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
