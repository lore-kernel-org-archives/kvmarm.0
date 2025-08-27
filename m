Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7E6341ABD
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756289999; cv=none; b=lNQoomy6qiCQbgnmmgbqrr2FwikEjR7a49YNu2OAaeAxQg8X/STQ2pXwgyu6gojlpBqcTQ8bYe6vHABz/j29ebiyr49R4uPhYBcgquvBd82NOvT1CPY1Hc+MpNDWeF2BXehUnZIqy6jOEdEXzbWQXytQjeTlA4jdeQ5hpgEggr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756289999; c=relaxed/simple;
	bh=1hne3psqA/uyftsoOVNOx80JYixnX/w4nGcpFRRx06E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tbP92TrGPkHIpiUuxShpo/cM4s8bmXm6sjJLY8FmBrkDZh8GYb5fdfiW/Vfh7fOoZ7c1FtRqjkpZ+uw8+8fx0Hrk/NhXIOFjhHSsHQQfdP/U5OVJINbyfYZ30XcyT8dPJlgXIIpnw1CncfmqaxK9r6I+Dope3UlDmWR7p12NY+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v+Bw7KiS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+Bw7KiS"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b6490ea91so9966245e9.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289996; x=1756894796; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mnbd4Q5k7JD2kPdF6Eij8SGcex3kyAoVM00VR9ktf4=;
        b=v+Bw7KiSB7aSrTOyq1jzg45qPCiHpJc5ULFZiZrJ9I547pZsdghjAykzvR9xMPudry
         gTA2FDvm2GCFZt3sKANJGakAkKg0liMU7H7YHLntF+4S/NgpIsJUEwNPTi/lJXhzuQeQ
         DFf70s6apAR1JieomN5FxOy+J3U6St0aVsBBGo90uYmPkY57xwdcCSGUnOBzHx95Rrfm
         iVo0pAoW37Yl08e/eOlKYvoAcULa1EgOaep3MTDgsV3OMZlYup45AASlEw57aicrQZwP
         zX9WQtYAn64knm9klvujNuXyDFUkI7m8y8Ta4JV+iNa5TPYbpkNeogUnh63DfUI1a6Fn
         X8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289996; x=1756894796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mnbd4Q5k7JD2kPdF6Eij8SGcex3kyAoVM00VR9ktf4=;
        b=f2zdFQ32mjK9v10c8JMCN5hq9A3/kTVmqakVkXfDnsV4+Msv6c4a3n8csAlTWLfD6f
         Obbt4TJnS4TNailNi0Qe5CgnrCeesihqXLAFhkccJrlsb0hJbHXSGPVY8MDMKu2fKznj
         AzRPwUjcO64u9jodK/B2WseyfzIT9ORmrzYhOI4wvRWdoVWio6Jx2l71yEIqcYIvKxdy
         UbC2tVHORgCfiZlG3qW26wP99KTesHbfALrf7hjCnanpnEDN9UCy6Yp70XnhtiSMFXW1
         Jnei05czDyPl7hoinyaoXjFPie/H/DMnDiCvniAGroj6+GxcVDPWr5C7FG58n3F/rpfG
         y+jQ==
X-Gm-Message-State: AOJu0YxctrAE6ZQRKy1Nwu6BDhB946DtiNiH0epf696L1wNvf1CK7I6+
	BtsE5V/Kjn1Qgtdd/0nD3zJThDBi9bzq0jdJgOOulOefra7/w4BtsUxgV7nR1s/FBO6TPWn32fO
	hQxcJKXAp8hwiuLmigvnYySCwD0SLECbw497VosoQjf+a9AXeRqTdg8HjZGCrowPrxTP9wQutKD
	CtM262E8o/3Uc1p2V/RnZX3qcARJfcjss=
X-Google-Smtp-Source: AGHT+IGa2OXp31RIOkeWltDfubFfhgbApuPcgBbAFrQZ9t2QvmsER073iwlg1cHEBx+MH0iIIjmq5lmmXg==
X-Received: from wmsz17.prod.google.com ([2002:a05:600c:c171:b0:459:10dd:2e55])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f86:b0:459:db80:c29f
 with SMTP id 5b1f17b1804b1-45b5178e84amr152274095e9.1.1756289995668; Wed, 27
 Aug 2025 03:19:55 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:44 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-5-tabba@google.com>
