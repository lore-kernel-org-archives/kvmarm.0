Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6E9C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11F5822D57
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11F5822D57
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 915934B36D;
	Tue,  5 Jan 2021 13:06:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FMlHXPvDVEtv; Tue,  5 Jan 2021 13:06:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FEFA4B20F;
	Tue,  5 Jan 2021 13:06:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F29FA4B275
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 08NmYRNBG+Wb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:05:59 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7A934B35F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:05:58 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id r3so115466wrt.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=S3/rPCJUnMLfjD3b25qof1oX2WveJLOvFQJdod0fSPo=;
 b=Iwu0pUa0YSXjcvx3quDZYpB77l41vCMGRFORqWy3mdOa/tYLkPf0sYx8kmz5igXrc7
 EU4nEErd4MlRE7fB6nlJW5P0YzdkYZgSeU0/6oFYl1RkFEgd5P2jgpY0Bgyi1Fz0ZcM3
 DPF9ufE5GKcJX4cQ6HaVMXL+Cd41KOf50op+JJLWKpkUVUftEcZ5E0WpIhzQYaLFsGpZ
 hb0Xnie++//B0InrE4yYVNC/mCGpc7VnwmkMxk5lVpfIcEjuqfoc2E5yz/6UiMtwXJXV
 Aus9iwVc3FY9zZDo4Uyr9qzGwb0Afu4A/A9qUAxXw0wMoNQBbY9obdMD/rifda0qwk3k
 cJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=S3/rPCJUnMLfjD3b25qof1oX2WveJLOvFQJdod0fSPo=;
 b=cNPjS/9pOQPTgt97OzksGMrJ3n/unIBJnkF2/n/zLfpQHA1lUgU0EfuiWbk8cSV5U2
 W+rebxBukhBR9OSrL7dLyy1RakGQeg4v39T6OcyAocuEaPDoS/cphTNwA4azYTuGQLhc
 3U1wYfn8IyV2SayR+OKP4MglZYvl7qni8sfCC7zEFYJN/AmTCPLPFuPFuHWOjQNKjBug
 o9c6npdUOzM/ZbM7brYrv3K3LDgrTBgy9wZskKzCl5k9qDTZtfwjKUqO/6JGdBU7fG0t
 cZAigAk3qzhwV/O9qtFNfS5nDkn+uk+XtqaOv1p5U/hZNqLpzFG0WUt+Q2wiTfUfcBqN
 sktA==
X-Gm-Message-State: AOAM532XczsVVfXdnL3m/Hcvf1FiyW8OuQQ5/SrCyb8WM+jCMXu8f6Iu
 5UFeuKQ8CFQYUiNR6+5hwnmHH1pe4DAtSA==
X-Google-Smtp-Source: ABdhPJxc3qALx98DUhQZ7KCR6QZnBSsyO826Znz8Ic7DBsq+bseW6pwLsZMIeo64NXrlmnDKkKvMzQ==
X-Received: by 2002:adf:83a6:: with SMTP id 35mr751393wre.274.1609869957580;
 Tue, 05 Jan 2021 10:05:57 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id z3sm830263wrn.59.2021.01.05.10.05.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:05:56 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/8] KVM: arm64: Set up .hyp.rodata ELF section
Date: Tue,  5 Jan 2021 18:05:35 +0000
Message-Id: <20210105180541.65031-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

We will need to recognize pointers in .rodata specific to hyp, so
establish a .hyp.rodata ELF section. Merge it with the existing
.hyp.data..ro_after_init as they are treated the same at runtime.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/sections.h | 2 +-
 arch/arm64/kernel/vmlinux.lds.S   | 7 ++++---
 arch/arm64/kvm/arm.c              | 7 +++----
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S | 4 +++-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 8ff579361731..a6f3557d1ab2 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -11,7 +11,7 @@ extern char __alt_instructions[], __alt_instructions_end[];
 extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
-extern char __hyp_data_ro_after_init_start[], __hyp_data_ro_after_init_end[];
+extern char __hyp_rodata_start[], __hyp_rodata_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 4c0b0c89ad59..9672b54bba7c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -31,10 +31,11 @@ jiffies = jiffies_64;
 	__stop___kvm_ex_table = .;
 
 #define HYPERVISOR_DATA_SECTIONS				\
-	HYP_SECTION_NAME(.data..ro_after_init) : {		\
-		__hyp_data_ro_after_init_start = .;		\
+	HYP_SECTION_NAME(.rodata) : {				\
+		__hyp_rodata_start = .;				\
 		*(HYP_SECTION_NAME(.data..ro_after_init))	\
-		__hyp_data_ro_after_init_end = .;		\
+		*(HYP_SECTION_NAME(.rodata))			\
+		__hyp_rodata_end = .;				\
 	}
 
 #define HYPERVISOR_PERCPU_SECTION				\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04c44853b103..de1af4052780 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1749,11 +1749,10 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
-	err = create_hyp_mappings(kvm_ksym_ref(__hyp_data_ro_after_init_start),
-				  kvm_ksym_ref(__hyp_data_ro_after_init_end),
-				  PAGE_HYP_RO);
+	err = create_hyp_mappings(kvm_ksym_ref(__hyp_rodata_start),
+				  kvm_ksym_ref(__hyp_rodata_end), PAGE_HYP_RO);
 	if (err) {
-		kvm_err("Cannot map .hyp.data..ro_after_init section\n");
+		kvm_err("Cannot map .hyp.rodata section\n");
 		goto out_err;
 	}
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index 70ac48ccede7..cfdc59b4329b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -14,6 +14,9 @@
 SECTIONS {
 	HYP_SECTION(.idmap.text)
 	HYP_SECTION(.text)
+	HYP_SECTION(.data..ro_after_init)
+	HYP_SECTION(.rodata)
+
 	/*
 	 * .hyp..data..percpu needs to be page aligned to maintain the same
 	 * alignment for when linking into vmlinux.
@@ -22,5 +25,4 @@ SECTIONS {
 	HYP_SECTION_NAME(.data..percpu) : {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
-	HYP_SECTION(.data..ro_after_init)
 }
-- 
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
