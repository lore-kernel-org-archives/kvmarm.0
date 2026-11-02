Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655284;
	b=AULyMZoDCUt21joe3LcA5l/A7k5mwm+Go6Lg+4840QJMOlFDRC3yPj0I/xIzrtqBVUCx
	 Dai34ps+yvjJRN6+4g9SDEnp33v7udIRnGCWTtDQg/NOVQYq9UCqZh9bcwpYSGtb5opcO
	 Bnx4rHPeMFZlojksWP/ZW+a8zv6nL8rh6c3zzCM7eQuBIbl48AOO5SaGdjKoViJUSa0o0
	 h2ik2RmgyclghoJx69lzPLQ23y5a+vWJSg7eD9Bti82ipVy48LJemnlkj080bX9s/gxTZ
	 PziaVGpCvbSs1sYN29s1Boyi6okfy5PjqA1gj9hw1Oxye1yETk1MNFhbD8KBBFoNnzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655284;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lHjTCMuVsg9JOZ5IrZLxNrPDvI3MU5ap71SuXEUGItw=;
	b=dmp7/KUX1wlBz3NuNGQ6zgDzCxUSQjHTqJHA2w7kW+yKxHXkEDrGJYkA/Vmh5SURO7UY
	 aTyYY3R2dPoV368scG6VfpkAOiPzVcZ0k8RRYSDM6ZNHQXO1g3gvyBfisfxoxDa6HsgQg
	 IuNA9+YuVyew8S/Nyg6mR1GryKQpt5MXed1oIX2gWB+nmWTQH1Ql5oNu0/oYL6nGW+9gy
	 kh0bmSmdU10g/dwwz73se2yBdre8TAxZudhCEGjJh2JP6SoSJuxyvw5ajlYz8pLiUvj5G
	 etUNiWgwXYs9UTFo69PUaiOLZV+WSNwu6WxSoMgeFWc1ON5FY9toQ7oAAuOtYP6jDQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dNs0HjHc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CEB5606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CEB5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dNs0HjHc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A87971595;
	Mon,  2 Nov 2026 13:34:39 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 707F83F673;
	Mon,  2 Nov 2026 13:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655282; bh=vw8zsuc5YLoHQGQPKr8UKzhCrTZt0A3Obj3H/+CW5HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNs0HjHcn35B4FerDbg5+m4JaVtmn44qTrmrhlaLoeDBKOEOIdKcKiMTavOnbInlY
	 q/vW7xKa57zAF21Gf5QmJJndNozARN6VFjsJFzSeTP2RYQ479k5ssW4VbG0Msvh2xz
	 +6WWnj9mMu0K26PU4M/yqneTIWKd4l1tU8WXTV2I=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 05/23] arm64: Add GICv5 irqchip device support
Date: Mon,  2 Nov 2026 21:33:55 +0000
Message-Id: <20261102213413.4136118-6-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102213413.4136118-1-sascha.bischoff@arm.com>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
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

