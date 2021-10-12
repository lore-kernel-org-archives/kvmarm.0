Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAFFC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:37:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81DA16108F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:37:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 81DA16108F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 334F54B08F;
	Tue, 12 Oct 2021 00:37:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ga-QeWX2XUbh; Tue, 12 Oct 2021 00:37:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E5284B173;
	Tue, 12 Oct 2021 00:36:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E79974B091
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TIdNj9X85E89 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:57 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EABF54B128
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:56 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 w185-20020a6362c2000000b0029566b18a88so8034216pgb.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=eIUhuChkelcONVLGBJ0a2MPEEEhxwwehMuijtFOAuDI=;
 b=RuE+yIAI83dgKgc0EI81lpKKKdaCzCn8+SfDwPeU8Fln6xA4/deZlxo2DwtD71VRgy
 cw6TSj8JyRvn5oKLcvmqRuGF7hVSbUVdrEMEKUojpjZyBBQ+tJ1vSUHBrWlg1IuSMZPv
 R+rpCZeNhqGRUmc+stVB+dTUWZ147p6Jjc9tP2WejjahKq68g464d/gR3s99oJIo6lWp
 A/jaKj7gVcm9U7Tzh6Orb4tNznNnOji9vtaNMWche+5EZdUD4rHwml9Y4DQ6LY92/e/n
 yuPPhMOR//Z2EmHt3/Rk9H1biH/MgK7UmW3yEvDk4dlwnyojLI/KFQPcSc40TnGmCYIW
 ZXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=eIUhuChkelcONVLGBJ0a2MPEEEhxwwehMuijtFOAuDI=;
 b=LbJTyeEMG/uXZVJbOlonexE2Yip28BW523SarBLy7DV7amjaMPbivNcPb1RQlmXEPS
 204VVVh4mDY25laTDp65oCuiOX2Bby/puPS/dmyzYRBGctd05SFQ8pbIYxBqR37YRL05
 zbuwpYmwlzl/TShyAhUBKvbn98FeuiUYVFEXr/8I7QK3aqIgSJ5ERLbX0NZdPpXMdKqi
 SWsfBRfQ3cqZex1N/XEBesgfvHNAR4teXQTOmG4P9BcPWsCCAzld2TTl1C5g+NS3L3ZR
 YOmHe+ERmrLZME5Ih5VWb6OJJwVJUBoZGOUKwFXFpX85zAZTXa2+Le3ZPNlI1A/tVlIM
 MJPw==
X-Gm-Message-State: AOAM533caQIj604BkOHypXjvnKXEESGmNTx0OaqOhFfF+IRh0mwvnC7s
 Zz8B+cetAPbaPcFJBXt/ocqEQkPbbT8=
X-Google-Smtp-Source: ABdhPJyTEEEJJ8ULSCGnE5RUuiEtmSCACpElVLQCVz7cpGVyLWG6TLcY5A92rMWKWU0CqVfHfvo0h0Ok6PA=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:902:6ac4:b0:13f:52e1:8840 with SMTP id
 i4-20020a1709026ac400b0013f52e18840mr1435432plt.15.1634013416153; Mon, 11 Oct
 2021 21:36:56 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:34 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-25-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 24/25] KVM: arm64: Activate trapping of disabled CPU
 features for the guest
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Call kvm_vcpu_id_regs_trap_activate() at the first KVM_RUN
to activate trapping of disabled CPU features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 691cb6ee0f5c..41f785fdc2e6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -743,6 +743,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
 int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+void kvm_vcpu_id_regs_trap_activate(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38301ddf8372..6b392d7feab7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -606,6 +606,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (kvm_id_regs_consistency_check(vcpu))
 		return -EPERM;
 
+	kvm_vcpu_id_regs_trap_activate(vcpu);
+
 	return ret;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
