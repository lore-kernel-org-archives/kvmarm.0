Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DDC1C5D6A
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462299; cv=none; b=UJ3+ycCC65DNVzl9Kqc2HOmJL5NNuXiXlLeWYj2x4aj9n8wefOkJj2uUMtas30Eh2zeCJcjkLTKQijwPS5WHjpfndoj45ZKejNr7cZPWL1fTxocyIdwJ8KC89C/GebpSuhSYACLBGd57u9d+Srukcfun1RbC71mb2ZI25byNbtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462299; c=relaxed/simple;
	bh=HS3A6nZ/C1SGV1BCJYeGF/yP+AMKPP+weyYCOkSvWPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GIOhrdGJNP1R0uNboEhbgJJie5XZrgpBb7u/npvhCcxGofM6y/IegrMtuCYgdwBjYvaiISEQXRQyfyimNVj7C2polHAnH5PRNGRxtAN9WlgJ7nQoNaQ5tjsb7Ll9FZHGMyTDFfYA0VOx3vUATEgIrSwoUCkii4Oqhd0mvrFzpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OfBYi4Nj; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OfBYi4Nj"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6417677bf55so6934555a12.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462296; x=1764067096; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MdD3HvYe/LmQgWb1ELzMtTfkz5l2xc5jclOfmsq7xGc=;
        b=OfBYi4Njcv+xtknkcgp6lOxWUxY+5UjKapHiHzm8JyQE1ItLINH386BUY+gR2yDMwR
         tt7jj60LZavtGCV1h6OmYOhm7tnO0thNbJ7ieac5V1gN1HCnD/xRb09ZQauumFW98vqq
         1usIvjLEij6AFChltneuBvYVUZaEuSG8sL9Qn2BXS1i0+Glss1WxzXzraZd7iojnm6eL
         xPVvgmX0O2jYkSHkvsnaW4AWpOdv92kkQP7icvRqHIDLEl6qouf9ArlqbkipDEBJMIxN
         2bKDJe3ZoOlxZ0WGLTiOF9A22Bo2vNy/76jT1EImLrfTPlWTjg2i3neuBs0qeRQTsVCv
         juYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462296; x=1764067096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MdD3HvYe/LmQgWb1ELzMtTfkz5l2xc5jclOfmsq7xGc=;
        b=Aw9H7NHht8IFtTpaUWvu8VgJ0AigFVsxr08JWqsRAHoAL/o7E75d/FMG97iaxhSv8x
         iGEOFdLuyBXW7AhPP2DFz9JThyJqfbwKYwZtqMgATTesC/GHEwYIwq6Qy7A1k5qhYVT1
         6Le58xDLyX86t1xt3E3tdL0LVHyyOar6Pb2Q2YRIjRyUCx7eQbuIuv9DvWQVyQLxOCYR
         wFBmpC4N4x698tqY2b3pNc1qTKXGOSGUx4l4944SgCZOCNTX4AQBY4mNChuUiVZWId4L
         ODRkQhgdvMbZcf7YEI/qdLvllrURtW4S+WchTU/q8pbeOF4QeCro2OjJnbCp95TOzQCS
         +cxw==
X-Gm-Message-State: AOJu0YzdKfBWrc3dRCLY4e30QnY0LBETUBZHTSsE1Z2PpaVYpdAdJuGL
	HuhqYS2e1dmIiLIS1/TZFEeDjq8Fjmz61WYVjZ56quB4CZ1yuNKrEV+0kQ3oY1ffnjl3zU4HAK8
	vIV+COLL/jZfWVSY4+PypyTNQapIp/nhmF7cStA1hlj2lSQRxeYf0u3LLyv815FoJuaehF94qHN
	LJPc8ee1XVlcGh95SZVriOGFTEJ/q65Lo=
X-Google-Smtp-Source: AGHT+IEJA/93zlApirgJ20FxZ4HFh69ol4ZkNO3y+csZUeciJUQyIEUxS2YM11xAwc6simPGysMnBpLtPg==
X-Received: from eda13.prod.google.com ([2002:a05:6402:a00d:b0:643:38d8:ea2a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:51cf:b0:640:9bb0:a059
 with SMTP id 4fb4d7f45d1cf-644fe9b27demr2655048a12.10.1763462296292; Tue, 18
 Nov 2025 02:38:16 -0800 (PST)
Date: Tue, 18 Nov 2025 10:38:06 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-10-tabba@google.com>
Subject: [PATCH v5 9/9] KVM: arm64: Prevent host from managing timer offsets
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
2.52.0.rc1.455.g30608eb744-goog

