Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793612878;
	b=GgUZgX9fR97NIpaBykU9N1QjduhKO6mikZe3NRqmupOU/wi1f/ChFMWG5EuxHQXle0Qi
	 l91Dde2+P/2jLLsCRWrs1MC7moKf6S1hejf8Nolpr/5Y3wRZb5oulRHOjbY0bAFDVSZbE
	 jmAoOVIcCFnY2v8CGzPmkzNUtjIWxeFcoZic9KRwmrOSLqoi7Pe53Uo1JrvQgFxZ95L7d
	 sZqHSzjkxalAio7K3Prcwl55Af9sFw1O7xjLjC5dVJVuI7RJ8GsrfITtXnsC3Km1yjSZC
	 jO1qpP6Wxmr0ISF7RQltoaYthgRf/BXXXS1dvjvWxKS0KYTDfOOohkAYeUp8HX+QsDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793612878;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=Ij4gPNs0GfjVbJFGWJtRXm0Tew534zu7KtTk34Zsa9o=;
	b=kxB4G18KvcY+ejIx4hOeSoZgvx1UleCqKzg2oWCkJwcXbbOZwafZunQO5I2tRVE0ZjAI
	 4GxfdxroorxT3yidnw/JNqk9IiMu92PefMT0HH2+uTH3jF51ALNMRDLUC7mH+HlR2illT
	 RnM5j511BmdKcZoPJB+ULLqUJByLrckE41g95GGxqiyYByuxhGfDKq7uAR2gUZt73sSM0
	 xOyTOsmPrbZT+YS5lEOPV3FV+jS3ORLHpwBCkyu1eJ6QK1BxSHcDM7iQhehhJYP9AtjZo
	 9RfJzjJdCzS33xWnEhjaW+6mbZtnv5/mNIEiTa9Hz03VOtWUL361DMv2jDXMxkDUUKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cmvPbjCW;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E42B606A33F
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 09:47:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E42B606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cmvPbjCW
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48dff112181so2531927f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 01:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793612876; x=1794217676; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ij4gPNs0GfjVbJFGWJtRXm0Tew534zu7KtTk34Zsa9o=;
        b=cmvPbjCWtz1nQ49UPMGiniLa3B6yQyZXf2y86uX8WZ/MjdzjNBi/+g27NIlZZK+opb
         dQAh2ndIyOAndI4tKp4ZkYpwQeaHBnP9pztm53WLFx57Q47h003febnOhahUwT4QLANL
         fVo74VwNDU4RNM1zwB2dLEwA5rTyuofo++IAprlKgzC2Fc/7aVTSrCituYAz0MLmV+Qv
         zvpUX52Ka3fWYf3oKieMpgMel+A5gRgfxzCzeOSu0up+DhgI/Q8b3934iMg2Rn4C3L+z
         t3P3PAt7Ml77nPGvQJg4hTkxbrEX0SqCOQbp/Z8xPqrgofbZPT0SVD48JVCOZ1+njiEL
         flFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793612876; x=1794217676;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ij4gPNs0GfjVbJFGWJtRXm0Tew534zu7KtTk34Zsa9o=;
        b=kMZ0aBWFIzsG5bUNI7KyWNiAU5swFrN+te48ce0YaphaUiRi/I4bdKZbaz1QMxAuLs
         4kbHxGRbyPA+rjQUypkzSDD855V4wYlxxRLteVXAc2ddT77MuyAOEnueGMj4bvIvoJSq
         KpS0xCB5oQr1jTPI76Na2sGjsnfe1xuqsfN14JM1Ifj+Pcjf+nG++m2li55t8TI5Uh0I
         UFdzjFBHJuZ+4Pb1KGXkijSiXy8yODxFGdtX0KUWxH/5QZ7LKB6QNlHzJoprB0NfqjKt
         JmjSPpZ5IvZHmmD68ACpV088ILna3j2+YYJ55mJbKm1cXfz0mSdKCJlL6jIdKNNmijB4
         6VCw==
X-Gm-Message-State: APuU4Z++VsXrGcGTL8GjgLgXK7rvCG6XO8yMXUA4tMZOH6RPg5+3dqUZ
	CTQLDWs22HdWJkun5UPfOkWZ+gK52GRiqBOEuAs0lbX/eAlBcI04hLoN1xrzMW3RBh7Lo2vQb4l
	Vt/CY2NLm6IkAypM/RsXDKUb+R86FO9b73NGSUy0wLVyQab5dR31alsekegJYOhFEZ0llO74Y4T
	I8rdgr9x1pKYIL2kCl8SKzRxfl/g==
X-Received: from wrtf8.prod.google.com ([2002:a5d:50c8:0:b0:48e:773f:1c7])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:310c:b0:48e:5cd4:aa60
 with SMTP id ffacd0b85a97d-48e6e2fbc14mr23004113f8f.42.1793612876088; Mon, 02
 Nov 2026 01:47:56 -0800 (PST)
Date: Mon,  2 Nov 2026 10:47:49 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102094748.2638468-2-ardb+git@google.com>
Subject: [PATCH] KVM: arm64: Don't livelock when AT can't resolve a fault IPA
From: Ard Biesheuvel <ardb+git@google.com>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
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

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>

 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e0c55644224c..4ba61b71d511 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -843,8 +843,21 @@ static inline bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
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
+		__tlbi(vmalls12e1);
+		dsb(nsh);
+		isb();
 		return true;
+	}
 
 	return false;
 }
-- 
2.56.0.317.g454f8302e1-goog

