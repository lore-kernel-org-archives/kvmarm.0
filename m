From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/4] KVM: arm64: Fix order of vcpu_write_sys_reg() arguments
Date: Fri,  4 May 2018 17:15:57 +0100
Message-ID: <20180504161559.22852-3-marc.zyngier@arm.com>
References: <20180504161559.22852-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E04A400D4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:07:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pKdcoOiDj6QR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 12:06:43 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B089449FA9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:06:43 -0400 (EDT)
In-Reply-To: <20180504161559.22852-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Valentin Schneider <valentin.schneider@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: James Morse <james.morse@arm.com>

A typo in kvm_vcpu_set_be()'s call:
| vcpu_write_sys_reg(vcpu, SCTLR_EL1, sctlr)
causes us to use the 32bit register value as an index into the sys_reg[]
array, and sail off the end of the linear map when we try to bring up
big-endian secondaries.

| Unable to handle kernel paging request at virtual address ffff80098b982c00
| Mem abort info:
|  ESR = 0x96000045
|  Exception class = DABT (current EL), IL = 32 bits
|   SET = 0, FnV = 0
|   EA = 0, S1PTW = 0
| Data abort info:
|   ISV = 0, ISS = 0x00000045
|   CM = 0, WnR = 1
| swapper pgtable: 4k pages, 48-bit VAs, pgdp = 000000002ea0571a
| [ffff80098b982c00] pgd=00000009ffff8803, pud=0000000000000000
| Internal error: Oops: 96000045 [#1] PREEMPT SMP
| Modules linked in:
| CPU: 2 PID: 1561 Comm: kvm-vcpu-0 Not tainted 4.17.0-rc3-00001-ga912e2261ca6-dirty #1323
| Hardware name: ARM Juno development board (r1) (DT)
| pstate: 60000005 (nZCv daif -PAN -UAO)
| pc : vcpu_write_sys_reg+0x50/0x134
| lr : vcpu_write_sys_reg+0x50/0x134

| Process kvm-vcpu-0 (pid: 1561, stack limit = 0x000000006df4728b)
| Call trace:
|  vcpu_write_sys_reg+0x50/0x134
|  kvm_psci_vcpu_on+0x14c/0x150
|  kvm_psci_0_2_call+0x244/0x2a4
|  kvm_hvc_call_handler+0x1cc/0x258
|  handle_hvc+0x20/0x3c
|  handle_exit+0x130/0x1ec
|  kvm_arch_vcpu_ioctl_run+0x340/0x614
|  kvm_vcpu_ioctl+0x4d0/0x840
|  do_vfs_ioctl+0xc8/0x8d0
|  ksys_ioctl+0x78/0xa8
|  sys_ioctl+0xc/0x18
|  el0_svc_naked+0x30/0x34
| Code: 73620291 604d00b0 00201891 1ab10194 (957a33f8)
|---[ end trace 4b4a4f9628596602 ]---

Fix the order of the arguments.

Fixes: 8d404c4c24613 ("KVM: arm64: Rewrite system register accessors to read/write functions")
CC: Christoffer Dall <cdall@cs.columbia.edu>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 23b33e8ea03a..1dab3a984608 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -333,7 +333,7 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 	} else {
 		u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 		sctlr |= (1 << 25);
-		vcpu_write_sys_reg(vcpu, SCTLR_EL1, sctlr);
+		vcpu_write_sys_reg(vcpu, sctlr, SCTLR_EL1);
 	}
 }
 
-- 
2.14.2
