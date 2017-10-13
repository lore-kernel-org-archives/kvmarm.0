From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2] KVM: arm64: its: Fix missing dynamic allocation check in
 scan_its_table
Date: Fri, 13 Oct 2017 15:17:34 +0200
Message-ID: <20171013131734.16485-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5753B49D35
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 09:16:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z2pl7zz7oei8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 09:16:47 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E57C49D2A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 09:16:47 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id u138so21859051wmu.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 06:17:34 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently allocate an entry dynamically, but we never check if the
allocation actually succeeded.  We actually don't need a dynamic
allocation, because we know the maximum size of an ITS table entry, so
we can simply use an allocation on the stack.

Cc: <stable@vger.kernel.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f51c1e1..1d2668b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1801,37 +1801,33 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
 static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 			  int start_id, entry_fn_t fn, void *opaque)
 {
-	void *entry = kzalloc(esz, GFP_KERNEL);
 	struct kvm *kvm = its->dev->kvm;
 	unsigned long len = size;
 	int id = start_id;
 	gpa_t gpa = base;
+	char entry[esz]
 	int ret;
 
+	memset(entry, 0, esz);
+
 	while (len > 0) {
 		int next_offset;
 		size_t byte_offset;
 
 		ret = kvm_read_guest(kvm, gpa, entry, esz);
 		if (ret)
-			goto out;
+			return ret;
 
 		next_offset = fn(its, id, entry, opaque);
-		if (next_offset <= 0) {
-			ret = next_offset;
-			goto out;
-		}
+		if (next_offset <= 0)
+			return next_offset;
 
 		byte_offset = next_offset * esz;
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;
 	}
-	ret =  1;
-
-out:
-	kfree(entry);
-	return ret;
+	return 1;
 }
 
 /**
-- 
2.9.0
