Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A2037F8D5
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779358931; cv=none; b=fRbnWA3CHLk/3ZjhoMQHNlzHHCUwRZflAnkY2CbIVGsG/0BFWqkXpYby5lxOjm0s7pp0yBVf+Z82EUPLwDag8v7CbACPYRcTH3n/eFTsTu43F5Kk5bFpuP+4OcrHMybO6h8yGWvBLEq9p8U0Y72hmrJkjb1IHXyBVNJSAtCsN9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779358931; c=relaxed/simple;
	bh=7s7GSg8yEIWRSNB1NEd77nkN5PphHXn4l2FgS+2CUHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bW6vbe8sHJkMwEuggeRFS4rcajN7+tTDBsn4uwIt6o4m8Zc4ETOJeZbQoRgXWhMda3MsbqvYIP21FtpkekFba0FXr48rE37d7FabCLs5Dq29d4L1x+VfcMW7w1xuaiOhqOWCRH4NBF496B0DX1/T15WE9oEW0nGzSZdAc+wzYjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fPs5Vten; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fPs5Vten"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-67fd8b662ecso6182044a12.2
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 03:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779358928; x=1779963728; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nP4J9fw6WkwrBkWENfxjLXAdxOioe0P1zdEKW/zD1r8=;
        b=fPs5VtenMLzYOpS6rKytz5uCgV+zPSOXmmSvARu08GsnFfGfyeenBfm6+00jrlXG0Q
         86S1ZxaVMwa1ED82C0PovDH5gdAQ7tF8XkKdofS5TFILer5NmHx89/tkGm4hZ2weQ3Jg
         t/3gKNsNrxBqsAlKanOye5Rh/1i9s5Hw2xbvRr+dsmsedQpH+bOoA3lvYt/HqfjoN3bL
         tgSrIpmMED88bbJ+oUN4w9w1oXaoLB2aKU8Mfbenc6JhB+kTpsoBpdHctXrQCOW2J+GO
         5MFxv34yXFcbMP2YQtmq2OrhO4SRGVt57asIBl7xWWk7XUabQjO4lXhxv21nHcb5knlq
         iW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779358928; x=1779963728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nP4J9fw6WkwrBkWENfxjLXAdxOioe0P1zdEKW/zD1r8=;
        b=h0tfn5kPKm3vn7lE6U8BCi21BcLOkiDI9XdXP+N6XhOVgJvF/D3gv9/ZGOSkhQSHoa
         /ZkTwTf0QUZfg8mPN5245PEdyfJ4kkB4mBO0fKmBZNeSZAyJtJwQQsZLhtkGe9gAbxXm
         RO0/5MykGjXE1j7tpN8oPccwdgeQ2SjANZPTndxsNEHjd/BXWNZUKCl10q/dP4n054Zd
         STnSb/9wnZcjx4Bc2wUTSNv/FwJI6x471oiTAFzVbmSpUEgtrnU2v//pTG9fAdoRBmep
         Bmvc49Rl29KtrXEX840g7H6t6eYHJc2k2BxntGRYprYLciXaXHPCvAkdnDWvkCDcjTDZ
         ulbw==
X-Forwarded-Encrypted: i=1; AFNElJ8rUsOkz8GD6/F3WuSaPckd6EwSVc716flKNGAV4JqKtG0xQtFW5cT933qMvxFFYonWilO1v2U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyP37smHVSUpJ3HK+SBw5skw+h0g9GiXk32LT9tQaxZ3OQPGLrt
	abJbv79c2HCoeIxd6z4nq+FXZIA7aPGJ/DH3rHsBCsFp7JAE9DfMUg1NlI2w0IZHwyQ9yTt1eSX
	TFRXQeqtSIhuffE5cRzLHdw==
X-Received: from edrb20.prod.google.com ([2002:aa7:d494:0:b0:688:57d9:5a0c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3586:b0:670:8b38:5717 with SMTP id 4fb4d7f45d1cf-68836ecb198mr1175738a12.24.1779358928033;
 Thu, 21 May 2026 03:22:08 -0700 (PDT)
Date: Thu, 21 May 2026 11:21:49 +0100
In-Reply-To: <20260521102149.804874-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521102149.804874-4-vdonnefort@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Add fail-safe for refcounted pages in __pkvm_hyp_donate_host
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A previous bug in __pkvm_init_vm error path showed that the hypervisor
could leak refcounted pages, (i.e. losing access to a page while its
refcount is still elevated). This poses a threat to the pKVM state
machine.

Address this by introducing a fail-safe in n __pkvm_hyp_donate_host.
Transitions are not a hot path so added security is worth the extra
check.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 42b0b648f32f..bb97d05b9b25 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -855,6 +855,16 @@ static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_pa
 	return 0;
 }
 
+static int __hyp_check_page_count_range(phys_addr_t phys, u64 size)
+{
+	for_each_hyp_page(page, phys, size) {
+		if (page->refcount)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 static bool guest_pte_is_poisoned(kvm_pte_t pte)
 {
 	if (kvm_pte_valid(pte))
@@ -1053,7 +1063,6 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 int __pkvm_host_unshare_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 virt = (u64)__hyp_va(phys);
 	u64 size = PAGE_SIZE;
 	int ret;
 
@@ -1066,10 +1075,9 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 	ret = __hyp_check_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
 	if (ret)
 		goto unlock;
-	if (hyp_page_count((void *)virt)) {
-		ret = -EBUSY;
+	ret = __hyp_check_page_count_range(phys, size);
+	if (ret)
 		goto unlock;
-	}
 
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_OWNED));
@@ -1132,6 +1140,10 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 	if (ret)
 		goto unlock;
 
+	ret = __hyp_check_page_count_range(phys, size);
+	if (ret)
+		goto unlock;
+
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
 	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
-- 
2.54.0.746.g67dd491aae-goog

