Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4256D2F3C37
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454830; cv=none; b=ujoDUjdW2xgMnFQa8vwQLYqWISJl4wirei/l+B2tdISLUP8MaBHyEeBADGAWSLDsPUMy5Q2++F+HRBlUQE9AW/ErzDXMRSchX7VCClmtsgCW5uHU3/T0KutfMEBfcmlScT8aNLRJnD7LxLTTnsGTfI5bBnmVhI01perdyfBS4Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454830; c=relaxed/simple;
	bh=6fN8ZpRV3F+mtkNhz/8qmQIMh+9OjyhawKu2ZpLAl6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t91/HAIW8WDup+9rlJY3ttdKF6S/bdpx79QamLETL6ndT6ScQI+HtZPOdt/X92uOboiuLZkYtgq+nMNhx/ESdCYSx65qaLgMzLL21tVul0KnZZ3Igx/SBj+lldyW7KYu5X5mk5jxjKeCo2lp5kaRgUYapCABMoVp12qSQTOjB7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iYw/bX1g; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iYw/bX1g"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490bfd70b0fso23576345e9.0
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454826; x=1782059626; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tv4trLugC2C4NI3RAbn0dCrrthQRiHhpJKIFLbS3QSY=;
        b=iYw/bX1gjNyaibJ/ipZpJs2AWC1YvJjpEqVm5KD0tUStvmDI5CNCQtVq7ScQQ788To
         f7cJPI6ZDtTPTld8862sHFgRQoDPBResYkfgXMd9VtBjlLE3BFJm/LCqIIMZVVQvkhgl
         HSmKxIzX2EQeUcP5R07kMdl4R02QJSJYkWckhNZnloX0DL900VEyDhzaq17w/gcwVQLl
         QIrZEtWqImM8unY7HkqoW0Rk806J+pddrd09rqg/3rqCJPOMe1LuGTUe8M2L0UTK8S20
         tfWrOszBlBMC28c5uuJyRxLdsFBcs3msM0cA5qKeNynf7TEHGYk5kDhCfzR4Y1Z+kI/r
         FMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454826; x=1782059626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tv4trLugC2C4NI3RAbn0dCrrthQRiHhpJKIFLbS3QSY=;
        b=Dqhzt+42ycqVWgm/RcPQYujoSTT+q0VOGoNb/t2WrfnWMAk2XNyuMusmzXAZMwysas
         00GEkwo8+zMCq+6t6WK5qahYg1p+2vyMaMmB2cPoE4GKJVy7bYIo7ThrSoshNLz91+/B
         WUDK+4tawyC5iCWEjZ3DUe4HhHuk1zuNweZvW0XWl8GYtrcjTYkrAxfjApb6iyW7GoDa
         5cTkA8t+CyC190MI1ol+1m9a0CkQxU6qRiDgxm3Xlbgz+63JbfwOjml107A8bYqN8BZg
         iCh5rmawGHpY/cVKX56gul4XGYwFlG8ysBrSn/TyveL05LdOK/zyViC2mJzfISW0a1bD
         +m7w==
X-Forwarded-Encrypted: i=1; AFNElJ+3huzKkrJTOWjEeNs0ptPMischjyoipmKskNuKgZXuj+tY9MBwOXS739rFekJeGZF81k861mM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyT59ggf+liZrX7ZfMQuV96ifamet44GQpDbOyw6gdsYOonzjeQ
	2FR/PtGUHFJdr2+UAbuSsJ9im8ek7C+um1Y7cm+TO291gxR/YlHUzsz1zoeYYDc8H5vYuDk6JZC
	3GQ==
X-Received: from wmjq15.prod.google.com ([2002:a7b:ce8f:0:b0:490:7e29:9cea])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:8494:10b0:490:c7dd:de3e
 with SMTP id 5b1f17b1804b1-490ec521187mr96160565e9.31.1781454825642; Sun, 14
 Jun 2026 09:33:45 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:36 +0100
In-Reply-To: <20260614163336.3490925-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-8-tabba@google.com>
Subject: [PATCH 7/7] KVM: arm64: Set IL in fake ESR for pKVM memory sharing exit
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
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
2.54.0.1136.gdb2ca164c4-goog

