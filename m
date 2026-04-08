Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B439185E;
	Wed,  8 Apr 2026 20:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775679976; cv=none; b=Bh5wgjNlpG55zfca15xUl5Sr/MsBTxjSo2EfxX5AY7J8gC/CpO0ArcHsax3dm48Tgn7UGPLenTokYGQEkFm7Kd1J6zM/Elmv6CoIV0I2z4n5I2svnrbI0snuEAZkiYbG1WfG5mRt/Hpn8h/9aPzwv03quCPR5dmdFiq87zIDghY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775679976; c=relaxed/simple;
	bh=bXbJGr21j8KIwFiiL1c7noDATobXMBaxoPNt/uKIZss=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwU49Dv4yNqA+n2zaCrnuE41mic0VuWE7e3+Eu10OxDkH3ETIiSHBLj1qw8v3/Ij91QABYZodx0d9defd0LDSwsNEvJpocSylq3yRpXkCqIMzzJPuEtYJJU0uZbNt3/4k/bA9Dy8q22R+GjtGHlJwDDvwCsGy7QcvNs0n03YrDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ss9zO2y8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ss9zO2y8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=3Lvrg7160Z/M4I9yntFStuMcz07DFNixV35Czjmg9PY=; b=Ss9zO2y8itQqB5aAS2t5XVa9gf
	NFByKDydRED4g2SIhty7U6tV4noYsN32/Xxc4T0Y1Z6H8PudH0+stXT9hiWu2mdlBp9fGZU85exWs
	uQvNhmVg/BSDU+x9/gNpCtww5qYMIGLRZC/70oHlwyA4dQWG+JYQl5rSlBYpxYVsqvd8DEyxmeHrl
	uDxHlYGeoX3gnSXWXbIa8kX/oRrckIg5W0kBRny6u4mK9HxGxT1Z3NGGcgnHReePl+9tllZaLA9bZ
	vrViupqrA6/TorPZj4cckih1sU3daetVlt+gTi/hNBXFyg8MFVzy5AsxKhIarlasV9FNeGSsqktw7
	9cgiGidg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAZTM-0000000AmLv-2Gk8;
	Wed, 08 Apr 2026 20:26:00 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAZTL-00000008oxO-0Ta1;
	Wed, 08 Apr 2026 21:25:59 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 1/2] KVM: arm64: Add KVM_CAP_ARM_DISABLE_EXITS for WFI/WFE passthrough
Date: Wed,  8 Apr 2026 21:23:47 +0100
Message-ID: <20260408202557.2102476-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260408202557.2102476-1-dwmw2@infradead.org>
References: <20260408202557.2102476-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Add a per-VM capability to allow userspace to disable WFI and/or WFE
trapping, modelled after x86's KVM_CAP_X86_DISABLE_EXITS. When the
corresponding flag is set, the trap is unconditionally cleared
regardless of the global kvm-arm.wf{i,e}_trap_policy setting.

The existing kernel command line parameters provide a system-wide
override, but a per-VM capability allows the VMM to make the decision
per guest.

This is useful for hypervisors running a combination of dedicated
pinned vCPUs which want to avoid the cost of trapping WFI/WFE, as
well as overcommitted floating instances where it is necessary.

As with the x86 equivalent, KVM_CHECK_EXTENSION returns the bitmask of
supported exit disables.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst    | 28 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/arm.c              | 20 ++++++++++++++++++++
 include/uapi/linux/kvm.h          |  6 ++++++
 4 files changed, 58 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 032516783e96..e3b3bd9edeec 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8902,6 +8902,34 @@ helpful if user space wants to emulate instructions which are not
 This capability can be enabled dynamically even if VCPUs were already
 created and are running.
 
+7.47 KVM_CAP_ARM_DISABLE_EXITS
+------------------------------
+
+:Architecture: arm64
+:Target: VM
+:Parameters: args[0] is a bitmask of exits to disable
+:Returns: 0 on success, -EINVAL if unsupported bits are set.
+
+Valid bits in args[0]:
+
+ - ``KVM_ARM_DISABLE_EXITS_WFI``: Disable trapping of WFI (Wait For
+   Interrupt) instructions. The guest WFI will execute natively instead
+   of causing a VM exit.
+
+ - ``KVM_ARM_DISABLE_EXITS_WFE``: Disable trapping of WFE (Wait For
+   Event) instructions. The guest WFE will execute natively instead of
+   causing a VM exit.
+
+When a bit is set, the corresponding trap is unconditionally cleared for
+all vCPUs in the VM, overriding the system-wide ``kvm-arm.wfi_trap_policy``
+and ``kvm-arm.wfe_trap_policy`` kernel parameters.
+
+Disabling exits is a one-way operation: once an exit type is disabled for
+a VM, it cannot be re-enabled. Calling this ioctl with args[0] = 0 is a
+no-op.
+
+``KVM_CHECK_EXTENSION`` returns the bitmask of exits that can be disabled.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 70cb9cfd760a..a1bb025c641f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -312,6 +312,10 @@ struct kvm_arch {
 	size_t nested_mmus_size;
 	int nested_mmus_next;
 
+	/* Per-VM WFI trap override; set via KVM_CAP_ARM_DISABLE_EXITS */
+	bool wfi_in_guest;
+	bool wfe_in_guest;
+
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..326a99fea753 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -178,6 +178,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_DISABLE_EXITS:
+		if (cap->args[0] & ~KVM_ARM_DISABLE_VALID_EXITS) {
+			r = -EINVAL;
+			break;
+		}
+		if (cap->args[0] & KVM_ARM_DISABLE_EXITS_WFI)
+			kvm->arch.wfi_in_guest = true;
+		if (cap->args[0] & KVM_ARM_DISABLE_EXITS_WFE)
+			kvm->arch.wfe_in_guest = true;
+		r = 0;
+		break;
 	case KVM_CAP_ARM_SEA_TO_USER:
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
@@ -379,6 +390,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SEA_TO_USER:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_DISABLE_EXITS:
+		r = KVM_ARM_DISABLE_VALID_EXITS;
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
@@ -610,6 +624,9 @@ static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 
 static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->kvm->arch.wfi_in_guest)
+		return true;
+
 	if (unlikely(kvm_wfi_trap_policy != KVM_WFX_NOTRAP_SINGLE_TASK))
 		return kvm_wfi_trap_policy == KVM_WFX_NOTRAP;
 
@@ -621,6 +638,9 @@ static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
 
 static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->kvm->arch.wfe_in_guest)
+		return true;
+
 	if (unlikely(kvm_wfe_trap_policy != KVM_WFX_NOTRAP_SINGLE_TASK))
 		return kvm_wfe_trap_policy == KVM_WFX_NOTRAP;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 80364d4dbebb..694cf699ed0a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -669,6 +669,11 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
 #define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
+#define KVM_ARM_DISABLE_EXITS_WFI            (1 << 0)
+#define KVM_ARM_DISABLE_EXITS_WFE            (1 << 1)
+#define KVM_ARM_DISABLE_VALID_EXITS          (KVM_ARM_DISABLE_EXITS_WFI | \
+					      KVM_ARM_DISABLE_EXITS_WFE)
+
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
 	/* in */
@@ -989,6 +994,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_S390_KEYOP 247
+#define KVM_CAP_ARM_DISABLE_EXITS 248
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.51.0

