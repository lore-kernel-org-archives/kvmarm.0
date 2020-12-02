Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D542DC71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5018C22254
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5018C22254
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A4F4B42A;
	Wed,  2 Dec 2020 13:42:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FCiOv+2wE4p8; Wed,  2 Dec 2020 13:42:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C645A4B445;
	Wed,  2 Dec 2020 13:42:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6A84B40C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id emoHpw0G-DoR for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:09 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49AB64B420
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:09 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id h21so11167749wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=qcfRU1YbBQ04ItAE6mdwMxjNOIhFl6zoGdtG5ZWWz6Y=;
 b=FHW7OMVvnhhhri9l5Ifx4Rrqhfsw/iXEfWL3Xv//E79ZdV/UcgaVz/W0r2HYbZvqeY
 y2QPeIachgJaHG+rwCcgMXEco0yfQx0/re+sBTjr6jN3QPx9IhOX1g2yZimUEhTvMoB/
 YR/6959KrrBVEVUmE+JaqtY45Jz6vNkVJSyz3+1p5vk6xN23TYB9XpSQ6p2AiooWt88K
 LQ7b0Wm6T9rpwnxpjLpJSDo0mx7Ar0oSQOh22fxFpxsurRK+osX4w8raIkJoQ8iQkpKP
 91ESox4eJ95E+WzqyGdvdpGOKHRFxTm9LL8IJqFyGSLj03VMBv6+sx3rJ2bd1jSyLpuW
 stLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=qcfRU1YbBQ04ItAE6mdwMxjNOIhFl6zoGdtG5ZWWz6Y=;
 b=tHKqmV26bXQXzH8aB17N+HWEDCQMjTmkWg9wmlKUyBpGx82dJEN/mloG+ofY1ja7vJ
 f4WPWx0cQoCoTrVD5h5Xf9e77c/WTOD9kdj1yhI1imH8H3PBTzsLbY0dFnEzlbnNAxY4
 wLQ+LlmxUS6HB6B7Hv/RMuvhDgupWojlwhzgh4vccDqUYmhErj+zuKOjXvHpYkNPB8OV
 syb/UXfOVKD6YjDqxWtU1zRV6PWdYpOZlE7vEFsD4GF8Day+KxyDwIW4yK1h7l/xbj/O
 yoA6p8MszD+a8WP5X3OW+VRM1uOo84l7PiI8k8g7D61aWIi+C2++HL9mq5/4wB9rVRA0
 xmGQ==
X-Gm-Message-State: AOAM533hILpaSy/gOMsibuJlf87XzH0UG9mdWJ3ysNQ0dwBOsSaPcBYF
 oliTlR1kLm+DB9lunMefgKdSNyVIpaP0XQ==
X-Google-Smtp-Source: ABdhPJz/Y9ERJYjarEvm1qv0CECj56Dlnsv6FCiSdtWlW6kjM8WK1TRApQh5Lukq91apWPC5bp6dJg==
X-Received: by 2002:a1c:bd87:: with SMTP id n129mr4533586wmf.32.1606934527867; 
 Wed, 02 Dec 2020 10:42:07 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id n128sm3160473wmb.46.2020.12.02.10.42.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:06 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 18/26] kvm: arm64: Forward safe PSCI SMCs coming from host
Date: Wed,  2 Dec 2020 18:41:14 +0000
Message-Id: <20201202184122.26046-19-dbrazdil@google.com>
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
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 42 +++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 70b42f433449..5ad56a875ffa 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -54,14 +54,50 @@ static bool is_psci_call(u64 func_id)
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
+	return psci_call(cpu_reg(host_ctxt, 0), cpu_reg(host_ctxt, 1),
+			 cpu_reg(host_ctxt, 2), cpu_reg(host_ctxt, 3));
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
+	if ((func_id == kvm_host_psci_0_1_function_ids.cpu_off) ||
+	    (func_id == kvm_host_psci_0_1_function_ids.migrate))
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
@@ -70,6 +106,10 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
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
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
