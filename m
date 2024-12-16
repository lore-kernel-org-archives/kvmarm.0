Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053C20C48A
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371904; cv=none; b=PlKd9z5758SetIVKd9w4YkuM0flQmo1h1DNvj9703B54YnYKUOYVLpzEWsp75mNPRNheeH1d4rPEojiNaBNB6MdJyFNpIvAiyLdJWBM0STzN4sNZFlD89HPl8StswXuzQEtjzTvkn23cylhkChpmomXjrHnWQ0IVs75FtlHVx0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371904; c=relaxed/simple;
	bh=VDPjyhAniiGam9OPIR7Fg0/TYc5hRZJY+waFhhN2Kqo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RyB2RB1vyR+B776gc301qnedKQkjM2+Xj/NAOyEG5jVKOBDaz3sLzcIFiUNED7AE66Hc9ym/2Z4k/st25MQ8N1YgtLMrakbcWXk7xb52pgapLRA5WVZe2XSpNTtX8aZPPra/GgV3TYFcyI5RsPBETr+1UYOz5ZGEO5k9/FsMfq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CpjlIA1G; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CpjlIA1G"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3d9d6293fso1870238a12.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371901; x=1734976701; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qd1/ZR7yY7ReH6NCWgcpm0z1q63UQhmB9TeGY0t0ioU=;
        b=CpjlIA1GrDMwcNwd2toiUAD+J3YeA+a6pOgg7x+pwKVf+IdZEvm555hX/ujHwfjcLW
         devMOSwqMQ+X1fMy2Vy63xsmdiBHtRqXFsTGGYiJwZJa1MAyzh2u/uVShWrRgnYPTPTy
         mjMPgwFPHmD08rPDTf3dFtEHG4I0U8XTGL5vIQSa1jXX7lPNPwgr/CYeaOvcxMjebTKi
         GJWtmNec+FuWj8Ek8kpG/6FVGYytts7ozjmE6uFxVuDbp8Cb1a+Ton5XePPnDbq4COBH
         K+TLOjxVn7fn9gK1ewc8gGFfiBdJVLFoseHqMl786yW56vNSE5AU4a5wZgavdxarSn7K
         LBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371901; x=1734976701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qd1/ZR7yY7ReH6NCWgcpm0z1q63UQhmB9TeGY0t0ioU=;
        b=X6ZmtqeR1Od+rfzwephZP8g8oXghFJF/69BwHDSdjBlb7cS0TibC0pN78NvKiVYwLg
         Oiyg2ogtMZLn34nzKYmBBYpOL91IFMigm5Gh0hGUp4gmvXgOpCRLYiWYGiS20ydEMDzq
         zfhmvZQA3kEnJyMsWCCWUyJ/w+rzLd7LIzsZru2YsC6PmkHwqaTHBBIawZJDTpTz1CJV
         8EQAuPJsMEMmhg80AYfC2QIctHJ+x/ibSk3tqeXWDPijFyxOsw9V0W7BA7CdQBJ9X8xZ
         3UYuuZdNGnzdZ8fbSmIH1lvoeQpULQWTJA9jAEC9EA7wvzwjSBSU6kgMmWmDvwvvMdvR
         95fQ==
X-Forwarded-Encrypted: i=1; AJvYcCVehWDXX3KFYJnpJH4ahhq6susfG1hjen2xhAtk+qApY+enz4fmi/o2OveIqp5OYqUWBQTZss0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbQhNpjvI6IVD1mNOdzPJn8v+VoduKhl/gU7FFK1X8lduOf0xV
	CCl11QFmDh8NMI+dXc+XGaFJB0bY9KRJlc+OqT0rMIWe4ufayc9G4bC3pv/4DqSHyVzudd6bO49
	SkMiaxw==
X-Google-Smtp-Source: AGHT+IEZAZq2KaUjkxJv0f3RrehRlI6rnfYsshuZuD5/X0wPwG8guYjpqgqhcPwLPFFRfZ50xXtdhX2JySHz
X-Received: from edyv15.prod.google.com ([2002:a05:6402:184f:b0:5d0:1fec:60a3])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:270f:b0:5d0:bcdd:ffa8
 with SMTP id 4fb4d7f45d1cf-5d63c2e7bcdmr11529217a12.1.1734371900235; Mon, 16
 Dec 2024 09:58:20 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:52 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-8-qperret@google.com>
Subject: [PATCH v3 07/18] KVM: arm64: Make kvm_pgtable_stage2_init() a static
 inline function
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn kvm_pgtable_stage2_init() into a static inline function instead of
a macro. This will allow the usage of typeof() on it later on.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c2f4149283ef..04418b5e3004 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -526,8 +526,11 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      enum kvm_pgtable_stage2_flags flags,
 			      kvm_pgtable_force_pte_cb_t force_pte_cb);
 
-#define kvm_pgtable_stage2_init(pgt, mmu, mm_ops) \
-	__kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL)
+static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
+					  struct kvm_pgtable_mm_ops *mm_ops)
+{
+	return __kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL);
+}
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
-- 
2.47.1.613.gc27f4b7a9f-goog

