Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE80C4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13D6F60FC3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 13D6F60FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD9B94A4C0;
	Wed,  4 Aug 2021 04:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tSL-Wv-XBdxX; Wed,  4 Aug 2021 04:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D9204B099;
	Wed,  4 Aug 2021 04:58:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9664A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PC+hyvR+DzMB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:49 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C87340629
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:47 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 c63-20020a25e5420000b0290580b26e708aso2242575ybh.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=35TVCGaSXP1YX+xl0ynmypPjFUwRXJIFcUTUP7y3OEA=;
 b=uZnF95SUd8tPNPh9UDFmW/BkibQwuIqjWxF/hBpRgMBadermRtPRVOXDB9dmgoECSE
 FKyGfmtyrLDrsggccC+Bh3D5G2gELbtHa3uN0XfY5JKG0ECY2NshKN8FbWDsmNi36LEb
 ctSbdLL+8gkNDC+TlCJ0gt0RNoAPIKSkADIlXB6qQ9GqhxXiuP9bYTOxBYCK/0CJbLyX
 OMo5Qd7rEVm7l+Vl0r9z9VADsMHVwgRinpxvMjgoANM3sIcdXewmA5o0ijE8KaMaarny
 i6gAvU3WwVGrOeGLvkW/NqGz11SdqskIEqbf4Vm2r99E0OmmNmyy0TLewqXP11d4sUzL
 O8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=35TVCGaSXP1YX+xl0ynmypPjFUwRXJIFcUTUP7y3OEA=;
 b=YbunTbv4XCGeVQXOoOs9mCEVgesvXHGd86EalTIIUiu65foAcP/dLlGsLJMIV4uzsL
 dPVEx9W3TEufpdHIjX3m1bUVwz3T7oQE+5hlqQHAmrjvKhDKyH5tLFmVrrDEd+bHEReO
 DNwzf5dBpeavwjpVjzOpIytHc5yjkudO7+WNk6w4BkhYvcnb0Zc9/fpDGDXBuqNE0raQ
 o8ag36JJdUezkDxlLds5PKbcL1Fv+qfLUB6pdVAOjB+izUZTqXWFRwJfVAFv2WpvuZXF
 DLc9HwKVX4sc2BSIDQW2mDM89OoulMJDoi6W6xUYltfZnNSF1eOtMcfc0IRt6NXTemD9
 HRDg==
X-Gm-Message-State: AOAM532eq2eEz3t+ZXZ7ftj1oZ7Uzc4AOLSH1BmvtM/gPAfL5Tq84tRG
 8Rq6FzkLrG8x+MBzUh6ejIw1yecO+lI=
X-Google-Smtp-Source: ABdhPJwQw2VG+2wPW9YYVkLKNHJyZLMCee16q7ggjAFKp03Ugn+6tAxy0sKWEOCLAMhlJGHciviyBhrNI/s=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:8010:: with SMTP id
 m16mr34219421ybk.210.1628067526796; 
 Wed, 04 Aug 2021 01:58:46 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:09 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-12-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 11/21] KVM: arm64: Refactor update_vtimer_cntvoff()
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
