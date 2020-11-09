Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F3AC4741F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8A9E20731
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OQc11lBo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8A9E20731
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 867E14B772;
	Mon,  9 Nov 2020 06:33:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FPnee3L-8SY3; Mon,  9 Nov 2020 06:33:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CF3F4B627;
	Mon,  9 Nov 2020 06:33:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA4A4B72B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFaf06vXESsN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:03 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C258F4B7E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:03 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id p19so5264212wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=LKrqV3xLA/ibeJM+AQCXY9IBi6Twfnl4kI7peR0SVVU=;
 b=OQc11lBoTR5fJLdx+W2P8jL214ocEiZbxcjChcEvDu+j2dkB9NsUrsMdFWRHDmee3D
 sYikdoR0rn5I+XINzOWJlUa5jGseeRnNVR8gfCsKBm4VUfReK9aFmu18nleZIGhQSzcq
 D68YQ0GXpLN6ipsxq+zdaVPhgTboJ4+FUJeb/M67GrzOMDLPVZcxDPi0fFbPdWeXmFrl
 hCTReFIEwsH5+p+JPg27Ma8hKvS3cDoYmhYKAFBpXZ9yuycea852h2+1pF7f6la98cXt
 wq5a4CtNC/F6NmihcNri6n2Nfcia3CNPUHmhxlM6YWwOI7QNr+5owVOn0ujXVRZi7D2n
 1QqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=LKrqV3xLA/ibeJM+AQCXY9IBi6Twfnl4kI7peR0SVVU=;
 b=Zm3mPNze/p+SDHsoO6l2DapidigngdTAuUZtAv2K6Is4NFpEdkR63xK6sM5x/50qU2
 aeEODBkvrRLXAMNPBIIyVXOTVZ++YkjjNJw7cHh9wMTzrevWxhmsChB5PanErkmrxIjp
 zNNrlEpP3xU3tNWDzZ6MXqpaHhNrmesmOm5AI9Jy5+pZzel3B11lssynfbfm4M4z1XCi
 TdfZI7eMilAxgL6wAHm60lsOsGHVa1ILy3FR/AMkHp+/UwLSh+DdHitgCo5Md7JeX25M
 FDZ/OwsRbl2dMayRKxA2dWYNptToFjaaSzxdjI4YHSyppehGXPigplSp6x9IoBGDfLlQ
 k5Ug==
X-Gm-Message-State: AOAM532lxLgXtSKsaQXnRVLA1HdLPn3wG2QVKIM0RFs1hMth7OLXg5kd
 oXumGf0dsn2Cbp4jD2O1nuTecI9awL076bYy
X-Google-Smtp-Source: ABdhPJzvaLtgbVxyZ2GDPcw/eFFKQNxLYoWLsP6DD3k4mKvCQB7oh0IBN8nQ6nLo0FuIJVxGVngrTA==
X-Received: by 2002:a7b:c20d:: with SMTP id x13mr13474111wmi.167.1604921582538; 
 Mon, 09 Nov 2020 03:33:02 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id t11sm12458783wmf.35.2020.11.09.03.33.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:01 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 11/24] kvm: arm64: Add SMC handler in nVHE EL2
Date: Mon,  9 Nov 2020 11:32:20 +0000
Message-Id: <20201109113233.9012-12-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
for validating host SMCs in KVM nVHE protected mode.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 35 ++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 19332c20fcde..8661bc7deaa9 100644
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
@@ -114,6 +146,9 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_HVC64:
 		handle_host_hcall(host_ctxt);
 		break;
+	case ESR_ELx_EC_SMC64:
+		handle_host_smc(host_ctxt);
+		break;
 	default:
 		hyp_panic();
 	}
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
