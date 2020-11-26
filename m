Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A041DC63798
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11A2621D7E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="jqLq4mvu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11A2621D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2B14C07A;
	Thu, 26 Nov 2020 10:54:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jQ4pzmPeRkS5; Thu, 26 Nov 2020 10:54:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92D0E4BA29;
	Thu, 26 Nov 2020 10:54:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4E134C08E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rYw6FoGx+666 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:54 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E0B54C0C9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:53 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id m6so2632375wrg.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=abHZKvAnOIOh0cfJUm3aASRkjBMLNkdSVRPPeTy9mxo=;
 b=jqLq4mvuFUHRNYTuDA8X4VqzR999IfDP4q84W39BYEKyBQxNgrPCGYrczkPYGhK3xu
 rAyOQQer3BhE9duh1aWdFCeG+6knjdw5TuROmYdg4HhznGrigbB06JqMnjAT7xfK+est
 C3hOyQ9Hz6DwLFMNdCGX7L+t1pUqK9ugYB0c9EsrTz5zLyPmstSDlVJslLskorCLfkLJ
 xnDwNLr1x8JteRXu7nG+IZYBSzTE8FzQbQlInhi+UOtUpSqxM/09so4wFxOqzOzG7W3k
 fMq1ulRSMT+FhtRSYbgZxKC8qiIf4rnRr+xoJ9PrqtwZUt/DvnRvDjiCJXDqxMKOdZfk
 IUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=abHZKvAnOIOh0cfJUm3aASRkjBMLNkdSVRPPeTy9mxo=;
 b=hgGXdWuf2jAFWsRfegHmwgaPwyIHnYSavAg7/YhhFitg+WVhBDe1WnrbsLjwGA3N69
 QdI08B6tQuRdgL9VoNBx6m2qRt2pDQEk9cOL73nt1cT61QyAjv3WmWZyzEd3cjX1Ju35
 QhmDC3XcJXEKnhR/Zfr8muKHr5CkFXL2mgRVFweec+Uv6aAFjO6iAHOSmNLMaFZP81ZY
 IQDt7DAltCn247eVsCSNmm5eUWJy++0lV05MsiNvM6WNGDysiGQiPp80zzRMfjRKoPmp
 ohiTs9hoy6Ru+pNP4wqf8sV/GdmowD7JqUSfwssBU5zGyLltvNKlqhyqGJKndUCaQ47u
 +l5A==
X-Gm-Message-State: AOAM532WG9rQsYKDeBmriBdHjU1PfJMJuqr4y0aOgUDF3xAvG1YSp0Nf
 B/ufVlCdScWqxzHFa8o6IWgHMx4mFfJYPQe6
X-Google-Smtp-Source: ABdhPJzBk1cgJvigLTBpzrkzyw93ozQjhaI8GSxKK42oABc32zYGurmL/AUO7+tHdNOzK5VOfFnjDw==
X-Received: by 2002:adf:dc83:: with SMTP id r3mr4498991wrj.223.1606406092266; 
 Thu, 26 Nov 2020 07:54:52 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id r13sm4193297wrm.25.2020.11.26.07.54.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:51 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 12/23] kvm: arm64: Create nVHE copy of cpu_logical_map
Date: Thu, 26 Nov 2020 15:54:10 +0000
Message-Id: <20201126155421.14901-13-dbrazdil@google.com>
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
index bb07f0401c68..bb3c541d3ddb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -61,6 +61,8 @@ static bool vgic_present;
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -1531,6 +1533,20 @@ static inline void hyp_cpu_pm_exit(void)
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
@@ -1703,6 +1719,9 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	if (is_protected_kvm_enabled())
+		init_cpu_logical_map();
+
 	return 0;
 
 out_err:
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index c168d86f885a..ceb427aabb91 100644
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
