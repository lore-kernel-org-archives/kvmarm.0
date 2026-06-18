Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20593F482B
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785020; cv=none; b=QAdCsSJCQBg//k15s6KaIPPl3iQYrVBx5aNHy4Br6yeWXd75xskj9qBg6B1xxxyaUUII0Tx09YVkbXpRD7EqRhCW5V8UVY/g+eTS4ve0ux+dodtYEg2RW7tcyrHbcZYbJJeKZP90W7Ca2uqGY6bSOVroPlLPC/74wYmcwiFLYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785020; c=relaxed/simple;
	bh=gGkWocGEAP/CjIdO62aKSEdoOplcwhb3SX3ymAiG8yM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y3idMpQpILbF8eqRWu17wUalBW8wP2sQBc2Upu9Ejjf4VQuWpfmqvI6/buHgYBKk+BGvw9mkeewko+vY4ZIuzWdVTTNPeIS78oHVuKMteQAmYThluku04+vmk1GhL7qMKg4I8h9al9amGFUPY3qZPyJfa6qvpXmUD4e4Gr8Snf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vkx0n6Br; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vkx0n6Br"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c068a256749so91855266b.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785012; x=1782389812; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C9HlvrniU1D96ODxhGlOnHZdC3XvdXiJYKZBpcs/wmo=;
        b=vkx0n6BrjTxDL1l44Svs1898gBjqVgdj4m1BV1hbtti51PYGti+eFgEVJMq/YnWuy0
         qKFprfwPmdEsaqTIhgp7qDXobNeFDwOpl0UfUwVGS7VT6KL4/gpnmUfZZ64I4qOG6ByS
         ZWM3/OTtRvQo+c00zdL1QJe1ZHRdVqSPR4tcPm/WfKDd+Dfdo2TtRoMqeHfCftr5TVJX
         bQj5J8wZmFHRGfLdBYyi6a5/Z4oHaQd4rVX5UOKefmQ7a7i58NAFn5bCgl2zA01mL4a7
         OQi/6NP1jVYERQo/qllDii3a93yc7w40/F8PulqxTQh7QIxIJiCmBlawvhil0V548/kh
         qC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785012; x=1782389812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9HlvrniU1D96ODxhGlOnHZdC3XvdXiJYKZBpcs/wmo=;
        b=QvZV4CZtDv8oC8sCwbJnzIloX+eE3vmznAUlRudKZiY+77KDn+WuIh6IpXo67Nukjj
         +8aGAj+jgM7ct6Iruias+qDgHLBfy8pDevNbFxNvWmQA8QaD66n7oEXksPQWVR8w79Bc
         cYlQk8ob8GrQpIFwvi3WH5Yb8v1hlLen8Fcyok6+0Bhxy+J9LsXV1NjKWx9uIDUjpfA6
         zKAy/awAFUSacn9dulzf32exKGt3N2fYXj2H3nLR6PuvJmymuI70tIrLUplIzLg76FWc
         Yd7BVWmfjqqGMATZrfNkwl6J8NxvDExjHelK8g4Fkf32qLU5L8DbWlOraiOGxk+SQfoT
         ISvw==
X-Forwarded-Encrypted: i=1; AFNElJ/XM9Lj0C64ZfwdOTK1y0D6bVCaqNm3uMYxkXYOMWXKCn+PS2sm86j7pVBHaZ8/Xkq5VMt+m7A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKNA85EcvHsAFea4h5sO8u8i0qvs7wwyW7zmE5dSCA6nxL1sJT
	rI8JpPCFg/KO/6ErpUoEy/YPhe7WnsbZO9c7XbvfQS+KOuIigCKm15pjPm8ykp+rTXGXQNUuVt8
	U0g==
X-Received: from ejnz1.prod.google.com ([2002:a17:906:65c1:b0:beb:941b:68f1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:70e:b0:bea:a8c2:3d02
 with SMTP id a640c23a62f3a-c074ac8784cmr188483966b.4.1781785011825; Thu, 18
 Jun 2026 05:16:51 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:42 +0100
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-7-tabba@google.com>
Subject: [PATCH v2 6/7] KVM: arm64: Set IL for nested SError injection
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

kvm_inject_nested_serror() constructs an SError syndrome without IL.
The architecture mandates IL=1 for SError unconditionally.

Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b74369e9ad7f..6f12496cae81 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2938,6 +2938,6 @@ int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr)
 	 * vSError injection. Manually populate EC for an emulated SError
 	 * exception.
 	 */
-	esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
+	esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
 	return kvm_inject_nested(vcpu, esr, except_type_serror);
 }
-- 
2.54.0.1189.g8c84645362-goog

