Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87E5262A6
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633155; cv=none; b=Vy0RYB7DSZpEXwCK5beni22FLSbWBNPTtmp1N/DKQD5MLBzrChWezxTQvMuDFsBGTUVknji4+SLGWx42ZxrH3XdPe0VIzOwNVDm28/SzTGNGWnCzPBPsy3nVRGg6pdMuzw2svQaU9rPltRaMaPez9XDw98q2mI5a5ZX5qdw2Gg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633155; c=relaxed/simple;
	bh=Hm2zb7BbK6u0+sAv3frPUeGtmPDc9kHP8wj1uipzTww=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MLIvpPZIsYExCWRSVt7/CharP8TGcpwhgg72xCI6Ufd5+/zNY1vmSAOLrpjpyLA+XorhljReA1GXBY1rw/FL/ipRftbaEchw4FklEKSB+nWgqUXU0cdRNAxQSCrwr6xL6Ut+CdNXvhEUzgz06R20FTZWpXuyH1SQNoxpyMOTnqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uxUIP/22; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uxUIP/22"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4710d174c31so13419375e9.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 09:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760633151; x=1761237951; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o9SbmhQZwiusbuPbqM8RzBz4UGbORFM0qZTqA8aOS0k=;
        b=uxUIP/22s1onr1IK3rEGgeNjaLoK/dEkziu5t82+/ol3sXI6eccjlOh4ROYmuzlIUV
         +4B7eyxmXuSeTx8dnbp0nM7MZ3JKGyTSO+zO/FxrXyPqM/mhKQQRB7Ec/Cz6IpeTx3wv
         EqaODMmT70lJGgzX3BK0Je3YnTcFrOJXNNzOO/5qtMXa48ZMWaIwVVr5zNBARVDwMVEI
         sebxVfuwUQ396tDORPeoz5uQl5QPVLc/QOMRBo8ZUSQbqPJ3Dw/oVNQw8Y9QUXPD5gi2
         54cLzPKEzuuN0efDc4juJR0ngOh0HN4sA0OCa95HJZIG1jP5VXkdcqdExEuvhnNJzRkb
         s93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760633151; x=1761237951;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o9SbmhQZwiusbuPbqM8RzBz4UGbORFM0qZTqA8aOS0k=;
        b=HavbMW1bootzFvcNLqOszOdz+7c/o8DoK0wDU8plBk3o3Ws/nTsF28cuxO/XDxwQtK
         ZCHP9cuFEo2WWQkv0/yP+KwxXPsAvGCM8MvFErNdiXf0ZRjc3YmwE0POKUIYIvtl8qsW
         eb9W1aLtwia/CM0U7hX34r2jFwVdjh29zr5qzy3vLIlLMzNk/7RZtPwk7BilUq5OZJAF
         c4E8OZRNOVNuAVgLxkDEgYHcIMjYRzH9yvD4i6lbuIy/vsDKV8e9kl650uXFuzCPoYRB
         WmHW+jIyHV6X2XWa5nfzQcOIXlbe8aytCl4etiOkl3J1cUPkm7H6Q7oeL+uoqrzvNkfe
         Dw8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUFcnhyYAJrB/APSKuF/S+vns7gg2DfhfHIO4XXru3VCpHLcKMO8CswyyNztlb+1geqI2N7A6A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzss3JnbZt1WPt4HGyL86V9tRwDMlz8FqTcQMJGLSqniXNoknvs
	S/cnlOpq4BcXsfUr0tFlYl9hmbx8TGYs0laysPR6eDAzYolt+gCn9K9Fk89TSKAdTgGvoRV7d2G
	jKRA1j4ZmshvwbalOGblbQQ==
X-Google-Smtp-Source: AGHT+IHO7bMt3ey0cBeCObbuEwgWLkRaJtIUMULZrT5bRJWCOB4Klpu3BVpGfBvD91ceBxusLc/jdHvwsQsn2up0
X-Received: from wmbh9.prod.google.com ([2002:a05:600c:a109:b0:46e:2121:d406])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b03:b0:471:6f4:602a with SMTP id 5b1f17b1804b1-471179068f6mr5540055e9.23.1760633151113;
 Thu, 16 Oct 2025 09:45:51 -0700 (PDT)
Date: Thu, 16 Oct 2025 17:45:41 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <20251016164541.3771235-1-vdonnefort@google.com>
Subject: [PATCH v3] KVM: arm64: Check range args for pKVM mem transitions
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, sebastianene@google.com, keirf@google.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

There's currently no verification for host issued ranges in most of the
pKVM memory transitions. The end boundary might therefore be subject to
overflow and later checks could be evaded.

Close this loophole with an additional pfn_range_is_valid() check on a
per public function basis. Once this check has passed, it is safe to
convert pfn and nr_pages into a phys_addr_t and a size.

host_unshare_guest transition is already protected via
__check_host_shared_guest(), while assert_host_shared_guest() callers
are already ignoring host checks.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

---

v2 -> v3: 
   * Test range against PA-range and make the func phys specific.

v1 -> v2:
   * Also check for (nr_pages * PAGE_SIZE) overflow. (Quentin)
   * Rename to check_range_args().

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ddc8beb55eee..49db32f3ddf7 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -367,6 +367,19 @@ static int host_stage2_unmap_dev_all(void)
 	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
 }
 
+/*
+ * Ensure the PFN range is contained within PA-range.
+ *
+ * This check is also robust to overflows and is therefore a requirement before
+ * using a pfn/nr_pages pair from an untrusted source.
+ */
+static bool pfn_range_is_valid(u64 pfn, u64 nr_pages)
+{
+	u64 limit = BIT(kvm_phys_shift(&host_mmu.arch.mmu) - PAGE_SHIFT);
+
+	return pfn < limit && ((limit - pfn) >= nr_pages);
+}
+
 struct kvm_mem_range {
 	u64 start;
 	u64 end;
@@ -776,6 +789,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	void *virt = __hyp_va(phys);
 	int ret;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -804,6 +820,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 	u64 virt = (u64)__hyp_va(phys);
 	int ret;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -887,6 +906,9 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
 	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
 	host_lock_component();
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (!ret)
@@ -902,6 +924,9 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
 	host_lock_component();
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
 	if (!ret)
@@ -945,6 +970,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 	if (prot & ~KVM_PGTABLE_PROT_RWX)
 		return -EINVAL;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
 	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
 	if (ret)
 		return ret;

base-commit: 7ea30958b3054f5e488fa0b33c352723f7ab3a2a
-- 
2.51.0.869.ge66316f041-goog

