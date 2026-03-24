Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12D5256C70
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774373306; cv=none; b=tZtnf7+iBM+Xw8+CSs7FF0cEFsksDJalGTqS8j6GxV7VqZ4Z/hejBXOcXvCd9uyi1SRItKyqjVbqdrc0lPztY8j5IG7/0XxjL2Dg+2P1L4ZkmAargw7eFOENnWW5wte7423WTYYFsdA+XIhDF1GWGST+bMN1a+erOUcGPDMctl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774373306; c=relaxed/simple;
	bh=5YWhta78jQn5CIg3q1vnbGPYP5uDKUfnnQUgvXe1p24=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FTUpk1+EtT3vEbe2G246QL6SidJ2izO5VzZ72nlFDURl+fKmHzF4iZz6f2wnchXAX5jTfp1FNzHa6lSkkPrM57EDo8bX2vNrIdXCbsiMUyV33bkabzujL6aHyCJHQzZhDzngf59EHR6usKL8Ug7T1oAAa4z7uvOO5iiAFhU1rzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nfXiR8I6; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nfXiR8I6"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b92323d85efso800600766b.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 10:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774373303; x=1774978103; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gWoPOwuwSHWEwP+AulKEamMmUHfmTMMDJl4jnL/FRPc=;
        b=nfXiR8I6sH/IAVlUmCRQGitz4mtTo6iqS3NXRMl3s1+rfnRKNeitqpb78IKR/gX7kW
         dpdhyCruW4ODM0/GcTvoJhRrFWdvEMDjygZDxAxN/16sLHBekw+PEU2WPkj+9XC+pSvZ
         NGwll2l+sN2XyvtL9duFNM9D9XXi6nZuRt4mBJJkPX9Q/WvM5q9zysFYFC4IHJbw2up6
         XRbfMMGRH25AX5AF8v7Wg/Ux1HLZakVkh2CcPpPxpYLZyjpCMg2A3xnPQmcL4WKSHiOr
         OTf2tAlZ3fMogYKNv+ADv1DhysjZeNZbMW/JAYEEAImSHs233iDmfacwPBlTL9m04Drt
         Hwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774373303; x=1774978103;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWoPOwuwSHWEwP+AulKEamMmUHfmTMMDJl4jnL/FRPc=;
        b=NkcDkZaBgvnjQB6oKTe7xbU6BkHO/aa6hzmslaCngyMdg+Gn1T5SBO7IVQ4jrPOTAo
         m64xMGN430WVqxzDQcxYzEgIOheD977D+wpFG+U2hamQX9KEDCJbPOYAabFB/GlUxiZ1
         LboAUhQJHQlzIEVyi5y/9gg1CziwFegP017S+QHzxiXqmy67olBoRCwcvVZunXw+1DvC
         KT4FEz8uxtvVAb3EUsoYGnqfNAVIb8QW3TdAhLcc8NVeNdC2J4d3R2GZk0nma1HaRmVj
         nhzf5QnYqRCWnyvIpj9AyBmlfUIsIRAFuAEJ7MFsoy2skochM8jJhApQBIrhhcxG81Js
         XHGw==
X-Forwarded-Encrypted: i=1; AJvYcCUkZ6Ax/0qA3poUwvEAYPRmcBf9Sr3uVCc2PO+mmwSMgmu6/+bp5senh/H5b48FmRK67JjRWLw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0jdG4DNJ8T3LvWuPDDdaa7j0XQa1aFp7JucwU6YfcyLVdjYM/
	V28MbNNeeoM2cl5VeAYRXJ0KxbauSe1VU2XPMG42JZA2VFt5DpJhjOs5FuHihYg0FtobpzqIgi0
	0nUKULJoVyZOq3HOyoZIycg==
X-Received: from ejchq39.prod.google.com ([2002:a17:907:3f27:b0:b98:4a43:a55])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1681:b0:b98:6a8f:78f4 with SMTP id a640c23a62f3a-b9a3f1a0210mr19003366b.17.1774373301993;
 Tue, 24 Mar 2026 10:28:21 -0700 (PDT)
Date: Tue, 24 Mar 2026 17:27:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260324172757.2147153-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: pkvm: Rollback refcount on hyp share/unshare error
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

If one of the HVC __pkvm_host_share_hyp or __pkvm_host_unshare_hyp fails,
rollback the refcount to ensure the hyp_shared_pfns tracking reflects
the actual sharing status.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 17d64a1e11e5..0fb41d2c8b44 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -493,11 +493,17 @@ static int share_pfn_hyp(u64 pfn)
 		goto unlock;
 	}
 
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
+	if (ret) {
+		kfree(this);
+		goto unlock;
+	}
+
 	this->pfn = pfn;
 	this->count = 1;
 	rb_link_node(&this->node, parent, node);
 	rb_insert_color(&this->node, &hyp_shared_pfns);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
+
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 
@@ -521,9 +527,15 @@ static int unshare_pfn_hyp(u64 pfn)
 	if (this->count)
 		goto unlock;
 
+	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
+	if (ret) {
+		this->count++;
+		goto unlock;
+	}
+
 	rb_erase(&this->node, &hyp_shared_pfns);
 	kfree(this);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
+
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 

base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.53.0.1018.g2bb0e51243-goog

