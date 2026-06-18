Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15720396D1C
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785023; cv=none; b=RsfpoN6zHK0gBBc9/frKRVGvqstDQ2QMpBYafY/SAkr1bNKsl9pjhVrKpTz6J3mGniLbprbaRfR1Bdo2YStoPGb+DBO4VhCNR7tlIstt9LX9lSIrkaz0nfnBgwNT4AOU59mwmkH70+E7waYxvn4AJAiFM+MXO5RXwIsTOo0WY/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785023; c=relaxed/simple;
	bh=Uh1GI4QuxpsTQwnVopQQEcCtnknklzVbagmoWNXU6ZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KVSZ4pQCa42zmrMBpV77HRHey8lJ5eTH/SKESSebcl6B/drNrWhRedjvzrq3f4KYUMMEIg4Vl3tgtyYPgQkbf0lgkV2FyhZS2VU2h5VdWk8hpvltJlsJnn9Qc6AXHByz5UeUPTmJeV0os/2EoR9SnWIYhQroLQ3pYdxui1nDNlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BW+FHrsW; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BW+FHrsW"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4923411f041so6463875e9.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785013; x=1782389813; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+61K/aG7Smoy1LWrJDyBkJHQEfHByS53+hZfj5eCGYc=;
        b=BW+FHrsWuKFExYSkfQsy58GEdAyxbHMhPg0CbU37OlNSRBTxq0Yo40da5akkltedAc
         +uzXDdDjKZf0RNoMRKXhumbye0MC/4jUWvyTluLuWfBz7XFd4tfn/QC3RE/sghOQtC6n
         hDdQc+M/y44dqIC0r1pTDnHjuQNi4JnX1QJm5hoTpFtBnO4CaOUhznFCsVMZzJxD3Epy
         mbM24PSjHnnvNi43WfPiSakS3CLRsipM8ukqHhWgqHA7ZhhFdKceUcG87wDTUy8NdSaO
         mcLMCUx6nlZYR8pWdxtolT40x2y63MU9ZMPIM3P7onrSqiKrCNqEOv1Rf03k/w11RAde
         h5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785013; x=1782389813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+61K/aG7Smoy1LWrJDyBkJHQEfHByS53+hZfj5eCGYc=;
        b=j2Iajvxzk9m9NFYgfeYiAaVp+flu/U+Qk+wuZOVP/p0vlfMBqS+ADMug3GHL44luIb
         t5+XGDcmDcgjYNUFbdaBO6cYbJpoxS9UJv8iiilS6eIBCK6+9AIn1cy1TIUEppr0qTDj
         Dxk8KbQUkWKSclctO3XHrvRGDuma4rTqul0J5SKpAotStcrMun/uuCr06jj6GiZCy2CQ
         //LSgS6QJuCjxlOYTroPbdVn0Fl3LNusR6ZbAKTLscgQnbT6hQNoHDp6pFJx2FtvR6t/
         oJfOLBFCCe3N6OONhCIGneLjbJgGhBcD8mEu3Q3m0EGjBQ2X7A6t4cxy7m59MQiPOBBM
         M9fw==
X-Forwarded-Encrypted: i=1; AFNElJ9Lu4rESa2x3J8OVGdP/Z0vWipyh8QLHGnSeCbdZCLKRSDQwBns5OSMBGCfm+nRo9Bl54IrlLs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzH3ghUNmfwwWJwRBWHHx7GW89J/NnZx8L2TvYu3Bs12uWg5xx2
	mnCW/DL8+ubk5BIAE4i8m6Xe6dyncwVP2Qzs8iHu90ecSPGoP9gGWauVoZn0TNSeThpwQiha698
	Gxw==
X-Received: from wmdd27.prod.google.com ([2002:a05:600c:a21b:b0:488:9c2a:aec4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f84:b0:48f:d1b8:9ab1
 with SMTP id 5b1f17b1804b1-492381f0ed0mr55115875e9.9.1781785012931; Thu, 18
 Jun 2026 05:16:52 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:43 +0100
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-8-tabba@google.com>
Subject: [PATCH v2 7/7] KVM: arm64: Set IL in fake ESR for pKVM memory sharing exit
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

__pkvm_memshare_page_req() constructs a fake DABT ESR_EL2 to exit to
the host without setting IL. The ESR has ISV=0, so IL must be 1 per the
architecture. The host does not read IL on this path, but the
constructed syndrome should still be architecturally valid.

Set ESR_ELx_IL.

Fixes: 03313efed5e2 ("KVM: arm64: Implement the MEM_SHARE hypercall for protected VMs")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index eb1c10120f9f..c982a3a04c37 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1054,7 +1054,8 @@ static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
 
 	/* Fake up a data abort (level 3 translation fault on write) */
 	vcpu->arch.fault.esr_el2 = (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT) |
-				   ESR_ELx_WNR | ESR_ELx_FSC_FAULT |
+				   ESR_ELx_IL | ESR_ELx_WNR |
+				   ESR_ELx_FSC_FAULT |
 				   FIELD_PREP(ESR_ELx_FSC_LEVEL, 3);
 
 	/* Shuffle the IPA around into the HPFAR */
-- 
2.54.0.1189.g8c84645362-goog

