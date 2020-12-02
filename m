Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1E3C71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B24522173E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B24522173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1E24B40C;
	Wed,  2 Dec 2020 13:42:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1rxtwGtySkJi; Wed,  2 Dec 2020 13:42:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EE9D4B429;
	Wed,  2 Dec 2020 13:42:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 131404B3CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PgyiuHxaWhbs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:01 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 009B24B41E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:59 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id c198so10180651wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=X0j+RCoYcy0kA4Cq9TKjA5cl6J4xllDB/E52Sl/VxFI=;
 b=QcreM1BcCNABhAl7u4JGwSWjJ6gL2zFtNGBBBem5Uz5LSqS20kZNu05BsIN3mdk4kM
 WmwSgASKeZZf1fSScVelU10Ou/l83oRqNvrWHtKxX57HtR13qLL5HHbTF514eIWpCpMw
 P0Gy3N3uhn3dqAOv+u3mta3p6YjahXlzn4T7tVKOibfRXgAJf13M/c2ftXFoqM3j22us
 ffeUS8vBSPDzcOIbAw+5y73xgPZdPgPtA07YEQoX6QjVhtaChsCatVOzVs9MuAzzNIpb
 ta4/8BaelML3og/7agjZt0z5OZIowiI5vG0V76o+ilQp/3DwYOPyCZFg562dd8fO3tG3
 ssSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=X0j+RCoYcy0kA4Cq9TKjA5cl6J4xllDB/E52Sl/VxFI=;
 b=t3UaJY1DkBVsBy2BM832iyyWjliVJo9XeatrpeX2vIAAiReOZL6I++iQV6+YViOveA
 ysAWixZ71DNfoGbxeU/ns7RrF6c4Va0fsplxP8izxG04ClqRsfga45uk4wyeVnnEUxCJ
 snW6upwbCxFr57c43x4BVYVIyL9o/scUzABPW+2yYK3cWipo1CF1wnEKxOfowLmPLkFd
 FG3Qiov33hukUJEqh2dQhuWEMNRwcW4nVxlzb2Thmpf/YLslo3vODAth6RhELCDZ57WK
 sUU5hJTbzpjK9kaOIz+/ZCIWDokrs66CDYQLxQkh9xWQiLP9OafLPmLe4zAO/kwh7KNH
 nacA==
X-Gm-Message-State: AOAM531dhDGDIVGDRcxFjIn5WJcvs6UldgLiCRoETzD52SPP2Xz3/CCr
 ABUgQ/KrTt+9kLzDFqQkGpo0LOTBNkOweQ==
X-Google-Smtp-Source: ABdhPJyPFPIxlkDq4z9qel4Mj/fLalo17OXktP8fnmZlxbaiN1V56nYRoNY5X1VLxACl0aApz+oOfw==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr4615447wmk.48.1606934518563;
 Wed, 02 Dec 2020 10:41:58 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id 35sm3086773wro.71.2020.12.02.10.41.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:57 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 14/26] kvm: arm64: Create nVHE copy of cpu_logical_map
Date: Wed,  2 Dec 2020 18:41:10 +0000
Message-Id: <20201202184122.26046-15-dbrazdil@google.com>
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

When KVM starts validating host's PSCI requests, it will need to map
MPIDR back to the CPU ID. To this end, copy cpu_logical_map into nVHE
hyp memory when KVM is initialized.

Only copy the information for CPUs that are online at the point of KVM
initialization so that KVM rejects CPUs whose features were not checked
against the finalized capabilities.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c              | 19 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 16 ++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 40857cbed3d1..09bb4098502b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -63,6 +63,8 @@ static bool vgic_present;
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -1584,6 +1586,20 @@ static inline void hyp_cpu_pm_exit(void)
 }
 #endif
 
+static void init_cpu_logical_map(void)
+{
+	unsigned int cpu;
+
+	/*
+	 * Copy the MPIDR <-> logical CPU ID mapping to hyp.
+	 * Only copy the set of online CPUs whose features have been chacked
+	 * against the finalized system capabilities. The hypervisor will not
+	 * allow any other CPUs from the `possible` set to boot.
+	 */
+	for_each_online_cpu(cpu)
+		kvm_nvhe_sym(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
+}
+
 static int init_common_resources(void)
 {
 	return kvm_set_ipa_limit();
@@ -1756,6 +1772,9 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	if (is_protected_kvm_enabled())
+		init_cpu_logical_map();
+
 	return 0;
 
 out_err:
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 7b0363b4857f..cbab0c6246e2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -8,6 +8,22 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+/*
+ * nVHE copy of data structures tracking available CPU cores.
+ * Only entries for CPUs that were online at KVM init are populated.
+ * Other CPUs should not be allowed to boot because their features were
+ * not checked against the finalized system capabilities.
+ */
+u64 __ro_after_init __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
+
+u64 cpu_logical_map(unsigned int cpu)
+{
+	if (cpu >= ARRAY_SIZE(__cpu_logical_map))
+		hyp_panic();
+
+	return __cpu_logical_map[cpu];
+}
+
 unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 {
 	unsigned long *cpu_base_array;
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
