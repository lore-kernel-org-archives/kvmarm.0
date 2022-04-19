Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1BFC43217
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB9B4B1D4;
	Tue, 19 Apr 2022 02:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 67UHJdgWO-Ch; Tue, 19 Apr 2022 02:57:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A14E4B202;
	Tue, 19 Apr 2022 02:57:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085FD4B1BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cRaNdyNhVEHB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:15 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCD8449F16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:14 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 mm2-20020a17090b358200b001bf529127dfso1038938pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DnB6mkT71yKfiG5xjrOUttE90Hmb51/VYCnn9fFtof4=;
 b=ZbU4DI8LNyuRtCFqPLEdyNdwHwoaTlUuA0oTrVeKfChCv8RdXwbrsDjHZp/0f6FQnP
 PZLE4A7NgUR6x0oMr5exTueSSuVho7obJ7dNzlyMTCr7HwLw6BKGJra91wUoMx3wlcb6
 bSQgSXwurkj3VYnxA575UdfzsJ87lzw9afbZ03AYvGQBQjegBxyQqcW+BA/oZie6o1mF
 Yh4sHj8EegW8bDGiPBecdj0wvXoudVP1mUn1WVnV9+uzP0TsHZWRMOL2i/nuqQfZnjxy
 xbyWDd7Or3+beb4xI3uCxytRvzji52R4qg7KmFzoyO/a+cO5Ag0fHz60VLe8FWFkTWw9
 Li0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DnB6mkT71yKfiG5xjrOUttE90Hmb51/VYCnn9fFtof4=;
 b=VmZ6yLWT9T0zjpdzVNbkFGWAsExEDPB/80qEmSoB1O97BbmWIJs2H2/RXp37MhwS/C
 o3WtX9EOLxHGJpWz4Edi+SKpZus8XM/6ArSe9xboTfDh3+fkQlU26oMrSbaKcvJAXeuU
 Y+TRgGFbXfzJm8GdbPYnopAdTtoXGXCm5WDi5MNMtdde35WkEz6R6sPKdyfPQ73B0uLF
 clkL0LlncKmKSLjvk4HZ1jhMrbhEfs2CMkNJgEKm9cJ2WK+Ayd2DiUJ5R9fkJf3RygJr
 mkuuauAyuptqS3wpEDK6yMkU9FGJFt6+6PdTRF1D8bRLWL5DIoqbdnmCJeTTMW/4poxF
 S5rA==
X-Gm-Message-State: AOAM533A4mdW9fet0n3AtXF4o0oB9JNIJNtLN5P27bRePwBBfn8cWfh5
 F3+ZhVo0aBSWaQx+/NUZ9T8fXc3g6P8=
X-Google-Smtp-Source: ABdhPJzKDkHVW1R2MC+Nhg/V/wFyysks9SmrrOZPKWBr9DJqaBdQnJOCmh0zLDSQV1Z/jaqGVIPM47cp9DI=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr276794pjb.1.1650351433778; Mon, 18 Apr
 2022 23:57:13 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:11 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 05/38] KVM: arm64: Prohibit modifying values of ID regs for
 32bit EL1 guests
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

Prohibit userspace from modifying values of ID registers.
(Don't support configurable ID registers for 32bit EL1 guests)

NOTE: The following patches will enable trapping disabled features
only based on values of AArch64 ID registers for the guest expecting
userspace to make AArch32 ID registers consistent with the AArch64
ones (Otherwise, it will be a userspace bug).  Supporting 32bit EL1
guests will require that KVM will not enable trapping based on values
of AArch64 ID registers (and should enable trapping based on the
AArch32 ID registers when possible).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b19e14a1206a..bc06570523f4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1537,6 +1537,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (raz)
 		return -EINVAL;
 
+	/* Don't allow to modify the register's value for the 32bit EL1 guest */
+	if (test_bit(KVM_ARCH_FLAG_EL1_32BIT, &vcpu->kvm->arch.flags))
+		return -EPERM;
+
 	/*
 	 * Don't allow to modify the register's value if the register doesn't
 	 * have the id_reg_desc.
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
