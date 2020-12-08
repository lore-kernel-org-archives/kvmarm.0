Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D65C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E5FB23A69
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E5FB23A69
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 214334B2A9;
	Tue,  8 Dec 2020 09:25:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HQ8-xF+C7QXd; Tue,  8 Dec 2020 09:25:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671F94B2A4;
	Tue,  8 Dec 2020 09:25:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF04C4B2AF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZeQJD4tHA1mo for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 09:25:13 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB5A44B127
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:12 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id l9so7279694wrt.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 06:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=f8/kp02WsOtyuCy6HonxO8TbrW5eGuVLEWwGykCnj2I=;
 b=cYNQMxDujCmqPGMeSjB/5132Iwcyi91EYgI1F304AcQrUlHZKwrKFnxd5VYUmZe9K3
 qhfD9zstwz62Vgp0K320RLF7hLuvtr9nZDivEzCcR75CoOEA4hb3GFmeyES77O7KnMTF
 pAFnnE6967VFpJ/Fer47PSFKjnPHQQfe7mnE8sjmlVKr9apoDHds84eU2Nsa/WKlIBbn
 e+PddT+iFaoD3sljklf4jA3CdeJ4OWlAk0Nm10aXIftrVEcv1s96VvtC/zC6jeWwHJuO
 iIaowJGppOUfMxWaOtqumlHOPIktlTx+cXWMLrE/XMiCypkUNwIa2Z7JbNAXPdtn61gw
 lM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=f8/kp02WsOtyuCy6HonxO8TbrW5eGuVLEWwGykCnj2I=;
 b=HTnLXBPw1yvnmMmI+LcGiIdHU1i7o0haHy5dNDzjxGjQl6J+ZUXKhfWiPz9/GCVnFi
 s/OT95E5dk4eRiqQ2fIKjmtzAj2iER/peMMi0b/BILFSTlZrTuczGZ7GFbiFr/4LohVh
 Tc97QwvAH6R3pYW8P4CTwL+U973ReZAmU9AbkdHlP6WRKKZbrUD0H5ErJjYAzcM8r1Ri
 N8EGX2Lyu8zOHO4s/qqnZBUHfYWVZTgZlqudp3aCMJCIMD6qioCj7+CIFTTgCtv9Ho8d
 /Pwl6ukrLXRldqu4qmoPTec+akYm+i7BW1rLkdP/BOTsEaddOUzjyklXYITwbDNItBiX
 Zjwg==
X-Gm-Message-State: AOAM531MkNzrDucbI5ZnoIqseMC+m+CP+AnEZ+Jbyqw7+Qt/2XMrXeuR
 v2YevsleOl7pxYGnAz86HdaW+vVrxsJruQ==
X-Google-Smtp-Source: ABdhPJxMNnq/XmyKaQEfovB9gUn+Z+sXBgJfo586XxWEv01Ooqibpo3M5GZvW3EusOCR/yqN4TASEg==
X-Received: by 2002:a5d:69cf:: with SMTP id s15mr17334520wrw.372.1607437511630; 
 Tue, 08 Dec 2020 06:25:11 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id b200sm3963032wmb.10.2020.12.08.06.25.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Dec 2020 06:25:10 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 6/6] kvm: arm64: Move skip_host_instruction to adjust_pc.h
Date: Tue,  8 Dec 2020 14:24:52 +0000
Message-Id: <20201208142452.87237-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208142452.87237-1-dbrazdil@google.com>
References: <20201208142452.87237-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Move function for skipping host instruction in the host trap handler to
a header file containing analogical helpers for guests.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 12 ++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index b1f60923a8fe..61716359035d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -59,4 +59,13 @@ static inline void __adjust_pc(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Skip an instruction while host sysregs are live.
+ * Assumes host is always 64-bit.
+ */
+static inline void kvm_skip_host_instr(void)
+{
+	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
+}
+
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index bde658d51404..a906f9e2ff34 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -157,11 +157,6 @@ static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 	__kvm_hyp_host_forward_smc(host_ctxt);
 }
 
-static void skip_host_instruction(void)
-{
-	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
-}
-
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 {
 	bool handled;
@@ -170,11 +165,8 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	if (!handled)
 		default_host_smc_handler(host_ctxt);
 
-	/*
-	 * Unlike HVC, the return address of an SMC is the instruction's PC.
-	 * Move the return address past the instruction.
-	 */
-	skip_host_instruction();
+	/* SMC was trapped, move ELR past the current PC. */
+	kvm_skip_host_instr();
 }
 
 void handle_trap(struct kvm_cpu_context *host_ctxt)
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
