Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E01BC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:25:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D22862080D
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="v2fnvJZk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D22862080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81A704B1A8;
	Thu, 18 Jun 2020 08:25:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0SyHhMk1K3-I; Thu, 18 Jun 2020 08:25:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BDAB4B15C;
	Thu, 18 Jun 2020 08:25:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45A2F4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:25:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kj0e2IPtKvHe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 08:25:52 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 261704B133
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:25:52 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id f185so5450770wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 05:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=djiFW55yS1Rp4YNDz8isiFDt/Jj9YD2Q3nFMXytrXY8=;
 b=v2fnvJZkLqF0i9ErTBWcqsVxtNWg/3wdSutfObc9AIk4DR/IavDByhXEtlOYekhmdf
 R2CgLoEuJAbgHIWE/vPnL5o/HpKTPnr77VMTfNap2Jdz0WW+qcGIUEwuTapaFS1tKF1p
 ZLLoqMNDzEdm8u5aMtSPYg4A04ypHted9caH6mhehwNz3HStqSoG2BT/EHLQuOauISpr
 IDWxdnQNL5hLTPOnquHTBZ5v3Y/zX4wzZRzveuQ2xKU4K4qfn3raKqsYUtZTiuJ+T2rF
 8RLx+Nk8YRIHIp1ihTyjcJvrrloifKjS1iJbF6NSUB52yi2G+564oLebdH39X7+ZWhVQ
 IuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=djiFW55yS1Rp4YNDz8isiFDt/Jj9YD2Q3nFMXytrXY8=;
 b=h+sc/mfsv3PrRQOwObOFJmoJgrRbHIj63vQUq1tGy8SOSMovl7w45xRnnixa2/l1VU
 Oks+UNsqmrOeWToEeEdHkta02dxZ+OtxmSDrcg26SOIk/38c3tG6q35NbXT3J77CWq5g
 7/YvI0q4chBQ3qiFw/ltYAgPmpNQ/WO3IKcEEgmxeZTKSoiIe3nMh6I1M/17Pj6/TjJM
 oh2e5itTe4QFNb7jpNmaTIy79f3kVMGuq4r6jHnBNa7MU4HpQM4BHB7hFa8dTG2EsQtC
 +Di/HeGxN7uGuHd/FGhZv+M8PfcpUp3Yo1ceF1N39tSqjrvHxp96yUiovzYKZst+mqcA
 Qzgw==
X-Gm-Message-State: AOAM531AVE+m/JpD65jPFpkYKLT70zOvEMdWRW+yo8HLjJiskLwJM9oq
 H9fJ3lyfPV85USvgTWZhdIOvlw==
X-Google-Smtp-Source: ABdhPJy9A8Zbppj9s06HLgvsvKt+NXsCtHpKYpFtYCSZa2fG9j2ycaFqUHQSP17r/EIg0sOzuQL+lg==
X-Received: by 2002:a1c:5411:: with SMTP id i17mr3942342wmb.137.1592483151024; 
 Thu, 18 Jun 2020 05:25:51 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c1af:c724:158a:e200])
 by smtp.gmail.com with ESMTPSA id 89sm3423962wrg.56.2020.06.18.05.25.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 18 Jun 2020 05:25:50 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 01/15] arm64: kvm: Fix symbol dependency in
 __hyp_call_panic_nvhe
Date: Thu, 18 Jun 2020 13:25:23 +0100
Message-Id: <20200618122537.9625-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618122537.9625-1-dbrazdil@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
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

__hyp_call_panic_nvhe contains inline assembly which did not declare
its dependency on the __hyp_panic_string symbol.

The static-declared string has previously been kept alive because of a use in
__hyp_call_panic_vhe. Fix this in preparation for separating the source files
between VHE and nVHE when the two users land in two different compilation
units. The static variable otherwise gets dropped when compiling the nVHE
source file, causing an undefined symbol linker error later.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index db1c4487d95d..9270b14157b5 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -897,7 +897,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 	 * making sure it is a kernel address and not a PC-relative
 	 * reference.
 	 */
-	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
+	asm volatile("ldr %0, =%1" : "=r" (str_va) : "S" (__hyp_panic_string));
 
 	__hyp_do_panic(str_va,
 		       spsr, elr,
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
