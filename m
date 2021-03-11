Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3931BC433E6
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:00:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A1A164E58
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A1A164E58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1993E4B6AE;
	Thu, 11 Mar 2021 05:00:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eb2WoJdTaEQW; Thu, 11 Mar 2021 05:00:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 446644B702;
	Thu, 11 Mar 2021 05:00:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 375374B6AE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:00:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rqTITOtTope9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 05:00:29 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE6094B4C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:00:28 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E76E164E28;
 Thu, 11 Mar 2021 10:00:26 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lKI7F-000xb0-2f; Thu, 11 Mar 2021 10:00:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: arm64: Reject VM creation when the default IPA
 size is unsupported
Date: Thu, 11 Mar 2021 10:00:15 +0000
Message-Id: <20210311100016.3830038-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311100016.3830038-1-maz@kernel.org>
References: <20210311100016.3830038-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com,
 kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, stable@vger.kernel.org,
 Will Deacon <will@kernel.org>
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

KVM/arm64 has forever used a 40bit default IPA space, partially
due to its 32bit heritage (where the only choice is 40bit).

However, there are implementations in the wild that have a *cough*
much smaller *cough* IPA space, which leads to a misprogramming of
VTCR_EL2, and a guest that is stuck on its first memory access
if userspace dares to ask for the default IPA setting (which most
VMMs do).

Instead, blundly reject the creation of such VM, as we can't
satisfy the requirements from userspace (with a one-off warning).
Also clarify the boot warning, and document that the VM creation
will fail when an unsupported IPA size is probided.

Although this is an ABI change, it doesn't really change much
for userspace:

- the guest couldn't run before this change, but no error was
  returned. At least userspace knows what is happening.

- a memory slot that was accepted because it did fit the default
  IPA space now doesn't even get a chance to be registered.

The other thing that is left doing is to convince userspace to
actually use the IPA space setting instead of relying on the
antiquated default.

Fixes: 233a7cb23531 ("kvm: arm64: Allow tuning the physical address size for VM")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 Documentation/virt/kvm/api.rst |  3 +++
 arch/arm64/kvm/reset.c         | 12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1a2b5210cdbf..38e327d4b479 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -182,6 +182,9 @@ is dependent on the CPU capability and the kernel configuration. The limit can
 be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
 ioctl() at run-time.
 
+Creation of the VM will fail if the requested IPA size (whether it is
+implicit or explicit) is unsupported on the host.
+
 Please note that configuring the IPA size does not affect the capability
 exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
 size of the address translated by the stage2 level (guest physical to
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 47f3f035f3ea..9d3d09a89894 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -324,10 +324,9 @@ int kvm_set_ipa_limit(void)
 	}
 
 	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
-	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
-	     "KVM IPA Size Limit (%d bits) is smaller than default size\n",
-	     kvm_ipa_limit);
-	kvm_info("IPA Size Limit: %d bits\n", kvm_ipa_limit);
+	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
+		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
+		  " (Reduced IPA size, limited VM/VMM compatibility)" : ""));
 
 	return 0;
 }
@@ -356,6 +355,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 			return -EINVAL;
 	} else {
 		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > kvm_ipa_limit) {
+			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
+				     current->comm);
+			return -EINVAL;
+		}
 	}
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
