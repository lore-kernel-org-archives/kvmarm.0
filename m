Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B743AC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6932161058
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6932161058
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8114B0ED;
	Sun, 10 Oct 2021 10:56:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2gBRp2+Kd1uK; Sun, 10 Oct 2021 10:56:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5E54B0CC;
	Sun, 10 Oct 2021 10:56:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 185A24B09C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJ3SihXsgWhn for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 10:56:51 -0400 (EDT)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 229FF4A500
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:50 -0400 (EDT)
Received: by mail-ed1-f74.google.com with SMTP id
 v9-20020a50d849000000b003db459aa3f5so10905631edj.15
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 07:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
 b=rp+JkjIo4z20TVZIDlSIwcTFY4aSNLPZRbRvWkOYVJDpTN4kkc4kXKzj4zL1XqqLD6
 MAwZqs/RrSgf0IYgMqBgWKZYmmpqhy3KmVaynpWh9HHyGMXUXUcM29ar8oufFOa5aQ2N
 lINiptI6aVJKGvrvTUjakeU3dSpiVoKdo/XZgog7T57pZp9EcAyJKpppiUM40z7tR80X
 1UftZdYHjRvUcOFi3KF74SM+84H4frlKpmMrGdCI1Cn+3svn0f/GGhiK5N/LeL1cKKDt
 qDhPHsxNNRvruisMmkCZJJclGsNKHNIAe4WG9EEW7err/CAn71dkVA66KFkvXOcuJysR
 L1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
 b=hsNnB7KpOZqI5cm0I0YLL27nnoc6B/XxDrJaSbgXnFDS5lyMKrbHcmkeKcoMJfHstf
 WAr8sZXLqz65wwljUvMccL1IzFJfl2bK0MJom+wsJKO4MoTI+GjKskrrEVwKZKwrfOqP
 2p4BgFwViEE5wInVeggux1QoXJh4kpsiA4ea34COfbeDBRC+DImfzXm1YcxaOIGI4uCT
 Kcxc7NDIQQFw9oUEOKzSjt1Ifmug2QTTsq796XriUy2Fx7lpvNe6ogu+Q1jQkPY1F2m9
 ep/l52I595bmwEzLGi3uvYruMFqV1b2j3VmBT1lr8rNSQ7DsNDsuwOSgeRm6vJDe+ScB
 CRiA==
X-Gm-Message-State: AOAM531PytJcYH3aXut81becjjhXz/lhHi7+lLzbsClbkOLtdPXTpCQg
 faTIVsimMk811tsZSrj/imWvQmIPd0x/vU7dYMBpzXnV32ZxrXkKKwcCJpv874KnjSx8lYN3Iy0
 SLZaLdrM0Knq8ycPYYySY4Dk2pq7Prf0RrAY4yp3IXkZ/JSEOTzcYLJLUOjh8OMqCNA4=
X-Google-Smtp-Source: ABdhPJzpTkGFIK4j/LTFwoQ2gf1pAyDRXSmWmhJdD0DXhgP3O9zDkvzBU1J5GnrnGKvcXFBgRmmgtFV55w==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a50:be8a:: with SMTP id
 b10mr32770711edk.235.1633877809045; 
 Sun, 10 Oct 2021 07:56:49 -0700 (PDT)
Date: Sun, 10 Oct 2021 15:56:30 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-6-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 05/11] KVM: arm64: Add missing field descriptor for MDCR_EL2
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
