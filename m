Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F035A39F
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 22:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790719455; cv=none; b=uKZo1ac2U7M7wtoTt8bZvwHABcIFP7xw4K1e4iyuVEiIx/ZRj8RIYQUJLGVbBqX8ZzEK7YCUpPcw2yl7GhCsIgVeioqIzMzi0US9BfFg/34ZXTaZuovJtMQC+8SeOxGgXHwldHuKec4ftRBM4rJvIeMX7vOBHboipJjl0LIE6DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790719455; c=relaxed/simple;
	bh=YxAlMmfVcm2W4cU7DakMAjMJLU1Lttxry7DoFyXpeys=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XjQCCiAWfCt+uLKxHvIHYWLWq7YcfODClFdELqtqwYmkc56s9FkC6uriCFchGk0UeBrJL7Hr1SaSJCYqHgiIrvIQxx3FjUw52bCKehx6Gt6hW5JglpAsM+/iyjEzCcuo2uPlzhULEkwVcwx4CovFcFyueRuERICchMPLqaBbf3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNNqTRTS; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNNqTRTS"
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4dab94dc3e7so8008590b6e.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790719453; x=1791324253; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1dGp94WLO2gdDysa7HIE4Qlt4fCj3et0VUDMOFJDyak=;
        b=SNNqTRTShPdk/HhUXlHXPZXYR5u329CDXd2qCA8SuuxmlTN/l2XMjf+tvnHCCEh2Py
         sTJpCGHATk1mZBZvXjhIRS1yg9v1tn/R1fjDHv1ZCw+Cau2wet+qhygaH3Ji8duGnyxj
         GQmere6lMqX62fVhMXu4lokpMKe6oF7PVBlk5hN2CpzbUPilQ+OpsRsYWBskiYEFKhE2
         EyE9mp0cblgRRBlmZtZ91ICkzLcPFxBUwFoyFyRb5/12K5eIMBGPZzqPbB7pl6FxaQSb
         mEeksz9qahBrvxD7H0q5cAu07XUqHGCOfIdIwNFE/wDvXToWXqvFKIDlaC2U8xlQxOtA
         J90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790719453; x=1791324253;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1dGp94WLO2gdDysa7HIE4Qlt4fCj3et0VUDMOFJDyak=;
        b=DkPNx9TgPoCjpw6SN35I8g3BYS3IymZ6ORYyX2yEBAi3VudPVc/ps1Ywwrm0fOyy7I
         EYIrcayr9NyPynmcR5ZGhP2RhuXmKclcDSQ5Xk2QT+H1uPeoNFOD4P32JfP8GrDFBX5E
         ONuolciKaP7GB47pPvCuPq3j8w48OniEj6IQH/FNlqwF/cgkKScV/lDFEeKgIDPhVl8P
         FYAPDiB0JrR47mjFwmNhUXRfQ7tH5sx7HQHWtgVLpermq7AL+F73X4SBWIpJy52Veq19
         HHd9a7fhxDE8JtKmEEiFt5y8TYdYGL//OX4+QSnVskmYN6TArhyyXvAe+JnGYxfIKe/D
         NKsQ==
X-Gm-Message-State: AFuF++nBF5PukEZHCFhX/dkWpi03aU4qoQMq9U0vqzY4uNYzJdJvxszf
	cIRiHstdjgbk5yEQi5gzINYnNHZfEoJb3ck1EY+PotB7R2whURyKMTCPPXgGExjqX3qK9hCK+XB
	Y0PcdGDKCj6Ka8+6SRf3ZMDQkpYhb3BD7NvfhDC9tZYMDEaZ9pL+YkJAKmaz/uzmi4FjoTIzvhL
	D57rVYYUTtv6OcRP0SPUw3YjSjZTssHHd1yTvDqgBho46D+FUcvSYlM5fjqTLJvu0=
X-Received: from jabgg6.prod.google.com ([2002:a05:6638:6906:b0:5f6:798e:166d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1927:b0:4ec:f57c:f81a with SMTP id 5614622812f47-4f074dcd517mr1045481b6e.12.1790719452327;
 Tue, 29 Sep 2026 15:04:12 -0700 (PDT)
Date: Tue, 29 Sep 2026 22:04:11 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929220411.3756519-1-coltonlewis@google.com>
Subject: [PATCH] KVM: arm64: Check ID_AA64DFR0_EL1.PMUVer in reset_pmevtyper()
From: Colton Lewis <coltonlewis@google.com>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When userspace initializes a vCPU with KVM_ARM_VCPU_PMU_V3 but sets
ID_AA64DFR0_EL1.PMUVer to NI (0) or IMP_DEF (0xf, which is sanitized to
NI), resetting the vCPU invokes reset_pmevtyper(). Because
reset_pmevtyper() only checks kvm_vcpu_has_pmu(), it proceeds to call
kvm_pmu_evtyper_mask(), which reads PMUVer == 0 from ID_AA64DFR0_EL1 and
triggers a WARN_ONCE("Unknown PMU version 0") in __kvm_pmu_event_mask().

Check ID_AA64DFR0_EL1.PMUVer directly in reset_pmevtyper() via
kvm_has_feat() instead of kvm_vcpu_has_pmu() so that PMEVTYPER<n>_EL0
resets to 0 without querying the event mask when PMUv3 is not exposed to
the guest.

Fixes: bc512d6a9b92 ("KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised")
Suggested-by: Oliver Upton <oupton@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a2f4e769a4282..0bb3c2f10a22c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1060,7 +1060,7 @@ static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	/* This thing will UNDEF, who cares about the reset value? */
-	if (!kvm_vcpu_has_pmu(vcpu))
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
 		return 0;
 
 	reset_unknown(vcpu, r);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

