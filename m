Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACFDC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 00:22:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1EA260EDF
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 00:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B1EA260EDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8C54B248;
	Mon,  1 Nov 2021 20:22:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pb34FmuFRuiV; Mon,  1 Nov 2021 20:22:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C835D4B240;
	Mon,  1 Nov 2021 20:22:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEDE34B245
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 20:22:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZQLyp9FiJYtA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Nov 2021 20:22:38 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A9E34B1F0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 20:22:37 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 134-20020a62198c000000b0047bf0981003so10258083pfz.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Nov 2021 17:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=q8+WFsVbgm29AAf/AGwas77W0K8xwgbmPl1Tstb7QWc=;
 b=b7OJ80GPH2oQgQ9tb2V+6/eW0GWKJVLr1PWxB8v4wFAwbzrU4pUgP2cI0Riz7azO5G
 Z+6rcFj7+griGUkir/2Gug4bGdUYN2p9f39RS0Ie9f5uSe6HaSA/mFLmkPgf2GQpbG0d
 5Uj2XEj05Mj2qzm0yYL9Dk4pz0EAn5W63XS6fNeOr6NTWCR/dHkpIRmXhIJtQkan6y6X
 /fqFwxj9iuYkiqbKxdWhd3ZvXyHvUTgQJa4OqwCSyt0QI4PWOnfljN5xnAgMSEk27aTJ
 kZ/8kU5lGgkp1PHOP2Rmza2Vvq/QL7beU+QmLk/l2Gi6o3hXyrVojRzFmnd0YUwtPd1I
 W03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=q8+WFsVbgm29AAf/AGwas77W0K8xwgbmPl1Tstb7QWc=;
 b=ELqis1vqE02DeyujTU5wE/No3l8jRVvkDplY7Geh3Uhdtk6nNlarlNgN1nGbFYbQy/
 wIfGqyiKoZioHiLto1b6Yb3fRFHrnqlAEuCUhCIq9DpyJZ8b60Xo1IfUl1TOHQ+km8B3
 0JJQbTIyyvg1gzDWhPIz7zD1lOVJ71t8n5qw/P6nHzpIn/k+TLmW7DKGJCDUBl/C+sk1
 gAIxfuKLnGWhdHy3aJsKHPCqy1Lf92vs5Y1CWUDoM+TqJX+wXgs3PHNOGDW6FckchJDP
 B54yKUfamGA8ewpnIXMk1ARw+9uQZg3l7XpFBJ4a9r2uCg9FutoBdEjPNZ2ieQZcvS9/
 lABg==
X-Gm-Message-State: AOAM530Cj82bPgrUJXYSBQ6i6yg+iwJlUFovnxU0S6jkr+Q5WeuS4P1c
 tx4Jrbdk8/kqooK0Eq683ESwMQjKMJ7/
X-Google-Smtp-Source: ABdhPJwek5nlon1tiWB/vxBvYaoxxIt+RqFeK0GQlOxIF29WacF2NwA+ysmja9uIeRDDlLhNWR7SRXVq/jT7
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:4a82:: with SMTP id
 f2mr2615207pjh.236.1635812556766; Mon, 01 Nov 2021 17:22:36 -0700 (PDT)
Date: Tue,  2 Nov 2021 00:22:01 +0000
In-Reply-To: <20211102002203.1046069-1-rananta@google.com>
Message-Id: <20211102002203.1046069-7-rananta@google.com>
Mime-Version: 1.0
References: <20211102002203.1046069-1-rananta@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH 6/8] tools: Import the firmware registers
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Import the firmware definitions for the firmware registers,
KVM_REG_ARM_STD, KVM_REG_ARM_STD_HYP, and KVM_REG_ARM_VENDOR_HYP.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

---
 tools/arch/arm64/include/uapi/asm/kvm.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..a1d0e8e69eed 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -281,6 +281,24 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
+#define KVM_REG_ARM_STD			KVM_REG_ARM_FW_REG(3)
+enum kvm_reg_arm_std_bmap {
+	KVM_REG_ARM_STD_TRNG_V1_0,
+	KVM_REG_ARM_STD_BMAP_MAX,
+};
+
+#define KVM_REG_ARM_STD_HYP		KVM_REG_ARM_FW_REG(4)
+enum kvm_reg_arm_std_hyp_bmap {
+	KVM_REG_ARM_STD_HYP_PV_TIME_ST,
+	KVM_REG_ARM_STD_HYP_BMAP_MAX,
+};
+
+#define KVM_REG_ARM_VENDOR_HYP		KVM_REG_ARM_FW_REG(5)
+enum kvm_reg_arm_vendor_hyp_bmap {
+	KVM_REG_ARM_VENDOR_HYP_PTP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP_MAX,
+};
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
