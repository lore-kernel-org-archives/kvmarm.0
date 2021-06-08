Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B326CC4743F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68FE261078
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68FE261078
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D14540617;
	Tue,  8 Jun 2021 10:12:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Grsn8za-2btX; Tue,  8 Jun 2021 10:12:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A02340630;
	Tue,  8 Jun 2021 10:12:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60CE049F92
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZHEAuTFPAGCn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:12:09 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5423B49FE6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:12:09 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 z4-20020adfe5440000b0290114f89c9931so9454531wrm.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jp6fv0GP5OZMvO++5rX+YJvw+QWeN06SDMdZ+IsoUG0=;
 b=OPGc9RaxdbE4jC3Nv//QuI2Jsufzx1NecG16pksOv0KGZFsu+jQWG8OJ+DQZ/2CDb7
 LFyBKgXQSD1jXRXJSE9x5NaKjdXiIm+GtBtKKFt25YFO9mA79s+SF4YpGXZt1H15X2bx
 2mFt2oQz5XWvE06MsNy05geVWsUOMK7e0gvwzyMUMRKcY1GxXVSD6ET7BGv21Oo48p9W
 0QAvnB+NR2k52p+qiGx5aDr2ji0pztzmJJSg2gFz9Pxhn4VuD9KJA1FYmyETBfmJXzGS
 5o7NPPmVj1Nr/w/77PeoiO4acbt0s0rishsN36LfTVHRZVejvma+yDt8LCXCv2Q7Its8
 oHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jp6fv0GP5OZMvO++5rX+YJvw+QWeN06SDMdZ+IsoUG0=;
 b=ku02v971yz9c5wajNst82udKxA+R/M7ZVXEkAQ5gHJn/Hs+6NaZGwNMY2c4Y/hFQ8o
 49fV8Xzv+kifHec/HzdI0oo7Ie/57eeou/ETWbjKOI0o88de2zyLaIyS5lVVTt/vmKcC
 lSFn5pV4mjaVNTmAe/6n7IuZ4bRbNuKtNAtqitcr3LyYU7q4b4o/m6W6HlcBOyvDgbUT
 2O1jgSBR8Kxq7TmWAOZIDQYxJ41o9G8Ajtfrt9/dIED/pXorc10qAZ3/amT+DNlR3r+3
 2oxcIAZzVbnhyusiMYRAr0hH1GMTe/demp7ryMt7LMV3oKxkMTJe0Zaej73BDoM9cngg
 kuWQ==
X-Gm-Message-State: AOAM533GGqFWxnvpoO2LzcL7uEHxm40Ee5Y1s4N2ientSMZ/Epq6Hufm
 Kd9N2+BLIWTgpMRavJTuGtYMSvdHqrnCh3izuDfdnf5lAmghtS6VePZtJ2eFbIE2dYcT2aFaGL/
 oKJm+7PJOWAELp6q7yuQ5IY6wSRExcKM9jwwEWlMKFtq7aK7b6m5YFSBxR2pDbJV6IoY=
X-Google-Smtp-Source: ABdhPJyHhizcjmweSCmSoFGB2PMDem+2OK12rFn1TS9WE8cTt6h356mgLMjU2sM0rpQ3SM5oD2nnES3tfw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:cc8f:: with SMTP id
 p15mr4535235wma.111.1623161528421; 
 Tue, 08 Jun 2021 07:12:08 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:40 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-13-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 12/13] KVM: arm64: Handle protected guests at 32 bits
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

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d9f087ed6e02..672801f79579 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -447,6 +447,26 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
 
+	/*
+	 * Protected VMs are not allowed to run in AArch32. The check below is
+	 * based on the one in kvm_arch_vcpu_ioctl_run().
+	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
+	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
+	 * CPU. If the hypervisor spots a guest in such a state ensure it is
+	 * handled, and don't trust the host to spot or fix it.
+	 */
+	if (unlikely(is_nvhe_hyp_code() &&
+		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+		     vcpu_mode_is_32bit(vcpu))) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		goto exit;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
