From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 05/10] KVM: arm/arm64: vgic-its: Save the collection table before device tables
Date: Mon, 23 Oct 2017 16:08:24 +0200
Message-ID: <1508767709-15256-6-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Currently the ITS caches are not emptied on reset.

After a reset, in case we attempt to save the state before
the bound devices have registered their MSIs and after the
1st level table has been allocated by the ITS driver
(device BASER is valid), the first level entries are still
invalid. If the device cache is not empty (devices registered
before the reset), vgic_its_save_device_tables fails.

This failure has no consequence as those devices do not
deserve to be saved: they correspond to the state before
the reset.

However the ITS driver already sent MAPC for collections
and those need to be saved. With the current code, they
will not and the restored guest will not work properly.

So this patch saves collection tables  before device tables.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

candidate to be CC'ed stable
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index b6650c2..8472417 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2324,11 +2324,11 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
 		return -EBUSY;
 	}
 
-	ret = vgic_its_save_device_tables(its);
+	ret = vgic_its_save_collection_table(its);
 	if (ret)
 		goto out;
 
-	ret = vgic_its_save_collection_table(its);
+	ret = vgic_its_save_device_tables(its);
 
 out:
 	unlock_all_vcpus(kvm);
-- 
2.5.5
