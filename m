Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5BC32A835
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598590; cv=none; b=a0j+i7gLwAtxF3/EVg5lI1utvZ2HmKj35tc3IcaxUE579zcBp4dmUoh+2pd9mu1j9rPGfn5JA1uVE2b1K4mpwL0ZCSOfKX+a9OPcRF8EQiN6OXWVYkamiqP2L0X/SsliRO2tOUkvdYEZfaEIpz6c+C1Qr3HZUPy87bCeNAzW96s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598590; c=relaxed/simple;
	bh=oD5inpjA2IcOCtviwES48RFDBTJqtvXhnvR33T0dpwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AQWS692AloVfziS44yGlm4DTxT9kBIezQjm/0yc0MO3deamQM+3v0yZ8HuRb5Uf8arTBmFwl1WVw7g7o/26L8p7s6jj7ytXRkAHUtjjSP3ADVscZ2VI5UApXnC1yTpGgPBbg94jqF0mz3NBMBYOshUkmfj9UJ+6E0ZGyahsAaww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLHbNI8A; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLHbNI8A"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3e751508f21so584923f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 06:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757598587; x=1758203387; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isdwFXSTuI6vyPoZ5KEzSCMF3I2UJtuA1www3knapSA=;
        b=GLHbNI8AXsXrWEsaLDtDmyGRPVSQO/jRd/VoM/6sI6V2Nuo4AdVckue72v9cxS0dw7
         gEzaTJsCQRfih8cKthz3qLZHsXeAEjL7ZDELyBe1OwlNtqESKF/QYQoH4rhwK/I6TXIm
         LYb7U+GbBwvotXV6hNpAdFfQRQxRc28EfUIzgFd3d1IR0OUhaUEh1wM2ywoF0Krgu4Xw
         M2k0iu+X+Mt873SUpN+ZWxQUIWh8HBh0lNWHu091+E9OipYwNuhc2yzx9ZDCBB4Te0TW
         0jOX6yIyrY3rge6EQmkf4MP2thDDdVrrCp+fgFJF0pZqcaB66drfos+FP3Knetjz0S9T
         2XVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757598587; x=1758203387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=isdwFXSTuI6vyPoZ5KEzSCMF3I2UJtuA1www3knapSA=;
        b=FWq86dEbxJuDQxSADY97kCseFlvsf+lSlg9pI3ZoiSNVXYXzydJnGkfB4SRwv9weR/
         /cfPlwMiRmLGfXucY0DRgjs7DXL5B2ukHeS1Ep4g2VF1fhw+hzpuSnCSHe1y7Mtfx9Yg
         op7AbBIMkpQfI3/LGq0zXv0jWAa+IdB07T9vaeh/7rOoTsPEESLvWuWorOkALx9oxRjb
         0e5gR7m6rBzHRc2LOo8moCcy6+iIRjMGSeXwWJVC343grpsOyvlj7jo/yWXvwSjKOJA7
         golMndpJkcI0fwIH2MPbMGq4txpJTyELzNYc1iTZMRTfxHfdvyCh1uVs1WDBDfZh1YWW
         EscA==
X-Forwarded-Encrypted: i=1; AJvYcCVV2NrkAwkOodXlJH8E0zp/hiPZ8YcCl4hzh+GWXESQVuf44EItTcW7xVpYmm43J/50bIqGWsk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqHdgsviuvAETq8w7vhr5Wn2HHxTJ8+7b03TNGRZv7usEoohpK
	Kt0q4hNXTO2Z+ykvPJhuV5YOQ02na6YQKlwg+ndS2tyCU+LoiH/UYb52
X-Gm-Gg: ASbGnculd4kbcqSLKT3970z3HuMhNYBv+K8dDRbDtJrBL5dqEh5KdUF9o/Ab4pWg5nt
	SxLFt2J/JQ9nGIQ0+ia01E3utYuSw8ou8JiZ2akVCWjMQBVYMNGGCgMtxlOd8CI57xqBLNcdA44
	6tKqm6XvK6bPuwkrNre44CpIn4FPTm6srCfWyMH3YBjtkMT9Y7UuCHxi+AakJwvCcSIvkPZdNnN
	rBirgp6xYzuvOM/HS/6J4+XGP+wjelwAmF/ajwmJCmMFYu0pk8cBQrEPpjaXRP7DViHSoBcaXQB
	MFMXz1pEmv53wVeR0Ri357i7Dno0QGLWrtnrfEGoX82QZO3j6UumBSW+Hily7CNec4es3jKVQSw
	qK8coNCnp/MN+xw1/PuLMpBLgRswdzFKcgP3ed3b3jNGN0L+RKH5vzkoV1CXftJ4b5LdHXGaD
X-Google-Smtp-Source: AGHT+IEUm00hUmaf0xUsT6+9m3Zb4ZN7y4GJW9ZTUjRe1MIWGQuwO5e+uMIcjcSuvIP0YWNV9JWh1w==
X-Received: by 2002:a05:6000:2385:b0:3e0:152a:87ad with SMTP id ffacd0b85a97d-3e64bde9161mr15064477f8f.31.1757598587245;
        Thu, 11 Sep 2025 06:49:47 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760778915sm2608361f8f.12.2025.09.11.06.49.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Sep 2025 06:49:47 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com,
	roypat@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH 3/6] KVM: arm64: Add pre_fault_memory implementation
