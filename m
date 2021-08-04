Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3F3C4320A
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 518E460F6F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 518E460F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0150E4ACC9;
	Wed,  4 Aug 2021 04:58:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vg8RPcgAg-1U; Wed,  4 Aug 2021 04:58:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B59FF4AEE2;
	Wed,  4 Aug 2021 04:58:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 763BB4A1A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0x9xw84F8pIp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:50 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F12F4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:48 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 c11-20020a92c8cb0000b0290222da0d1404so287196ilq.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=83fDaIfLsY16yic2+Bpl9lC9hOGkPIV4LchssH1j3LE=;
 b=SN6GL4hBv6p6nMD4A6e58ghkZoNJfYaNi1MH9O1SIy7AoxXS7cRW68enEg2zIivQkk
 aZholzalc9xdnfdFzpu9eczDYMKU3+21wWy+fHFgrhF1LmBnspbi1VbEK21vIeTc6TgF
 rxlaa1A0gISSGbu1UB7PaIEPBWtI6gYPJAV/mOAXQctzT1NMqQZJYYnplqQFgzPN9OjD
 YtOYVGsAkqQIxCqhX5FD0AOTTtVv8WbFRE/CHjmppQjFKKelImAn2YGU+uu7XY+qyKZr
 CbnHCJveaEuBZkRFO75LP0K3L/M8CD56y8I6K0CXzIBrVp7Y0gEcqjJiNLCF63KqUPgI
 uDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=83fDaIfLsY16yic2+Bpl9lC9hOGkPIV4LchssH1j3LE=;
 b=MA6yrT/Ln8umBItdpfCYi7gfR2nCHF6juKpHot//LVbOjEBNg2Lryq92O3QovQWLM0
 ZmtS1BftlMfVqKC5QciLW21Y21qIehMIPXVFphxdrF208DvkxqOAVUbHcmVS7d91RA+L
 LkoIOSAr10l7kwG8CM1nBfmUTh2f26UkuGM+/s6rm7XVc7pLqGyQZ9Ca5IpdhMtrZoYw
 mCpEnLUbtBKlPs6UEogDAooqlcNW6SAcoaGguGRX+XpxczSjtZC7o9v+iPYtEKfniWL8
 i+xqC3AiFZLSPAdLVWjBXL7P0x5QlLroN+lZ1JsUU9GjAvRHxBJv1dji9HQDju0FP/g+
 minw==
X-Gm-Message-State: AOAM533jJyK+pVH32I/ol1edIApZ5UfdCATFRx+8WidOxQyiwv0yOZYk
 C8uiR0H5SaUlPBQp49+i0ggITu1Skgw=
X-Google-Smtp-Source: ABdhPJzi9q8UGwJAYqkti8laANuUPc3nn5R3eDyiiZDnOVn9vGB1o/QfvD8/gVEEbONDuMag3MzbiMyJaWQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:5205:: with SMTP id
 g5mr634503ilb.22.1628067527974; 
 Wed, 04 Aug 2021 01:58:47 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:10 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-13-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 12/21] KVM: arm64: Separate guest/host counter offset values
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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
---
 arch/arm64/kvm/arch_timer.c  | 48 ++++++++++++++++++++++++++++++++----
 include/kvm/arm_arch_timer.h |  3 +++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c0101db75ad4..4c2b763a8849 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -87,6 +87,18 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
 	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return ctxt->host_offset;
+	default:
+		return 0;
+	}
+}
+
+static u64 timer_get_guest_offset(struct arch_timer_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch (arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
 		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
 	default:
@@ -132,13 +144,31 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 
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
@@ -749,7 +779,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 
 /* Make offset updates for all timer contexts atomic */
 static void update_timer_offset(struct kvm_vcpu *vcpu,
-				enum kvm_arch_timers timer, u64 offset)
+				enum kvm_arch_timers timer, u64 offset,
+				bool guest_visible)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
@@ -758,13 +789,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
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
@@ -772,7 +810,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
