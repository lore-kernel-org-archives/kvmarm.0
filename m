Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793706279;
	b=bmTlR+WiGOkGa5Q0az8iYNPudkjwX3x/nJ/kv67bwduaNjxopFQRtxIS/BaOsIpEKGhd
	 FJe7EOsGUU4Ul69dMxqYfTaIcaqZeHpQK5XjS0s9aqshEOqlM5noWzgArWbzYnnWBrGYk
	 THvV9pGEWvQFduhHrS0yFgY5ye4f17Ucwo2DgBeZP3ytKjhzKwbNePT+EWFLiplB1RGvY
	 zNbhMhX0uTl9qk19pDtFJfQo9cAS90Ab56GmL+1RbSOMYDl9BD6MvbvKTejENYVZ/+YBO
	 FRefq9pDvho/ZrTo5cDC5FWdSq+koGdiciBpYAdjN8iegzJkHIHyFMoIGsjWncFBNzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793706279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=RqFmeSuXfKwzh6ahVFLLnCY13TcsmgSS8+wDHQOoqJ0=;
	b=st30Zphupw7qagADUtoYeTvRrE3KER9BaB4Ub1rTy3mCUCvMR0ax4zE4r31nrah9O6g+
	 71mnC5T/ex0rSWg24/h+TiedQ0Pz1hhYUcT62vgrfNiS/pXRpqSc9sNRM7WBBqno+STIJ
	 oR/Fd3Xvy58nmtHekjQHfbn6POdpH9wDKm+XGY5q+1YAxFxe1IER7a3SQr4Xevl/vGObr
	 h3l0Mxewc3cmnje6JZCobzOKnImodDeEYh9i8DnyHL8YtKxaEZXTQ0VaPiDk9ic2DKmDB
	 SlTAQQkNHwsALqQAjS9JHq+cJXa5CO9/VMMOgkF0T+W9vI4SLQ0AafgmFalTU/OcZ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="pvvvUiW/";
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DA6606A326
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 11:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48DA6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pvvvUiW/
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a214a5f8a1so41607625e9.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 03:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793706277; x=1794311077; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RqFmeSuXfKwzh6ahVFLLnCY13TcsmgSS8+wDHQOoqJ0=;
        b=pvvvUiW/3jfXWK6GE03q0w93gTR4/7Nm/4MYztzbwO//Brni7UEKn5coHwn2stPD1F
         3X0ecsNpYyihAB1oRGE9U0wrTyhnTUZfw/y4rYf0Mmcy4E8h9J2/eZL1CgTOZSFYFddO
         S8RYHpTC4afxU+PnYZ5IkIcHOlKAeelS6UKsZWdSdJHJOD5/IHCQ0Ja9VLbBSawFLFEQ
         xwmaxr+YFPoGvwEi3KasDSOP+aEP0Tl/XJjPq702Duecjd+VvrvEEIlTankZfdjjyDeV
         ZDofX1x/5bKLNiq0F7AHzRRJiTv3145i6tFgAyc1ZrZIvxfuxspoEZP9WUT2io8GhGDr
         Bh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793706277; x=1794311077;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RqFmeSuXfKwzh6ahVFLLnCY13TcsmgSS8+wDHQOoqJ0=;
        b=eT9qRm5579efFrKP2uBBtGaAIZeSWGqxCSlwdHrzM96uMysr4CLXrb1tTjsev57dWv
         nYe4LY8E7/ux1XGlBM2Em7k5oFYvfNiknI5KsWwnu1+hzaUOhxnP0Aufq4vAYcPg+7oJ
         ftYJMTX49iXX54vGFQOQyfjswlRBewkxy5Z9IrYEGiVX9+M3DryWQbx5S02xK5x2/Qw2
         JUYV4HCqr1S0H/dYKg1yczl8QD2UFY8ZPxemmbtalE0+RVqVV9ozAFeSZ9R5SU4veuxF
         bEHRo6tiJIXbAbCOJo2SeXyymAFPrKGbz5/NICDafX5PSBklV9aTvCH9ZQMAEZWCsu1R
         ZLBQ==
X-Gm-Message-State: APuU4Z/7cjo6ZUzsQxkWSdYy724DEZqR8ubkA//tzbh0tlfvxK19ZqIT
	861j8yZogizHHC7hxrCnYUHFblZoqhlt/O8FWEYPLjSkdpVre5uahLT8yJZKvvl1P83Le28oJla
	skz+7LOI0Otp4/fRpofwZE2NuTMsbHXAzyXmI1mbpv1S5TmLkNpKMCXZOdUT4ADKW+ezt65x/fd
	bNGN2SqKR2jQj9+L7u/YItFrumKg==
X-Received: from wmgg21.prod.google.com ([2002:a05:600d:15:b0:4a2:11fa:1981])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:870f:b0:4a2:1196:db0e
 with SMTP id 5b1f17b1804b1-4ac1899348bmr268213665e9.30.1793706276582; Tue, 03
 Nov 2026 03:44:36 -0800 (PST)
