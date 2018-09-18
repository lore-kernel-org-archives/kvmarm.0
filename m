From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 01/13] kvm: selftests: vcpu_setup: set cr4.osfxsr
Date: Tue, 18 Sep 2018 19:54:24 +0200
Message-ID: <20180918175436.19742-2-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D4449F94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mm92388omtV1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:54:45 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E39D4A20B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:45 -0400 (EDT)
In-Reply-To: <20180918175436.19742-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Guest code may want to call functions that have variable arguments.
To do so, we either need to compile with -mno-sse or enable SSE in
the VCPUs. As it should be pretty safe to turn on the feature, and
-mno-sse would make linking test code with standard libraries
difficult, we choose the feature enabling.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86.c b/tools/testing/selftests/kvm/lib/x86.c
index a3122f1949a8..bb6c65ebfa77 100644
--- a/tools/testing/selftests/kvm/lib/x86.c
+++ b/tools/testing/selftests/kvm/lib/x86.c
@@ -626,7 +626,7 @@ void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
 	switch (vm->mode) {
 	case VM_MODE_FLAT48PG:
 		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
-		sregs.cr4 |= X86_CR4_PAE;
+		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
 		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 		kvm_seg_set_unusable(&sregs.ldt);
-- 
2.17.1
