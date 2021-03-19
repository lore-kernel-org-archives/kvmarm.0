Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CEDC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:01:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6714964F73
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6714964F73
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 040484B600;
	Fri, 19 Mar 2021 06:01:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pxPDGL4inYOI; Fri, 19 Mar 2021 06:01:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC1B14B669;
	Fri, 19 Mar 2021 06:01:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C0E34B60C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:01:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wAaoizK0pnjI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:01:55 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CDC84B669
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:01:55 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id p12so18987791wrn.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QCiwKULDYqVgexkGV6Dq4fSAHDULaRDXCu3D8lkxqPg=;
 b=YsykdfHMlrALCZI0j/lFF8X23+hN+Zu3fDiK1ID85DnPouGtnQLEmewg79JgR6rjVF
 kPU/iYhzhmpW8dg5GxiWf5NEbaAPjywICzQZOnlcn+pOldrRNy48XFX5MPV3IPrAXBSn
 9qtwV0D9x9ZsilM3McX3RcpvJdUARTU8n08E5gu7j+N1u52VviYAWxhBVM1+gtr7z/Ow
 NyFvxEPGlX3fblHkO0JxtGDo+SUSPEVzgjWiR6bmEERmFVqlWBhtgJG18fTfo66C8BOR
 9kK9G7CoQRoNzALus8imZsx/9855keRRGBrUso/WZ+1cKQz7/UsVIHBlcuFkJV1Rdlwe
 RDgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QCiwKULDYqVgexkGV6Dq4fSAHDULaRDXCu3D8lkxqPg=;
 b=JXQqUcVCpUqS8F08BTKROoUoJ539tOK2eQsWs40P4Hv33bItzs6mGhd4cJYkAqFBGy
 Sdo3JM09vGSAufFR225ma/ieFyRSTUTqmao2acHp6Vb9dIN9adST3SDXUg95N43U63ZI
 PkvicFqlgqSf+kGZReCX45i0OgqfVGMehi6Bga8K09SeOgYQQF2wwoVltdfWtaFzX7iq
 xJZ8lVSdmQ34QOZ6YU/6DdLUdTbve8vfbjrYrWg5HLfCtbDUi2A6mDU4gH9y7ZnhXG6N
 JpfyyN8/RXK2R0LcQYzhTxQhLDVaIhjjsP+wE+gykkL/xFjunpxeGWLZLlZMQ+W72abk
 A/gg==
X-Gm-Message-State: AOAM531VpPP9koME6e+3s17YjPbI6I47HfXwwgsT0IhSgKi91/G81sme
 U6RgzH6BKS87ftoLEBScNlk74Etof7Ck
X-Google-Smtp-Source: ABdhPJynBItS8S3NsqD1ssoT1ZqH19/azGgDhWvgPMOcebHSNlUyhK+MNUoRziO27fIkmI2sqEz5Xbr29CO/
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:4f55:: with SMTP id
 m21mr2914524wmq.11.1616148114138; Fri, 19 Mar 2021 03:01:54 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:10 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-3-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 02/38] KVM: arm64: Link position-independent string
 routines into .hyp.text
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Will Deacon <will@kernel.org>

Pull clear_page(), copy_page(), memcpy() and memset() into the nVHE hyp
code and ensure that we always execute the '__pi_' entry point on the
offchance that it changes in future.

[ qperret: Commit title nits and added linker script alias ]

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/hyp_image.h |  3 +++
 arch/arm64/kernel/image-vars.h     | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index 737ded6b6d0d..78cd77990c9c 100644
--- a/arch/arm64/include/asm/hyp_image.h
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -56,6 +56,9 @@
  */
 #define KVM_NVHE_ALIAS(sym)	kvm_nvhe_sym(sym) = sym;
 
+/* Defines a linker script alias for KVM nVHE hyp symbols */
+#define KVM_NVHE_ALIAS_HYP(first, sec)	kvm_nvhe_sym(first) = kvm_nvhe_sym(sec);
+
 #endif /* LINKER_SCRIPT */
 
 #endif /* __ARM64_HYP_IMAGE_H__ */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 5aa9ed1e9ec6..4eb7a15c8b60 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -104,6 +104,17 @@ KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
 /* PMU available static key */
 KVM_NVHE_ALIAS(kvm_arm_pmu_available);
 
+/* Position-independent library routines */
+KVM_NVHE_ALIAS_HYP(clear_page, __pi_clear_page);
+KVM_NVHE_ALIAS_HYP(copy_page, __pi_copy_page);
+KVM_NVHE_ALIAS_HYP(memcpy, __pi_memcpy);
+KVM_NVHE_ALIAS_HYP(memset, __pi_memset);
+
+#ifdef CONFIG_KASAN
+KVM_NVHE_ALIAS_HYP(__memcpy, __pi_memcpy);
+KVM_NVHE_ALIAS_HYP(__memset, __pi_memset);
+#endif
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index a6707df4f6c0..bc98f8e3d1da 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -9,10 +9,14 @@ ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
 
+lib-objs := clear_page.o copy_page.o memcpy.o memset.o
+lib-objs := $(addprefix ../../../lib/, $(lib-objs))
+
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
+obj-y += $(lib-objs)
 
 ##
 ## Build rules for compiling nVHE hyp code
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
