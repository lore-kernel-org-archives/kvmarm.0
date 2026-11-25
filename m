Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619663;
	b=HUdLfXiEofOpgMj3aJkEIug0Kz9umSreOlMwyS9/zAQCBUBclfccPfSrePGc1zvCY73p
	 29SLzDb/jg9flTcf6zcngiZIdoYeL02VUxZrJe8/795Dj7Mfyk1nTOYgK0/xM+Hvf3S50
	 z5kElY/zoRNvo+TyB524DuC8nd5hQDsniHTLlXLOZzOl5IBNw9n832o2iiB4qrItxqeBF
	 YDcFW6T7/LCQOs+3rm6TZskiJKVFEIvhVRFInd45qCPGsf95vJllWiailuDmzqGa9d3+l
	 pRjSEp2OFEZ6FbxzMX6N7A5poM15Y7Wo87xy/TI3VujDFMqHoBdP908JCuqpNocWImQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619663;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KPxJkSXbgNCwMjexUmFruvkO52wS4HWNgIMrUkpFZyw=;
	b=YmDdau9OykNXcP/GGS+TWUG3455zJzcsmJUYMMLWl7qSI03+hmgFeCRHZhnYSceDqZV7
	 QTW7DnWe3kXSYv4oZl12gN5jlJjYxKsTa8nGJLpoXXwvthwdqjX8XhUpInvcdW9UcLWZg
	 DS/2fomNakQFnPZMPSYGJ692/ZT2NmMUOhDdnuWmXt/9+S58Ii2Nt6z+R/tQlDEabIyJS
	 Y9kXZ34D5FltpCu0cHOMMwTycOjVlINaXFRzl9lIV2eTjiMaiHIaUjRB1y+EMwLqGP8iZ
	 Ism170bo53b1AK4RYcfFchAY3DN3sfu6mEN8czqWjwBaWyfqHmDfGVOrzU5bdgkACJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DMMed954;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF69E606A680
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF69E606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DMMed954
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CAFF2F;
	Wed, 25 Nov 2026 07:14:19 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F5AD3F86F;
	Wed, 25 Nov 2026 07:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619662; bh=561lrRLmUiWpxG8SJgos6yK6je/WVLjQyZln4pVPQYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMMed954YUdp/mJbDjKvyc+RSfnXpIehB5AiO0TKoZ5eyeB2cmNAHbIwV1dDMsyva
	 ndrpTBZ0Qa+wuvVQ0KhelqegsSTyPWlc36pCz9TjJguiYpAkcqRwkc89ubKkXZn4sE
	 IkicNozUXoy3L5YI1TxziIJADluyITl++PfTiJ8k=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 05/23] arm64: Add GICv5 irqchip device support
Date: Wed, 25 Nov 2026 15:13:38 +0000
Message-Id: <20261125151356.2875108-6-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
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

