Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD74B22E3F0
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993503; cv=none; b=hB2+GQI13klmc1+xa3gTwFaOJhlTQdoDSWPEChofiJB02hFhP8d4JX8iLyOe2WZe4J536AiegamQoSGjtHmazHXD2TqmgauQEX8G26O4toSPMezjH31RVO38SLBjeJhOa0wcKDq+c+aYv6LLNRkilJnDhOMp+C+RYfVH4zxmAUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993503; c=relaxed/simple;
	bh=0oexpWMVPOMBg/tm6NN+hzxx55lhIoUeedDj8t8xquQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X6SLNsqy9FY4cfIn4DKv9c6aJGRgZSpFOI6iTCp77KAtyso9GQ6AzzOFHMf0CZcuvR0dBcxmx71YTo8OhiFjVn3hibtol6sE2sQu56yDqgmleVDMfUk/5kTVsLQM2/AckxGc3RZPQczqK5TDVRQXwhnYJqR07DPIv7uq1kHAn8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B/g1G+OX; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B/g1G+OX"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8fa71b83a0so58803966b.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 06:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993500; x=1771598300; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jMJHo973aYDR+UWfROXQvwm6KfmNQpCUXcX+kTjqb1M=;
        b=B/g1G+OXHBd53Ve+speNeLmWD6yBA26CvUwyWgyd2L63/+AiZF4o8iozQVigtq/jAb
         i2fFpHWA9jL/PvAFQyXpGBY7mmZC3jZERqFjDCvtCqbakTvCHjpT4f5qBotQXE7elQu6
         SQKicyVpNsmAnbJHKcevAQV4+gFRSLQmaMN1xoVc2LpO3sv5vAvRkHzFjaJMK3Vlo/UT
         1aPCpvo75CrFvAHIQGwQ2VKkrZ2C48lPvqsC8wVyb9aBQpKJrFLNAolqdnYvPbKTkUyL
         GYFfQbjELPrpPhojeFaogGGN9BZIwm/VkctyKVudNXsmlCU6nsNZS2vkTNkUuIbbOeIi
         oKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993500; x=1771598300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMJHo973aYDR+UWfROXQvwm6KfmNQpCUXcX+kTjqb1M=;
        b=hG2e23uG/GeYbuLqOYE3C2ZzPKK+3BW/PV94Ijn1Ju3W7EveDzhyA3xxcAZjTUr8Sj
         ijzH0qXM2enOZsaxwQ+PvRyFxYyQakbqSR6pQqmY1YUPaUcBgTCVoLDjlIeZ4wSqs3FO
         yMRj6kZqdBYQ0xLgGSwc/iDpZ0kEUbu69lvnL/1KqC7i4b71/imvNZQuIOO+RX2x5/rj
         SlodhL7icYQxLRSLTFZ9IdU5StPZKcPvbrcE+Qpuv7JgrItS1dpafebQfPVaXBR8T2VT
         EeW6D/Zi+XwFrQxNffXsPzoL4fenccMBXES5KD9v258O3N07dqd4aBelniL7OhgoHAD2
         ZviQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs1a+uc0FyYXTbjaVz6n74KVwrnpOyJuofaZx4J3IFIM/akxaz0q6iSxIifvI1a1IkM6GySxg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM4yAT3H3+tbGsdAEmgWSRPDwGctLVo7Z4Go1KugWCcu9Me9px
	iDeXEPobxXt2CRpDXChfPxI3XIOZ4YM+jEK6MaB9gj1/+KoofF9HpsSS8nOs2a+z/pCcbnwx10m
	g5w==
X-Received: from ejrf19.prod.google.com ([2002:a17:906:7f93:b0:b88:47b9:4312])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3f8a:b0:b88:22f1:768f
 with SMTP id a640c23a62f3a-b8fb452e1e2mr118012766b.54.1770993500038; Fri, 13
 Feb 2026 06:38:20 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:14 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-4-tabba@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Fix ID register initialization for
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
the hypervisor `kvm` for non-protected VMs during initialization, since
we trust the host with its non-protected guests' features. Also ensure
`KVM_ARCH_FLAG_ID_REGS_INITIALIZED` is cleared initially in
`pkvm_init_features_from_host` so that `vm_copy_id_regs` can properly
initialize them and set the flag once done.

Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 35 ++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 12b2acfbcfd1..59a010221818 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -345,6 +345,7 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		hyp_vm->kvm.arch.flags = host_arch_flags;
+		hyp_vm->kvm.arch.flags &= ~BIT_ULL(KVM_ARCH_FLAG_ID_REGS_INITIALIZED);
 
 		bitmap_copy(kvm->arch.vcpu_features,
 			    host_kvm->arch.vcpu_features,
@@ -471,6 +472,35 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
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
+	if (test_and_set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return 0;
+
+	memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
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
@@ -490,8 +520,9 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
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
2.53.0.273.g2a3d683680-goog

