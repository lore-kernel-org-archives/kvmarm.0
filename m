Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6380911C8F
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 16:22:20 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5646e695ec1so4660935a12.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 09:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425339; x=1692030139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SAQkX4jZeXwDCfCgjX41xn0J3qXI3kH8GLigtCxFkz8=;
        b=Zvb79Kk/LFrJrvLeAcw88YVuYDlvWjKFeHkEVjfxhaJ/xNFyVxflXFCQagtZK5seQW
         jYOtUqIQHHNqGmGBZUvcLOy0zo8WQQDzdP2aKlffiiY14Wz0eWQXjvSXYzbXEmNPJ0kQ
         JgC0D4XVnYc1o3rL7wxAg7LjapTXfJzGilnlxM1Jgzn5E+KYELW2V7MeigIekRfTWb3M
         qyjYr6QZ1KUKXJCGAwTWtWV2x6TzkCVRo5gYe55LDHvSgjt5+7KUJdij4M/Fg3UNn8Hl
         xm0Rs5LYhmNR2b/6rdKysFLm5jNaCdNILNaFpdY72jj6sUwlVWJQC2+GUe9TLtu74xpd
         EI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425339; x=1692030139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAQkX4jZeXwDCfCgjX41xn0J3qXI3kH8GLigtCxFkz8=;
        b=lhQ11VhLGzzTGGZol37Qx8j7FO3VPiCvB1rnEplNI6w3+BAU58RXdYD5xfrqVz+ZQ8
         e8nDTazb8bTU4lA6AIQhqcI14+hJLz/sj6Bn3Byl10+gLBVd0gN4SbbvQM09nidrvlaQ
         XSbeMMrVMGCh7IPXpIr9rVUzwRXwC7OpT5bUE4Bss7CjmwfEb3myvjBWVGDnRYiFadA8
         M6zCq8KaNajSjHklkx7590p8UJ5rsy002fIzmjQvTxirwOjV7tMk0RdjWQ7X72UAJYhF
         9soOzvnojmhhY8ENxHiiM1l+W0HEeJuPbBe9r9jmMV9SH4ZWFVN7BUpGh0rGTNmNofXb
         635Q==
X-Gm-Message-State: AOJu0YzbeVsWr3R7zkKs8AdapeRE56fI3NfUG1Hg0hDwQ0209JvkjEjl
	CzTi79kMGI28xOhiRqR+NxPNKb/kcKYgqhOYBQ==
X-Google-Smtp-Source: AGHT+IFFZxfoYywV7ZmGAj6x9E0RwK9qKQGx056gmXPqflmg3y3hhcRV+6dVUsAA9/fEaJG2keYm3J+S4fX0jbR1Pg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:3646:0:b0:563:e937:5e87 with SMTP
 id d67-20020a633646000000b00563e9375e87mr42124pga.5.1691425339660; Mon, 07
 Aug 2023 09:22:19 -0700 (PDT)
Date: Mon,  7 Aug 2023 09:22:01 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-4-jingzhangos@google.com>
Subject: [PATCH v8 03/11] KVM: arm64: Use guest ID register values for the
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
2.41.0.585.gd2178a4bd4-goog

