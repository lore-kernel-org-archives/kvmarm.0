From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 2/2] KVM: arm/arm64: Stop leaking vcpu pid references
Date: Thu, 30 Jun 2016 15:39:37 +0200
Message-ID: <20160630133937.2654-3-christoffer.dall@linaro.org>
References: <20160630133937.2654-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF0B49B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 09:33:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QIVGZxpkMz5e for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 09:33:35 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D17BA49B5D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 09:33:34 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id r201so119268074wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 06:38:51 -0700 (PDT)
In-Reply-To: <20160630133937.2654-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, "# 3 . 10+" <stable@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: James Morse <james.morse@arm.com>

kvm provides kvm_vcpu_uninit(), which amongst other things, releases the
last reference to the struct pid of the task that was last running the vcpu.

On arm64 built with CONFIG_DEBUG_KMEMLEAK, starting a guest with kvmtool,
then killing it with SIGKILL results (after some considerable time) in:
> cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff80007d5ea080 (size 128):
>  comm "lkvm", pid 2025, jiffies 4294942645 (age 1107.776s)
>  hex dump (first 32 bytes):
>    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<ffff8000001b30ec>] create_object+0xfc/0x278
>    [<ffff80000071da34>] kmemleak_alloc+0x34/0x70
>    [<ffff80000019fa2c>] kmem_cache_alloc+0x16c/0x1d8
>    [<ffff8000000d0474>] alloc_pid+0x34/0x4d0
>    [<ffff8000000b5674>] copy_process.isra.6+0x79c/0x1338
>    [<ffff8000000b633c>] _do_fork+0x74/0x320
>    [<ffff8000000b66b0>] SyS_clone+0x18/0x20
>    [<ffff800000085cb0>] el0_svc_naked+0x24/0x28
>    [<ffffffffffffffff>] 0xffffffffffffffff

On x86 kvm_vcpu_uninit() is called on the path from kvm_arch_destroy_vm(),
on arm no equivalent call is made. Add the call to kvm_arch_vcpu_free().

Signed-off-by: James Morse <james.morse@arm.com>
Fixes: 749cf76c5a36 ("KVM: ARM: Initial skeleton to compile KVM support")
Cc: <stable@vger.kernel.org> # 3.10+
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 893941e..f1bde7c 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -263,6 +263,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_vgic_vcpu_destroy(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
+	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
-- 
2.9.0
