Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC6D1F4261
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741951123; cv=none; b=YXjzbH1UrYWELncSCyCtBp6a9dLMOS7qFnvGJkEYcQo7t0y7V5u9BaC/gdDbubC3wnpCEMlXQCY5T2eG4VQdqY2rs9fLSORJpjQyqGLqmPqu3IbYUQnCmO2hNiHPtXYHO7JJcNfe2/h2yZbxrwN1HxBHH7+UShdjfIFk7WVqnnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741951123; c=relaxed/simple;
	bh=MFvJGBa+LToQL3nRmGdge2ZzG1bkiQCiX2Y3keGyAwo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qe2a0dwrYQwyFekME2kDMEllDR/RDu6SeZPSpYtu4DRR5JWMZ/9CN8kqihrcF5cyktfLV2TWEbMCo3L8D0qAAmKN2od0fDMK/wfwpZJfOfBmFvpD2+8MdBJCaw/v0r6BbrgMAA573Z4AixaSCTanVC/u6W35jFiHEq0/HJt8qCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lGdAG0on; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lGdAG0on"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-390f3652842so1061221f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 04:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741951120; x=1742555920; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yVHCPBxikyr6bz94T8wXYfnynt+o8o3vwTA2lD3uomo=;
        b=lGdAG0on5gzrS6zMwlT3z/vK2mk/P475ZM743jszfcn4tcUQ9ddPQDVi4cV7weDVhJ
         YcL3DxG9UHLJl63P695SamKxyyG0h6lqgea2nrdf5KdUUSxpvtX9WBkhStEbTtANXSIl
         hNcvat46JxwyOPUY9NmO29789Vi6yWyVDCdlzjQkU0326P10X3feJa5m2t8Vg4LH1rzC
         zb9y0vCn1sAS8EuLMK1IDZ2G0vTPMSgicS7XZBPwjhq/zkvI2B/wPCqi1mm2bGGHMuxx
         b1pBhWN8cAJB5TnInnNU9ZGpmsNmPvURZqVHIsRmkVRugNZAP6AevSCqg36j/bTrmEi/
         zGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741951120; x=1742555920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yVHCPBxikyr6bz94T8wXYfnynt+o8o3vwTA2lD3uomo=;
        b=j8sUp5IbyKBjz+nXsinkpHGq1R+Ug2EuzEPGnOFtzkOiEvLgl02jIuOEp1369RNPvn
         ybZysZX/kKc2TgSMB6uiBCCQXN4a4gdPJLqrWJHcm/pGwJvcmQsGrkx8fkaBJjW4OAu5
         9s05rL29vHbUFsyXX4e0HO4mB5rPimUGpFq9uaZ2De6tBVYBX+zA9FM0aPal/lnD2tpj
         JzMfQt0kvL4zmyQHW5pXn7CR3MrFLebQZq6DyCApjTSs5cE33PiBp80RUwLKl6c3F2eN
         4h4tZXkl/Gi7NxPXzCFbciE8PyLle/jnTe7cL6WPuBnE76SlHAPiTqHQEZos0eh8K5FK
         /sBA==
X-Gm-Message-State: AOJu0Yyi97kp1KWLlTUvmlZWf8O8TmXqzyNutek/uDkaDBaa+qeuq6Dr
	MV7XFTKh74geVaYhzIEjp4Vqu1d4neSwzSTTZHuf3g0/LrRsODprdKb5fnRtRs/NJevqrHx4W+B
	sG64BP1M/cIs+rVRD18Vlh4xW3PV+KGscs8koeoz3QmgEBM/wkNuT6fgvq9aB2eHGK6yXyoHkbu
	PGIVhxbWmslAcPYtWwX3f4Jyfycfk=
X-Google-Smtp-Source: AGHT+IFH3SuJ1uC+yXMAZ9jkckywHcWe5WA9zfg61vMBkH7bJ1po2Sm1vehb5nwh9MKJnjPHma3sjh1qZQ==
X-Received: from wmrs15.prod.google.com ([2002:a05:600c:384f:b0:43d:c77:3fd8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:59af:0:b0:390:f6aa:4e80
 with SMTP id ffacd0b85a97d-397200ac22fmr2439040f8f.53.1741951119711; Fri, 14
 Mar 2025 04:18:39 -0700 (PDT)
Date: Fri, 14 Mar 2025 11:18:30 +0000
In-Reply-To: <20250314111832.4137161-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250314111832.4137161-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250314111832.4137161-3-tabba@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Initialize and set the traps controlled by the HCRX_EL2 in pKVM.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3927fe52a3dd..6efb9bf56180 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -166,8 +166,13 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	pkvm_vcpu_reset_hcr(vcpu);
 
-	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
+	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu))) {
+		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+		/* Trust the host for non-protected vcpu features. */
+		vcpu->arch.hcrx_el2 = host_vcpu->arch.hcrx_el2;
 		return 0;
+	}
 
 	ret = pkvm_check_pvm_cpu_features(vcpu);
 	if (ret)
@@ -175,6 +180,7 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	pvm_init_traps_hcr(vcpu);
 	pvm_init_traps_mdcr(vcpu);
+	vcpu_set_hcrx(vcpu);
 
 	return 0;
 }
-- 
2.49.0.rc1.451.g8f38331e32-goog