Date: Thu, 11 Sep 2025 14:46:45 +0100
Message-Id: <20250911134648.58945-4-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250911134648.58945-1-jackabt.amazon@gmail.com>
References: <20250911134648.58945-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Add kvm_arch_vcpu_pre_fault_memory() for arm64. The implementation hands
off the stage-2 faulting logic to either gmem_abort() or
user_mem_abort().

Update __gmem_abort() and __user_mem_abort() to take the pre_fault
parameter. When passed, the paths to determine write or exec faults are
short circuited to false, as when pre-faulting, it should be treated
as a read fault.

This closely follows the implementation on x86.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/arm.c   |  1 +
 arch/arm64/kvm/mmu.c   | 71 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index bff62e75d681..1ac0605f86cb 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -25,6 +25,7 @@ menuconfig KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_VFIO
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 888f7c7abf54..65654a742864 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -322,6 +322,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
+	case KVM_CAP_PRE_FAULT_MEMORY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 082e7d8ae655..002f564c6ac7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1523,7 +1523,8 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 
 static int __gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			struct kvm_s2_trans *nested,
-			struct kvm_memory_slot *memslot, bool is_perm)
+			struct kvm_memory_slot *memslot, bool is_perm,
+			bool pre_fault)
 {
 	bool write_fault, exec_fault, writable;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
@@ -1537,6 +1538,9 @@ static int __gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	int ret;
 
+	if (pre_fault)
+		flags |= KVM_PGTABLE_WALK_PRE_FAULT;
+
 	ret = prepare_mmu_memcache(vcpu, true, &memcache);
 	if (ret)
 		return ret;
@@ -1546,8 +1550,8 @@ static int __gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	else
 		gfn = fault_ipa >> PAGE_SHIFT;
 
-	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+	write_fault = !pre_fault && kvm_is_write_fault(vcpu);
+	exec_fault = !pre_fault && kvm_vcpu_trap_is_exec_fault(vcpu);
 
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
@@ -1599,7 +1603,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		      struct kvm_s2_trans *nested,
 		      struct kvm_memory_slot *memslot, bool is_perm)
 {
-	int ret = __gmem_abort(vcpu, fault_ipa, nested, memslot, is_perm);
+	int ret = __gmem_abort(vcpu, fault_ipa, nested, memslot, is_perm, false);
 	return ret != -EAGAIN ? ret : 0;
 }
 
@@ -1607,7 +1611,7 @@ static int __user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			    struct kvm_s2_trans *nested,
 			    struct kvm_memory_slot *memslot,
 			    long *page_size, unsigned long hva,
-			    bool fault_is_perm)
+			    bool fault_is_perm, bool pre_fault)
 {
 	int ret = 0;
 	bool topup_memcache;
@@ -1631,10 +1635,13 @@ static int __user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	vm_flags_t vm_flags;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
 
+	if (pre_fault)
+		flags |= KVM_PGTABLE_WALK_PRE_FAULT;
+
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
-	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+	write_fault = !pre_fault && kvm_is_write_fault(vcpu);
+	exec_fault = !pre_fault && kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
 	/*
@@ -1895,8 +1902,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
-	int ret = __user_mem_abort(vcpu, fault_ipa, nested, memslot, NULL,
-			    hva, fault_is_perm);
+	int ret = __user_mem_abort(vcpu, fault_ipa, nested, memslot, NULL, hva,
+				   fault_is_perm, false);
 	return ret != -EAGAIN ? ret : 0;
 }
 
@@ -2468,3 +2475,49 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_pre_fault_memory *range)
+{
+	int r;
+	hva_t hva;
+	phys_addr_t end;
+	long page_size;
+	struct kvm_memory_slot *memslot;
+	phys_addr_t ipa = range->gpa;
+	gfn_t gfn = gpa_to_gfn(range->gpa);
+
+	while (true) {
+		page_size = PAGE_SIZE;
+		memslot = gfn_to_memslot(vcpu->kvm, gfn);
+		if (!memslot)
+			return -ENOENT;
+
+		if (kvm_slot_has_gmem(memslot)) {
+			r = __gmem_abort(vcpu, ipa, NULL, memslot, false, true);
+		} else {
+			hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
+			if (kvm_is_error_hva(hva))
+				return -EFAULT;
+			r = __user_mem_abort(vcpu, ipa, NULL, memslot, &page_size, hva, false,
+					     true);
+		}
+
+		if (r != -EAGAIN)
+			break;
+
+		if (signal_pending(current))
+			return -EINTR;
+
+		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+			return -EIO;
+
+		cond_resched();
+	};
+
+	if (r < 0)
+		return r;
+
+	end = (range->gpa & ~(page_size - 1)) + page_size;
+	return min(range->size, end - range->gpa);
+}
-- 
2.43.0

