From: lantianyu1986@gmail.com
Subject: [PATCH 7/11] KVM: Remove redundant check in the
 kvm_get_dirty_log_protect()
Date: Fri,  4 Jan 2019 16:54:01 +0800
Message-ID: <20190104085405.40356-8-Tianyu.Lan@microsoft.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B544A3B2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WkG6oQurVkyW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jan 2019 03:55:13 -0500 (EST)
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C8EA4A3AF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:13 -0500 (EST)
Received: by mail-pg1-f196.google.com with SMTP id w7so17207670pgp.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jan 2019 00:55:13 -0800 (PST)
In-Reply-To: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

The dirty bits have already been checked in the previous check of
"dirty_bitmap" and mask must be non-zero value at this point.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 virt/kvm/kvm_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf7cc0554094..e75dbb15fd09 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1206,11 +1206,9 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 			mask = xchg(&dirty_bitmap[i], 0);
 			dirty_bitmap_buffer[i] = mask;
 
-			if (mask) {
-				offset = i * BITS_PER_LONG;
-				kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
-									offset, mask);
-			}
+			offset = i * BITS_PER_LONG;
+			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
+								offset, mask);
 		}
 		spin_unlock(&kvm->mmu_lock);
 	}
-- 
2.14.4
