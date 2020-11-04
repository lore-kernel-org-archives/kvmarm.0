Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF304C63699
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BED622228
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="phvU+aAR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BED622228
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE4BE4B7C8;
	Wed,  4 Nov 2020 13:37:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TtCN-Fx-IzAv; Wed,  4 Nov 2020 13:37:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A804B7B1;
	Wed,  4 Nov 2020 13:37:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378554B606
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cTINgTqKpJMj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:14 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A28354B6D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:13 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id s9so23140881wro.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ZVjVFozTLdMZo3Qj+qmHuuLudZQ2Vnjr88mC0h8KdNc=;
 b=phvU+aAR0cMr4PSwYP4GPkWz29rXwGC9l6/gUkgEjJ41OCA08ZcE+n1PJzNz0U9axl
 S4dpFjCDxAzjGzMRrsJKFU28M4gkHv2uhaxYBrgJHsUcuvE+VD3lfqcNB5TohC56+pK/
 yxLAWGHDqcd+ZySMPpb0Uc3ftPAUejRVMWEG281NsCzDDEqtT9MYem7+nqhqXqX7dAc/
 MjbJFmxejTtBit6tLHcNLX36y+YPsBGpwamh2dfQLuneXQx1Va1B+hY0xXr/c7obRIYC
 2yFJOmJFT8asy/4FASrFkHgHJ9WveV0lIgaATcylkuOr9Xn7oy5QE1FC6m2LVo7KbC5G
 b5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ZVjVFozTLdMZo3Qj+qmHuuLudZQ2Vnjr88mC0h8KdNc=;
 b=EmT89v5zPcRKMjqv9TzI7saIFo2GdY5aXJ5q888PvROD2y4EeNJon0kLCycsz7UBXO
 j6rQKBk5IJYiguRJhVjJilgd0xXio2+QpEMQVCq8PZlgvAkm9Yi+0yBnco6bcQuPQ/AN
 6vBKqcyZPdtASudhzR2aBym8DrocM6VxA0KxPdWuXiE7+8hzdqMGcbJcSu0zERR6VGyb
 9nvbDHUO6oXcnQPmglYH3i0a/l4b4bYNWrBCH7v2ejyZW8Po8CCXiJhpceyoplIl2Z/k
 jkTgUIo0IZK5EboZpfvnCLIlLuCRR/K/2whokoTpcJ6UGrBOwfE+lUujP+JpO+SwbOJG
 1PBg==
X-Gm-Message-State: AOAM533nb2c+GxZgV2n0AybHkfc0GMbY/HLHIrajdrpdkULR1AElS5M8
 o4Qn3wUePdCeKq7d/BemYm0e95GX5fo67tyM
X-Google-Smtp-Source: ABdhPJzSOg5ehTCfdQXoJjzXBCOHpK0Uzw56Ie6OCbSaHqF4Y4sxI4USadgIi3s6J90cFV5gmW4tkw==
X-Received: by 2002:adf:f245:: with SMTP id b5mr6282692wrp.389.1604515032310; 
 Wed, 04 Nov 2020 10:37:12 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id b14sm4016046wrx.35.2020.11.04.10.37.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:11 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 16/26] kvm: arm64: Add offset for hyp VA <-> PA conversion
Date: Wed,  4 Nov 2020 18:36:20 +0000
Message-Id: <20201104183630.27513-17-dbrazdil@google.com>
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

Add a host-initialized constant to KVM nVHE hyp code for converting
between EL2 linear map virtual addresses and physical addresses.
Also add `__hyp_pa` macro that performs the conversion.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c           | 15 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/psci.c |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cedec793da64..580d4a656a7b 100644
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
@@ -1686,6 +1700,7 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	init_hyp_physvirt_offset();
 	init_cpu_logical_map();
 	init_psci();
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index 8f779560ab6f..3eafcf48a29b 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -16,6 +16,9 @@
 /* Config options set by the host. */
 u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
 u32 kvm_host_psci_function_id[PSCI_FN_MAX];
+s64 hyp_physvirt_offset;
+
+#define __hyp_pa(x) ((phys_addr_t)(x) + hyp_physvirt_offset)
 
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
