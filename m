Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F221AC4361B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 741C323A6C
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 741C323A6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5DC4B272;
	Tue,  8 Dec 2020 09:25:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TBimWT5kFaxW; Tue,  8 Dec 2020 09:25:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BBBF4B2A6;
	Tue,  8 Dec 2020 09:25:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7300E4B263
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GpN9IshGaMj9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 09:25:06 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 783A54B2AB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:06 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id r7so5159570wrc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 06:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=EaxldaDhN9JlM3hE+IVwd+bTy8bVzmLP3BfUJc4jBBQ=;
 b=gULKGUKDNs5K8nvvXyITt50X6Uz79vM8+89FVjcAK6zuOHuIsYhOe00OqWQpm5TSDx
 nO/IrbyzFdepEFETzFAk43WiZWmcNzfBkWmyFGZ7/CE3M3a8c8UgRUqJ1T7bxmgmEXTi
 ah1qwtxT+O8hgLZgyXup0DutJii6RxEe0micQGZqCFpncp18p3Nr1G4O378zaFhdYGmH
 2rFzRZAG6RGGAifB5Ab+jkuNsBpkSU2V+GlcJZ5dEqcjjFYsMKVcpca30QjNdRH0HawY
 NNE+iIMrSbbHfJ6G/Tl1kfUA7TX/Mml25q29hbTuoaFYkbORxsivaK/tU69ho0TbxZvv
 iRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=EaxldaDhN9JlM3hE+IVwd+bTy8bVzmLP3BfUJc4jBBQ=;
 b=K8NCLBaKSIhSn1mMb31Hp5DSfqsFOBncB8F+Uzgasd6nyBAn07FPNeMoqghMr6jC05
 sq/eyrIutL2DqtFQbeIV00wHfZ6RwQVAf1JN1PLPKUEcmB8bfA5ksGPPCJ+D7eIJCOfx
 cQckKJ8j3W8uS7ll3oHXpCjWgT+LsyCVBGb47cVMFcya+AEq+X8nEsy5bT+ARWAfGRSO
 BugFEfzJTE9kA5O5ksMaHo+Ho4W9bxFwP+jiZ1pGcnRHgHccfFcKkoeNGXEBB7Vnx8cK
 qqwBub2MzqWKXOp9VnBMdLsshh+kxxZUrbv/sU7+H9rEfVfs7Yzi5VwXcNob/2EayLdM
 sSqg==
X-Gm-Message-State: AOAM531PVj3Z3/aj8B547lk+DebIO8By5YHftpoCcdY3aMBXmamC468G
 9b5f/S0cFyvyBnobzFl4Nyye5o2ngbEXSQ==
X-Google-Smtp-Source: ABdhPJzYqcZS7aoqzu4qYNksPaO6tUAeFeTHSKRNPw1/fsSQ1g1CJLkKZZZyFEt/fPl04D3ibmVhAw==
X-Received: by 2002:adf:f98b:: with SMTP id f11mr26057502wrr.235.1607437505274; 
 Tue, 08 Dec 2020 06:25:05 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id d9sm20747214wrs.26.2020.12.08.06.25.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Dec 2020 06:25:04 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/6] kvm: arm64: Skip computing hyp VA layout for VHE
Date: Tue,  8 Dec 2020 14:24:49 +0000
Message-Id: <20201208142452.87237-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208142452.87237-1-dbrazdil@google.com>
References: <20201208142452.87237-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Computing the hyp VA layout is redundant when the kernel runs in EL2 and
hyp shares its VA mappings. Make calling kvm_compute_layout()
conditional on not just CONFIG_KVM but also !is_kernel_in_hyp_mode().

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 18e9727d3f64..4e585cc892e8 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -434,7 +434,7 @@ static void __init hyp_mode_check(void)
 			   "CPU: CPUs started in inconsistent modes");
 	else
 		pr_info("CPU: All CPU(s) started at EL1\n");
-	if (IS_ENABLED(CONFIG_KVM))
+	if (IS_ENABLED(CONFIG_KVM) && !is_kernel_in_hyp_mode())
 		kvm_compute_layout();
 }
 
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
