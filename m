Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186742FB093
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402684; cv=none; b=IO2Kto0MpIVw/EY4ZyP3rpn6gUeZ4/IwhcegrmbYpXaX1m+L6DeKjZX3MnrtMP40Knzd5TV2QGibmF0HTwebx/dl2RscVNpepLa+vbslRNT+7btEFguYY1tIUcRNuSPE7oG9D8A9K/RvIzk7GxorF5fEJrBLZCsVz+P1AaAA45Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402684; c=relaxed/simple;
	bh=tUXW+ofNiz02CW8EFmgp/f4HbVtSlArr7sqc/GZq5NM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JbA9qGAOhkEQN6a1egfeCYhtjLptRbfVSMBDnXZMLyBnr03puMro3XXH9BgxAAQjTWRqGkcRVMr91ofY16RcpjaDEo99U8sg/Xqox8yePDjgfNOIL0y3aQKv45y4/zPlPTFgaRHGRqlWRWI8R4tf5H+b2neYAtIR0Luv8imPSYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qproW7Ac; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qproW7Ac"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3e61deaf253so1997840f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402681; x=1758007481; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fpuaZWpwHD1IZjAGpdSGgFXSAYCuUUsJNgHSlQWyn4Y=;
        b=qproW7Ac+kTRMog+luWB9/8QxDZYLQhx7Hhimvifsnwv9vTcoQY3ThiB6VZW7WvUO/
         sYI863Qiraezv1N22XRdI6byfWKKIlOVK4WOc/3slZLKPLKS2iQrqRPy24WdSuqQ34c2
         8z09gdTIV9N4LdHLIjBFHOsC1qWK3Sq3KJdrmDRgsEEHOEQBoy1FdGol/ShX3osQwC36
         PTm952kilxeYPbNqaWrtPQeBZ/nGOA6texyNAmC7mdblD5Uo8HJ95lt3cYCufzhNe3nM
         bpq93BqpSwhw47h0/GUbCldU3L8+3w6sgoOZvDyE+1ih9hKSNdngSIr2ldm5nR4wEy2m
         ycAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402681; x=1758007481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpuaZWpwHD1IZjAGpdSGgFXSAYCuUUsJNgHSlQWyn4Y=;
        b=tZwpq514RbWxNIHybMQDaWvlAlpMdDK8laKMkA6d1Ku/S/i/mPoQanguUSdWE2NQmA
         gwRhA8QGtyv6F06Dq6/whE6MtAZ0VpDnWoTBAkmKPe/S9Cq5POJ19YuQfeyOm0ENinx/
         89OqfB0OOQTyLXMW9eJVhRK6WCtrCJjfMkKp4POZccoVchBk7N6ZALhLz6uvQ9PL31+L
         95qW42LwbvTnllYGlDnheT1nUcIgk9sXKoVGEqh+v+MmfGYvyN3ObY1dJDyAszeuziUc
         u06NAD1MxdR9U/2e7z/5/nj8ORLwT4GUKvjJexnuVfqEftTNL7LVn4efmrl4Dn++BvED
         DRxA==
X-Gm-Message-State: AOJu0Yz7+bpPLJGRwESxmebGEoYq5bz/tSzm+NdDTklLLwixws3kUnMK
	1gKk4hcRO7Iiq4YJs6xGgQIJIOIxSFXWtEK0pXUnylP6qIs0SIUln9oWK887aA7PBiLN9/guX7l
	2ZeVY+R+tGR7PTdAD9/MWgnqK/5p+xpmv1s+6X4FDhoaw52vv+ZlDDMEUk0eiS5O3jFougn0CVE
	9fklI7h71ocQSrCILb3dpWnpCCi8G+QBk=
X-Google-Smtp-Source: AGHT+IFpr4GL3PRIkEBqOVne0CX2qomut3PLzgU4knSILRFgs6WxJvoBwuEb6uQ71mFuNqingc6ATaNeaQ==
X-Received: from wrtr3.prod.google.com ([2002:a5d:4e43:0:b0:3d4:dcf3:824d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2203:b0:3dc:3b91:6231
 with SMTP id ffacd0b85a97d-3e636d8f8demr8014805f8f.12.1757402681337; Tue, 09
 Sep 2025 00:24:41 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:31 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-5-tabba@google.com>
Subject: [PATCH v4 4/9] KVM: arm64: Clarify comments to distinguish pKVM mode
 from protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
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
2.51.0.384.g4c02a37b29-goog

