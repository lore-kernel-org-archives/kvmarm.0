Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F78A41
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346284; cv=none; b=PtubTqSg9uvCGtpvB3YqmRHEiRkkkUfSI555gj8eL19mHD8E0ubnWt8wSk6+qUs9UODXPliOn5jHlftXtkcrEgk7ySNTZpDuEPNidXFHHc71VvdKn6gQtR3z/enwQXWoRsupMnqltgbPr4s3i2aJKWbnybWCJebx649dWoB8oDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346284; c=relaxed/simple;
	bh=BS3URXN+scvQnxiOGo5RgjWgyZt+J8QSrDnVHZUKVJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ayw6tkgXbfQQtanwtP247YO1zUeDVskAjykclO1SSXijzyQH44Nf2F4tEFxel2EcilLOsMQ00M7/V3RU/U+t+2seNYnhKKdXgNn8DR+FU30JlEfQruKU0ZVdh1trOjGKpgYETzZvq2mCjpVbe0mRodGSfGgooJhLY8nkEPEkJQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x/l/TXXV; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x/l/TXXV"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4359206e1e4so36765705e9.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346281; x=1734951081; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fAuj7C7H2YKoNTM8wr0twIlAbi4Bb5s+3gqw8FPEWIM=;
        b=x/l/TXXV/I/6bHe3bdCegDElUihaNjOtwo338CyNmX8qjz/nMDqDAPxN4QyDQI0TX6
         MWRc5exZnBCssDpvmCzJRf3lKv0IHozO9lqMuh3hDtpGtN9xhaQcG9d6zQ7Xqo4VM1ym
         ZCEpmciqpFBqJX87w9GAJI2umQSKfC3vkZx+68AumYi/nZ51KObgw2tfgdqZRg98TCnh
         8L7hiIu9F9OpSZa8mDN/sTS0IPlekx7Q+eoOM1SJVyEhu+7UwuAIJdz2rP8pEyJ90UHs
         amh2TW6lPlQqpqPxSEU0sc+R/Pdr6Hxhnm10VjN4QXtsv+do7bgIGrJiomZNT1wWkDHr
         YpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346281; x=1734951081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAuj7C7H2YKoNTM8wr0twIlAbi4Bb5s+3gqw8FPEWIM=;
        b=WZpPlaUKhneI21y639mtR4+dmwHOu/ro5EadWgHb5rtGTs0L+/RnuXJcfTMgzDeiQf
         DXk/zRFFJvU1o6xOn+DGYXPUZuRCGz4VBy3BBfh8vrvSN3Pw6tQK34Qj1CKt+K8wJCo0
         Xp2eQ6cvFIIqNKsZ2ucr+OqVvyShfsMmALxLeZXgZaVpr4yLQ/N5uFszQsmHTWNzH42U
         vCyaum4A7jEZZdmTasbMTVkk7GI8in8QYsKk6JwXXFkCEtmj/TeIC3zbRavIA8Z8Kllz
         8lZ7lNMqnVs6ZGV3peXwK3EyfDI0cikUmjFRhOFuiNsx5RHJ0ZavEwIYERZ9f+3XYLkT
         3oBA==
X-Gm-Message-State: AOJu0YwBaOhWkth3vaf0bZAcNyF9CvX4Wlqk9RpQgH3HofiFBLqqsbhp
	TA63He7dm1tpN0N5qj71elUDHBpuAtMox9tsNZvhuLlzLrA5ETC4nwZ5kCjXm2sHGYzdXgbOrmi
	b1J5JSryEFS0gRFc2eWlj9Xz03D1WPF9tMkSH8WARBRZbU3sCJsYkclDJvl6FyBLhuQwDm33pz8
	3g2nSVHyKQS20VQYKWt5wnv6HyBPk=
X-Google-Smtp-Source: AGHT+IFC5u2mx9tjf2UN64KWU4at4Dw87sQewuG3wxlRUMwtao0CZRTo0ShpInfw9GzncnB31/qHqTErxw==
X-Received: from wmbg5.prod.google.com ([2002:a05:600c:a405:b0:434:fddf:5c1a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:450e:b0:434:a852:ba77
 with SMTP id 5b1f17b1804b1-4362aa4ffe0mr115535675e9.15.1734346281409; Mon, 16
 Dec 2024 02:51:21 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:51 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-12-tabba@google.com>
Subject: [PATCH v5 11/17] KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

In hVHE mode, HCR_E2H should be set for both protected and
non-protected VMs. Since commit b56680de9c64 ("KVM: arm64:
Initialize trap register values in hyp in pKVM"), this has been
fixed, and the setting of the flag here is redundant.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index add0502f888f..21864d101230 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -57,9 +57,6 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	/* No support for AArch32. */
 	val |= HCR_RW;
 
-	if (has_hvhe())
-		val |= HCR_E2H;
-
 	/*
 	 * Always trap:
 	 * - Feature id registers: to control features exposed to guests
-- 
2.47.1.613.gc27f4b7a9f-goog

