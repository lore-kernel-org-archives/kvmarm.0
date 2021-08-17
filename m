Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2372CC4320A
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CCC1D60F58
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CCC1D60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80E3D4B173;
	Tue, 17 Aug 2021 04:12:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ithqHzzC3kgu; Tue, 17 Aug 2021 04:12:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C4C4B198;
	Tue, 17 Aug 2021 04:12:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E3C4B160
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uR9lnLDDjwCR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:12:09 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92C624B14D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:00 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 p4-20020a5d59a4000000b00156992180dbso3978115wrr.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wCAlPucxwkxQDsZjrMwYYiCi5QbYeNWxBim5zrWnq2Y=;
 b=Aakqhp0ujPFBkz2t9XKF2sWAACl4G7B5hxJDrt2uXINVbL4SDQRXJFOegBUQ1cWZ/J
 0jUUeLw9Od7HUTBaHF2bEbcWHbDSiLs7WOuMmHvkgQ9aKAKEc1Se9jaIc0RdmvVOh0fO
 2EN/wB6tJc5Zuqxbzk63h/bmcGOdULfseyFm4sZABt1qcXnPvBSlGoCTvs5yVR6Y8Yo1
 YMuBWKj78N9MEBXEHK0yav34qJ6J/ferOrSpzyXe15duHhdaVH3IinJtQB7TmOXkIdhf
 EGOlFmuP1fTlBQFW97lGVUPjXY5ipiWvG/UMC6271totgCudngPKM0tiXwaU5gQ9KdQm
 5UzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wCAlPucxwkxQDsZjrMwYYiCi5QbYeNWxBim5zrWnq2Y=;
 b=KBenN3PKiW8DwOLkZhmYI2Qr+FClswOa/4IkFpLQT9hW16V8qxksUmklLJnuwbmu3E
 NRBUB7xizhcmaO5bRXJ24kPfnZrehc4MrspSS32dcIskCy9S8QRTe1IZYZRwF1EICezY
 2n2YLNQL6vnuzAac3re5tXSnDpN1mkIpTMaIS8d+iHzUzW9Mq1fM0ezjD8vyOLMMSP7V
 iXsU/ngtGPdAnmM/4dmbD5LB8/ocepem7oqZfJFRbWvgaWJCYInwrdxqoH94VAgE4UkY
 HKD0ErItswEAuaerI+f4SRjhayHo12RjNDhNOtfioCI3eTTloglWDiOJB2i2BFVdxx1y
 YamQ==
X-Gm-Message-State: AOAM532xZMYfeUCGQrtHNiq2bNezqdsFHhz4BZ/JcTAY5kJJcUXhpSV3
 ah+2lw8M7q0ZgdWoal3nLj1VA0OCdnEuEWUnFNEaWZZ7WFlP7ItwmdibX8IvSDzIzX/ZYtZqe44
 +Vfvb4/86hk5bW6S8EHIlvHOGGIu71xVG+001nyCEnzHKVG9hraLr9zRRP3mP1x1pmBA=
X-Google-Smtp-Source: ABdhPJyYTcbz4UVboGo7zKDmnSidrFF2RAjsx5lYf6M4UE4X0H/bCAlk0j+kiCGYLkR2pXqzSg2USK4ZwA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:c914:: with SMTP id
 f20mr2057147wmb.140.1629187919570; 
 Tue, 17 Aug 2021 01:11:59 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:30 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-12-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 11/15] KVM: arm64: Guest exit handlers for nVHE hyp
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Add an array of pointers to handlers for various trap reasons in
nVHE code.

The current code selects how to fixup a guest on exit based on a
series of if/else statements. Future patches will also require
different handling for guest exists. Create an array of handlers
to consolidate them.

No functional change intended as the array isn't populated yet.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 43 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 33 +++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be..5a2b89b96c67 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -409,6 +409,46 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
+
+static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
+{
+	return is_nvhe_hyp_code() ? kvm_get_nvhe_exit_handler(vcpu) : NULL;
+}
+
+/*
+ * Allow the hypervisor to handle the exit with an exit handler if it has one.
+ *
+ * Returns true if the hypervisor handled the exit, and control should go back
+ * to the guest, or false if it hasn't.
+ */
+static bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu)
+{
+	bool is_handled = false;
+	exit_handle_fn exit_handler = kvm_get_hyp_exit_handler(vcpu);
+
+	if (exit_handler) {
+		/*
+		 * There's limited vcpu context here since it's not synced yet.
+		 * Ensure that relevant vcpu context that might be used by the
+		 * exit_handler is in sync before it's called and if handled.
+		 */
+		*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
+		*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+
+		is_handled = exit_handler(vcpu);
+
+		if (is_handled) {
+			write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+			write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+		}
+	}
+
+	return is_handled;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -496,6 +536,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			goto guest;
 	}
 
+	/* Check if there's an exit handler and allow it to handle the exit. */
+	if (kvm_hyp_handle_exit(vcpu))
+		goto guest;
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 86f3d6482935..b7f25307a7b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -158,6 +158,39 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+static exit_handle_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= NULL,
+	[ESR_ELx_EC_CP15_64]		= NULL,
+	[ESR_ELx_EC_CP14_MR]		= NULL,
+	[ESR_ELx_EC_CP14_LS]		= NULL,
+	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_HVC32]		= NULL,
+	[ESR_ELx_EC_SMC32]		= NULL,
+	[ESR_ELx_EC_HVC64]		= NULL,
+	[ESR_ELx_EC_SMC64]		= NULL,
+	[ESR_ELx_EC_SYS64]		= NULL,
+	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_IABT_LOW]		= NULL,
+	[ESR_ELx_EC_DABT_LOW]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
+	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
+	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
+	[ESR_ELx_EC_BKPT32]		= NULL,
+	[ESR_ELx_EC_BRK64]		= NULL,
+	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_PAC]		= NULL,
+};
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
+
+	return hyp_exit_handlers[esr_ec];
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
