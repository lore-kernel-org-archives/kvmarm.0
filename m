Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAEAC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7DB661029
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B7DB661029
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DD4C4B135;
	Fri,  8 Oct 2021 11:58:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jmf+WynF0CKR; Fri,  8 Oct 2021 11:58:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F054B16E;
	Fri,  8 Oct 2021 11:58:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EEFE4B135
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZT7fTXinZPXW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 11:58:46 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47A444B121
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:46 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 d13-20020adf9b8d000000b00160a94c235aso7679063wrc.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 08:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
 b=i/pRriXt3CHyKnmFS1FqK4spN9Y1lGyHor2YjbaqZJmPtizyGB5YVl2YWNQdDK2rED
 OjOfggwsChwZgWrO1lOFVRW0wuTBR/RmRTF42bJGDrG3qHafHvsfVwS52uiasBo4BcbQ
 9sBSimbSX/5vkRRqWl9kAr43lDwk23pKR0Ec2QLmvJIj1HvFc+xzBzvQLURwNBbY4aEi
 3tanzatP5/VfsUO0IQqkIBQTco3dk6QRc/NhX5JijcL+go6HzrB0gvdkhREFDrGeFitf
 e08mrjdfEyHTp5ALIukb1y9FvaO3nuCKfXdeyKvYNSfbFX++yeKnRdl/IGBNd5DjFrYW
 2VHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
 b=bUiEx9sab6+0SCyVrX+nmr21zV4tymIC9QNCB+xv2of8CUqBcai7eelo9OJM/U9tTG
 7x7YgWeDFvnrCs1wbTTm3z5h6/nIo/H5gqt4oQjy14bAihXBny8IYmk5NELvm9N7anzk
 zFiIcHbi8A1AstQoMJn7GaQoa2IQtjql5od6jsGXRMoWYxBk1mXUYQOsQE2sdiPtUy9u
 g99NM5JrgwtzGJ73DKmjjPRHVv8arGgWdbNjbHOycx3e9gHkJ+x77ZJELCJZqMG8DVMp
 fFv/mWmlthDjsCEcxdYjM8q4K8C7uzCwe3IrAgBZEBP9KnUXH0SwyFcH9GAqgJPvgRpJ
 f8Ig==
X-Gm-Message-State: AOAM530kb1Ua6ImXOBHz3Gg7fs4nIj9/GmxItjhu0VyEgGCuyJZcUvn5
 urqTe8qCjZ7TR4U6DISQQpMxqsCiY3bemxIWdsjCqCmO+cESmnqJL2e2VS4wmHvLBDkxFdwlId1
 1sXdWe4c8fzmOsxAn7KiVTJ8VinGOSjUMFPtM3yz+m7qUCQzmVqkvRbAeTNRMRJPP+TI=
X-Google-Smtp-Source: ABdhPJxOsk7AO25uGgC6TRQuZfz5cGyFTJAhMct+vYAVjDxjkvjo/1Ci0Jb5yGJ/JlNHmxU68Ydzgx4w1g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:a54f:: with SMTP id
 j15mr5036651wrb.218.1633708725327; 
 Fri, 08 Oct 2021 08:58:45 -0700 (PDT)
Date: Fri,  8 Oct 2021 16:58:26 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-6-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 05/11] KVM: arm64: Add missing field descriptor for MDCR_EL2
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
