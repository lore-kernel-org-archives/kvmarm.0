Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562D923244D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867063; cv=none; b=lkPWzOk/7Orc4sTmCc51UPQ/G0l1oIW7FJ6vqm57VZFBI4Wf2ZCcWrYoAILatBEUoUIygqCCml+ViEgYk8nYbrZXp7O1npBSe3zCv3d9sgkw2Jmg+DFEslDWZN2LBEJnNIU20XSRoUNz3qj4UQrtrlZRdTx5qb4zbtpI8hN4IqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867063; c=relaxed/simple;
	bh=MZeRmO8ZTGgSQEVOU+NNtjEQeg6nypl3nl7iC8CEFGA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RUA9f0Tgb5rOKRSw7o1xN9cUbjQRVQTCToSzgKPyp0KuAubCAx4yKhyKL6Nt262jo96Bx35IEBw6Wz/HudX6ZGgkSHIFyAKrGCb7bS/0U3eu6gf4JRoR/DDF14K4IB13FItWpxE83eYC5DJPqAoRzktc9Ic7PiMKbigrtxBDk3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IEWh0sP7; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IEWh0sP7"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-385dcadffebso2708645f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 07:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736867061; x=1737471861; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iFUw03iAYkA2yPtETYQdaDhPmq7j8x1+kmN1DGn30Jc=;
        b=IEWh0sP7JA9F96l/3lw2MalYUafXlQ3jsgkHP8kRETRzoHwbO+N2xbbK26KqiIUIEX
         gYP8yavn8xmFHHI6vdTzus/6gIOuMmuo1kjJBUUkyV7unCkX3FhP/KBUNnNyrou1UR+z
         e8IJrLp/MTX3CumOsQopP7uPhP2iZrsclPet29GJnghQCU+AX1ZvAyfxzgc1P7RB0ld1
         9w0aWlEjvu6jx05Cj71ouUv2Rdajhv3c7h4cUfBjmwW+fIM4vmn4FdJ6DLeUIUr/5P+3
         n74fmXV69qXbKcbXxKJTWpaG9K3Hf2qQmuEUC2vxACYJSh0m3G5c8f5wylcWMN0PcHuh
         6Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736867061; x=1737471861;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iFUw03iAYkA2yPtETYQdaDhPmq7j8x1+kmN1DGn30Jc=;
        b=OxDWGDWsROMYasPm68tSb75851BDd49MuPpDlk59JoOv4sS1buXTb+gzkZkUK4SDPn
         mTKBnZUyvPh5S9RNuy3eymQudkY4gu4oSYnJ6tNqTURA4Czp3rU8tHTUxGfUF7XTABH9
         TA6GAUImdMxCqLazTyo5OZfPk1DTZihp0VQIJhFlW4At/J81euYZJ8C/bRL+ZMSbIGKE
         24/uepOe3yj/5+egTdLk1G1FmFQepqNpOnlyWwAjUX9XOWPYzqlv+Luv3EjC9LgKPIjv
         /XGqmEDQL9kgF2c6E5DhqMnVHzaFki+y98Ubr2nUj/7Siqy27VaJDco8nL2d5cP69tCe
         bldA==
X-Forwarded-Encrypted: i=1; AJvYcCUysf6KS7K6sViTPLr9jB0xTZpObzG2nRNb3ER4ojHVA2NAQ8FdYdWQrwC8969utq21a5NMq9Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3RCD74L5IZQW1LqVQTIxScruzjb2VXIo9gwXBiZjJjadYqv/V
	4pQ6eW9B7zYUg0dZPZ+ULOL+G2a1+zI9QiUmGo4J+opPry9QDxu4z+dtk1cM/uwcYVqlpggjPky
	1HPLOlrXcqxjrMTm3VftEhDjT3w==
X-Google-Smtp-Source: AGHT+IFpiqH515zLDuPDEl5YMg0JiAtp3YAmq0zTvt8gaVtr3+uGQ4dNXSPwKEF4OV6mX+3fdYiNTQoSKScQSyAyQUE=
X-Received: from wmbhu19.prod.google.com ([2002:a05:600c:a293:b0:435:4bd2:1dcd])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2cf:b0:385:e961:6589 with SMTP id ffacd0b85a97d-38a87303d73mr20369063f8f.20.1736867060920;
 Tue, 14 Jan 2025 07:04:20 -0800 (PST)
Date: Tue, 14 Jan 2025 15:04:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250114150407.566762-2-sebastianene@google.com>
Subject: [PATCH v2 1/1] KVM: arm64: Fix the upper limit of the walker range
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, sebastianene@google.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Prevent the walker from running into weeds when walking an
entire address range.

Fixes: b1e57de62cfb4 ("KVM: arm64: Add stand-alone page-table walker
infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 40bd55966..2ffb5571e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -260,7 +260,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
 {
 	u32 idx;
 	int ret = 0;
-	u64 limit = BIT(pgt->ia_bits);
+	u64 limit = BIT(pgt->ia_bits) - 1;
 
 	if (data->addr > limit || data->end > limit)
 		return -ERANGE;
-- 
2.47.1.688.g23fc6f90ad-goog

