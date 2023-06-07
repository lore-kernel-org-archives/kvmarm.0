Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D72F182AE
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 19:46:01 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-565a33c35b1so117305697b3.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 12:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167160; x=1688759160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hzxVwxnrNt+YQp7iV0J7o3+qKksOkJQBVAdrxipkKZg=;
        b=fMZYG2zR8/wyVaV7AOWU2176k/b30yDMKXHbC/LdYCNKxTdoLKCXlQ6JSsEJpKCovx
         u9u+W+rKoRyLy9Nud2MHk1nP4o/c3i4sFDaqNU5Tz18ncnoHJWBcV7YBp35rYblNSMrB
         Srt2tjPaFXVZin7mr/aGXsbIXt58qgfwgTEdJPUyg6mM2OwgX47KdIHSaIQqmi0eqIPL
         5v2P2BX/GBKy3oqa1yCJwfGXELL6EMogyVQSIkmTzCQjg5UWFxSp21LfjJpQZem0aQR2
         wMmq8AKiEtvscrwUGTY8A+yxh1qWK/2oPM6gQEZ/Tb/oHE/8BwS7FZkxI6PRefMOjJOI
         XiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167160; x=1688759160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hzxVwxnrNt+YQp7iV0J7o3+qKksOkJQBVAdrxipkKZg=;
        b=HsnJK3SHDBLDC7vj7a+URfU5VTCQ5bZSra4gIRCdrs4a0C1z5MJ+dysE/7BkVgHmGh
         pHSW60I8W/9KLV8/pfA72yPaLtCruIJRWNb1ahDSmWio9FnfIPK8zewtJ23bw0zeTzUW
         O42VxAguJCeELUCNw/T7cj8HQ0rktfW45w7ZSKZX/RoMy4B1X1P45kkWKu30EOJmbyG1
         Shmh4fiZexVCwaAvTOzHPPpsuc84jfLx5CZiKpOVLDCelZNghzw8ia4HRtgrdY2kNCHW
         CaSkRLEg0Wc9M9RdmUrDeEzoYcWtwWdQo8zEu9k0STETvPWQim4DYD3RyfX2llampInx
         waGQ==
X-Gm-Message-State: AC+VfDyUCEKBP/ScAGD4SbGP+WqMZhFzHGrDJ+ZdJ4EY1HGOtuXG7SfG
	eI1RGQwC+ResPWULoTNuPYkc1LWJrFLOo+Uh4A==
X-Google-Smtp-Source: ACHHUZ6V41FX37D247KNGDPz31teBiVq6V+3LyWxqzaVMHNbR4cZ9zys4EkzeS1q16KMxoLnqrscogFEIf4yfE0S0w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:ae17:0:b0:568:9bcc:5e16 with SMTP
 id m23-20020a81ae17000000b005689bcc5e16mr3400413ywh.2.1686167159720; Wed, 07
 Jun 2023 12:45:59 -0700 (PDT)
Date: Wed,  7 Jun 2023 19:45:51 +0000
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-2-jingzhangos@google.com>
Subject: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error if
userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 50d4e25f42d3..a6299c796d03 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1539,9 +1539,14 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
+	u8 pmuver, host_pmuver, brps, ctx_cmps;
 	bool valid_pmu;
 
+	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
+	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	/*
@@ -2061,7 +2066,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.rc0.172.g3f132b7071-goog

