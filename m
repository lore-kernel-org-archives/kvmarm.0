Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E1C3E9588
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785016; cv=none; b=Yn7DCR6qE6ofhdE8hRUWy/IADUc4jimV4F1bwmr9bHaLo6MAHLa5OXzfUr/EvF34rFubIBXajAgvKnFtpzR68NtMUhFkeD/eToQE8+04bPp9L+XPcYJ9Yvqym2QDBs5fe4mk/AgcERqJlVjD35+PL6EkqkWjDLG1nIrHcev0MGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785016; c=relaxed/simple;
	bh=JO3KFiC7Kg/szgo5tuSl9TnU7bZhpv5yulsTkPo6A8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A/V2czayyxgJOO0V4CLw2a2s3D/1C0/+DRdw4xPVNr7FxOAIGN2mX/z/WxAsJ9tb10C2wfCiheW5PAVqBXbU9mCRpDE7+vfaf87LBUFIqGwxY7tXd+kSqqXqxogOTJIOk8yGejGdd5rR4LLmkOc9MrTnnlHfyTsE6mItK5UMrNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxMx/PSp; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxMx/PSp"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-695cf61b463so1034873a12.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785011; x=1782389811; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4OzMnD/NoskCUoJd7co6AiN6FbMwLhfUbQPuu5zkvOA=;
        b=KxMx/PSpn8zp5vQa1ZI9O8RUl87/HT/ZClTBoSa3sUGAmOpGVT2HMxDc0w2PH9Hjzz
         ruH1gPMWxjRPeBTTRmtQW7oOjwwiXhckPznMRAtTGzj2zk3g5PwcSZEpEWxBASLzhuIF
         YCrhWnXBjget5/Crjm1z/whBiMq4xtOQXz2vNaCpmM9rP4iKhVKWUlEao2RSIsTeTON1
         e7k8cmY3hhk0r6ILjQWJtZP7RxPxpAsbrpdgi2ifBdca385ac0Y8W4E0WrJKsEjJyGEI
         ppjCoRH0oeVLAM+Es8/lFhvjzxjXrmXAzfMwqJfyJ74i8HbWxW+jwe4/Bwe/eeDUt2xC
         Q68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785011; x=1782389811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OzMnD/NoskCUoJd7co6AiN6FbMwLhfUbQPuu5zkvOA=;
        b=CpFJf0dR5/mzmx3fg0KzbeiJ1c5Dn+lbZfd9ftJE7L6hT09Vhm6fV0g54IFpTJBuux
         /pnhrmBr4tnfYAy+LUnkcMQ48yjmDjab6jQoAh4ZU9msfQtdG/Ff4OLp1Puzaaqde7H1
         XJyU3TBL5UacEV0FRAgQI0gADptWWXdHVXR0wP+zeVETrh5G7mJWrzVyiN6TrVMUT4IU
         9TDGIDbZ5OT92VQVmzUeL4T/XSHFSVZIac/V3o+8CsJCsIscnk1NCaZNnxZXupXmm1pb
         6j0NfehTWwlNN8frCl/S46r0lV/eqFQQb0niOH27zsn7mrRX44oVBGHJObhbLo2gtKly
         R08g==
X-Forwarded-Encrypted: i=1; AFNElJ+jGnP8qPB8Br9HWCnNAxoCqx650mk1EePj9u/9nzr6yuyortaCu8OBJ4lRXg7Vm8gAlSX882k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw422C8+/+zBQqM7jp09TZfdTXmKe98GKBvFP6nILSSS0dK6SSl
	MZv2yvPHd/bcJQW+axIMBhubbpZLAtf8rCJj5L4FNH8rfuZ5hgw4IA0NaZdKRJWx8RbNNWwCxgC
	1Dw==
X-Received: from edwl20.prod.google.com ([2002:a05:6402:1254:b0:695:bbc2:4b07])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:13d1:b0:671:a18b:32b8
 with SMTP id 4fb4d7f45d1cf-69546c6df14mr4828584a12.0.1781785010536; Thu, 18
 Jun 2026 05:16:50 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:41 +0100
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-6-tabba@google.com>
Subject: [PATCH v2 5/7] KVM: arm64: Set IL for emulated SError injection
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
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
2.54.0.1189.g8c84645362-goog

