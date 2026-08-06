Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BB8376463
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028479; cv=none; b=UXR0yp9Ze6fe/PWdiqc5OuxXnR2EE5Sebgo8FGg3kNEVhwHVupwFX8mIARyS6K8qNmsY88MxaR0odDMnQISVGZdMF9S6NjpI+9NHLCvuzvitV2A3p05OJQuXh5BZcJF9UAdaVu1MK1cF72FUnmUZaA3C/ZargTOcrr4ERjMATiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028479; c=relaxed/simple;
	bh=7IGVnmtezJzz+vG1Zjjgm7GLlt3laMJth5Gf0zoVmlI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=k6NboG0LHGutwu63eeF4tJ2NgghhJ5QydNLtKNdtktCqd/XRInD+fnqiatYFwvDG5RgJQruznPZLj03mijBnY6cKyqFEHqchaZ1f5n01c+tbuCkiHQZ01gUDHi/xcoEOfo1lid2dlDDzTLa1hzzbahyWvwRPbGUCml6R+n0x6M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bRFLIKuE; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bRFLIKuE"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954dcd6131so19315035e9.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 08:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786028476; x=1786633276; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P8/Uc5RoXpFVHkZ1epqzt9nXXbG81Fj6PP6hKjU9EoQ=;
        b=bRFLIKuEk4+1/TzBWlTGB1RRmoBbgcYpExd8rwo2/Oy3dlf02bf1fEh+k6BpDK0tiA
         jTTO+uoUQZWs1aHEw0liW+m6RVANC2V9FLTpEcxZ55uZofRtQ1XbNIOAjizkEgg1yvYo
         RvDawkqwivAnRhqmzMMKBuHr1atBa1WDB+GX/+EU2Au1eSEqvK+Xn2G93M2sHRBGSyKp
         zwC9gJdUAGkSuAYO6kalVbt03hsmWv654y8nkfimvkecf7NV0TNO5Ut7HbecVgnn06fC
         4hqGdbX0JnprlrSKHwDFHwTiVrr4c0RUwANzCBButWfB7SxLf2r48Lxf5AZs1vFDv6yc
         YLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786028476; x=1786633276;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P8/Uc5RoXpFVHkZ1epqzt9nXXbG81Fj6PP6hKjU9EoQ=;
        b=b3k4YupQuW4jhAqYIlewO50YqyFsJVmgQkj8ONqbV0KEIKOTdChLxndQQbSUQoeFg8
         mwR3hiiCVq3icCucZ+j5enxDYkuLlQzqRFmEsPGvQlDAm2cZNj0U4ZIbA/9w4cWjcQaz
         yEFkiFVd1E8CP/aEPuGKRWJ/4ZIE1OVKskHMNh2JkSyPRCQstav5Yuuw96b5j7Th7rec
         9BxDAssb02xGmqgNOUgYvOdgqaUUhpiT1zKJiP/4azN3nmn6grP5/cYUqjdjpR6FIwwG
         1ood3JsL87wqi6CjEi+BUPL9ut4Z5y16QCWQAqcgR1GK4mxbKwwsxVKxoQ5Fsl/lh3Ey
         lItw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/PF934wnAGqbeJ4HNiCWVlFWuZHFizKcXHvG0L65gSnrMMcEzLFJmi6bGuCiD4PYTXnRLm6M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxN+9E/bN0uX/pvT95VgMJG6Tukqva/BvUmqKU8abDv2e9Fv7tq
	2yrfJMayxKGQodr9Xxhd4Ys2qvh+JTc3GKsrtv1MegqCymMr3E2OVQE41EHihceG/g0NxIehXOK
	vlTlHLN5m2CBf8w==
X-Received: from wmok17.prod.google.com ([2002:a05:600c:4791:b0:495:5b2e:3824])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:cc0b:0:b0:496:cb48:5eb8 with SMTP id 5b1f17b1804b1-49959e38ecamr25064705e9.15.1786028475423;
 Thu, 06 Aug 2026 08:01:15 -0700 (PDT)
Date: Thu,  6 Aug 2026 15:01:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806150105.4010701-1-smostafa@google.com>
Subject: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

When running on a setup affected with broken CNTVOFF_EL2
(has_broken_cntvoff())

