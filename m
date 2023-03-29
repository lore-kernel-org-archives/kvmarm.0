Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1340BAFDF
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 12:15:29 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id e15-20020adfa44f000000b002d7ea9d6ef0so1515688wra.8
        for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 05:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680092128; x=1682684128;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3LDovRClEiEee92bH6YgUcmES4firbrLEQRncmwPJsY=;
        b=aE6a1iSlrF07iDsx3s27aH3qFGuqnJ39YNvFoWalfzgbbc5syaOxqbYaSMBLqQ3XRa
         Ds3EeAfyOoUZAdikTRKm6kmKYR213dgBalRpH7Da+vX1KnqhkxQyRtVGGIoninmWXAXI
         o64sIAzpSypg2xzqsTsOsGT5UDHxdRxQR0tTue9KmkCX33DR65GOtnIRUNvaEHtX9dIh
         P7FY9sKOnaMnvgyIxswHv/aB2oRXDXeNN2A5NkogyedusqDDIBdUaUdzgoYDsJf//ifW
         kAhrT3dfpGl+jIefDKdp/Gj3sj+JgvTfvv5rxM30gmQSIXhWBPhSurNs4xLuq/pwzQhL
         1jQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680092128; x=1682684128;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3LDovRClEiEee92bH6YgUcmES4firbrLEQRncmwPJsY=;
        b=0Uy9v2hQ62+4edNzIrvWoenq2pzduqiLmMNFiW63ayAYMZQXPh/1OQSMsMOASeumEm
         v+ekbhDA1LXUmIrHYRX5XNdh3S74AJiSyB2fpj0yStAYq/FE9zAfEa6tYnqv8+RLy4AC
         0cHAa0ruEteVRhiwFOu9KeB6/UeDPaW55JEuxiPJTeGvgnyfJBeQkdR1TO5NXnm7G9+R
         z+OSJXvGjTipw7qA+4C80S/VKE3Hr4Ys+ctLJ5eaKrE2mK1DsKlBu1cDNLqx1Job0vOd
         h5w1uD0pOsiO9D/x+XV+eFm1KJPCq8Pt3FcfjSVbgDjDXiOMZ/LdbAxUZjdyPE9xVUZ7
         +daA==
X-Gm-Message-State: AAQBX9cA37OG2mhdSoJppe2686J2YmENZbDWWK2OSXMWWspHfX/DET+S
	RSAUK+yPC0bN6Xi8fYlI3BTvQmEjws/Ud7gIvN0pHfQa2BTjGDIfURTvYa1Q+O7Xs3iNCEor/gg
	Ap6+HpteWM3kCG5fDrXjX4plimFHTgyT8EdVQWbF/rcPkSugBI+0prsAQRaE=
X-Google-Smtp-Source: AKy350a2TXbsc4wgoDmK0xosSNujzwRIPiHbkU0ilqrgPU26WFZYU6IQL0eiinCffMwXzip/xFl4nM0mmg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e5c7:0:b0:2ce:a8a1:f2a9 with SMTP id
 a7-20020adfe5c7000000b002cea8a1f2a9mr4010465wrn.12.1680092128220; Wed, 29 Mar
 2023 05:15:28 -0700 (PDT)
Date: Wed, 29 Mar 2023 13:15:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329121526.1168242-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oupton@google.com, will@kernel.org, pbonzini@redhat.com, 
	james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, 
	reijiw@google.com, ricarkol@google.com, rananta@google.com, 
	jingzhangos@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The existing pKVM code attempts to do that using a value that's
initialized to 0 but never set. To advertise csv2/3 to a
protected guest, store them at the hypervisor and use them for
setting csv2/3.

Similar to non-protected KVM, these are tracked as a system-wide
variable, rather than per cpu, for simplicity.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  3 +++
 arch/arm64/kvm/arm.c               |  2 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 15 ++++++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index bdd9cf546d95..723a645af191 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -127,4 +127,7 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 
+extern bool kvm_nvhe_sym(spectre_unaffected);
+extern bool kvm_nvhe_sym(meltdown_unaffected);
+
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..364a4440ae54 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1902,6 +1902,8 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
+	kvm_nvhe_sym(spectre_unaffected) = (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED);
+	kvm_nvhe_sym(meltdown_unaffected) = (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED);
 }
 
 static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 08d2b004f4b7..3f647a2f4c96 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -28,6 +28,16 @@ u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 u64 id_aa64smfr0_el1_sys_val;
 
+/*
+ * Track whether the system isn't affected by spectre/meltown.
+ * Although this is per-CPU, we make it global for simplicity, e.g., not to have
+ * to worry about migration.
+ *
+ * Unlike for non-protected VMs, userspace cannot override this.
+ */
+bool spectre_unaffected;
+bool meltdown_unaffected;
+
 /*
  * Inject an unknown/undefined exception to an AArch64 guest while most of its
  * sysregs are live.
@@ -85,7 +95,6 @@ static u64 get_restricted_features_unsigned(u64 sys_reg_val,
 
 static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 {
-	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
 	u64 set_mask = 0;
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
@@ -94,9 +103,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 
 	/* Spectre and Meltdown mitigation in KVM */
 	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
+			       spectre_unaffected);
 	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
+			       meltdown_unaffected);
 
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
-- 
2.40.0.348.gf938b09366-goog

