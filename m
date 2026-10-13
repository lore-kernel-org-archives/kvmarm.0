Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B543F412B
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902023; cv=none; b=SQUPK43hpsev1VCFJ6xKoXLmyKDpi5Db39Kg5U9G2QyfpBvawQZCAAX2iH959czi4qcQixNuOi8elQeIYdB7tP5DMMIb8UfNJFn5fYBqz1lPrM/Fr6yBZQ0tw4MkCWb82qzWHpD/+PN0AMnEHQvfEKFQpDSwlo2Wqlsue/W6xIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902023; c=relaxed/simple;
	bh=Ducuf6SS/bfdD6KwAAH5f+/c4spXeWPNSOKqOShzR0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=evX3Av4hzvw2RAju/SFG8AqHTjH81peoJ0GtB/C4Lgwg6CbcP8tL0gitkCx2Dg8VZouzEKR1lR7HFHIAtUOYAJWRxvvihj3Ax9wgqouKJVECsRuRVfmxTMxcPa7ssCi2UChWSzWZH9vutPAQSLmhL/P5gqWG1RMX+dPFTxTtyjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JBpV0ZUc; arc=none smtp.client-ip=95.215.58.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JBpV0ZUc"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ducuf6SS/bfdD6KwAAH5f+/c4spXeWPNSOKqOShzR0g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791902020; v=1; x=1792506820;
 b=JBpV0ZUc5Bc/h3HvAXmV2heSzEJUyvDR3RtZ4EHIXHcvyePJGNgn0wkgwO2tB13d12teKo3q
 Gf0ldKUNYMdPqac+E3HKy4E1dyQ3TPrm+OZWBiSl31qKVEJ458RGySqBUvWDJ6ClblCZOfD9fZo
 1m52/nBBcjsKVzsZNSQxugPg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7db65e9a5b41bfc7;
	Tue, 13 Oct 2026 14:33:40 +0000
X-Mizu-Trace-ID: 7db65e9a5b41bfc7
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: vgic-its: Fix LPI double mapping and DISCARD
Date: Tue, 13 Oct 2026 15:33:38 +0100
Message-Id: <20261013143338.815377-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <86tsmp20ne.wl-maz@kernel.org>
References: <86tsmp20ne.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Tue, 13 Oct 2026 14:25:09 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > We do still need it for the window after the exit: with the delay
> > there and the same patches applied, the guest takes it in none of 20
> > runs, against 13 of 20 on v2.
>
> I don't understand what these probabilities represent. Either it works
> or it doesn't. And given that I have no idea what you are testing
> with, I can't really make head or tail of the above.

They're the number of runs, out of 20, in which the guest took the
discarded LPI. My reproducer has vCPU 0 issue DISCARD for an LPI pending
in vCPU 1's LR, at a varying time, with a debug mdelay() widening the
window, so only some runs hit it. I've since replaced the delay with
debug hooks that force the race, so now it either works or it doesn't.

[...]
> If you have a herd litmus test, how about posting it? It would really
> avoid a lot of that back and forth where the S/N ratio is pretty poor.

Sure, here are two, run with herd7 7.58 and the LKMM from v7.3-rc3. The
first models your diff and comes out Sometimes. The second adds the
request check before the flush and comes out Never.

C discard+halt

(*
 * P0 is the vCPU in kvm_arch_vcpu_ioctl_run() with your diff, with a
 * pending LPI queued on it: check_vcpu_requests(), the IN_GUEST_MODE
 * store, the flush moving pending_latch into an LR, the fold (on the
 * early exit, or after a guest run that leaves the LPI pending), and
 * the release of OUTSIDE_GUEST_MODE.
 *
 * P1 is DISCARD: kvm_arm_halt_guest() making KVM_REQ_SLEEP and reading
 * the mode in kvm_vcpu_exiting_guest_mode(), then clearing
 * pending_latch. A halt that reads IN or EXITING (1, 2) waits for the
 * IPI, which the vCPU takes after its fold, so only one that reads
 * OUTSIDE (0) clears here.
 *)

{
	pending_latch = 1;
}

