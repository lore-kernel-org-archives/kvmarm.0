Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AC52F3C26
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 03:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770607559; cv=none; b=oCZzaQzhr4QLmd/ynNF2QxjJJkvyXUA/+tm1t85oyY87MqmuySj6Zbl+87grAWldeQk73928AiBt6pOuLGmQ3nDyH85AlFBxQzpRLlowJ7R+3MaoMNTtJ2zMParHixQgIRmMpKvqHFv03ljjfBwX8UYUPGM+DI6pe1qTBWYKUCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770607559; c=relaxed/simple;
	bh=wQ8zNZWo3gNmUfdFdYur75h1ZgtxxKDdEWMpmF72LKo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hGPilRauxDPD498h9nGKUCzTVDJOi4xqek+xtw+qiIfMNaOGTwi7jQAoCjBbS27kr9kXTDJ0am46CdIK2J4xQHSXPbOuEYm5SjcBIa1e7h1RnCQkshugxstI3o7bSyKMekv0/CE8D9lm1j6URzQ5r8sD/cBmxYwKe7VPZOU8M3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=HEwH8cDb; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HEwH8cDb"
X-UUID: 074ef5fa056711f1b7fc4fdb8733b2bc-20260209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=zdf80m6iia5xIhe9PY6XN+0habe8icFkZYue+zSTHR4=;
	b=HEwH8cDbsOEpF/LN5SZZNb0dhhP5j4F8rudHNj7qN21UmKhw/aN7zx0XxxVhUM74aK3D8SJ0AcAK3dmu5rS9nbQpDY7VH+QdeeJqYAV2dF3yG3maF6Vu6gNcMCsGiXl1FtH3BwuUWLvX/1tCI3rgN2N1+/BbR8UjyhFRcZVKLqo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:cca227dd-88a4-49cf-9210-dcb310f6e288,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:59cd79f0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 074ef5fa056711f1b7fc4fdb8733b2bc-20260209
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <kyle-jk.liao@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1852136951; Mon, 09 Feb 2026 11:25:48 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Feb 2026 11:25:47 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 9 Feb 2026 11:25:47 +0800
From: <kyle-jk.liao@mediatek.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey
 Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Quentin
 Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
CC: <wsd_upstream@mediatek.com>, <rock.yeh@mediatek.com>,
	<hungwen.chien@mediatek.com>, kyle-jk.liao <kyle-jk.liao@mediatek.com>
Subject: [PATCH] KVM: arm64: Allow module-owned pages in host stage-2 range adjustment
Date: Mon, 9 Feb 2026 11:24:13 +0800
Message-ID: <20260209032421.1278325-1-kyle-jk.liao@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: "kyle-jk.liao" <kyle-jk.liao@mediatek.com>

The host_stage2_adjust_range() function triggers a WARN_ON when
encountering pages marked as both PKVM_NOPAGE and PKVM_MODULE_OWNED_PAGE.
This occurs when load_unaligned_zeropad() accesses memory that crosses
page boundaries, where one of the pages is module-owned.

Extend the check to accept pages with the PKVM_MODULE_OWNED_PAGE flag
in addition to PKVM_NOPAGE, preventing spurious warnings during normal
module memory access patterns.

Signed-off-by: kyle-jk.liao <kyle-jk.liao@mediatek.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 49db32f3ddf7..baaabf4b5112 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -495,6 +495,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	u64 granule;
 	s8 level;
 	int ret;
+	enum pkvm_page_state state;
 
 	hyp_assert_lock_held(&host_mmu.lock);
 	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level);
@@ -505,8 +506,9 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		return -EAGAIN;
 
 	if (pte) {
+		state = get_host_state(hyp_phys_to_page(addr));
 		WARN_ON(addr_is_memory(addr) &&
-			get_host_state(hyp_phys_to_page(addr)) != PKVM_NOPAGE);
+			(state != PKVM_NOPAGE && state != (PKVM_NOPAGE | PKVM_MODULE_OWNED_PAGE)));
 		return -EPERM;
 	}
 
-- 
2.45.2

