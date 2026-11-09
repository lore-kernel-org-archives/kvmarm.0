Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794262416;
	b=P4b8tz65nQ8Su3iL9EfXaP9HGtVRb3PNKzqqQnWNHegmlgMOfrSU9eLe5u5YSacESlns
	 ZOq6mLHfgya2VMxdkf42PzcxHqRxRj6IJxyeDQWQt8SDvGWJmlYN2vxmbRXrW7m1P2iVu
	 YOqAN5tNZwZdB5HQpcVaJW8n1Baxap8wRk7Oycyy34GAWI2PAtjiDt6AmsWP79j1bzd/3
	 +0PExDQm+kVGbP7iie/ZgHomEo0/uNrHP5sZCDUqaxfpcdcdAT1bW35A2xFB/AaPSVB3F
	 zmfDakn55tFbx1bfpSH8EDjsl9es6c+Y3pv++siS+tyxwb95HdWcDdFN6Eg3V1JxCUw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262416;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zMpIc7KG/FgM26D6oZ4QsYgjHL/cVuDmS1tSg0YoPmc=;
	b=iM1TF+wtbTUe3Tfog1r0YAf3bt5tYFZ10eHZA/rglp694PpWlbsC27nj1uzd9hQds2o6
	 EL2ve74X3XROW4Z6DGUzKUCQOzdb6Sadexrj4+WslGc8xvqGs1meP1o8a85La2CvDqWqk
	 S1UDjytxWk6xxlFDKTSTM0iFmEdQ0QM8pHzwnXzHTEExdMHAvh2mawnYYjDuCaagq+G9A
	 HDx8AGo8vs9GHmOWuxqkTlirS0EEkKTd7A1RUDenbemmWyXcz08O/ozZxmAcoqWEzzp4Y
	 9Xhi+UzdFGzsnAIyXjvdGrpSqgiuNSCtn/VVbX96iIy2cAh/53bJ7egtzDunULdj/oQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DfS0M4+Y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16CA606A325;
	Mon,  9 Nov 2026 22:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DfS0M4+Y
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794262415;
	b=pHi84+L54K1Vq4xh+7zc6Z/zTosjXuFBfxduY4GlA03THOSs9Qao2OX18LfcZjBOt1Yh
	 0AE6xShkA69UsvXDt5Gr/Tim2KRMES7SEDl1cz5VylfdHEYtVHp8bpg3oWikvZXdnS8gS
	 bw/6t1X5RXuiQS9ZaxhdLq17lj4GSxm/Wuzhi8uGcPQ27eh1Km+p24tCXyQJvYsqnlZ1x
	 ZwyU+vasbjXBbyg9KYuHa0JmJeQnr8GJqrx7idVABdNsGJ7x4cFZ0kQYBapVd1U5arvRc
	 uuXiC55H8TnGxEz2C6pSRDZxq5Cdqou+/EkZeUumHsma0/cYz4YNnesvZnJDwZxE3zQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794262415;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zMpIc7KG/FgM26D6oZ4QsYgjHL/cVuDmS1tSg0YoPmc=;
	b=hch1pQtPaUevVdJ7SfyCjP4fF/BSL+s4eNQYZkHkuRshVWXXYI28RI6Y7acAMtMGa+y7
	 Pjh3Ruucb2EIWYf6X0eooQEbjPFyPQYNGNq/qNzpy/WNvifLHtT+TgSUGlyaPNODlJPA8
	 5xyUPNvoroeFKLoq+Of/RihR3m+0Md9afZzeH78VfyRKADXJhZtzTaf6kvvy0JYFbn4XK
	 eeIwYZT7rnFZ8glRX1dtJtv46F5D0ZH2NpvySqsLFKOuGeQJRmGknmbPgyrLzSw0FpT8v
	 1Na0NsfXbYnwuQIY51JIo8nrsZixE0uzPkBoeL07gn0e+CXUeMMgt5SuOEWM4SuVTcw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E04ED1F0089F;
	Mon,  9 Nov 2026 22:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794262415;
	bh=zMpIc7KG/FgM26D6oZ4QsYgjHL/cVuDmS1tSg0YoPmc=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=DfS0M4+Y96JLRXbiiIVBdrdhXkBMom5jOJNYVs1CoAgDRtXwW0R548L8MtmegXFRV
	 cnMFlZS7budk8xx3liy5LhO35ZWtb/p2in97zuOa/SDdmsOCer21XmwWk13cDsFYBc
	 X3nSVez1GZeKV/g2y22L98M0AP9Nx2fGnO+fnYzsc0sDHwCMBkq1v62iN7ipzK+yeS
	 BCqjkUUb5YYksCOS+P37B572+A5eBhMo9ayObk/rk8vGezwknoovpNuPJC0rev5LJG
	 m6rGGkXo240S8qtW2lPFa0VOZ2uCwnBYN4M4BMpongm/ns8c+pkAF6hu9CNVbCeQQv
	 03IkJyEZEElmQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3B78E48690;
	Mon,  9 Nov 2026 22:13:34 +0000 (UTC)
