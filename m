Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2F3C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17D69206D5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17D69206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7D064B40C;
	Wed,  2 Dec 2020 13:42:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wMZ9uxtwmBct; Wed,  2 Dec 2020 13:42:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82A24B43C;
	Wed,  2 Dec 2020 13:42:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A843F4B379
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xJa0fkpZn7hs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:07 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00FEF4B333
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:06 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id t4so5092060wrr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=W2F3XgDMqEgOItGdCRM5+AsTSkKoSbLe12YGzB/3TvE=;
 b=fU9dMZnq0EEXms7M3KvnzCm8EKKrnGSW67qY+oR7f4a8sd6WG8ahqSKv+9LlTdMSv2
 jPe+fM5u1XEChj2kBxLARa7kuONgbg6lySnEtqRvYhT3y/ZQNe8Vpk02CPBXQ0Ky2OfZ
 Nmy443RidccsbP8jBYjOpNgfHtiwMlp36a1VkRy/wv0RNzVhHX3Qz1dX4li5w/G2UpQn
 T8PisBjeSEdzFR5SyxZRQh03Qb1evvCEEEKzTsu2SwLWr46cK0sYnIZvGoNdrH0WGbVV
 N+ScKSKwGwqQKkTet61ZGVYg0yBgffmTTSfbaJT7iZfAAwXkPZmhHwPeClI4FYJ0oRJP
 KbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=W2F3XgDMqEgOItGdCRM5+AsTSkKoSbLe12YGzB/3TvE=;
 b=MEaQOYG4Y1pR8CNpWdxwtNYZeL8NaCCL+KHmIoizlpHAW76j8HnCjrw8Xd99rDthkI
 wy2ODfMDpp3SxSNrGPuWbWKtmOhDS0EIJoVqDRd9pf67wecy4Jcq+DWeZGXXHf+MaUaK
 bHYeRW/g1S/CqB+YcmWGOsXlMrHM6JLiY0gjG3sbu2ZhFUGIbjl/FBOGaWNaiRZliyJn
 1JMKd2uZfDTz7+m6fJuJG38snT6kp7HQyVjw+ddlvFUGC/+f4TTXnWF9wWJoDNyD/B/K
 VuOMTwRjQsAc49MbljyRsqVYzYgTulrPBk0XNg7u2CkykGDbqu5YyQvtrFlh5Kr6DLGE
 N0Fw==
X-Gm-Message-State: AOAM532oxqxK033bXhm7r4ULVilNGU/93+mb2RL2sldEtwCK8SqghuNW
 CjkLAvEYm6WrPGQVt+qPk74X25gFD9SpUQ==
X-Google-Smtp-Source: ABdhPJxAfhDIldOi3vjK9bjU3teuSjjSL+9tOaDk90A1iO8lPe93m43qHEcAwCAxAn2GJH7EkOTR/Q==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr5063389wre.78.1606934525638; 
 Wed, 02 Dec 2020 10:42:05 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id d9sm2453926wrs.26.2020.12.02.10.42.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:04 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 17/26] kvm: arm64: Add offset for hyp VA <-> PA conversion
Date: Wed,  2 Dec 2020 18:41:13 +0000
Message-Id: <20201202184122.26046-18-dbrazdil@google.com>
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

Add a host-initialized constant to KVM nVHE hyp code for converting
between EL2 linear map virtual addresses and physical addresses.
Also add `__hyp_pa` macro that performs the conversion.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
 arch/arm64/kvm/va_layout.c           | 30 +++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 61375d4571c2..70b42f433449 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -18,6 +18,9 @@
 /* Config options set by the host. */
 __ro_after_init u32 kvm_host_psci_version;
 __ro_after_init struct psci_0_1_function_ids kvm_host_psci_0_1_function_ids;
+__ro_after_init s64 hyp_physvirt_offset;
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
