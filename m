Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AD9381C1
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qw57gSnR"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33608b14b3cso5646479f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548138; x=1703152938; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hWCr/u0/LEl0Qz/K61SKmSilcDBET0Mpt8ezhmPfdL0=;
        b=qw57gSnRFeV5fwsq9T27XM8eCqzOoqg6ZosnQneoDJbWVczcYbuKu4h3iih4Ap2bmv
         Ai6DsM1tzPVgjXP5lCmyQ+wXDsu8pz/oNKefA3+4qzAFB3qrYWf3Cld19SSkpVxhSVOO
         u1adB+0mAHeYTA8IAECidxQ9+vPzEpAZUOWmSSdrq0uc+Jer8KJSITnuaXimYBCg4q3Z
         RHUEjteLPZxKyztjxG3x0VT9yu4wBvSmbn5Ygj3V6radwAr3U25mToTsYKx6xz/njyiB
         vlVFinVxPieE5iAOggXjkmKQHydt70ymB8IFEG/WEXM7LPaKs8XLM30TycsOp9Agkhwx
         tKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548138; x=1703152938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWCr/u0/LEl0Qz/K61SKmSilcDBET0Mpt8ezhmPfdL0=;
        b=kRipEWRZl4DnjT5UdzLNFeMzbhVKLlPMWUtW9tWybryxe3INBFY6mP/jWEaIvs2S98
         t3fuc2LY1KedxH6qpqOSO9izWmwLZvFThoM1IYnh+Ow0s+lklr9PDkIXBzoda4g8j9X1
         Xo7E0dMNlLv2BiPJ3aQZ5DoRI1+Q5+ShPiEDv7pfVZgKcuBLqpLJTTUYbM5oUFGUZnD1
         lGHsdacKkp9+bFzIR1UPDr029HV4QtU1tkt0Eg8mtZxlSBHjanAdofNZEv0ybbvkZl3V
         ir9i5mX8em8bsiw0/ZKO+Zp+ta2Uq7ST3ctyLshQbAWSedBnytZegY9pCN0/iQQ+8R2v
         77MQ==
X-Gm-Message-State: AOJu0YwN3fCnu0X/q3prVsOXNqLwbGnapEn492WNteMhi66npkQBT4oO
	A9rZXERIYBL3nMATefqMP6EzqgrvbuBX51AYr1u5CqgOSpCGJZFoylw3Ul1UdICaGMwiSxhqqq2
	d939AeD6reD2HoNhcROz7J/b3hAJI1LgQzowIdJ3IuTnyB9dVTTQ5JL7px/8=
X-Google-Smtp-Source: AGHT+IFL2ThU73Trz4Wy9pYB2yLh/2X8/PtTAtN1qdC64iHsHskqYdTX9A2+HSCsuauP2OUpLSO2Us+QPg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:4024:b0:333:43b5:ef39 with SMTP id
 cp36-20020a056000402400b0033343b5ef39mr50416wrb.10.1702548138483; Thu, 14 Dec
 2023 02:02:18 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:48 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-9-tabba@google.com>
Subject: [PATCH v3 08/17] KVM: arm64: Add bit masks for HAFGRTR_EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

To support HAFGRTR_EL2 supported in nested virt in the following
patch, first add its bitmask definitions based on DDI0601 2023-09.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b85f46a73e21..7de0a7062625 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -370,6 +370,10 @@
 #define __HDFGWTR_EL2_MASK	~__HDFGWTR_EL2_nMASK
 #define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
 
+#define __HAFGRTR_EL2_RES0	(GENMASK(63, 50) | GENMASK(16, 5))
+#define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
+#define __HAFGRTR_EL2_nMASK	0UL
+
 /* Similar definitions for HCRX_EL2 */
 #define __HCRX_EL2_RES0		(GENMASK(63, 16) | GENMASK(13, 12))
 #define __HCRX_EL2_MASK		(0)
-- 
2.43.0.472.g3155946c3a-goog

