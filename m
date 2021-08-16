Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771DCC432BE
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29DB86137D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 29DB86137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B704B0D5;
	Sun, 15 Aug 2021 20:12:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id foEk-UhVgcEy; Sun, 15 Aug 2021 20:12:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5BD4B0E8;
	Sun, 15 Aug 2021 20:12:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8667D4A193
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2UVSU7oHDQGY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:22 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 637FA40895
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:22 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 i32-20020a25b2200000b02904ed415d9d84so15006963ybj.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=onAqEh8W0SBicAWR55u2ngfwbUkFlrlMLEeDkUeYr84=;
 b=qhpICAaFLhU3+IHGm11sW/Isc3WfyB2RHrfJtKUbGw63J9vM6gdE81PvZpG2zwzw8O
 xvVYLTVWjzq99ack7VgFOvIFPZ9F8t1LoJ+Bka5jr0/d1fVgY11AhngDstTL1cvP8CGl
 uzx6mHO3mvAm1M8LD8tT2AZJBhRb1SK4+nTn70NI8oIPj2hNdSXzcfTaW9wyiq8hjMmt
 SeTDHthVV5479sAgDnHPGWxL3jKaNRJ7PjRH2ZZ+VZci3oTPKyXAAOqKsDZ0WtPr0VeB
 9t45HJPdPMTdj85xkXn2iZcBVWBjs8VxIxPa4CqJJyRRVVNRxf2OeHlXRUStSFQlttQb
 94Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=onAqEh8W0SBicAWR55u2ngfwbUkFlrlMLEeDkUeYr84=;
 b=LhfQ5b51iDXWYh7MGzFddCeqW8BWNVplbhtjQfZAxoRRDqHzCtHAfIQZ8gWR/ItJNI
 cDEdxpsCmCnguc++gC7F+GeqWhi4XDtw0EpmwUwCUGuBFfRn+lT3VeaB71f5CbpaqwQg
 SUR23+ZYD3s0mvkdmnu1ZgesaRaA/SiULgIvEG6N8xkKfddk1ahe2h//d4wcSpSS2Gc9
 eCpwvMKnXtdEwqu+8HCbDtiW/P2bRfO5LPmNIH/l793OTE2nXti/0KOH/UIsd72hHFQm
 dF4AMc89nvEbPHklZ1OCwLKQVu888WlBV6UaMilrg9V17ehwDMZFf9onhWGWCqvNo2WO
 U1pg==
X-Gm-Message-State: AOAM530raN2jNRdIQ2B2o+S/PchB0QC2nxDg0h/S3GKSmdnW8U8ojfck
 QU73a0Ldr7T4F8uTz3Sp5rtktDT1oMU=
X-Google-Smtp-Source: ABdhPJy6FWA8u3sJLeHS6AWC8Xv9Z0rmwcuGesbQJOl0Ryv15/E1haP7bvTFN3gsAs53WozMzCacm0BdTVs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:8c4:: with SMTP id
 187mr17077125ybi.369.1629072741950; 
 Sun, 15 Aug 2021 17:12:21 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:11 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-2-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 1/7] KVM: arm64: Refactor update_vtimer_cntvoff()
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

Make the implementation of update_vtimer_cntvoff() generic w.r.t. guest
timer context and spin off into a new helper method for later use.
Require callers of this new helper method to grab the kvm lock
beforehand.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..c0101db75ad4 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -747,22 +747,32 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-/* Make the updates of cntvoff for all vtimer contexts atomic */
-static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+/* Make offset updates for all timer contexts atomic */
+static void update_timer_offset(struct kvm_vcpu *vcpu,
+				enum kvm_arch_timers timer, u64 offset)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *tmp;
 
-	mutex_lock(&kvm->lock);
+	lockdep_assert_held(&kvm->lock);
+
 	kvm_for_each_vcpu(i, tmp, kvm)
-		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
+		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
+	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
+}
+
+static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->lock);
+	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
 	mutex_unlock(&kvm->lock);
 }
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
