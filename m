Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0216C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 746414B411;
	Thu, 19 May 2022 09:45:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UeL1t3YaPYgq; Thu, 19 May 2022 09:45:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3F34B432;
	Thu, 19 May 2022 09:45:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFAC24B3D4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2CxA5QDnNqFn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:41 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA56D4B415
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:41 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 05F41B824AF;
 Thu, 19 May 2022 13:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35805C385AA;
 Thu, 19 May 2022 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967939;
 bh=HFRJpgCE92vv/8Xgnf9OmEXUkv8UW/YItxgJ7HnU+bc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ps84NFP9x4Ubm9E1OtA0g8yrueW1XFv9aVFu70FM0t0nZ2gNSTEdiE/MTqoLE144+
 y6q8RYW3A1qiqSshj71BduHi7uz1tLUnAtG/3Z8Y5v4/yVCj6pIyFX8DbXyW+CXsLq
 0+7Lr7rTTsnFaISZPDvjVtEYWkqNKXjhBTYfgZxdhlVNp+HpdhSHqjRzG+ojnEgVeZ
 G2Vv+kvmejx9Fx39uwt7nqKLwpVaiLan6DRASOodof+sKnzjhSScEDHfj/2tuao08S
 i6zJ8qd0xpd5wDwScezFcFmld212A3c+RRqTvZvyj+maAheJKo/5Yb+znCuoIN0lPp
 RMC1X3rsc6mYA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 49/89] KVM: arm64: Add hyp per_cpu variable to track current
 physical cpu number
Date: Thu, 19 May 2022 14:41:24 +0100
Message-Id: <20220519134204.5379-50-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Hyp cannot trust the equivalent variable at the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h  | 3 +++
 arch/arm64/kvm/arm.c              | 4 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4adf7c2a77bd..e38869e88019 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -15,6 +15,9 @@
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_PER_CPU(int, hyp_cpu_number);
+
+#define hyp_smp_processor_id() (__this_cpu_read(hyp_cpu_number))
 
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 514519563976..3bb379f15c07 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -52,6 +52,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_KVM_NVHE_PER_CPU(int, hyp_cpu_number);
 
 static bool vgic_present;
 
@@ -1487,6 +1488,9 @@ static void cpu_prepare_hyp_mode(int cpu)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	unsigned long tcr;
+	int *hyp_cpu_number_ptr = per_cpu_ptr_nvhe_sym(hyp_cpu_number, cpu);
+
+	*hyp_cpu_number_ptr = cpu;
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 04d194583f1e..9fcb92abd0b5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -8,6 +8,8 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+DEFINE_PER_CPU(int, hyp_cpu_number);
+
 /*
  * nVHE copy of data structures tracking available CPU cores.
  * Only entries for CPUs that were online at KVM init are populated.
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
