Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA42C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:15:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00DA020702
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="my1fX9ke"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00DA020702
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2D04B565;
	Thu, 25 Jun 2020 09:15:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IiP7glozQtpV; Thu, 25 Jun 2020 09:15:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77554B4D5;
	Thu, 25 Jun 2020 09:15:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 098934B4D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D5uSfW+Q-zkP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:59 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A8F74B562
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:55 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id g18so5828913wrm.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=weWL7T+4egHpRvm0GYQ+v0Ui4aatvNKJI5SmqJIkJtU=;
 b=my1fX9kephaqvEBX9FIxuU9jSFcVLXtuFzR8EJXTKHAGTj7fLu6Ke5DENPonybea4V
 PBLUSWSvylaGW+EShdRwCSisN31LtAAQvUK+v/6gqv8mBVJ1AeTUpNtlVDPiOaClm/XB
 B6VJoXCqxfS2PNF1wy43kOtOAhMEB6m5gpKxVbZmNgH6/c/EoUxQvqJj2qdyXcBbu2bq
 BTzSiyss5XXgeL8JBFO3zRgUsv+0ufEUH4DA5+wrDD3dcS8DWRGd+VyANE10xSaGBDZB
 wNxnSbyFFAzJjqYCqVmN445ayuhhkLqksu1gWdfrsThf1TdGUSGBEWgc0w3wslq5X90j
 wopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=weWL7T+4egHpRvm0GYQ+v0Ui4aatvNKJI5SmqJIkJtU=;
 b=N0Q/QTmC5ymBEl9dsGylyxSINUYUTf27bjCS5ku40Yl0CfQkPFXGS+OJYQwyfd9CjS
 LUTJIgFhhEHKqLGMPsIgtMXk4LjI4mqxKRGth8aD+ZEruQanxjkMOJWWH2B7R33ol8Rv
 gkcZ9Grt7i2Dotl/tmfWLMFh/ZKsXJ99hNB/fJGzyKrNKwQqJHYl9nbr9mgDGHPtsaqh
 dRuuFdrqzhxGaNwtQaqdIiVvls3Excf5Jy9SRg4ieHt7ezi3IB6mLZSxvYxqkathqI07
 Bs8i2EXuHlOOXmrtBV6dnC2DvCbV48OUdEYhNPA0rYcY0kI6sCMUeYS4zWP+EoVLcEAM
 ZtaQ==
X-Gm-Message-State: AOAM530Q2bk0lRMb5lK7XWpcpU4ubAHFP3Oz48wXnsnThtcaZjIQrgj0
 Kbm0xpfT/Fltlu4asyCXNN8qlA==
X-Google-Smtp-Source: ABdhPJyFCoPxAl/jVyIrJH4RBMwPWAai2+rrEY7HwqA9hMweZ6XP4r6wip4j7cg6rQQqnDEQLHWwXw==
X-Received: by 2002:adf:df03:: with SMTP id y3mr34915884wrl.376.1593090894481; 
 Thu, 25 Jun 2020 06:14:54 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id z6sm8125973wmf.33.2020.06.25.06.14.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:53 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 15/15] arm64: kvm: Lift instrumentation restrictions on VHE
Date: Thu, 25 Jun 2020 14:14:20 +0100
Message-Id: <20200625131420.71444-16-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

With VHE and nVHE executable code completely separated, remove build config
that disabled GCOV/KASAN/UBSAN/KCOV instrumentation for VHE as these now
execute under the same memory mappings as the rest of the kernel.

No violations are currently being reported by either KASAN or UBSAN.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/vhe/Makefile | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 090fd1e14be2..461e97c375cc 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -9,11 +9,3 @@ ccflags-y := -D__KVM_VHE_HYPERVISOR__
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
-
-# KVM code is run at a different exception code with a different map, so
-# compiler instrumentation that inserts callbacks or checks into the code may
-# cause crashes. Just disable it.
-GCOV_PROFILE	:= n
-KASAN_SANITIZE	:= n
-UBSAN_SANITIZE	:= n
-KCOV_INSTRUMENT	:= n
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
