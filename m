Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FBBC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D612F22AAA
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D612F22AAA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BA54B2C5;
	Wed,  9 Dec 2020 08:18:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GwCISHMW4CwC; Wed,  9 Dec 2020 08:18:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73B134B2D7;
	Wed,  9 Dec 2020 08:18:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC124B2D4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+XE+csCDCkH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:17:57 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0EA54B2F2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:57 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id 3so1639996wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=eC3dfrduk9N3bItne4Bt2OJ3xFC82tVD26IiWD/PAzc=;
 b=ZhdHHWTrxybOS3ckjtAmTjfzvZosyvpJGZcwcPadU5OeCIPFNwt1A3F29cIGChqQBi
 5+cQAEs0QKUeKAH+f6I3IbNBTY+dZ6M6X2DC4cxNXVKRlCLMUyoGV/iIJJQ++TGYt7cN
 HWQ+ttLyL29Ckl0l8dhFUEMOYLBhF9H7F62yggNGMq9+pE6vz7cxq3JDXBa2owu7dv4q
 Fek1uPRomzQ3VbhTcMdLcgYbIayHaX/zgPY0yjxJGjH8qB7QIFZfIrOdceHWn3ldY3Zg
 lbhHMVOb92NEJeoEnF/6sQXRszqVs+xGV8veUIdFoDvVQ0ts2N+ory1Vz2SwyYpZ+x2n
 csmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=eC3dfrduk9N3bItne4Bt2OJ3xFC82tVD26IiWD/PAzc=;
 b=I+o0/qTX8ZnzGYwqpp+NFkF31rH2PZcI/EIv3SRQ6rc2qkJg02xPi2+EZuwiDNG9GO
 0/QyVdb0Dm77FiMUgB1xvKlcinYe42bxehmhN/qHVF4vc2/HQtotOkUuQqs7atjjgFxW
 QbjAKmonmHSnFLkI9fbnUb6X7jVQLN7gXHKJQ1UJIIOzuHvneeRLRzRp3SyCKWgd6Yqs
 AAmv63qw9uThUZgpQbf89Wf7FWtnWKUPBlKDBsRkSlSsuLUr2Y/YOmc376ZPp0FvgHPC
 AVcB7Y38c0XuVxAdJnCA2sJfGTjOLTcrF7xJuHoEz3t3tFEYp37W2qM2R3B5f0+n1qwm
 ugSA==
X-Gm-Message-State: AOAM530Hm+siLZ5086gW6SPdfm4KdsuDPo2xmiNIyiQ6fJXfmO5a5IF3
 4mm5yIrQTnwvW1eJ0msLvUnhtp5UpcrrQg==
X-Google-Smtp-Source: ABdhPJyJlAdG9Q2cJj2wx1wE7lWFVUjh7hiYEXBuQsKX5NFis+JOymoWzsrCIbt9tGIBYhRtb6nAqw==
X-Received: by 2002:a1c:2c4:: with SMTP id 187mr2810150wmc.187.1607519876443; 
 Wed, 09 Dec 2020 05:17:56 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id d8sm3211263wrp.44.2020.12.09.05.17.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:17:55 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/9] KVM: arm64: Set up .hyp.rodata ELF section
Date: Wed,  9 Dec 2020 13:17:40 +0000
Message-Id: <20201209131746.85622-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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
index 43af13968dfd..f294f2048955 100644
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
index 6e637d2b4cfb..c244e57f9cd9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1745,11 +1745,10 @@ static int init_hyp_mode(void)
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
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
