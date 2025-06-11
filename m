Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4742D6633
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682078; cv=none; b=ag1+cWR0Wtkjs+NFRVGGXxjC1JeQrwOwGX3uHM7Axv09Xoh43PbIlkCMcUb9dzZAmDDsJy2SKEFOx0iYNJOJgXE2vNdTjxCbSNLpDodaleOwNE3pIhfscJD8Bi6fmumRjaASI8tfxFA9wj3AVpRahW20nBL4SX6xhA/hTW0FFJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682078; c=relaxed/simple;
	bh=j41Uf6UxRmW62fWWWKV7gcUywbZjarY50CWC7KTpVXA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZDR4C41qhJRz4JnTTf6Ns2pOzrmsD3lQDbjJdczZXGEqYekkbKxvAoiioVUe1FHuha47Ef6+eP/lm1DETe1D9AIHBWYgDp01BCZKyLlFG0BSG33cEvohZlp9Nf3wjwd2PWQBXy79sO+cXe4bPv/Ci80Ui/tRB0gX1+r6JBI4FvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=03itv5kg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="03itv5kg"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311f4f2e6baso327481a91.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682076; x=1750286876; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D1Ge4V/cjACONoBs0qgFEJo1LJMRo9yRFlMmYU8swmk=;
        b=03itv5kgE7hbne5RHu6+1iU0+DlHfiZ0IWtowe6OYxI24/FneSx7GMeg2eQ1bjupZQ
         m94DySYXMr+eU3Qz3QqRAotd2Hv/cMXzi7/Sxu3i3V362qpcWxUbn+uJi8SvJdDQ6gOG
         RjUTzK3TeouEdVpJ8//xlonTPE4jm4c0uq1jByCKtBDenRdzET3x1jScd5x29J2apZJz
         dj4wZHrvFf+w8n2AzhUp1W4i9KII6GbiQFD3zZJpHRyNPR7bbJCqJNY8LylAFU89C2ec
         iLCY8vkHoZnUS1iv/FmM3PidUfnJa9ept1NLisZUv27k9XJG6PHA7k1ymkUrEUUh4O8G
         v0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682076; x=1750286876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1Ge4V/cjACONoBs0qgFEJo1LJMRo9yRFlMmYU8swmk=;
        b=Z0otfoXOuEwot078U02+Dm+mXVoTubnD77pz0PkBrXVzqtkOdxtFhbJW+YsB78pXLi
         TzCXlb/xN3/ITHZwbwT231CndVHXr5O7izHvEPiMvUvcz0MPyGXBT0fmIaLqE3+gT+pF
         Bwzlgb3mcmbuQHgoStvYH5Rprv0VJE24dBKG8B3NPfffz3AwhA+Lv9CqvYeUoaj2dJeJ
         6NfIozygqcaEkdJSS+NDZNXVr9zOoVTAuoduSK7bWE+1tg+DXTDkQMY+0C9F6PhTXLte
         81ddxquLxxJCKXe180oL0QH9RK2iM5WDj5Ub06F14L8HUVrAKePdMKwWZuuNDHc/1mFt
         WOAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu6QkgMVVYN2bhSpFE8RpobyUARnIECRCbb/nANdM3YSTRSxj9XRk2ph/4LaSjH/GNVEE/N5c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4TdMJRiwzg1s/p180FwYSkS4iKA0myOtfRQi5VEqa4GzGRqSA
	FUS3ISqMkQfyDYgF2yJm8/fnhQtW7d5XmoHBp00K2NTDBSxHgpeAzxtqftXOzc9r7Zv/eg4cXDY
	nlESETg==
X-Google-Smtp-Source: AGHT+IFqa2w2kmXbZWMF8yccOdDvEvpmv9cb25OglMZKL4EfpfzN4NVZljxUxuB5ee0yWW1el6qOh8n1yDU=
X-Received: from pjbsk13.prod.google.com ([2002:a17:90b:2dcd:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dc7:b0:311:d670:a10d
 with SMTP id 98e67ed59e1d1-313c08d2876mr905787a91.26.1749682076024; Wed, 11
 Jun 2025 15:47:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:38 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-37-seanjc@google.com>
Subject: [PATCH v3 35/62] KVM: x86: Skip IOMMU IRTE updates if there's no old
 or new vCPU being targeted
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't "reconfigure" an IRTE into host controlled mode when it's already in
the state, i.e. if KVM's GSI routing changes but the IRQ wasn't and still
isn't being posted to a vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 6447ea518d01..43e85ebc0d5b 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -542,6 +542,9 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 			vcpu = NULL;
 	}
 
+	if (!irqfd->irq_bypass_vcpu && !vcpu)
+		return 0;
+
 	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
 					 vcpu, irq.vector);
 	if (r) {
-- 
2.50.0.rc1.591.g9c95f17f64-goog

