Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652431;
	b=lsDUn6ecrRmkFfOya918r+nq6/v/PCDQJViE9aq2KSG+OqXt/Nq7+jGgNGTE78ua/CDB
	 qtpj3c5gEQTZnDYerC5oPq2ZnxKPI3s1hu54jOxHthEEsRlulBF1hrVTI/ER8Yq+IVg9v
	 C+dJ2t9nHS2ajW+opH9xZ4b/HvqIImHU3EZmAS2bF082vSbAZ49UzBZg0xYQo1JZZK1h9
	 k3+cHm6WDn421Yea2pLr5VWGI7E42QYTgJHWDHqJtNWZe8ANgOT4SyqqFanidCg//WBmD
	 PzPMg7OwUSm3/OJH0hstSE3Y7rGkr074VqatQtUXsbBU4eB/qxk65xBT6v3wokuKHdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652431;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=O33+NCycmOfzcP1ZcAQN9xwtoCagQjbgxHzNinMkOtI=;
	b=HM9h1K0FOcaB3J7DW9zCv04GefXh9637sh+SokjN9Ri8Nwg5nz1wfYuADsqUdLh7i87E
	 4m0kmCJRmVysONqf/CyDVB1T8xgS3KTDW3efyYvb6247a49r1SmiQHHtjoeY6GAtLio+k
	 DjCd4uRTMyQohjaWPO20lxnboyYr00FLvzr9Or65Z042myg2CaVV/wYuaDKW9PCCIq4Qd
	 9Va/5N1G26bg2DZmsh42sAujCjEh7/eVB+dB9R/Sl6YwQ7EOPSmidnVLt2QWnvT2FnCyU
	 XnOMZheMhe60nFG4Yc4gY87PWScsJv79+YCsnYKGHg1FICelngBkZhCWEwBTkk/V2wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gAjt0DqK;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E59606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4E59606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gAjt0DqK
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a16dc2323cso29285885e9.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652429; x=1794257229; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O33+NCycmOfzcP1ZcAQN9xwtoCagQjbgxHzNinMkOtI=;
        b=gAjt0DqKwoh8skoC1F6/W/TW8dAvxr3zoIeGklyNBwrMd5stHPtHSjqam4/Sd5xS2e
         j9AAMl2tqPQ3QNtKsl4yBE17ofn+1w/wA11fn/UtJwzzzRgUtgpD4aio/9J8KC2Im94c
         5GNx9sRrut+ypOoOx7sBaG0Hmb1KVwuOubGzPublODnfmUnpMbNvzsOo/pqZTFkYVB0v
         0T+UafIM0Lk/dHcqulr4egfTpwX4qoxd/Cb/SpxyIPZFoem611VD0O8XOmyCIADKiHnO
         qGYv8DfygQidX42eZFza20S90oCxl68M0oLja307hlH7M8YjMS6Fhwr9UkJ42F26zPik
         atog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652429; x=1794257229;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O33+NCycmOfzcP1ZcAQN9xwtoCagQjbgxHzNinMkOtI=;
        b=CQBamNG1wh/+HwMDPxAuxKSak+W9woFC3+QJUU8UKY5LjQTI9JluUN8nQxzwBQhGjS
         V7XprKd+Ukr03VusfznQGwOOLxhs/KHVrmrHY1oU1/RqgXrjMlQ5w6/Y9yPTiMCkEDL5
         5j6nI5wO/cLn9gSH4FSoDpES6D7ZjbbRTumXxCN2OaKhvxmRdSTKXY6+lUdF02weLD5C
         PF+hwOt4YvUCpcIPplVGpihwD80kgOpChAeoQfjzDkhYKt8VZ03j7r0dH3l9ikrxE3Wt
         of47EKxm2MnTcDw/Nsz5jz8io8ed4Z15IClhEEn77bRnAYdFuibP8SnoSr8J/sD4O4QG
         9HdA==
X-Forwarded-Encrypted: i=1; AKwUvByRDhgnAVev7BWd2CrXOWRlWYcc8/t/tEC1qPtEpU9goCcUKZTJryiSv9FmIIHx5Tyd33kKX58=@lists.linux.dev
X-Gm-Message-State: AFq9FYKYyEao7wzFBM3G6afpRHUyGOj4M3MvlbRXJzWmGUAt1WerFb52
	Z7zO5upEu5SON4ZigyVBByi23sZ1HfYtQlKUTfNQkgAW2SRZ+z8fIIsiMCDn1iBeFnzGejN9lsw
	EBiuaclTMCQW4Axn1R8XLXg==
