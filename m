Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C070FC47255
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 790C22082E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="llTRbVie"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 790C22082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C224B53F;
	Thu, 30 Apr 2020 10:49:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YnOpNkXfMIyD; Thu, 30 Apr 2020 10:49:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1A04B51C;
	Thu, 30 Apr 2020 10:49:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4832F4B4C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ya3dRchBX4rY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 10:48:57 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 611334B509
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:57 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id e26so2183894wmk.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=bbHNVTpXzIBH43k7+53bLmR3Osutfa9At2Hme6Sb9BQ=;
 b=llTRbViex/wVjycqDYpppwsQ0xUzk4iAPlw0uNFjdIhsppV/SKrvZbyK35stLuiFrz
 AUBMsiXjZ6vVVymfv1M2Ih94IKnRUaJ+o0SgAcyJS+ZLfYOlLp2IjBrMMv2h69dKvgSd
 oS11PAuOK+5C2Fh+LaUFFFdZCkeiH/1TK3J3zoHJ5I7xtgGHfnCkOOCuSqvjx4YKceV1
 Fh9LJ1Xy4SFCRK59Fg5/k8WPH9+rjpd/VwKOKWpdUyCxmI8LwsuS2VMQHTR+CSxnLn4O
 EmSNclgJIW+TaBUAkSzTL/tIC3mm2zNJ/14mode5DBV9vfGzVkVSFtYV7BiJV1ezNIzY
 52AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=bbHNVTpXzIBH43k7+53bLmR3Osutfa9At2Hme6Sb9BQ=;
 b=spt+BdfOxB3e2Xm59DKXbbLCZnT7E/vQP2xnEE7GjBfHBxWIMslwhfg4ZOJjM+xisU
 AisRfmkwkgDBc4DFN1jAPqvzVzBW0UMEIqDRPRFviVSJmxbMtPNQDeWJEf0erzejMhxO
 m47BpbSF48Y7TSYoaOSGO+BF8ET7O8xaPSPqxY/gA3e4wl1UXj9z6KkHtK4UrxLsaXiR
 EKqTst/PKwxIHkvwm+2jBCoFK4+vvNOx5MzG/VEL8NTRQ77Kd3cZSE10p6l+9CkuqcEM
 SShU5UPPqJRB57wgQWQ9S2kBXSnI3NBZ45NkR/Pdll5XFZh9Ys0v5+pFpf0WKqw3Hg3C
 izKg==
X-Gm-Message-State: AGi0Puam1E2betYvAkewXTdwm6LlUveY4sWIe6HhNkQLEC0LFDLQ21YY
 9m7Wq92sKgnK755fVIUiUa8FhQ==
X-Google-Smtp-Source: APiQypKHpehC+NoZtiH6O1b+EgH40+ocC2ldPt1fuV9Crb6tjR/KtOsD6F8IOBtbo+KoSxGe4rMN3g==
X-Received: by 2002:a05:600c:2c04:: with SMTP id
 q4mr3264060wmg.7.1588258136239; 
 Thu, 30 Apr 2020 07:48:56 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d4b6:9828:8bd2:ce6f])
 by smtp.gmail.com with ESMTPSA id c10sm4180096wru.48.2020.04.30.07.48.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Apr 2020 07:48:55 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 06/15] arm64: kvm: Move __smccc_workaround_1_smc to .rodata
Date: Thu, 30 Apr 2020 15:48:22 +0100
Message-Id: <20200430144831.59194-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200430144831.59194-1-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

This snippet of assembly is used by cpu_errata.c to overwrite parts of KVM hyp
vector. It is never directly executed, so move it from .text to .rodata.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5986e1d78d3f..7e5f386c5c2d 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -364,6 +364,11 @@ SYM_CODE_END(__bp_harden_hyp_vecs)
 	.popsection
 
 #ifndef __HYPERVISOR__
+	/*
+	 * This is not executed directly and is instead copied into the vectors
+	 * by install_bp_hardening_cb().
+	 */
+	.pushsection	.rodata
 SYM_CODE_START(__smccc_workaround_1_smc)
 	esb
 	sub	sp, sp, #(8 * 4)
@@ -377,5 +382,6 @@ SYM_CODE_START(__smccc_workaround_1_smc)
 1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
 	.org 1b
 SYM_CODE_END(__smccc_workaround_1_smc)
+	.popsection
 #endif /* __HYPERVISOR__ */
 #endif /* CONFIG_KVM_INDIRECT_VECTORS */
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
