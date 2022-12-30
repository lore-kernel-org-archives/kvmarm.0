Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DE9C10F1B
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 04:00:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE6C4B688;
	Thu, 29 Dec 2022 23:00:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kVacrlmxlfnm; Thu, 29 Dec 2022 23:00:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D4AC4B133;
	Thu, 29 Dec 2022 23:00:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521E44B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 22:59:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8wCg4RbdSGPI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2022 22:59:57 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BA9340CDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 22:59:56 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-45e2e1d6d2fso218024077b3.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 19:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=1SYJm5JNDxkav0WQdwJtR7PUOPOmz+q4dcky77gCOc4=;
 b=CtHYSYoomRsxseLmDPzoqoYHK094uDWmtIS+mcaBfAMl4yXR5g8VvBGT+MP6t9oVov
 a7PMNLphXcn50C3qT+lfvc86bTtQBxmJzuDt3A1P1JPNUHfkNdt3cIipk30Vt0EkngPY
 za8KN0Y1mKLDUoz8v4G9pypXDzoh4uHowtMnT1cMXmz9SVcRus/mD/E96IBCEyzG4bTA
 UYhWbRv5mfP0Qmp0qs82nydtru1j10DmfPh8Kda+DT/l3xUOjGh8jRz/vmRI0pTGM/fD
 GVwUJ7kNTbgFNdAPtnVYy4ro1xK2t0WCDCSq0CDkMVO0sISbxm/ep2kuVZTx+33YOS8Z
 aObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=1SYJm5JNDxkav0WQdwJtR7PUOPOmz+q4dcky77gCOc4=;
 b=MNj2ost2BUbQlKPobP15WSd/h7KwxnxLtZ1m8oGryEKG5zCb0Bm3FgeNdiEYgJgoWS
 4+oN4wc9uoQ0zqdPnlL5BADH+xkQQ3zX+bJZxwJmtUVuZoZz+2KdvceIMy5ftekzqvBA
 BvaiKIMrbRFlQA7wtIl6dV4bIHnIaP/FWURo4m8uNh9SO/z1ga5VdKVjjKUpbDIARzvJ
 xUJFirfE+HoqwVNoXH1LI2lZUJpGFT2oUO7sugNzu6p0yMOHZZe5MYvf6I0XmfaMsDaE
 D7zqpVR88EL+RCrrQAlt4N/xfWMdYOioSv+dMYOl9W5okS1V1H/m0dCgJKdR22v9154P
 iJuA==
X-Gm-Message-State: AFqh2kqq3twKlGslfGClQjgL6fibwQZxJwYUEtYkiwJSA+f0rPB941d7
 oNkliKBaJWwP+UGI5ugg0+4OAghA5pg=
X-Google-Smtp-Source: AMrXdXvLdndaUF+C3AnEdTc8eaJR11ktcamnCwVT3vgAxLC0xCEa4lAK5Ji3iCN6FUO1z3ovO0zq7Y46r0A=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:dd1:0:b0:3bd:370d:aa42 with SMTP id
 200-20020a810dd1000000b003bd370daa42mr3445113ywn.497.1672372796597; Thu, 29
 Dec 2022 19:59:56 -0800 (PST)
Date: Thu, 29 Dec 2022 19:59:22 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-2-reijiw@google.com>
Subject: [PATCH 1/7] KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
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

On vCPU reset, PMCNTEN{SET,CLR}_EL1 and PMOVS{SET,CLR}_EL1 for
a vCPU are reset by reset_pmu_reg(). This function clears RAZ bits
of those registers corresponding to unimplemented event counters
on the vCPU, and sets bits corresponding to implemented event counters
to a predefined pseudo UNKNOWN value (some bits are set to 1).

The function identifies (un)implemented event counters on the
vCPU based on the PMCR_EL1.N value on the host. Using the host
value for this would be problematic when KVM supports letting
userspace set PMCR_EL1.N to a value different from the host value
(some of the RAZ bits of those registers could end up being set to 1).

Fix reset_pmu_reg() to clear the registers so that it can ensure
that all the RAZ bits are cleared even when the PMCR_EL1.N value
for the vCPU is different from the host value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c6cbfe6b854b..ec4bdaf71a15 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -604,19 +604,11 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 
 static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
 	/* No PMU available, any PMU reg may UNDEF... */
 	if (!kvm_arm_support_pmu_v3())
 		return;
 
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+	__vcpu_sys_reg(vcpu, r->reg) = 0;
 }
 
 static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
