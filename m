Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E0531C583
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297340; cv=none; b=J4+gXvVSZ8E9R5yWsQbI1fRtP5C+5YnyKB52ujZkDtkhOyK4cly04uRC1RvCeI+jYm7LGTZ/Di4eRkMHlUWmXoTkDvQsWwMHlkK1iimS880RD5RvBUxZbU4jxCPLNi8LHb+z+rjvZ8Gxg4VyhELSGPsvwKktljbSmHdNlYDrPzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297340; c=relaxed/simple;
	bh=q+ltlpOidKXc+Gs5FbxaUoBvp/0NlBvUil7jiGSbDrA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rx6GspqpBapcp+dYsoGgXfh3YBkYc+CJiVeBCij5KMqwaKYlQrswoEJWazDKMlRnciDyCRJicWrS8RThhEgtg7T7y6RvcoHhTBacz1m93o7o48gvPbl5iDQ7zlypn8T+u94bmgc8ogKijVP2McuGQbPsuA5AApP7J/xvO8ZIFJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z+8e+4QE; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z+8e+4QE"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b986a7b8aso12218025e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758297336; x=1758902136; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FOKSGqynaN2anerij2SkIETe5RaqqxOUKLRkUOiDZeU=;
        b=Z+8e+4QEVdUT/PMuDm++MkVcG/qn6hrwPqBg/0n6mWXo5XYvdNjLIduRniFP545nIq
         U9zymY2D6LChqHyv5zfY5NEdOxVQcS99P2vpmIEB8Bo1QvBHuWdF67JQl7jKTJoi6JPg
         AwoCptboJD87NMaZB5n7KxHOSxivOSGvJhmtU/EbUG5T2EK6F5b9H29epYThC2XIT4in
         cRn6j4Tvg2lwL3VyqpW9SdoovcSHpAw82SxukXUd5EemHFDLduczWGim+h57LTVurZ+2
         B0GZIxw0aipkJ5mLoRxB+nz0jfNQfEYuXX1Uz9h73jJJrdQ1RN5ec2okz3I82Pu8eWTh
         MQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758297336; x=1758902136;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FOKSGqynaN2anerij2SkIETe5RaqqxOUKLRkUOiDZeU=;
        b=nC/P9Vwt5Wz0GU7Sl3gvHx2cbfavRzGFTq08dWAvZQBBf9A44+DJKygLKq6Jvtm1hb
         Zn/SgHUSI+5eImkvthr1kBRB8PPZIO9Nkb6fCdczCYLy+hys8LOBqe80mV2gAihK3oqf
         KXyxzJ7N5dbZvhXoFUg4syxmK0LH81yV2Ty5NKQxdSQcBsu6kMJmdxc5QFkAnNEgvvwJ
         38IYvfgO4aZop/203JRMg6lW8GrOQX06hfsqTQAoYXHZ5+EPd6hTsea8O0+3LattqqaH
         RIc4L5+Z9YLfeBVtTuEqlCybevY9CHwVwtQxBeFEts1kreWrzFd0/6ovSJpzWKzQQKx7
         psew==
X-Forwarded-Encrypted: i=1; AJvYcCUnG6cHf6ZFFHyeXxg25DyDbqUk0d6z6wDoTzF900SyLEgtABZlY7RMHh8SkhbwmF2N/+nO46A=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZGxa866n/DsY54trRXeDscrQog/94fr6/5WpfbQH2KcNuCKuU
	6Va8md+RfaQEZzy4FZdCMQnbgUXQuevjtG1ltSzJbDDiHQFzS9oEtjvwD/hjhA9mI8gWwxuEZeu
	K8QywvrRfb6tUOD4zftH5Qw==
X-Google-Smtp-Source: AGHT+IEUFCbcLzkaHmj5mVgMPnutmJZ9S4AToUJFiYuLUhCLRphe53uMI81/4ePc9pYVhpGPJ8joXqow1Xo/ILf8
X-Received: from wmbei25.prod.google.com ([2002:a05:600c:3f19:b0:45b:6337:ab6b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4748:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-467f2242a87mr36001815e9.23.1758297336691;
 Fri, 19 Sep 2025 08:55:36 -0700 (PDT)
Date: Fri, 19 Sep 2025 16:50:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919155056.2648137-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Check range args for pKVM mem transitions
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
pKVM memory transitions. The subsequent end boundary might therefore be
subject to overflow and could evade the later checks.

Close this loophole with an additional check_range_args() check on a per
public function basis.

host_unshare_guest transition is already protected via
__check_host_shared_guest(), while assert_host_shared_guest() callers
are already ignoring host checks.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

---

 v1 -> v2:
   - Also check for (nr_pages * PAGE_SIZE) overflow. (Quentin)
   - Rename to check_range_args().

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8957734d6183..65fcd2148f59 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -712,6 +712,14 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
 	return check_page_state_range(&vm->pgt, addr, size, &d);
 }
 
+static bool check_range_args(u64 start, u64 nr_pages, u64 *size)
+{
+	if (check_mul_overflow(nr_pages, PAGE_SIZE, size))
+		return false;
+
+	return start < (start + *size);
+}
+
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
@@ -772,10 +780,13 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 size = PAGE_SIZE * nr_pages;
 	void *virt = __hyp_va(phys);
+	u64 size;
 	int ret;
 
+	if (!check_range_args(phys, nr_pages, &size))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -800,10 +811,13 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 size = PAGE_SIZE * nr_pages;
 	u64 virt = (u64)__hyp_va(phys);
+	u64 size;
 	int ret;
 
+	if (!check_range_args(phys, nr_pages, &size))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -884,9 +898,12 @@ void hyp_unpin_shared_mem(void *from, void *to)
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 size = PAGE_SIZE * nr_pages;
+	u64 size;
 	int ret;
 
+	if (!check_range_args(phys, nr_pages, &size))
+		return -EINVAL;
+
 	host_lock_component();
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (!ret)
@@ -899,9 +916,12 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 size = PAGE_SIZE * nr_pages;
+	u64 size;
 	int ret;
 
+	if (!check_range_args(phys, nr_pages, &size))
+		return -EINVAL;
+
 	host_lock_component();
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
 	if (!ret)
@@ -945,6 +965,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 	if (prot & ~KVM_PGTABLE_PROT_RWX)
 		return -EINVAL;
 
+	if (!check_range_args(phys, nr_pages, &size))
+		return -EINVAL;
+
 	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
 	if (ret)
 		return ret;

base-commit: 8b789f2b7602a818e7c7488c74414fae21392b63
-- 
2.51.0.470.ga7dc726c21-goog

