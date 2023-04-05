Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29D37470
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 17:21:51 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso28500431ybf.23
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 10:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmqT+xEMzaVEM8H2cjQDaFd1fXb0znGEptEPZMK1zc4=;
        b=VaoW5e2K7xYhDTLa8brM9G6tOV8U/SCHghY7DZgkjotGqVe/L0gpvUYAopdgOIKd8i
         E7m1bHv3nJoii28MSfUEI+73TYEsKSoHuYTRHt3R/x/2gvi7f00Ezk0VzBr2Mp1kb6Gy
         25Zua8e1CGfAEMae/CJlEmxtoVp5FhlDnESnDaGc1jf0YQJ2MkSJlW7dCM+i9gyfzLT9
         XqZHkwghNLhqEVEhnba+A7j2lPZnEPNkzFxIaslaewi+2R/z5fK3KXAmbH98L9P8qr43
         Y5rPeLaJ8rAXi4Nmd+ZFIWIHnsw2L56+I8Ql2rejheXHpos0Oa/hts7D6JcH+D1ldefC
         FJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BmqT+xEMzaVEM8H2cjQDaFd1fXb0znGEptEPZMK1zc4=;
        b=RFVyq96+3CRz/JqEP4he2Cd9GIXvbM8FO2LaAcrEgp5uotuVJYziSv/sNDVJeZeTCk
         HmwYaMmGIKSON+2vpPrXBgOauSjJg7tXVBV4v04ij87UEI/ZE3fL6ERudzewX2tIr/eT
         cmVa6Q1ZKxc2rwskPgiK+TGhLir2HHpr6YQvBJd3oy8zc4UVjFJha8gDqH/f4JelSgc9
         ggRoOpYMComEIATbOaBhN/jjxAid4JY7lQ6o4OWWOq2cR5V6WlaPL3AG6RTlbPGnh0Jd
         IWimlCMqwmpo5M9tvqc6JO99L4aGbRz1J1oVRjqC25TnDWIwaO+ogPE9hJ06Cw9v4cDv
         vw3A==
X-Gm-Message-State: AAQBX9cQ+GSQwDg+7zpXw+a6YNiKmd0V1iYazvcAZlaE210c3xSZXES8
	NZtvW5rEvVy1tHCt6RqCrnT7+krFHLg8HIjErw==
X-Google-Smtp-Source: AKy350Yl8X0xPwh29QUUIXvQyLzR+bR8YP76SlbD780VXcZg+KLALOuHBR8wv/i0C87zpq60i2MDK/RFt2JkgJ35qw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:1370:b0:b75:e15a:a91b with
 SMTP id bt16-20020a056902137000b00b75e15aa91bmr2439474ybb.6.1680715310689;
 Wed, 05 Apr 2023 10:21:50 -0700 (PDT)
Date: Wed,  5 Apr 2023 17:21:43 +0000
In-Reply-To: <20230405172146.297208-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230405172146.297208-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-2-jingzhangos@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error if
userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 33968ada29bb..ca26fdabcf66 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -336,10 +336,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
+	u8 pmuver, host_pmuver, brps, ctx_cmps;
 	bool valid_pmu;
 	int ret;
 
+	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
+	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	/*
@@ -592,7 +597,7 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5, 2),
 	ID_UNALLOCATED(5, 3),
-- 
2.40.0.348.gf938b09366-goog

