Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B5FC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21635611CA
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 21635611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C719E4B187;
	Thu, 16 Sep 2021 14:15:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MB8oPR6Ca3rH; Thu, 16 Sep 2021 14:15:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7749B4B0E2;
	Thu, 16 Sep 2021 14:15:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 502334B15D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B8KsdP9B-eVi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:26 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 404774B128
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:26 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 d23-20020a056602281700b005b5b34670c7so13747290ioe.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XUo/cabJC2z3w3MrWduFKk4WaDY4TAKhMiRwSkCiAgo=;
 b=FiHKbPWfNLd8h3hHTWDz0wf6UJseMtqwYaIb5d2P8FsRf17sd4QzQ8PbtmcvYUfy9a
 WEGMeW3Vr2Mi3wTUySTqL/ey+OH0o5FU14Z+kfNlq4c9H+9n3/qFgWxsbsXIVEWKPWVP
 H59LQ2whbEZLpR8yNuf39IydUL4SEGNl99MJgNpWNQK1PwR8XFFL+Xos2R++8wflwKte
 fEo39WLray0Axn4POpXXYSTR9Vcotb1h+FcXrzfJh29ePPJOSMxcURU99hRjLpQ3zZp8
 zEkU0vYXWKz2RfP28kSSc+5DK5DOMgG8uWoOgjThWgi1V2zzNjxh+8nGPLzXAIxkWnPX
 kTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XUo/cabJC2z3w3MrWduFKk4WaDY4TAKhMiRwSkCiAgo=;
 b=D4UPXF3yj9CiigVSGK+2svmmTt92HbgRAd3MEsR2BhR1EmmGVe3GIVmqTTJP4U5Hzo
 USIQsY7pwJ5phc0z2MSYg8XXZLmRiokx/ZbhjXuBydDMNFN45ji4TjfrFp7QEkaKERh9
 JeqLd/yC7JgxG0xRscxT+itfKYjEsmvGprkMsLFDKeFaAD7TjMUpXJtwV6r1BR+s3MQ8
 ooXFsTlWz01nGQbGoHio0zfVWrX6ScOFUCE6hG5WSZun6dwzcH1pCSGykdmWr0gMCjgO
 7tXE424Gm9RZPH7Nk4GXLYFQjuIYdS7Sh1wmK7srUOXOesY9ZPGVtp2l1XccNlUaxJvd
 SN+Q==
X-Gm-Message-State: AOAM531YfrCAkFHhnPwpH9F/DQ8deE05Hgcwp/dH77a3Y5d0AdT4aWqv
 BbyNMJvxMKfK1iJ2z5hKH6wBZs4J/xc=
X-Google-Smtp-Source: ABdhPJwtaweXuS39g26oV8m+aB6wVZTQ+xy+L2QMCX4fbgUnZ0pMTxHQ1syrpggpylUpo2byr1NmjTqgKTU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2e13:: with SMTP id
 o19mr5529495iow.9.1631816125727; Thu, 16 Sep 2021 11:15:25 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:04 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-3-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 2/8] KVM: arm64: Separate guest/host counter offset values
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

In some instances, a VMM may want to update the guest's counter-timer
offset in a transparent manner, meaning that changes to the hardware
value do not affect the synthetic register presented to the guest or the
VMM through said guest's architectural state. Lay the groundwork to
separate guest offset register writes from the hardware values utilized
by KVM.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c  | 42 +++++++++++++++++++++++++++---------
 include/kvm/arm_arch_timer.h |  3 +++
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c0101db75ad4..cf2f4a034dbe 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -84,11 +84,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 
 static u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		return ctxt->host_offset;
 	default:
 		return 0;
 	}
@@ -128,17 +126,33 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 
 static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
+		ctxt->host_offset = offset;
 		break;
 	default:
 		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
 	}
 }
 
+static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch (arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER: {
+		u64 host_offset = timer_get_offset(ctxt);
+
+		host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
+		timer_set_offset(ctxt, host_offset);
+		break;
+	}
+	default:
+		WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
+	}
+}
+
 u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
@@ -749,7 +763,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 
 /* Make offset updates for all timer contexts atomic */
 static void update_timer_offset(struct kvm_vcpu *vcpu,
-				enum kvm_arch_timers timer, u64 offset)
+				enum kvm_arch_timers timer, u64 offset,
+				bool guest_visible)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
@@ -758,13 +773,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
 	lockdep_assert_held(&kvm->lock);
 
 	kvm_for_each_vcpu(i, tmp, kvm)
-		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
+		if (guest_visible)
+			timer_set_guest_offset(vcpu_get_timer(tmp, timer),
+					       offset);
+		else
+			timer_set_offset(vcpu_get_timer(tmp, timer), offset);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
+	if (guest_visible)
+		timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
+	else
+		timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
 }
 
 static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
@@ -772,7 +794,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 	struct kvm *kvm = vcpu->kvm;
 
 	mutex_lock(&kvm->lock);
-	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
+	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, true);
 	mutex_unlock(&kvm->lock);
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..9d65d4a29f81 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -42,6 +42,9 @@ struct arch_timer_context {
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
 	u32				host_timer_irq_flags;
+
+	/* offset relative to the host's physical counter-timer */
+	u64				host_offset;
 };
 
 struct timer_map {
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
