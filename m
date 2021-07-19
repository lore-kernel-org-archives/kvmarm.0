Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5C6C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:03:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1C5761476
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1C5761476
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F9A4B093;
	Mon, 19 Jul 2021 12:03:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cCNfSzAOi0A7; Mon, 19 Jul 2021 12:03:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 872044B081;
	Mon, 19 Jul 2021 12:03:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8FC64A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9eHLiecpL2Sn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:03:52 -0400 (EDT)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2C534A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:51 -0400 (EDT)
Received: by mail-ed1-f74.google.com with SMTP id
 x16-20020aa7d6d00000b02903a2e0d2acb7so9461595edr.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7wkujqQey68d/8KAgY7QxLbL3Tk3E6zx35InqbFhZk8=;
 b=cI1pqIS70PpjVvFSr5jOtpULbEY43W4Q5k3H2M3+Pe6zycfUQ8J+47luWmyhdcQtj7
 LNxHqrAvDi7k9ZrQ99sbopcAZrp3nHUyLPCcBPNXNHZvx6IO2Sjq+TT+uUNxgcRWX4D0
 hrK/zoz2PS3l1iEKbpT8oLy9lelodxEKSRRmt9VX3F0p6thfu4rojU+4Yd/qLgMHp/ez
 VpGefh79ZC7n9pleIODX29EDlrGxzFeLjbnMF+IlxpHlSfvFqr0ESZ0EtoJF7DVEoOGw
 ZvzS7Ubj2jPwojVsgNF86jX6jRATNvOjxY9RH1HXtLXAJxT+9Z3pMek+apc2yM7iYbcI
 +qxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7wkujqQey68d/8KAgY7QxLbL3Tk3E6zx35InqbFhZk8=;
 b=KoKQCQx53YZU/XVPytzSvLHSYn1UaIPFpjfDQzAlleJkbKYOZdxJjvYrNOnLfv74CH
 ObE/XOVv8WaAJiRMZH8NTiRsadFrdcEN7YhcV6OQBYh1jn8FW/kOtBb07S07CjTJuzA7
 4h5hCJ76gHJIcvwsD2GmlRaXdxFUbpb1d16Z1iMBwkNpYMnx7vWUuPNEnNrQi4HiGHBn
 4UOBNvc/cfKHwWmu2IpBgOtCuyXq14n7BFNJEQFHNOzSsLfvEKeB2Wu6Q1GjtHCRMP1E
 Ob6FvdliSK9BKB4l8pMm1W6Bt4Zq9FVut+cnWlj87zqjVzxfhtZoxv9KlA4DjR3tn5qI
 n2bg==
X-Gm-Message-State: AOAM533INYD00Ux0Nl1I6TiDwiqKUS/KLr7wHEbhOpY8G+2RM76GHsip
 Qf3jCL45LquUWACgdJi86WnDb/nwtO6I+n5u5I2ccGn+6yfjdNWRsj4Be28RBDeJhLY8uPC3+9/
 EExXOAB1/1VH+Rs7roQsC0bnSdKNRFwCo/H06YBipwHgI0UxpgVa0XixobkKYRAjf/lU=
X-Google-Smtp-Source: ABdhPJw45jb2VfQ2x2siX2+8lyhQyXfGajRdkU6yAqPnufGi+Y4rw/053/SjjPHbtJCrsvDdQe7auRMpSw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6402:2228:: with SMTP id
 cr8mr35901384edb.309.1626710630758; Mon, 19 Jul 2021 09:03:50 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:32 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-2-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 01/15] KVM: arm64: placeholder to check if VM is protected
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
to become a check for protected VMs in the future (see Will's RFC
[*]).

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>

[*] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
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
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
