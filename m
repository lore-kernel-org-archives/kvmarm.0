Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15864C56201
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C014208FE
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="dKdv3AFV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C014208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1398C4B761;
	Mon,  9 Nov 2020 06:33:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7EoyNmEaCOGY; Mon,  9 Nov 2020 06:33:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50C44B834;
	Mon,  9 Nov 2020 06:33:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25CB64B8B5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iRODAIlW-1QM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:25 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8E8E4B843
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:23 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id o15so470874wru.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=p42rRkCPYWoJ8F/zuYYtS8myDLEcghdypmEMJwmGPuM=;
 b=dKdv3AFVKNz2TvbhuhQkVsFgrhEhdWpmA59RmYXb77rE0FCbJb/j5vpMfMW43tImW7
 nwhBJx0rjj5/lc2OcC5nwslciSR0hKuNAZr2T72xTUwkIclTmg564tL3F31GwRFhKPR7
 Itxsk2XYH/HTOdKO4Q27CV0q+y4uGbSCoG071/20ox9dRRYOm0g8Iwvlhie2sKdvUFw4
 +5Ok5Sj7CoWCGK9NJIONc4pfJZrnObcg3Wupi7pVmeXf0F/fwx2p3/XAbWIuOtk972jW
 Tg6kgBygp+akhSDRD4/0L7CUDrp61OUjLbHuI/WEu6Mj7vh5QYBq4UYeumYwqZmeIHS1
 4ovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=p42rRkCPYWoJ8F/zuYYtS8myDLEcghdypmEMJwmGPuM=;
 b=slknNAk1KhG3nl0whd1EQza9Ap+ShEIqDPVvTIreSqZ4UjUM9XvwllD0M4aLVsZKib
 cvqVQqxZf2UxVGg/I/xSE0NLGhlUhiwq9EuJigxfEkGIs3c+RgyKuYb+LiUqAtd7sNm6
 PEhzoiwKHNk3DPO3MS+qxUVGIdRjE5+SGjLM6bS1O1j2KHeFzCLrUeouKGNnWj4ZbxMR
 CauF4aCavRu55WykraHZ+MZLE4HhozRIL50+SZxLoN4AyLFWU5Zhd9cByODaNGk0bqEF
 RCNms/uZb+maHjop9Wnmu1mVmRKFd06750Zt7QMiZ66tetlphOvG8eOKt92b2EwKu49t
 /hHA==
X-Gm-Message-State: AOAM530zkT2U3TuUNv6E221fcg54p2TjvEGnwtieYpVrHzShupW02EiE
 zzrqH39QjYjh+MLDEaoHGwf/1gXdxPo07/7O
X-Google-Smtp-Source: ABdhPJyxgdjvEUnFGKqjP6pt6kqP/0XM/at3rDogZRjLUzJLV7kTcwVriYMD+vgSsOaDAx+Ws5AFWw==
X-Received: by 2002:a5d:4ec4:: with SMTP id s4mr3533343wrv.31.1604921602589;
 Mon, 09 Nov 2020 03:33:22 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id s202sm12526094wme.39.2020.11.09.03.33.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:21 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 21/24] kvm: arm64: Add kvm-arm.protected early kernel
 parameter
Date: Mon,  9 Nov 2020 11:32:30 +0000
Message-Id: <20201109113233.9012-22-dbrazdil@google.com>
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

Add an early parameter that allows users to opt into protected KVM mode
when using the nVHE hypervisor. In this mode, guest state will be kept
private from the host. This will primarily involve enabling stage-2
address translation for the host, restricting DMA to host memory, and
filtering host SMCs.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/virt.h |  9 +++++++++
 arch/arm64/kvm/arm.c          | 23 ++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 6069be50baf9..2c3124512c00 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -65,6 +65,8 @@ extern u32 __boot_cpu_mode[2];
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
 void __hyp_reset_vectors(void);
 
+DECLARE_STATIC_KEY_FALSE(kvm_protected_mode);
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
@@ -97,6 +99,13 @@ static __always_inline bool has_vhe(void)
 		return cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN);
 }
 
+static __always_inline bool is_kvm_protected_mode(void)
+{
+	return IS_ENABLED(CONFIG_KVM) &&
+	       (is_nvhe_hyp_code() || !is_kernel_in_hyp_mode()) &&
+	       static_branch_likely(&kvm_protected_mode);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* ! __ASM__VIRT_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a931253ebb61..452a01afaf33 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,8 @@
 __asm__(".arch_extension	virt");
 #endif
 
+DEFINE_STATIC_KEY_FALSE(kvm_protected_mode);
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
@@ -1796,6 +1798,11 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	if (in_hyp_mode && static_branch_unlikely(&kvm_protected_mode)) {
+		kvm_pr_unimpl("VHE protected mode unsupported, not initializing\n");
+		return -ENODEV;
+	}
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
@@ -1827,7 +1834,9 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
-	if (in_hyp_mode)
+	if (is_kvm_protected_mode())
+		kvm_info("Protected nVHE mode initialized successfully\n");
+	else if (in_hyp_mode)
 		kvm_info("VHE mode initialized successfully\n");
 	else
 		kvm_info("Hyp mode initialized successfully\n");
@@ -1848,6 +1857,18 @@ void kvm_arch_exit(void)
 	kvm_perf_teardown();
 }
 
+static int __init early_kvm_protected_cfg(char *buf)
+{
+	bool val;
+	int err;
+
+	err = strtobool(buf, &val);
+	if (!err && val)
+		static_branch_enable(&kvm_protected_mode);
+	return err;
+}
+early_param("kvm-arm.protected", early_kvm_protected_cfg);
+
 static int arm_init(void)
 {
 	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
