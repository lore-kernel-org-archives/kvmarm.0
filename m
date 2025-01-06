Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED11DED44
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173525; cv=none; b=Eyazekl3eYx3sJgg9+KqZbtz3ydycDPRYTCMgBhkg2zlrATDSod1Pko3HMfB2uNwzWRADvB85Mx3oeIbnX9x4ZzU6dP0wgsY0Kk5IvuGltguzgXJHrb47GZocQ3VW8MFThsczx5rUevAz8nW/RTxcX/pD1/4lZfUJez6tTzGJP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173525; c=relaxed/simple;
	bh=515J20g3KOaVrQnDr2libk4j/PMQxhzZ6DKC1HncDTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j//q/zz1UruZAhPPdCLvVX98Do2KACZO99FhJFWlPcpEqRk6ZKOBV3/ZcvnZ0x8laurGS+FIMSVuwY3PAoa+oovpnG0tp0uKf51Qw/z8J9orSCLM1emZI1ojK4hR/VYOFr6hWcDoowUScsRiJ0KJrRss1qAC6IMdBCsK5UrEwjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MdWKRgzV; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MdWKRgzV"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-436249df846so99948285e9.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 06:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736173521; x=1736778321; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyZ7wmu4kV9rVhQbBxzSf+OE3ubAppsrT+cnU3G/b6w=;
        b=MdWKRgzVwLlyIOMGbFffpSQxRDtuNC/00LUpd7od4vtkm6h0nUKO0c9MO+WzP8tD0X
         EXUhzHAfOHZ5/111WFA04BpmAWWL0kQXEXGa3oPZzSdJxUo/lxGHxguKcrlnCAt40wVX
         rMOCe0jyAqwNFEXkcFT3Ja41sYDYPDEq7wBDBpQZyeXBjv7zVsy+Rz/0SevV+tjf5aGJ
         GsH2mHkYJKW2xsFsufhwsIAcOf7xgglRHffTg40QC6F8WXTCdkDIc+G22MTMpyRSHe0k
         PxMpWP/WpTcyU+a436Q7Ra3n+3mqsE0qOtmrdsvkmpLOs1VwccuUY0W757jy99ewIw9S
         XlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736173521; x=1736778321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyZ7wmu4kV9rVhQbBxzSf+OE3ubAppsrT+cnU3G/b6w=;
        b=CkFTYGVh+/yFCzeLfexVehFTs5rixVClzIDc6KUr5huirFaUnByYoe5eFmo+hnWwLE
         nBljkgkuX9KhZUUa0/z+EKXbCjy1w+9cDWNDeLP7ltY+W6ij8CqNbzo5smaLAvrt3d0L
         pzrmFTLeGnCtHl/i7aOicpzwCUPpKoK81Kq0llfUW67QA0IeuE/ORfBJoqrcKHGorYUS
         QuYYvv/jBweUVQ5yeGhr8f+OcX3GRjlm3Z4x7sJpEkNmhfh6z4TJUBN1hvWeU79mN0Xd
         ScRYoUGs+O9vFsj2glm2moSbNPsNI7kk8vzDLHwRkuEYiOyi/h1j0u8hePN6A4zq8tNE
         F2aA==
X-Forwarded-Encrypted: i=1; AJvYcCW9UD0CP82z2UZf2hGxDHKH6ecRX/86/xYt2xlg8GA4nEaZuj1fV5J2MsEjmMdxhiweLw8CIQA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmCCdeRIAbfiu36I7CY8C1XKsj6xD4ZojapQe25sH2dcp+jtZo
	OsGRVe3mYHF7yPpund48Sx3q6UOQgjf+j34YPfb3NTf5nGe4QclL58CUpaouGtw=
X-Gm-Gg: ASbGncvgsG4VqJvGJSwBFq5kk/5mvfz15FBUJzGaGDh1qPcrQyaDqvhaCINMouXGAHp
	Lss+mKSmXFCn8Vt/ujeZNbBJVIpr26LXrVBctqCOZ0jbOqjmZoHDDm4Ddn/mKiZyqGF27v2Yrf6
	R3mXNqQCUrLXLDra+2BO9lIOMwpCGG0jQtu0KLpjGUZULspmDWhqlo3cX4kQV3bOS6QKnDP52KF
	phC6M136ZG/3JaQok1P+lRZjAr59W9QIpz3fyDKj+DHP4TfjiacYMBc
X-Google-Smtp-Source: AGHT+IGCQC1ROdlgyRjosoLzlDCaOKhnwgRBpfjpCc9aRQvwJaTQPlLkjI1ZckCY76Q0lC+lhk/kwg==
X-Received: by 2002:a05:600c:35c9:b0:434:f5c0:328d with SMTP id 5b1f17b1804b1-43668b4999fmr438349285e9.23.1736173520936;
        Mon, 06 Jan 2025 06:25:20 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4365d116d8fsm577295045e9.17.2025.01.06.06.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 06:25:20 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 4/7] coresight: trbe: Remove redundant disable call
Date: Mon,  6 Jan 2025 14:24:39 +0000
Message-Id: <20250106142446.628923-5-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106142446.628923-1-james.clark@linaro.org>
References: <20250106142446.628923-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

trbe_drain_and_disable_local() just clears TRBLIMITR and drains.
TRBLIMITR is already cleared on the next line after this call, so
replace it with only drain. This is so we can make a kvm call that has a
preempt enabled warning from set_trbe_disabled() in the next commit,
where trbe_reset_local() is called from a preemptible hotplug path.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 919804b12a67..03d3695ba5aa 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -253,8 +253,8 @@ static void trbe_drain_and_disable_local(struct trbe_cpudata *cpudata)
 
 static void trbe_reset_local(struct trbe_cpudata *cpudata)
 {
-	trbe_drain_and_disable_local(cpudata);
 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
+	trbe_drain_buffer();
 	write_sysreg_s(0, SYS_TRBPTR_EL1);
 	write_sysreg_s(0, SYS_TRBBASER_EL1);
 	write_sysreg_s(0, SYS_TRBSR_EL1);
-- 
2.34.1

