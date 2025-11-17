Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60D4320CD3
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419413; cv=none; b=C0Dtf+4BPEDr0qnVdh8nvUGq33dMhWknJ0jnx+62yI05Uh984bI2cRfL86lGfYYKT64T86qlQpZTmsQqdHAbFgTFsm5uoXue+hTZwQ/mxaNWnegaavCw4miPyNIG8oRZ8rzmvr97XDTv2wspjMwzMtGBn6XtyCT9b1EIR8b6ZoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419413; c=relaxed/simple;
	bh=aS2/1gIZ662Xsk2KAoOfb91FHTxLFtgzrDg1OiI1Mqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK4O8wz3ZLoMwQ7KQ1kKedxa29JHIrP1sSoXPUWcsYhQzSoCPwXCy47OyGDIT9R46PmWrLEWfwMRrHk+29bF39K4a9IUGJosEZUBOqH8YH1B3bhkAmD7CXMwg/PJa3owj94g3eHpKg4Cc8fq4t31xoWqid2JtV/rce7TVhG/khc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSMDXv4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSMDXv4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C8EC4AF0C;
	Mon, 17 Nov 2025 22:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419412;
	bh=aS2/1gIZ662Xsk2KAoOfb91FHTxLFtgzrDg1OiI1Mqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSMDXv4A6wSJh7/3ZD3F55WTYTt755a9qnE7wUENauYhBDyfsDu9mYi9TQTVhfZnF
	 C1Wiu1I+loHVsrxwQ+XnCXZaqNQyg016Kgahgwj7/qZcZJN/Z10kPkAPmQ69w5v1Wq
	 cKz144CimLzHYjDTf44aV8RSHMBXfipimZl4FzUuXMZwb5WchMxMfrMscC2IMR9FMz
	 7BK98Pvh+4+dHptWC7fmMqDwJK2mADKBtLWn7FmEz1WzIzWMOg5lsmZ+HXbEEcmxZG
	 wSCRjN2bD6uUGXmRQxR2NsK6FSM3QgrC0PohnQcZV2438JQRI0K9Ss14KvzFpr3ZHe
	 uYSG5rWLe5Cqw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 09/14] KVM: arm64: Add helper for swapping guest descriptor
Date: Mon, 17 Nov 2025 14:43:20 -0800
Message-ID: <20251117224325.2431848-10-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
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
index a295a37dd3b1..22e2ee4e182e 100644
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
+	u64 tmp;
+	int ret;
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
+		     : [ret] "=r" (ret), [addr] "+Q" (*ptep), [tmp] "=&r" (tmp)
+		     : [old] "r" (old), [new] "r" (new)
+		     : "memory");
+
+	uaccess_disable_privileged();
+
+	/* STLXR didn't update the descriptor */
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
+	if (r)
+		return -EAGAIN;
+
+	mark_page_dirty_in_slot(kvm, slot, gfn);
+	return 0;
+}
-- 
2.47.3

