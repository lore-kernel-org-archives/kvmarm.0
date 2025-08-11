Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB681DF982
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907594; cv=none; b=bFYG7YsM1kTKK6SYVCMRrfyGq3fohfMiFiJvVRZrPIjd4QQPVDSpRGnxhyZ4wjBBMWJjP50smslXjJyHxnIBr+4VQhitbwN4p5G8GMyIfRif8XtFOsKU6kFRUo0USVsNXPAT/nZoUwS0f5dngq0f5Zo4SzpAy45a7xKh6tROWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907594; c=relaxed/simple;
	bh=skqfQ8KbM6JhiomI3Du/zlIAMvGMT+9oqIqODqV+cG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a0ttJkCufUrQO58HlzlEBPnqKnNeZytaJZruZfBhOmeCIKTRoPMY3lqcUTVHOZmDs5SIx+qrltYb561wQOHjuAc2kWqvaVVn+4PBS6oh7zPav9bt/I8qohhd7xL90oIadv7BKxLIGJiZZaQa75gtD5sW0fS2FJn2Z8VJQbOAJgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tNC2OCd6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tNC2OCd6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-459e02731a2so33265015e9.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907591; x=1755512391; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hnRqsahB6ixCE+V/kYk/AxHHS7DMqiBEI4yNzskZKCQ=;
        b=tNC2OCd6zQYom509x5NtIWc4jM0gQqPa0RUU4ISyl392332O1SPaYTR0bO1nPNDGwr
         gM9/GCZ3rWBPXjiTg4S9kBxFJjrFa3ekUBjSt7CQ7W83MIvZI3EKpSSbm4H29aDAPf2I
         DLVHP+itmbYJAA4Wu+Gs5H4x/HU25EJPmZ8yhrAF2zGUlp0gTjb34kJxwaBoAjjwiuCq
         F/GbTeOgh29rzqw1aLgdPHqA7inLbQ94P53vcSli7it1zgVXIiUv32jQfzfl2tRynP/L
         YDZ0lk2x89l0XvL036t00gPOCQcBy9A+KlAsnSE0wVT2DIRUWzFl8yUzwj03P+5klo2y
         u/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907591; x=1755512391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hnRqsahB6ixCE+V/kYk/AxHHS7DMqiBEI4yNzskZKCQ=;
        b=XBNCb9mjarWjbN4fuIzEs55nlqHCA13FuJT1TO9T3OhK2scA+ltH7AjfaYl2J4MwJW
         23FeCtZPU8TAlJVZRAAvB+4X18qRCPV06y4qGW/W3i2kVnoJk/f5jAuwujhzMgWTbMAx
         yuPJ4nZ4GP9t6LGWV4sfKzSBRHyiNfmFM0kuSEVBCepMx9vUqg7vrEmhgC/kpY+vsy3T
         X2bBJU0zp7sFSoPLbfP6N4heIZXVqJ7iAT0Ctkj7I5SX8+s/pD/4i1cxKb9N8Zcvw2Mj
         CgKRjLgace9TSgkYWXGuI0yTlLyzfsbzC/HtK7QdTYDw+kOrfurkwt7AlI1HYZwRdC1f
         jnrg==
X-Gm-Message-State: AOJu0YzuLWmgkeQNcK3Wq1dR1PECZkq0hmhp3OKyAu7UKs0CWxNCAVE+
	uRBp84GPSki0J6OiOUCNhni/Z+7nNvw/X6Q4QAk9bFmmJoXrx90rGpewyIh1nY8QrigFMviiN/V
	dTLIxbEL8wxSayYdXHtL9oRkVImSntWrtJek42YAafd9naBL6O7MpLQvb5fWT9c26vLnMN9MXPb
	MDzieNI/WCSDuO8B8RrX/kHP0JMsrrkg4=
X-Google-Smtp-Source: AGHT+IEmsALnIdUBObLNmVtdjI78htHxobIddAiETD6i+p9WjqtA1PEmQ3Rf3ILEnidkMpgPE0IcOJxURg==
X-Received: from wmbep23.prod.google.com ([2002:a05:600c:8417:b0:456:214c:845d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46ca:b0:459:e3f8:9308
 with SMTP id 5b1f17b1804b1-459f4eaf6e4mr98644725e9.11.1754907591072; Mon, 11
 Aug 2025 03:19:51 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:42 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-4-tabba@google.com>
Subject: [PATCH v2 3/8] KVM: arm64: Clarify comments to distinguish pKVM mode
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
2.50.1.703.g449372360f-goog

