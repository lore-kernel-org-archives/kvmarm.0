Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531C94501A
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790421; cv=none; b=TABor8m15QJlvBMb9DDXXHuTPhswQ4UHKaZ0m0HUnleq/wbPEwL68SZsxOrPKDgTayOR7KRtdH8QE/LqqQCXxxZYFt1kGUzK10qehjTrG/vqEOBIW8NWvx+wkFCnuBXOpiNu6dBU/uHMSrQhrSBrZN1oMgPBzKZ6criGmorR2j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790421; c=relaxed/simple;
	bh=Dks8BvWEB5uW6mYmgWuYhqFGw4Mrrfi4NOPGlx+URgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GAyNu28BMPLv3g1B/1bSSrrZrqdRi9/6BiXAa4pofit9pzP70wZOxKv+KzWg/0D5Ug5xIxkw7aIc2fCXiaroLW3f1mt+8Pi5rTnl3xw7lbgWdMJMSsKDBCGqOr4nz44F0JxYi9F7PXe/3q0+XFrjR8YE+4p1D35FK+UiMydVTqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2k4rVqz6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2k4rVqz6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-456175dba68so32988145e9.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790418; x=1754395218; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yzOMi+9WhLFn5RsmaXLKQASfSh/9aYySv/FWLLLXXM0=;
        b=2k4rVqz6Tz7F8Ep9LFRrOo1UWCFnblbfIlzHBbNYYoPtCB0IhCPjYWfVEatZ+SmGz5
         jT/HNT+P14RLom8I7L1lH7C7L0U5b65eC6xwD0kE1xFlThBhwuBcZI1/cHp3eywPJwKM
         cIw2y5hd2VBB+dtJu9cjiIWQ6nXEEnpX/uuX7TYBsr9I7IVxOdOSEJxaJ6dwgdSFHUep
         0TfcZH1sprguCe8HMAvFjRakBB/iAwgDo1QLv/9QxbVcJuiQ4KcscZaCh/aJ1jJGchq/
         QvHrsJJZEFDVz7x0t36Eu62CVSslMHGBuc34D/0aEULv2J47pyRd2Zn+dP3FgreaV3Pq
         5jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790418; x=1754395218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yzOMi+9WhLFn5RsmaXLKQASfSh/9aYySv/FWLLLXXM0=;
        b=DMWcw8quqf8LpfYJ0JctIBP9oOJ9UjsdE07ROoCESPaHuCnNuXw+7O54ZdcidSkcoa
         tZvkEzd1hqjgmSXWUbKuIx6l5ZiLShCIIVV/2AhB9wja95SNVq5zuo524HBg2i+1vmLf
         g+9bsBab1htsoPdd9sleuPy77viuBRoz/UT5gSe3T6e4kcO2SKaK1rXl6jWHP4h68i2+
         0KbiGn/rz6q+3QDi6HDp8SxM6lTU1ShR5Z4lZPGN15J4V/hX+w302eZmJ52Qx0jHNOXf
         JJ9YLvMdCrcD14p6TQitt3/cwrcXB0WBOJTxQ0wlM3TwtBhiPsstitcpIWyQjrcVbSFt
         Gbiw==
X-Gm-Message-State: AOJu0YxUBydKh9/wrpkLGFWa/ckxilQp+IK2KZUt8yza0KiNbrBA919f
	jEbDkf4IXxdmLaXTp6cMTt06gEBHF980QsuHpp662rPOft5RrWp1+RBYeHshUxiQ2ev/Ae6OeAL
	vQ7rV8h6BEeAEcIU2FxBMjCUbR2HITwMOmCHc5/+IZdwjrCHV06iT+3d94zoaIIdZFtg0XFsN+v
	n+OnZ8H+Y0bYXgz42bJhIUjzrOU+EZ46w=
X-Google-Smtp-Source: AGHT+IF5m5Jas+Y1tjtFvJmfbbD63cNHNWbScBXNfx43vxxHKWugss/STe0rrrG6LluVj7J7814rLj4CZA==
X-Received: from wmsd13.prod.google.com ([2002:a05:600c:3acd:b0:455:9043:a274])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6088:b0:456:e39:ec1a
 with SMTP id 5b1f17b1804b1-45883089729mr83764525e9.14.1753790417578; Tue, 29
 Jul 2025 05:00:17 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:08 +0100
In-Reply-To: <20250729120014.2799359-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-4-tabba@google.com>
Subject: [PATCH v1 3/8] KVM: arm64: Clarify comments to distinguish pKVM mode
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
imprecise and potentially flat-out wrong. They often refer to a
"protected VM" in contexts where the code or data structure applies to
any VM being managed by the hypervisor when pKVM is enabled.

For instance, the vm_table holds handles for all VMs known to the
hypervisor, not exclusively for those that are configured as
protected. This inaccurate terminology can make the code's scope
harder to understand for future developers.

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
2.50.1.487.gc89ff58d15-goog

