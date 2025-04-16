Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B188209F45
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817230; cv=none; b=Rte8eXsqgMk+glgLagNjwhgquXlvfD0agt19icZ2rOrCLxtO1zFPqW5Av5xw85YOogw7g5D+C0MO9nLvSWo1HgA5NaqdykCjzQW92zNMdKOBcs7XWmvhVpx8Rj7AIrDyVed4YcG9q2XrMi3mvDNp8Uojp4HF5W9vvGK8+D+nLlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817230; c=relaxed/simple;
	bh=uu6A7iueq6DtipNuS6Phk5LGlAI7BCi/IestivOyyuk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cq8tmAk2GYwOKqGyztGMiGcWiFU/5G2b2DFsLS/Dx2vvltpLDmviztBU6w/Wloz74MDV/jxFM0wjX//moxWDYlO9eKBnPk6A8f5CA+6Ug7UGm8cyJcC3fZM00In1WotSPJlqo5IXqFTlp0Q7/0OhJp241GC2gJqSOIBck5jMKrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Knv81exi; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Knv81exi"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ac28a2c7c48so80026666b.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744817227; x=1745422027; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j+5woTKLEDxUzA3eOLn0hsAEJ5MJo4JdU/wMD9M47qc=;
        b=Knv81exiQjXIue3A4voSHQG2CfK4x41F81IIZgJRdha7WKkFCnp12haPciRI+v2943
         nY4oA+M4wSIvFffItrwKErW21at/HfBmK80sSXi6Lpf7wdRZVQh4VI1bweroabHE5GZe
         4SIC358d0TIg0JxL60z60rJTA3p02NM0HWb9M90AKBr4lA2a8WPHnDgSJAzKC2NhvwEa
         kNTBC+K+6GfiEeKaTSLJlizbXcAZCHqP6PJl6NDuH10QnRAnhxoXmqxcaaO0lCo/nPrm
         VL3f9CSeWFDYmqV6omyzPC5ROtpIESHoz3ge2xXemFKbzce4HZcUM+FpHGlzGblyVUd6
         tQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744817227; x=1745422027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j+5woTKLEDxUzA3eOLn0hsAEJ5MJo4JdU/wMD9M47qc=;
        b=Yu9sZfHGj8UqbIo5ODkYoqHYDBuBWsHcy5fot9hE9fcVlwSPljBzWRKOBSChxOL0S0
         l39NNUEcD0rkt4+1azLPUtrRcw30iM+BwC5E6l9FgCaDY2sD19Eb5UADXZfBip+1Hb5b
         V6hFxvbw0msSwIywsbF7nEobqNi6fqMZm/SsyWGfi7JbPJEQks3z6whii0YforpevboC
         tuV1052thffGbq0DVJYjL+27AlwPoLEdQ+qNlR8Wjjy1qzmJlSdkr5UlK+frFAKvcTOu
         jSJ4p0apoXaCkgGZckiEmZhdHO3FbaJI+vgboGbx4nPVId1BAZj62YisVIBWzgKAqSM/
         K26Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGqP/YAzs9qMnznvRlyWb4anfijfLeg2WhxWC171eZ4UpIc48/z6g3IQdhvqWp5wAdEkYhH28=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3dp7gB8EsVcVZq4GKHqzsaZr4y9wzpV2b4clFNwpOjjR77FhI
	rcwa3dFJq+36xu0Xrx+KWlQwnVe6HaBDz1TqC4f2j/m06nhacdIvVA1ifeu50Ll8OU+FmgfePwR
	2xLuBHA==
X-Google-Smtp-Source: AGHT+IGCybzKX7dX809ygOrq+ajkf80dzTivmVZqG7Y0aKxNYJUDug4w5qsQZIOiGF/fQUZzevVuaJaQC1OG
X-Received: from edqt19.prod.google.com ([2002:aa7:d713:0:b0:5e5:339d:60ab])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:42c5:b0:5eb:cc22:aa00
 with SMTP id 4fb4d7f45d1cf-5f4b748ff90mr1896967a12.19.1744817226898; Wed, 16
 Apr 2025 08:27:06 -0700 (PDT)
Date: Wed, 16 Apr 2025 15:26:47 +0000
In-Reply-To: <20250416152648.2982950-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416152648.2982950-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416152648.2982950-8-qperret@google.com>
Subject: [PATCH v2 7/7] KVM: arm64: Unconditionally cross check hyp state
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that the hypervisor's state is stored in the hyp_vmemmap, we no
longer need an expensive page-table walk to read it. This means we can
now afford to cross check the hyp-state during all memory ownership
transitions where the hyp is involved unconditionally, hence avoiding
problems such as [1].

[1] https://lore.kernel.org/kvmarm/20241128154406.602875-1-qperret@google.com/

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 91b757e3fb4c..709d286999a1 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -702,11 +702,9 @@ int __pkvm_host_share_hyp(u64 pfn)
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (ret)
 		goto unlock;
-	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
-		ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
-		if (ret)
-			goto unlock;
-	}
+	ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED));
@@ -762,11 +760,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (ret)
 		goto unlock;
-	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
-		ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
-		if (ret)
-			goto unlock;
-	}
+	ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
@@ -792,11 +788,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 	ret = __hyp_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (ret)
 		goto unlock;
-	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
-		ret = __host_check_page_state_range(phys, size, PKVM_NOPAGE);
-		if (ret)
-			goto unlock;
-	}
+	ret = __host_check_page_state_range(phys, size, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
-- 
2.49.0.604.gff1f9ca942-goog

