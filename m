Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C70B1EE7B7
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249710; cv=none; b=kCqtCfo7eUaCYa7ND/O937V0H8Awvk7Fhr43TZ85sC3iURK8+KZk4T4jGeeqlrI20tn3JMm7w08f4M1ZY/Bjqdvi8GRjF01uvga4vGqMaGLIwifyVy/v6UemP+2FF9YCMHba6XJ0+i82xcX+9mnO0e02UJyoCVCP36fgDV//Zrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249710; c=relaxed/simple;
	bh=515J20g3KOaVrQnDr2libk4j/PMQxhzZ6DKC1HncDTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WI1wPZOKEuNre1B3vS8ocCGhfF3CiF34N85jNDVSzRAR2AhaZbKYLnLeQ2XPrpHmPgmT4qDpjzB30FLMx+JeD0rdO7OmlubPl/kKPRiUFerl1NleyC3afBWdg56VBpHgECrTOvIJQsxAmZtRbv0VnQkq0htobcaqp5FL2Ke6dGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ABfEO9nS; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ABfEO9nS"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-385eed29d17so7331383f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249705; x=1736854505; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyZ7wmu4kV9rVhQbBxzSf+OE3ubAppsrT+cnU3G/b6w=;
        b=ABfEO9nSAI1FYgTNjetD23SywqAsyCJ30yGLYZ8Auzc5mlcARjD4jBy6Eq2CVqpe2I
         d8c59gt1g5r/ulJeGoHwycmgG9Q1Lk2PwtDyX4nMKg8K+65bghqb30ZkIuMocbrCiztw
         I7UAih1Pi+XVjU810E0y6Ok3WTbLu8JUXfw4ihctdFigkRJWKtbVu1DXhJzSz46X4Ess
         Oembls6JBK+p0B0D2Xg8ql5JYhRy77odF+cEGVc6lhqxK7tchSqVOxJV6L9YH+Ciqfaw
         V87m5BhKo54XNRS6Yp4pV0LX1l5XD68ty+MVAwsx/YJaYcPHanLpb4m6EzvPubPJka7j
         082Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249705; x=1736854505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyZ7wmu4kV9rVhQbBxzSf+OE3ubAppsrT+cnU3G/b6w=;
        b=UvgftFhXgdufiEZoIsRgbacT7Kn1kTfHRpkpstju7a8bhYyCAdYYDW9bHrEMz0CSh2
         WnvFHLOoKhpeRDRK3EBKTljEDypCk88fsX/mgMYVD6cYsYZ+FH3rSMuYJXFTwNUC0zYF
         WA3nVKWiGidypo02+EggvS35MzlUgr0M7KJmI3yEHLCrHIy+bGVOFcZSCqWOdqPIKDMA
         WTYJLYI/gecYKnPTkQey7EscnZ6sIyYWmvew0NWIaNqn5vFUKefSl/rT8Rb6ZGb/JB7+
         GZO+ZfxGK/rrZJkIJdopgrUSz6PEqtw/9fBsQAoiDNmc0PLepd32954FMAiUNLQkrjbr
         hvOA==
X-Forwarded-Encrypted: i=1; AJvYcCXMXMCoTUIMFof9C1cQThWn0pRDNsFEG2e0TDFOqL3v7x4ZnmczecE7qQr0Vnrh6yncAbMMNtg=@lists.linux.dev
X-Gm-Message-State: AOJu0YylWYIQkz+uKBTrXEuL9KLA7+IL/PD6zJgGq2rPzJyT84tjk6VH
	LGtTQ78IVeGuU14rRFhgdZpc0VGBZZ5rPsd257RzdU+j0cnL2GNazGMlZUn510s=
X-Gm-Gg: ASbGncs5ZhVX69WLj9iOxUAvA+MyWfd5jY97alqTrWDxSZrNqCtD5/uknW28Gbs7WND
	IaoQPql5gf/oHiqdSxR4oi8f/F2kz9aDh30Mp4IR1MSmkSBQJRiAu3AEGpUtz8kUfveohVRjqGH
	KrreOPSLqQ88tOrm07ZCOg9XDqSuOF1hGkaK+QIa0mIw8VDaD88U3y7IfUS0F+//PUf0gENugIf
	6b7+wZQq3ipVMJvlq21jAfU6k+q0olv5QSrNsuFRgrZ7JrIvbdAtKbT
X-Google-Smtp-Source: AGHT+IEC4sF0XNw3h98PStn+vCErJw5sgNdzJ/PvImYeIfJrKSde/mZzDqExrjtGN4xoF+sXkFEBcA==
X-Received: by 2002:a05:6000:1f89:b0:386:3e48:f732 with SMTP id ffacd0b85a97d-38a221ea89amr51505376f8f.16.1736249704829;
        Tue, 07 Jan 2025 03:35:04 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:35:04 -0800 (PST)
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 07/10] coresight: trbe: Remove redundant disable call
Date: Tue,  7 Jan 2025 11:32:44 +0000
Message-Id: <20250107113252.260631-8-james.clark@linaro.org>
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

