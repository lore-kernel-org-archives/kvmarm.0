Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48172ECEBC
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682115; cv=none; b=ZxOI5j5O73hT0kIF5+UQMmIOH3X7SjpXSp1G4146+Y/l9VReglp53GgoBz80/3mohwchitTNJMIL0E7yN0iSLkN5YWA/C2LqYAXk7QUgq36vZsILE4wNSIjz2Vlv70dOHVo0fmy5gnZsZKT3xwWD4KMVZgh0SxdSOveP1PVqJ3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682115; c=relaxed/simple;
	bh=oClo+BVpPugtrWJhwqiJOJyGd7gX17MvqJmd+Hb+bsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JGGtNSScI3g5Q/sE1teVdxfv2bmz5A631ttJACZFEIPcgGSvwcxToueznOkWwICrXkgEn84om6kr/mLEdN+iPqTzIvnB9nO/LnItQgDi3dl2203OoPiXzWwFLmWRcpERX/e6OsrOWMneP0Q9fNkzcdQF7qfItb6ZKhcXWx4h4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WnEG7G5i; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WnEG7G5i"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747d143117eso252928b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682113; x=1750286913; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wAqMQv4ZCiS/o57gwDnKWsXRvD97E5JGl6V3dBiKRrw=;
        b=WnEG7G5iJTiM+ezuoObv+rRf/JRkp/3Ra9C/04Sa1JNeTdMuP/ALcWEjpQK/ac8N4/
         qIOx5PulRn7HZQmZ4BfKuWRpUclJeHRB4gOwiWd+dc4OzumYgyvSDym/5FwwTC12zrBV
         dmXnuZkoc+HBsxkuyjssWklsnoS9pGpfqExsGunrJ8C2DPurVHbMnWSlcA8zeeqiJoDy
         7smvqS8QYJXQswgzL2lVKjssOxlkj3+zNyjchbkYOcu+PiseTC1llKdZM3YDXbvPkHMY
         D+EU4NNbGna/Lyc+8duUZ9vlSYP20qHSZyUlMQ4e0mwS9LBJJsQ+K83IiNXOYu3+xpRj
         AYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682113; x=1750286913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wAqMQv4ZCiS/o57gwDnKWsXRvD97E5JGl6V3dBiKRrw=;
        b=jdEGlfVTs/ttYJOYMt0fs3b8uf/tyu0XMj4xbjSPmmXwdEHwIeiHblqXNy7IB09snU
         gpeZHMHzAfx2KqDErHI1rwQxhPW6svjhFVlQYwlQholYcAObTMzzRjuXJW34x7FuXGqh
         24TbdqxxXw6yAVj3y3QuEVJiaj/Q2a/38zTw2TAYuN/Loo5rd2PqOLV9Q2Ad2ozG2e4c
         x0heW4qBEQPF6g5ENWaWGnJtSpQlTyj08gKpG6GJISnEuJp+KrqHfcwRlS2JtF+vRfh8
         S6aAih0EcuGgztN80m4smshnbOcWwa+1DPYF2nRas3I1bDWEpyniHL7Q6Ne1psWmW3m7
         h2fA==
X-Forwarded-Encrypted: i=1; AJvYcCXsEmtlAFfdvkQAkXqKp6hfCW+tZluOcFg1Aaf77ouTh44W/o5W2pRjwdC/4FRtw8CjnbAApms=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw++H2O7sBfttRORZ9s1brGeQ3tEk9iyzcHKPr1eCuDyTFyPdgJ
	vwNGVZvCTe1MhKiD93rib72q+kWsPsi2N99RTjzg7Bgrse4LNJU7TIQBVAvvrZ/wNTQz6fzuYGr
	ZcvE0Vw==
X-Google-Smtp-Source: AGHT+IGWXeo6wLxobJN8weuZ+dD2iRb7MDLZVxncM/6se6ioUirEafScJTOie1Jy0cagndCeqMrM68HvN2k=
X-Received: from pfms8.prod.google.com ([2002:aa7:8288:0:b0:746:1a7b:a39a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a86:b0:736:5f75:4a3b
 with SMTP id d2e1a72fcca58-7487e0f2cb6mr1014723b3a.7.1749682112843; Wed, 11
 Jun 2025 15:48:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:59 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-58-seanjc@google.com>
Subject: [PATCH v3 56/62] iommu/amd: WARN if KVM calls GA IRTE helpers without
 virtual APIC support
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

WARN if KVM attempts to update IRTE entries when virtual APIC isn't fully
supported, as KVM should guard all such calls on IRQ posting being enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index becef69a306d..926dcdfe08c8 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3836,8 +3836,10 @@ int amd_iommu_update_ga(int cpu, void *data)
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
 	if (!ir_data->iommu)
@@ -3856,7 +3858,10 @@ int amd_iommu_activate_guest_mode(void *data, int cpu)
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) || !entry)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry)
 		return 0;
 
 	valid = entry->lo.fields_vapic.valid;
@@ -3885,8 +3890,10 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	struct irq_cfg *cfg = ir_data->cfg;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
 	valid = entry->lo.fields_remap.valid;
-- 
2.50.0.rc1.591.g9c95f17f64-goog

