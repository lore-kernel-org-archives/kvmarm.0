From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 07/11] KVM: arm/arm64: vgic-its: Always attempt to
 save/restore device and collection tables
Date: Mon, 16 Oct 2017 17:03:28 +0200
Message-ID: <1508166212-9599-8-git-send-email-eric.auger@redhat.com>
References: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A22341185
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:03:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qsmAMuizCc9l for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 11:03:21 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58B1749D4A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:03:21 -0400 (EDT)
In-Reply-To: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
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

In case the device table save fails, we currently do not
attempt to save the collection table. However it may
happen that the device table fails because the structures
in memory are inconsistent with device GITS_BASER however
this does not mean collection backup can't and shouldn't
be performed. Same must happen on restore path.

Without this patch, after a reset and early state backup,
the device table restore may fail due to L1 entry not valid.
If we don't restore the collection table the guest does
not reboot properly.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

candidate to be CC'ed stable
---
 virt/kvm/arm/vgic/vgic-its.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 0031d57..3c2a6e7 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2379,12 +2379,9 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
 	}
 
 	ret = vgic_its_save_device_tables(its);
-	if (ret)
-		goto out;
 
-	ret = vgic_its_save_collection_table(its);
+	ret |= vgic_its_save_collection_table(its);
 
-out:
 	unlock_all_vcpus(kvm);
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->lock);
@@ -2411,11 +2408,9 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
 	}
 
 	ret = vgic_its_restore_collection_table(its);
-	if (ret)
-		goto out;
 
-	ret = vgic_its_restore_device_tables(its);
-out:
+	ret |= vgic_its_restore_device_tables(its);
+
 	unlock_all_vcpus(kvm);
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->lock);
-- 
2.5.5
