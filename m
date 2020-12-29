Return-Path: <SRS0=Fui2=GB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD84C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 16:01:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87A3320825
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 16:01:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87A3320825
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4CDD4B115;
	Tue, 29 Dec 2020 11:01:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jo45vwLWiVWL; Tue, 29 Dec 2020 11:01:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A71E94B253;
	Tue, 29 Dec 2020 11:01:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1E34B250
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 11:01:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lpPS87tiz9IL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Dec 2020 11:01:23 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 948134B213
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 11:01:23 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id m5so15012222wrx.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 08:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=NtCljhLriYtvqTyh0Oi7f3SoeajHUSS/0DAzm3hIGXE=;
 b=Oz7Ml7QJVCMzwv2c3OvZUVS1nQR+4abLjG0AvTqtcYOBygQ3cV++dq2Q6H5LlAKrJT
 yiLsX9sMElJJfJRsPvDEaP+TbemQEMjDGRraLIfCVxGD+J1oRK5SOotiiGSBR1h+utFs
 k3pYH3lbVXXATfVz7oopjMSJzngGXuu/egoKdfuLkxzdA0cJVJK5H1HBZcheS6le/UX2
 bR7Wy/OEayCryx50CMsvlN8wahXfGjPH3yP5ucV7N9nK9AGU3X/DyctWqEyNDF6LCIEA
 4b7vbgmlTU4v2FSk5RCmiSPrrdDZY0nYjL0nBX3BHVA/0Xyyv+6JRgMuPGWQUtZ8JJrL
 yrYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=NtCljhLriYtvqTyh0Oi7f3SoeajHUSS/0DAzm3hIGXE=;
 b=s6MnFcfNwAymXZkhF1+Jl/EWhoMThaEgG+yyUbw9VBveHitnl59COf4vvcJxOuzDnk
 2XhnS+c293svtpktvh7NB8qrjK9QtF0ZuHWLxmCfCRtutGdBh7f1ZWj/0UmUbTkgkli2
 uIb9hs62Ic2OPc8wfYHLlhvRtUthe+M+tPFKBt2E03DCj13HOsUxkfaTUBciVxWUwP63
 R0Rb6tuQRV+gb6NQkOPR1Ymo7IcxZqzxlTQjbbXem0YBkP4uPmrnXrzQTbrfXO2TW6dh
 CwHqptpBWW0Vo7MbC/mbDlHnPFJdT83Ol5JRkDPABB/iI1wvxhmrwog5iEHMEcacO3wY
 y9rw==
X-Gm-Message-State: AOAM533Bu4Jsm2f7ZHxTk9AFsw5d29B4vlzinwYlEf7e2g+DGF77Gvt4
 KOoTUJZABVrHCevXf3dYBi8tYuUTqAr9AA==
X-Google-Smtp-Source: ABdhPJw9Ayoh9M0GtPyVtC0R8Y+dAZ8drQfvlYeo93ZmkqUpL9igbq4DREd39sZg1DlSlN4TeaAUKw==
X-Received: by 2002:adf:8290:: with SMTP id 16mr54668406wrc.27.1609257682161; 
 Tue, 29 Dec 2020 08:01:22 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:b0e4:997:fb3:e517])
 by smtp.gmail.com with ESMTPSA id l5sm61284118wrv.44.2020.12.29.08.01.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 29 Dec 2020 08:01:20 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return
Date: Tue, 29 Dec 2020 16:00:59 +0000
Message-Id: <20201229160059.64135-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

The KVM/arm64 PSCI relay assumes that SYSTEM_OFF and SYSTEM_RESET should
not return, as dictated by the PSCI spec. However, there is firmware out
there which breaks this assumption, leading to a hyp panic. Make KVM
more robust to broken firmware by allowing these to return.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index e3947846ffcb..8e7128cb7667 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -77,12 +77,6 @@ static unsigned long psci_forward(struct kvm_cpu_context *host_ctxt)
 			 cpu_reg(host_ctxt, 2), cpu_reg(host_ctxt, 3));
 }
 
-static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *host_ctxt)
-{
-	psci_forward(host_ctxt);
-	hyp_panic(); /* unreachable */
-}
-
 static unsigned int find_cpu_id(u64 mpidr)
 {
 	unsigned int i;
@@ -251,10 +245,13 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 	case PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
 		return psci_forward(host_ctxt);
+	/*
+	 * SYSTEM_OFF/RESET should not return according to the spec.
+	 * Allow it so as to stay robust to broken firmware.
+	 */
 	case PSCI_0_2_FN_SYSTEM_OFF:
 	case PSCI_0_2_FN_SYSTEM_RESET:
-		psci_forward_noreturn(host_ctxt);
-		unreachable();
+		return psci_forward(host_ctxt);
 	case PSCI_0_2_FN64_CPU_SUSPEND:
 		return psci_cpu_suspend(func_id, host_ctxt);
 	case PSCI_0_2_FN64_CPU_ON:
-- 
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
