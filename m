Return-Path: <SRS0=mTyv=AV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815BAC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 09:58:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35AFD2078D
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 09:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="c7Ddxyfb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35AFD2078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5CA04B14E;
	Fri, 10 Jul 2020 05:58:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ab3Gsk4hdOfy; Fri, 10 Jul 2020 05:58:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1704B153;
	Fri, 10 Jul 2020 05:58:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112C64B131
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 05:58:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q5ozkR5HQNsL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2020 05:58:26 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28F9E4B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 05:58:26 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id e4so3766332qtd.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 02:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OEvDCs6GxZh5HWA6VucXyfZNanV+chx77kwyKvJ7Fac=;
 b=c7Ddxyfb8361YbE8pib2PJaWk1eYRhB4e5UxS8eYWOvTperlqC8v5k2MQVoPugz711
 PngYAqExuG0b5yueaQQuo2FOw+O8K9/HMS2la2DF1CVgN8mNaAN1Y/L6rPf3uY9rvIc2
 zNwQdL1oLIW+jpn74ySBOM9guPRacJHKuPDcg5WYwhlovx/F/6PP4D22y0SzOAoJiSai
 gO2WPAzHgpzBALV/JbvkQ9ofI2GqQaRyQ5JhT0fF3Q6taVvGzBajrq1JzPJviyxhn5Jh
 nyapGodRaGFVBhCG8TSV60gL9pzXnaDnxGv0zpuwIJlPY8LkQE0ey9YCvI5jl+Fgdg7U
 ZKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OEvDCs6GxZh5HWA6VucXyfZNanV+chx77kwyKvJ7Fac=;
 b=XMAXSq+4J8d25e4bfP4wlkOXTpYP5anF386QeQHIC27fSQ7DRXW3SZapR3wpiZJpEE
 h1ledOjwIXOwGw1j2c9j/W3XuYJ64rjiKMcQYzw9OAr0jmWbLkYwM14dMepCPO60BtjT
 82qK1LJv4jVh49y6CWqxNAFTyCThxVsCyJgCVvzm9XpZ9q24n0NcaKBVQ+HZaRCm4gcl
 +rUj+Vrq/8Hvkcao+dtEjFlRnCFgVO+WhVOcz3ywp6IE1iiK3aCK/D4rukEyR6sbRPaa
 0fL2w84J4f+k4xmBd2ZIVrGcuq8TN24SnjGQLldXl9nof8fVhSSO80OQzcnttUIFAmkg
 h6MQ==
X-Gm-Message-State: AOAM533Cb1AYs1DX6B3OusRtA2hYYHPH5qCfyDMIXeeBA6c6z0nTl+97
 A1ZtN989mwrOZmJnjpICxp7GXfU5Z5aSgcjI8cDNpwyfiAK5WAdH9miLA0ayzAIxTuHSb49NZHW
 9KVvAPhixOGpJc1k9wo1qMuvnQhQVx3B1AoLxiun8ED3lOKOYHYpQp5GMxoDHrdGVnr6V9Q==
X-Google-Smtp-Source: ABdhPJxLIbB2qpgwoLAKYXYNiw0Cx3bIaSzY/GoHb5ln9V83Bnk4J5+MFv3ur8TMvDdViNuGLEaUDcVhqdc=
X-Received: by 2002:ad4:4f4b:: with SMTP id
 eu11mr55856119qvb.142.1594375105506; 
 Fri, 10 Jul 2020 02:58:25 -0700 (PDT)
Date: Fri, 10 Jul 2020 10:57:53 +0100
In-Reply-To: <20200710095754.3641976-1-ascull@google.com>
Message-Id: <20200710095754.3641976-2-ascull@google.com>
Mime-Version: 1.0
References: <20200710095754.3641976-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 1/2] KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates to the
 host
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com, dave.martin@arm.com
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

Move the clearing of KVM_ARM64_DEBUG_DIRTY from being one of the last
things hyp does before exiting to the host to being one of the first
things the host does after hyp exits.

This means the host always manages the state of the bit and hyp simply
respects that in the context switch.

No functional change.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h         | 2 +-
 arch/arm64/kvm/debug.c                    | 2 ++
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e1a32c0707bb..b06f24b5f443 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -404,7 +404,7 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
+#define KVM_ARM64_DEBUG_DIRTY		(1 << 0) /* vcpu is using debug */
 #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
 #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
 #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 7a7e425616b5..e9932618a362 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -209,6 +209,8 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_arm_clear_debug(vcpu->guest_debug);
 
+	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
+
 	if (vcpu->guest_debug) {
 		restore_guest_debug_regs(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 0297dc63988c..50ca5d048017 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -161,8 +161,6 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
-
-	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
