Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927B21C04
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 03:59:57 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-45a51c37009so221206017b3.17
        for <kvmarm@lists.linux.dev>; Thu, 29 Dec 2022 19:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=LMM3980Lc2Hum1TsmsXtviYXs/akeYiNoUNUC/OCeqSwyyZzFFGfSXeVCt9YCRlZXi
         VzygPMDABe4OI57pRRTM7FLEsgH3wLBt//uhxS23sWBjwhxHpOOQwCc4gbTURFW7IECy
         Dtp5UY2zMDFCGExHbwPmZGyDJ9ElWlJfIDsankHMU7A799R5z0hhYP7h5wpuEZcTjqa8
         B4NnqfxS2j2CqlCR3ESyiwDJowkrGUWJvU0FU4KGxWoA1NA4grLRC0N0pi9Xwx8o9L0q
         Fael0GLLv4UoGauGtgTMljEFkRzTEXBYZ4UsHuQ+RQGIEeG0XEKqquXo6MDV30zzNCsF
         PkmA==
X-Gm-Message-State: AFqh2kpVd+qVab5/HBTRhWLcZcN5CvwtcKFKNKucp2r41JLSuGL19Tgd
	0+woJxDp9kSV+CNw+ktbVMiH0+OngVE=
X-Google-Smtp-Source: AMrXdXvLdndaUF+C3AnEdTc8eaJR11ktcamnCwVT3vgAxLC0xCEa4lAK5Ji3iCN6FUO1z3ovO0zq7Y46r0A=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:dd1:0:b0:3bd:370d:aa42 with SMTP id
 200-20020a810dd1000000b003bd370daa42mr3445113ywn.497.1672372796597; Thu, 29
 Dec 2022 19:59:56 -0800 (PST)
Date: Thu, 29 Dec 2022 19:59:22 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-2-reijiw@google.com>
Subject: [PATCH 1/7] KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221230035922.9hhsbEUq2j3D7AFrtOvdClHU4XdUlGyU4AMZMoiRTcE@z>

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

