Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDAB253C8
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 15:27:27 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1b8a7734734so22518275ad.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 08:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607647; x=1692199647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=kOoTOacFJO9+uHVWHHqMzZUX8/dwgTKGK16Eo5ITJVuv8lBgElCfJCMjxew+K8LFhS
         0GysunMasR920l3SSl3P1E9H6MG66vreYE/A/hoaEEJom/uKr7dGst7zkry0m4tU49E3
         tvH8jPnZrUJ3n4XKLeUkSZ/GdivDj+baCykn44EudzfpfOvTXDaDSw3twySIRBSrD8pS
         uorNxDt+Xg1bfg7pWfLzylmCrMXSCayowem3n4taDuSjy3E+hAsxqwYdpbZBKJsCKwNW
         jwfXjyOrHVd8AasOuj+dAbxTjBnEw2867xWLAV6e4Fexi+xj9wlHjDFJehhW18rNQh2o
         EnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607647; x=1692199647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=ijZR/9+U9cqyfKBpme66HJA4e3uiD85L8uvpLCAdH1J8yR2mqGvu8Wgj0HCWSoD8ID
         uRxh8VuB1apB9O4AXr+ngAlS3GCPQyi05Skc3RHgqp0VB52gW7ZwPMHHGRi2cvqquVfo
         qv75hakWMC91l7u3lFuyhzjjnBcyLj6LV7zqI9nrks9nrkwPa1e1/O+aJRQsfhqKqIDG
         y9ez7UT1shOFu3ZtTJqQzC4eJkW/wWnKjyrlUesQEhkpmb5Q9tQj7VZWwuk6eV0CPe+p
         Vpz+7B43z8qY98yhl+l9HbMLINaz/UQSPYziQ+Qs36OVrUEYAMGuj8QCjE4TrRbmTbdn
         WSbg==
X-Gm-Message-State: ABy/qLY1PKb3TrvadKx/mhUx30YnvYH1ptpJ8rU4AafwuHWOkJ2EuUfw
	oT/tt4inqiX4ToIEDnKjfOMkgWRtGn2muE8irg==
X-Google-Smtp-Source: APBJJlHIl7j3tQllnrhzxMlMfd0kK1zkhxUn4crAb5Cbfzt/zjRHX6e+NgOaoE/NYrO8gVVSsE2pUunvbNtvgstR8g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:d503:b0:1b8:8c7:31e6 with SMTP
 id b3-20020a170902d50300b001b808c731e6mr83plg.1.1689607646689; Mon, 17 Jul
 2023 08:27:26 -0700 (PDT)
Date: Mon, 17 Jul 2023 15:27:18 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-2-jingzhangos@google.com>
Subject: [PATCH v6 1/5] KVM: arm64: Use guest ID register values for the sake
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

