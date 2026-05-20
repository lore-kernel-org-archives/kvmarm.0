Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2E73EFFDB
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290838; cv=none; b=qGI8ZkFMukySXJgPXJOoxmJzP07WUp7PME6Vo3E1etXwKtYle27QaRg6pDUF98MDYdbRFzK3EHSU+vr+VPcZnjs8yktwZoX+8hH8AgWlYTaH6h5GiSp7gyuMn+lNYxuzdQtPi+qDZjp1zl7FaNIMpSjurpDAH7TmkQDqMedBRrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290838; c=relaxed/simple;
	bh=TDZlPB31kDDiRA75i4wbb1Ly9c7qC0ssfXeFBt5qiJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hb4CDRw4LuRjiITN+bjgTKpLO/fSC8JNIIyA2JUcc8WluaeCDnnWtXaWsJHMvk4p1Jo8C0qotgzhZTmMTuPxzayXdb04undfSHtJg221mEDoWX5ZQwQj32soy6aUj1WBjcRdyXQiA7bsAeg22bioVh9rf/HOno+tGHRR9+bf2Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iaPfhnr6; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iaPfhnr6"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso3769920f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290835; x=1779895635; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZONiO+mDswOu3N7D8n6Jxwck2D3vsYCGy5DutX7HM4=;
        b=iaPfhnr6674JnajWm4WO74yMkEQl6tRo9N55zYi/NRPR2JyXr9nODElIH1GHgZ93Q3
         9cXgBI2XNk9QbalE9TsICvqlFq0HhOSPXhvEBBDWqHyOMF3sE3JOXPpYBsPIi9ITOXJX
         58Syoj19Jo3wi+4Suk7fx0ATtYmR6KMNnqDDNAMt6k/aTzjQIvN4eadi/HOLXTKF0G2E
         otrlMpU3UQoa1dwxtj3vG0FRUBllQUePX3Ytg0S6V02W1H/pNZQUC2GHAsATPVnIjXEU
         SckL35KwwU64Md8rrK2lGDL2LSgzPKor0axfhIffSlkNjrj3Xr+E6ciKIZH3xRzLY/cK
         5GMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290835; x=1779895635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZONiO+mDswOu3N7D8n6Jxwck2D3vsYCGy5DutX7HM4=;
        b=be1hSxAx7vBZV5iwuG51jwPaY9f5oOE1ZbJJf5d7MoKZyQDxnyEjAOxxtpFmS+IqOO
         OX7z5+MPN49QJVfUssDdcw5n/FAGddaxgp8aB8B6O0iOF+U1Xf7/LVxv0YfcV7b61s6r
         Pqa9RKiflUbCTrmh3EMBuHIFtpFp54j4IDEYD2ol638Y2Wb3etRm0WiJIoaY32Aew/ab
         hZurUZDh3i0ztU7vexSUugMje8msqKSgSMmS7OusxEV35BHc8K48BUhTaj5nUf9On3Wg
         MNS2sSs876VlsGOoxRNVRwmWY4Mxl15aJSdeaSTKZSgEjgQ3VQ2lMHdJUg8jtaVhYljL
         TlbQ==
X-Forwarded-Encrypted: i=1; AFNElJ8zfMqWuSJt61LBpJFd8GxqdgUM9dCaDqimjar8fBJEUqyul4Q7Z5WfKC/rT4+m2b5N4wleqt4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPOeTcA6pSc5yqBidugU/pBhOc7v6w9N/ieye9C9HpMVN6BBDK
	ZFhe/GH6IwMyOJAFiihUfz+Tz7aTg2AcowWxYaTVm520YctL6cj5cnF/YysnWqOxHbZ6mQJ1d3u
	+njuCS5W931oD7eJ5QNLm4A==
X-Received: from wmby19.prod.google.com ([2002:a05:600c:c053:b0:485:3aa2:da59])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8707:b0:48f:fddb:dcd9 with SMTP id 5b1f17b1804b1-48ffddbf75emr298355385e9.27.1779290834936;
 Wed, 20 May 2026 08:27:14 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:34 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-2-vdonnefort@google.com>
Subject: [PATCH 01/17] KVM: arm64: Add __pkvm_private_range_pa
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Mappings in the pKVM private range are not identity mapped, making the
standard __hyp_pa() unsuitable for translating these addresses.

Introduce __pkvm_private_range_pa() to resolve physical addresses for
this range by walking the hypervisor page-table. This will be useful for
the upcoming pKVM heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 6e83ce35c2f2..d3137c16b632 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -30,5 +30,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  unsigned long *haddr);
 int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
+phys_addr_t __pkvm_private_range_pa(void *va);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 3b0bee496bff..773426a68d2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -502,3 +502,17 @@ int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 
 	return ret;
 }
+
+phys_addr_t __pkvm_private_range_pa(void *va)
+{
+	kvm_pte_t pte = 0;
+	s8 level;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)va, &pte, &level));
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	WARN_ON(!kvm_pte_valid(pte));
+
+	return kvm_pte_to_phys(pte) + offset_in_page(va);
+}
-- 
2.54.0.631.ge1b05301d1-goog

