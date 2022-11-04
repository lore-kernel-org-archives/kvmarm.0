Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C2DC43219
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:11:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8001E4B1C6;
	Thu,  3 Nov 2022 21:11:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TD7aLcy09Pjs; Thu,  3 Nov 2022 21:11:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60EAC4B125;
	Thu,  3 Nov 2022 21:11:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C15144291D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id abnntNzbZMpx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:11:16 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DB644141A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:16 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-37360a6236fso33636147b3.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=ZNLPTbSTlYPZjBY9HcgmDn5JBJ/klYO2bN4Z3HIMVZY=;
 b=bwqOOb8Qn4eAWyxn4R+vdMrp7z+X9MlDWhtS2hi7whYYdWkf5FJmAUT0M76zNFvK5c
 GyzhxZ5ilEPl4VxyNPOGGI5u87KZWaJ1KVssckoBO832LOf4XmVPYHCNIjRZdotM/F0J
 qj1sLHsNomzmqZ/nB59WTDwW3KcDU6htZGJrewk9dIdhjOkArVUQSeDtjaXhXp/5erjH
 pGMeBPkgMHqGoItOyxvfZeHzrb0m0uG0h2Zw+/go7QH1C0Uwo43havjN/hLRO/V/Inez
 e9WWTq8U9kdPOCNEajZfZcONdmtEe3Q8gQJwu+MfMee3ynkyU1T5t0Zg2llvErCGZsqA
 Tb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ZNLPTbSTlYPZjBY9HcgmDn5JBJ/klYO2bN4Z3HIMVZY=;
 b=sEd3OpHbksZB13hB+QefnflsG5ewQY/EkejJKd3nWj6LzrRIf5NeaFslTLOCUIonZ5
 btIKpOOktHqBmvKfz/vWR2JM6wyziseNHm+0zF4dg/rB1dyB2m+5lSK6qTmQ5xzNWRdF
 CygDA/6tKEsbobYFo4BUCcz/CUFVMk3eJMnxBrfk4eYP+Uo0AAwQnWD0mvLFR3i4ZhHI
 UpXAs1o80Bhz6fVLqz8ENr6LVu276rdWiowmgNd3kCeUAFMsHvka8tX0pPrAgjZ6OJ8X
 tKOjXp2BXWGSDuvhmI1LdkMZT50iUDLf67yAuj52pdNhBJlPUC8Oq/xtAkege4NRA6X4
 0yaw==
X-Gm-Message-State: ACrzQf2ksKuDXRIIRFAtbYJz+yo2t0Tm2dmErgaA/O0e9FClunLzqwOS
 jDSUwXzpQO1kEJm4kyXJlnAJWzc=
X-Google-Smtp-Source: AMsMyM6nmXxJ8Gq+/aWVuDapWKSZFcWfvUUDZ0UKrzoV1+beR/aXVD1kiZHnxs3uVYWp1mJAGj9lGKM=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a0d:d705:0:b0:36f:f574:49a2 with SMTP id
 z5-20020a0dd705000000b0036ff57449a2mr32986451ywd.442.1667524276250; Thu, 03
 Nov 2022 18:11:16 -0700 (PDT)
Date: Thu,  3 Nov 2022 18:10:40 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-8-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 7/8] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
 MTE enabled
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
on being able to map guest memory as MAP_SHARED. The current restriction
on sharing MAP_SHARED pages with the guest is preventing the use of
those features with MTE. Now that the races between tasks concurrently
clearing tags on the same page have been fixed, remove this restriction.

Note that this is a relaxation of the ABI.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ff9a271cf01..b9402d8b5a90 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1110,14 +1110,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 
 static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 {
-	/*
-	 * VM_SHARED mappings are not allowed with MTE to avoid races
-	 * when updating the PG_mte_tagged page flag, see
-	 * sanitise_mte_tags for more details.
-	 */
-	if (vma->vm_flags & VM_SHARED)
-		return false;
-
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
