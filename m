From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 2/9] KVM: arm/arm64: vgic-its: Fix
 vgic_its_restore_collection_table returned value
Date: Thu, 26 Oct 2017 17:23:04 +0200
Message-ID: <1509031391-4407-3-git-send-email-eric.auger@redhat.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E228349D36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 11:22:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gH4w10sYnzwf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Oct 2017 11:22:16 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4924B49D19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 11:22:16 -0400 (EDT)
In-Reply-To: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

vgic_its_restore_cte returns +1 if the collection table entry
is valid and properly decoded. As a consequence, if the
collection table is fully filled with valid data that are
decoded without error, vgic_its_restore_collection_table()
returns +1. This is wrong.

Let's return 0 in that case.

Fixes: ea1ad53e1e31a3 (KVM: arm64: vgic-its: Collection table save/restore)
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v5 -> v6:
- use the same trick as vgic_its_restore_itt and
  vgic_its_restore_device_tables

v4 -> v5:
- added Christoffer R-b

v2 -> v3: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d27a301..8230ffe 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2268,6 +2268,10 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 		gpa += cte_esz;
 		read += cte_esz;
 	}
+
+	if (ret > 0)
+		return 0;
+
 	return ret;
 }
 
-- 
2.5.5
