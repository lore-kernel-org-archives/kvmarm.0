Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE963C56202
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50EF020BED
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QGvBnzgo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50EF020BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E73AE4B6A3;
	Wed,  4 Nov 2020 13:36:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KbOVOgK8Lhfc; Wed,  4 Nov 2020 13:36:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50C54B7D4;
	Wed,  4 Nov 2020 13:36:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBAB04B7C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NjgeFHqgps8W for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:56 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1C854B7A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:56 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id k10so21832532wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=0K4yzmgUf7vVHr0iz04jMBBw0fWBZw8e2naPJ5vP+Z8=;
 b=QGvBnzgo0YRmIsUmCbkwh4pjuJnqEqI3AN4RP2WCjupA1IHn6Z0OnrMIpsPkymqpGw
 LP9vXOC4bb2uIkzXW0F524KSp23G15/moUgPgVXyGcaOdHz02/CsBg9vdKJ30wzamCGY
 /SWOL9tpI69HAqq6Lm3Ny8wX2p8T2D1MT7DbixVPelrjHpAmcQfQrSllDLrT8J7mD9cB
 9GcGSiXbr5xTAA5lqnnidjDOw8yi3CjQw/YpYaC2iN/JQlLnH0UqksA8MHDMKqloZlF7
 p+qMxb5zNbwWUudAMWkCby24Fe08vjsUpOoq5cImXofhjAevvHYe7xd/i7i9ef2L3nTG
 GeBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=0K4yzmgUf7vVHr0iz04jMBBw0fWBZw8e2naPJ5vP+Z8=;
 b=UoOG0yMO1XtQxcFEyA8MslQj4eQeZTBpB1lpWYqaihlUz5hGuodH5C9blyIE1W4zRh
 MKerYE2Sfk/WFambNWW7+QjNlLKgto7yLrxkiBBEtcPLlEVYccSFwBXCr247zmSKahH5
 vvsSj8C3o1OPw9cO/q693hoAGElokVpwU3PQlIgdQsCo7Ay2E090j4Qtz+y0oS9hGEQV
 Pg/J2W+65Y8J8tAyypAiimEvzDrNUq2wgNzNLNKbmfvWzNp/WvckIyJhAebjPblUhrRa
 Wd03x/GkoBES15+dI911NTg+Xmu+UJ5s2Gx+giByUqvmxeR2hKW3HLx7y1V7C+9BIfq6
 u8GA==
X-Gm-Message-State: AOAM5336W/jbEeYPeIyqEhsnx2B3iU6uWuArn+XeLKBtvwXW3uEKuNkt
 SxUAi/Y/78Nl1R8ARYW+HHoN/CCz+8NF6mFd
X-Google-Smtp-Source: ABdhPJxYOz8oN6hDQHajevWPLeTnGuUdeWGhUJpO55H7sotkzepkhC9LY3nZQ7oVr6rhj4DYoT519A==
X-Received: by 2002:adf:f246:: with SMTP id b6mr33349825wrp.111.1604515015435; 
 Wed, 04 Nov 2020 10:36:55 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id l11sm3646430wro.89.2020.11.04.10.36.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:54 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 08/26] kvm: arm64: Create nVHE copy of cpu_logical_map
Date: Wed,  4 Nov 2020 18:36:12 +0000
Message-Id: <20201104183630.27513-9-dbrazdil@google.com>
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

When KVM starts validating host's PSCI requests, it will need to map
MPIDR back to the CPU ID. To this end, copy cpu_logical_map into nVHE
hyp memory when KVM is initialized.

Only copy the information for CPUs that are online at the point of KVM
initialization so that KVM rejects CPUs whose features were not checked
against the finalized capabilities.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c             | 17 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/percpu.c | 16 ++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8bb9fffe2a8f..58e9cc183bd5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1481,6 +1481,21 @@ static inline void hyp_cpu_pm_exit(void)
 }
 #endif
 
+static void init_cpu_logical_map(void)
+{
+	extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
+	int cpu;
+
+	/*
+	 * Copy the MPIDR <-> logical CPU ID mapping to hyp.
+	 * Only copy the set of online CPUs whose features have been chacked
+	 * against the finalized system capabilities. The hypervisor will not
+	 * allow any other CPUs from the `possible` set to boot.
+	 */
+	for_each_online_cpu(cpu)
+		CHOOSE_NVHE_SYM(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
+}
+
 static int init_common_resources(void)
 {
 	return kvm_set_ipa_limit();
@@ -1658,6 +1673,8 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	init_cpu_logical_map();
+
 	return 0;
 
 out_err:
diff --git a/arch/arm64/kvm/hyp/nvhe/percpu.c b/arch/arm64/kvm/hyp/nvhe/percpu.c
index 5fd0c5696907..8b7f6b7dbd48 100644
--- a/arch/arm64/kvm/hyp/nvhe/percpu.c
+++ b/arch/arm64/kvm/hyp/nvhe/percpu.c
@@ -8,6 +8,22 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+/*
+ * nVHE copy of data structures tracking available CPU cores.
+ * Only entries for CPUs that were online at KVM init are populated.
+ * Other CPUs should not be allowed to boot because their features were
+ * not checked against the finalized system capabilities.
+ */
+u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
+
+u64 cpu_logical_map(int cpu)
+{
+	if (cpu < 0 || cpu >= ARRAY_SIZE(__cpu_logical_map))
+		hyp_panic();
+
+	return __cpu_logical_map[cpu];
+}
+
 unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 {
 	unsigned long *cpu_base_array;
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
