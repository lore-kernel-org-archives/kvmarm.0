Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A882288B6
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jRENtm/q"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5d1b2153ba1so86803897b3.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857115; x=1702461915; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zYxPAWzNKjGs4zFv8vXKbQlKv9g94bj4VsgWTl+ZTDE=;
        b=jRENtm/qoeu4W3Vv0cwLyZGzIMVRGJAv1h5qP14c8sFV1uD2/JZb7tsi5qalUDWzS2
         sk3AiacSCpdgkb1QhtQqodspgMpeH9u6ch5xFKFQqHNh0aAdR5tfWK1dhdni5YZIWhvf
         uNOS/v5Ype6TgJhnGQXbdB/Y0xRKyheEIuwBNGJ6oLjtqQVErrpCQJF5tsFaa3Bgt0x5
         n9zSPmrU40dGQx6SU3sWMX5xeMGtXeier3M1kfUMRhl//pzyJA8L2iPHkVU0uBk6b3C6
         iEHx+UygYOQUiuZeLg/R44PxrPqeUj8QV3eHFkgpwA99G50Ia021Y/3GwMH77Gya0fih
         acCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857115; x=1702461915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYxPAWzNKjGs4zFv8vXKbQlKv9g94bj4VsgWTl+ZTDE=;
        b=ixiko+pDxEw3Ryxh6OPBjvbPwI3rXMtfotBAk1BEGMrpP5EjLg4Te7+fWpWjxEKX3l
         wyYuHbYaXCqt6SdpoLCr3Nm90OvS8LGoB/f7gVasRptyzrF8N9uGA2uXcUCVXVDlBger
         47VwTzhJT/wKsasGCOIj43Q7RcB5dQfxGDjJVEuC1g7TT0R4DhdbFmOiKHA931bN+2cN
         dyNcrxNZSwbK7PLtSNEKRlPVny3EQBUBQNdjt7e1hLTLka1w7z/U1dtZkmpwJGvNpLck
         P65yPxq/UWdLKGAeJvlFSeQrOCLRoe2Z6ZIqKAVFZKThUxbd6UJx/BNmJbrkhucalIev
         G/mw==
X-Gm-Message-State: AOJu0YwOtaeOYKYEsrz8YYt8beEXO8zfHxDk8oJm+CyoIyvLI14gIMY6
	KBCRBhybkODeok0SPQXVsWTbPUwPlJCXlNROes3GEVTjVkZkrRazuWBTUBHK19c9SfbS6xFZ8mL
	1pOL6NCpkqmCAsFLhEC3AvV8jCt1+NWxo91qUNA9BTi4wM3iJxjN1YmJ927E=
X-Google-Smtp-Source: AGHT+IF0XgmZPFBvviD8ncVdOvmfhSBDcBIU1bXeM3NwrVYLt3fuNjdtGEUjzplTBvIJ0H5yPPDislhxCA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:7643:0:b0:db5:4692:3aaf with SMTP id
 r64-20020a257643000000b00db546923aafmr4334ybc.6.1701857115094; Wed, 06 Dec
 2023 02:05:15 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:54 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-5-tabba@google.com>
Subject: [PATCH v2 04/12] KVM: arm64: Add bit masks for HAFGRTR_EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

To support HAFGRTR_EL2 supported in nested virt in the following
patch, first add its bitmask definitions based on the 2023-09
Arm Architecture System Registers xml specification [*].

[*] https://developer.arm.com/downloads/-/exploration-tools

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
2.43.0.rc2.451.g8631bc7472-goog

