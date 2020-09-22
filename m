Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EFFC4727E
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A1F22388B
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="mFQseQHn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A1F22388B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B504B0CC;
	Tue, 22 Sep 2020 16:49:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ulIiG1yeoObc; Tue, 22 Sep 2020 16:49:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C0A84B2FB;
	Tue, 22 Sep 2020 16:49:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB854B2EA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B8cWkWRKJfAc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:27 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C57DC4B0C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:25 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id j2so18575546wrx.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=6hcvsBW/48nsMmalbwHvD4T862f8LFuLjJBV7AYUfvw=;
 b=mFQseQHn1Y1I3BZ+gsig8Wge2enrtWQW8L4d3xY52w1u/7b/MicSVS1chXzMe60pUt
 7cfP9MMk1y3ySfPoSEf9iYVfjXFb75323j2HUWS3lnxJcQO63fjFCG9Bj1iQKVWC/dT7
 C5XccFHiFpc+ZvBAeuhB7fFz4dwX+Cz5I9Us7JuOM+B+9WY28UoASZiVfbWEPlM7bOPD
 lNitzqZc7PScdPOpNV9kV7r1AZzmuoXH81eoTvKUSbBkq1WEAIhWKU+Nl9q9SiX3zY7d
 QJQ0miOwvXT5L8czYaoiOBBSBGASZWmvtOAJ2xu6hZJxQmzA7ri9/3am9cHZRN5olSnl
 Z4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=6hcvsBW/48nsMmalbwHvD4T862f8LFuLjJBV7AYUfvw=;
 b=hwIk/SeSqSCSeIsTuf7aGxuwiTj6aE+pJbo0lfNtwrNgloRzr4qBbp0bCcusjP1drZ
 RI8SUkUK9miYpNVg7KOYiHTmoFDN4ZAqN/zxqscH4gEr30958Yc6uGmsrjUSEkG2QQOl
 GDVoviKuGSPKL5LoJqW40diVIxk3MTcCONdvOGovDmlScAKNf/cpZ89n+qIotuRi01bJ
 bzvroQ9eLbFyIU0VR8/EV3uIxC4kKMH8ZsXv5ar9+VKcJbA1lPtAOfrtckL1iqxP1v/P
 nRbpldHObEGPTPPW365LV/vQhm4i7xOt9U6bUR9tPHD80UMgzc131AfANw+irBubjtK8
 jY+w==
X-Gm-Message-State: AOAM531u/g3SXHbwbhyBgeGwPfgJ1/NmDydie232kLtY+Ol8x8uxzKlW
 afdM1yPIOG5E9ysiDjgG8iBtCvNOjnQ5DUBr
X-Google-Smtp-Source: ABdhPJypXlHocIl7dcK6uefDe0gktX3pkswpIUFjly01efgyFk2Y31JrNoQ5d2m6+d/Xvy8lZBSRkg==
X-Received: by 2002:adf:ec86:: with SMTP id z6mr7489780wrn.109.1600807764469; 
 Tue, 22 Sep 2020 13:49:24 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id m23sm5446145wmi.19.2020.09.22.13.49.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:23 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 07/10] kvm: arm64: Duplicate arm64_ssbd_callback_required
 for nVHE hyp
Date: Tue, 22 Sep 2020 21:49:07 +0100
Message-Id: <20200922204910.7265-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

Hyp keeps track of which cores require SSBD callback by accessing a
kernel-proper global variable. Create an nVHE symbol of the same name
and copy the value from kernel proper to nVHE as KVM is being enabled
on a core.

Done in preparation for separating percpu memory owned by kernel
proper and nVHE.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 14 +++++++++++++-
 arch/arm64/kernel/image-vars.h   |  1 -
 arch/arm64/kvm/arm.c             |  3 +++
 arch/arm64/kvm/hyp/nvhe/switch.c |  3 +++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 189839c3706a..e134c2ba2c5d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -529,6 +529,7 @@ static inline int kvm_map_vectors(void)
 
 #ifdef CONFIG_ARM64_SSBD
 DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
+DECLARE_KVM_NVHE_PER_CPU(u64, arm64_ssbd_callback_required);
 
 static inline int hyp_map_aux_data(void)
 {
@@ -537,18 +538,29 @@ static inline int hyp_map_aux_data(void)
 	for_each_possible_cpu(cpu) {
 		u64 *ptr;
 
-		ptr = per_cpu_ptr(&arm64_ssbd_callback_required, cpu);
+		ptr = per_cpu_ptr_nvhe_sym(arm64_ssbd_callback_required, cpu);
 		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
 		if (err)
 			return err;
 	}
 	return 0;
 }
+
+static inline void hyp_init_aux_data(void)
+{
+	u64 *ptr;
+
+	/* Copy arm64_ssbd_callback_required value from kernel to hyp. */
+	ptr = this_cpu_ptr_nvhe_sym(arm64_ssbd_callback_required);
+	*ptr = __this_cpu_read(arm64_ssbd_callback_required);
+}
 #else
 static inline int hyp_map_aux_data(void)
 {
 	return 0;
 }
+
+static inline void hyp_init_aux_data(void) {}
 #endif
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 76da2ad1010c..59d12a0b4622 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -67,7 +67,6 @@ KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 
 /* Global kernel state accessed by nVHE hyp code. */
-KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
 KVM_NVHE_ALIAS(kvm_host_data);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b588c3b5c2f0..76be11d31e5d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1298,6 +1298,9 @@ static void cpu_init_hyp_mode(void)
 	    arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE) {
 		kvm_call_hyp_nvhe(__kvm_enable_ssbs);
 	}
+
+	/* Copy information whether SSBD callback is required to hyp. */
+	hyp_init_aux_data();
 }
 
 static void cpu_hyp_reset(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index cc4f8e790fb3..4662df6330d7 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -27,6 +27,9 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+/* Non-VHE copy of the kernel symbol. */
+DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
