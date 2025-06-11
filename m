Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598942D3A9C
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682051; cv=none; b=a0j9MEPNU4v1CaHsFy/13t1tOzn4EF02o2zLxMf/w7cgCsUs/HGBRLpwnojaX3UP0UlmioBEn01hWkrDm8Rd2ifNbFrNZVYyOcsRgyXxZMbT3pzc66+7jqdC8DPogZWQY22anGsFY3OLLh7qmQtU+NN68n4rOwp+NYzFbSXTIyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682051; c=relaxed/simple;
	bh=z4kCs1kk8FzhHP3ubWZ/+kPZ7fbmVPbe1K9/NNHAwZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IuzfvLLbMTAkjPDpwDnqyxPbokLsaQMH6OuLzP73jW8idzLXIiLBRVx8iPbcFvGSEZvZgAzEbBrfjZewxY07NwabvTzXKgaX6Iv0BQMGnizHrLhS0fVcRqgFADGfkyrBgOGkntwbBSzVNAkUuSzGLJH8GBb1Ffx6VwJbUwnrKIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DCEqXVEy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DCEqXVEy"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74847a38e5eso208348b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682048; x=1750286848; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IkktWH+V9h3bcYXFzddTxBsHDsmGjlRn4knyOKrNzLg=;
        b=DCEqXVEyQvB8WTjceK3eRRI5VXxZPj8Bb6KEetPd0KzfNCvzqsgu7oa1UWD3lIEW7m
         YqePYodXmkHM6n+dzYgHQhjEF4WN6hqjxvXz9fF0RLSAJ710uoNZLbxMQg+xymDWm0US
         VomuE5xaiGkweGz+kJrPDIKJbTHKwt2mSZu+/8h53urK7d3bgbfe4MqaFd5HYQBXMMSM
         VyXA5jIlBc3KLL2cX6AQm5Jhh95/8KCOe+HOUfPH+uoXSJWieNmgXQIwq4zQT3YNBPIl
         yEigPMiXD4yY42acwPnbaui5beDJNe3868ExCWLHJS2Mdh+++EJ+jsBpybbpxafgFS0G
         EfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682048; x=1750286848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IkktWH+V9h3bcYXFzddTxBsHDsmGjlRn4knyOKrNzLg=;
        b=AstHSRuLtQXYdFE+IHi1lJ8nL/evgwJYysbuRqWE+zDkuYxga4JlWm5w2FvblVN+gO
         YOBsfyjDVq3TiYFbAoYj2yzqMaXeqmH9L56MRVtKcAtnD9LKOUqHWcsEUUxAhgoq8Te/
         NvXU0A4yOjeP0EQqQKCGUdTu/+eOw7yGZVIXDtkXDGYAPZpFSePBi5wZmFVmhb1xFn6z
         iEwDd+5IRBs1aw9rgosSOhaqYWBRDK87JhB41CFIYdCjQtGk45NkB9FxuPoG8BZ20gLx
         umpQvuyKzHx/aPraHuCSA2ks0JHV2aYTNTCby01V72xHEF6RhD32dqiLQx210j7tRYlF
         ulug==
X-Forwarded-Encrypted: i=1; AJvYcCUPt51k2jhJr1pDBE2pFfNGjMHP6h8yZX7SFFKU9hJDRMwJ8Xzcvn00f3DUoSxJgXDLxm29gVs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmOCFfy5SfBt513IVOYIzsvsZen+vr3SR49rIaIddQF0cITIc9
	ixiKWK2XDBXP5/OzK9cqYChEbHLAtZFUZBSwgGP7mgaBblPwCIZfUfXR2cINAX4JJfDctANg9+E
	jYcXB0A==
