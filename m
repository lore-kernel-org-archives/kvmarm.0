Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48FDC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 566E061269
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 566E061269
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 061A24B15E;
	Thu, 23 Sep 2021 15:16:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N5FSad47v-Nf; Thu, 23 Sep 2021 15:16:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4A984B11E;
	Thu, 23 Sep 2021 15:16:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F7194B130
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5FPY1WFRJBxK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:22 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 305B14B0FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:22 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 q18-20020a252a12000000b005b263fcc92eso295379ybq.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YX6wLWSIJTG38D0JCJDYsCJb2+sCdnlZJoLOpE40P6M=;
 b=Igy6VVMKWdhPbPXq1S7BSk4Zo0tnmp6XkOd5OoVhvbxZfpbMMdSjLKLrVZQfDwkijt
 Gid6Wob2mCp9b9SwnyLnbx06l3w1bICa2ctn4n6NANLSLTQSfnclob8KsMXrr5CL7F/D
 J0NefWfn8S8LKdSN+qJJgpBc5NH36yiRxOp85vnJChbIFKT7LcWaX7GP26tnUU3CtKyK
 avfHaoIlf2XKDDeBLpSQhEQrrc/eZ0OjtOGpFnqD7LyWSexSfd/IUPHQWjv2Uxjsik/L
 0rxFMjqae0jVCJEdLx+HqyPqqpTs839lVDhapYnYePAoM79WsF90TOhK/RrMmzA4+Czl
 LyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YX6wLWSIJTG38D0JCJDYsCJb2+sCdnlZJoLOpE40P6M=;
 b=GmXTa2BBj/D/ebbHg3soqkvGApSOIIOFzSUD/mvAfv9Qx3dg8bf5ZkkWH6C8P4YDCo
 aBjnX1tiTPlQeDJWfVDf9npNdWIvzcfnrShO9nY6rOWwWm9XjR73xWo0bKv9f7OcR35v
 zQOd0UjhXVTzky/LuJHlALbo9WRTeH7orEVPOz+wx1GGxG6C8r2+JWzxVjLL9zUQYBI4
 spNTYF2uCWELgl5AolJ48/+wbv8qsvRAj40z55MmcPTDVjWpMfA7Da5QGdFy/XnKmeNi
 jy8hZOfFNXyPVs+BaRQXWxSOcaDr1dOIa/yEhanbN+aRuOJNcZkOEwA/i24fzY3xtIMf
 8Zsg==
X-Gm-Message-State: AOAM531Ea7di2qCkHcMroMmPTbVqnyDpa5LokrXKBZiPaOUtrs8aNQZP
 UmwaHjTHimGwr5nGV8Xbk0VHs3tBQrToeS4ME30FZsdoZhb6CaMd9sYRBrsr7b+AtXiD5HGqiEx
 +n//3xeQ/x0jsW+IbBuExYxjV+X0jq0J1Oqha+pP1YeYkZ1dlzKkB5Dg88HGVLv4NgV6woQ==
X-Google-Smtp-Source: ABdhPJz1tbWEEs1Gv4kYcRNWO/op3Eino71+uPo4QLG2oDpchkCrTFHJgIB2O8EyPAJDVKVyWcqX4trvHyo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:12d6:: with SMTP id
 205mr8004600ybs.441.1632424581627; 
 Thu, 23 Sep 2021 12:16:21 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:04 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-6-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested event
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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

The emulation of WFI-like instructions (WFI, PSCI CPU_SUSPEND) is done
by calling kvm_vcpu_block() directly from the respective exit handlers.
A subsequent change to KVM will allow userspace to request a vCPU be
suspended on the next KVM_RUN, necessitating a deferral mechanism for
WFI emulation.

Refactor such that there is a single WFI implementation which may be
requested with KVM_REQ_SUSPEND. Request WFI emulation from the
aforementioned handlers by making this request.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 9 +++++++++
 arch/arm64/kvm/handle_exit.c      | 3 +--
 arch/arm64/kvm/psci.c             | 4 +---
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..1beda1189a15 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -47,6 +47,7 @@
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
+#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3d4acd354f94..f1a375648e25 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -670,6 +670,12 @@ static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 	smp_rmb();
 }
 
+static void kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_block(vcpu);
+	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+}
+
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.target >= 0;
@@ -681,6 +687,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
 			kvm_vcpu_sleep(vcpu);
 
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
+			kvm_vcpu_suspend(vcpu);
+
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..5e5ef9ff4fba 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
-		kvm_vcpu_block(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		kvm_make_request(KVM_REQ_SUSPEND, vcpu);
 	}
 
 	kvm_incr_pc(vcpu);
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index bb59b692998b..d453666ddb83 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -46,9 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * specification (ARM DEN 0022A). This means all suspend states
 	 * for KVM will preserve the register state.
 	 */
-	kvm_vcpu_block(vcpu);
-	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
-
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
 	return PSCI_RET_SUCCESS;
 }
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
