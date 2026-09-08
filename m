Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A7857F72E;
	Tue,  8 Sep 2026 16:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884603; cv=none; b=V9FdJ4X3qAUW+/PsZw2MZyIt6eMoRZ01njxi2vWZTWX2p0i9GbG6iKnjhniAHEom326SVtnE0ANf4+7mQkhH6pa9vQSHkkSTmJTP2/KFqFask0tnjaTYZYK5HnOsq7eutfEoMwEdkJpZM1GmWaeKolMtTNLvXhYPy48gkXrpLeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884603; c=relaxed/simple;
	bh=vmaUB5iSk6lw4qSBLxzzmbDWNLrO7NOzUFjs3zuKsbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qny8KFvtUKiIkwvNQVEKfDTGzGVD+rdlGS20VRWib/YKbYiwjU+5jld1LpWiUYgqqDDkc5mvK/bm3a9eeTpvx2VZdErf1P18RMYOh+lcvdCj+nPeCkAG+Gs8pWeTPCL9S8fXrHrt5xbZgFN2et11w/hvgizAPg/jRCYZaIE0dIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gFF+ippZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gFF+ippZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A4B11477;
	Tue,  8 Sep 2026 09:23:17 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EAFB73F7B4;
	Tue,  8 Sep 2026 09:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884601; bh=vmaUB5iSk6lw4qSBLxzzmbDWNLrO7NOzUFjs3zuKsbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFF+ippZOn+9Uh847NfrGv7hLhfT9mTDUoj1KbLPPfGTkup8rmKO7Jw7hVAGDMrQD
	 wxSOeR0i0hFa1EcjDfZMqcMzRvX0H20hpKhsFr4GgPP87Edk0jAVNt+rLTWyhvMMUs
	 /iH9YsBkJRlD0mjkS++BmEGtrgVUrTf4LuqMrgYY=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 09/20] KVM: arm64: coco: arch_timer: Prevent timer offset configuration
Date: Tue,  8 Sep 2026 17:22:12 +0100
Message-ID: <20260908162223.1683432-10-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Confidential guests, including protected PKVM guests and Arm CCA Realms, always
runs with 0 timer offset. Prevent the configuration for them.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/arch_timer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6ac3321f4c575..eba84cab95d01 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1079,7 +1079,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	ctxt->timer_id = timerid;
 
-	if (!kvm_vm_is_protected(vcpu->kvm)) {
+	if (!vcpu_is_confidential(vcpu)) {
 		if (timerid == TIMER_VTIMER)
 			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
 		else
@@ -1110,7 +1110,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
-	if (!vcpu_is_protected(vcpu) &&
+	if (!vcpu_is_confidential(vcpu) &&
 	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
 		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
 		timer_set_offset(vcpu_ptimer(vcpu), 0);
@@ -1736,7 +1736,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 	if (offset->reserved)
 		return -EINVAL;
 
-	if (kvm_vm_is_protected(kvm))
+	if (kvm_vm_is_confidential(kvm))
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
-- 
2.43.0

