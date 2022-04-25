Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101A4C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 18:55:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9A584B1A9;
	Mon, 25 Apr 2022 14:55:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rX+qgHTvZ+Lx; Mon, 25 Apr 2022 14:55:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 611C94B218;
	Mon, 25 Apr 2022 14:55:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E6849F21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ynF+3xFaIAkd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 14:55:43 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13D1F4B17B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:43 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 b20-20020a62a114000000b0050a6280e374so10870861pff.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dEuOZy5F/RHIH6k3dlY2bs3M+qjUMNXUfNeA0Gux4fw=;
 b=WYYcygI0JnzrOij9OnRfKLDoDDOJyC+QKlHmplgmvcnSyRhR5U2coTCwDWEUCY5Xnb
 usolFiXQT72Y6/adDmfwhZMJPAj3TGBqEXITJW/+tLwpAaT/IbcxZRHEigg6ZtnlO6EN
 qXQuG1uqINcVMU+z6vJ8IljyRZwv68zB8+tr8nUa/tVrRlesOuf1vr/cmXlNUVV9P0Uj
 CH0PWSEWBaeDTyKKjtH7a25NDIfaDtfyQQZmX5veIXsw1llQ/XVu/HiHA3qQCR5oUKHc
 pycVC0moGz0+c8w9iTwNb7dVeEwY1LhqlCk/nsqt1RbPMaCB3/BTFOKmThCQdtE+PaYG
 edzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dEuOZy5F/RHIH6k3dlY2bs3M+qjUMNXUfNeA0Gux4fw=;
 b=AdXFrspDFAsbiaG23Db4C077VrZ07hxY1sL+Dyp2qVlHB1dX++0YvT5N6HQ3dccA8e
 UB4Ez2CkLYvB79NOYVMLODCt1ml3A/nm4Z7JrWhFUZbSofsVuWy8Ycbbpu4oVDdi9Gve
 nnrBZwIRJ/b7Cd5l1p44reb0/RFyFmqeDjviPBzc657TXUUFADVgNmTX8tiT8D3uJYvc
 0BBmHtTg3ZUX8KqORoV4vZrjdnyhX6cpcAnQgPA84vfeOYK1DGv9OcX6Z/+UUM1r7jne
 pgFLSZRlIUuqilNOjEEk31mpD81PEQkh5zL/Kpmo7MXHbJYsdZnlGu57Mz7Wz+anxSq0
 gPiw==
X-Gm-Message-State: AOAM533cw3r4qvK2RxPeJvapi7PQb80iIncid488vC74//Pgdhv9vTWZ
 j094ECHWttavtPUtgG3FerBJ/AgkDl0wLA==
X-Google-Smtp-Source: ABdhPJzulkhUWdOTSDkMAj6C6yM2yo9uaoIL2BnvYG2QurPMF/tNYPoc0CucL0doRxnyFoRfi4ntRJ7uENgp7w==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP
 id k5-20020a17090a910500b001d29e987e1emr1602476pjo.0.1650912941792; Mon, 25
 Apr 2022 11:55:41 -0700 (PDT)
Date: Mon, 25 Apr 2022 11:55:33 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 3/4] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte
 failures
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Restoring a corrupted collection entry is being ignored: a
vgic_its_restore_cte failure is treated as success by
vgic_its_restore_collection_table.  vgic_its_restore_cte uses a positive
number to return ITS error codes, and +1 to return success.  The caller
then uses "ret > 0" to check for success. An additional issue is that
invalid entries return 0 and although that doesn't fail the restore, it
leads to skipping all the next entries.

Fix this by having vgic_its_restore_cte return negative numbers on
error, and 0 on success (which includes skipping an invalid entry).
While doing that, also fix alloc_collection return codes to not mix ITS
error codes (positive numbers) and generic error codes (negative
numbers).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index dfd73fa1ed43..4ece649e2493 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1013,9 +1013,6 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
-		return E_ITS_MAPC_COLLECTION_OOR;
-
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
 	if (!collection)
 		return -ENOMEM;
@@ -1112,7 +1109,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	collection = find_collection(its, coll_id);
 	if (!collection) {
-		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		int ret;
+
+		if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+			return E_ITS_MAPC_COLLECTION_OOR;
+
+		ret = vgic_its_alloc_collection(its, &collection, coll_id);
 		if (ret)
 			return ret;
 		new_coll = collection;
@@ -1267,6 +1269,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 		if (!collection) {
 			int ret;
 
+			if (!vgic_its_check_id(its, its->baser_coll_table,
+						coll_id, NULL))
+				return E_ITS_MAPC_COLLECTION_OOR;
+
 			ret = vgic_its_alloc_collection(its, &collection,
 							coll_id);
 			if (ret)
@@ -2508,6 +2514,10 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
+/*
+ * Restores a collection entry into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 {
 	struct its_collection *collection;
@@ -2522,7 +2532,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 		return ret;
 	val = le64_to_cpu(val);
 	if (!(val & KVM_ITS_CTE_VALID_MASK))
-		return 0;
+		return 0; /* invalid entry, skip it */
 
 	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
 	coll_id = val & KVM_ITS_CTE_ICID_MASK;
@@ -2534,11 +2544,15 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	collection = find_collection(its, coll_id);
 	if (collection)
 		return -EEXIST;
+
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+		return -EINVAL;
+
 	ret = vgic_its_alloc_collection(its, &collection, coll_id);
 	if (ret)
 		return ret;
 	collection->target_addr = target_addr;
-	return 1;
+	return 0;
 }
 
 /**
@@ -2604,15 +2618,12 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 
 	while (read < max_size) {
 		ret = vgic_its_restore_cte(its, gpa, cte_esz);
-		if (ret <= 0)
+		if (ret < 0)
 			break;
 		gpa += cte_esz;
 		read += cte_esz;
 	}
 
-	if (ret > 0)
-		return 0;
-
 	return ret;
 }
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
