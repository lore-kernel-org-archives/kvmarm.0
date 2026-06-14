Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D084B3CAA2F
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454828; cv=none; b=OKHdE5MZo+t9/zOe4I843CfJ7pLfGW3LBfQe+XH5rJGqdWZnlPmx3j/ROB9/TniaTm3WzJc8RykegDm6wOwW+1KLvQmoJYjDd2UrtwQToZTc7+ipu/e9qsMXLK8FGaOw3Mp9lXqEWeCzvoZblbX+9xzSwRuA0DCGpVfGV0OE/tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454828; c=relaxed/simple;
	bh=3BXxnJPExNDB1HTq+EWPaJrT9x+ejnTlGW3XYrEwV48=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rNQVjEohfm0XVOXtzhozAUGfRDo7Zv5PJV1kf7pQjz5yUA9IG+o1ccUxL6CdghoR3vXstyLHcPbONYoAQkbno6+7TqbeVq+uhLBkG9xbLYQoIMD+UixxjXRSWLUIK8sVLLl2DN8qqTgNhL+icE3+EEj63grCKnvtQCdSQgrx0KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AjhOmlqj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AjhOmlqj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490bde3d239so16939465e9.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454823; x=1782059623; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DTU517bylf7hW4wRPEZ03YW0srH2bIdRmAB9JurEalI=;
        b=AjhOmlqjydR/hnd4J41ae+vJgQ8bFR2s87lzFRYyTaGbA/fkWDvzG7h8Fu+eXkE5Cb
         8vZoWdMIM6/bagDGRfpl3qkRnYj8/FMo/QsyKUZIZIxhZsZFD6DuUPXD3mH8oUn3CRK7
         L+GQn6rnpym0ODOeMW7ciQRrffRJ2sPtW7Bng+/eK6ok+WB0+EloPcjAL3QfpYephrfW
         97fwBfwS9dWpYWnhwM4FoFql91uIZi60ogqluInd1S6lT1mLt0ELOMcy+yltYlwEAcNf
         UdzHBMvx+GPRcdtPyuZ11CX3vbHwv3tXRQF4TDrceLJqiDBJgnqcFtTRbrm/FjOC62BW
         5Z8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454823; x=1782059623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DTU517bylf7hW4wRPEZ03YW0srH2bIdRmAB9JurEalI=;
        b=A0E5zOmU+u0iqTgbchmtHuUF288DjAkNlhio81m+QITLIxwB7wOeINrDPYGWw2XmHg
         aT+h4iG79EI2aQFiWuYQF/uupGOOusfiRRBq5RMqmRwJsyCYisNRqS8N2Lfl9frljmy6
         JD7YrChAxFVTe8sRbNusXTKkA1L+EJ0AyTZtYgCKSYQxpZkfVhB2HyfqTqcbFxjyEnU/
         7DX5Pfdl/ho6BbYeVZwEd0/ProwDRnWXKhLyRvlMH5EHb0ywvPaQ4zRxM+EU4r8xE65e
         kjwCOH0eU/yRFFDGRgzhdDr6ycA9ms5CMZ1/8hBX8ji/woKJFEAHK9v3Gs632O31KNgg
         Z/pQ==
X-Forwarded-Encrypted: i=1; AFNElJ+pwaRVQ0RColAhsO8T5FgGPtCQLd/jmq9k1Kt0UH6EpObkpjVGB7N/3zQE4L+eWfNXdrDmm5A=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywksb9gVN+CR3R2rr3Z85q0HGlmxauxqLzS2Y650gqO1QjK/jXH
	rCVQ4pLj/xrTINtSNyMG5y6xoOdFKNvYmUTv96S/wzj4EC8GWX4gDk8Zfc0CF/XGG6l6OsS0vTg
	qHw==
X-Received: from wmqe21.prod.google.com ([2002:a05:600c:4e55:b0:490:b058:c623])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:c8d9:0:b0:490:b3e7:4614
 with SMTP id 5b1f17b1804b1-490ec5020dbmr94558075e9.25.1781454822969; Sun, 14
 Jun 2026 09:33:42 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:34 +0100
In-Reply-To: <20260614163336.3490925-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-6-tabba@google.com>
Subject: [PATCH 5/7] KVM: arm64: Set IL for emulated SError injection
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

kvm_inject_serror_esr() constructs an SError syndrome without IL. The
architecture mandates IL=1 for SError unconditionally.

Fixes: f6e2262dfa1a ("KVM: arm64: Populate ESR_ELx.EC for emulated SError injection")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/inject_fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 444d219b0217..d6c4fc16f879 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -381,7 +381,7 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 	 */
 	if (!serror_is_masked(vcpu)) {
 		pend_serror_exception(vcpu);
-		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
+		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
 		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
 		return 1;
 	}
-- 
2.54.0.1136.gdb2ca164c4-goog

