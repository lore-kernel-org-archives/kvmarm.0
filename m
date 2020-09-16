Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D926C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8CF822460
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="qMakas/E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8CF822460
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ADCD4B4DB;
	Wed, 16 Sep 2020 13:35:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FNYvHh5XjV0R; Wed, 16 Sep 2020 13:34:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D324B506;
	Wed, 16 Sep 2020 13:34:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6B34B48C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ouc7P2N4xZ6g for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:34:56 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 943EE4B4DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:56 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id a9so3901736wmm.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=9sgzGfpFFC64RJRg+974gui8xymUAlAMqzcpem+/CSY=;
 b=qMakas/EqU8sthwlgBLnrwvnZRAraVI8Sv8JwWPnUfgEnVzZJSdrtVHvMt1ezF7z7H
 A/CJWmbIe4J9dCW8b0LTLe7Heh9CPHI643HmQCBrpkULf8M+cEXiyc0+aQbcTDAsf1v2
 +n07zinh1/QDVCzCcP9y2XRmwPgdEs1CXndG+Zomxw2gl8eA2cp9tt2bxanJ+/59hf2A
 /m/n28TEXQlZYX3OIhG9T3Sixf56usD+TjQZ/+zNIZJNqfbTjzC6ijgK3F9kXhjOrOS3
 4yT1Toi0Q6lOvmlLPznvI5ROFnBl/KAiCFVY5WND4p3AsI8mQUEIZDynexktrozfT8Lx
 0RGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=9sgzGfpFFC64RJRg+974gui8xymUAlAMqzcpem+/CSY=;
 b=Prnz22VWV1VHvXWfCeS5WqD1/EN1d9CCZIZPSUN1SckS7r3G9DeMEdABbzNevX5yvg
 5T0wHyxFkWaQQJaaKoHtdMGXVXWLiTPYRxlrKN0oFvnT7eD+LIA5oQeyuunms/ocsd/k
 uEM71syt8J9RbVoY/vf3n7Yc63Zm8ocyJyNLhm+cfYBv91jO4p5iFLyof6gCPNn0Vv70
 4ofqcBz4vl2GnoF0GxaOFa+orbC9xWyJJe0rrfMCCSZ2cR0S/1UqyJW2K74Bx9I1FQCj
 Zm/8RxOxSKW98NrDojFvMU04oUt/dP8vr7W2EY/D2RDyLRWPZKgPkT2y37PptoHlkBov
 sGVg==
X-Gm-Message-State: AOAM530juBpllHXF+BKEsi/IYkz1Lv3iTPyrMLeFz2q58tILWkxkbpuo
 xzMFkjC22vbNkYTGaHCUaKPbcgDgGqjxQ/3u
X-Google-Smtp-Source: ABdhPJxFj6X/hCuUE/N+733RQjEZLOd7n2vySf2bWA+cMRMhZxuMBy1BHCIG9TmmZ1mKvjjqjdC8yA==
X-Received: by 2002:a7b:c192:: with SMTP id y18mr5703981wmi.108.1600277695176; 
 Wed, 16 Sep 2020 10:34:55 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id m1sm6108804wmc.28.2020.09.16.10.34.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:34:54 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 05/11] kvm: arm64: Remove hyp_adr/ldr_this_cpu
Date: Wed, 16 Sep 2020 18:34:33 +0100
Message-Id: <20200916173439.32265-6-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916173439.32265-1-dbrazdil@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
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

The hyp_adr/ldr_this_cpu helpers were introduced for use in hyp code
because they always needed to use TPIDR_EL2 for base, while
adr/ldr_this_cpu from kernel proper would select between TPIDR_EL2 and
_EL1 based on VHE/nVHE.

Simplify this now that the hyp mode case can be handled using the
__KVM_VHE/NVHE_HYPERVISOR__ macros.

Acked-by: Andrew Scull <ascull@google.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/assembler.h | 27 +++++++++++++++++----------
 arch/arm64/include/asm/kvm_asm.h   | 14 +-------------
 arch/arm64/kvm/hyp/hyp-entry.S     |  2 +-
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 54d181177656..f79231a0f949 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -218,6 +218,21 @@ lr	.req	x30		// link register
 	str	\src, [\tmp, :lo12:\sym]
 	.endm
 
+	/*
+	 * @dst: destination register (32 or 64 bit wide)
+	 */
+	.macro	this_cpu_offset, dst
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+	mrs	\dst, tpidr_el2
+#else
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
+	mrs	\dst, tpidr_el1
+alternative_else
+	mrs	\dst, tpidr_el2
+alternative_endif
+#endif
+	.endm
+
 	/*
 	 * @dst: Result of per_cpu(sym, smp_processor_id()) (can be SP)
 	 * @sym: The name of the per-cpu variable
@@ -226,11 +241,7 @@ lr	.req	x30		// link register
 	.macro adr_this_cpu, dst, sym, tmp
 	adrp	\tmp, \sym
 	add	\dst, \tmp, #:lo12:\sym
-alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	mrs	\tmp, tpidr_el1
-alternative_else
-	mrs	\tmp, tpidr_el2
-alternative_endif
+	this_cpu_offset \tmp
 	add	\dst, \dst, \tmp
 	.endm
 
@@ -241,11 +252,7 @@ alternative_endif
 	 */
 	.macro ldr_this_cpu dst, sym, tmp
 	adr_l	\dst, \sym
-alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	mrs	\tmp, tpidr_el1
-alternative_else
-	mrs	\tmp, tpidr_el2
-alternative_endif
+	this_cpu_offset \tmp
 	ldr	\dst, [\dst, \tmp]
 	.endm
 
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index c196eec25498..cf9456663289 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -173,20 +173,8 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 
 #else /* __ASSEMBLY__ */
 
-.macro hyp_adr_this_cpu reg, sym, tmp
-	adr_l	\reg, \sym
-	mrs	\tmp, tpidr_el2
-	add	\reg, \reg, \tmp
-.endm
-
-.macro hyp_ldr_this_cpu reg, sym, tmp
-	adr_l	\reg, \sym
-	mrs	\tmp, tpidr_el2
-	ldr	\reg,  [\reg, \tmp]
-.endm
-
 .macro get_host_ctxt reg, tmp
-	hyp_adr_this_cpu \reg, kvm_host_data, \tmp
+	adr_this_cpu \reg, kvm_host_data, \tmp
 	add	\reg, \reg, #HOST_DATA_CONTEXT
 .endm
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 46b4dab933d0..fba91c2ab410 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -132,7 +132,7 @@ alternative_cb_end
 	str	x0, [x2, #VCPU_WORKAROUND_FLAGS]
 
 	/* Check that we actually need to perform the call */
-	hyp_ldr_this_cpu x0, arm64_ssbd_callback_required, x2
+	ldr_this_cpu x0, arm64_ssbd_callback_required, x2
 	cbz	x0, wa2_end
 
 	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