X-Google-Smtp-Source: AGHT+IFju6WrqvBHypqRYrHHoWezRKFOOmxRqymOxF1hxx8+vosFxM+8IRo96ENVv8Z0pfdBM/f4N8kJm6A=
X-Received: from pflc8.prod.google.com ([2002:a05:6a00:ac8:b0:746:1e60:660e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3925:b0:736:d297:164
 with SMTP id d2e1a72fcca58-7487e0b1b93mr961505b3a.1.1749682048530; Wed, 11
 Jun 2025 15:47:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:22 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-21-seanjc@google.com>
Subject: [PATCH v3 19/62] KVM: VMX: Suppress PI notifications whenever the
 vCPU is put
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Suppress posted interrupt notifications (set PID.SN=1) whenever the vCPU
is put, i.e. unloaded, not just when the vCPU is preempted, as KVM doesn't
do anything in response to a notification IRQ that arrives in the host,
nor does KVM rely on the Outstanding Notification (PID.ON) flag when the
vCPU is unloaded.  And, the cost of scanning the PIR to manually set PID.ON
when loading the vCPU is quite small, especially relative to the cost of
loading (and unloading) a vCPU.

On the flip side, leaving SN clear means a notification for the vCPU will
result in a spurious IRQ for the pCPU, even if vCPU task is scheduled out,
running in userspace, etc.  Even worse, if the pCPU is running a different
vCPU, the spurious IRQ could trigger posted interrupt processing for the
wrong vCPU, which is technically a violation of the architecture, as
setting bits in PIR aren't supposed to be propagated to the vIRR until a
notification IRQ is received.

The saving grace of the current behavior is that hardware sends
notification interrupts if and only if PID.ON=0, i.e. only the first
posted interrupt for a vCPU will trigger a spurious IRQ (for each window
where the vCPU is unloaded).

Ideally, KVM would suppress notifications before enabling IRQs in the
VM-Exit, but KVM relies on PID.ON as an indicator that there is a posted
interrupt pending in PIR, e.g. in vmx_sync_pir_to_irr(), and sadly there
is no way to ask hardware to set PID.ON, but not generate an interrupt.
That could be solved by using pi_has_pending_interrupt() instead of
checking only PID.ON, but it's not at all clear that would be a performance
win, as KVM would end up scanning the entire PIR whenever an interrupt
isn't pending.

And long term, the spurious IRQ window, i.e. where a vCPU is loaded with
IRQs enabled, can effectively be made smaller for hot paths by moving
performance critical VM-Exit handlers into the fastpath, i.e. by never
enabling IRQs for hot path VM-Exits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 110fb19848ab..d4826a6b674f 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -73,13 +73,10 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	/*
 	 * If the vCPU wasn't on the wakeup list and wasn't migrated, then the
 	 * full update can be skipped as neither the vector nor the destination
-	 * needs to be changed.
+	 * needs to be changed.  Clear SN even if there is no assigned device,
+	 * again for simplicity.
 	 */
 	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu) {
-		/*
-		 * Clear SN if it was set due to being preempted.  Again, do
-		 * this even if there is no assigned device for simplicity.
-		 */
 		if (pi_test_and_clear_sn(pi_desc))
 			goto after_clear_sn;
 		return;
@@ -225,17 +222,23 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 	if (!vmx_needs_pi_wakeup(vcpu))
 		return;
 
-	if (kvm_vcpu_is_blocking(vcpu) &&
+	/*
+	 * If the vCPU is blocking with IRQs enabled and ISN'T being preempted,
+	 * enable the wakeup handler so that notification IRQ wakes the vCPU as
+	 * expected.  There is no need to enable the wakeup handler if the vCPU
+	 * is preempted between setting its wait state and manually scheduling
+	 * out, as the task is still runnable, i.e. doesn't need a wake event
+	 * from KVM to be scheduled in.
+	 *
+	 * If the wakeup handler isn't being enabled, Suppress Notifications as
+	 * the cost of propagating PIR.IRR to PID.ON is negligible compared to
+	 * the cost of a spurious IRQ, and vCPU put/load is a slow path.
+	 */
+	if (!vcpu->preempted && kvm_vcpu_is_blocking(vcpu) &&
 	    ((is_td_vcpu(vcpu) && tdx_interrupt_allowed(vcpu)) ||
 	     (!is_td_vcpu(vcpu) && !vmx_interrupt_blocked(vcpu))))
 		pi_enable_wakeup_handler(vcpu);
-
-	/*
-	 * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
-	 * as blocking and preempted, e.g. if it's preempted between setting
-	 * its wait state and manually scheduling out.
-	 */
-	if (vcpu->preempted)
+	else
 		pi_set_sn(pi_desc);
 }
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog

