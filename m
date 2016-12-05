From: Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC 12/15] arm/arm64: ITS: create collection
Date: Mon,  5 Dec 2016 22:46:43 +0100
Message-ID: <1480974406-29345-13-git-send-email-eric.auger@redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C87640296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OdYH9jsXn0Nt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 16:46:52 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B94B4027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:52 -0500 (EST)
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

Helper function to create a collection, characterized by its
collection id and the target address. Currently the number of
collections cannot exceed the number of redistributors.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 lib/arm/asm/gic-v3-its.h |  1 +
 lib/arm/gic-v3-its.c     | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 31589d6..af82b32 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -190,6 +190,7 @@ extern void its_setup_baser(int i, struct its_baser *baser);
 extern void enable_lpi(u32 redist);
 extern void its_enable_defaults(void);
 extern struct its_device *its_create_device(u32 dev_id, int nvecs);
+extern struct its_collection *its_create_collection(u32 col_id, u32 target);
 
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index c230959..1b50fc5 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -286,3 +286,20 @@ struct its_device *its_create_device(u32 device_id, int nvecs)
 	its_data.nb_devices++;
 	return new;
 }
+
+struct its_collection *its_create_collection(u32 col_id, u32 pe)
+{
+	if (col_id >= gicv3_data.cpu_count)
+		report_abort("%s coll_id=%d >= cpu_count %d\n",
+			      __func__, col_id, gicv3_data.cpu_count);
+
+	if (its_data.typer.pta)
+		its_data.collections[col_id].target_address =
+			(u64)gicv3_data.redist_base[pe];
+	else
+		its_data.collections[col_id].target_address = pe << 16;
+
+	its_data.collections[col_id].col_id = col_id;
+
+	return &its_data.collections[col_id];
+}
-- 
2.5.5
