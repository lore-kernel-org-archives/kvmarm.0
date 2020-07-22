Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FEEC433E5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EAF8207CD
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="MVr23i9E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EAF8207CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB514B26F;
	Wed, 22 Jul 2020 12:45:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TZe5OtdgAJNd; Wed, 22 Jul 2020 12:45:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D8A64B2CC;
	Wed, 22 Jul 2020 12:45:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30B854B2AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qDzR585ZbZ1e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:45:06 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C5404B2AF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:05 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id z15so2543621wrl.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=UzkCazi9IF2R2fovvI4XRbgeSUfI2aZOTLYWCOQmH7Y=;
 b=MVr23i9EY3adsavlnzqKlwywAbRQmWnYu/O0PqHFO5h2mZINEVU5vdwtCNcmVIzmqc
 HuDpvw4REHKGW2v9gawHMWOspu7nYKIcm7m1oe8P0DG0AG/jVj8RQJM+fncEU8eAoeFW
 Q4grx48wtHAnOBBbFmFB/F65EWt+ytE4kp9aCo51/gz5p+jKu5T4002eOYPYmq7uEzE1
 NJ+zdUhBvFRvtHM/RZLaDZ3LPvYeZlJRJrm4vb3JYln4uQgm1YmjZZ9WkIcvE4+s0QMo
 wpBITPMxNDcLOEuTS6TvgjT2x1TCzG34+CS/lKZmQkI5ELNGsHGz5y5Vo26RHLtMkgdF
 k+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=UzkCazi9IF2R2fovvI4XRbgeSUfI2aZOTLYWCOQmH7Y=;
 b=MMgdsnV77PJr9Kd1KJZexKrMXLLLZ/Kxqjt0K3Q9HWDtCOZeLy9LI5f/+Pby8RlMRO
 rM2+rVPaU7pF7QgQDyaIB9E1asMADOjFl6nxZCMXDFBg25pcWHRWOyOBO52vetktOM8x
 3IOSlZAlXeCOuyoCq7kMwqWLIJTiDzLrHZ44baVMoGglmgnpMSgjaWWwFDh7A2TYsUaE
 9wLhI8BAmkZ9ATME8RxuWaw+Vpq+804ULz16ohQtZgsyMfyT0+O66vlHqaw9z4Z+ub81
 gcMPqgHUyEUF3+Fsk4IQsfSYnM3YRxPFxDKkHjP/rfMF5hDPnlpNtSzwO8f9J0l3bz6b
 Zx4g==
X-Gm-Message-State: AOAM532P8HUibgaNU5EFAcxcWEgI15A7H8UplnO0X71hDfyEz54EagZE
 qMEEvl2m1oU+LqDyyTaZ00GFmQ==
X-Google-Smtp-Source: ABdhPJx/qEkJrXuwujIJYy6c8DcTNrb907z4XGsmWjlpmktsrboRRdsmuZeU2BTNkn5zyZPYZ1dJqQ==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr417138wrs.228.1595436304534;
 Wed, 22 Jul 2020 09:45:04 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:b0ee:900a:e004:b9d0])
 by smtp.gmail.com with ESMTPSA id 2sm250421wmo.44.2020.07.22.09.45.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jul 2020 09:45:03 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/9] kvm: arm64: Remove hyp_adr/ldr_this_cpu
Date: Wed, 22 Jul 2020 17:44:18 +0100
Message-Id: <20200722164424.42225-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200722164424.42225-1-dbrazdil@google.com>
References: <20200722164424.42225-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@google.com, kvmarm@lists.cs.columbia.edu,
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

The hyp_adr/ldr_this_cpu helpers were introduced for use in hyp code because
they always needed to use TPIDR_EL2 for base, while adr/ldr_this_cpu from
kernel proper would select between TPIDR_EL2 and _EL1 based on VHE/nVHE.

Simplify this now that the nVHE hyp mode case can be handled using the
__KVM_NVHE_HYPERVISOR__ macro. VHE hyp code selects _EL2 with alternatives.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/assembler.h | 27 +++++++++++++++++----------
 arch/arm64/include/asm/kvm_asm.h   | 14 +-------------
 arch/arm64/kvm/hyp/hyp-entry.S     |  2 +-
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 54d181177656..b392a977efb6 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -218,6 +218,21 @@ lr	.req	x30		// link register
 	str	\src, [\tmp, :lo12:\sym]
 	.endm
 
+	/*
+	 * @dst: destination register (32 or 64 bit wide)
+	 */
+	.macro	this_cpu_offset, dst
+#ifdef __KVM_NVHE_HYPERVISOR__
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
index da4a0826cacd..bbd14e205aba 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -151,20 +151,8 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 
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
index 689fccbc9de7..0a0cb1d3acd3 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -108,7 +108,7 @@ alternative_cb_end
 	str	x0, [x2, #VCPU_WORKAROUND_FLAGS]
 
 	/* Check that we actually need to perform the call */
-	hyp_ldr_this_cpu x0, arm64_ssbd_callback_required, x2
+	ldr_this_cpu x0, arm64_ssbd_callback_required, x2
 	cbz	x0, wa2_end
 
 	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
