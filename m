Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F07D50F
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:45:29 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1b8a4571c1aso30890325ad.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 09:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698729; x=1692290729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=IG7T43kRHhKHqmEiMzHxNeQ56Cb0139AlcIhz2Mi/+JW/VCHRl4rYafsJFi/e2JFEi
         mIvhqJWXlfvC82JAWuBBk2Xi24o18hCzneiWW6VW8aULpxR+CjOWv13HmkdpoJv3DurC
         L2DbZRk4IwjvXC9sEiXHpWWw4Pc4Jue5D+o42rmQouFteNkDuRc4NNc9C/siUP8Ry8P8
         D1oQnTyl/+aQ9787SxzIRkNdmje0ThG0RirnnIxVV7XnJB3HUNsYN5zxe8aZ/tadDsK4
         akk9re/Kek0AM0PZ7I9ayA5J3l4ygxCa63qtk6CUH6Sjsz6434l1UfEiaefJAIXWtM/D
         F3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698729; x=1692290729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=gBIuwhveEJxKTLXzUsKOUvmVlhopQkiiu4JbLdpiAVaijVSVjz6ZJlXMbWrscQ5Dcd
         cJ0PjpOzY1Y56ou/JMBXcfuJe8DV/isl1cFCkjXVKT4kLd8qVVvHq9yXhGob9Xo8Xiyz
         onDmvUVoTigewfJrg1K5jjAa3vGgYATs064x4w03TIaRPsYjfVX/64aKv7AyveX72AKN
         Y52j2IL0dqKhX6xKN/CL3fJJ1kWk0d2Cx5WI/22kwz/EfPcILmNNPkj1vWCab+Dm9OZP
         uG2iSxn6IcQEiw6rrMkCkKn5ueVmPphtCxFxatfqLExQOQFxYdTnlxHeDPClp6iOTQIQ
         /WCQ==
X-Gm-Message-State: ABy/qLZzKJUyud6lh2mtPOuW4qnINOIyPxEnrRFd9hqy7lRyz3m1DYT8
	tY+Mx43Q97zqadJ52jiHGWOwlzkMdZ0EnjavHA==
X-Google-Smtp-Source: APBJJlGDtopDEFCCENvpj9bk0ucRozmxIamafw8OCk4paTc3ega52yzZuM1x2wqjc5oWp4XpUi/NXDGnD1HR1/9cuQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c952:b0:1b7:edcd:8dcf with
 SMTP id i18-20020a170902c95200b001b7edcd8dcfmr1194pla.4.1689698728793; Tue,
 18 Jul 2023 09:45:28 -0700 (PDT)
Date: Tue, 18 Jul 2023 16:45:17 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-2-jingzhangos@google.com>
Subject: [PATCH v6 1/6] KVM: arm64: Use guest ID register values for the sake
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

