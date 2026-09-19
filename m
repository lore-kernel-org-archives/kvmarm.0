Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D79019B5A3
	for <kvmarm@lists.linux.dev>; Sat, 19 Sep 2026 12:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789821118; cv=none; b=lJeTxqe4xTR4fVCQGRUVO/v3QRsAReid5xRch6MNSTvlEXLTEmpxcj99RVlyeyBkEWcWXounbDMTaikek8iDA1cszZMTVTlXotnSG048yR0T/JzyAKrdkyTzGVljZR2Kili0oBEJz6R5PcCeqAQ0oKvUh/jM36lSnZAsggiYq/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789821118; c=relaxed/simple;
	bh=zDx0HMONsBTyORpvpO9cv0W/YE6yg1iuAd0QBuaaG9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2gOHjkWPXEObmPnWQTtj+eGQOGMV9AUAXRjFeIASLFuCUIMiYvmWq1GS7DwZlAhfsAjhz5vgz6agRc3TVYCM4xNyDxkDdyAEv3fAXbWPtDiUwPIHZWP+0kDYSYNgqdq4An4fqoGzmERxSc7cGIohZuq/Ayg8iHXVcGkEve2GEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lw1Me2zf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lw1Me2zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87CF1F00899;
	Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789821115;
	bh=t4PDq/MmBp9D9cI3ENZf8ObIugUB4Aoai/ehDBDUDZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lw1Me2zf9xeufxnsM1OMdawy5Euq54s0wDPEANZeYIrUVgP0KluhUWVTZEb5Qf9Bk
	 IBkKp/1ZhzxasXqbt+aJFa7kBQvfxgOdqROCL6O8buQpSpesXvx7JeNT0O3TBM8pYn
	 5kLXjzGrCllO6Jg0al4ncAfhvE/riq+o///euGzNESrrwZsXq+Ag/8GnI6Z0GW787k
	 gVK2XJ2eH5EUmuFAb1JSz+5dlRobpJUGfJSjZUTdh8vcQeEYTrdH4hue5Hi4gClBv9
	 nHBtZ/eG79IxqFonZ4HCkZ4jUDM+GCZ5xQvMbUH63StLPLjjXcv1vilcdN7lm7MhIu
	 1XxfR8afze5MQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x7uET-0000000AwvV-4B7T;
	Sat, 19 Sep 2026 12:31:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 4/4] KVM: arm64: vgic-v5: Correctly handle host ISTE __le32 conversion
Date: Sat, 19 Sep 2026 13:31:50 +0100
Message-ID: <20260919123150.3283606-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919123150.3283606-1-maz@kernel.org>
References: <20260919123150.3283606-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The vgic-v5 defines the host ISTE (h_iste) as a __le32, but uses
get_user/put_user on a userspace buffer declared as u32 *. This leads to
sparse having yet another fit.

Instead, define h_iste as a u32, and perform the conversion at the point
of doing the access on the architectural state.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609191215.to1MBYak-lkp@intel.com/
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgic-v5-tables.c
index 2c8d0f360506c..aae5cf05f3907 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -1457,7 +1457,6 @@ static int vgic_v5_get_lpi_ist_desc(struct kvm *kvm,
 static int vgic_v5_save_linear_ist(const struct vgic_v5_ist_desc *ist,
 				   u32 __user *uaddr, size_t nr_entries)
 {
-	__le32 h_iste;
 	size_t index;
 	int ret;
 
@@ -1466,8 +1465,9 @@ static int vgic_v5_save_linear_ist(const struct vgic_v5_ist_desc *ist,
 
 	for (index = 0; index < nr_entries; index++) {
 		__le32 *h_iste_addr = ist->base + index * ist->iste_size;
+		u32 h_iste;
 
-		h_iste = READ_ONCE(*h_iste_addr);
+		h_iste = le32_to_cpu(READ_ONCE(*h_iste_addr));
 		ret = put_user(h_iste, uaddr);
 		if (ret)
 			return ret;
@@ -1520,7 +1520,7 @@ static int vgic_v5_save_two_level_ist(const struct vgic_v5_ist_desc *ist,
 			h_iste = *(__le32 *)(h_l2_ist_base +
 					     h_l2_index * ist->iste_size);
 
-			ret = put_user(h_iste, uaddr);
+			ret = put_user(le32_to_cpu(h_iste), uaddr);
 			if (ret)
 				return ret;
 
@@ -1710,19 +1710,19 @@ static int vgic_v5_restore_linear_ist(struct kvm *kvm,
 				      u32 __user *uaddr, size_t nr_entries,
 				      u32 intid_type)
 {
-	__le32 h_iste;
 	size_t index;
 	int ret;
 
 	for (index = 0; index < nr_entries; index++) {
 		void *h_iste_addr = ist->base + index * ist->iste_size;
+		u32 h_iste;
 
 		ret = get_user(h_iste, uaddr);
 		if (ret)
 			return ret;
 
 		ret = vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
-					h_iste, index, intid_type);
+						cpu_to_le32(h_iste), index, intid_type);
 		if (ret)
 			return ret;
 
@@ -1744,7 +1744,6 @@ static int vgic_v5_restore_two_level_ist(struct kvm *kvm,
 	struct vgic_v5_two_level_ist_shape shape;
 	size_t h_l1_index, h_l2_index;
 	void *h_l2_ist_base;
-	__le32 h_iste;
 	int ret;
 
 	shape = vgic_v5_two_level_ist_shape(ist);
@@ -1771,13 +1770,14 @@ static int vgic_v5_restore_two_level_ist(struct kvm *kvm,
 			void *h_iste_addr = h_l2_ist_base +
 					    h_l2_index * ist->iste_size;
 			u32 intid = h_l1_index * shape.l2_entries + h_l2_index;
+			u32 h_iste;
 
 			ret = get_user(h_iste, uaddr);
 			if (ret)
 				return ret;
 
 			ret = vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
-							h_iste, intid,
+							cpu_to_le32(h_iste), intid,
 							intid_type);
 			if (ret)
 				return ret;
-- 
2.47.3

