Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789041;
	b=RtIvJokeb/1tlGxmWnDlBWO2mCCTsa00WuUZVMaXCck7/C3Wc44o9K9uCJKxKEMCxYEL
	 +AKM3VZ5geJlOBr+AxQGMeIize7FpBnrTXGl4FIvrvwA41mwDDT/sm/y/0XFC9L4xkGhU
	 KqJKAP4CyK5U2n/vXCZMD7YGG/yoK9PFnKSXn9jbhdPZwt7W/BYr/X+CQzTCmVGuBLzHO
	 bVBJ4NBmx0Dz76v7cHiEQuPVxDmHknjqttayQd9b+WoiuB/oiSfo7c5OaatSPzXl3dIOI
	 9dy7Mo9YrOX5J/PYKjKgjLa0SkX2UBfawJa46zJNjqRi8j+RMc5hcSuO5SSNTfLjkOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0IdhmF99LDl77/hLE03LlaYclWDXFfvPTPVFK1qF/Ls=;
	b=EywnuwyDxfjycN+DAsDOwdU8nBi3blHm1YARyVKN3E4H5lqsYhBSuzLWHoPu4DGqrIqR
	 fx3h7We411dxPb2m0NnVntn0AP6RShQDEa2yjs5uEbPWGolJpSwiJbzCOkqE1Z48zJUcw
	 +u9JxevoIAAKuAR3kVUMAFnEI/C98ct/+EtZ9oXdUbGrxKwiA1KEXWxwrmIwmAHYplk21
	 z3Cz+RjQd3KChAfj5ScNPOodsvboHXMlejB841U/2Nli+EXu9TNFD8Kw7kefCLv52uoLv
	 2/KUcKUfPKkfYlvikoD3i7HAQn+1lHbYkA5W5j/Obc1I8Gv2E/Vq1zDahk10O9nCOWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXQohEER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9FB606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXQohEER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE641F01825;
	Fri, 23 Oct 2026 20:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789041;
	bh=0IdhmF99LDl77/hLE03LlaYclWDXFfvPTPVFK1qF/Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXQohEER0xpnibfQUn8O1Dh6PT9A11oJdnPncaQ8+1bq22NYRJ4qthgxT0sb4dAIQ
	 ybl3LDbFGQpg+aU+5ZJAsXP2kE4h2dwhutFtRRjN16AbwS5in4M8xjyiE9+wbeZzOr
	 aoyFqo8gpBDJ0S0OlrJ/xzW7BLcGEusmP07lSfocvh4RFlgXY+oCHrk53Icxbjlmcb
	 g8tvUXsAFP6/IfmHs1z3h6e3SVEJjXEkMFIMKpLMDTtFb5Qc81knXEhcKQwpFK9GVG
	 +VhVy8Oa41h0KtuW2UKZ9wgG0+waNKcu+PXB/AKHlK46QejJHekXCaVabxsk62PJqj
	 8+d4svOQ9WdKA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 20/28] KVM: arm64: Reject non-coherent DMA when using forced writeback
Date: Fri, 23 Oct 2026 13:56:02 -0700
Message-ID: <20261023205610.1044532-21-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assigning non-coherent devices to a KVM guest subject to forced
writeback is broken. DMA through cacheable aliases and CMOs work, but
using non-cacheable aliases for buffers on the CPU does not due to the
implicit promotion to Normal writeback.

Non-coherent DMA is fundamentally incompatible with the direction of
travel on KVM/arm64. Draw the line in the sand and bug the VM if FWB is
in use. Users can use the newly-added kernel commandline to fall back to
a non-FWB configuration that *actually works*.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1c6632216e32..5672721416a4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1565,6 +1565,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
+#define __KVM_HAVE_ARCH_NONCOHERENT_DMA
+
 #ifdef __KVM_NVHE_HYPERVISOR__
 
 #define kvm_vm_is_protected(kvm)			\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d593ba928093..f08a450184d9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -133,6 +133,20 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		return;
+
+	pr_err_once("kvm: noncoherent DMA unsupported with FWB, see kvm_arm.nofwb\n");
+	kvm_vm_bugged(kvm);
+}
+
+void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
+{
+
+}
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-- 
2.47.3

