Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D4E1FCFD4
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550881; cv=none; b=UoNgbzuBWjIYyotDdHBJ220RdAiUTDoVgOAUZh5kA8Sllz1UaJ2wWeiyL22zQV5jVoiR5M6q3YUrfBW54I+pbQJHSWOXSys4+aiQSxcETLJ0dqbRe+Bx75eQFUzQ36k4MuaWzTOOrTGn571tebTrpsrEWRQ6Ix8DU9n7S5Sef7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550881; c=relaxed/simple;
	bh=QMaQ24g0UDehTdXnJ1WSPTfwrrvhU2BGRO6bojUvM20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V2Bfgcnsdx2TeWKkv3j8Rg/xmgGvYEPaCzaWCswOg6bxnKHLL32k4HtL+MnYARDTCiGUjOlzytMtVqSqc6GEHmncaMEEKk5EShilYXLxgeMQHIb17S6qXaeG7o1nq8l/mYhYpfkKHZqlt+GApE09Gj55g9cawvhJtA/R0vubZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CtX/s0NL; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CtX/s0NL"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3d9d6293fso2554a12.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550878; x=1735155678; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UN033o2GHiX5GHpTGB6kvm1rK9tee5Gj8O9vUBu1qws=;
        b=CtX/s0NLCN+vXYR0dPRR29AIQI1FKlaxLepTq3kQYdIeXwuNwEYYhzQ+fARBmKm6Fp
         Fymu20e07cNMDvuZ6IURQryCqkF758MA9gPduLQKh05M39i+wYDY1EOEOF2t1iFRFLtJ
         hMQLO8U38xMPZMCiLI2ldBQVF6wAxc4rSdn4Z6AhHrCaypKcxvB82ZzmIDn0tu1H8x3F
         zE+3eRsCcvPolP/nCmO1yWITl0Id1qMtq2AoOmt6DL5DdK4eABAHBm0L1bXKz4+dHigy
         xhuFNHw4saKtTECDPnkdDwVKy0TMczDVQU+5hrcQ75Nm5BLlQkS4I74n2WE+ZpdAcvBh
         QE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550878; x=1735155678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UN033o2GHiX5GHpTGB6kvm1rK9tee5Gj8O9vUBu1qws=;
        b=YGvbjEA0Ma0WqM9ssT4r/HCMJzyimKEWWW45ryDbMUkyvo0QtaOFNbqdl0rOe4Ye6G
         lkFIQD7v/N+3Wtd5c5HGpEjfCYj8TTCJnvNaBqVTV2zICIWzVB5BLQywRjIY37HPjD13
         Qp6y4oWZmaeigBCYRhXTLmd1V/AxNKXT+daaKsyoH4xQUKJaOKUT1Lviii3fNEKFmAIJ
         1jqxc5216TlULyh2irfEjS7tBk5KMGT9MoTkf0QsNdaw3uKtxR2dU0VbHZynJlC+YxR9
         E9Sad8FW35T8xL1m6h+JHj/ZVmm9RTJ4bl3ITccysBdBsrf/5bZL4RQLaUXbqJYNyZco
         bLJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHiUJSYY0arzFoIA+D2qtJi/p00xjUjjHuNuFAVp6QcJO7pxBuNNsPlawJ7GPRSrKQA+EYTN4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQPtBfI5SBtwNQ93iOL3/XDA1K1ifs0J2zo1b5UTY7H2O129Yi
	GrODJO+b3kauZYovo1TZOS5h3mvbq/tHY5Nx0Ys1M8H9TPWrEaPnyrYgrBCkfDTbvOvUf/+dfAw
	lAmwGMQ==
X-Google-Smtp-Source: AGHT+IE3wkDG9vtefB7L3ndH+glOdLt6SFA31qjCSbwI5pguq8Sr2lwBLtJq9tsEv+9Luyc+4JoZCl07Dm6S
X-Received: from edbes27.prod.google.com ([2002:a05:6402:381b:b0:5d3:ef04:4872])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:34cb:b0:5d0:e826:f0da
 with SMTP id 4fb4d7f45d1cf-5d7ee3b4ce0mr3687509a12.16.1734550877975; Wed, 18
 Dec 2024 11:41:17 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:48 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-8-qperret@google.com>
Subject: [PATCH v4 07/18] KVM: arm64: Make kvm_pgtable_stage2_init() a static
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

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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

