Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937474;
	b=WNRI8jGWBY32z5ZNLzcRokGScIlzBYPze29AWsAfSTXFP9D4GkIQLqLOQC3vDgM5PP11
	 QNXhOXf5/h2yNxjVQG5vx9JhayK5AO8Bba+VFUr+eL1psOwpoJWLwy7FnP6NqCYZoqLQT
	 vb87Ow3MH2xg9qB9p6WpXHbaR7AfJXpquHgsZMEgaeU7lqXjtq4OxAm1TstMhSsFVHV5R
	 fPy6kRaB+Y+ZHftExNpjgQ3+4L+q9DX0mHgbjn/oHksLFqD3UtpWDFR+dGiuEKQjgyUUd
	 pl4j1Fj1UHphZUHJA8hje0QK9uW8ZI+IcSbnEf8wFkAVm9GayIM3EFsx4EHbHfQL1UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=psREq3c91VndNY3eQzrAWuiCYYim0nrHRYcBTY+XgxM=;
	b=DJAIMcfkd2D6Ji7p7iO2BQe8sOi68I0lXiDCtqhN6OjA08lecoo9WBi4qqWVdQKx2KOl
	 qgBwXH8LI4jKkfQgM97rm1R27q6bFfj4jFS+DHEfNVBidcnzPWk02pjqCKwYQgU2fcIpi
	 J/LwxcMcRTeE9J/I8XDD8lBnGxCeEAK9Ab44s8WcX6cbvYipndov2+84hQCepffloKNgc
	 Lugwnib/QkfBijL5RRi+UXU3xzhpvIQ4QXvN/RIph8KFtr03h5FwwUBMtqPfEMSUiX5dy
	 9NrZs873xA2XN8itRmKeSWzI4uaEQKYkWbFGJp0iH4fhVio4ubcTzMGPEdjxpD8rfUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GfDwLu3d;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B790606A32F
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B790606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GfDwLu3d
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-49090fde23aso3527f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937472; x=1795542272; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=psREq3c91VndNY3eQzrAWuiCYYim0nrHRYcBTY+XgxM=;
        b=GfDwLu3dHS8m14x/44EW18WzfpD9mxgHAV1b+hOFB/wJpZjpFlznQeTA3tj6mQgGNE
         Nu8Zi6roCodz71RWaqbZ6vlLvb8tD+lyPcgTZdiWLVbiFjHlDrUIawY1tnGMdPUY3Seo
         29da30N8i/jzhqOXCD2jZELVeqo7x0PxNNyH2K6CqXp1kowWS76zUfLBwIynDcu1DfJM
         ZOwCCACBvJ/UDVN+i4bj8jjMb8ph2vGoTacpGn4FIPS15AtaiFIEmBX0qcokuuGtoqdn
         NhwM8GYnR3bwuTur3WtoXgYrT8e9DKMAmePf4kM3UvPuahjaYlNLFS5u+4nzikgurMIG
         Ww/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937472; x=1795542272;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=psREq3c91VndNY3eQzrAWuiCYYim0nrHRYcBTY+XgxM=;
        b=Q3vtVOPeR28tCb0Z8qVXnHjRGh7FAb9f2+a7n4BuUZCJpM1yeJ8othZXkQq7lG7dy3
         K/hkCJvvz0F9CVdCfNvIJZWu+xFDs08fnR8OK3SqQL10xtf9L32j5PZDbDaa1ldc2d51
         astt23sKFyvYNCGk8HOMHhpfvyY0YTf1MeKYu+pQ6P6x2IMLn0oalHO4RDZ+52ox2U3f
         ASSmIPDP533KLAAfgiMVF8jYxlXU1EsoRU0f71offDr1SfYaOnJm6/cBngAQYbvAR/mV
         CfWv4NhEIxIJx1exDjbW+gXcoKiddy5bIbNW2mX9uYI/ZTcblDr32beQx2hOyljRIn3a
         2eGw==
X-Forwarded-Encrypted: i=1; AL+hErEEF6cWBoGmjvwyjcDkUurVWBT7F19mgj8tyh/5Fwnhohuqx7E9WbbotE5mPoNgIgKzFeg8Kts=@lists.linux.dev
X-Gm-Message-State: APuU4Z9euvSGhGmaaY3+zXI9NeKzENFs6r8Z2D36FahfDVNz60ozwEwD
	uGjjq3L6gogoxXtv0BMtnmlWZ3Ol4JHFmIkHAhr4LJ80FyO6quNcGktr35OkES1Tf1bu6LsEp4P
	n2eFnyTseHnGkIu9Mk8+QSg==
X-Received: from wrcz21.prod.google.com ([2002:a05:6000:4555:b0:48e:4d88:ab1e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a8d:b0:48e:f10:ceb8 with SMTP id ffacd0b85a97d-4a63833975emr426004f8f.11.1794937472069;
 Tue, 17 Nov 2026 09:44:32 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:53 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-15-vdonnefort@google.com>
Subject: [PATCH v4 14/23] KVM: arm64: Handle huge mappings in __pkvm_vcpu_in_poison_fault()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
allow __pkvm_vcpu_in_poison_fault() to work with PMD_SIZE mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 68ed886e294e..b9b591533b30 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -994,7 +994,7 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (ret)
 		goto unlock;
 
-	if (level != KVM_PGTABLE_LAST_LEVEL) {
+	if (level < KVM_PGTABLE_LAST_LEVEL - 1) {
 		ret = -EINVAL;
 		goto unlock;
 	}
-- 
2.56.1.708.g77570a6a1d-goog

