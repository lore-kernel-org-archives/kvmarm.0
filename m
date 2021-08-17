Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45816C432BE
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A79EF60F5E
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A79EF60F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E8F4B154;
	Tue, 17 Aug 2021 04:11:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hqfhIkaH9Rtk; Tue, 17 Aug 2021 04:11:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F8824B142;
	Tue, 17 Aug 2021 04:11:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B0C24B142
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PBEenkV7Iuhz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:11:39 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1553D4B141
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:39 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id
 di3-20020a056402318300b003bebf0828a2so6169183edb.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+tR0t5ZUJ91bnVp6oIhXSHEsqTp4Y29yczYOBvuJUDo=;
 b=NkOZvmbOv9x7PRjOB97t/mkx29EdEllMNyS1WbW9rr6vvm55DXlOL+NC8ig0QTdjE7
 B0GabQwAfdMe6C43xuYpSxLYBcoRBhgVbUE0tQTQNimpEflvOT0w067ujp74lgdKdM7C
 nhEpQC/34RYPE7t0RpUBx0dsexU9U+VkSgvni3sZDem72nxGUMRPHl/zo1gU0f3hSGGU
 J3aQFvR+GkR6+FEd70H9mmM3ItdbPf//Moto1u1lGfTs1BaNShyRYEJlz5Tb1+HR5gMl
 qq6ICC9g/Chjg/h/fHkx+qUV4mU3zz+0fDGprCZaV4GaQ1BTYrLvpbHHFmUfXnAFGhAk
 vowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+tR0t5ZUJ91bnVp6oIhXSHEsqTp4Y29yczYOBvuJUDo=;
 b=WXxxrLKENYLncovfJaESo+qU4VLFOWGznmDyKPkga86i4VPUYNPXuQ/p9Fak3wL0vN
 f5qXMEyrp7yShJPNlnFB8TSxPlXIYAqvd0zALdm2gJMYYDEMa1xrvBFBwmuqBUXgHEQS
 5dgUjIRMt9/ySK0FW94uCuL5QIrxc5D5e1ZYU93IxvyYnRH6FV5gDtkKyPr4DaQjVILJ
 bulAvJMtXFdbXE3Z8IlIrVtt5t+8bpEM3dUEfcUutnNijJV/TwTp7M1kh79OWQWh1ND8
 CvOVCk975IzOTMeiypUXiVce6UUYiri1PEt9Aw9IP8p6bFp/Hj54E4bxBrOntDUyyJFL
 nYfg==
X-Gm-Message-State: AOAM531uncj+IvfJx3jR4ey/SOn7Cr+UvA7MJcNc4sL8N96VhmIVmjf/
 S8JW8AkrD4Tlz6LqYNfvUvc4BowA2dT9FvBbj2aKwwtNyWWiHlela3jD4EX+LlHYwmesTkRO/9/
 1cmyhGr1xTgLtP70geQWYNiEhF+X+u69JC7Dydg3Nclyh+jaSER8qtr9LV4joHoEfWJI=
X-Google-Smtp-Source: ABdhPJxrm0L18Up0kCD8WqZDsdLtZDpsbuBf9GX5oRdLeJAUH+fDDBpze0tGJ+Zd9PZQHh79BqPRr1gzjg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a17:907:1750:: with SMTP id
 lf16mr2655793ejc.242.1629187898060; Tue, 17 Aug 2021 01:11:38 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:20 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-2-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 01/15] KVM: arm64: placeholder to check if VM is protected
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

Add a function to check whether a VM is protected (under pKVM).
Since the creation of protected VMs isn't enabled yet, this is a
placeholder that always returns false. The intention is for this
to become a check for protected VMs in the future (see Will's RFC).

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>

Link: https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
---
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..347781f99b6a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -771,6 +771,11 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
+static inline bool kvm_vm_is_protected(struct kvm *kvm)
+{
+	return false;
+}
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
