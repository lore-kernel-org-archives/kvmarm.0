Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74124DC6B
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:17 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bbbf96ebe1so45429035ad.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903217; x=1691508017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4m6WXeBLyRHr+QvNXIbI2jFxW3avFe83y+pcJg40hnI=;
        b=41CSSN+hrqV+uEQcg062xb3BDESzeeaZrpLGmBiFuxwUYBsb39Ajf4JSPo+BnqEgph
         GrjSldr+fqJbSsULyLROGCqdMwJ6TPcEvBoVqHSLOk+R/n87pDxRhy98pn9Hko3TkWy8
         hadEWh7vpkVun5nkli3CBu22HaEfMwDlFX4/lfrHcwM+vpthhZekf6YFpnphlxc8mcOZ
         /tCUu6i1UfO7pHCYc/bz3S3y5IA4/rdr1KqkE9ugV+EJbcsx5MsA6+N2bJ3L/D9HokGN
         sFSp0hvkwd7iT7Xnq8UDGuYPwZVC1ofE4o7p8U193EiPY3+mMfFzysmq6ICIwWSgnw6c
         bQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903217; x=1691508017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4m6WXeBLyRHr+QvNXIbI2jFxW3avFe83y+pcJg40hnI=;
        b=RBzUeN4CqvlvFNaYZohAPyHls6zNDZsey8O6yDGBFf+Lo2lJP+f0mww/MFT9Ggkjew
         Z/svnCudlnA+quRmeJrryIuwU3MoFZW4bNhQMq+W/9e+kKSFgobGNTAkzMHe3HVVsnFn
         qyLuBcxyhUo1Gs5vZTyFI8sO5XPpE9V7LGwy7YYSXBR0fm/5PsMWgWM9brENtdIZ86zv
         ueRXTtojzRoMZwzsvcqk538qjxhlqU4kpgI95F/9RCcrPv7lBvY94jyUHcyWp9by9cex
         q9ub7G8HjtOPr7pmQjUFA8GV76xSdZSbdKYH5Twr3CmMegwHmUKr/c87D3aV9oWr4tJP
         be3w==
X-Gm-Message-State: ABy/qLbHhtJ8Cgp406LCSogHTa/Uac13FArt6lYygnIrXRvyERVvnc2A
	2v5W9MZVPZxsC3dDzYaoDprbjLusClMuk7T2BA==
X-Google-Smtp-Source: APBJJlF5pQV//6JpAgPsrrwmu1eJKxYmdCqhfZm9zICtlUCY7L5aEFcjDBXXU7rrEPxZCvZlO/QmM5V89O0TvCqmmw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:7588:b0:1bc:1189:189 with SMTP
 id j8-20020a170902758800b001bc11890189mr53532pll.3.1690903217346; Tue, 01 Aug
 2023 08:20:17 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:19:59 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-4-jingzhangos@google.com>
Subject: [PATCH v7 03/10] KVM: arm64: Use guest ID register values for the
 sake of emulation
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d9317b640ba5..6eab45ce05d9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -379,7 +379,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
@@ -2429,8 +2429,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
-- 
2.41.0.585.gd2178a4bd4-goog

