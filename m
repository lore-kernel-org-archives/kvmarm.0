Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8952DC763
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 09:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886978; cv=none; b=eolpC1e2MqQT8eg6pTBfwNfjfZ16bKmijo5tjcCZYHVxUQZjS2B+rMgj8ClpI27R9Cg9tfMIUcKvIKUaZarOhO68Z73Qu64HnXx8qrCslGnCeSni8csVrq6DxqK5FySOMEfMTR8wjSVS8Xf5hSVC5wDxXI/G4XZdJzl/DLoU54I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886978; c=relaxed/simple;
	bh=Lg7kND86VXNrl9kVbjruzNAW8/pyZ1wa8nTrxBB+aro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h2Ea4n0rVxRsxi7uRS7NsNg61QUxo9mjccng/RJbr5f0f/uWg9BDS50qBMXO3v4u89aYkIHDiU2tIPF/y9Zt7U+pzETxuza4IYTW8yqZz7h3e2OZ70WwrgFDMVUsKQ+Va4RoaOS8ILbMo3t9pzrnvOvCjVCDJxZBa5eeL2PArqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AB0EDe++; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AB0EDe++"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4832c4621c2so55823185e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 01:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770886975; x=1771491775; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=okszUF6rn81wokN6MFCx8nZtl6u7oamXEuCUR6T4heI=;
        b=AB0EDe++ajO5+UCqORxIpVPMogb3lhlpLilKGQvK8rh3v+uwtPgW4PknVk82SAcde+
         DFE4viupwBo2857deIvKBGgU5vWvfT0Vf/ytmgcclUlABAFR7tMv541XuJXXM83weOgy
         9YrTr9P93gnMfR0TVfldvij1j/F5tsOvw1zOgKpCDuiLenQRg66fQWViaL9jiFDHR9FU
         2HHkJ9TWyHEpReXISAfDXi2h0mJAJG+lqd934FnnaMUEad5mzfq6G+SbsdjR4/z2MgJR
         pRjkrEZC7KuXtAp01iBbpocayIeBIQQPjPWrE3Ao1ZD4W+chdZk1U0UFEFpheGbcw6Wc
         RF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770886975; x=1771491775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=okszUF6rn81wokN6MFCx8nZtl6u7oamXEuCUR6T4heI=;
        b=XV/DGQkoJ09RiSxsE6p62OQKAMb3XYyQ9+Z0EFdq8zk1M7vujNXeCB5FkFtDzLVMQ7
         B9YfYMkl4KlstxpvSj9IrL9aJLNzbrdaprnogdMU/1VqweVjJUN9QqMz9Bb0xhioo+So
         bGAQ8T2h5kDiGK2GSwM0ihBYNNf6dBVP7XjWDZaIZDqmcFNEthRVJGFZDUBng0q21PLr
         6BRghbYShIvwsh1DnLPtjnHv+lKunuh1S04oQ1mFL+8JheePknd+627D3chRja0wzAGp
         fuHN23IH95J1XNOMJtva4d7IciPRlxJzxxzxAsZb5GC5XxnqGIQs6gWJjmfylla6Tpvh
         bjAw==
X-Forwarded-Encrypted: i=1; AJvYcCW3fgKS/R5IN66WLmBc1k/lUFY6QpIGc3YM0WoTRnV3D3B/CmFwUB631eWT4FjJpZOnKMQpOps=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcMPAbSVXz8Eq7kEaHJEa8aHsg7ks2hdE6JiFsJFsDlP8R+d+F
	alsrgrRc7GJj+xutT5gqaQU2s1fsgPkOBU/zCaBTAxcfU8mjGnlEVqV9iNfPvBNijccQHBUpNXD
	Mdw==
X-Received: from wrbfv12.prod.google.com ([2002:a05:6000:2c0c:b0:437:72d9:7316])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f48:0:b0:436:3475:3687
 with SMTP id ffacd0b85a97d-4378adca042mr3331122f8f.57.1770886975548; Thu, 12
 Feb 2026 01:02:55 -0800 (PST)
Date: Thu, 12 Feb 2026 09:02:51 +0000
In-Reply-To: <20260212090252.158689-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212090252.158689-3-tabba@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Fix ID register initialization for
 non-protected pKVM guests
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In protected mode, the hypervisor maintains a separate instance of
the `kvm` structure for each VM. For non-protected VMs, this structure is
initialized from the host's `kvm` state.

Currently, `pkvm_init_features_from_host()` copies the
`KVM_ARCH_FLAG_ID_REGS_INITIALIZED` flag from the host without the
underlying `id_regs` data being initialized. This results in the
hypervisor seeing the flag as set while the ID registers remain zeroed.

Consequently, `kvm_has_feat()` checks at EL2 fail (return 0) for
non-protected VMs. This breaks logic that relies on feature detection,
such as `ctxt_has_tcrx()` for TCR2_EL1 support. As a result, certain
system registers (e.g., TCR2_EL1, PIR_EL1, POR_EL1) are not
saved/restored during the world switch, which could lead to state
corruption.

Fix this by explicitly copying the ID registers from the host `kvm` to
the hypervisor `kvm` for non-protected VMs during vCPU initialization,
since we trust the host with its non-protected guests' features. Also
ensure `KVM_ARCH_FLAG_ID_REGS_INITIALIZED` is cleared initially in
`pkvm_init_features_from_host` so that `vm_copy_id_regs` can properly
initialize them and set the flag once done.

Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 37 ++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 12b2acfbcfd1..267854ed29c8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -344,6 +344,8 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
+		clear_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_arch_flags);
+
 		hyp_vm->kvm.arch.flags = host_arch_flags;
 
 		bitmap_copy(kvm->arch.vcpu_features,
@@ -471,6 +473,36 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	return ret;
 }
 
+static int vm_copy_id_regs(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+	const struct kvm *host_kvm = hyp_vm->host_kvm;
+	struct kvm *kvm = &hyp_vm->kvm;
+
+	if (!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_kvm->arch.flags))
+		return -EINVAL;
+
+	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return 0;
+
+	memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
+	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+
+	return 0;
+}
+
+static int pkvm_vcpu_init_sysregs(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	int ret = 0;
+
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
+	else
+		ret = vm_copy_id_regs(hyp_vcpu);
+
+	return ret;
+}
+
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 			      struct pkvm_hyp_vm *hyp_vm,
 			      struct kvm_vcpu *host_vcpu)
@@ -490,8 +522,9 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
-	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
-		kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
+	ret = pkvm_vcpu_init_sysregs(hyp_vcpu);
+	if (ret)
+		goto done;
 
 	ret = pkvm_vcpu_init_traps(hyp_vcpu);
 	if (ret)
-- 
2.53.0.239.g8d8fc8a987-goog

