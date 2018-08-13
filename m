From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/37] KVM: arm64: vgic-its: Remove VLA usage
Date: Mon, 13 Aug 2018 15:57:27 +0100
Message-ID: <20180813145755.16566-10-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F27A04A1D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aUhd1dXcNlo1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C40CD4A21C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:18 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Kees Cook <keescook@chromium.org>

In the quest to remove all stack VLA usage from the kernel[1], this
switches to using a maximum size and adds sanity checks. Additionally
cleans up some of the int-vs-u32 usage and adds additional bounds checking.
As it currently stands, this will always be 8 bytes until the ABI changes.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Kees Cook <keescook@chromium.org>
[maz: dropped WARN_ONs]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4ed79c939fb4..1d88010f6b61 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -168,8 +168,14 @@ struct vgic_its_abi {
 	int (*commit)(struct vgic_its *its);
 };
 
+#define ABI_0_ESZ	8
+#define ESZ_MAX		ABI_0_ESZ
+
 static const struct vgic_its_abi its_table_abi_versions[] = {
-	[0] = {.cte_esz = 8, .dte_esz = 8, .ite_esz = 8,
+	[0] = {
+	 .cte_esz = ABI_0_ESZ,
+	 .dte_esz = ABI_0_ESZ,
+	 .ite_esz = ABI_0_ESZ,
 	 .save_tables = vgic_its_save_tables_v0,
 	 .restore_tables = vgic_its_restore_tables_v0,
 	 .commit = vgic_its_commit_v0,
@@ -183,7 +189,7 @@ inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
 	return &its_table_abi_versions[its->abi_rev];
 }
 
-int vgic_its_set_abi(struct vgic_its *its, int rev)
+static int vgic_its_set_abi(struct vgic_its *its, u32 rev)
 {
 	const struct vgic_its_abi *abi;
 
@@ -1881,14 +1887,14 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
  * Return: < 0 on error, 0 if last element was identified, 1 otherwise
  * (the last element may not be found on second level tables)
  */
-static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
+static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 			  int start_id, entry_fn_t fn, void *opaque)
 {
 	struct kvm *kvm = its->dev->kvm;
 	unsigned long len = size;
 	int id = start_id;
 	gpa_t gpa = base;
-	char entry[esz];
+	char entry[ESZ_MAX];
 	int ret;
 
 	memset(entry, 0, esz);
-- 
2.18.0
