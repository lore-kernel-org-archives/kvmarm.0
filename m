Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC413C6369E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C88E2067C
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="hv2R5Zu/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C88E2067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C16D74B606;
	Wed,  4 Nov 2020 13:37:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lSRBSHwhh8rv; Wed,  4 Nov 2020 13:37:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CCCC4B798;
	Wed,  4 Nov 2020 13:37:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DC214B768
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QI-hmC0GxM2b for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:05 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FF364B7CB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:05 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id n15so23206782wrq.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=nKgIpHjS/zdI3tb1vXzwoiiNM/jjodo8Otz1dws/lFM=;
 b=hv2R5Zu/z6mSOSF7dEe47i7r5T2cQPVysT7HoseP6g1eSaz6nNutmQSMgNBOdCt8eb
 PBT+5ilqIWofeWIil70QAAfQ++jMMGIDYwQCqScBeSD6s1/xacLom1Lg7Y6fr07ETPLc
 T5oVlB+HcrdVLb2F6SrnRwFCeUH9eLTNlKI8QXPxO6kK7HuFF6bgPtuTH+9dGZYRnmHe
 uXqrakMk7K/yAkrJV315umztyia9WU0yS91B2aTAWtmZ3Vxtl5rRie/Z8nLO2muqf32T
 +md4szIJBymJW9d9MDCf+3bjNANk8thtWZ0W8yjJnHGaSBHiCNp86qmYoNJNVZIuipRO
 Tl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=nKgIpHjS/zdI3tb1vXzwoiiNM/jjodo8Otz1dws/lFM=;
 b=VhcVz5pJK/fufFHwKkJ5/5CMlvy3Iu4hnn40u3cuUrs2mqAUF8M8V4vahDaJyOLji/
 USoVQAH2BlP0vsQZ1Cikh1WH6CvEu9d45Kc/+yeXfnWipKEtAUQePmZ3RNnnu3F5y3bj
 TL4Zk3I05CtNASrHGerStuqPYMywirSAr0xGGwwzsVYeLOpIezVaDRBEAsu3mRMMruQ8
 buwcNobFUR5rlmobqum0Q0A9LxW/jlhM0MiWIw9Uvwj4BPE+Pd4tl9ppTeaJi/RyLwd2
 PpHyPE7fMU+gfQysXsy2IG/OL5FirsAoxIg7hkbna1t6KkGo5NvnxOy9uRgOCijOmyL5
 Budg==
X-Gm-Message-State: AOAM532YxM25yOHoWofaXZ4GxJAwQQ6voY8adppGoa6b+ANULb5Yd2p6
 FlFr/xp2MzkQo8MK7erIMG36UsIQydF14B0J
X-Google-Smtp-Source: ABdhPJw7mLZKqMBluuUKvkKmIlrqh8pTnCd64tbISLpXPLgmZa+Ae3kp7ph+K6q6eNWevcaZKm0Gcw==
X-Received: by 2002:a5d:5387:: with SMTP id d7mr33257971wrv.224.1604515023950; 
 Wed, 04 Nov 2020 10:37:03 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id t11sm3428092wmf.35.2020.11.04.10.37.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:02 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 12/26] kvm: arm64: Add SMC handler in nVHE EL2
Date: Wed,  4 Nov 2020 18:36:16 +0000
Message-Id: <20201104183630.27513-13-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
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

Add handler of host SMCs in KVM nVHE trap handler. Forward all SMCs to
EL3 and propagate the result back to EL1. This is done in preparation
for validating host SMCs.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 36 ++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 19332c20fcde..fffc2dc09a1f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -106,6 +106,38 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	host_ctxt->regs.regs[1] = ret;
 }
 
+static void skip_host_instruction(void)
+{
+	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
+}
+
+static void forward_host_smc(struct kvm_cpu_context *host_ctxt)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(host_ctxt->regs.regs[0], host_ctxt->regs.regs[1],
+			  host_ctxt->regs.regs[2], host_ctxt->regs.regs[3],
+			  host_ctxt->regs.regs[4], host_ctxt->regs.regs[5],
+			  host_ctxt->regs.regs[6], host_ctxt->regs.regs[7],
+			  &res);
+	host_ctxt->regs.regs[0] = res.a0;
+	host_ctxt->regs.regs[1] = res.a1;
+	host_ctxt->regs.regs[2] = res.a2;
+	host_ctxt->regs.regs[3] = res.a3;
+}
+
+static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
+{
+	/*
+	 * Unlike HVC, the return address of an SMC is the instruction's PC.
+	 * Move the return address past the instruction.
+	 */
+	skip_host_instruction();
+
+	/* Forward SMC not handled in EL2 to EL3. */
+	forward_host_smc(host_ctxt);
+}
+
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
@@ -114,6 +146,10 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_HVC64:
 		handle_host_hcall(host_ctxt);
 		break;
+	case ESR_ELx_EC_SMC32:
+	case ESR_ELx_EC_SMC64:
+		handle_host_smc(host_ctxt);
+		break;
 	default:
 		hyp_panic();
 	}
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
