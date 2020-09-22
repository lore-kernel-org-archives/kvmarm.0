Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4BAC4727D
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EDD312395C
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="KYMM1B96"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDD312395C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F6A24B0C7;
	Tue, 22 Sep 2020 16:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0vFKXCWoS6ur; Tue, 22 Sep 2020 16:49:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51DDA4B1EE;
	Tue, 22 Sep 2020 16:49:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 704A74B0C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lzxY3ezvGrWF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:23 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABBAA4B226
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:22 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id s12so18562537wrw.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=4owpoQA0YZkU55g3xZqB0P4GXzrY6zfnXz2TqZZIyZ0=;
 b=KYMM1B96Jv7z2OSW2J1SxoT0oCmfO8gzdOG3M1m8MGUzXriMClxvjHa/SFXuKswpCm
 RXSDpcMVpydS7yQvsSinqKRB4luwMTtxl9yqngeD3k1qPCwL1tyaO6lZDQwcOBnmvohX
 u3CxFJrBb5HXhwlotYXSVREXOiEaAsCN8mVf/eDVM2sXPVh5UmS3JoU8JdJtDXU9b8y/
 yIzBCfYtb7WXokc+pb7TdoScbplDeCH0U9QuIDyYx2LfgAkMx9l7SpOD6T0AUzSp2jj0
 jPoMAfE1qHyVwF5n11jwIJ2KZ0DPEPFe37y2qMCLi5Mq5zD5r7MgYvB3/9Ocys280cNY
 VrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=4owpoQA0YZkU55g3xZqB0P4GXzrY6zfnXz2TqZZIyZ0=;
 b=t6u847WAqw76QFZ01k5x/BO2+QhnJh7P3HiZ4GqCLh3p4FByjU8JmD1m1hUwdhqnE5
 mbMfdWqdXvLZrnYppW7qq0HZrzVSG61pHi+M9Kq6JgAbTyWjZM/e+qsU6Be/DSIeD9yr
 P4D5N4FEURyosLowQwKzxKpAXbzhhOlST2QcONetEW8tpGoXD5UsScvXiH6Ear89c2YA
 k6MRyuI3IwSvBU6vU1F0YfnqLsfzlppodpEuIMkQkI0ghmmZX5Fv1ZQwt9Io9HHCfvcF
 /x1JG7YSyP63myRh1BC3oh2x5s756avXgsN2csHayEATTv3pQvm3wqV1QfS+Rg0UEf+I
 lEAg==
X-Gm-Message-State: AOAM532JAXlLU9vTMU3ZriktzDbRMR/68uNqsXUsMosHoXCBS5nM5LtP
 UgwQf5JDXB85doBygrYxrVx2AKjs895BezTW
X-Google-Smtp-Source: ABdhPJxX9uBzSAKnJBAmtj/fHGztbwr3USOr+K3MXcKDIWkd6igzfbo8A1qOGNiBRh7RnslToVGEkg==
X-Received: by 2002:a5d:4dcb:: with SMTP id f11mr5757666wru.163.1600807761459; 
 Tue, 22 Sep 2020 13:49:21 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id y207sm6365851wmc.17.2020.09.22.13.49.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:20 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 05/10] kvm: arm64: Remove hyp_adr/ldr_this_cpu
Date: Tue, 22 Sep 2020 21:49:05 +0100
Message-Id: <20200922204910.7265-6-dbrazdil@google.com>
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

The hyp_adr/ldr_this_cpu helpers were introduced for use in hyp code
because they always needed to use TPIDR_EL2 for base, while
adr/ldr_this_cpu from kernel proper would select between TPIDR_EL2 and
_EL1 based on VHE/nVHE.

Simplify this now that the hyp mode case can be handled using the
__KVM_VHE/NVHE_HYPERVISOR__ macros.

Acked-by: Andrew Scull <ascull@google.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/assembler.h | 29 +++++++++++++++++++----------
 arch/arm64/include/asm/kvm_asm.h   | 14 +-------------
 arch/arm64/kvm/hyp/hyp-entry.S     |  2 +-
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 54d181177656..86e0ef79a799 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -218,6 +218,23 @@ lr	.req	x30		// link register
 	str	\src, [\tmp, :lo12:\sym]
 	.endm
 
+	/*
+	 * @dst: destination register (32 or 64 bit wide)
+	 */
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+	.macro	this_cpu_offset, dst
+	mrs	\dst, tpidr_el2
+	.endm
+#else
+	.macro	this_cpu_offset, dst
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
+	mrs	\dst, tpidr_el1
+alternative_else
+	mrs	\dst, tpidr_el2
+alternative_endif
+	.endm
+#endif
+
 	/*
 	 * @dst: Result of per_cpu(sym, smp_processor_id()) (can be SP)
 	 * @sym: The name of the per-cpu variable
@@ -226,11 +243,7 @@ lr	.req	x30		// link register
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
 
@@ -241,11 +254,7 @@ alternative_endif
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
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
