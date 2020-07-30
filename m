Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF04C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:18:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB4B5206F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="AQYWfol0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB4B5206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9E8F4B4DC;
	Thu, 30 Jul 2020 11:18:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GUbLtLEbSX5I; Thu, 30 Jul 2020 11:18:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D0F4B4C6;
	Thu, 30 Jul 2020 11:18:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A0B4B3C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:18:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uo3zy+GBdF65 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:18:39 -0400 (EDT)
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com
 [209.85.218.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D6DF4B39C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:18:39 -0400 (EDT)
Received: by mail-ej1-f74.google.com with SMTP id bx27so5263780ejc.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 08:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=MUdvGy7WHMB9yvv+A5FAQJ5wXXTHoVGUzZoWv2V60Jc=;
 b=AQYWfol0VTcdcEBOcnuyDdRedXvaHZvHx4gYGKq5XJ28q+hynhzFbbFAIkfGUdQFkt
 jGdoYs7xmoyhy3zCfLxjjUOEinhBO/pt0Y7cG6M6+k62t7clGTK3QVj2xZ5AsaASkDx9
 937yPHw8hzI3B3pXLoSiTCStEuTh1N2dHAJKPvgKkso+4aGn2NxvdPZHkAijEJwtf1Ve
 b1cdFSmuOOIaiVjpSZszwJrmIs5bqXFNCFhcVCK7yQM8O8ICT0y7NB8I91ji7+B1fxdL
 8ip0xd/6BEiuF95p8Zg0YaKj+SDPAJ+qwkGRqo2fUP+ddt36hXdEy/KWbPa44YH8yt4D
 1CvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=MUdvGy7WHMB9yvv+A5FAQJ5wXXTHoVGUzZoWv2V60Jc=;
 b=smaaeVzKNzP0ws9UksYu5lRio/is1cC98rTHWNzj+0ijXP19nj2ElAvOpsi4Y+8GvH
 Ybc35gsToywYOhZFhD9V6fOzQ6qYKJt3AFUCDcSXb/FFbD6DOWOT4WH7nhyHPv+N13FL
 JMT6yYcQcGpr8x2jBR/wEx+atrq2gv7FA7Ncl65Ue/uufyvPx/uURSGd/eOftp7Z1r3S
 9KzuCWysXGD3DrT48746sZGBkDeVb7SkqLmI6P/3hDV2w2qQRhhy/RQ8rtbopcfL3kQH
 0fZCOgH2NHhjape64ZvagFtpE5cAjuL8CK0tYyer7AHzyuqtcsb8vONAlQTP2ET3s97B
 8fvQ==
X-Gm-Message-State: AOAM5309OIVeBvvK0ynBMeM7qpAFrO0PHNCKN7W0fhFghnofxYQJH7Pb
 t9M8tc+EON8e5SRGs7k4o9Catw4InCd5vXivIagUDWJbhldEg3gNRMHwjgWe4WC+YuTIE6FYCX5
 WFbweYLLcoSwcwDqZfkdCJDwWzOjQpVV0Ps05uzbJuX0umfBrcWFjIJC74pMvcX2v5FoOqQ==
X-Google-Smtp-Source: ABdhPJzeSGFfrRmgUevUOcbCBa7nkliKEAnlBU2NiXMiSP/jkS7KWxC3w5KvKrK3GY2Uz2WAQQVUUcAe1Cc=
X-Received: by 2002:a17:906:b6d0:: with SMTP id
 ec16mr3091947ejb.94.1596122317996; 
 Thu, 30 Jul 2020 08:18:37 -0700 (PDT)
Date: Thu, 30 Jul 2020 16:18:22 +0100
Message-Id: <20200730151823.1414808-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH 1/2] KVM: arm64: Restrict symbol aliasing to outside nVHE
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org
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

nVHE symbols are prefixed but this is hidden for the host by aliasing
the non-prefixed symbol to the prefixed version with a macro. This runs
into problems if nVHE tries to use the symbol as it becomes doubly
prefixed. Avoid this by omitting the aliasing macro for nVHE.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index fb1a922b31ba..413911d6446a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -99,8 +99,11 @@ struct kvm_s2_mmu;
 
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
+
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
+#endif
 
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 extern atomic_t arm64_el2_vector_last_slot;
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
