From: Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC 11/15] arm/arm64: ITS: create device
Date: Mon,  5 Dec 2016 22:46:42 +0100
Message-ID: <1480974406-29345-12-git-send-email-eric.auger@redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 596984027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hJWNMOza1kNV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 16:46:48 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69957401F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:48 -0500 (EST)
In-Reply-To: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce an helper function that registers a new device candidate to
send MSIs on the ITS. The device is characterized by its device id,
the number of event ids. This dimensions the associated interrupt
translation table (ITT), allocated by this function.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h | 11 +++++++++++
 lib/arm/gic-v3-its.c     | 28 ++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index b73736c..31589d6 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -124,6 +124,8 @@
 
 #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
 
+#define GITS_MAX_DEVICES		8
+
 struct its_baser {
 	unsigned int index;
 	int type;
@@ -154,6 +156,12 @@ struct its_typer {
 	bool virt_lpi;
 };
 
+struct its_device {
+	u32 device_id;
+	u32 nr_ites;
+	void *itt;
+};
+
 struct its_collection {
 	u64 target_address;
 	u16 col_id;
@@ -164,9 +172,11 @@ struct its_data {
 	struct its_cmd_block *cmd_base;
 	struct its_cmd_block *cmd_write;
 	struct its_cmd_block *cmd_readr;
+	struct its_device devices[GITS_MAX_DEVICES];
 	struct its_baser baser[GITS_BASER_NR_REGS];
 	struct its_typer typer;
 	struct its_collection *collections;
+	u32 nb_devices;
 	u64 flags;
 };
 
@@ -179,6 +189,7 @@ extern int its_parse_baser(int i, struct its_baser *baser);
 extern void its_setup_baser(int i, struct its_baser *baser);
 extern void enable_lpi(u32 redist);
 extern void its_enable_defaults(void);
+extern struct its_device *its_create_device(u32 dev_id, int nvecs);
 
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index ecb8f98..c230959 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -80,6 +80,19 @@ int its_parse_baser(int i, struct its_baser *baser)
 	return 0;
 }
 
+static struct its_baser *its_lookup_baser(int type)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		struct its_baser *baser = &its_data.baser[i];
+
+		if (baser->type == type)
+			return baser;
+	}
+	return NULL;
+}
+
 void its_setup_baser(int i, struct its_baser *baser)
 {
 	void *reg_addr = gicv3_its_base() + GITS_BASER + i * 8;
@@ -258,3 +271,18 @@ void its_enable_defaults(void)
 
 	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
 }
+
+struct its_device *its_create_device(u32 device_id, int nvecs)
+{
+	struct its_device *new = &its_data.devices[its_data.nb_devices];
+	struct its_baser *baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
+
+	if (!baser)
+		return NULL;
+
+	new->device_id = device_id;
+	new->nr_ites = nvecs;
+	new->itt = (void *)phys_zalloc(new->nr_ites * baser->esz);
+	its_data.nb_devices++;
+	return new;
+}
-- 
2.5.5
