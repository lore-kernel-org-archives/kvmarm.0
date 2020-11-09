Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD5BC4741F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A80D722202
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="IR/8H2d8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A80D722202
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0DC4B779;
	Mon,  9 Nov 2020 06:33:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mDMpbqFbRJ+n; Mon,  9 Nov 2020 06:33:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7E54B86B;
	Mon,  9 Nov 2020 06:33:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 651DC4B771
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vf1V2t2GwlHv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:14 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9F634B4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:13 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id l1so3907738wrb.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=zE87N7EsES3H9YbKeZT+RN+vHxj9ggaErIqWx8Fn12A=;
 b=IR/8H2d81k7uevbNNSG8f/6BB011ytztZEahIYOtxTG9ucZzbuCQnUQot12tY6naDL
 CYEz2nEOTBd1pg78nTX5Bo3o8X2jpF1Y/laLGLB/+T19f0ePw9rH9CK2gvkp6wlxghcC
 +R9Cfs1KftNnc9neG+mL20Ve32bKpvhvphb6EEVU2KmByKUjwAKj0/qG1QfAl51UpOKS
 YBrUUbXRXp6Z8nxY1xNbE5T2eA47j3vYo9mnfT4QatLCSCvtxKdkbm1r5cg1uH/OuaAq
 +Y6ZVo1P2kz/eSWjrHyDv2g+8xFZ8vlPcc6XsD4qvRxLaWD6YSgsOAQxwwEtDuxkpiBk
 AvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=zE87N7EsES3H9YbKeZT+RN+vHxj9ggaErIqWx8Fn12A=;
 b=H6GAlkGu9xAZqDIIEmSFDi8kjskQi6cs7sjuapR1KVpFjO1jM+Njg/0EF9A2FwJ4a1
 3lwtxH+dyFixNPuMlLht7nTglXK173t0LeJyitAlBUnwcCl3LMerPhlqQtCW8tFbSP1n
 DQD50kZsSozWkjoanX50GcKzxOD+mf2ej63lRjoFRsG5a74+d1K+M57AGlMNLu5GPwUJ
 rhCB5gVbNlbnsHlpD2u25rs4SB09u/9I/FLxTysjDyC3Q9ZPFyWLZwOCLAm1/GpIsLSw
 fhT0v3qXioUGGCJksTVrSpXt4r9yuLBzw3KNhftXA4CEbyscJuFGer770ghviGazDywq
 Op6Q==
X-Gm-Message-State: AOAM5320p0aVMX/ZAOHMEe8xgwG3/TBYipO0NMzW3C78L61JzFG9bH5/
 lC3N7bWUnOcqJgf2Xlz/40HajYDI4U7iQUq3
X-Google-Smtp-Source: ABdhPJygQl8gljX5JecTMhmc7uSQ5Wg3Z2Y3ZSIC8AlADfKYvAhejYRCr2+E2yqGtTe2lcwndhvUWw==
X-Received: by 2002:a5d:6ca6:: with SMTP id a6mr17359352wra.348.1604921592643; 
 Mon, 09 Nov 2020 03:33:12 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id d2sm12885131wrq.34.2020.11.09.03.33.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:11 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 16/24] kvm: arm64: Add offset for hyp VA <-> PA conversion
Date: Mon,  9 Nov 2020 11:32:25 +0000
Message-Id: <20201109113233.9012-17-dbrazdil@google.com>
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

Add a host-initialized constant to KVM nVHE hyp code for converting
between EL2 linear map virtual addresses and physical addresses.
Also add `__hyp_pa` macro that performs the conversion.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c           | 15 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/psci.c |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 28e3bc056225..dc7d43d7785a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1484,6 +1484,20 @@ static inline void hyp_cpu_pm_exit(void)
 }
 #endif
 
+static void init_hyp_physvirt_offset(void)
+{
+	extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
+	unsigned long kern_vaddr, hyp_vaddr, paddr;
+
+	/* Check that kvm_arm_hyp_percpu_base has been set. */
+	BUG_ON(kvm_arm_hyp_percpu_base[0] == 0);
+
+	kern_vaddr = kvm_arm_hyp_percpu_base[0];
+	hyp_vaddr = kern_hyp_va(kern_vaddr);
+	paddr = __pa(kern_vaddr);
+	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)paddr - (s64)hyp_vaddr;
+}
+
 static void init_cpu_logical_map(void)
 {
 	extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
@@ -1688,6 +1702,7 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	init_hyp_physvirt_offset();
 	init_cpu_logical_map();
 	init_psci();
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index 82d3b2c89658..b0b5df590ba5 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -16,6 +16,9 @@
 /* Config options set by the host. */
 u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
 u32 kvm_host_psci_function_id[PSCI_FN_MAX];
+s64 hyp_physvirt_offset;
+
+#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