Booting with VHE or protected mode(nvhe) (id_aa64mmfr1.vh=0
and arm64_sw.hvhe=0) works fine.

However launching a protected VM with protected hvhe mode panics the
guest kernel:

[    0.000000] Internal error: Oops - Undefined instruction: 0000000000000000 [#1]  SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc3-g05f75bd71e0e-dirty #29 PREEMPT
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 000003c5 (nzcv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : arch_timer_shutdown_virt+0x4/0x1c
[    0.000000] lr : arch_timer_starting_cpu+0x1c4/0x2d4
[    0.000000] sp : ffffa6bd9a193c00
[    0.000000] x29: ffffa6bd9a193c20 x28: ffffa6bd9a1bcf88 x27: 0000000000000000
[    0.000000] x26: ffff00001be70dd8 x25: ffffa6bd99d85000 x24: ffffa6bd99d85ee4
[    0.000000] x23: ffffa6bd99d85000 x22: ffffa6bd9a1499c0 x21: ffffa6bd9a1ab900
[    0.000000] x20: 00ffffffffffffff x19: ffff00001be8b600 x18: 000000000000028c
[    0.000000] x17: 00000000510f0010 x16: 00000000510f0010 x15: 00000000500f0000
[    0.000000] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000018
[    0.000000] x11: ffffa6bd9a8ac000 x10: 0000000000f0000f x9 : ffffffffffffffff
[    0.000000] x8 : ffffa6bd98822e18 x7 : 0070752d65746174 x6 : 00111ff76e007261
[    0.000000] x5 : ffffa6bd9ad68078 x4 : 0000000000000000 x3 : ffffa6bd98822a0c
[    0.000000] x2 : 0000000000000073 x1 : 0000000000000001 x0 : ffff00001be8b600
[    0.000000] Call trace:
[    0.000000]  arch_timer_shutdown_virt+0x4/0x1c (P)
[    0.000000]  cpuhp_invoke_callback+0x11c/0x280
[    0.000000]  cpuhp_issue_call+0x1e8/0x224
[    0.000000]  __cpuhp_setup_state_cpuslocked+0x1d8/0x2b8
[    0.000000]  __cpuhp_setup_state+0x50/0x74
[    0.000000]  arch_timer_register+0xc0/0x148
[    0.000000]  arch_timer_of_init+0x148/0x170
[    0.000000]  timer_probe+0x74/0x124
[    0.000000]  time_init+0x18/0x58
[    0.000000]  start_kernel+0x1c0/0x3ac
[    0.000000]  __primary_switched+0x88/0x90
[    0.000000] Code: c80b7d2a 35ffffab 17ffffeb d503245f (d53be328)

And for non protected VMs seems to hang or progress really slowly.

The workaround avoids setting non-zero CNTVOFF_EL2 and trapping the
virtual counter to emulate the offset.
In the VHE path (timer_set_traps()), traps are only enabled when the
guest actually has a non-zero virtual timer offset.
However, __timer_enable_traps() in hyp/nvhe/timer-sr.c unconditionally
set CNTHCTL_EL1TVT and CNTHCTL_EL1TVCT whenever has_broken_cntvoff()
was true.

Which causes 2 issues:
1) Protected VMs: kvm_handle_pvm_sysreg() does not find "cntv_ctl_el0"
in pvm_sys_reg_descs and injects undefined instruction exceptions.

2) non-protected guests are trapped all the time even with offset of
zero.

Fix this by adding a check in __timer_enable_traps() similar to the one in
timer_set_traps()

Fixes: 0bc9a9e85fcf ("KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index ff176f4ce7de..98b6e37ee8fa 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -10,6 +10,7 @@
 
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <hyp/switch.h>
 
 void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
@@ -63,7 +64,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 	 * Trap the virtual counter/timer if we have a broken cntvoff
 	 * implementation.
 	 */
-	if (has_broken_cntvoff())
+	if (has_broken_cntvoff() && hyp_timer_get_offset(vcpu_vtimer(vcpu)))
 		set |= CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
 
 	sysreg_clear_set(cnthctl_el2, clr, set);
-- 
2.55.0.654.g21b8a5bc05-goog

