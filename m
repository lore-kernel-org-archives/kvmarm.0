Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2A230497C
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450042; cv=none; b=P1vcENoFMgbMSwe/3UmquvNI6l3/MxVFGXgEmLxNkhFT1A4uli6uFBHEUVccUe/yekXbLhGRHBg7YTo4w5E8Lml7Fngy4yDD48ONTRXIMaX0tyuQbMIeh6IdhAc6unzyS7skzkXds5QHmaBIH2lKRnk1KXi3bFn5ZwH7HX4Tbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450042; c=relaxed/simple;
	bh=a0bm5ypoL+ePWexa5r4NV2hTrNL9J6dicbZFBQV7ZO8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bmQg3uAx54uBHpjkUuruB0PlkwTj1SY4O9GOhGf58X4muGfD8IZFYAg06AAVUfLKBnf0HtRlrdUeuZB+bDJgEtlmEegZ/ChOOoN+lLaJphx4uxAWUBpo8G7QreDhL3LTFYrNwY/WAwq5LojJTjcraDArSfsmVPaDoGxmq9kaiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eEqqAibF; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eEqqAibF"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso9941535e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450038; x=1766054838; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPJFeWIsG1i6FowmtIAisiP3QqBxSUvcrKvafvSq4e8=;
        b=eEqqAibFasFgOL7RJ4ZTRRafsMlP4bvABdVr96EB8vuq08ZfMTjz88ceKDoODtcLvP
         oReQ5hutEiy6QowSYN/qsnvniIJsciUmzhbApRz/IaU2BrzmJVIYrayyCo3dY1TosB87
         nJE7iX56imOyqv6ocg+5oCwZrS4IFvmyDNAXQuv90ncQkLw1MzehuX/wb8ACffMSUF4a
         P2yMyC/ngUO7ycTiM0mPfzpzV1/Qk+rqAunz9Ap+p5DAud2eUUg80ieQlfsQgWb5o9wQ
         G7q1FtYqcixT4wMuyJjgTtTLZru0+siQL84DtqjUYSWkU04tttmnCy9CZr4OcSxQPp4J
         KCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450038; x=1766054838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPJFeWIsG1i6FowmtIAisiP3QqBxSUvcrKvafvSq4e8=;
        b=S1XV43rcmQVOuJ16VKqLPUw4n9A6vcqjdCsgS3BAX54i01MHZlLpIbqXwg11NEuJLQ
         m7HfCwtaMeAKOOx9dAZSGsqbaaLW5W71CykXtES393k8kJSfG8KrNy6z1DCIqLOWzMeS
         EBLuft5yVTlw+PKDUPwx/AM4+aMX2qQM2p3LONoGdsOaZGOwVdKnsH7aK21BeOUy6tqv
         LjfSxPy8W0l2LaM7g4suMidB1W3sUfycgkHRE1wFXHmTwqQKe5cLi3Fe3Ob3jIb7k1/d
         5ckU/6nROkWEYr/IV+AzuKtuGOBCI/PvAYA/H/+HNYfk7Rvpgsnta3YRtQmi1mUB5ig3
         1wSQ==
X-Gm-Message-State: AOJu0YzpFM2VC9CuOoxOc/qCyzYSYWj2vE1pXN5MPjRZnOim/BhV3yVy
	HyRqo6ex6aj11rn6zo+0aztan7T0SaWkrV/R2j1+Me/RUzYo+zLes32ZQpQpspTnD58PoHSGifW
	T5ssMFDP2WBhHW0mqi5I5U0Ko8xROGZu6/W47q0FSLH+aG0rXJXKLvDq35PfWeGYIyQGNS3RZJI
	cWSyrXXmXPyP1N0LqB0kLsmTfDN7xvyRI=
X-Google-Smtp-Source: AGHT+IFxe3la08OatSiShthELwpIsMGdrPJNlN/I9MD19vMV+FsiKC4eR8k6s85XeMgwNaC6DyldV+5Jog==
X-Received: from wmpg4.prod.google.com ([2002:a05:600c:4c84:b0:477:55d3:90d1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4693:b0:471:989:9d7b
 with SMTP id 5b1f17b1804b1-47a8378cd86mr56456405e9.21.1765450038441; Thu, 11
 Dec 2025 02:47:18 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:09 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-10-tabba@google.com>
Subject: [PATCH v6 9/9] KVM: arm64: Prevent host from managing timer offsets
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For protected VMs, the guest's timer offset state should not be
controlled by the host and must always run with a virtual counter offset
of 0. The existing timer logic allowed the host to set and manage the
timer counter offsets for protected VMs in certain cases.

Disable all host-side management of timer offsets for protected VMs by
adding checks in the relevant code paths.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arch_timer.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3f675875abea..f5407301c8f9 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1056,10 +1056,14 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	ctxt->timer_id = timerid;
 
-	if (timerid == TIMER_VTIMER)
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
-	else
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	if (!kvm_vm_is_protected(vcpu->kvm)) {
+		if (timerid == TIMER_VTIMER)
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
+		else
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	} else {
+		ctxt->offset.vm_offset = NULL;
+	}
 
 	hrtimer_setup(&ctxt->hrtimer, kvm_hrtimer_expire, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 
@@ -1083,7 +1087,8 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
-	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
+	if (!vcpu_is_protected(vcpu) &&
+	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
 		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
 		timer_set_offset(vcpu_ptimer(vcpu), 0);
 	}
@@ -1687,6 +1692,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 	if (offset->reserved)
 		return -EINVAL;
 
+	if (kvm_vm_is_protected(kvm))
+		return -EINVAL;
+
 	mutex_lock(&kvm->lock);
 
 	if (!kvm_trylock_all_vcpus(kvm)) {
-- 
2.52.0.223.gf5cc29aaa4-goog

