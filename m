Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87AAC4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6180B2223D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="m5ieAtIS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6180B2223D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D748B4C1EF;
	Mon, 16 Nov 2020 15:43:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SlKIVrLQPl6N; Mon, 16 Nov 2020 15:43:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A61E4C262;
	Mon, 16 Nov 2020 15:43:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93CA74C24E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h8u5MOjQ2VVY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:43 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D0F34C226
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:43 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id m125so578299wmm.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=/xSxQ6wMrJch4MkdpKs1AkVDK65s53fUsfBxRtXSdJ0=;
 b=m5ieAtISL0bm/LUKttamwfLlzhs+j8pVtTzSWO66zpxkqSyqcI9qGCjmMZEITUAsRh
 yqdiGq+w6rI0GCGo50z0jh68U/2ypSU/r5sGtiGWJw2pmO5VyM0KMM0SeNdtc5WgZzsM
 hirMis8efojxuO/J5IlkDJ+y9wXS3qa/89kQ2mq7YV6N570irqpYEX257aEHd/E/wn5A
 v7VtE91FuEp2YqQTS9U57cMquhdQFIHh9s21Z+didm2rlYVIGVYX5gAtB31/xEBm/fTe
 5F49guosSVTnCZftqO+UK+EX3tg5d0FaLtNe7b9IcgkySeAZDQRoqZnRIiBAutOTssIs
 cSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=/xSxQ6wMrJch4MkdpKs1AkVDK65s53fUsfBxRtXSdJ0=;
 b=YKnOgJl40JLMVVpHe/alFeMuBR3MV+o8/16ctbVDtneaxMaf3gFM+YnJ1nWRjrXh8J
 DVWXkhxhoYqbhDJp16HJ6G0D2YoPsQIdMQpowUYPYm0rp3dehLk0KJ2fNkgWsontX+LC
 XrtaxTKxaPzKM4R65xiRuAI+t2A6IQntIBTOYNRSbWFa/5LqP0ZINqL1xp1cBs6aH502
 oJAxFCAtGpirPRaJEoaDIWRLAxAOZScSLsiRhrDgKK9UcHJQesX9ORR67VUqyQdSIRAg
 wWUxAXWPdKlrSB/Hf8e+ya5DKKo7pqrIptmLd1AeSBndGv6v0re0FuTsMSPQahC7VdEZ
 EbUg==
X-Gm-Message-State: AOAM531QGYU5dZbSMWSeBzCWPKXZGuJlOZFRahN1ad0Qr5e8Z+zx2g+W
 5IUmBgXyO0nC/XpNK7m6Wnk7uHi9GHuvXBUQfbc=
X-Google-Smtp-Source: ABdhPJyS/aNgHssSQvEMalBMF7PxZKqg/8avV0om5DEzGM0leU4FRM/z71yVKcNzG/Z5aqFD0OtZdA==
X-Received: by 2002:a1c:44d4:: with SMTP id r203mr743633wma.60.1605559422223; 
 Mon, 16 Nov 2020 12:43:42 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id i10sm24457621wrs.22.2020.11.16.12.43.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:41 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 09/24] kvm: arm64: Add .hyp.data..ro_after_init ELF section
Date: Mon, 16 Nov 2020 20:43:03 +0000
Message-Id: <20201116204318.63987-10-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
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

Add rules for renaming the .data..ro_after_init ELF section in KVM nVHE
object files to .hyp.data..ro_after_init, linking it into the kernel
and mapping it in hyp at runtime.

The section is RW to the host, then mapped RO in hyp. The expectation is
that the host populates the variables in the section and they are never
changed by hyp afterwards.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++++++
 arch/arm64/kvm/arm.c              |  8 ++++++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  1 +
 4 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 3994169985ef..8ff579361731 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -11,6 +11,7 @@ extern char __alt_instructions[], __alt_instructions_end[];
 extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
+extern char __hyp_data_ro_after_init_start[], __hyp_data_ro_after_init_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 1bda604f4c70..4382b5d0645d 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -30,6 +30,13 @@ jiffies = jiffies_64;
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
 
+#define HYPERVISOR_DATA_SECTIONS				\
+	HYP_SECTION_NAME(.data..ro_after_init) : {		\
+		__hyp_data_ro_after_init_start = .;		\
+		*(HYP_SECTION_NAME(.data..ro_after_init))	\
+		__hyp_data_ro_after_init_end = .;		\
+	}
+
 #define HYPERVISOR_PERCPU_SECTION				\
 	. = ALIGN(PAGE_SIZE);					\
 	HYP_SECTION_NAME(.data..percpu) : {			\
@@ -37,6 +44,7 @@ jiffies = jiffies_64;
 	}
 #else /* CONFIG_KVM */
 #define HYPERVISOR_EXTABLE
+#define HYPERVISOR_DATA_SECTIONS
 #define HYPERVISOR_PERCPU_SECTION
 #endif
 
@@ -234,6 +242,8 @@ SECTIONS
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
 
+	HYPERVISOR_DATA_SECTIONS
+
 	/*
 	 * Data written with the MMU off but read with the MMU on requires
 	 * cache lines to be invalidated, discarding up to a Cache Writeback
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4838556920fb..97af6c285f84 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1620,6 +1620,14 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
+	err = create_hyp_mappings(kvm_ksym_ref(__hyp_data_ro_after_init_start),
+				  kvm_ksym_ref(__hyp_data_ro_after_init_end),
+				  PAGE_HYP_RO);
+	if (err) {
+		kvm_err("Cannot map .hyp.data..ro_after_init section\n");
+		goto out_err;
+	}
+
 	err = create_hyp_mappings(kvm_ksym_ref(__start_rodata),
 				  kvm_ksym_ref(__end_rodata), PAGE_HYP_RO);
 	if (err) {
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index bb2d986ff696..5d76ff2ba63e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -16,4 +16,5 @@ SECTIONS {
 	HYP_SECTION_NAME(.data..percpu) : {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
+	HYP_SECTION(.data..ro_after_init)
 }
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
