Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B47C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD2622224B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="jgslmvmt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD2622224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60C294BF6A;
	Mon, 16 Nov 2020 15:43:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5ecVlmeyzw3c; Mon, 16 Nov 2020 15:43:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C144C260;
	Mon, 16 Nov 2020 15:43:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D4A4C280
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Bq93xUeMxxR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:54 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D3F34C276
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:54 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id j7so20272879wrp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=jBVm/LArO1AVdRcZ+q3L0QCd8OGhOWzJGyI1ZWbTM+k=;
 b=jgslmvmt8eyl07t0cwWGpbSH4YO9VXaPfVOOgDE4ZLJZdfxC1arFjcoVmUcA8bERW2
 LpjgCO2IomJfdN5wcTNCxzu6/ACvAMfzfYR1xDcg4JV+U7+/rACINJhLTnv+gQRMMAR9
 RlXzbFg91geSG4d9QWPIcsQaZNBXxpYjN0bCuwZ5BV9hehTkUFB6WcQUXfoai6so36ba
 yMn6V4g6VBYFjP3+86GJBswJ3YdqydvCyHRKvrjkBRwNOxyFTnJ62T9rZXoOuF8STe5D
 QYSvT0l3RZ3uwSF/C8Z3t696VxTLaxi7R84OUo8LqD1GgrIT4HEgDr9/yqhcYuVXiZsA
 mBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=jBVm/LArO1AVdRcZ+q3L0QCd8OGhOWzJGyI1ZWbTM+k=;
 b=HwvONMFrsfJZ4wvxj8S1Lqgc4dJf4quJanjqj9+X/ayR2A7Cw2VhAsNaF1SZhXVZl2
 IjSBx6HMZh6Hp5mxpg6qAL97aEKjagwAGKffvcsTyKhcL4W7ioS56jvknxuCAh//8O2N
 kaxaLMdvgOrtCsX33L0QpLBoPtP4e5Sa8Rw3ko1lV3ReJ2ZrcNFrNCahWZpvHmBqjKns
 3BjDs6K3Mr00p3nb1KWkuHupC+nobDSRHHiih8QgjSI2so5P7i441Ax+Nl97DRJons/v
 kHcfRQ+eLL2aokTAWlBrVLX1jktw6zb6Rnfuy1KXMvOGgFGlqs5lkqo9vAgZ/FfxHy80
 U9vg==
X-Gm-Message-State: AOAM531DSbb5nHVCvhCLajLlWBL9+ie8Uh7XOILpn4VOt20SC4R0fwS6
 aXmy/fbKSOLs0Jt/YU0EOuHNEaymHdoxAitmpdM=
X-Google-Smtp-Source: ABdhPJythO6pSCGfoIJ6apcHHCt92vwA+uoll4DlQLlq+cpg7CP8mgV1V4M4lg/fFUf6xY15WUHrSQ==
X-Received: by 2002:a5d:6688:: with SMTP id l8mr22511702wru.360.1605559432765; 
 Mon, 16 Nov 2020 12:43:52 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id 60sm21908566wrs.69.2020.11.16.12.43.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:51 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 14/24] kvm: arm64: Forward safe PSCI SMCs coming from host
Date: Mon, 16 Nov 2020 20:43:08 +0000
Message-Id: <20201116204318.63987-15-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
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

Forward the following PSCI SMCs issued by host to EL3 as they do not
require the hypervisor's intervention. This assumes that EL3 correctly
implements the PSCI specification.

Only function IDs implemented in Linux are included.

Where both 32-bit and 64-bit variants exist, it is assumed that the host
will always use the 64-bit variant.

 * SMCs that only return information about the system
   * PSCI_VERSION        - PSCI version implemented by EL3
   * PSCI_FEATURES       - optional features supported by EL3
   * AFFINITY_INFO       - power state of core/cluster
   * MIGRATE_INFO_TYPE   - whether Trusted OS can be migrated
   * MIGRATE_INFO_UP_CPU - resident core of Trusted OS
 * operations which do not affect the hypervisor
   * MIGRATE             - migrate Trusted OS to a different core
   * SET_SUSPEND_MODE    - toggle OS-initiated mode
 * system shutdown/reset
   * SYSTEM_OFF
   * SYSTEM_RESET
   * SYSTEM_RESET2

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 43 +++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 1583b63322c4..7542de8bd679 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -55,14 +55,51 @@ static bool is_psci_call(u64 func_id)
 	}
 }
 
+static unsigned long psci_call(unsigned long fn, unsigned long arg0,
+			       unsigned long arg1, unsigned long arg2)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(fn, arg0, arg1, arg2, &res);
+	return res.a0;
+}
+
+static unsigned long psci_forward(struct kvm_cpu_context *host_ctxt)
+{
+	return psci_call(host_ctxt->regs.regs[0], host_ctxt->regs.regs[1],
+			 host_ctxt->regs.regs[2], host_ctxt->regs.regs[3]);
+}
+
+static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *host_ctxt)
+{
+	psci_forward(host_ctxt);
+	hyp_panic(); /* unreachable */
+}
+
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	return PSCI_RET_NOT_SUPPORTED;
+	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
+		return psci_forward(host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_MIGRATE])
+		return psci_forward(host_ctxt);
+	else
+		return PSCI_RET_NOT_SUPPORTED;
 }
 
 static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	switch (func_id) {
+	case PSCI_0_2_FN_PSCI_VERSION:
+	case PSCI_0_2_FN_CPU_OFF:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_0_2_FN64_MIGRATE:
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+	case PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
+		return psci_forward(host_ctxt);
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+		psci_forward_noreturn(host_ctxt);
+		unreachable();
 	default:
 		return PSCI_RET_NOT_SUPPORTED;
 	}
@@ -71,6 +108,10 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	switch (func_id) {
+	case PSCI_1_0_FN_PSCI_FEATURES:
+	case PSCI_1_0_FN_SET_SUSPEND_MODE:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		return psci_forward(host_ctxt);
 	default:
 		return psci_0_2_handler(func_id, host_ctxt);
 	}
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
