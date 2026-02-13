Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2454A361DCB
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993504; cv=none; b=nZr0Gz9agdszgT/crZ0Qjh7LVIBYQ3FtlHYUqz3rsq6OFxr4oxhUwBYNLdNRQm7zuc3KYANDlgbhVEDRoE5afyxIWDwiYsHBuUGj6rcO+ly4DOJCyZBIr+AQPgzty63PpP/LANjV3ngscWebCDpv3rWD1RTvhOhPuFHiMjKuZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993504; c=relaxed/simple;
	bh=2Yh7aBShA6c8gQ4pY43dXnO0B18sPgc8K/vuxbeNWds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cexQmbJGuD42wI2bV6eGlysoBHO8MqCQooD6vwuNkcT0u/fW1jLqmLlsiEa3GDl9V33sLlWroDJT+An24bz92pPLzxYvCb1+lYvKFF+ns6P6qksK80B82/vveoonTSN8jOUVE4UWW95Nkwu9GsGk+iE9jh0kXd56onb7cUVdI/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t540aTDQ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t540aTDQ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4376b624589so1029222f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 06:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993501; x=1771598301; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/UGGDvqnPusZ8w3DOSxM5/L8hUMj6ctAm+38uUc+sw8=;
        b=t540aTDQXrlkSJzJFAtHWtiVrVy/9EAk2vEqN6DLZE+dHatoKMcJlRdG/zBdjKx74y
         nU/jTiu57lfruM7OJAPyWCp35dds8nrMjyzxlK4u9k8VqwG7m3WF+V/ccyg1dul15f9e
         UyHItLW6FCmhEHb8tBztvDOy+2OKhXGZE6GMFdecb+0CV6Cgc1gWPTq2Adx6mka422XW
         HNI2jiVZHCHGb0sEv+4MTJ6toe/rTUwNuUUXst/d1XfyFBpH09+H22eomdb+tjM/xXHT
         7XbdN2+fCkMrtW0LaJqO0ZGbx3nHlkxdYQR2/6KTRDc6/bn/x6NJoDaxGE4nFJhzJz8l
         qgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993501; x=1771598301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/UGGDvqnPusZ8w3DOSxM5/L8hUMj6ctAm+38uUc+sw8=;
        b=WGanDUOKtIprDxJlJ71JZeScxf/7+PoTq0EjV+ExXwBgWWfR4Grix1qwPXGsg8OWDA
         AkWpM9+gq9eKPySt2TN8746V1WMVoSj/rP9xRlg5dIRxcvQJwnwuGbyG8s5hENFdiaOL
         sOiVOKk55RCAg7WHE+5x5M9XAjq9QzAOwJzjweW6za8ZbzIScQWEdLgf7QAzQlWtJPIQ
         G9eZyn6Xtg9xzPmU63UJ4iKqXjYmjD2X7EeC0CqTki7piWVjv5ZxETlstBNIkAWgdTKr
         3uJaGLVWT0yfsEcm/RDSuXy4DyUbKAtyPhKJ4LEtLrwhlwT94ROaHuKxeLCJvAQB8jNL
         zpGw==
X-Forwarded-Encrypted: i=1; AJvYcCU03v9CyWSVdm+Rxgj6vsGP0ejmKmhHIZycj6rtUn7peCiZlE6M2b4bhmQQA9CDV8t8bFmVGlE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3CAaEgdF7DZ1tkpsjB2pPue1+76psVALxgMPzdb+SBsuRV8rf
	TlKjgEmfLZjKu44ljrIUilxQHHMa3xDaeWJhMXE5Rz9fbd9AgzfiVpDi2dF6N71pXsLlWstTKXO
	usA==
X-Received: from wrqa11.prod.google.com ([2002:adf:f7cb:0:b0:437:72d9:7316])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:588d:0:b0:436:369f:39fa
 with SMTP id ffacd0b85a97d-43796af9ed9mr4847850f8f.44.1770993501337; Fri, 13
 Feb 2026 06:38:21 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:15 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-5-tabba@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The `sve_state` pointer in `hyp_vcpu->vcpu.arch` is initialized as a
hypervisor virtual address during vCPU initialization in
`pkvm_vcpu_init_sve()`.

`unpin_host_sve_state()` calls `kern_hyp_va()` on this address. Since
`kern_hyp_va()` is idempotent, it's not a bug. However, it is
unnecessary and potentially confusing. Remove the redundant conversion.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 59a010221818..389fa5f09c3d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -392,7 +392,7 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE))
 		return;
 
-	sve_state = kern_hyp_va(hyp_vcpu->vcpu.arch.sve_state);
+	sve_state = hyp_vcpu->vcpu.arch.sve_state;
 	hyp_unpin_shared_mem(sve_state,
 			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
-- 
2.53.0.273.g2a3d683680-goog

