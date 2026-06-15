Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656E23ECBEA
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529080; cv=none; b=ZhDjTchEClA/9s4YGNttPbkYbrl+0LGpXq4sH2nabFXUkwXWpLPeFjH5vzPUDGILOKxdbqbLEHnt7gQnFNqZxHsKHS+S0bFsqYxQLMgkzwQ3Yrw8EzavQbH9QqN/cPxc37IZCyBg0KWiqRHj0oGx/1Im2p1KhlZFXuLATdmmz+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529080; c=relaxed/simple;
	bh=Q8TEX85KOjNcdvNCgZVyXSGWbrrAjZBHAj9OERtFzQA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rdiTfSSaAt/Ydrk93rWtLNzFRp3YKSw3rVZG5yTHRl75Rcu/8f7caW819OZhGvfvidtD1htQt9rDxZXpEVJ2pjui74UQW1+ZQDlsBkYxXNuk19QhGcGfugGrGY9mG1Sd8m00IFiFTJbWcFEpb6ZM4l5iJMu3IvB2g4MaIYgmvDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oc0gmWDh; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oc0gmWDh"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490dad70f95so34758535e9.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781529078; x=1782133878; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M73130SiNKp2+ndBAl5SeIBo8s7L0rXyQ0BMD/dcV4o=;
        b=oc0gmWDhI6BJLNf0yUgKU6rHWabFN+XFSBpn7taMGLDi1USnBe3aHg9Xj7A/Y5gBwN
         JlL80/HbeekIXn6jsE5MrRunoICxFW4VpaBCF8voogXfy0reZF6wL2iCk/wFDgPBv+uE
         01sxy0jLEmYnev65hgK97Mzcua/kJjCEn+mo+mmK1phtwZ2ok4ir+fSQGmE7SLfYR1s0
         +/blXcvwI0PPB8C59GtG0FpVf6M9ZP5Ap4sEexQyCVnjIaPokGbzU/TVrzyXDzp0rvhS
         WOrYOA+daCNxaExUhC/OmoxN+QU5Dl1DWzqRyo92HEmbQP+cP9pwKn1AkUbTkumvndBY
         N8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529078; x=1782133878;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M73130SiNKp2+ndBAl5SeIBo8s7L0rXyQ0BMD/dcV4o=;
        b=lmk9+aqeQ/B0BjIFDHoVhRfKGN+fIn+2ou8xMnSvvgvSzjzqYu53qYtGL/owK/WJMN
         AkLfsIhpR+GSqt1uS9TE3RE+KMcMgi/hPGK4UaSPmmiDAXUur3pU/C3P6JIDg1HA2MOJ
         od69Y36jYDUHglXpCwztlSB+tAmRfgGjKdw0y5oLh8VTqCduelF3ujqTjBEtxFTIWOmt
         JTvq7s/Ya5S23OqXZT3rgFaGmUBw0gBbfvUDLEmPjNXTPJQMcOtYykGn2vJakDb+7GD6
         E4MNt0xLjgy0YD/QTRG/7gp1evLoH5zJKjKyK+O8AIDrvuS03CgPIODW/5FjFVEjYjYK
         d4NQ==
X-Forwarded-Encrypted: i=1; AFNElJ8un7LfbxejsO9MQl4eHqaikSSTHJ1cA6I3PaWh4iz2+qZvx/h8xfmhH0nljcMJqJtnnW7igug=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLzbXGbybglFliHXXk67QB4nbd3tia2pFTLO3TUUkArHob4r8L
	z0UqvrooZU+xqeTzmIN+RqOFCoGCKixg21FGSr+zOiA+U/qu7Ui17axyglKzu5FvxH4kyzUM4Cz
	Iig==
X-Received: from wmph20.prod.google.com ([2002:a05:600c:4994:b0:490:bd79:13cd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b5b:b0:492:25a1:e2f9
 with SMTP id 5b1f17b1804b1-49225a1e350mr103728295e9.26.1781529077262; Mon, 15
 Jun 2026 06:11:17 -0700 (PDT)
Date: Mon, 15 Jun 2026 14:11:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260615131116.390977-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: nv: Write ESR_EL2 for injected nested SError exceptions
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

kvm_inject_el2_exception() writes ESR_EL2 for synchronous exceptions
but not for SError. enter_exception64() does not write ESR_ELx for any
exception type, so the constructed syndrome is dropped. A guest L2
hypervisor taking a nested SError observes stale ESR_EL2.

This affects both kvm_inject_nested_serror() and the EASE path in
kvm_inject_nested_sea().

Write ESR_EL2 for except_type_serror, matching except_type_sync.

Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 22d497554c94..c2580d40197e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2750,6 +2750,7 @@ static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
 		break;
 	case except_type_serror:
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
+		vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
 		break;
 	default:
 		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);
-- 
2.54.0.1136.gdb2ca164c4-goog

