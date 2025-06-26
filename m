Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7CB21CA0E
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 10:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750932620; cv=none; b=lONgJ3nULN1sFP580w+igpiGXLPSiBW8QHR1YVmtkOgCfH4jruDBO1mln15SyKTBmDhKnbpbOihmKeEo/c8Ao6akYKqPXcRrhspv2fOAcwcRXByN0dHQNhFvrS3LJXb820lm/0KEVCXK+98Bk25adUnh7dhEx5nYe4lVVRGJAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750932620; c=relaxed/simple;
	bh=DKVjNysQiPg44WHFvqc/jybFh9qT2hEaqcBWlu8MgG4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SQy4l8VeUNXjnsrEDkvz2bqQPJB4znIxaHg8Bls+bzHt6A4MYhuLKtPTCo5A7M7fBbwuk3i0Nd4fmxgb7/xAXJ3JGhAulfaDmBEtXhhTuf3GTYBUKNF7aV7l6jjzMBnGuLzyNJao71xu1AYj6kjnJQ5qzgSbgGMas5FhQJRVkjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1/jISB9c; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1/jISB9c"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-607142010bcso626902a12.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 03:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750932617; x=1751537417; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TP7OERsBD0AIL6q0/hWWV2FPerGoaJHuU25B69zEssI=;
        b=1/jISB9cNtD4ojc/juT/mPEPEGU2snXJtJJkO/mIn8YE97MxsCiI7OmcTLZzyIsQJx
         8wlvRcbhhiqnGQ0/qAyfOilIZ9IFMvrWQV8XQilg6h8bSnMkiILSZr86d1yaF0MtM+f+
         kvhCY/enmazsVdHwAQcKFfYM39XC7k4zl0yVI/sgQIZBZhcdPQeJgirM8jGzJhzrkdrK
         ry/2h5K6WFduHOLoe80k7wmtMMYiNAHGKrKi4kvIfkqDPgbGly+ZXkwn2qOdVfHsuLNO
         KDet9XWnYydhx9UzrbXJMREY1E9a36cru5enZRvZHZqR++iz3QETcp4QJF4d8LvbiNji
         8LLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750932617; x=1751537417;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TP7OERsBD0AIL6q0/hWWV2FPerGoaJHuU25B69zEssI=;
        b=UBNxkOiCIannAbaFp6m2AwwGjB4iEGmeOQmrIGRSqr7oRwYfYF6+Y6g/0MlbBO/kEF
         MMG/yKnFJQkXsgF8T1wv075lYExRaHW/JU1M2+obj7xGWQJ7sLn1JsJc0DbZ3xJYXPsr
         9IIH5bUDOjWqzjAcY/oocDsmttW7l6fHTMPvaYxnsfEeUy+QeKLeunpzbhIYDffMxsqA
         MpOxVRY4Fqn30NEUs6v1VJgSI9cgwLAO1ljPI/kvfBuilRvoDyiR+sKquE1KCojr7feq
         LPbcl5rbqfaj5FrliUou4CBwh9tJIV/Z2yF5fwGLgfDDHsTBN8JQ7MB75M7eMfHqRBQr
         Qtww==
X-Forwarded-Encrypted: i=1; AJvYcCWPw3o/ZAa5cAVDhwJY+NoxyzybJHJXd8bDtcnj2oCiSr1YNeYuoHiEySErm6oK3G58HXjoChw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+uWEgJzy/zG1Oq3gBYYL9P20bt7OiC7GcGqn0+li4Ls8MbtyE
	KAgCD6VQKe3DYKDA0IN0PRIH1X+bs3PzPc/Mj0h4KYNO+zgeth/klt51gBcqEkU2yvR+BD11p5o
	RAbQfrEIN5A==
X-Google-Smtp-Source: AGHT+IEep39DiT0nAnVXFppD+aWUwOIVpbsw7STELNO8ls+qxpoksuLe5NaSudBMyzv7SiB61C4OREGYZWCw
X-Received: from edvo20.prod.google.com ([2002:a05:6402:394:b0:606:e3fd:b317])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4309:b0:608:48b0:5e88
 with SMTP id 4fb4d7f45d1cf-60c4dd42daamr6239997a12.18.1750932617018; Thu, 26
 Jun 2025 03:10:17 -0700 (PDT)
Date: Thu, 26 Jun 2025 10:10:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626101014.1519345-1-qperret@google.com>
Subject: [PATCH] KVM: arm64: Don't free hyp pages with pKVM on GICv2
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Marc reported that enabling protected mode on a device with GICv2
doesn't fail gracefully as one would expect, and leads to a host
kernel crash.

As it turns out, the first half of pKVM init happens before the vgic
probe, and so by the time we find out we have a GICv2 we're already
committed to keeping the pKVM vectors installed at EL2 -- pKVM rejects
stub HVCs for obvious security reasons. However, the error path on KVM
init leads to teardown_hyp_mode() which unconditionally frees hypervisor
allocations (including the EL2 stacks and per-cpu pages) under the
assumption that a previous cpu_hyp_uninit() execution has reset the
vectors back to the stubs, which is false with pKVM.

Interestingly, host stage-2 protection is not enabled yet at this point,
so this use-after-free may go unnoticed for a while. The issue becomes
more obvious after the finalize_pkvm() call.

Fix this by keeping track of the CPUs on which pKVM is initialized in
the kvm_hyp_initialized per-cpu variable, and use it from
teardown_hyp_mode() to skip freeing pages that are in fact used.

Fixes: a770ee80e662 ("KVM: arm64: pkvm: Disable GICv2 support")
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---

This patch depends on Mostafa's recent fix for teardown_hyp_mode():

  https://lore.kernel.org/kvmarm/20250625123058.875179-1-smostafa@google.com/
---
 arch/arm64/kvm/arm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6bdf79bc5d95..b223d21c063c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2129,7 +2129,7 @@ static void cpu_hyp_init(void *discard)
 
 static void cpu_hyp_uninit(void *discard)
 {
-	if (__this_cpu_read(kvm_hyp_initialized)) {
+	if (!is_protected_kvm_enabled() && __this_cpu_read(kvm_hyp_initialized)) {
 		cpu_hyp_reset();
 		__this_cpu_write(kvm_hyp_initialized, 0);
 	}
@@ -2345,6 +2345,9 @@ static void __init teardown_hyp_mode(void)
 
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu) {
+		if (per_cpu(kvm_hyp_initialized, cpu))
+			continue;
+
 		free_pages(per_cpu(kvm_arm_hyp_stack_base, cpu), NVHE_STACK_SHIFT - PAGE_SHIFT);
 
 		if (!kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu])
-- 
2.50.0.727.gbf7dc18ff4-goog

