Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC58C3CB2FA
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454829; cv=none; b=pW6qzN/aTREV6SH97L+yzcn9Q2isvKXVW+kpe0MJXuZwNMhPWRQdbEgoB/pEY5f5W9NIE5OUZdgkajN08riq5+eOsMAftQ5o6oh1JhABGB+Er5zevN/O+YouLMTyq/rGy+Pi52KmHvye2+gT0+3WnlDsGjaxN2Vy9XjMS4KA7B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454829; c=relaxed/simple;
	bh=G59YdLXk1qJAnhUOH0k9EGm1DFUTtF7E8+VfExmWg8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cOFYqMIgC/f0/B0MikiXiZutzljo30j14/x7PwtGIyetouHop7jrfOtpECPQa/4eJOfDxt/D49ZHMWevXqDaZUsSXy7SDhS9TcFp2JZbex3/02tkqeFL83gCxx+faaaLmormqveMgsTn+DLTG2TCx7VgZtV/dHFa3xKMd5aFXE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fKYDELt1; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKYDELt1"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68f148093e6so2228244a12.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454822; x=1782059622; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P0JxDDL/a2cg7BfWdupOKX50oyJPHi3eGmAcnoWVFfs=;
        b=fKYDELt13zagiSTO/eF9g/wOwQo11ZekBqUD2XDas1gWdVoEf7SmumnbynezOPQtPA
         Zjd4P0qleFzlRZ1/ggqtGR5PZPsRQhWkDSRAcVVdzJVcgeGgG6WJsgtZ2CPPiXVLmvZJ
         PDr866w37zwzxbtAuLYYo8KaoMX84ZnQCq3vQj9WOJpyU6eHOXN6X+LTRRlX/liT585O
         +jeGdfk4BXcafyf7gpaOplVwVeR3ROxAKcgegGvFeaS4X0ij1gTiVDuEhM4a1aRRS2kl
         /TuYtTNIM3Y0d48zx430Pyu9nnL59m1/LTHH20z++m1Ff3kc2jPCbkKMOK4mMU4pKpJm
         caSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454822; x=1782059622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0JxDDL/a2cg7BfWdupOKX50oyJPHi3eGmAcnoWVFfs=;
        b=BJ8t112m1hkkLULjuaDJOgUiuM78xU9H9icZY0VCCIO7HOYtf1rRRsHpxTxx/z5JY0
         JcfjDPv6goLYkeOtMZwgP+ulag/NF48dK9NDYyn9dWjVE9KWg9w/nhUq3G3xxBwRHTPS
         6DkHRrFG6m9emXOX4AzFeA1guFjja7H16vWbTFnjK1pIX2ms7i+r9RbeJmsI3dUHi5kB
         FP9a+0SYe1iYwbk/QvOtLCas3uTkGfJvR/RfPqTYN75H08rKV3sgyjqbwKoYcBcAdU9S
         bIiQZH6wCkWpW1TAj0P2egAwlcpNC06E8wqceFX/MgHoV3BzipGpZ7xE4BWsJRRVvMhJ
         G91g==
X-Forwarded-Encrypted: i=1; AFNElJ9lST2uQnsUc+r4Dg8I9fYb3H/8u+1UeaqVSo1+K/xfZwLGSt5vEzXd8bGK1DBImxa91BR5p2s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgzFBJYJmIMv34ueFyjX4oas9LEDM5J2YJtiPDquSOSyA8ifxt
	vTZs/y5XYoP7l3z4dmdP94sWqWNtC/129L7q+SwWZPwTcDwXVDr8+l/1JeKe0pncM0U9HYiIuDb
	eoQ==
X-Received: from edup20.prod.google.com ([2002:a05:6402:10d4:b0:68d:af88:b33b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:350c:b0:687:9c0f:5897
 with SMTP id 4fb4d7f45d1cf-693c6a16992mr2491039a12.9.1781454821737; Sun, 14
 Jun 2026 09:33:41 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:33 +0100
In-Reply-To: <20260614163336.3490925-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-5-tabba@google.com>
Subject: [PATCH 4/7] KVM: arm64: Set IL for injected FPAC exceptions during
 ERET emulation
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The FPAC syndrome constructed during nested ERET emulation does not set
IL. For FPAC (EC=0x1C), IL reflects the instruction length. ERET and
its authenticated variants are always A64 32-bit instructions, so IL
must be 1.

Fixes: 213b3d1ea161 ("KVM: arm64: nv: Handle ERETA[AB] instructions")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index dba7ced74ca5..4b39363cf891 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2777,7 +2777,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 		 */
 		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE) && !(spsr & PSR_IL_BIT)) {
 			esr &= ESR_ELx_ERET_ISS_ERETA;
-			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
+			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC) | ESR_ELx_IL;
 			kvm_inject_nested_sync(vcpu, esr);
 			return;
 		}
-- 
2.54.0.1136.gdb2ca164c4-goog

