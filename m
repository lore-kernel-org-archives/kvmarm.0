Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BC3C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:57:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C72549F1D;
	Fri, 11 Mar 2022 12:57:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id io+87LGczArJ; Fri, 11 Mar 2022 12:57:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 303E749F20;
	Fri, 11 Mar 2022 12:57:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3299A49EF1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0yKwtV3r9e-Q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:57:45 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0AA2D49F15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:45 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 o70-20020a25d749000000b006291c691122so7972580ybg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iMUX4p8oYYdLskY6YlQfUR43FNfUoWfkZJK4wIrDvVI=;
 b=kbWvR7NSwT//jyD2uA/WkBGtSra3OAWNZLtQDDPfNKfREZh2jH89JBDrkrpTgQ+YNv
 BUozf2+Uo6ONunKNVgwoR5E9m7HxiNyKMvg/WGnR+sSX0XuH3X6nfPaGNxi3vJ37o/lM
 d+e2mKjeL9oPXKYywZpE/b7Xl/51yZO7v1R8Wc8yzsnBcH7u1/IxQKScxbUdOYyJ2EmK
 LOX+JHVm4kFAdEXVqPovN8vrY7fDTjstsHEv/kIjboyaWqWt/BP/PCBTiUiUXfkaA2m/
 FTSD1xnG8bA32t2Mx3cnmlZRYON6s8EvQNUCszZAool1frje4oMd6fFK+SEr9nABWojl
 +9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iMUX4p8oYYdLskY6YlQfUR43FNfUoWfkZJK4wIrDvVI=;
 b=r6DkyqX1dxBV0ILBdt1+SD4JehD7ceMc4NOzB4ErkHC+EZFQuYpZ5i0Cyqesi1vtsr
 CuaWUrbk0E1C3oxY3/mCyAjp/hm+CLp9y2iVKk9gTg/UO0Rmw8oQcwgLV76JSCyMZNWi
 zwtmLGL7VzTtKJD6R79xtIUFH5g9xkKMOCJiP3rqgwDSdefc665CasV6G7sM9THzt1i5
 tux3ERgdcm9nR3CxxoYHYRNRHB7Q0ISxHhXBkDFuSNvLOU2vhZKbx2rtgjfgJlqsT1Gn
 JLv44lJXOsFH66jWvGExYzPRVk6N3QDPHBhFDSclMx2gOlIS/soBR4stM77Klg+SJybc
 udhg==
X-Gm-Message-State: AOAM531vhbZ41xfU3/GGC8JvepDmRTAAungB7pLofTUM72PNjFR5y5OX
 CabpLV4S5fGixdc5p1CcVvQxotWNzJ54IuIfS3U5MtyVO00Wo+D8HttMJ9rWeHDc6eN3w2IECN9
 VckZRDJ+YpyH2OXOeVeWtjNQhtf8Y5CcP+NzeWTDbvrMcGqhUcXYUkMcXcJsajcAlnC3I6Q==
X-Google-Smtp-Source: ABdhPJzPRbWq+blf3W5J139AGKxE7e6TJnEjyAP/74A7vawiP9FcCu7oAu7fi1c5ZnCuQttujGbnOdDK+/Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:d847:0:b0:2d8:1c55:942a with
 SMTP id
 n7-20020a81d847000000b002d81c55942amr9375589ywl.260.1647021464480; Fri, 11
 Mar 2022 09:57:44 -0800 (PST)
Date: Fri, 11 Mar 2022 17:57:16 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-5-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 4/5] ARM: Add a helper to re-init a vCPU
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
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

Create a helper that can be called to reinitialize a particular vCPU, or
in other words issue the KVM_ARM_VCPU_INIT and KVM_ARM_VCPU_FINALIZE
ioctls accordingly.

Make use of the helper from kvm_cpu__arch_init() after the correct
target/feature set have been identified. Calling KVM_ARM_VCPU_INIT with
the same target more than once is benign.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arm/kvm-cpu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 1ea56bb..164e399 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -35,6 +35,15 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
 	return -ENOSPC;
 }
 
+static void kvm_cpu__arch_reinit(struct kvm_cpu *vcpu)
+{
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_INIT, &vcpu->init) < 0)
+		die("KVM_ARM_VCPU_INIT failed");
+
+	if (kvm_cpu__configure_features(vcpu))
+		die("Unable to configure requested vcpu features");
+}
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
 	struct kvm_arm_target *target;
@@ -132,8 +141,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-	if (kvm_cpu__configure_features(vcpu))
-		die("Unable to configure requested vcpu features");
+	kvm_cpu__arch_reinit(vcpu);
 
 	return vcpu;
 }
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
