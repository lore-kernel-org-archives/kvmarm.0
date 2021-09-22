Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E6CC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F6BC60F13
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7F6BC60F13
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32BDA4B0C5;
	Wed, 22 Sep 2021 08:47:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PjSk4r+9Pu6p; Wed, 22 Sep 2021 08:47:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C48714B0C3;
	Wed, 22 Sep 2021 08:47:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0BF4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3T+HDuDsOgjp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:19 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C83B04A19A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:19 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 e22-20020a05620a209600b003d5ff97bff7so10696069qka.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CzbIlsH2Bae6d1ohUhEXXMHc1BqJcEJ9GIPtvLTyUfA=;
 b=rVHWBTr+ChOeXTeurOu+v+1CwFDR2HJVvNknRU/O8EN6WJBhCyhU1JsMDyDbYX7e2j
 gShaBT1v5OklVRbcq+ZHzBlgrnkbeNelVoK+r8WrwHJggXyrWzyjL66vv+e+rjJWzt9z
 f8JBkLd7VVi9ZgG2Y3aI0k2ArWCOWOcJHi023g1LSaCRj7J40bY2+NtZyz3awLWBP7Uu
 460hJb28W88+rdDfdlIxzuysUwIwTf8uWZz5jO7OPY1Mm7FE/e/6K5xondK38E/cI1od
 DHvkROjoqmK6czAiQm73zjKTkPITnirwf9nnPX5qs9FUSB4Z/99PAjlr8XD5tukLQkLw
 /60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CzbIlsH2Bae6d1ohUhEXXMHc1BqJcEJ9GIPtvLTyUfA=;
 b=BTs3d3dKhGvCrzm736ClCmRgkqdU7Vzy3rRXbdg2Rq7CchV7aorlGoI3hLaM2aXFFD
 7/NMNjmtrazNi+KALVYTygSHzYYD+gXTwesEd5uYb+a7uqptZN8PF7KlqjI60N4ZyzCr
 vnR7fEYCrxG9waVzsnieIMvPazEJkR+i8E2F39sLvQvvp11LsyrjSg6qXIvWAfb4uTVC
 oQI7dxZxauv9TBBEmWz4qi2IHxVLbTZ3MVx5wSTksOTCzhZBf2m6VhE9Y4audwyOQ6A1
 17RogEaP+inl6W31SLPomf8+wtU8Pl79WzAGIuBW1CT/nDreOVInQp51RYclmzupwgwH
 FbjA==
X-Gm-Message-State: AOAM531/FPanRokDKxxSDYLkGMlwMCKCG9Htbkpuunklno37nXlJEiyr
 usXJiTzsSmrXhDT0jP67FsUiJpyKSUjCqsCqr2AX2/2Xg/5qGtDWm/WNAiQqGMXXRQJbtJ4AsAb
 KTqL8EJzvJvWZP6E3sLIE7hzcAsZ2fiDMfEgat6jv8QN4ik7SuqflxWXhBXwhmfm46SA=
X-Google-Smtp-Source: ABdhPJwDDPHHqyL5m+7ppFVDXADAk8bgN9FGXTlQ7s7v5LJH3sv6Jt4+umRRpSGlND+gPox8E6lKgwV4fw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:ab51:: with SMTP id
 i17mr12629786qvb.39.1632314839330; 
 Wed, 22 Sep 2021 05:47:19 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:46:58 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-7-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 06/12] KVM: arm64: Add missing field descriptor for MDCR_EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

It's not currently used. Added for completeness.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_arm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 327120c0089f..a39fcf318c77 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -295,6 +295,7 @@
 #define MDCR_EL2_HPMFZO		(UL(1) << 29)
 #define MDCR_EL2_MTPME		(UL(1) << 28)
 #define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HLP		(UL(1) << 26)
 #define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
 #define MDCR_EL2_HPMD		(UL(1) << 17)
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
