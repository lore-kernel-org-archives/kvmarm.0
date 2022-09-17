Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516F8C6FA8B
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 01:06:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD214BD37;
	Fri, 16 Sep 2022 21:06:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fgsTcgU6nsKr; Fri, 16 Sep 2022 21:06:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D506F4BD3E;
	Fri, 16 Sep 2022 21:06:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 222A44BD35
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJSdUZrPJGSa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 21:06:12 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF08A4BD23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:12 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 bu13-20020a056902090d00b00671743601f1so20101808ybb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 18:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=vvtE6TLaYPOCtfXk0O9FalggG3OGcnP88HBgikw4s3s=;
 b=ZS8EsXPJGtNTPDBSTFPeNymnL+eydmn5nRgAQiRgoh63nhdGTzOadgQMU53fsLn7vZ
 wyev2+MfrsanzyzIOq70pt1twN+lQLFEiarxgaLxdPOkrq2OZm1QoR0zbj3KqkoE427Z
 YatrzLJ4U1Qz1IUv2ublq6USSdxp1r0mjww105kH1EY5muqDOo7sBqhVPR0R8MU5Zsyp
 GkGSAk2LHIMqsfqJz8F8TSBUM9hXspKDyQNjs7qt0Gm511ZOS8tdFpf5kTQkQakbc/PE
 kc/0ZRUg2PqahDYAMM2N3CbJ6ZKl5kWN4dbhORr0VvI+EZHCar4hhJBeh2pNgIUdhczW
 Ii5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=vvtE6TLaYPOCtfXk0O9FalggG3OGcnP88HBgikw4s3s=;
 b=y8fw/DFNM5rE8+gmgG5FdvINtlqzJ3Zpbxw346nOJQ0zNsDjgHDciGOzDfzmhA4hz1
 7xQTyfgDuArWuzpZ1wF5vO4bQTZyRsaEMjE9Ip5XqktugSHk4J3FceRzPKNN2C0lh93z
 g4x6HEuzkmvTrgHbOfIm691HiZdDDrK22LKzi5mMGiSi2W9TFi3ueuK9sKQYKGu4v17T
 BsA1KeQUarq0snnEEMphgB2pmNSc1asQH26e3Y6zgCEGJ74xC8J2rgbHqIPUBnXFKZmu
 tXHHCd2KP4NKxlbUFnssk09SGB7Z1uhqTyQ7hZZh2B2E9J5ZhxG3JEaEO2pLh8zZbtWb
 V+SQ==
X-Gm-Message-State: ACrzQf1P46XZf1dXle0lbPQo+4fKPl+a1/t4XZUl84EDIeb2ojiWZzJm
 dXWUv5KUJ1TGTiSh6yQIS80b3fyJSd4=
X-Google-Smtp-Source: AMsMyM5s2RuFF4UFZBuj9Fx+pU9qkLjM1BVQwNejQE34KqLu+nW0MZjqstMEQeQCvo5RW6Lc97Yj1VOZmlQ=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8704:0:b0:6b1:302c:ad63 with SMTP id
 a4-20020a258704000000b006b1302cad63mr3468976ybl.67.1663376772490; Fri, 16 Sep
 2022 18:06:12 -0700 (PDT)
Date: Fri, 16 Sep 2022 18:05:57 -0700
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-2-reijiw@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Preserve PSTATE.SS for the guest while
 single-step is enabled
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

Preserve the PSTATE.SS value for the guest while userspace enables
single-step (i.e. while KVM manipulates the PSTATE.SS) for the vCPU.

Currently, while userspace enables single-step for the vCPU
(with KVM_GUESTDBG_SINGLESTEP), KVM sets PSTATE.SS to 1 on every
guest entry, not saving its original value.
When userspace disables single-step, KVM doesn't restore the original
value for the subsequent guest entry (use the current value instead).
Exception return instructions copy PSTATE.SS from SPSR_ELx.SS
only in certain cases when single-step is enabled (and set it to 0
in other cases). So, the value matters only when the guest enables
single-step (and when the guest's Software step state isn't affected
by single-step enabled by userspace, practically), though.

Fix this by preserving the original PSTATE.SS value while userspace
enables single-step, and restoring the value once it is disabled.

This fix modifies the behavior of GET_ONE_REG/SET_ONE_REG for the
PSTATE.SS while single-step is enabled by userspace.
Presently, GET_ONE_REG/SET_ONE_REG gets/sets the current PSTATE.SS
value, which KVM will override on the next guest entry (i.e. the
value userspace gets/sets is not used for the next guest entry).
With this patch, GET_ONE_REG/SET_ONE_REG will get/set the guest's
preserved value, which KVM will preserve and try to restore after
single-step is disabled.

Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e9c9388ccc02..ccf8a144f009 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -393,6 +393,7 @@ struct kvm_vcpu_arch {
 	 */
 	struct {
 		u32	mdscr_el1;
+		bool	pstate_ss;
 	} guest_debug_preserved;
 
 	/* vcpu power state */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0b28d7db7c76..1bd2a1aee11c 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -32,6 +32,10 @@ static DEFINE_PER_CPU(u64, mdcr_el2);
  *
  * Guest access to MDSCR_EL1 is trapped by the hypervisor and handled
  * after we have restored the preserved value to the main context.
+ *
+ * When single-step is enabled by userspace, we tweak PSTATE.SS on every
+ * guest entry. Preserve PSTATE.SS so we can restore the original value
+ * for the vcpu after the single-step is disabled.
  */
 static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 {
@@ -41,6 +45,9 @@ static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 	trace_kvm_arm_set_dreg32("Saved MDSCR_EL1",
 				vcpu->arch.guest_debug_preserved.mdscr_el1);
+
+	vcpu->arch.guest_debug_preserved.pstate_ss =
+					(*vcpu_cpsr(vcpu) & DBG_SPSR_SS);
 }
 
 static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
@@ -51,6 +58,11 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 	trace_kvm_arm_set_dreg32("Restored MDSCR_EL1",
 				vcpu_read_sys_reg(vcpu, MDSCR_EL1));
+
+	if (vcpu->arch.guest_debug_preserved.pstate_ss)
+		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
+	else
+		*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
 }
 
 /**
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
