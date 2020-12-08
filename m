Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58C4C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A12323A6A
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A12323A6A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0414B286;
	Tue,  8 Dec 2020 09:25:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pih573pnGaMc; Tue,  8 Dec 2020 09:25:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E401F4B281;
	Tue,  8 Dec 2020 09:25:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 605BF4B263
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w6QL1U5eEvlK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 09:25:04 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7242A4B232
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:04 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id a12so9618646wrv.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 06:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Js+kADbtgM+vdnerlP9z0cKyj1NsUqnpPe0pQv1UIXw=;
 b=rNqDlvxyiJ1P0X/0WsQzcAkJH7Wxtpn3w4/snPmFyQE2KualXgw27WCaRrxPRFYwwI
 QsoSIhbDK/z907X9cKGawWx3YqPOhniUpNV1ttzOUbL2Xq2ygPlTp3uuFaexqbw2e7TM
 jdPGWa9M+DcgzmdFp0iih/gDDMH7slzsCXgDqnvpQ29RZuDbpmF3IqIKm06SjMnw2EzM
 WOtgcp0yD0ppJcFJgI573XFMmWxBCOKN5+aoJmLMv7u2bHi87WbHN7aVZrm92p/mzelu
 C76fa08qbD0a4wn1vmdzbRf2A1519kerYbbXV9QHDQqk2wmYfsyqYachY5A4E8hypG4o
 MFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Js+kADbtgM+vdnerlP9z0cKyj1NsUqnpPe0pQv1UIXw=;
 b=lRNOFj3v+axr5OB+OglZH3rFQy674aIKiy1hUb74IL32a9r5pkFO3DIzDI/ZDzBt6A
 MsLlK9G64Gqz67fMJfF/2Hk5OlCYKET0rFjPUzFquXfJPQPXt4HUQYqlo6T5371+7RJQ
 qLyrJQ460uh4v2Z72/jFmkUh3tjVytje1a7U3GaYi3OxhAfXJr2Jfi7MX7yUow5bwSCp
 WqdDdjyQMdjnCnaU/kTa598I/SqcUTAR6eQmBxLVTYNMZk/6Ve0QDz4DsE+eNMSG9SJN
 thqwvGgZiEtB0Q3Sv+lh4pAztSZ0K76Dq0XXWgeI0xVY8gzipKy5hNS/mL9X0mYOqXet
 nC/A==
X-Gm-Message-State: AOAM533H7YGBVkCzs00qeGWXFrFR7zg6TzKevz56Evb7NFyTdZ+qanps
 TOWfzkumWNxdrePAMRT0RICiplGk1D1dRg==
X-Google-Smtp-Source: ABdhPJxHrjfFXJbqnCX9xFY5SICS+JzIJWzJPSavZ7ozgbyJlJghKGdV9NwVaAw/PLQwBO8RZFpRfA==
X-Received: by 2002:adf:aa4a:: with SMTP id q10mr24761702wrd.276.1607437503226; 
 Tue, 08 Dec 2020 06:25:03 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id m8sm3952024wmc.27.2020.12.08.06.25.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Dec 2020 06:25:02 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/6] kvm: arm64: Use lm_alias in nVHE-only VA conversion
Date: Tue,  8 Dec 2020 14:24:48 +0000
Message-Id: <20201208142452.87237-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208142452.87237-1-dbrazdil@google.com>
References: <20201208142452.87237-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Qian Cai <qcai@redhat.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
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

init_hyp_physvirt_offset() computes PA from a kernel VA. Conversion to
kernel linear-map is required first but the code used kvm_ksym_ref() for
this purpose. Under VHE that is a NOP and resulted in a runtime warning.
Replace kvm_ksym_ref with lm_alias.

Reported-by: Qian Cai <qcai@redhat.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/va_layout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index d8cc51bd60bf..914732b88c69 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -42,7 +42,7 @@ static void init_hyp_physvirt_offset(void)
 	u64 kern_va, hyp_va;
 
 	/* Compute the offset from the hyp VA and PA of a random symbol. */
-	kern_va = (u64)kvm_ksym_ref(__hyp_text_start);
+	kern_va = (u64)lm_alias(__hyp_text_start);
 	hyp_va = __early_kern_hyp_va(kern_va);
 	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)__pa(kern_va) - (s64)hyp_va;
 }
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
