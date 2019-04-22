Return-Path: <SRS0=1O2p=SY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797D6C10F11
	for <kvmarm@archiver.kernel.org>; Mon, 22 Apr 2019 19:47:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F265C21906
	for <kvmarm@archiver.kernel.org>; Mon, 22 Apr 2019 19:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1/C1rA7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F265C21906
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B12BE4A4C5;
	Mon, 22 Apr 2019 15:47:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 27mEljDOH1cS; Mon, 22 Apr 2019 15:47:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DED54A486;
	Mon, 22 Apr 2019 15:47:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8671F4A47E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:47:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HZzZ93uq9UJh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Apr 2019 15:47:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 393264A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:47:42 -0400 (EDT)
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
 [73.47.72.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 93C1421902;
 Mon, 22 Apr 2019 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1555962461;
 bh=kKSg9CKcEJ+JF+KJ8Z7C0kIhnyeUyt4CjM1tQIH4960=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=O1/C1rA7KeOCQ/sK1g3TCnxxQzB80/ItoeytpcyxQ8FIu4tcsSx06LNfO6VAzYN2b
 WcjNLizmpYhTPzuy3twsCxRvcDH6+fDpC78aB9/8d1p6Ai61U4dhWPJnVBunGmN6Ml
 QVk1w3j2jIIfqJP2lFTB/lUiQX/Vrjyd+FpX8XdI=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/43] KVM: arm/arm64: vgic-its: Take the srcu
 lock when parsing the memslots
Date: Mon, 22 Apr 2019 15:46:53 -0400
Message-Id: <20190422194727.12495-9-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422194727.12495-1-sashal@kernel.org>
References: <20190422194727.12495-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Marc Zyngier <marc.zyngier@arm.com>, Sasha Levin <sashal@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190422194653.ZsYp_6pgPLCoDjeQlOJ2MiEkx-B-my6MjZOvdhZkFbs@z>

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 7494cec6cb3ba7385a6a223b81906384f15aae34 ]

Calling kvm_is_visible_gfn() implies that we're parsing the memslots,
and doing this without the srcu lock is frown upon:

[12704.164532] =============================
[12704.164544] WARNING: suspicious RCU usage
[12704.164560] 5.1.0-rc1-00008-g600025238f51-dirty #16 Tainted: G        W
[12704.164573] -----------------------------
[12704.164589] ./include/linux/kvm_host.h:605 suspicious rcu_dereference_check() usage!
[12704.164602] other info that might help us debug this:
[12704.164616] rcu_scheduler_active = 2, debug_locks = 1
[12704.164631] 6 locks held by qemu-system-aar/13968:
[12704.164644]  #0: 000000007ebdae4f (&kvm->lock){+.+.}, at: vgic_its_set_attr+0x244/0x3a0
[12704.164691]  #1: 000000007d751022 (&its->its_lock){+.+.}, at: vgic_its_set_attr+0x250/0x3a0
[12704.164726]  #2: 00000000219d2706 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164761]  #3: 00000000a760aecd (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164794]  #4: 000000000ef8e31d (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164827]  #5: 000000007a872093 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164861] stack backtrace:
[12704.164878] CPU: 2 PID: 13968 Comm: qemu-system-aar Tainted: G        W         5.1.0-rc1-00008-g600025238f51-dirty #16
[12704.164887] Hardware name: rockchip evb_rk3399/evb_rk3399, BIOS 2019.04-rc3-00124-g2feec69fb1 03/15/2019
[12704.164896] Call trace:
[12704.164910]  dump_backtrace+0x0/0x138
[12704.164920]  show_stack+0x24/0x30
[12704.164934]  dump_stack+0xbc/0x104
[12704.164946]  lockdep_rcu_suspicious+0xcc/0x110
[12704.164958]  gfn_to_memslot+0x174/0x190
[12704.164969]  kvm_is_visible_gfn+0x28/0x70
[12704.164980]  vgic_its_check_id.isra.0+0xec/0x1e8
[12704.164991]  vgic_its_save_tables_v0+0x1ac/0x330
[12704.165001]  vgic_its_set_attr+0x298/0x3a0
[12704.165012]  kvm_device_ioctl_attr+0x9c/0xd8
[12704.165022]  kvm_device_ioctl+0x8c/0xf8
[12704.165035]  do_vfs_ioctl+0xc8/0x960
[12704.165045]  ksys_ioctl+0x8c/0xa0
[12704.165055]  __arm64_sys_ioctl+0x28/0x38
[12704.165067]  el0_svc_common+0xd8/0x138
[12704.165078]  el0_svc_handler+0x38/0x78
[12704.165089]  el0_svc+0x8/0xc

Make sure the lock is taken when doing this.

Fixes: bf308242ab98 ("KVM: arm/arm64: VGIC/ITS: protect kvm_read_guest() calls with SRCU lock")
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d72b8481f250..dc06f5e40041 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -704,8 +704,9 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
 	int esz = GITS_BASER_ENTRY_SIZE(baser);
-	int index;
+	int index, idx;
 	gfn_t gfn;
+	bool ret;
 
 	switch (type) {
 	case GITS_BASER_TYPE_DEVICE:
@@ -732,7 +733,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 		if (eaddr)
 			*eaddr = addr;
-		return kvm_is_visible_gfn(its->dev->kvm, gfn);
+
+		goto out;
 	}
 
 	/* calculate and check the index into the 1st level */
@@ -766,7 +768,12 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 	if (eaddr)
 		*eaddr = indirect_ptr;
-	return kvm_is_visible_gfn(its->dev->kvm, gfn);
+
+out:
+	idx = srcu_read_lock(&its->dev->kvm->srcu);
+	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
+	srcu_read_unlock(&its->dev->kvm->srcu, idx);
+	return ret;
 }
 
 static int vgic_its_alloc_collection(struct vgic_its *its,
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
