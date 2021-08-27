Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29C7C4320A
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6273660FDA
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6273660FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E094B13C;
	Fri, 27 Aug 2021 06:16:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S37Kwv3YXKM0; Fri, 27 Aug 2021 06:16:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4022D4B132;
	Fri, 27 Aug 2021 06:16:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FF504B10D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UKTBDGskb3Wo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 06:16:30 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2669240C88
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:29 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 u1-20020a25ab01000000b0059949024617so3096459ybi.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OOYeyRZ535ASPcJl34CxFAtspma0NaClFfMwCj0zNiM=;
 b=MMJd98j1sjtVGzvY0xoiCe870qLTkNP4IyEZQjgVbqTh/LW07Yma/AMKoEBaiRsBUj
 dYeyIu3MYgqn4+fvSRz06yVW8rA51aG3iAnhHeXZUChsF4s3Q/2HdZxqDE3htmI3Spge
 4rAar8nENLBa+e1WETiUf3djsH0xgXB5IQjIbFL0hRlJ9X2nJM6BPGOYhgul5UDDTeQJ
 48Dh4vIZ6WWqWLpQW4yPpek3U4syFdWh+DNIQdQx3DbPEK0vKCQIchz6vHIAK3r9HGZ2
 /2WSnCl4gskjvR1DCwFmRgraJZmpoPTb8Q+8Xc/vL7iu97iW0K7EcJJ8cj1fc6WItBP5
 Uz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OOYeyRZ535ASPcJl34CxFAtspma0NaClFfMwCj0zNiM=;
 b=odqOomnBVCBbNSJgd+Yqi927SQARMiDag2AJIR9KMEQPOcgzw5d/+QrqZUM1lS7uxc
 zuWQEAva3z0Xg+gz3k9UZmI1JRLzEzq5mA2ef/nU9gyq59k5AEU2tBHIr7r3ggPZzATL
 DGUAUAKz2rRvZUMdhRcBhkEVn1AByk686yGfszsF89Bc59MqNk0pZEZe+zO1cBNx5CBb
 h5ZB26qXuCGbkMLavfTLZKEfw/VfJhLtoXpumAG+VuICtv1bakYBFbiDK4pl0Kw3INk/
 AX26fTEHpvMWbTYEd6Qc4QBHvOy9f2+4QN8Iuk7Xdaji3n3PyHGYekG4G+Vi3SPbXfyu
 O63g==
X-Gm-Message-State: AOAM532WttgvXzAZybXcL61lSXm0LFgiOf+hZZyQfu8uYmiMTFbJHA+s
 LiQmePSnvjq+jb3wxvAkPAwBdE/qns2Ej5XlThrTEnVaml3zv5Lron1cRplytC86mWRYbmoEngE
 FbThVkROivV28g9I0vaK2eByaWg68wpxpZV5kjA6vEuJlvueE9Lnk1svK+omaSmBPy00=
X-Google-Smtp-Source: ABdhPJzT2yWZOSKKQOr1U5pdRkyQythprVXGwwbqFDaS7R+/nXzLrvHZijLvzoQpOLWF/RjJwMsgi571yQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:5b44:: with SMTP id
 p65mr4363216ybb.336.1630059388598; 
 Fri, 27 Aug 2021 03:16:28 -0700 (PDT)
Date: Fri, 27 Aug 2021 11:16:09 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-9-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 8/8] KVM: arm64: Handle protected guests at 32 bits
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

Protected KVM does not support protected AArch32 guests. However,
it is possible for the guest to force run AArch32, potentially
causing problems. Add an extra check so that if the hypervisor
catches the guest doing that, it can prevent the guest from
running again by resetting vcpu->arch.target and returning
ARM_EXCEPTION_IL.

If this were to happen, The VMM can try and fix it by re-
initializing the vcpu with KVM_ARM_VCPU_INIT, however, this is
likely not possible for protected VMs.

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 41 ++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index fe0c3833ec66..8fbb94fb8588 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -20,6 +20,7 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -191,6 +192,43 @@ const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 	return hyp_exit_handlers;
 }
 
+/*
+ * Some guests (e.g., protected VMs) might not be allowed to run in AArch32.
+ * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
+ * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
+ * hypervisor spots a guest in such a state ensure it is handled, and don't
+ * trust the host to spot or fix it.  The check below is based on the one in
+ * kvm_arch_vcpu_ioctl_run().
+ *
+ * Returns false if the guest ran in AArch32 when it shouldn't have, and
+ * thus should exit to the host, or true if a the guest run loop can continue.
+ */
+static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	const struct kvm *kvm = (const struct kvm *) kern_hyp_va(vcpu->kvm);
+	bool is_aarch32_allowed =
+		FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
+			  get_pvm_id_aa64pfr0(vcpu)) >=
+				ID_AA64PFR0_ELx_32BIT_64BIT;
+
+	if (kvm_vm_is_protected(kvm) &&
+	    vcpu_mode_is_32bit(vcpu) &&
+	    !is_aarch32_allowed) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid. The VMM
+		 * can try and fix it by re-initializing the vcpu with
+		 * KVM_ARM_VCPU_INIT, however, this is likely not possible for
+		 * protected VMs.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		return false;
+	}
+
+	return true;
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -253,6 +291,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
