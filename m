Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7164A1EC01B
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249686; cv=none; b=kMpFDfyFI8WIsb6xbIZwooM27PLk3ihfJkysdmlQ0GTudxeomvf6f5SS35jOS2McCKqlLtFlGDrpVPny02AXrsmNhsupzjNmpztzDBwHPAetsGE6pPrAbOIHINuUfY/+Xx2h3xhRvwCGzXUnQnaSDopxjNJRnbcoAhJdY2NoC4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249686; c=relaxed/simple;
	bh=G9rRuC3G2YaoSkuVlJ4Vp1culXRO3s31raBx1lelOs4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X0/8R2Fuf/xUBG6s024dX1iwidmO+QGOyQ1sGLbfVSJ2VZ49gw9UoIueW25VkkYvIcUBeKs7FvUeGN67Xq5V4jqHi9vtBiTGeHMydjcf8GNvGwvSdjlvoR4fLiPVue4NE6G296eWr7CcmE6KjZ/V81tvPegCvARsgIUhx0AdkYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NCw9tfqz; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NCw9tfqz"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38634c35129so11826689f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249680; x=1736854480; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYKAYFSavL2qrh7QKasXIoDw8tHxDZ9ErXkuN1nzLXI=;
        b=NCw9tfqznQwDVOQBlsCCNE/ir98+tgtKSB17MIjiuZ9biLdqiPArT7A/qHHjmQvd8M
         HluWh7NyfgCIzATQxbRSB4k8oM/b514FWFWN7fCiBO1ENv2TJ1Edos2tVwRsX0tdybHX
         chGJnoDPiOsGrqqlkB5xMMx8QbJ+SOaMdR+CTAonZoCJsp+MzycexgHyHYT8Ei3FPJmE
         ZRCx1gX+SgcRM+Wy0bQYaEEMZomNCpY44JdkLrWp8KZrmj0PncAleaxnmBHBfw3Hn2KE
         MOAutxqO8g3HuV9F4dUfLOplHxk89cHgpEus04TiHdNDtUkkkEV/S6Bmf93fLKSFf6/J
         JLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249680; x=1736854480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TYKAYFSavL2qrh7QKasXIoDw8tHxDZ9ErXkuN1nzLXI=;
        b=aO696mdSqb8K/00VMQFmFej/ZBSsyfU17m4JK3z0WsL88ULpm4SpLdfwjOai1F7uXd
         5va+0k4a3T2lSOAMifxgcdfeZxLrjTPl2VR+ZPzcn+3n/7vhipTSsmfJ4uPQZjuEpLyQ
         5Rdc9euOxTmMQWfSzhPiIfxpcVGDM/AIlMEFW+CTO+P/B1jySUTDg9NF14IDXDjfnAwf
         sE/de1FWvE6xdRPNod8AtfN1oXqv6t7btYS5BedtHiMqQ/uF8dUDGG98RkgWNXW6HWs2
         D/iGVACkLAeMuJXG1mpEc6k3TtxMA9ImV5DPrCwn4hD3q2+d4VU0ILm5gz3LPfXxFf/+
         oA5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUY14xc+KG+excpCY6oTPVUgsr2fHVQGu5REALBXYvnRf4z1QUkXzZttrwLFMO0Q93Pa3/0xdc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3yO8tYqRc1vxq9jO+bBH9NNz+RbEje90UB60VJkBl89nFvTrp
	b+QzWKuEL8G3XwDjzGiuMAFgpPUHlzudQ/REPLlftS1i6XS6+6vL3z4tLUnJ68I=
X-Gm-Gg: ASbGncsrXxIHd1a0r8wt3uOpwKBr/MqddneGz0GR6GJpzEIg50gPZrs1gM04CE+zZxw
	8ZS53MZMIf3AuTqc1Kwk2RmFZh5BS9rgjTD7/3stBzc0GMbGNNmdKfvXyZPve21AdEygSGWB8LR
	MHdIxeWk+Xdy9BCFwDvoMaX0cKHHg1i4D/ApdlseQVQHFfPBOMhRekk1RbvVJfrx2DG3FYs1WM5
	mVmdlXVXedcC7922AhsWqG+2rXlmHUXdHMgHRW8mq+ezfYlw2Vk3eEh
X-Google-Smtp-Source: AGHT+IEWzbMoPmYqwdpQNkR1Kz5LG27JaD30WaVdSux7OQkOmE0VOl2PoerHtsX2D+CBixf6WOUzdA==
X-Received: by 2002:a5d:64eb:0:b0:386:3711:ff8c with SMTP id ffacd0b85a97d-38a221f1fddmr44591980f8f.23.1736249680458;
        Tue, 07 Jan 2025 03:34:40 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:34:40 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 04/10] arm64/sysreg: Add a comment that the sysreg file should be sorted
Date: Tue,  7 Jan 2025 11:32:41 +0000
Message-Id: <20250107113252.260631-5-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250107113252.260631-1-james.clark@linaro.org>
References: <20250107113252.260631-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

There are a few entries particularly at the end of the file that aren't
in order. To avoid confusion, add a comment that might help new entries
to be added in the right place.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b081b54d6d22..4ba167089e2a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -48,6 +48,8 @@
 # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
 # item ACCDATA) though it may be more taseful to do something else.
 
+# Please try to keep entries in this file sorted by sysreg encoding.
+
 Sysreg	OSDTRRX_EL1	2	0	0	0	2
 Res0	63:32
 Field	31:0	DTRRX
-- 
2.34.1

