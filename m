Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24C038CC2
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 19:46:04 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2562b26cfafso2869522a91.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 12:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167164; x=1688759164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=huLg6ss0tcmHNDWws/J4wYZLAswrAiv7bwqrVCr+Www=;
        b=rvQpvgjutLDBUFD6re8s66cYIwgJnhk30RuWpsooLwa0/DnV1KMpLh1QKXz+AU3+EJ
         toULyYGPVwLcH+MSf1zAwjIgC+QmNBB84JuvtVGLm32grPQNsyGJC3yXIN+pXqUx0vmf
         kYkm0cPqzfksnRtP/WQ3XaIV5kyL5FExnTnvHnNEHk9QkXCUYZPtMjAyqZOwoW4K0Hq1
         y35uWuI4QoY/hqnEX3uFzWlae+hnEGx6aU+9CDnIEosOHdw7Xdp/4v0Mg9VKQ9GeT0yk
         980+Iqqj10VIbOSXVkqMt9C0azx+wOnrkAIodnSMgi7gX9SdshzFmuUiEcp8K2mTBDU0
         eicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167164; x=1688759164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=huLg6ss0tcmHNDWws/J4wYZLAswrAiv7bwqrVCr+Www=;
        b=NcVo3bJgAaZfje5El93wzZ0wnRMx0m8TpUFG6f8bvKqNW0pySF3SpY8AjOXAKfmlKt
         SwrKU6iLqpGJ0bXrW7jJhA5ZQv1YKxvSvbbudUjhu0kwchvjrPseZXW7GTYQKX7jXWp4
         B1ZmSaRx/d6RggADL2EIuAd5UlBxPnQs6AH03T3SUQE7KIv80xp7eKByeC35QDi8BJqj
         /VOweelUKISUl03LuythXCa/Iq6enOZg14Y1An+gJeiBEVs9wEZqMlU1CVjQnrLRYLAc
         4iiq/pxdkaPCeuSoh1T7VEQYQt2N7RZfJaK/vob8Np3FbZOLlZiVUhRshYsoBtSNgTHF
         QgKg==
X-Gm-Message-State: AC+VfDzziryPQ4xCPef3FLpgdsXaSlz5pWTG6/MySaIbwkCzYG8USRQc
	tATWYfZUNkooPGyJpX/EqrUbEdHRZ9nxGAc8AA==
X-Google-Smtp-Source: ACHHUZ4hJXt9tbUdkBWtP+0/4Tl+ZJnlb3E1BRZjLecrD3nbq3Co9zEpbNCwpWdnYYtl6Y/VvwJ4Y5DV8ySaS3odNA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:453:b0:1ae:549f:af6e with SMTP
 id iw19-20020a170903045300b001ae549faf6emr1907179plb.7.1686167163943; Wed, 07
 Jun 2023 12:46:03 -0700 (PDT)
Date: Wed,  7 Jun 2023 19:45:53 +0000
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-4-jingzhangos@google.com>
Subject: [PATCH v4 3/4] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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

Return an error if userspace tries to set SVE field of the register
to a value that conflicts with SVE configuration for the guest.
SIMD/FP/SVE fields of the requested value are validated according to
Arm ARM.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3964a85a89fe..8f3ad9c12b27 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1509,9 +1509,36 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 
 	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 
+	if (!system_supports_sve())
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
+
 	return val;
 }
 
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	int fp, simd;
+	bool has_sve = id_aa64pfr0_sve(val);
+
+	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_AdvSIMD_SHIFT);
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_FP_SHIFT);
+	/* AdvSIMD field must have the same value as FP field */
+	if (simd != fp)
+		return -EINVAL;
+
+	/* fp must be supported when sve is supported */
+	if (has_sve && (fp < 0))
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_sve(vcpu) ^ has_sve)
+		return -EPERM;
+
+	return set_id_reg(vcpu, rd, val);
+}
+
 static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
@@ -2049,9 +2076,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
+	  .set_user = set_id_aa64pfr0_el1,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.rc0.172.g3f132b7071-goog

