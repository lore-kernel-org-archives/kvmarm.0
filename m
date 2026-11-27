Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798933;
	b=2r3/cqqdIzQcLdKbFN1wpoEN7IPA3fYCqj4OTNCbEKHsP/GJZWmyO31tYPKGWg4suaS2
	 MQlrSGqJ8flXEvxTmFImF+q886yDFQKo1+ZjIElqLXR2ItbgYvZCwAS5F0pCz1mgOUAB1
	 cmrqUrBq/rSEqOBJioFIB65ucjV6POt87RF/KyO2NG/x561hZMfOkTVQxAoWwjWsWdWi2
	 W4tliCojTWXLQAZvUoXN6OBtwwgJkzrxaAw5kN++RB4eRaaKZWAF5StXzH8+kcz7SvnUD
	 dwg0D3B6a0gNwzvV7/AdVzQhoWmCIHB8Xd2HMtRfsssvkce75X2ZuoXEcPWZBI8L8Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798933;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KPxJkSXbgNCwMjexUmFruvkO52wS4HWNgIMrUkpFZyw=;
	b=qL/1bGaWLIIjHac/7lKKebkh9k9T0MalpSF+7hIJNFIagTvA3A2/BsViOZlBmvaytsRN
	 sD+pVwQU/wpYsEgF46IIYaOKd/1DcCF6p7L8sdvxYFzRZtNUh55IOrW45JzAh02x3yZ86
	 Wi5G+o+mQSeUa1jqg5oWfOeogDW+vTectJr98ixSpJkm+vY9zJXY8HSzVbF9PD/nTFrH8
	 Ps7VMIATee518Ro9KJL09fFIU1RDox3aDnhYnCLf3PzeShzfO4v6gl14rwn//vbIhlVEr
	 8umJuHIsAJQt7rqwDw0Kkuql5tdWiM3ykOU4KRozpxz8azFqGBfPomAWk2GDVd7DCTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cOY3qCdJ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB87606A321
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFB87606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cOY3qCdJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 575221575;
	Fri, 27 Nov 2026 09:02:09 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A94C3FB9E;
	Fri, 27 Nov 2026 09:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798932; bh=561lrRLmUiWpxG8SJgos6yK6je/WVLjQyZln4pVPQYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOY3qCdJ2I68zWDjeRpN59a3NkCzz8GYciuevdqbkyjgb7oJ9nQpPS7bBSMq23Dkn
	 Nlbco2BymWBJJfS29ixP11O0Z5f1xghdfJd4QFhQ9vlHXQfjo7Ik7DmtiRR+hegIl5
	 Ix0QbnO6XLP0UwbWOTnXHcpb1zlv/o++U///MJPM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 05/23] arm64: Add GICv5 irqchip device support
Date: Fri, 27 Nov 2026 17:01:27 +0000
Message-Id: <20261127170145.4138182-6-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127170145.4138182-1-sascha.bischoff@arm.com>
References: <20261127170145.4138182-1-sascha.bischoff@arm.com>
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