X-Received: from wmpg42.prod.google.com ([2002:a05:600c:4caa:b0:4a2:d3e:ee4a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f06:b0:4a1:e672:5721 with SMTP id 5b1f17b1804b1-4ac181e75c2mr267566705e9.13.1793652428758;
 Mon, 02 Nov 2026 12:47:08 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:12 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-8-vdonnefort@google.com>
Subject: [PATCH v3 07/23] KVM: arm64: Add a range to __pkvm_host_share/unshare_hyp()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Nothing prevents the host/hyp sharing transition from working on a
range. In preparation for testing huge mappings with the pKVM ownership
selftest, add a range to these hypercalls to allow them to be tested
just like the others without any special case.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  4 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 | 12 ++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  4 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 50 +++++++++++--------
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index a1c9c71beb36..ec0bf9dff899 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -31,10 +31,10 @@ enum pkvm_component_id {
 };
 
 int __pkvm_prot_finalize(void);
-int __pkvm_host_share_hyp(u64 pfn);
+int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
-int __pkvm_host_unshare_hyp(u64 pfn);
+int __pkvm_host_unshare_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 5ad74ab265b5..cfcf93770c77 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -286,13 +286,13 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 	if (ret)
 		goto out_unlock;
 
-	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx));
+	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx), 1);
 	if (ret) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto err_unmap;
 	}
 
-	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(rx));
+	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(rx), 1);
 	if (ret) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto err_unshare_tx;
@@ -324,9 +324,9 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 err_unpin_tx:
 	hyp_unpin_shared_mem(tx_virt, tx_virt + 1);
 err_unshare_rx:
-	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(rx));
+	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(rx), 1);
 err_unshare_tx:
-	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx));
+	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx), 1);
 err_unmap:
 	ffa_unmap_hyp_buffers();
 	goto out_unlock;
@@ -355,11 +355,11 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
 	}
 
 	hyp_unpin_shared_mem(host_buffers.tx, host_buffers.tx + 1);
-	WARN_ON(__pkvm_host_unshare_hyp(hyp_virt_to_pfn(host_buffers.tx)));
+	WARN_ON(__pkvm_host_unshare_hyp(hyp_virt_to_pfn(host_buffers.tx), 1));
 	host_buffers.tx = NULL;
 
 	hyp_unpin_shared_mem(host_buffers.rx, host_buffers.rx + 1);
-	WARN_ON(__pkvm_host_unshare_hyp(hyp_virt_to_pfn(host_buffers.rx)));
+	WARN_ON(__pkvm_host_unshare_hyp(hyp_virt_to_pfn(host_buffers.rx), 1));
 	host_buffers.rx = NULL;
 
 	ffa_unmap_hyp_buffers();
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index bf3d13a15b2f..853dad542597 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1282,13 +1282,13 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_cpu_set_vector,
 DEFINE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp,
 	u64, pfn)
 {
-	return __pkvm_host_share_hyp(pfn);
+	return __pkvm_host_share_hyp(pfn, 1);
 }
 
 DEFINE_KVM_HOST_HCALL(int, __pkvm_host_unshare_hyp,
 	u64, pfn)
 {
-	return __pkvm_host_unshare_hyp(pfn);
+	return __pkvm_host_unshare_hyp(pfn, 1);
 }
 
 DEFINE_KVM_HOST_HCALL(ulong, __pkvm_create_private_mapping,
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 385a7ed12b3c..f7d249d35f50 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -992,12 +992,15 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	return ret;
 }
 
-int __pkvm_host_share_hyp(u64 pfn)
+int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 size = PAGE_SIZE;
+	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -1084,12 +1087,15 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	return ret;
 }
 
-int __pkvm_host_unshare_hyp(u64 pfn)
+int __pkvm_host_unshare_hyp(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 size = PAGE_SIZE;
+	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -1807,8 +1813,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	selftest_state.guest[0] = selftest_state.guest[1] = PKVM_NOPAGE;
 	assert_page_state();
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
@@ -1820,15 +1826,15 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	selftest_state.hyp = PKVM_NOPAGE;
 	assert_transition_res(0,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
 	selftest_state.hyp = PKVM_PAGE_SHARED_BORROWED;
-	assert_transition_res(0,	__pkvm_host_share_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(0,	__pkvm_host_share_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
@@ -1840,8 +1846,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
 	hyp_unpin_shared_mem(virt, virt + size);
 	WARN_ON(hyp_page_count(virt) != 1);
-	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
@@ -1855,15 +1861,15 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn, 1);
 
 	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
 	assert_transition_res(0,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
@@ -1881,8 +1887,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
@@ -1907,8 +1913,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 
 	selftest_state.host = PKVM_PAGE_SHARED_BORROWED;
@@ -1921,8 +1927,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 
 	selftest_state.host = PKVM_NOPAGE;
@@ -1935,8 +1941,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
-- 
2.56.0.385.gac671c819a-goog

