Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8614F29346F;
	Tue, 22 Sep 2026 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086717; cv=none; b=okiFAa4Bd1Vo98wc0GaVQRvu5E2pKnG0RM7Ym6WbPv+cBxhNlWNU5hUfXUxyBm+jDj+85CSwE9esYKI5w7Mf/TFAqdzQ+LCLu0VHhqZ6ZzYbHaXP3OMrRxPMzV3UvWn5Db+eESVxybuz4JQ8eoY2ZkHs/og/XgVVm1dYf5eHMSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086717; c=relaxed/simple;
	bh=U/KI+OV6E5hdeRIf8g6CECuITvNZct+Xk6OpTjtj5Fo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AZnBbb0yihl0CtzzhzVM4llMD+80YBoINfwWbFlQokpBNErCTDWx88z3ejr9Zl5G2jlaDfrggGgxBGTYJ+c4vN++o0KyXgh0xJqHtX5EVKFdUVgjZRUasQlqtaoS2b+kdPrLvSGRDnYCs+7zFtvCtSMzA+84tlHJAzIEhW0rTqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gI/963iN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gI/963iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B571F00893;
	Tue, 22 Sep 2026 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086716;
	bh=HUODlUriyITHDyCZbZVg/ianheWjpNd7vPjYh3RGebI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gI/963iNxILhecLZBS2R8YZcyY/nJO+GH93+gpVztoscPZH6tEQAB7Z6+pT+ARUJB
	 c9p3u8563xXVgQwMXhvwQ7ygz4xSrv9sea5dK85BYDpqh7P4bqbVF5qzlmV7iBBRIL
	 SyjqJnUekGwN/drXyBJ6OQjmenoO9d+k4rQPZXmohAEDSdvLSTE46qejmrULZiAeUH
	 UBr3zQhn3cZTZlFezJVplF79Wtnrwduv3mIkL0no9OXkRiiosiuTwELqZNaNddOEll
	 KasQB3jKM2aW7X6WPXx2RovCR+9go47Mcjv8HXK8UhcaE/irxRrz5AMiGlhjfsj7Y/
	 NHm/9PuzJxx+A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 15:17:58 +0100
Subject: [PATCH v3 04/14] KVM: arm64: Propagate and use esr in s2fd when
 handling guest aborts
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-kvm-arm-prefault-v3-4-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2889; i=ljs@kernel.org;
 h=from:subject:message-id; bh=U/KI+OV6E5hdeRIf8g6CECuITvNZct+Xk6OpTjtj5Fo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29Unw3D954u6ST85bRE/xTHY6tupuci23qkOd7kEpt
 0Pn2vkudJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiM30ZGQ4d0tx5plLW5qX/
 lBPKJyW8XSf89+1c/O6+NOe0VomfS+YzMlxadNv9myvXVI118070it/Yc/yB+ySHb2xZV3xXXN+
 /7TYTAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

kvm_handle_guest_abort() establishes a kvm_s2_fault_desc data structure,
s2fd, to store and propagate state to either pkvm_mem_abort(), gmem_abort()
or user_mem_abort() handlers.

Each of these, however, examines the Exception Syndrome Register (ESR) via
s2fd->vcpu.

Introduce an s2fd->esr field to abstract this and propagate it to callers.

The value of this (beyond refactoring) is to be able to later generate
faults with a synthetic esr, specifically to implement stage 2 page table
pre-faulting.

Abort handlers which use kvm_s2_fault_desc - gmem_abort() and
user_mem_abort() - now only reference s2fd->esr and do not look it up in
any other way, which makes it safe to pass a synthetic s2fd->esr value to
these functions.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d8b11817a45f..3cd4dd6478db 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1655,21 +1655,22 @@ struct kvm_s2_fault_desc {
 	struct kvm_s2_trans	*nested;
 	struct kvm_memory_slot	*memslot;
 	unsigned long		hva;
+	unsigned long		esr;
 };
 
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
 {
-	return esr_fsc_is_permission_fault(kvm_vcpu_get_esr(s2fd->vcpu));
+	return esr_fsc_is_permission_fault(s2fd->esr);
 }
 
 static bool kvm_s2_fault_is_exec(const struct kvm_s2_fault_desc *s2fd)
 {
-	return esr_abt_is_exec_fault(kvm_vcpu_get_esr(s2fd->vcpu));
+	return esr_abt_is_exec_fault(s2fd->esr);
 }
 
 static bool kvm_s2_fault_is_write(const struct kvm_s2_fault_desc *s2fd)
 {
-	return esr_abt_is_write_fault(kvm_vcpu_get_esr(s2fd->vcpu));
+	return esr_abt_is_write_fault(s2fd->esr);
 }
 
 static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
@@ -1678,7 +1679,7 @@ static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
 
 	if (!kvm_s2_fault_is_perm(s2fd))
 		return 0;
-	level = kvm_vcpu_get_esr(s2fd->vcpu) & ESR_ELx_FSC_LEVEL;
+	level = s2fd->esr & ESR_ELx_FSC_LEVEL;
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }
 
@@ -2067,7 +2068,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	 * and trigger the exception here. Since the memslot is valid, inject
 	 * the fault back to the guest.
 	 */
-	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
+	if (esr_fsc_is_excl_atomic_fault(s2fd->esr)) {
 		kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
 		return 1;
 	}
@@ -2518,6 +2519,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		.nested		= nested,
 		.memslot	= memslot,
 		.hva		= hva,
+		.esr		= esr,
 	};
 
 	if (kvm_vm_is_protected(vcpu->kvm)) {

-- 
2.55.0