Subject: [PATCH v3 4/9] KVM: arm64: Clarify comments to distinguish pKVM mode
 from protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The hypervisor code for protected KVM contains comments that are
imprecise and at times flat-out wrong. They often refer to a "protected
VM" in contexts where the code or data structure applies to _any_ VM
managed by the hypervisor when pKVM is enabled.

For instance, the 'vm_table' holds handles for all VMs known to the
hypervisor, not exclusively for those that are configured as protected.
This inaccurate terminology can make the code scope harder to understand
for future (and current) developers.

Clarify the comments throughout the pKVM hypervisor code to make a clear
distinction between the pKVM feature itself (i.e., "protected mode") and
the VMs that are specifically configured to be protected. This involves
replacing ambiguous uses of "protected VM" with more accurate phrasing.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 25 +++++++++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index ce31d3b73603..4540324b5657 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -29,7 +29,7 @@ struct pkvm_hyp_vcpu {
 };
 
 /*
- * Holds the relevant data for running a protected vm.
+ * Holds the relevant data for running a vm in protected mode.
  */
 struct pkvm_hyp_vm {
 	struct kvm kvm;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 6198c1d27b5b..abe173406c88 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -23,8 +23,8 @@ unsigned int kvm_arm_vmid_bits;
 unsigned int kvm_host_sve_max_vl;
 
 /*
- * The currently loaded hyp vCPU for each physical CPU. Used only when
- * protected KVM is enabled, but for both protected and non-protected VMs.
+ * The currently loaded hyp vCPU for each physical CPU. Used in protected mode
+ * for both protected and non-protected VMs.
  */
 static DEFINE_PER_CPU(struct pkvm_hyp_vcpu *, loaded_hyp_vcpu);
 
@@ -135,7 +135,7 @@ static int pkvm_check_pvm_cpu_features(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	/* Protected KVM does not support AArch32 guests. */
+	/* No AArch32 support for protected guests. */
 	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL0, AARCH32) ||
 	    kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL1, AARCH32))
 		return -EINVAL;
@@ -210,8 +210,8 @@ static pkvm_handle_t idx_to_vm_handle(unsigned int idx)
 DEFINE_HYP_SPINLOCK(vm_table_lock);
 
 /*
- * The table of VM entries for protected VMs in hyp.
- * Allocated at hyp initialization and setup.
+ * A table that tracks all VMs in protected mode.
+ * Allocated during hyp initialization and setup.
  */
 static struct pkvm_hyp_vm **vm_table;
 
@@ -495,7 +495,7 @@ static int find_free_vm_table_entry(struct kvm *host_kvm)
 /*
  * Allocate a VM table entry and insert a pointer to the new vm.
  *
- * Return a unique handle to the protected VM on success,
+ * Return a unique handle to the VM on success,
  * negative error code on failure.
  */
 static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
@@ -594,10 +594,8 @@ static void unmap_donated_memory_noclear(void *va, size_t size)
 }
 
 /*
- * Initialize the hypervisor copy of the protected VM state using the
- * memory donated by the host.
- *
- * Unmaps the donated memory from the host at stage 2.
+ * Initialize the hypervisor copy of the VM state using host-donated memory.
+ * Unmap the donated memory from the host at stage 2.
  *
  * host_kvm: A pointer to the host's struct kvm.
  * vm_hva: The host va of the area being donated for the VM state.
@@ -606,7 +604,7 @@ static void unmap_donated_memory_noclear(void *va, size_t size)
  *	    the VM. Must be page aligned. Its size is implied by the VM's
  *	    VTCR.
  *
- * Return a unique handle to the protected VM on success,
+ * Return a unique handle to the VM on success,
  * negative error code on failure.
  */
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
@@ -668,10 +666,9 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 }
 
 /*
- * Initialize the hypervisor copy of the protected vCPU state using the
- * memory donated by the host.
+ * Initialize the hypervisor copy of the vCPU state using host-donated memory.
  *
- * handle: The handle for the protected vm.
+ * handle: The hypervisor handle for the vm.
  * host_vcpu: A pointer to the corresponding host vcpu.
  * vcpu_hva: The host va of the area being donated for the vcpu state.
  *	     Must be page aligned. The size of the area must be equal to
-- 
2.51.0.261.g7ce5a0a67e-goog