Date: Tue,  3 Nov 2026 12:44:12 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103114411.3642140-2-ardb+git@google.com>
Subject: [PATCH v2] KVM: arm64: Don't livelock when AT can't resolve a fault IPA
From: Ard Biesheuvel <ardb+git@google.com>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, will@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org, Fuad Tabba <fuad.tabba@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

When a stage-2 permission fault doesn't report its IPA in HPFAR_EL2,
__get_fault_info() recovers it with an AT S1E1R/S1E1A on FAR_EL2. If that
fails, kvm_hyp_handle_memory_fault() goes straight back to the guest, on
the assumption that the replayed access will either succeed or take a
fault that the slow path can handle.

That assumption doesn't hold when the AT fails because its stage-1 walk
takes a stage-2 fault on one of the guest's page-table pages, while the
guest still holds a cached translation for the faulting VA. The guest
doesn't walk its page tables, so it never takes the S1PTW fault that
would let the slow path fix things up. It takes the same permission fault
again, the AT fails again, and the vCPU livelocks in the world switch.

This was observed on Apple M2, which has no hardware Access flag
management at stage 2, and no DIC, so execute permission is granted
lazily and the first instruction fetch from a page takes a permission
fault. With DAMON_STAT enabled (CONFIG_DAMON_STAT_ENABLED_DEFAULT=y),
kdamond keeps sampling guest memory, and damon_pmdp_mkold() ages a whole
PMD at a time through mmu_notifier_clear_young(). With THP-backed guest
memory, kvm_age_gfn() therefore clears the stage-2 AF of 32MB of guest
pages at once, without TLB invalidation. When that covers both freshly
loaded code and the page-table page that maps it, the first instruction
fetch from that code livelocks, and the vCPU only ever recovers when its
thread happens to be moved to another CPU. In all 52 instrumented
occurrences, the AT reported a stage-2 Access flag fault on a stage-1
table walk (PAR_EL1.{S,PTW} = {1,1}, FST = Access flag fault, level 3),
while an AT S12E1R on the same VA succeeded. With DAMON_STAT disabled,
the AT didn't fail once in 210 boots. Nothing in this is specific to
nested virtualisation, nor to instruction fetches: a write to a
read-only memslot hit it too.

A stage-1 fault can lead to the same livelock. A guest that ages its own
page tables without invalidating the TLB, as MGLRU does through
ptep_test_and_clear_young(), can keep using a cached translation while
the descriptor in memory has its Access flag clear. If such an access
takes a stage-2 permission fault (lazy execute permission, or dirty
logging), the AT reports a stage-1 Access flag fault (PAR_EL1.S = 0),
which the guest never takes either, as it doesn't walk its page tables.
This hasn't been observed, but it is why the invalidation below is done
whenever the AT fails, rather than only when PAR_EL1.PTW reports a
stage-2 fault on the walk. A guest that merely races with its own
page-table updates isn't harmed by it: at worst, it takes a translation
fault that it was allowed to take anyway.

Invalidate this VMID's TLB entries on the local CPU before replaying the
access, so that the guest has to walk its page tables and takes the
fault that the AT ran into: either a stage-2 fault on the page-table
page, with a valid HPFAR_EL2, which the slow path resolves, or a stage-1
fault, which the guest resolves itself. In all instrumented cases, the
next exit was an S1PTW Access flag fault on the page-table page. This
only happens when the AT fails, so the cost is negligible.

With this change, an EL2 UEFI guest that livelocked in 27 out of 210
boots didn't hang once in 420 boots.

Cc: <stable@vger.kernel.org>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: add DSB before TLBI so that it cannot be issued speculatively before
    the AT even runs

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>

 arch/arm64/kvm/hyp/include/hyp/switch.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e0c55644224c..6b2ca89e8326 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -843,8 +843,22 @@ static inline bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
 static inline bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu,
 					       u64 *exit_code)
 {
-	if (!__populate_fault_info(vcpu))
+	if (!__populate_fault_info(vcpu)) {
+		/*
+		 * The AT couldn't resolve the IPA, typically because its
+		 * stage-1 walk took a stage-2 fault, such as an Access flag
+		 * fault on an aged page-table page. If the guest still has a
+		 * cached translation for the VA, it won't take that fault
+		 * itself, and would replay the same permission fault forever.
+		 * Drop this VMID's TLB entries on this CPU, so that the replay
+		 * walks the page tables and faults with a valid HPFAR_EL2.
+		 */
+		dsb(nsh); /* ensure that AT completed before issuing the TLBI */
+		__tlbi(vmalls12e1);
+		dsb(nsh);
+		isb();
 		return true;
+	}
 
 	return false;
 }
-- 
2.56.0.385.gac671c819a-goog

