From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 22/28] KVM: arm64: Make vcpu const in vcpu_read_sys_reg
Date: Wed, 19 Dec 2018 18:03:43 +0000
Message-ID: <20181219180349.242681-23-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9199D4A373
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mrBUayWwpjTI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D1F4A3B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:11 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
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
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

vcpu_read_sys_reg should not be modifying the VCPU structure.
Eventually, to handle EL2 sysregs for nested virtualization, we will
call vcpu_read_sys_reg from places that have a const vcpu pointer, which
will complain about the lack of the const modifier on the read path.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/sys_regs.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7a5035f9c5c3..c22e50ba3473 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -319,7 +319,7 @@ struct kvm_vcpu_arch {
  */
 #define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
 
-u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg);
+u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
 
 /*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ecbf67ccabf5..965c6f1706d6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -76,7 +76,7 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
+u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	if (!vcpu->arch.sysregs_loaded_on_cpu)
 		goto immediate_read;
-- 
2.19.2
