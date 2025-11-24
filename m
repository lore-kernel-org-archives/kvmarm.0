Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5D52D481F
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010922; cv=none; b=n28BqycC0gPH5rIz6O6mTazWm1W7TeLNfarGJN0dozLPS5Wl9mabVft2LlKU1kg7JXMaSTknemWPpcGM0+AyXwQgEW+mfOMsojFK+E9eLHmwBRghdmCspkJ5zVE7NS3xqXfcsHCqGv2ZWJvwg8xbdiGmwzLR/9Jwr426I3s270c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010922; c=relaxed/simple;
	bh=xUX/L/LAK+bOIk15OqFgaWh22SGM/m8q+Er09IG0f+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFJGZYNygwmQ+b2Pl19cHW8GLeOu4caCkL/BMox+mkzacQxbE3aZ9ByvkRXWZCMXxtLxkKTNDGo9nQtj8T24hAJBbxXiw3D1FzcSCB+VaPxMslvU2Ax2GzHYbBHUosEqg3RnRGUQQ5HKGqOIlHxaskNxKERFww245/flpgOMBqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFkj2bH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFkj2bH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D197C4CEFB;
	Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010921;
	bh=xUX/L/LAK+bOIk15OqFgaWh22SGM/m8q+Er09IG0f+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFkj2bH7LchGdp9Ev3FSEwulK2BcQs9NjpgkZuw9oSKrnbucF/JMp/GGf/2z2Ioc+
	 04t557IaygcNbggFDyd4+h7lGQRoEDhdK6p1UFTVhjYiOcwPWX9xc/L/drSHWARX+U
	 8jfgMQphSXiaInJhn7938YUpDEiYcfaHONV+HU2mJbsAjivxkpiIt/n24EN2xOZauw
	 X0+f6K775kQHSJni0GGrP6dS8Kixcq0D1Fp7FCk7Ap8+V3+MGKQmfWaPQVgOxnTXMB
	 TXKywskqoMVvzKU35C8DZM/eFyBz7R1/LF6c72+uHZYGSVTdRKjFBf71Q7o2I7ypp4
	 pToZLpJwGKyNw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 10/15] KVM: arm64: Add helper for swapping guest descriptor
Date: Mon, 24 Nov 2025 11:01:52 -0800
Message-ID: <20251124190158.177318-11-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implementing FEAT_HAFDBS in KVM's software PTWs requires the ability to
CAS a descriptor to update the in-memory value. Add an accessor to do
exactly that, coping with the fact that guest descriptors are in user
memory (duh).

While FEAT_LSE required on any system that implements NV, KVM now uses
the stage-1 PTW for non-nested use cases meaning an LL/SC implementation
is necessary as well.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +
 arch/arm64/kvm/at.c                 | 87 +++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5d967b60414c..6dbc2908aed9 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -403,4 +403,6 @@ void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val);
 		(FIX_VNCR - __c);				\
 	})
 
+int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index a295a37dd3b1..581c4c49d9cd 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1650,3 +1650,90 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 		return ret;
 	}
 }
+
+static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
+{
+	u64 tmp = old;
+	int ret = 0;
+
+	uaccess_enable_privileged();
+
+	asm volatile(__LSE_PREAMBLE
+		     "1: cas	%[old], %[new], %[addr]\n"
+		     "2:\n"
+		     _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w[ret])
+		     : [old] "+r" (old), [addr] "+Q" (*ptep), [ret] "+r" (ret)
+		     : [new] "r" (new)
+		     : "memory");
+
+	uaccess_disable_privileged();
+
+	if (ret)
+		return ret;
+	if (tmp != old)
+		return -EAGAIN;
+
+	return ret;
+}
+
+static int __llsc_swap_desc(u64 __user *ptep, u64 old, u64 new)
+{
+	int ret = 1;
+	u64 tmp;
+
+	uaccess_enable_privileged();
+
+	asm volatile("prfm	pstl1strm, %[addr]\n"
+		     "1: ldxr	%[tmp], %[addr]\n"
+		     "sub	%[tmp], %[tmp], %[old]\n"
+		     "cbnz	%[tmp], 3f\n"
+		     "2: stlxr	%w[ret], %[new], %[addr]\n"
+		     "3:\n"
+		     _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w[ret])
+		     _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w[ret])
+		     : [ret] "+r" (ret), [addr] "+Q" (*ptep), [tmp] "=&r" (tmp)
+		     : [old] "r" (old), [new] "r" (new)
+		     : "memory");
+
+	uaccess_disable_privileged();
+
+	/* STLXR didn't update the descriptor, or the compare failed */
+	if (ret == 1)
+		return -EAGAIN;
+
+	return ret;
+}
+
+int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
+{
+	struct kvm_memory_slot *slot;
+	unsigned long hva;
+	u64 __user *ptep;
+	bool writable;
+	int offset;
+	gfn_t gfn;
+	int r;
+
+	lockdep_assert(srcu_read_lock_held(&kvm->srcu));
+
+	gfn = ipa >> PAGE_SHIFT;
+	offset = offset_in_page(ipa);
+	slot = gfn_to_memslot(kvm, gfn);
+	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
+	if (kvm_is_error_hva(hva))
+		return -EINVAL;
+	if (!writable)
+		return -EPERM;
+
+	ptep = (u64 __user *)hva + offset;
+	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
+		r = __lse_swap_desc(ptep, old, new);
+	else
+		r = __llsc_swap_desc(ptep, old, new);
+
+	if (r < 0)
+		return r;
+
+	mark_page_dirty_in_slot(kvm, slot, gfn);
+	return 0;
+}
-- 
2.47.3

