Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEE7BA3E
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 15:23:24 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id i25-20020adfaad9000000b002cff37de14fso3797034wrc.16
        for <kvmarm@lists.linux.dev>; Tue, 04 Apr 2023 08:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680621803; x=1683213803;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LI+3FHqwQL9jrPeYgxrwtlUWlDIOVCL+e+ckJalmVYI=;
        b=a2QzmNYqwAO1/XerI4Crl0/j3VJeJVAINUWnufEkBZIn6spTGdE2zSYVS//M4e7rCo
         6XTie4biXjaH3B8VHdUJUsCP2DmPf0XDiQ33DRup/Dk4ZKnt+pFNxdXVFNsLSxb5FYHz
         IiMlCK8uAs+IlqwKSTW/BSU/hQOesbLedXflw/V79R4nJyIxFuTLaou/x8MEDYgdk9Hn
         AXAZRoTFJvW2Ddq98bwOwapEs2rQvZnARYxIfk2T2PhjQyyhWnc1t4WhGlAiqLm+gNTh
         v6KItf3xMkfPo+IVreJ6ZRA5eSKIC9QyI98mnnYYxe+2nra7IOzHvov3pRP+0xWYjB11
         ovbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680621803; x=1683213803;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LI+3FHqwQL9jrPeYgxrwtlUWlDIOVCL+e+ckJalmVYI=;
        b=osue783p/sUgRh8aw3zagGDBsQNs9oqrpsgC/w1ZEU2vNJES7qJDkfV7J2gEHqrRTe
         HpN+IzEmoXhoQZ2DydMcO2iM+7RaaoaZNkhDyPoAD0c/w9RILaPBafmx0seNKayYOl6c
         YsQq1CMNvVDskBBH7qiYXBZ2faCs0zFw3A60c6TJ3wImgFJb+7Pc+acwwq9FYnFC+9Ow
         KvOdyZo3idJ7vDANPhgutE92vPWEf2i7kF5vBJgn7p3A2GnffbbdGamfWPJPUuxscsYT
         iDdJjZ3mwk7/oTgdhTrlDb6V1inq7wcpPECAQ15mko5IPUGH6nI4558rnx2kz1rr5/hA
         imhQ==
X-Gm-Message-State: AAQBX9e3MosUl1FO143eXI6PfnzrEhkoTLl56JqMI2kPxMna/4pHCSGS
	GGH/jyeEmUbGP5pjw9EgsjFmp0K68FlZpOP4sEpgEoVVT6mU6I27y8fREjaiUFHD/Qk8dJEC7Cx
	I0s5SDf8h59XrzQxUeufXKkcBZJIp50lDRkz4wLDORRXi4fZEqK2cPgAB/U8=
X-Google-Smtp-Source: AKy350afIk6/58nZZUY/BpWPhrT7hckFjBXpOMOmxniqDvzY1/3FJoSWy5N/PoNcFc23uP8UvzFFwujNig==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4388:0:b0:2d0:3584:27e with SMTP id
 i8-20020a5d4388000000b002d03584027emr598559wrq.10.1680621803110; Tue, 04 Apr
 2023 08:23:23 -0700 (PDT)
Date: Tue,  4 Apr 2023 16:23:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404152321.413064-1-tabba@google.com>
Subject: [PATCH v5] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, oupton@google.com, will@kernel.org, 
	pbonzini@redhat.com, james.morse@arm.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, reijiw@google.com, ricarkol@google.com, 
	rananta@google.com, jingzhangos@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The existing pKVM code attempts to advertise CSV2/3 using values
initialized to 0, but never set. To advertise CSV2/3 to protected
guests, pass the CSV2/3 values to hyp when initializing hyp's
view of guests' ID_AA64PFR0_EL1.

Similar to non-protected KVM, these are system-wide, rather than
per cpu, for simplicity.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Fuad Tabba <tabba@google.com>

---

Based on: 197b6b60ae7b (6.3-rc4)

Changes from V4: Advertisement of CSV2/3 should be based on what
KVM advertises to all VMs, and not only on the underlying
hardware's ID_AA64PFR0_EL1 (Marc).

 arch/arm64/kvm/arm.c                          | 26 ++++++++++++++++++-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 -----
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..e850aeccebb9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1889,9 +1889,33 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
 	return ret;
 }
 
+static u64 get_hyp_id_aa64pfr0_el1(void)
+{
+	/*
+	 * Track whether the system isn't affected by spectre/meltdown in the
+	 * hypervisor's view of id_aa64pfr0_el1, used for protected VMs.
+	 * Although this is per-CPU, we make it global for simplicity, e.g., not
+	 * to have to worry about vcpu migration.
+	 *
+	 * Unlike for non-protected VMs, userspace cannot override this for
+	 * protected VMs.
+	 */
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
+		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
+
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
+			  arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
+			  arm64_get_meltdown_state() == SPECTRE_UNAFFECTED);
+
+	return val;
+}
+
 static void kvm_hyp_init_symbols(void)
 {
-	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 07edfc7524c9..37440e1dda93 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -33,11 +33,14 @@
  * Allow for protected VMs:
  * - Floating-point and Advanced SIMD
  * - Data Independent Timing
+ * - Spectre/Meltdown Mitigation
  */
 #define PVM_ID_AA64PFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3) \
 	)
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 08d2b004f4b7..edd969a1f36b 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -85,19 +85,12 @@ static u64 get_restricted_features_unsigned(u64 sys_reg_val,
 
 static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 {
-	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
 	u64 set_mask = 0;
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
 	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
-	/* Spectre and Meltdown mitigation in KVM */
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
-
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
 

base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
-- 
2.40.0.348.gf938b09366-goog

