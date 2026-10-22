Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=50.112.246.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792691315;
	b=qr38vut+8igHmkmoxpbjZyCW82JXmUmd+7m7gyMYEHmtM9ycAVOnHgXMwXMIN8xaJFRR
	 +2PIn+PAzzcnIix2nTqc53PXR1SurvtDJ1RLE/08b4uLrSQdBT5FdvfCPv4dJ28itgazF
	 W0vWSW66TJphT0YK3xK2Swq8p6yeOk5rhdB7pf8CisqUQLAhMInRtGO3cB1nBffQmfa8V
	 SJU8yQAuzP4HFYGUgVVeYs6KQXoOji7y0WGW+vLg0eDRBWEsKRs58+TPhzw+F/a42oLPe
	 1FQ1gilHOMXVSOPn5fM4B1YIqyKNh1UL7PH1QThQqkKOTyEyADt+kj+nrJ8A3nXsNVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691315;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=f9i8wkFVwMHQ4SaJgNQsC2mhEDqyv5B2iC1yR23KMbU=;
	b=pGdp2OvOzT13m/hthhvcPEaPA/B3KhzmcqGzg0+7KGUMwe/9hxQGX/qpqDgrbTrH9F9w
	 iWymAqXHJzS6aTNTJvrBtLGgdEL2tYWg5wq65lW8Ykm2XP0CyGB2eNRfKROfKlwLFt7LJ
	 5nEuv3IqW0MWKqm9OENSsVManWcbdelfHgHJa0eB2cBAupEAIFI874cbUD9n4sCaQzTVS
	 sdSBUYGN51JqaC2KqsnahZjR2IAfX0QodhhATc5A2ddO167LQ6IO1odsy9NgSwRsYF10V
	 bi5RaOOSg8PSiSAT8fgIxzz2Nf76tbdc9whukQ9odCcUAGVFObuDcNPX18AjDhwf0ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=DkmBDjP+;
	arc=none smtp.remote-ip=50.112.246.219
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3855B606A31E
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3855B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=DkmBDjP+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1792691314; x=1824227314;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f9i8wkFVwMHQ4SaJgNQsC2mhEDqyv5B2iC1yR23KMbU=;
  b=DkmBDjP+IVRlscHK/RGObZabJCfmoDv9SDyl4D+bb429D1ZixGKSoYCR
   +6pT4bIff1UqI0s06H7qEXX6U6HqtGJ0SbZ9lKyS8WOZJXU8hdsXlNz8c
   ZQ/y/lp6nZpoVpGqhhKsbkUh9iRx7S9T4xP8bZM+4PrIwU3ry7ym2eLpY
   D0saCbzSsWqjPS71kq9JPvkvMlm/Fgen5oX0TKnYFUADEsycd2V7Y1c6E
   x0Vn4wcsGss/TvkzTKXgvoB4MxjfjWn65boZulih8xjEA9SIjMYcilU+7
   6GB2GNI6ClIEx5yhWliOU0rGXEGAxkICclA0RrZevSK/glLEdi9dAcKre
   w==;
X-CSE-ConnectionGUID: RQZi2DGsSYa+ml+jqpMlvg==
X-CSE-MsgGUID: yTyMOonyS6GQr5ore6opzg==
X-IronPort-AV: E=Sophos;i="6.27,172,1787011200"; 
   d="scan'208";a="31764559"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 17:48:33 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:1871]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.86:2525] with esmtp (Farcaster)
 id 4c96b239-c80a-43e4-9e2a-b476f8e81ec6; Thu, 22 Oct 2026 17:48:33 +0000 (UTC)
X-Farcaster-Flow-ID: 4c96b239-c80a-43e4-9e2a-b476f8e81ec6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 22 Oct 2026 17:48:33 +0000
Received: from dev-dsk-aarnahmd-2a-95203392.us-west-2.amazon.com
 (172.19.38.251) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Thu, 22 Oct 2026
 17:48:32 +0000
From: Aaron Ahmed <aarnahmd@amazon.com>
To: <stable@vger.kernel.org>
CC: <maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<fuad.tabba@linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5.15.y] KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save
Date: Thu, 22 Oct 2026 17:45:37 +0000
Message-ID: <20261022174537.2767-2-aarnahmd@amazon.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit c6c156d931c33b92362383cf76f6d6e1291dcbfe ]

MAPC with V=0 drops ite->collection but leaves the ITE on the device's
ITT list, and vgic_its_save_ite() dereferences it unconditionally. A
guest that issues MAPD, MAPTI and then MAPC(V=0) therefore oopses the
host when the VMM issues KVM_DEV_ARM_ITS_SAVE_TABLES to migrate it.
That sequence is UNPREDICTABLE per the architecture, but KVM already
handles the resulting state in the translate, MOVI and DISCARD paths.

Save a zeroed entry, which vgic_its_restore_ite() reads back as
invalid. Skipping the ITE instead would leave the ITT slot holding
whatever is in guest memory, and restore rejects an entry naming a
collection the restored collection table does not have.

Fixes: eff484e0298da ("KVM: arm64: vgic-its: ITT save and restore")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260807104102.2410744-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
[aarnahmd: Upstream vgic_its_write_entry_lock() takes in the kind of table
 entry (ite) and looks up its size, while 5.15 takes in the size of an ite
 directly via ite_esz, because commit 3b2c81d5feb2 ("KVM: arm64: vgic-its:
 Add stronger type-checking to the ITS entry sizes") is not in 5.15.]
Signed-off-by: Aaron Ahmed <aarnahmd@amazon.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 054aec8a72e35..e6ed23b14623f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2151,6 +2151,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	u32 next_offset;
 	u64 val;
 
+	/*
+	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
+	 * and with it the ICID. Save a zeroed entry, which the restore path
+	 * reads back as invalid.
+	 */
+	if (!ite->collection)
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite_esz);
+
 	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
 	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
-- 
2.47.3

