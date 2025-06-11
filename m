Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA412E8882
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682088; cv=none; b=TKqPMJpmdS6clVML+gyYwEbTES7uR0So4fhlJ6a5Wpo8KlRz3zABS2TpEYRBTjNtQNJD3wWwMLnZ1ZepHI6TXuwN8opRNrTqIUCBZcvfwnYcGuXEZEzXzBlIv5Vdop/JKfdUwhO/U7wFKCX7auTuMEQ89XY1d40F1/8gzlRTzJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682088; c=relaxed/simple;
	bh=agTLIs+7ZgnhH/9jfFd6zwG8Wf/TcWn7XJunEBhtSx4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mx/d3+pmUPN+nbn7fq+91QvFyAPcPJA7FurvnPc6rKxpw/fooIZbHVNb1nRVUFbjOg354fR/mzP+x8gbg08FK+6jwpMcMWg4BTKA0kA0W/wlXcQmqgGkCUYGjAHmSnHS8KMs0RJTW/Jho51kz07jGlMN9dqQ2W3AiiEHGtpDZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KFCgh6Zm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KFCgh6Zm"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so443820a91.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682086; x=1750286886; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1jGPlsD+uHDpRgxTkjVCkrhVGHj4h2DSBv3sZnUZ6I=;
        b=KFCgh6ZmBcGaZD+e3fznI1Td6VYNdED+ALQC2XOASdhC0wPOmhjp3OUA09Hvr6W7fg
         UdwMmLM6J6QgtKfZXeXuMfC1N0PVXUSeZjdA90Q/P+iD9sBaWhWNiUllg2ggg136yRlb
         guTZLShBAuovIhvyKuFb1yv+IeaBzrts8L2MwFMTKkSrceOMM0ReFCBQ6GoDHrVOUmKs
         BCZ+u16ZSDrzuEhfoAb3KlBSZOI5KFupqaE8trPFj/XVVuDArY/CXErv+nhvECi8JFN0
         WV8InbpgxrNv/czfcdX7TRxLCNmCzf3g5aNk7HPWuFOvSi0HQAx1ha8WKiHFAY56l3YW
         770A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682086; x=1750286886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q1jGPlsD+uHDpRgxTkjVCkrhVGHj4h2DSBv3sZnUZ6I=;
        b=Ic4juZAU33ruTz8vkfMssDgZH7zoMbdgnT1i4Z8F51qqb2f0DfnqEpyppUlbdZxwaT
         Pmt8y3cBedgbXlSQByU+Fh3F4Jj5WnuYoDn5ZUM7Sy+Rd4qvG/xe21aHDXq07cPZ4y/a
         ic5gysr9iiMmzIv2cy81d0LV4N4fo2KuYf3Dgd96gGtxSE0X+BFbTH2y7K5AnN0sjzlR
         29hw1DUuXg9YFcE96rs+5wc7wssitPo6+A0zEPE0QYXzfZStjC7OSS+M9E3NnUeP8/KI
         DxxEAdOV4k8J8IL3ZvY38Ji2aImuROsC15xwpfrxeL8aMJF2kfUtoP0gUeLD0XfBTHZG
         YciQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzaXchxGFncy4QDoKQggEsHR4u/a06G/sFbEVogPW7MaqhEtBNYwJNOHwsjnoOCi5b5wUVRlI=@lists.linux.dev
X-Gm-Message-State: AOJu0YypMmZwfMODUx5m168NAIiF1s8biT8mKoXL94eMeHZpNwfOC6TV
	blvUpSLFxjhgpHKWVyxVLiVF8WM0xG84WALy8jJoikx7Du58xQOYOd3vqsOYuu+X/VZuh9uYlSE
	Ah1+wUg==
X-Google-Smtp-Source: AGHT+IGHoNvr6Cnk8J+KREg0HNO21SSc1Je6u1/AJsjFVgdYxx6GvgmCCTNG7aYe4NPsZfXP33le5zKfeT8=
X-Received: from pjbsb6.prod.google.com ([2002:a17:90b:50c6:b0:312:2b3:7143])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b41:b0:311:c1ec:7d12
 with SMTP id 98e67ed59e1d1-313c08cf229mr1001910a91.23.1749682086599; Wed, 11
 Jun 2025 15:48:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:44 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-43-seanjc@google.com>
