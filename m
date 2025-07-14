Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D34F285C9F
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533983; cv=none; b=hzPAb7pR4elWs/+nVwLxPxYynNnNCrrECU1O+fGdD0KK4/Zbulz+cXQHHi1LMGDKsMicGG77EeNakq0Ck0Z0mSg5ilWLFmA7AuFpYdPWw4aLPIEmT+oSozanWkIQmiqb7Rqvu/yILkjDZit+bDjyP2T3+IaJrqQ/4EZ/QH/ldaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533983; c=relaxed/simple;
	bh=v8A7OTNElLp9NjEON3srySP/azHIcZU0IjsZoZmUJ/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pujzDKq2Ndfh4DdU7teqUcvHQaZoa7y1Nm9KFescpBgZTSQ+WQD99kC3XAWIAv9uY9ZJyLlb9QePJCaGybhG9h3xV+ZzjDkZUxOYQVr5UHp2dRD6cj4IWeuQi+kurQJeXKnYqexvsM1i7yoU2aSW3aUpHeBKeYIJakOSaEQjw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oh+ijMzW; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oh+ijMzW"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86cf9bad8e9so508329339f.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533980; x=1753138780; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ8dG4IcFoEafWjbI5Tl7HqmjBNXuoxF6820bVcH07Q=;
        b=oh+ijMzWv03yV7S1wzecoOpnI8eVRdoJKPRRdb9suZwFZKXPHj9gnh1vDO4LK6b3fH
         ouWj+K3E5BkaohmntK4ryO6S9yWh/hhujPOz05GsfHqZv1Lazyd7APqc2N98ilWnIwrZ
         MnrGFRPG6EDEJYTS63vfrL3PUKthNZLXvEmd/PFca6o3QNK0d7B7SxeyaoswyR6oOqHC
         SYbMBC4q5jWYeioWSp4SsqRa7hDBIGLEWWfG8HJQcNyKlr/Qg38/M9kVs//of4Ff0LCU
         Hk5jFPfEimRhoun80WYBi7fkSERVHeVYYDqo24lRaxva5FyhDxiJv2J3WX3X2tYefGbV
         JJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533980; x=1753138780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ8dG4IcFoEafWjbI5Tl7HqmjBNXuoxF6820bVcH07Q=;
        b=hOt6WDntvj6oHSiGwVkfkHiyvevHHLv93+ufCpUwsffqtR0OIJQaIT1MRB7iH3d5pk
         GjAzjwOb43kjG0gj6M/6MZqRdfREZ4+Y2qUKn34kuN8hdFIvvSKB1Ne4tzv5r+PxyXFK
         8qy2xp3bhFv97col8b1ZGZCbjChcnPb2uqOQzvo0OYBTpGdzADP8W3mHINyIDPMZH8Q9
         +EFrPWs2OX6/R3s2DBLaOpvfzPPVj+odbhcP5vr6qe6saD/74lWrecnfT+n1pDerJhn/
         dAf5f4GeKrj+0OqGXXNhbtcMLt/+e0t7bHfJmOu2j9QPx69TY9L1c2qM9mhB/TLIFpy8
         Ixiw==
X-Forwarded-Encrypted: i=1; AJvYcCUnJsZ74XFqOb1tb+F35VXZEH4bY16FbyPWFk+q3rRNgFaPHeSIY/Q/FVl3KI70vZJ6eVJvXwg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhjWcZ45TbSafzcHasc/3YF5d/nYwk0Y4FHDHvv+SOWziyP2xF
	EoJe2ePZuimmqgDhGr1Mz8eIDWsC/17c4B9IJSkyyI5/KjmqsVkAr7nCLWMCqnSpP2r+wbl75Jk
	32s2YvK8Yzn1gwJTGDctyB7rDBA==
X-Google-Smtp-Source: AGHT+IGJW+F7N+Qps6LoDsgu+dPhKH89vA9SG/aNNYSKUKGt/XO72mo40SLlz3/qQJipXch8VyxKlGUxhSMvINEeyA==
X-Received: from iove26.prod.google.com ([2002:a05:6602:45a:b0:861:c7b1:d848])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:6d03:b0:86c:cf7e:d85d with SMTP id ca18e2360f4ac-8797888c692mr1676383639f.12.1752533980153;
 Mon, 14 Jul 2025 15:59:40 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:04 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-11-coltonlewis@google.com>
Subject: [PATCH v4 10/23] KVM: arm64: Writethrough trapped PMEVTYPER register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means delaying when guest writes take effect.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b3f97980b11f..704e5d45ce52 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1036,6 +1036,30 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				   u64 reg, u64 idx)
+{
+	u64 eventsel;
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+	else
+		eventsel = p->regval & kvm_pmu_evtyper_mask(vcpu->kvm);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
+		return false;
+
+	__vcpu_assign_sys_reg(vcpu, reg, eventsel);
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		write_pmccfiltr(eventsel);
+	else
+		write_pmevtypern(idx, eventsel);
+
+	return true;
+}
+
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
@@ -1062,7 +1086,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!pmu_counter_idx_valid(vcpu, idx))
 		return false;
 
-	if (p->is_write) {
+	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
+		writethrough_pmevtyper(vcpu, p, reg, idx);
+	} else if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
-- 
2.50.0.727.gbf7dc18ff4-goog

