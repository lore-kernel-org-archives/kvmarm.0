Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBF83EDAB3
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 11:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080944; cv=none; b=Qcy9J4tOaozY+z9T7OL+djFAhc0KtORlj7F29aIen6hreLbwumJp4t7F7Evfv2ZrQdDSumKsH7ZVxJ8YraSjVqvOa6MjoDGu3yTqT7RAyh8+Grgb1+bkXRCNJ3Tet58UrIxVtLnWd7hojVW2r/315tDP3tazIudlNZt+0Ki7edU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080944; c=relaxed/simple;
	bh=bfsIRS37teDbKDtsOS8eZZk97VU9njYpmzrzmTaDwyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eS4XhBkIytI4k0IV3EXOU5H/gTEVhHqCXzkf2JKHmySRASvyXlOm+Vd4ELkN02NDuXz4flgH5/guZWIlsJ6hFi8aT1x0SG9C+gJMhMLYcgkqgsdR++Yvg6nkV0tt/aiCODzoAqZjm7ucZoEunBOs/2fcgrUQUjK2w+6tDT6MbWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Swmaz0yJ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Swmaz0yJ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43284f60a8aso611299f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 03:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769080940; x=1769685740; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GbpJOUsj+jmFdKgKTCHaN8Qj3FdeUCxTExCcXcyJF/8=;
        b=Swmaz0yJn0vfEWCGOzDxTF1IjEcFVC7PV8BQxg+2a/+In/ebRAqCRFVYTi/ykRlj62
         3NxNNeD7U7qzgKFMlzvxqdlfeH6PDZmBAOFcR7v6mjAxPeMCgrWHg9HPKK0OnIpsaNpz
         wRPT88bP87g0rdT3/trBVwTnYzmJ6oYuiFi8qDrfc0i6Pw6jXloO5joyTJsQvjZ1+qfs
         dBODIaxIxzcjeHZH0r85H+ktGZmpD/qiNZoVMioDJPVmBy7lOEcE/sK2HRGBtCUfSBND
         TFXSFCDvBQbO21Z1+nt0ojwJOI9G7tnqtiiuJ1Q/CyG3IDbxz/0/3l56pCygLHY1woJj
         vIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769080940; x=1769685740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GbpJOUsj+jmFdKgKTCHaN8Qj3FdeUCxTExCcXcyJF/8=;
        b=etNiYSZ4YSXgBpcbrpVEdHA3UUona/J1ELUIF4qJGFhiwAc6AMFn0VRP0tqmA/U75d
         zHveIlQRMemtgSHZEtoyPkyE26jG6Tea0/vwJM7ECRA8Se/dNKf7QzFkfpilosMcsfr/
         FIfSWJ3BMrqKoB6VGmt6xOcA+Dsv4JWa3k44RGUOF39GyXQFh1Y74Dhv1MLttpMkSrMy
         /HR59Mf5/xGYKycONplZdIiJEMu3T+xBjxT9NBINcPyqUPJvbb14qLWL29hfQAZwSFMI
         BlO/kTtbMZfxwRzWsMG7Ozc/dYhwojrNiNEgqtp0OpY/2hkTxj3FJYbs5AWbNJTFi+9J
         +bWg==
X-Gm-Message-State: AOJu0Yx9JN23FgCe4dmY2EgZUl0fvwMpVWfBss36ODBTXU9knRXzX0Ti
	j5ATnGFQlkmgxB+dzue6yW9O8u0hyl/py0h7Fupj1UD7prKcT/RDDXzHKRLExSCLO8ZPpL3g+S9
	103Pamm1OXvR47ry7Jsog9uqFDora6zVk7FMyf5FalZUZPc2NGQ9k1mNgooBppp0lulDk/ybWc3
	RHnZQRl+i7lFZb5HvaAvLRj4iD+0DFZhQ=
X-Received: from wrbcp14.prod.google.com ([2002:a05:6000:400e:b0:430:f2e6:376e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5552:0:b0:435:97b2:a9b
 with SMTP id ffacd0b85a97d-43597b20ad9mr9445342f8f.37.1769080939974; Thu, 22
 Jan 2026 03:22:19 -0800 (PST)
Date: Thu, 22 Jan 2026 11:22:15 +0000
In-Reply-To: <20260122112218.531948-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260122112218.531948-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122112218.531948-2-tabba@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Remove dead code resetting HCR_EL2 for pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The pKVM lifecycle does not support tearing down the hypervisor and
returning to the hyp stub once initialized. The transition to protected
mode is one-way.

Consequently, the code path in hyp-init.S responsible for resetting
EL2 registers (triggered by kexec or hibernation) is unreachable in
protected mode.

Remove the dead code handling HCR_EL2 reset for
ARM64_KVM_PROTECTED_MODE.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index aada42522e7b..0d42eedc7167 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -260,11 +260,6 @@ reset:
 	msr	sctlr_el2, x5
 	isb
 
-alternative_if ARM64_KVM_PROTECTED_MODE
-	mov_q	x5, HCR_HOST_NVHE_FLAGS
-	msr_hcr_el2 x5
-alternative_else_nop_endif
-
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-- 
2.52.0.457.g6b5491de43-goog

