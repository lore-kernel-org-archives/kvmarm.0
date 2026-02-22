Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3938A2E63C
	for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 08:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771749236; cv=none; b=RVTJ3ZKiuJCpMNeK0iRe6OVVIwJKRrJGsFYaB6/Z4nZCi46eows6+nvHaUn8Z8OAxl7Ce43kRotY/D+4AobYeiu3BQ3bkIaNIYena6osxnzWBfyHIWGmJzgPDX9dZweMAdb3Fxirx8D1JS942p19yX9NmQm1EikMzl+vF/nTokw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771749236; c=relaxed/simple;
	bh=88krj4clSNRjBgcHzSin6IS19hZr1KA82D0vmmRs6FA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=u/S8VVKsZfDuyhcxkf5nCke7NuSF9B+mESFt6flLeGEN0miqJVhiP0ma12nCPFyVxUuXHMUGJWCFjcTI6I10sLFiV8Aq8XVg21z0vBPqsTBhbDvptERJ0DC2SsqcjdD5G7IqeQs2iMsEfO9RjuP+xb134Mqj10V1ZqB2cJafQ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kGfPqQ5T; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kGfPqQ5T"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso37566405e9.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 00:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771749233; x=1772354033; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uF6pAPbrtpXX8UslsPQ/1ObXO+PhRH6Th7tQ+yPzjrw=;
        b=kGfPqQ5TQbgNzXEtSnLnw1tdw654iXfmCdM+NjxaYuu0O+2wFeyQFQSQMIy2Uuk6QY
         926O2/scw6JhD4vd+DXPCG8dqHwIQwyhSZU7yuHBab5nGO6zmKAMVAyobWNZcqWlxgmR
         dMlFIXGZ6QK5Tz+un8DxfUOTanwq54uGHXSzZzHDz/GALbSWbuzzVQc5Gc4qq69XLWZ0
         B/8b2CpmugiS3EZK+Bh4M5CWC62/tmN+3LoEh46bmdVSBDFN4a0VG57cYUURC5VGv/HF
         e+vEGwoeSw4HVrKNPOFQGf89QAyBcWyhVqyZdm2VsG+021r0DRiMXARTPWAkoEZb6Gc6
         cbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771749233; x=1772354033;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uF6pAPbrtpXX8UslsPQ/1ObXO+PhRH6Th7tQ+yPzjrw=;
        b=WqRfsgF1Pv4i3/Lyqh5HxxfmSF/6D9N6IqxgcUVBeT0FFFQ7aV8FMOwmIpJwKDZfmw
         UZE4wSPm7bk1OtR75uMr1WHw1C3vMb3cMLrNwsKlgXve3zGJOOfn/jF8zB5oaIisjINq
         inbgcmrWa/4DqFhGu1uyMIYT9O2joXOm1MI0M8dU5vHIDJJeNrHQkWRkoOC4OF9Q9BlO
         9L+dgle5MXOrmvPkoVmEQivYPrC0y8b7H90amDXOdwlshWM50FO64GmONa6kOGXS7K5x
         mZcfa3yZrPd74jn9tCZqVdOlpeiVwRV1PBozwoj2WFq2HSER8GKdqVGj73UDgoSPdWax
         sw1w==
X-Gm-Message-State: AOJu0YzZZzJmahORAcXKq6CbJyiMTtHt2QoOnhlDE+Hr4qdqO9mZtILh
	mV2xgVTU9DdW8Ar/KuHpZa8EVkoEkcSfh3o9RbptaI7vn0bBmNXJ1PSeiAZRCA61GVdFFLlZw47
	rnPUf+o0Jr0UOw2Ga+B3oqlslEaoDOU8ojWgym9yqI/PS1Oeuu0zIOInGKoJXVeG6Z4OVegeBJI
	bgq7UgSkHMRlPisO55l9mpIqVdzzDN3Zg=
X-Received: from wmqa20.prod.google.com ([2002:a05:600c:3494:b0:483:1069:2eb4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:828c:b0:47e:e48b:506d
 with SMTP id 5b1f17b1804b1-483a962e003mr93985975e9.16.1771749233335; Sun, 22
 Feb 2026 00:33:53 -0800 (PST)
Date: Sun, 22 Feb 2026 08:33:52 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260222083352.89503-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu()
 for non-NV VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Commit 0c4762e26879 ("KVM: arm64: nv: Avoid NV stage-2 code when NV is
not supported") added an early return to several functions in
arch/arm64/kvm/nested.c to prevent a UBSAN shift-out-of-bounds error
when accessing the pgt union for non-nested VMs.

However, this early return was inadvertently applied to
kvm_arch_flush_shadow_all() as well, causing it to skip the call to
kvm_uninit_stage2_mmu(kvm) for all non-nested VMs.

For pKVM, skipping this teardown means the host never unshares the
guest's memory with the EL2 hypervisor. When the host kernel later
recycles these leaked pages for a new VM, it attempts to re-share them.
The hypervisor correctly rejects this with -EPERM, triggering a host
WARN_ON and hanging the guest.

Fix this by dropping the early return from kvm_arch_flush_shadow_all().
The for-loop guarding the nested MMU cleanup already bounds itself when
nested_mmus_size == 0, allowing execution to proceed to
kvm_uninit_stage2_mmu() as intended.

Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/60916cb6-f460-4751-b910-f63c58700ad0@sirena.org.uk/
Fixes: 0c4762e26879 ("KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/nested.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index eeea5e692370..7f1ea85dc67a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1154,9 +1154,6 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
 
-	if (!kvm->arch.nested_mmus_size)
-		return;
-
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 

base-commit: 8bf22c33e7a172fbc72464f4cc484d23a6b412ba
-- 
2.53.0.414.gf7e9f6c205-goog

