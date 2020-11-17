Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E249C63777
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A789B2466D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="H5BJeQDN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A789B2466D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45EFD4B601;
	Tue, 17 Nov 2020 13:16:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XuoWbwxma-vp; Tue, 17 Nov 2020 13:16:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2D74B88E;
	Tue, 17 Nov 2020 13:16:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F42344B628
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VHES-NqdUwFp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:36 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F2914B601
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:36 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id h13so7924801wrr.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=ku0UFgVufHs9v1IJuu4Ni7X8qoCAXYV3NVQ1AKXoaAA=;
 b=H5BJeQDNLb++2xZvg4tH88cc0a517Nx1EBbTKeYIiv7k2xmQWwSp58eVZTiebUdyMG
 +g9ZeTElu3osA0nWOAV/aPjF1sobwPu1mjr/Dc4ZR36cFV5rLKkzslvkaXdW4CLYUChE
 nsu09uy4ADkg28f4TLlCpZGieLbT7PYoNhrfsiVb3HuoZcGEbh4XzBqyFM2bwNG3qIfY
 hH/rYe/JYRFiC/HTk4i7mRnSpAofJBPD+hamGi87aZT+MwV5MFfE4MgTO4nNxijcnPew
 C0S1hc2bUUhl2BBBC+fbW8SxHu46dT+sn/YDa0tekeckiqLhsPvIgfkzwciINYE0N9jK
 cxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ku0UFgVufHs9v1IJuu4Ni7X8qoCAXYV3NVQ1AKXoaAA=;
 b=kJ2YuXJgwW9R5/kb8WWxQ+2nEw3d+IWXRCTXRzCobl1uTF7I6eVa5crXNvX64d7hfz
 vSXHcztbXqOLKx8Uc+gbyFzLaOqXRTXMq3fv7ZFsNYliSKq4fNqrsk7qP5byL4OlSuKJ
 qcOgSerLY208eYd0fRiUDR7bDhS0H2oPih0G4dR0lQlX8TVmtyt1ijgQAWd1XPX/nEv6
 qfrjtsc4GVAP6zm32Yws5wRVsHZNwx2Ubx8+UrYN0jEOKEqg4ot5Ize6lJ0XXzmLZ1dE
 9MInAUaeyHiacfwIuxaSFSmGldes4IYboE2MhN5pRgmJZvvt+91YdtfUNcECp3HA9+pG
 bW9A==
X-Gm-Message-State: AOAM5316WZ4RPSZJcDZT1T+yhRfkkM4+Om9j/dg0jExYxnbrjSkUDTXw
 buHRQkjhzx4YkMHNRFfhMuB1lRQG0VZM
X-Google-Smtp-Source: ABdhPJxGgMTS1HY9eY7+MyhEXSMxE4MyyZGir1Tn8gNiQHb8pv7qDl59xEr1Ob0B7Wzc6Bbww1Gn9i2dBo1H
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a1c:398a:: with SMTP id
 g132mr368672wma.51.1605636995303; Tue, 17 Nov 2020 10:16:35 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:47 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-8-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 07/27] KVM: arm64: Introduce a BSS section for use at Hyp
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

Currently, the hyp code cannot make full use of a bss, as the kernel
section is mapped read-only.

While this mapping could simply be changed to read-write, it would
intermingle even more the hyp and kernel state than they currently are.
Instead, introduce a __hyp_bss section, that uses reserved pages, and
create the appropriate RW hyp mappings during KVM init.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   |  7 +++++++
 arch/arm64/kvm/arm.c              | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  1 +
 4 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 8ff579361731..f58cf493de16 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -12,6 +12,7 @@ extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
 extern char __hyp_data_ro_after_init_start[], __hyp_data_ro_after_init_end[];
+extern char __hyp_bss_start[], __hyp_bss_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 4382b5d0645d..ded78a25365d 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -8,6 +8,13 @@
 #define RO_EXCEPTION_TABLE_ALIGN	8
 #define RUNTIME_DISCARD_EXIT
 
+#define BSS_FIRST_SECTIONS				\
+	. = ALIGN(PAGE_SIZE);				\
+	__hyp_bss_start = .;				\
+	*(.hyp.bss)					\
+	. = ALIGN(PAGE_SIZE);				\
+	__hyp_bss_end = .;
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
 #include <asm/hyp_image.h>
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7335eb4fb0bd..882eb383bd75 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1709,7 +1709,18 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
+	/*
+	 * .hyp.bss is placed at the beginning of the .bss section, so map that
+	 * part RW, and the rest RO as the hyp shouldn't be touching it.
+	 */
 	err = create_hyp_mappings(kvm_ksym_ref(__bss_start),
+				  kvm_ksym_ref(__hyp_bss_end), PAGE_HYP);
+	if (err) {
+		kvm_err("Cannot map hyp bss section: %d\n", err);
+		goto out_err;
+	}
+
+	err = create_hyp_mappings(kvm_ksym_ref(__hyp_bss_end),
 				  kvm_ksym_ref(__bss_stop), PAGE_HYP_RO);
 	if (err) {
 		kvm_err("Cannot map bss section\n");
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index 5d76ff2ba63e..dc281d90063e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -17,4 +17,5 @@ SECTIONS {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
 	HYP_SECTION(.data..ro_after_init)
+	HYP_SECTION(.bss)
 }
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
