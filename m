Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C80C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85CAE60F58
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 85CAE60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 349B44B15A;
	Tue, 17 Aug 2021 04:12:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oBBmI61vSq23; Tue, 17 Aug 2021 04:12:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC2C54B193;
	Tue, 17 Aug 2021 04:12:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 973624B14C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eggSPytYPAW0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:12:13 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DFEE4B164
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:08 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 e3-20020ac80b030000b029028ac1c46c2aso10725777qti.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GwBibOWYXter2+CeY3r4WjkndBFtBCh1zMuQU5reF9A=;
 b=TaP5HLSckkUY51veXyfP8aLq+lpBiNGYeORdB1m4e2OGEMWyXysqyPJyKmc2EZNCfT
 b+BUDY7wqFaCh1GTw+y3WhaHIuLBAXcejHOZ1kIT1UVJKPD0DTkOR9zpQFlGtSut54Ve
 6FcMYxuttHsA//J8xglMwAWQCdnipLpW9fhs0u+809xR3ZywlmJvTe96+EukUGktBjmr
 aFtP6OzyrKvd1jZCbUsvkpDwUpjW/98ueluGuPPWIjSy046HBebTfZ5xeJ66cDRvQgzH
 /ewp8xIjK8m9eN64A9+NmEsmtIEtg8Wi7yInIrgXAa3JA+Y7iFlP1iATJHT0q5tn9PCG
 RsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GwBibOWYXter2+CeY3r4WjkndBFtBCh1zMuQU5reF9A=;
 b=kjDJiV/hbiDkbbSWnbMRKcUWe+0Sq5gwoqg3bnVKbu34OZMQ76282gqRiWy7nHQ+1k
 ou5dGBO6m17abaeg2bndwvTZFCkl3JHJj3FDb8gbM0KN6HnuuYRfp4nxNmY0lvXs0MyE
 A1/dXJg5K5ONDB/sCusJKjOqyq89/Nu3BZuJXNBLo2fHPru0OO5yApgm4J5IwICmnMnX
 7IRDefcMJe3u+Dd7exv2fIwsNWoO8OzQg3YTNAeF5UonPKRn1twC5SBTqQWgusRmiA0e
 2Btbsj7yePQih1Zf81FHUzdNaRiFDvE9ytvlVLMz1s0/K380lWgOqXc6Ez6leqD8c8VA
 rj1g==
X-Gm-Message-State: AOAM533uXezEWyeGFky2xl23ZJetlCs6VIWcK4SvfdMujbHgyvINGvsp
 e3EAXZRntM5n5ajaf5pv8S64HL3ljSOORj64yZ8JWnV5fK+kd/dO/Yk2YdJatW6TUxaTOQ1MSTz
 Ko9D09QWuW5E/gTM6y508DSyOPlmP8K2LjuuxIU3GxVxeK8z1Rwme8ToyI/eoRrrWRgE=
X-Google-Smtp-Source: ABdhPJzdIqbLAYM6kPwUzmsBpGGJcl8EyMI40ZKNefrU0jERoj9lntCdBUE9/mgLqEPe2aj2UczmekLMtQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:902:: with SMTP id
 dj2mr2109786qvb.62.1629187927890; Tue, 17 Aug 2021 01:12:07 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:34 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-16-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 15/15] KVM: arm64: Handle protected guests at 32 bits
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
 arch/arm64/kvm/hyp/nvhe/switch.c | 37 ++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 398e62098898..0c24b7f473bf 100644
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
@@ -195,6 +196,39 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
 		return NULL;
 }
 
+/*
+ * Some guests (e.g., protected VMs) might not be allowed to run in AArch32. The
+ * check below is based on the one in kvm_arch_vcpu_ioctl_run().
+ * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
+ * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
+ * hypervisor spots a guest in such a state ensure it is handled, and don't
+ * trust the host to spot or fix it.
+ *
+ * Returns true if the check passed and the guest run loop can continue, or
+ * false if the guest should exit to the host.
+ */
+static bool check_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+	    vcpu_mode_is_32bit(vcpu) &&
+	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
+					 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) <
+		ID_AA64PFR0_ELx_32BIT_64BIT) {
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
@@ -255,6 +289,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!check_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
