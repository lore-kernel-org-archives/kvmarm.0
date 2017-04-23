From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 35/79] arm: KVM: Treat CP15 accessors returning false as
 successful
Date: Sun, 23 Apr 2017 19:08:45 +0200
Message-ID: <20170423170929.27334-36-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 043F549C6F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svbVQHvzlntF for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:24 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29E3049C82
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:22 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id r190so50450672wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:08 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Instead of considering that a CP15 accessor has failed when
returning false, let's consider that it is *always* successful
(after all, we won't stand for an incomplete emulation).

The return value now simply indicates whether we should skip
the instruction (because it has now been emulated), or if we
should leave the PC alone if the emulation has injected an
exception.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 519aac1..2c14b69 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -520,15 +520,15 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
 		if (likely(r->access(vcpu, params, r))) {
 			/* Skip instruction, since it was emulated */
 			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-			return 1;
 		}
-		/* If access function fails, it should complain. */
 	} else {
+		/* If access function fails, it should complain. */
 		kvm_err("Unsupported guest CP15 access at: %08lx\n",
 			*vcpu_pc(vcpu));
 		print_cp_instr(params);
+		kvm_inject_undefined(vcpu);
 	}
-	kvm_inject_undefined(vcpu);
+
 	return 1;
 }
 
-- 
2.9.0