Subject: [PATCH v3 41/62] iommu/amd: Factor out helper for manipulating IRTE
 GA/CPU info
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

Split the guts of amd_iommu_update_ga() to a dedicated helper so that the
logic can be shared with flows that put the IRTE into posted mode.

Opportunistically move amd_iommu_update_ga() and its new helper above
amd_iommu_activate_guest_mode() so that it's all co-located.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 87 +++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index bb804bbc916b..15718b7b8bd4 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3804,6 +3804,52 @@ static const struct irq_domain_ops amd_ir_domain_ops = {
 	.deactivate = irq_remapping_deactivate,
 };
 
+static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
+{
+	if (cpu >= 0) {
+		entry->lo.fields_vapic.destination =
+					APICID_TO_IRTE_DEST_LO(cpu);
+		entry->hi.fields.destination =
+					APICID_TO_IRTE_DEST_HI(cpu);
+		entry->lo.fields_vapic.is_run = true;
+	} else {
+		entry->lo.fields_vapic.is_run = false;
+	}
+}
+
+/*
+ * Update the pCPU information for an IRTE that is configured to post IRQs to
+ * a vCPU, without issuing an IOMMU invalidation for the IRTE.
+ *
+ * If the vCPU is associated with a pCPU (@cpu >= 0), configure the Destination
+ * with the pCPU's APIC ID and set IsRun, else clear IsRun.  I.e. treat vCPUs
+ * that are associated with a pCPU as running.  This API is intended to be used
+ * when a vCPU is scheduled in/out (or stops running for any reason), to do a
+ * fast update of IsRun and (conditionally) Destination.
+ *
+ * Per the IOMMU spec, the Destination, IsRun, and GATag fields are not cached
+ * and thus don't require an invalidation to ensure the IOMMU consumes fresh
+ * information.
+ */
+int amd_iommu_update_ga(int cpu, void *data)
+{
+	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
+	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
+
+	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
+	    !entry || !entry->lo.fields_vapic.guest_mode)
+		return 0;
+
+	if (!ir_data->iommu)
+		return -ENODEV;
+
+	__amd_iommu_update_ga(entry, cpu);
+
+	return __modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
+				ir_data->irq_2_irte.index, entry);
+}
+EXPORT_SYMBOL(amd_iommu_update_ga);
+
 int amd_iommu_activate_guest_mode(void *data)
 {
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
@@ -3985,45 +4031,4 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 
 	return 0;
 }
-
-/*
- * Update the pCPU information for an IRTE that is configured to post IRQs to
- * a vCPU, without issuing an IOMMU invalidation for the IRTE.
- *
- * If the vCPU is associated with a pCPU (@cpu >= 0), configure the Destination
- * with the pCPU's APIC ID and set IsRun, else clear IsRun.  I.e. treat vCPUs
- * that are associated with a pCPU as running.  This API is intended to be used
- * when a vCPU is scheduled in/out (or stops running for any reason), to do a
- * fast update of IsRun and (conditionally) Destination.
- *
- * Per the IOMMU spec, the Destination, IsRun, and GATag fields are not cached
- * and thus don't require an invalidation to ensure the IOMMU consumes fresh
- * information.
- */
-int amd_iommu_update_ga(int cpu, void *data)
-{
-	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
-	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
-
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
-		return 0;
-
-	if (!ir_data->iommu)
-		return -ENODEV;
-
-	if (cpu >= 0) {
-		entry->lo.fields_vapic.destination =
-					APICID_TO_IRTE_DEST_LO(cpu);
-		entry->hi.fields.destination =
-					APICID_TO_IRTE_DEST_HI(cpu);
-		entry->lo.fields_vapic.is_run = true;
-	} else {
-		entry->lo.fields_vapic.is_run = false;
-	}
-
-	return __modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
-				ir_data->irq_2_irte.index, entry);
-}
-EXPORT_SYMBOL(amd_iommu_update_ga);
 #endif
-- 
2.50.0.rc1.591.g9c95f17f64-goog

