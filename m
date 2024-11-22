Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B80414A84
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273613; cv=none; b=JfnP8bZp4IDiaYtls9Js1hjw82JSuD1RBpyjj406k0SOHYRzADWgol/wdH7XM+SSvXRnXbkOhgu2s8+kl8Z0si3lYbhwNku0B0fLyEGRyyjiwWgIpLmFrDWaJVwI1kGMahFuo93gMixkgiDH9VWnAB9izr9WGBcrmjv6F+5jrqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273613; c=relaxed/simple;
	bh=X2XN6iSNHs0KOZ8rThl2xXZOeYLYXokPUXViUNxPJUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ASOC61SizGae/n3PBM20iC3SjJhVjA67Fjqo4ak9qOwtnWiv4gmvrBN8+Cv428ObSGZsR5FVnpU8M6+yrQZ2tUC8FMjxoXJ6HbpVHPZThuo/okMpT30HgbtZda7nE1vrN69TuW0Wd9Cn7ZkNFchtYMx+faCBDoHZvcKXGfStCF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJ9xndxp; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJ9xndxp"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2971589916so3320784276.3
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732273611; x=1732878411; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CdzcjtKcPCFIYKoG4aLfkBMjNTuiZe1UO/NhF2ssDps=;
        b=pJ9xndxpYlmw/leI1tZVD7ToNjBWZdFptlyMckfycXWvXmyR17pWQMhZyg7k/+dFnW
         plWp1x8qgpR87rAFJAV0m11QsRCOdT6m7S6qJWrDiVn1lLM9AtExDQ3HREQAmij5w58z
         eIsygfRdLXz+BMwMhhwJLOWOy2ZYx6uCcAuJjP36kwf5sW0bMTNslmJZkPTW4egs0D2a
         acLkdktGeyUY4Hl9jOODHUYO/GlXxX+rNl/C22ZbTPrqGxvvCebnG2WWhelo9LecFG0m
         3umWs61UNjOFvLH2s/GYlzANzjUfW0cDg29mZ6UNiYSKfI5QY+m6PnuIXbY6uOdXKHZ8
         dHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732273611; x=1732878411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CdzcjtKcPCFIYKoG4aLfkBMjNTuiZe1UO/NhF2ssDps=;
        b=bnimFmgrBHixJQtEeETmbXhj/26PY4JzYLVM1Fk+p/E0tZR/8MGSG4sruyFDYgaXJl
         W7KOTIpgecGO4saQvVfvqCL5xtJvmNVkltAXpihjSdwuHP95NdRUmf9MieCjffq/zWxf
         cFD7PbwvLZeVj9Xj3VMoY25R9J7RVItzNAfPmzUAjJjswryETaW99IS6+a+ATJBT/Ogj
         iqQbI6Dmxoynf9f2joiYekoaTPDKIsLOclrGxIp7pUBg6FRAynwnukHD0KD8OP+FCMfW
         cyjtNAjH0M/HdSWHfnSBCOWHKU3WpKJWPm+1rm87ENd17IPr1za9+aBIS2mVj7Apu42l
         JjSg==
X-Gm-Message-State: AOJu0YxqVVLLS/ODLGPGerDRi+28gLaYSdqal4pLHEROtXgIxWfLzQZB
	JyEd8biIbUIJmOvwd3JmEBN8UnTJkPwJxspeRaCwwr0386kN9AnR4DqidioLS038JNt6hD62jq4
	oAc+guj8N3c22fRnpLAPJSYAv6wQ6eOwYmMFB3jV0HEkOtUb0XObtFGgX8OF2ClHAhl4jTnCc9T
	hoDT1DK+kWOQhO1irLp1fDsbXJuXo=
X-Google-Smtp-Source: AGHT+IEDyz1NhZvJVWey0V55b9I+icgbi698SOPFguzKApUlQ+aj+8HutiXfXKDa/HG43pXBb+nLXDLnwQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1745:b0:e38:78c0:1a0d with SMTP id
 3f1490d57ef6-e38f8acc4bcmr1062276.2.1732273610567; Fri, 22 Nov 2024 03:06:50
 -0800 (PST)
Date: Fri, 22 Nov 2024 11:06:21 +0000
In-Reply-To: <20241122110622.3010118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241122110622.3010118-12-tabba@google.com>
Subject: [PATCH v2 11/12] KVM: arm64: Refactor kvm_reset_cptr_el2()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fold kvm_get_reset_cptr_el2() into kvm_reset_cptr_el2(), since it
is its only caller. Add a comment to clarify that this function
is meant for the host value of cptr_el2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cf811009a33c..7b3dc52248ce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -619,7 +619,8 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
 		write_sysreg(val, cptr_el2);
 }
 
-static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
+/* Resets the value of cptr_el2 when returning to the host. */
+static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
@@ -643,13 +644,6 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 			val &= ~CPTR_EL2_TSM;
 	}
 
-	return val;
-}
-
-static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
-{
-	u64 val = kvm_get_reset_cptr_el2(vcpu);
-
 	kvm_write_cptr_el2(val);
 }
 
-- 
2.47.0.371.ga323438b13-goog

