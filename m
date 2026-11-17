Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937472;
	b=H/58p1mIY5fEsztAuJTYF2uYk5P4hrQgD2RN3DuDdDa6N0knroESaauG8q42bkVRYrjW
	 28c/BKlHRBAvQHlsL/3LSXuC6UDKUC7fky0vZYRzBLQADXvArDryF7HQzdxg0gQIdFOYM
	 PTthGWc6Yfkpv2qeh6DPT55gFo12iN53PRaWttVFzRrr0NVaz5IymNhIgppRNywOXcbzX
	 vchcvpIYh3exwFGvT7wEHz4IfMu2CYFANtlam/ScGS6sCp6ZU6jVk/mzNQ+R6ujze5EPB
	 WdGZ7jtMakOu8eBAPQbXW8Taz7pqI3u3LlHM/GNITnVIslFu+1z4urLc+TQiISTrNag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937472;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=SPtU4gBLJNhzXhU+p7KA/8zxvWXAMb/nxa3idf+KgvI=;
	b=XuCDBlBVS29q+uOip/Km95orQIPUtoAdcYV45OIXl9VFwnL4JXJpO+K2W/QU0xmF/X8S
	 EAE6obGEJ86F2dAanERHY9kvq2OtjpNsWd3pVhjv7mqwNXydL1Uiunm1q2ucxjQFwWynv
	 FVXem/huxT/8nauOiXV8TpoKsj04xa9ArmTkOGdbRPCshVWFXctzZo9M0ElbsBRDQxLcJ
	 ZayMbhgNQ8xeEqsXwh//bxF4jviQeGtmZMnq2Q0Cp3UUh4pPciaxjt1ZX2Eqr92eG062A
	 xvj0ZrdBp0puHLFugW5ESQ0blRfGhDqtESu6UJH3Dah/wlj/IFw6hieOUkblZSv769g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bEnWuou0;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E042C606A33B
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E042C606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bEnWuou0
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1fdde384cso574765e9.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937470; x=1795542270; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SPtU4gBLJNhzXhU+p7KA/8zxvWXAMb/nxa3idf+KgvI=;
        b=bEnWuou03j2PbVSiq5WjRAZB+kAIqC8LWj92WobzwnJeHP2TP/40WMY0xOhraN4iYZ
         f25kAN0D9R0Yf47kksDrjg31YFO3umRMIT+ms213FtKowWQ4q6DSaHJiQW0CBwrZJ/1r
         g67lr2ycp/Y6xNyWLQy7IqPMVo1Nje6KEr64CzwO+iGdgHa0MCfHuNKIqO+GAohlfskx
         O+2LSLksNRHmJW1C12pTx9kCNu4/zUTZRkAFvRnwPqrTO6sP8pnD2BaX3zoM9IkDoQ5R
         Ija9Zpc5ppQ6jcj9WVFnH1WInB9mdlfiTBZfEvH7BvgvVAlRDoq9kd6GIGSPwb0prKKZ
         RB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937470; x=1795542270;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SPtU4gBLJNhzXhU+p7KA/8zxvWXAMb/nxa3idf+KgvI=;
        b=ixZkILjODPsfk3JSb/vPD3atQMUMTlS8eu9FcOTF+pyUah1NVN+DGo+affKLrifCod
         Rar3P8aRMYPg7lxXs8IXQH/c5QzRFrdiHFlZoM6989qXr+OY6i41PhSXHy7BAtrwDgSR
         4oetPCHn0wlpoTlyEJSOISGFenK36HJmF3VNmU6/5ptVsUFBI/trNcB+9bVEVDn6oIbE
         uwuTmfp4PmSghCc1bBYs+8RvtvPg/nYkJhCLkKJK9jtiSio9JFW7hvNCAi5rbpLzleC9
         3dn/+peqZtfX0RirsrIQwasgkRjOGtKYhI7sdOD9/C6TvFtaH2U4CXq+dd8zoBKJkY7f
         ciBQ==
X-Forwarded-Encrypted: i=1; AL+hErGZV36TG/QHA5ZvQtOb+GGzXD1vb+uaoEYlmSHdA/YGNFtOKSBRemP+SSRkoe+5OHFeLSRFZDk=@lists.linux.dev
X-Gm-Message-State: APuU4Z9VMozm+PMscp4pGIttJbnOQq5HZ6Z0S9AhaWsCye6CB2/GoK23
	29QgdHIcuzYzcGmGfn5HaQPH0pTiUtuHPv21E9Kk8ty+N4oA2GMSM2Y4O5Bp7Iy+d+zTcsjietq
	cmrRrs4bscYaqcS6uYpcjkw==
X-Received: from wmbz23.prod.google.com ([2002:a05:600c:c097:b0:4b6:fd58:3209])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3509:b0:4a1:dbdf:17a8 with SMTP id 5b1f17b1804b1-4bb559f2cc3mr299925375e9.2.1794937470147;
 Tue, 17 Nov 2026 09:44:30 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:51 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-13-vdonnefort@google.com>
Subject: [PATCH v4 12/23] KVM: arm64: Add a range to __pkvm_guest_unshare_host()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
add a nr_pages argument to the __pkvm_guest_unshare_host() hypercall.
This range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is
512 on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 22 +++++++++++--------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  2 +-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 6741c9ecb879..3fb55899be6b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -33,7 +33,7 @@ enum pkvm_component_id {
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages);
-int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
+int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages);
 int __pkvm_host_unshare_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 9183406ae04b..030bfc1155f8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1072,31 +1072,35 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages)
 	return ret;
 }
 
-int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
+int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
-	u64 meta, phys, ipa = hyp_pfn_to_phys(gfn);
+	u64 size, meta, phys, ipa = hyp_pfn_to_phys(gfn);
 	kvm_pte_t pte;
 	int ret;
 
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &phys);
 	if (ret)
 		goto unlock;
 
 	ret = -EPERM;
 	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) != PKVM_PAGE_SHARED_OWNED)
 		goto unlock;
-	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED))
+	if (__host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED))
 		goto unlock;
 
 	ret = 0;
 	meta = host_stage2_encode_gfn_meta(vm, gfn);
-	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
+	WARN_ON(host_stage2_set_owner_metadata_locked(phys, size,
 						      PKVM_ID_GUEST, meta));
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
 				       &vcpu->vcpu.arch.stage2_mc, 0));
 unlock:
@@ -1961,8 +1965,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[0] = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn);
-	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn);
+	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
@@ -1979,7 +1983,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn, 1);
-	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn, 1);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[1] = PKVM_PAGE_OWNED;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 66d7493a6549..d92f4da1c180 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1206,7 +1206,7 @@ static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
 		return;
 
 	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
-	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa)))
+	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1))
 		ret[0] = SMCCC_RET_SUCCESS;
 }
 
-- 
2.56.1.708.g77570a6a1d-goog

