Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CF9C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 04:00:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D5A40C0A;
	Thu, 29 Dec 2022 23:00:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bKVRNlt6i3fH; Thu, 29 Dec 2022 23:00:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 813D94B125;
	Thu, 29 Dec 2022 23:00:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B56DA4A0FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 23:00:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8cdemkTz-ga1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2022 23:00:41 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A710740C0A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 23:00:41 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 h12-20020a17090a604c00b00225b2dbe4cfso8263059pjm.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 20:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
 b=TOfBgUI4HFcbvh0KtsNM/9/o1ljcx4Cqad/F/ADZ81uGH6f8ziU+OldSZqnTjldSar
 WiTR2PvRUcHB3sXXEtotTUdzx4cHCeMEK4s9CaNx3M6rjrf8UpWKtK0lVBRkXGG7R0Ow
 wSC57/bdkzgNWhmjfxLHoHJ35ZeTliLCztAxl5oolvneqPKe1VPfDBAzaAQNl2kAdTJC
 RoZX7y2q/atgIXWgzJIuX9jklibMxhBblRPCYOM1xZRGMbe4837LKDw+Ldlk99ynPvAH
 jfY654Fy62qyUHhAbxsK6w4Htvnzuc6dL+oKNVpX2FOq8bE6D+hKT8xAfCWfVozN+KXH
 4icw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
 b=SPbjIWZ9FSrFOvFfXA1f3XXrdlo9QM0hnX/Z3XZoII1KnN7bOoCgHsVH6xn/lTm4N+
 wbNSg/XuivZx4I3W9J8SVimDT6Czs/YvtdbQ+XvRis5WhAHP0lys/SO7RiBB4AafSWUb
 jfAEomg8PyUIZGfFSaVaF8qRo90KMeXSq0wmj5zHrNnxleV6o6DbxJO7oIafDRHDtpQr
 sjTqeoZlHEbgs2WuF+GUi2Cj0w6IUuBMPEvTF6fDin4o+HcquoIGNruLEnXUQ1DckFyf
 Q5w6H8U1DOITG0AuHu63DLiPO2XYn6AGmRR3mO9n1cBEfC4YxOjc1CukT5tbHHTfXm8I
 l4XA==
X-Gm-Message-State: AFqh2kpugUgXm2WD6Vm3F2/T1d14YRHfumYLCrXE6nE69cftQuhEria6
 shw+Y5UBo5VxKkWlLsvASGeOZHZtXZk=
X-Google-Smtp-Source: AMrXdXsA4iCBx3qhY8WnvROWXZ/axMqc2KCGoEEEIPQYkLStYSSjcl0e/rJxaFRrNWsrhr+FV7fmOU0gHls=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:902:70cb:b0:18c:1bc5:ab84 with SMTP id
 l11-20020a17090270cb00b0018c1bc5ab84mr1583115plt.105.1672372840749; Thu, 29
 Dec 2022 20:00:40 -0800 (PST)
Date: Thu, 29 Dec 2022 19:59:24 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-4-reijiw@google.com>
Subject: [PATCH 3/7] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU
 reset
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvmarm@lists.linux.dev
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

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the host value by default. Userspace can set PMCR_EL0.N for the
vCPU to a lower value than the host value using KVM_SET_ONE_REG.
However, it is practically unsupported, as reset_pmcr() resets
PMCR_EL0.N to the host value on vCPU reset.

Change reset_pmcr() to preserve the vCPU's PMCR_EL0.N value on
vCPU reset so that userspace can limit the number of the PMU
event counter on the vCPU.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 6 ++++++
 arch/arm64/kvm/sys_regs.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..937a272b00a5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -213,6 +213,12 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		pmu->pmc[i].idx = i;
+
+	/*
+	 * Initialize PMCR_EL0 for the vCPU with the host value so that
+	 * the value is available at the very first vCPU reset.
+	 */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = read_sysreg(pmcr_el0);
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4959658b502c..67c1bd39b478 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -637,8 +637,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	if (!kvm_arm_support_pmu_v3())
 		return;
 
+	/* PMCR_EL0 for the vCPU is set to the host value at vCPU creation. */
+
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr = __vcpu_sys_reg(vcpu, r->reg) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
