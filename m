Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD87125C1
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:22:53 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bf56d92231so28372795ad.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652972; x=1693257772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/7e7+T+7gGeD+hfC7oK94gmG9hjXKCpcMKW6ZDA6Zbw=;
        b=xPqz03Kc3MbngNofSxW7EbIK6ztFSQxq/NyvSD4MREYsiuhcfG2Ve03vFpqN7NhmF6
         R2PWmA7m4solm/AsMzUo5qr2cHLgBVkrqqoSdLmIPOVp6eGey+ag5QB7wQvD0LbDFAIp
         sF9hsbmJC5LAkhF7uuPIqTyjx5SGpgKd2s1riPBRwab4cg5boz3LplSc/WsMa6EzYxXu
         GL1ttfAqJi44WwJMFwEqKhxw6ENDXqY4ZCajnnvVXr7QxMGoAujun6YBGhKIAtADgJRI
         t7gl6j+CYLFusanJimkIIqFTGG/LDzV+XDhn7vFbxhY6t7uu49Nre1BshLPRWwt2VVCe
         Kpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652972; x=1693257772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7e7+T+7gGeD+hfC7oK94gmG9hjXKCpcMKW6ZDA6Zbw=;
        b=ROJEDRRIZkpMiOG7laDJ4j9lItulspYfLM8nDYV1donsD6pEP8faT8g0As7/lz8Z+8
         DHBRIbBpl9R7l86rpHJip+ad51fI/4KI4Kuu8eTUDMbzIh1YoLcIJFhVuOEqx2/0iFnh
         2Fg76NCWD9DzbCzD8MGGGsStjIucVnlcQnZM6Avp/KvvLBZH/kmC8BfrQy6PVqc6/PXN
         ndgRMfZKTDTLjz+ZdB/3GrHYLSGLYs+K4wZmxFOkgIg0/Tjd5BbgIwJzXMRq6sYZVAte
         2/tMgARpKJmJM01YduSuXsgQiIgDPWnCRos7jwfX721jitmJ0syyMrmluCxESqGRF3Pi
         DB5A==
X-Gm-Message-State: AOJu0YxFfld/e3iTOcn6Eg1aCrRSQYUTIHLAUE490UZb2Ch5BaeS3PKC
	Y4OoCK5h5g6PBGpRaMR/wzA5+03Q10b4PeqdnA==
X-Google-Smtp-Source: AGHT+IEwLjGrqVvblbAjrv7R7DKyqfbxYUNAxq1ht70WxGu39YS8/s2eB5c/lYBUlVlBXLjiJ9UutGkqmPcLZiFd4w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:230c:b0:1b9:e338:a8b7 with
 SMTP id d12-20020a170903230c00b001b9e338a8b7mr3857028plh.5.1692652972740;
 Mon, 21 Aug 2023 14:22:52 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:35 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-4-jingzhangos@google.com>
Subject: [PATCH v9 03/11] KVM: arm64: Use guest ID register values for the
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
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 216905840c92..42c4d71f40f3 100644
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
2.42.0.rc1.204.g551eb34607-goog

