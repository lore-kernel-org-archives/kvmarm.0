Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2515D3F1662
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290840; cv=none; b=lwHSK8ah9oOQxNClZbE07SH7U7tuvCq7oUmGirDxFJt5LJL2zh5rkobwczFHm6WLojUVmov/8WjAX71jSakaj9kDwT+9/sIWlMlLWdRPLfxQpSgR9uj53wbG34NWEX652L9OLxXhDUv8EsQSuimPuFWTT3ICagOxCqPDFiNS/lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290840; c=relaxed/simple;
	bh=6NTl8GKhEZqu5KZCpT4xHCBBpAEAWWsfx6ZYi/ua+zA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HxZAOZtRIdvwV+uRqG3QUwuqjfDWzzlw4Z7YBQAx4V7qCG4Z3pm6ezzxCOXTANLfQLKUIQcv4zQIASuK9kqWvitMJvbCSSmeRHRlAu/IcJ7cMPKhDcI84DTlRE5tAEk++bWScgn/d4bjlHL6dGW+PYT7iHz8sRaf7D4IOY8Xfso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C/yd9gD9; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C/yd9gD9"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fd33b4921so34297905e9.2
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290837; x=1779895637; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cqgx5sehgSsUJ6ykKsNMbPDDuPZW2QQ5bkclTXcvltI=;
        b=C/yd9gD9SNAG81gysaywShDEWlGdJBg/ArUxUGs1bLEaPUP0T5CJTnPM6rfQ0u6pJL
         2V1NDY1XNImxZSIE3Zb955NhuHR6IGiPv8QO5gtbRja+Iqx4lpvtz6aIOqUJabdPLXYS
         IZ6kIKnbnqiOoW3d46vYwdVtCIisI7773xKk0zqe+9Wmd92zJy53lazCu7KKtkaw1per
         jspHdnAo8euSbuZ4K+Z1+0QUiXvO7u5I9zQXUCowzXkZ+P8n9jkl9nuVwhtFjm3xe5wK
         vHTyfZFTECgQgcRviUywLECQprhB60s9+SmM/dV5aqwWNmp+MtVrC0YRGLgiE8YETglX
         1+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290837; x=1779895637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cqgx5sehgSsUJ6ykKsNMbPDDuPZW2QQ5bkclTXcvltI=;
        b=IXxhKGmjVD6flvJl4OGlZ7uFXZXpL11wm6n55T7mR2mzg1gImH+Smj5TOLT0YuCBXt
         28F5qJMtEF1wl676D6tQibXQnhVtE246HnOzuoDIkilXzT/VubOVI4Gax+//MwSN0W80
         zJ1n9wZDNF5PLKZj62QsqB+D+iEiEOzfZrxUVev1EsSrYL4a3m/tmAPjuf9NU8kHXOEq
         xCzSWy95dauHgiRNeNPKpfzh9Exo/CHvQUn/RsZEdqXBUSnY6r8uMW5ZdPWOO8PqE1jP
         CP2IWU0Yful/Wnqei1sPs2My+HxbuAUJiawoOGs1Z0UYqW1QLU8kjr0s2k91X10J4S6d
         GAuQ==
X-Forwarded-Encrypted: i=1; AFNElJ/RnPocbCte9QkmJrFBR8d/BHm25+O6nCYcv2jwJK+hU2SW4fS8SnvJMXfFFlH8WPod06hbsO4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzS97lLwGrKSS9b3Ja+VcQl1bbAkNYMTbpdLCD+lG1GVJGSLiLB
	GSWwN/GRXQkBqyAAURZ2LxK80XXC2cqVntXkjolOWle2zhq8+5gQKfgqxwRotPEqr7gCLigQKnk
	4kBOinkaxxytLEFdWVL6pOw==
X-Received: from wmpw34.prod.google.com ([2002:a05:600c:9a2:b0:490:c16:889f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1709:b0:490:327a:1b47 with SMTP id 5b1f17b1804b1-490327a1b5dmr14334175e9.8.1779290837309;
 Wed, 20 May 2026 08:27:17 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:36 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-4-vdonnefort@google.com>
Subject: [PATCH 03/17] KVM: arm64: Add __hyp_allocator_map for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for the pKVM heap allocator, introduce __hyp_allocator_map()
to map a single physical page to a given virtual address in the hypervisor
stage-1 page-table.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 725bb0fb941d..98a7774b541c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -32,5 +32,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
 phys_addr_t __pkvm_private_range_pa(void *va);
+int __hyp_allocator_map(void *va, phys_addr_t phys);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index ec59da1322a7..c1c01f81ac5f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -160,6 +160,11 @@ void pkvm_remove_mappings(void *from, void *to)
 	hyp_spin_unlock(&pkvm_pgd_lock);
 }
 
+int __hyp_allocator_map(void *va, phys_addr_t phys)
+{
+	return __pkvm_create_mappings((unsigned long)va, PAGE_SIZE, phys, PAGE_HYP);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.54.0.631.ge1b05301d1-goog

