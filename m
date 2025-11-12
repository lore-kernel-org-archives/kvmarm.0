Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824F63538AE
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972452; cv=none; b=n6eQ2kQiCs4+e5jQp13LWpRIVwrNnGYYKMEldVkUvGkZV5AMvK5XBoSDJcIs3R/9037e4CTx1aieDtveymQ7E9WxldfS8P7FPix369sJ2XUpT2g+CULrTgzesz/8BYH9Mq1hpy0jeRynD6QLMSeF7WSxHTF38P25qRkF4O6Jf3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972452; c=relaxed/simple;
	bh=rhYIiokCcmiX2VtsSB7m9akVxnJAE+U436RKqZE7JOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMGHcF2zh1Y4KMoP+83slNpTv/RvO9HCSRbPLR+LslR1afD+dy9x+19VvVIlEzCgS8o8UdSzg597Z8/TjQQJdLRyt9gbPIby51P1+bW8Feicg+yCKucvjkFjJr3MvnF6dgNLfAPL35AtZ2ffTbyPzsSfJ31JoFw8BAPq9XkG5c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDaxbdsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDaxbdsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F78C2BCAF;
	Wed, 12 Nov 2025 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972452;
	bh=rhYIiokCcmiX2VtsSB7m9akVxnJAE+U436RKqZE7JOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDaxbdsL7UlRODSTHOR94MHZlFcB8uk/hBf5YnmqpqbnqQsGANoVDDrd3B/FCYlp2
	 ndlpNEX2nxXhSTP2r7SxAyLnTwUAIcU6UG6dCrgmasURb02l6kcKmxRDLSHKZSwMiu
	 KIadcPr/n5QiH11th68bn0yItO0xEQ2zbfnH474F7aK+0qanJz7HNtTG2wbzmBqMLT
	 Jx4MkSdwy/jcDt8HbyHwp5phSGXrZcH4sTRHk/CvQ6fP8fCDnH/xtlvDWlJrUusfLg
	 opBW85Gw92iCNjLDInODqBrq/T/CKOiWuvnd0oocsrRgqBhCV+eoT97m92SMv00SYo
	 OnYg4+NVWuaTQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 09/12] KVM: arm64: Add helper for swapping guest descriptor
Date: Wed, 12 Nov 2025 10:34:03 -0800
Message-ID: <20251112183406.2118981-10-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
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
 arch/arm64/kvm/at.c                 | 86 +++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

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
index a295a37dd3b1..74f3be46fa66 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1650,3 +1650,89 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
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
+	unsigned int loops = 128;
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
+		     "cbz	%w[ret], 4f\n"
+		     "sub	%w[loops], %w[loops], #1\n"
+		     "cbnz	%w[loops], 1b\n"
+		     "3: mov	%w[ret], %w[eagain]\n"
+		     "4:\n"
+		     : [ret] "=r" (ret), [addr] "+Q" (*ptep), [tmp] "=&r" (tmp),
+		       [loops] "+r" (loops)
+		     : [old] "r" (old), [new] "r" (new), [eagain] "Ir" (-EAGAIN)
+		     : "memory");
+
+	uaccess_disable_privileged();
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