From: Xuheng Li via B4 Relay <devnull+xuheng.cs.columbia.edu@kernel.org>
Date: Mon, 09 Nov 2026 22:13:35 +0000
Subject: [PATCH v3] KVM: arm64: Don't replace a valid hyp block mapping
 with a table
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261109-hyp-block-map-v3-1-bd70e67eb0bf@cs.columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwNL3YzKAt2knPzkbN3cxAJdg2RDyzSLVEsTI5MkJaCegqLUtMwKsHn
 RsbW1AAtSsWxfAAAA
X-Change-ID: 20261109-hyp-block-map-0c19f8e9424b
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Quentin Perret <qperret@google.com>, 
 Will Deacon <will@kernel.org>, Mostafa Saleh <smostafa@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Xuheng Li <xuheng@cs.columbia.edu>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794262414; l=3910;
 i=xuheng@cs.columbia.edu; s=20261028; h=from:subject:message-id;
 bh=RIFjoI85KP24Rv3faoa4T6ksq6aQB6AW6n6O+fZ4Jw8=;
 b=j9SVzqCiLPkNYh1JWfLZitE9GNR+YyVV3Ivtx30mdQziJtNsmwtvPjrAxpTl0xi4hvgf6t9DV
 V55yyGreT2AB+KHnSiw9xKu79OZs9NymAKLF9eebBOAkIIPPYE1xU6K
X-Developer-Key: i=xuheng@cs.columbia.edu; a=ed25519;
 pk=L1HVV+goqxYmEMO/OXakL6uf9isSpgk2QrLlFqyZ2Qs=
X-Endpoint-Received: by B4 Relay for xuheng@cs.columbia.edu/20261028 with
 auth_id=1349
X-Original-From: Xuheng Li <xuheng@cs.columbia.edu>
Reply-To: xuheng@cs.columbia.edu
Content-Transfer-Encoding: 7bit

From: Xuheng Li <xuheng@cs.columbia.edu>

When kvm_pgtable_hyp_map() is asked to map part of a range that a valid
block mapping already covers, hyp_map_walker_try_leaf() declines, as the
request cannot be a leaf at the block's level.  hyp_map_walker() then
allocates a zeroed table and stores it over the valid block entry.  The
walk descends into the new table and maps the requested pages, but the
rest of the block is now unmapped, and the valid block was replaced
without break-before-make.

No in-tree caller maps into an existing hyp block mapping today, so this
cannot be triggered in mainline.  Fail such a request with -EEXIST
instead, so that a future caller gets an error rather than silently
losing the rest of the block.

The same check now catches a conflicting remap of an existing leaf, so
drop the WARN_ON() from hyp_map_walker_try_leaf(): every caller checks
the error, and a WARN is fatal at EL2.  Do the check before the
last-level WARN_ON(), which is kept for internal errors, and update the
kernel-doc of kvm_pgtable_hyp_map() to match.

Signed-off-by: Xuheng Li <xuheng@cs.columbia.edu>
---
This is patch 3/3 of v2, sent alone: 1/3 is superseded by Mostafa's
"KVM: arm64: Use consistent type for pool size" [1], and 2/3 is dropped.

With the WARN_ON() gone from hyp_map_walker_try_leaf(), a conflicting
remap through the EL1 path (__create_hyp_mappings()) also returns
-EEXIST without a warning, where it used to warn and return -EINVAL.

[1] https://lore.kernel.org/r/20261106172750.2678873-1-smostafa@google.com
---
Changes in v3:
- Drop the WARN_ON() from the new check and from
  hyp_map_walker_try_leaf(), and update the kernel-doc of
  kvm_pgtable_hyp_map() (Vincent, Fuad).
- Do the check before the last-level WARN_ON(), so that a conflicting
  page-level mapping returns -EEXIST instead of reaching it.
- Link to v2: https://lore.kernel.org/r/20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57cd6..6d6ed8596 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -508,7 +508,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
  * If device attributes are not explicitly requested in @prot, then the
  * mapping will be normal, cacheable. Attempts to install a new mapping
  * for a virtual address that is already mapped will be rejected with an
- * error and a WARN().
+ * error.
  *
  * Return: 0 on success, negative error code on failure.
  */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b1..94a59f29a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -414,7 +414,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 		return true;
 	if (!kvm_pte_valid(ctx->old))
 		ctx->mm_ops->get_page(ctx->ptep);
-	else if (WARN_ON((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
+	else if ((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW)
 		return false;
 
 	smp_store_release(ctx->ptep, new);
@@ -431,6 +431,14 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (hyp_map_walker_try_leaf(ctx, data))
 		return 0;
 
+	/*
+	 * A valid entry here is a leaf that conflicts with the request.
+	 * Replacing a block with a table would need break-before-make, and
+	 * would leave the rest of the block unmapped.
+	 */
+	if (kvm_pte_valid(ctx->old))
+		return -EEXIST;
+
 	if (WARN_ON(ctx->level == KVM_PGTABLE_LAST_LEVEL))
 		return -EINVAL;
 

---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20261109-hyp-block-map-0c19f8e9424b

Best regards,
-- 
Xuheng Li <xuheng@cs.columbia.edu>


