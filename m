From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 4/6] kvm-all: set KVM_MEM_INCOHERENT
Date: Fri,  6 Mar 2015 13:53:36 -0500
Message-ID: <1425668018-3649-5-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425668018-3649-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 872C74800A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bu9m-BJWPNOO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:47:42 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF9CE48024
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:42 -0500 (EST)
In-Reply-To: <1425668018-3649-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 kvm-all.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kvm-all.c b/kvm-all.c
index 507fa7204e062..924b4a0bec21c 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -305,6 +305,9 @@ static int kvm_mem_flags(MemoryRegion *mr)
     if (readonly && kvm_readonly_mem_allowed) {
         flags |= KVM_MEM_READONLY;
     }
+    if (memory_region_has_incoherent_cache(mr)) {
+        flags |= KVM_MEM_INCOHERENT;
+    }
     return flags;
 }
 
-- 
1.8.3.1
