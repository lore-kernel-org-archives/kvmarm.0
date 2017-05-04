From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 13/24] KVM: arm64: vgic-its: Check the device id matches
 TYPER DEVBITS range
Date: Thu,  4 May 2017 13:44:33 +0200
Message-ID: <1493898284-29504-14-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D837540AF9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:43:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ZOafqJ3HuWQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 07:43:06 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0063940966
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:43:06 -0400 (EDT)
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On MAPD we currently check the device id can be stored in the device table.
Let's first check it can be encoded within the range defined by TYPER
DEVBITS.

Also check the collection ID belongs to the 16 bit range as GITS_TYPER
CIL field equals to 0.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5:
- use GIC_ENCODE_SZ macro

v3 -> v4:
- VITS_TYPER_DEVBITS set to 16 for homogeneity
- use BIT_ULL
---
 virt/kvm/arm/vgic/vgic-its.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 6da548d..e7bb86a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -204,6 +204,7 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 #define GIC_LPI_OFFSET 8192
 
 #define VITS_TYPER_IDBITS 16
+#define VITS_TYPER_DEVBITS 16
 
 /*
  * Finds and returns a collection in the ITS collection table.
@@ -404,7 +405,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
 	 * To avoid memory waste in the guest, we keep the number of IDBits and
 	 * DevBits low - as least for the time being.
 	 */
-	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
+	reg |= GIC_ENCODE_SZ(VITS_TYPER_DEVBITS, 5) << GITS_TYPER_DEVBITS_SHIFT;
 	reg |= GIC_ENCODE_SZ(VITS_TYPER_IDBITS, 5) << GITS_TYPER_IDBITS_SHIFT;
 	reg |= GIC_ENCODE_SZ(abi->ite_esz, 4) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
 
@@ -646,16 +647,30 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
  * Check whether an ID can be stored into the corresponding guest table.
  * For a direct table this is pretty easy, but gets a bit nasty for
  * indirect tables. We check whether the resulting guest physical address
- * is actually valid (covered by a memslot and guest accessbible).
+ * is actually valid (covered by a memslot and guest accessible).
  * For this we have to read the respective first level entry.
  */
-static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
+static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
 {
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
+	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
+	int esz = GITS_BASER_ENTRY_SIZE(baser);
 	int index;
-	u64 indirect_ptr;
 	gfn_t gfn;
-	int esz = GITS_BASER_ENTRY_SIZE(baser);
+
+	switch (type) {
+	case GITS_BASER_TYPE_DEVICE:
+		if (id >= BIT_ULL(VITS_TYPER_DEVBITS))
+			return false;
+		break;
+	case GITS_BASER_TYPE_COLLECTION:
+		/* as GITS_TYPER.CID == 0, ITS supports 16-bit collection ID */
+		if (id >= BIT_ULL(16))
+			return false;
+		break;
+	default:
+		return false;
+	}
 
 	if (!(baser & GITS_BASER_INDIRECT)) {
 		phys_addr_t addr;
-- 
2.5.5
