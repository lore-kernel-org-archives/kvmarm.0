Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0748614AB3
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:24:35 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1b8a8154fcaso74331315ad.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 12:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017075; x=1691609075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=WEL8yeJBXLqzExhD6IHURdek5D4wvVU763ij1nXK8iYTaLrwHbm45oCwnW5EiOyICr
         ECOVHHRt04C8aCXCcHarD1e5tpbz/VD9139ooil7auwC5ZX9SeFEFSQJQEYvgMCiTJJT
         priMyy7eGQZOHQvWd+Rnvzdk2a6yDeqadOA2wAjDN8MohQcROJA4VCNaJhMeqzczzGNc
         Q4fO1VvryLtbUuk7JkXj6jkZV2sPZ65InW8KYpLm/PQIIg1Nyn5ZjHpKrB8rZ3myZCNl
         WhDLT/kCjBT6z1aYNMZP2KN/0p6C17+ILwBIKj2LCquGaWN+Po9fmNCZD1mreciXtBox
         ZcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017075; x=1691609075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=AoWdhLTv+ePDjDW8/phvhViA/ElnaCulOaplrxR7dyyERdsHM0ZOjamSYdEKmsfJLl
         Of8jfEwPXHGJJ7UB8vuatKa9WE3HPtoYJhWT4cBJTRS8jGzy7WL7qkhGFFbBmXxbUHEy
         W57X2Fs8DH8SNyRO++TZ581Pp9bXTYqziTTpUtCzPI8PIHOFkhb0FJHyCaW3a0oAfpfY
         lG5Is+zC9DfSBeVc27loSqBmaMQjiII8A6t8jUKXtwottq5sNHGwelyfEJMltO2RwFdQ
         j3IuJAH2ib+xbCUt3GY9r+hSrJcMY5igbOW1ul7UVjogzD2kLi+sITWrwA7Wkev/JVjD
         n2tA==
X-Gm-Message-State: ABy/qLbFHXRGX+AlPXONFTJNeMwjT6OJaA+ffeEZi+243VXVBxSSCVJ0
	Jsr5RqabGQ4oNzCcQOdRFP0SLHI75lgIwBbuWg==
X-Google-Smtp-Source: APBJJlF18xsYgsI0CxYuUZH80Cwz7kk1zPTVFelfLYuD+GDrkVgWul4z+afhe2yJxGfDVGHbruy74hyRYY9cbvtPLw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:41c9:b0:1b7:ef3f:5ed3 with
 SMTP id u9-20020a17090341c900b001b7ef3f5ed3mr13176575ple.5.1689017075354;
 Mon, 10 Jul 2023 12:24:35 -0700 (PDT)
Date: Mon, 10 Jul 2023 19:24:24 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-2-jingzhangos@google.com>
Subject: [PATCH v5 1/6] KVM: arm64: Use guest ID register values for the sake
 of emulation
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
index bd3431823ec5..c1a5ec1a016e 100644
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
2.41.0.255.g8b1d071c50-goog

