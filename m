Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372DFC56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5B3421D46
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="G+ViC3wP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5B3421D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20D5F4C0A4;
	Thu, 26 Nov 2020 10:55:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dcgjlOyYIB8m; Thu, 26 Nov 2020 10:55:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 018C54C092;
	Thu, 26 Nov 2020 10:55:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A9E4C092
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dc65aSW6YCg5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:00 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 085D54B9FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:00 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id t4so2615008wrr.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=irDOCaoxBC7rYFpDng3539rKfl5EDMRei9R6iacpt5Q=;
 b=G+ViC3wP1aisQEqSrtFyh4agtf+XRj/S5yCOQSPP+B9cEpF3CEG6DUz/bfIazuPr44
 ziINsQardil0WvZ7VvAzP+ViHc8X/aDnyhZgkBWKaSicVgTkjL4koXMMvnWUKwj6Tubf
 yy+Yx/hK3LwwE2ezmO7wOtcTtG/OXrSJrdAmCkUrUTDGlG25Xz7C8mTrmfItIjst/2Po
 ItFdY9jyph4RS42NCu18FEzXe2QYDp7fg8a3lGHm5/Bq0J2aPx0WhjJGBCWrdIlkvbXW
 PRBJQEM/Aw0vr3SF+JCrYwHFypXblFfnJAf0xiWqOkWB+uG+6muEhHq41S+AwQVN50o4
 /3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=irDOCaoxBC7rYFpDng3539rKfl5EDMRei9R6iacpt5Q=;
 b=MxEH+Xt/ZPtNNlU2lNJrWSZhO2G6rVcIg/4ByEdJKyTjbRi4ZyU8ynSIrt8XZHtnXh
 AF/QYDUHs9IfOy0x6mO3VlQm4ijN0dxN/DsQeFPA6s53EBBnfSIRYTQGnwOQd2k0CUg2
 sPWt1SnOS7Z7CgEDUeu7/UMArbkiTUgJ1ZW7x6M2kVhpOthxpWQZZoQQOG2uc//YYgrv
 67FLpj1QsS0p9+iGkazbEd2jHFqS4n2hNM7GRj8xMsMMYgDP5Z+utTLbYC0mU+kz9+q6
 dvhfQrBaut6K3yfX4IETNqjodNdsNpdp0F4hy9V2VBwTsyIBITKxfUaQyx/pK2+fndc/
 fL4g==
X-Gm-Message-State: AOAM530nV5zBcHMZ/ZNVwVID2wryqhyt2zMUFoIZUKuBXxOkvJnP25Mk
 BUbpuseEsHAr2M9sEnivST/99VlvqKehvb/0
X-Google-Smtp-Source: ABdhPJy4MBFMpR4y7kRf/sEF0i4eAr3+bsyd1csD1SmT3e7E9ub9c+2WpUvSX9zSC44QRHTnVEfgpQ==
X-Received: by 2002:adf:f102:: with SMTP id r2mr4652297wro.315.1606406098667; 
 Thu, 26 Nov 2020 07:54:58 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id 35sm9328533wro.71.2020.11.26.07.54.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:57 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 15/23] kvm: arm64: Add offset for hyp VA <-> PA conversion
Date: Thu, 26 Nov 2020 15:54:13 +0000
Message-Id: <20201126155421.14901-16-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
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

Add a host-initialized constant to KVM nVHE hyp code for converting
between EL2 linear map virtual addresses and physical addresses.
Also add `__hyp_pa` macro that performs the conversion.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
 arch/arm64/kvm/va_layout.c           | 30 +++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 44a9fb462d24..e7091d89f0fc 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -18,6 +18,9 @@
 /* Config options set by the host. */
 u32 __ro_after_init kvm_host_psci_version;
 u32 __ro_after_init kvm_host_psci_function_id[PSCI_FN_MAX];
+s64 __ro_after_init hyp_physvirt_offset;
+
+#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 4130b72e6891..d8cc51bd60bf 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -23,6 +23,30 @@ static u8 tag_lsb;
 static u64 tag_val;
 static u64 va_mask;
 
+/*
+ * Compute HYP VA by using the same computation as kern_hyp_va().
+ */
+static u64 __early_kern_hyp_va(u64 addr)
+{
+	addr &= va_mask;
+	addr |= tag_val << tag_lsb;
+	return addr;
+}
+
+/*
+ * Store a hyp VA <-> PA offset into a hyp-owned variable.
+ */
+static void init_hyp_physvirt_offset(void)
+{
+	extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
+	u64 kern_va, hyp_va;
+
+	/* Compute the offset from the hyp VA and PA of a random symbol. */
+	kern_va = (u64)kvm_ksym_ref(__hyp_text_start);
+	hyp_va = __early_kern_hyp_va(kern_va);
+	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)__pa(kern_va) - (s64)hyp_va;
+}
+
 /*
  * We want to generate a hyp VA with the following format (with V ==
  * vabits_actual):
@@ -54,6 +78,8 @@ __init void kvm_compute_layout(void)
 		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
 	}
 	tag_val >>= tag_lsb;
+
+	init_hyp_physvirt_offset();
 }
 
 static u32 compute_instruction(int n, u32 rd, u32 rn)
@@ -146,9 +172,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 	/*
 	 * Compute HYP VA by using the same computation as kern_hyp_va()
 	 */
-	addr = (uintptr_t)kvm_ksym_ref(__kvm_hyp_vector);
-	addr &= va_mask;
-	addr |= tag_val << tag_lsb;
+	addr = __early_kern_hyp_va((u64)kvm_ksym_ref(__kvm_hyp_vector));
 
 	/* Use PC[10:7] to branch to the same vector in KVM */
 	addr |= ((u64)origptr & GENMASK_ULL(10, 7));
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
