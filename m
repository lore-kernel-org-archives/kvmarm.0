Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC8FC56202
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D17421527
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="pwS+yO9a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D17421527
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0E1C4B6D6;
	Wed,  4 Nov 2020 13:36:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Ogf6Stzdbtc; Wed,  4 Nov 2020 13:36:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A61FA4B7B9;
	Wed,  4 Nov 2020 13:36:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA014B7B8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xhofo1eyMrJm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:52 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 781AC4B6A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:52 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id d142so3349807wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=/4FeYdmn3iB0IXLNt/H1CXu0UQ9fwGLnFLDS+u9FzHI=;
 b=pwS+yO9awK8oUBpQAVkLJuj63BH/WHRSAh1203sKJMLPgu/Z7WrtlqDJagBVCYrBaf
 EOF4SKuIVhlxAqijYs3lo1YFAo8JMGNuT2vGkFPRX2iSDKwMvMACiSGWDwM6hRJ50W30
 rsJicMhiC6OYQ/2/CIUPbdAdRQpWJXMwejJYSsKhgwDaIDaZLSG1v9QGvqOLA1ErGg9d
 Iq0FStkmxGam8BquTREXKbmimi0koGzmcK9fr4eliQyQiNZJD/2xQZ2zt3TcJYss/+q2
 PU8oK7Fyq8/xDdNN+GYMONZ2wzMa7EPpgD5F7CCcwZhZwvFOGbR9o6UrjPcEJN2uVbhb
 VRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=/4FeYdmn3iB0IXLNt/H1CXu0UQ9fwGLnFLDS+u9FzHI=;
 b=Yro/f0oDDN42/IeUJb8dwjgKBCw3O2MSKhrLQ/RFuf5+gzR60O57m8DoaVEl3lIt0k
 3PVrdoc/C/z+nEI4gR+kgZemPx7l+iVOW7oPHoq8V4MKXNprUuw7Qo/tZ/EUVKTtFiOJ
 u2bA9tBNvBZGF0pV/uiwMTMhjLZAF4f1Azr1z7zTqPmrBbH8S1hx1/07UBojiARPt0Ut
 561jMlBuQ/aOVU6BZDnwz5SKHkyf4O8nvROm6+FiSVa5r1si2JLXDBuXxF1x4GnUkAlD
 2XWf7nh4eKyBeCQDTVso8zrNBKLsCEUiCsHjPzdUoPcbRjKRY1Pr0T8Vv+1N74u6f5CE
 ky9A==
X-Gm-Message-State: AOAM531XcOvijx1lfKTw7atXRw/zWKG4BMFD/bG9pzlO5SE4AK3FWCyp
 WQaFxVXHcVUbKnxlJI7qpYttI4e6kTpirHHU
X-Google-Smtp-Source: ABdhPJx/hiCAz8Legoa47eblx4WAapjkBFpTOjmMETdF/oVexGY9XgUxpPgGgIkrhHQJMAw0LEe2bA==
X-Received: by 2002:a05:600c:4147:: with SMTP id
 h7mr5966082wmm.186.1604515011165; 
 Wed, 04 Nov 2020 10:36:51 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id e25sm4070787wra.71.2020.11.04.10.36.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:50 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 06/26] kvm: arm64: Add .hyp.data ELF section
Date: Wed,  4 Nov 2020 18:36:10 +0000
Message-Id: <20201104183630.27513-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
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

Add rules for renaming a .data ELF section in KVM nVHE object files to
.hyp.data, linking it into the kernel and mapping it in hyp at runtime.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++++++
 arch/arm64/kvm/arm.c              |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  3 +++
 4 files changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 3994169985ef..255f76f592d7 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -11,6 +11,7 @@ extern char __alt_instructions[], __alt_instructions_end[];
 extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
+extern char __hyp_data_start[], __hyp_data_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 1bda604f4c70..a9a1612c084f 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -30,6 +30,13 @@ jiffies = jiffies_64;
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
 
+#define HYPERVISOR_DATA_SECTION					\
+	HYP_SECTION_NAME(.data) : {				\
+		__hyp_data_start = .;				\
+		*(HYP_SECTION_NAME(.data))			\
+		__hyp_data_end = .;				\
+	}
+
 #define HYPERVISOR_PERCPU_SECTION				\
 	. = ALIGN(PAGE_SIZE);					\
 	HYP_SECTION_NAME(.data..percpu) : {			\
@@ -37,6 +44,7 @@ jiffies = jiffies_64;
 	}
 #else /* CONFIG_KVM */
 #define HYPERVISOR_EXTABLE
+#define HYPERVISOR_DATA_SECTION
 #define HYPERVISOR_PERCPU_SECTION
 #endif
 
@@ -207,6 +215,8 @@ SECTIONS
 		EXIT_DATA
 	}
 
+	HYPERVISOR_DATA_SECTION
+
 	PERCPU_SECTION(L1_CACHE_BYTES)
 	HYPERVISOR_PERCPU_SECTION
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5750ec34960e..8bb9fffe2a8f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1602,6 +1602,13 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
+	err = create_hyp_mappings(kvm_ksym_ref(__hyp_data_start),
+				  kvm_ksym_ref(__hyp_data_end), PAGE_HYP);
+	if (err) {
+		kvm_err("Cannot map hyp data section\n");
+		goto out_err;
+	}
+
 	err = create_hyp_mappings(kvm_ksym_ref(__start_rodata),
 				  kvm_ksym_ref(__end_rodata), PAGE_HYP_RO);
 	if (err) {
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index bb2d986ff696..bc1664d365a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -16,4 +16,7 @@ SECTIONS {
 	HYP_SECTION_NAME(.data..percpu) : {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
+
+	/* Put after '.data..percpu' because its name matches the same regex. */
+	HYP_SECTION(.data)
 }
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