P0(int *mode, int *requests, int *pending_latch, spinlock_t *irq_lock)
{
	int r0;
	int r1 = 0;

	r0 = READ_ONCE(*requests);
	if (r0 == 0) {
		smp_store_mb(*mode, 1);

		spin_lock(irq_lock);
		r1 = READ_ONCE(*pending_latch);
		if (r1 == 1)
			WRITE_ONCE(*pending_latch, 0);
		spin_unlock(irq_lock);

		spin_lock(irq_lock);
		if (r1 == 1)
			WRITE_ONCE(*pending_latch, 1);
		spin_unlock(irq_lock);

		smp_store_release(mode, 0);
	}
}

P1(int *mode, int *requests, int *pending_latch, spinlock_t *irq_lock)
{
	int r3;

	smp_wmb();
	WRITE_ONCE(*requests, 1);
	smp_mb__before_atomic();
	r3 = cmpxchg(mode, 1, 2);
	if (r3 == 0) {
		spin_lock(irq_lock);
		WRITE_ONCE(*pending_latch, 0);
		spin_unlock(irq_lock);
	}
}

exists (0:r1=1 /\ 1:r3=0 /\ pending_latch=1)

C discard+halt+check

(*
 * As discard+halt, with the request check between the IN_GUEST_MODE
 * store and the flush.
 *)

{
	pending_latch = 1;
}

P0(int *mode, int *requests, int *pending_latch, spinlock_t *irq_lock)
{
	int r0;
	int r1 = 0;
	int r2;

	r0 = READ_ONCE(*requests);
	if (r0 == 0) {
		smp_store_mb(*mode, 1);

		r2 = READ_ONCE(*requests);
		if (r2 == 0) {
			spin_lock(irq_lock);
			r1 = READ_ONCE(*pending_latch);
			if (r1 == 1)
				WRITE_ONCE(*pending_latch, 0);
			spin_unlock(irq_lock);

			spin_lock(irq_lock);
			if (r1 == 1)
				WRITE_ONCE(*pending_latch, 1);
			spin_unlock(irq_lock);
		}

		smp_store_release(mode, 0);
	}
}

P1(int *mode, int *requests, int *pending_latch, spinlock_t *irq_lock)
{
	int r3;

	smp_wmb();
	WRITE_ONCE(*requests, 1);
	smp_mb__before_atomic();
	r3 = cmpxchg(mode, 1, 2);
	if (r3 == 0) {
		spin_lock(irq_lock);
		WRITE_ONCE(*pending_latch, 0);
		spin_unlock(irq_lock);
	}
}

exists (0:r1=1 /\ 1:r3=0 /\ pending_latch=1)

[...]
> Is the hack below what you are asking for? I can't tell. If it isn't,
> please post your own version.

Almost: it's missing a request check between the IN_GUEST_MODE store and
the flush. Without it, a halt that reads OUTSIDE_GUEST_MODE just before
the store doesn't wait for the vCPU, which then loads the LPI into an
LR, takes the early exit on KVM_REQ_SLEEP and folds the LPI back after
DISCARD has cleared it. That's the outcome in the first litmus test's
exists clause. With the debug hooks forcing it on QEMU, the guest takes
the discarded LPI in every run with your diff, and in none with this on
top:

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f1449b0..896bc76 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1329,11 +1329,29 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
+		/*
+		 * Don't load the LRs with a request pending:
+		 * kvm_arm_halt_guest() doesn't wait for a vCPU it reads
+		 * as OUTSIDE_GUEST_MODE.
+		 */
+		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
+			isb(); /* Ensure work in x_flush_hwstate is committed */
+			if (kvm_vcpu_has_pmu(vcpu))
+				kvm_pmu_sync_hwstate(vcpu);
+			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+				kvm_timer_sync_user(vcpu);
+			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
+			local_irq_enable();
+			preempt_enable();
+			continue;
+		}
+
 		kvm_vgic_flush_hwstate(vcpu);
 
 		kvm_pmu_update_vcpu_events(vcpu);
 
-		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
+		/* kvm_vgic_flush_hwstate() can make a request when nested */
+		if (kvm_vcpu_exit_request(vcpu, &ret)) {
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			if (kvm_vcpu_has_pmu(vcpu))
 				kvm_pmu_sync_hwstate(vcpu);

Cheers,
/fuad
