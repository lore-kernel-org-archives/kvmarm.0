Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC88BC83014
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2313422249
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2313422249
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE52F4B420;
	Wed,  2 Dec 2020 13:42:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oO6hA1K9soVx; Wed,  2 Dec 2020 13:42:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8A74B38C;
	Wed,  2 Dec 2020 13:42:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB304B409
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T2Zf1YnFDCK6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:20 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA71A4B16B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:20 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id e25so11135620wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=FBH6HEW5NPUtTsYV4IlYky2BDGVGm12SrN30lN4PkFY=;
 b=GwirdQYpnGgq1EVsJzAuWcQcbP11n6x036yOyPPx1vuGLdUpAEBFHj+LcFwdzYyxw+
 T8lnqGlHicu8lC1OG+9o9owM1KpTEfxKieiZO+v648VwSXWHshhhM5L5mcoUnNJoGpgP
 JF9LDYFE971ZkAyI4UJiC9Wj2Xc8p3fiDo1tCV+m8q7oGRHw7LI+kmLYVPoNtx23niwN
 DKnFEZdky5kwe4pgwVbOEWZKaUBtyvs+ZR+1j/PIZVxPLVLSf3X2PlsluY9qutX26LPO
 CoDv2JHfB182QCETZ+fYEDp3BzS+9YTS+Cpc2qSLa7FqP4K3kA3VJYq5HemX3PVOurbw
 WfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=FBH6HEW5NPUtTsYV4IlYky2BDGVGm12SrN30lN4PkFY=;
 b=UD8AXOG68UsIa4eRCQzos9TuYSkUu/Ac/bprerEmgG3FNsvke6y/MXUOUoyf5O21eQ
 YvyGi7L6auDu5ohVv/dDIn+XY2r5jqlmFqYacZH80PwJWIQBsOm9gjR3ricXa06rw1A7
 Q4PG46M5pZAjmIFIMvIXCcLm/g53Y0g5u9ZPfHYlQ4d5aK9yFcC7ru4rojL2Q7Pu/JBk
 u8eO0uOlgUracnCzXEQ8wa8zank5K5Fcwh/uHcVmqKS/cXq8jM4UstX2by/SWmtdD1l5
 T0OfsvjxBCEYEm6exMu7qamJQ+IEkHOb9Nm7yg8lESC63MDxT+U9Y9eISAdFWoaAxIBf
 vdSA==
X-Gm-Message-State: AOAM530zfkZ3B3/qSEVw8+vtbGroURbWiCHeeAbNFBqlhW1/YH0RCJ8z
 xA5ImCHpRKlVdv4A9nmySxr5DtSzWnNWfw==
X-Google-Smtp-Source: ABdhPJxcoHouQF9MWhIcY2M29LL8SVnxKTEFmpQkXa7h00mrGlfxwPNATVEGfGu2v86fKDMdyLCvLQ==
X-Received: by 2002:a1c:a402:: with SMTP id n2mr4626696wme.185.1606934539318; 
 Wed, 02 Dec 2020 10:42:19 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id x9sm3176873wru.55.2020.12.02.10.42.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:18 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 23/26] kvm: arm64: Intercept host's SYSTEM_SUSPEND PSCI SMCs
Date: Wed,  2 Dec 2020 18:41:19 +0000
Message-Id: <20201202184122.26046-24-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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

Add a handler of SYSTEM_SUSPEND host PSCI SMCs. The semantics are
equivalent to CPU_SUSPEND, typically called on the last online CPU.
Reuse the same entry point and boot args struct as CPU_SUSPEND.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 0853f62b052b..a2e251547625 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -151,7 +151,7 @@ SYM_CODE_START(kvm_hyp_cpu_entry)
 SYM_CODE_END(kvm_hyp_cpu_entry)
 
 /*
- * PSCI CPU_SUSPEND entry point
+ * PSCI CPU_SUSPEND / SYSTEM_SUSPEND entry point
  *
  * x0: struct kvm_nvhe_init_params PA
  */
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 688cf7f40d42..08dc9de69314 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -201,6 +201,30 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 			 __hyp_pa(init_params));
 }
 
+static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned long, pc, host_ctxt, 1);
+	DECLARE_REG(unsigned long, r0, host_ctxt, 2);
+
+	struct psci_boot_args *boot_args;
+	struct kvm_nvhe_init_params *init_params;
+
+	boot_args = this_cpu_ptr(hyp_symbol_addr(suspend_args));
+	init_params = this_cpu_ptr(hyp_symbol_addr(kvm_init_params));
+
+	/*
+	 * No need to acquire a lock before writing to boot_args because a core
+	 * can only suspend itself. Racy CPU_ON calls use a separate struct.
+	 */
+	boot_args->pc = pc;
+	boot_args->r0 = r0;
+
+	/* Will only return on error. */
+	return psci_call(func_id,
+			 __hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_resume)),
+			 __hyp_pa(init_params), 0);
+}
+
 asmlinkage void __noreturn kvm_host_psci_cpu_entry(bool is_cpu_on)
 {
 	struct psci_boot_args *boot_args;
@@ -265,6 +289,8 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_1_0_FN_SET_SUSPEND_MODE:
 	case PSCI_1_1_FN64_SYSTEM_RESET2:
 		return psci_forward(host_ctxt);
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+		return psci_system_suspend(func_id, host_ctxt);
 	default:
 		return psci_0_2_handler(func_id, host_ctxt);
 	}
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
