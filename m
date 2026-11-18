Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024708;
	b=GQJeCBCOK5DA9Y8rpHjq/bWOl3iGdKK5ZpzR6iSw1foPfpHAmC9uhQdQltyr5GkEtb39
	 3nVG7l78uubxN2SXNZDHKEZC5iLM/6zMRdOomBiuU4Q6Sr38DGIVUQbxXezskww+h5Sq4
	 UB9fEPGUhMoAKRapWiCaq3N4uKx7cYsLgRNTc/XTeu9E7ovXJrpWijKYgmnGCoj1iLeMa
	 eRxjIrrhpjy5BhE/GAQ1MT1YEvq0jE0fpnVNJ3XAmnyxAPGB78b0OR4Y1nbIbJN6tE4aG
	 PgFs+njTXEC+/HnfxIJ9J2h0c6+iXOLU8e1Dmz5Cu3E5vTzz6tVH3o/Dzat6caPL85A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024708;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KPxJkSXbgNCwMjexUmFruvkO52wS4HWNgIMrUkpFZyw=;
	b=E8EkYedZqs1DcZ8fK5PRLp5UFKA8sFHnS66jOH6LN/QWh0sT4OK0KdZvX49nzDojtQAr
	 WKeAhg8zC2lnSmoKUOz6nbB+8FX1NOWThNhDLiKtF2Fdi5Jtluvc6/hx9Krl+2fjWMz0M
	 O6LKrVGpxxGkbqaqxJFs1rmEDUUzHeKg+txg6y2H4WYWXoM9npJJG03+88hX6ax6/bsJl
	 DlerFJ/gh5YfX4q9C+XYf6voDN5cwRrbkcoD1x3x2ZiPwalUpkG8tjqGHI6LbLoJHs3v2
	 12uTaz8/R5Rdnxo0ihlarHOpggAg5fH0K0Sela2Ndci0cijWAfgEDWuM9mR84YxERZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RQU78gS1;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A1D606A325
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72A1D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RQU78gS1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C748B1596;
	Wed, 18 Nov 2026 09:58:24 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 718C53F632;
	Wed, 18 Nov 2026 09:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024707; bh=561lrRLmUiWpxG8SJgos6yK6je/WVLjQyZln4pVPQYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQU78gS1EgNtYMxspsK1r89Qdx+LRzfcHrkpdKiS9j8Ul+2pLP1LRRFZmaYVC6H5Z
	 YBT9wu9qIEHCDsO9h/FlUb52+lltw1wPT+wBNRam6TvFGUDFHx2KncmN4pdp9a7BtQ
	 IKy4qMTJ2dePK8KKGS9QPx1cy/auLdZbLwIDCzj4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 05/23] arm64: Add GICv5 irqchip device support
Date: Wed, 18 Nov 2026 17:57:37 +0000
Message-Id: <20261118175755.1946977-6-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
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

Add IRQCHIP_GICV5 and create KVM_DEV_TYPE_ARM_VGIC_V5 for it. GICv5
has no distributor or redistributor MMIO frame, so omit those address
attributes.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 5 +++++
 arm64/include/kvm/gic.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 57f3fa02..51a32159 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -227,6 +227,9 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV3_ITS:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		break;
+	case IRQCHIP_GICV5:
+		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V5;
+		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
 	}
@@ -321,6 +324,8 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
 		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
+	case IRQCHIP_GICV5:
+		break;
 	default:
 		return -ENODEV;
 	}
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 8490cca6..630f0bbd 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -29,6 +29,7 @@ enum irqchip_type {
 	IRQCHIP_GICV2M,
 	IRQCHIP_GICV3,
 	IRQCHIP_GICV3_ITS,
+	IRQCHIP_GICV5,
 };
 
 struct kvm;
-- 
2.34.1

