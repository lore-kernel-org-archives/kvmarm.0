Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AA6C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:02:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6294B10E;
	Mon, 29 Nov 2021 15:02:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8osVFd43KPtA; Mon, 29 Nov 2021 15:02:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F34214B18A;
	Mon, 29 Nov 2021 15:02:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87AE54B125
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:02:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uvnau+iq3wdj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:02:20 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEB144B12C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:02:18 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 18015CE140F;
 Mon, 29 Nov 2021 20:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317C7C53FD3;
 Mon, 29 Nov 2021 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216133;
 bh=pIwGsPjTdVawd4oyenBzZnOtLgPUkCj2S2moQP6b3Ws=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=W1G3NO6rkKyTeYqwhmnnqlPbw2Cc3mmcMibzno4ZuXq1Nr+2e6nUFz8XUp/l7aXqM
 LGYln5VcZJ9xnXSijnRjjA/Mwz96UYaUdzRl0EmtHWI/PSFBNwwsfTeyjacu54ojOs
 qgwrXGA3gIJ4ZvSQGHNrz/EPoTL4Oqlt48UHZOHHWYU+cgmDc1FXzcOdKd//nPFkyN
 yfLI2nHP9sq+2yCkNvYKLBXdR/A0yAsrgtjyaqegVY8e9t6KEl1RjgT1Ai1YB10wL8
 sDxPAT1VBxTcazsww7bCTN+YgsEvDRcubItYz6ccdMzw/hh5IDVgimi0HmvH7HLpdi
 K+CcsKEwkGfbw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqp-008gvR-Ae; Mon, 29 Nov 2021 20:02:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 07/69] KVM: arm64: nv: Introduce nested virtualization VCPU
 feature
Date: Mon, 29 Nov 2021 20:00:48 +0000
Message-Id: <20211129200150.351436-8-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

From: Christoffer Dall <christoffer.dall@arm.com>

Introduce the feature bit and a primitive that checks if the feature is
set behind a static key check based on the cpus_have_const_cap check.

Checking nested_virt_in_use() on systems without nested virt enabled
should have neglgible overhead.

We don't yet allow userspace to actually set this feature.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h   |  1 +
 2 files changed, 15 insertions(+)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
new file mode 100644
index 000000000000..1028ac65a897
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_NESTED_H
+#define __ARM64_KVM_NESTED_H
+
+#include <linux/kvm_host.h>
+
+static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
+{
+	return (!__is_defined(__KVM_NVHE_HYPERVISOR__) &&
+		cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
+		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
+}
+
+#endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..395a4c039bcc 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 
 struct kvm_vcpu_init {
 	__u32 target;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
