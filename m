Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABEE3B4E94
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 08:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786179517; cv=none; b=oHlSPGdIt7rj9is5D4ukke5tsTL/iqvSwZi6+YYtC0X/XM3Xd9e26wFObonQKEhwgyafapj7u2HD9lPrZ66cJnTGN35HgnuauGPbWiydXf+CpuVbutQMukY2tOTuHuKp9/8TOw0807C7pPJUyTg1OIrolnfUJLZh/r/qqRFT5+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786179517; c=relaxed/simple;
	bh=G4qF8Z3F8YznyvYaSnDICEuJAKLvMzJPHvz7WlvNabM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WxazuOVyeth4ohu+NXPR5i/eSTMtcFyK3n8L/rkMIWP4PUCtfCKHLI7kyuU+RIcEnggscjs2N9kqMELwLvkivc/I6S7V/v6lVetIlx+I8e35e2pqmrV6pamfkR1pROSVZFpo2hIXx7ZLdQkkMbOfAI6MkEgKmCqwwqqpLwgAw0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jK5Lsm1l; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jK5Lsm1l"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49571407d1dso2246095e9.0
        for <kvmarm@lists.linux.dev>; Sat, 08 Aug 2026 01:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786179514; x=1786784314; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jwmzaJ2YawJZB/O6hrcBLYDYP6+Ln0uIsTfu/SId0gY=;
        b=jK5Lsm1ldvH9UlrYUgHS294U2T5NaMv1q04+Ve9IB+G23ykTdNHfBlkne1cDeCIBeb
         5aFJ6ehxkQ+MIYPHuwimSDB7DSlQjkGjZJWxl+364uKltXUSgSUIsKKkIsv01q/HqLur
         f2W16Dl0xVkWNz/TevAoqr8PrhE0vKXmhSK5V5LBnXU5pSscSz9cnmDi1GxhCwerTh/o
         he/3Mn8SW5or1q2uQ3DbmeBIRYiWWnDF5ZOR39cMzqk4axWZDl/Lf1x2E5/VYIQgVlJ4
         YYgn4Cae2nDSouwSKSPFnzPilTJvM0JSxbQMQ2ZAqYlSUeY2v299jOmcPZS070kmT1Oa
         gJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786179514; x=1786784314;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jwmzaJ2YawJZB/O6hrcBLYDYP6+Ln0uIsTfu/SId0gY=;
        b=DIdHfh/BYPFiK6qAuq4lOjg87K1TNzq9QldvvQPxmKCHHCIQPsmHBfSmQtvugy9Ysz
         Tk/a9kCxe3aSiYwLwNp7Kv8Y5El0d4BatjAWNMajMzJu4oUbdCRYjLZQTWle4IXYKjng
         oem5Jh9wUh7HTFMrrQHygwpatNaUNiq/H0HuLeCQvRaWknEjp/2+FOjnfgJ721ykGs2D
         ZKAwy5mwvz+Qfb7hWM+2qcuIRYnd1nP2rrlGeIXZVp0709o5J7kYackT6ZmYN3Sq6z+h
         gsTZG1G12gCyMfe9HwtRyrK2q4OjC87pJ7rqHm8uGOZlPCQUzbln+Q3CUOa/2yKPHUNR
         uoxA==
X-Forwarded-Encrypted: i=1; AHgh+RrK5WB4LtAi+ZJl+IQpmzP264sDtkURvMFmAS2FpBkNgw8N7wle45BGb5s2MxxPWobPEvh9HCs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd5J9uIdIfZKgpewCxFINPnIYmlOyC38UitY94t4qEpzxMF1SI
	ES1DQIWgIWPoN3Z9Qls+iIuocTw+4RrVNKETlR7eXiCAd5arzAnzAP0Gr+y15cLtE+u16+EMWUt
	8A8t0u195YA9tYg==
X-Received: from wmdd13.prod.google.com ([2002:a05:600c:a20d:b0:493:b301:e269])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:620e:b0:495:6274:56c2 with SMTP id 5b1f17b1804b1-4994e70a6f5mr464694635e9.2.1786179514030;
 Sat, 08 Aug 2026 01:58:34 -0700 (PDT)
Date: Sat,  8 Aug 2026 08:58:24 +0000
In-Reply-To: <20260808085824.732659-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260808085824.732659-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260808085824.732659-4-smostafa@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	yaoyuan@linux.alibaba.com, Mostafa Saleh <smostafa@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>
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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 51b4f5010b66..993065716913 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -61,9 +61,9 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Trap the virtual counter/timer if we have a broken cntvoff
-	 * implementation.
+	 * implementation and non zero offset as in timer_set_traps()
 	 */
-	if (has_broken_cntvoff())
+	if (has_broken_cntvoff() && timer_get_offset(vcpu_vtimer(vcpu)))
 		set |= CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
 
 	sysreg_clear_set(cnthctl_el2, clr, set);
-- 
2.55.0.654.g21b8a5bc05-goog

