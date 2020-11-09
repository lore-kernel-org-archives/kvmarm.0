Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D440C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D92AA216C4
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="NGM9T7Cg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D92AA216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7795A4B4DF;
	Mon,  9 Nov 2020 06:33:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VDIyqY2tLwQL; Mon,  9 Nov 2020 06:33:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 700C24B720;
	Mon,  9 Nov 2020 06:33:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5C244B4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2xsq+k0Q9uCD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:17 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0FAB4B817
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:17 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id w24so5119745wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=STxT3I0oev0DTBptKuUq67e2wlovKGTClvKfrgZni/w=;
 b=NGM9T7CgfmsasqmbWaORXlR/xBoFk5aIVmGIzm/UQUh9KDC2NVnsXrzyALlYGiluq8
 GJgsNYDUOrP5L4fORcs8BdEIG+XBni3PtySqYnhjWsUPd4AvX+Y953HDbf1nsu261T88
 oXHv9mrV7U9q9w9sAcyCrHQsjIqCmhjXWjCzHgesmo1+PF4JxxIFaOeWSDOZvBJ89grs
 XoV6ePNuO77GLT2ml6GBIr4UIKtXyvvVJk0Gz86ScJn1KCXSMqOUx4LOCkqDWVqqVFjq
 KQAjw/Eyc7XiFLROohIV3JrVJSDETxRfdgdyGay/7tMMS7RRK+oMQAH5l4bWw/pR+5/w
 VyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=STxT3I0oev0DTBptKuUq67e2wlovKGTClvKfrgZni/w=;
 b=nfl+5UxlQQOmF/OUhx4Jik1dT/j4xHZMKg63UXO/G/VxpY0nWlZn2NUfpOOZxSTBoT
 b650qKpWYrMFWqahjOgMTV0PPf9/F+ivipzHYw1J3jX9vSy3s6K0Znt1cdl+88Evdi5f
 O0dKBHEqXqfr7yDsjBaz0X9mdDlnZ5agLDdK43s00xBbYn8p2JI9V8XPlLHB0Kc9A9be
 iyOzyhYP035M9zbni2/t25scGEnbmMxmwlOoeeXDrjIm6FeCAiQSWJCyRIzLPWk0aVYX
 sPT8tvm1Qnxobz/BxrIDjCS22aVbDA3xdTpxjTVq8PmqrL4lXXoP3/vfT3kWgnLcsA6r
 xkAg==
X-Gm-Message-State: AOAM533YJSryNuzVWI+iAvssRenpH25HgqUb9U2e0HDhVer7YfdY2kjT
 BPOFdFrG1g59SI6kIym9cI7vb+2n+ztEp3Xo
X-Google-Smtp-Source: ABdhPJxqqBns67atj2fda4ruhApA8uhNwaLMzwBAgerwaILtvzmidmLAUfyEIiuw6wHIFXtvfZHSGA==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr13871173wme.0.1604921596533; 
 Mon, 09 Nov 2020 03:33:16 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id b124sm12777961wmh.13.2020.11.09.03.33.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:15 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 18/24] kvm: arm64: Forward safe PSCI SMCs coming from host
Date: Mon,  9 Nov 2020 11:32:27 +0000
Message-Id: <20201109113233.9012-19-dbrazdil@google.com>
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
 arch/arm64/kvm/hyp/nvhe/psci.c | 43 +++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index 7510b9e174e9..05a34a152069 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -63,14 +63,51 @@ static bool is_psci_call(u64 func_id)
 		return is_psci_0_2_fn_call(func_id);
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
@@ -85,6 +122,10 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 		return ret;
 
 	switch (func_id) {
+	case PSCI_1_0_FN_PSCI_FEATURES:
+	case PSCI_1_0_FN_SET_SUSPEND_MODE:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		return psci_forward(host_ctxt);
 	default:
 		return PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
