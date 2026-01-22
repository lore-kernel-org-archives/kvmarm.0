Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8563EDAB1
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 11:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080946; cv=none; b=ruZdlFNDNXfGGIksF9ruLHZ/McREDVERlUFAGGcvByKafiHgrc+vKeViRKYsPH86jbRYKPkJDAgwpPuOGG+fkl0jCw7AvCjvnieG9wIJDCJBtesxFkbf5MkLeN45kYFRv7//vxDcdJuJneDoc1Uo3yx8KlwgUauvIsOKvUgiD1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080946; c=relaxed/simple;
	bh=OdWY89KmceouUs7zXgKdsrUWStlEJZ/cbcWK+E3LnJg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pm10ihpdwba6z/L22b00HowzsaYpio7045xxGZ+8AAKfh53qY4Muueaa+WERLb382cm16g1ZcXx1usD+7w73+W3RN0NRXwMqPziOzcokw8IymqfFpHTdO/Ef9ZaV/QqItnhpa6n6KsfF69AhaH+ANsj3VVqRXF9jFja5swE3wuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qtt/PFFA; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qtt/PFFA"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8773bf3ddbso72149666b.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 03:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769080943; x=1769685743; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jzz0jXpTSjvajgmP5WETefk5h6QUuCbHINLblfWMNco=;
        b=qtt/PFFAPGlbDqHUeHRKHULiCybPzXEvpqq4LUAoITTOhgVkHmadKntPspbu2zM/wn
         ppAWDBcDe2utQqGaHlpDKukazoxL7DbBbu8lizE/kptaecEcLQ4t5dKDDI5aQRMVD8qs
         803g4ZMo/+MrMcq+inAcnPq362FDOwnIEGGynlV0c9NNgtCrT+CInKOSixwOJJJb/gRC
         RJ9bj1LYjcofgLvl4YEc7Z2GayD+F+2ZPycSK0GBUj1FglonIc3II3qRARnyc+q+7PSm
         n6Uo2QQpO2/dUA6OsSQWNHvgJvf/r8pdTO8PO1L1iWberMRMSnlguX4qhKwSzegRAViK
         yZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769080943; x=1769685743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jzz0jXpTSjvajgmP5WETefk5h6QUuCbHINLblfWMNco=;
        b=k87NE4uloTvW5KFJ5gItjmWBJc72bsFUj5cUBOJVGSSShLk+/uxm+WXd/JBm2BluFi
         OHSl+OF5n/zYiyUVv8Bbs3li2wmgGKScvO1rBryzh0Jm9XBcqwcDeLsIPrOToJEO+G9s
         zQgehzPv64Ic7AM2E04uOp5R62vbIHdTF1LuHIQPvUAEFKB5QDDeddwnjRigR1cqX2SD
         8rO8/GxUd/p4hUWKooFWzA5sCXuE13j+OMGMJa1WQIzhEtiyXkvD1tWLyHR4p68Y0cd/
         blDFR4zFtQCE2TnUAlnyJoWhS7bQQPsDm3AgM7znu9kaBjb5HTpdsNcLgOP0cuIq720r
         yIeg==
X-Gm-Message-State: AOJu0Yw4qXprGGJjIzEO3WAgR8tMhrMkXX8tnjI9E2HP6cuTnPGdRnYh
	FMbnaCL3bdC/0GRuJyOeuWz9nBLIrsTLHgEdjzH9+1ij3RT6i3g05KCWwy9OKU81UHkKzQcxAGl
	OvWKFXjuNWgd7mm5Wi7oncNQhS7mBNIBrr8R9OUtIeSREWdfEemacqc586BpJ9Qq5jRqjzH6yRg
	6k5EFi9eSnJhOtywLKKRGJLN+wIlaKz7s=
X-Received: from edsw3.prod.google.com ([2002:aa7:da43:0:b0:64b:595b:709f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:fe07:b0:b83:1327:920d
 with SMTP id a640c23a62f3a-b880005a0e3mr620986066b.0.1769080942869; Thu, 22
 Jan 2026 03:22:22 -0800 (PST)
Date: Thu, 22 Jan 2026 11:22:18 +0000
In-Reply-To: <20260122112218.531948-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260122112218.531948-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122112218.531948-5-tabba@google.com>
Subject: [PATCH v3 4/4] KVM: arm64: Use kvm_has_mte() in pKVM trap initialization
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When initializing HCR traps in protected mode, use kvm_has_mte() to
check for MTE support rather than kvm_has_feat(kvm, ID_AA64PFR1_EL1,
MTE, IMP).

kvm_has_mte() provides a more comprehensive check:
 - kvm_has_feat() only checks if MTE is in the guest's ID register view
   (i.e., what we advertise to the guest)
 - kvm_has_mte() checks both system_supports_mte() AND whether
   KVM_ARCH_FLAG_MTE_ENABLED is set for this VM instance

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8911338961c5..9b933424e70a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -82,7 +82,7 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
 		val &= ~(HCR_AMVOFFEN);
 
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, MTE, IMP)) {
+	if (!kvm_has_mte(kvm)) {
 		val |= HCR_TID5;
 		val &= ~(HCR_DCT | HCR_ATA);
 	}
-- 
2.52.0.457.g6b5491de43-goog

