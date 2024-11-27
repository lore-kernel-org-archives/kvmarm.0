Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FAC13D251
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 10:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732701726; cv=none; b=hKD8nGF7ciqHaDGmJ1QfFkDsf2K+w853nCL0HFVAYusublNIa3aNf2DNx0isnn5ielGGBWoqWv+kmoyIgGvmcc6yAC9T3LDbBZ+VxePLrdG2c+DzFPVDqUI2DFgPCW2tX/aUIo+BfnfTEQbPPOH0ySxmGOLD98cwevZOec0/AU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732701726; c=relaxed/simple;
	bh=NvSG3zelG+rR4cIjRHjFyNRBSUc2x1i3rn1BQtgcjyg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ALFrieVQcNGvFrLuSGyAQ7onOpOS7SS9TokJMY9qmVcvkAnNIEA+9mVdRe/mHjsfK7QO6BUyiB7hcbrq9Z/qBrlqiequtSGaHTlL+zIr6xuVOW4hkJlMEJM5x60TNi369j/EX3up7ki26EWEsNwJcEgIsCSJ00xXm9137fMdnd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f1qUJFdg; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f1qUJFdg"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53da353eb2eso10184221e87.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 02:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732701723; x=1733306523; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LA9dViqKYqwFBgszUeA0NVjaCyBCvEgaySoNXwjG8Lo=;
        b=f1qUJFdg1dmaLV9/r8dwVgYU9y3+KmPziUCkj4edcGtAa5Iyl/Mh7jmyMU5YAQuK+2
         X3NnelXtwtyBTPzg/0e151PcUa5mku7i29xYj6kLmxkEANtkTwelfLMzhzxJZdVtERyk
         dj8yZeVGHK7iTTsKoax3d/jKvp2icapz/r8ko3pWPVCjSwxBV/KyIXUz6j87xgPh1xiZ
         f5D1qeyBNo/Fu+3OaTuXlbAlwghn15ttGVWMO+cDy4E1/oKr1OMbaiPvkNlpL2aaGfe0
         ty/q5v1IBU1XlsWXyjqKDfwWMlFWf/wKbJrEIsshnUCChK2/Ty/BDpPDEQPJdrjCusAa
         w20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732701723; x=1733306523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LA9dViqKYqwFBgszUeA0NVjaCyBCvEgaySoNXwjG8Lo=;
        b=CAgATtiBvUgFEQ+q3DIDaDLqw8ycPXAhhC3QKYPoyP0XsIKVSCUZIKcOnbd/Z3XGJ/
         PGTW8AttA1vqBPo3vvrTX1P1EExhGAQHVp6exouGo9nFFK5SPdFduNoVBziNqhZ9SQaR
         mGN0eN/JRccXy70CeBg/Yr1FctNhIOM4sDypDtsHCkPguzggJoj/o3r+/nt7AIQ+GiYh
         4quBUc66mm0wmOuI5sB5tyIm59vxjfDY6LDAVLTqSUQeLr05aVGPHR4rNQs4TgPFBX2d
         ugCfFkS5jGtVf40JE2XX2ZvFocRuiuhfP+A0MiI+UCbzGPxsBLKXaltAiuv8BfatGwd2
         QkBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVUw8jaon257cHcC/S48XLGZvSB7JjODO37zFSPzfJIZz20I9db3NSAs60lJPJfNXG+Xai/t8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTO/v7XwafKa0fXkE/ykFjDIJXKqDt881jPAPciX3kbzlyLoy2
	j6RqLI6boQuIk6YuT+9BgPFd1TL0p/aXAaU8R04qInteIqR3nR7jqoIwiFPPbVc=
X-Gm-Gg: ASbGncshN7IOf2nKYsqxgAl+uNPdPnGHeLggsmBnVQZMEfzYJ9XPc8sxU4khwCDqgSd
	Ff5lJ2fDEp7gKj1olWv6NjhIaaCMVGI7TqmkRiD0ZWNYaX/uk69hSPtw44mF339jL1EE5/f8z3v
	Kdp1v93WjsDu0YaUsxNQTLSDwkqiGt5OY7VG1qu8AMQWTHvh5jPltsdK3f1K1FkrpJozOxYceDB
	V2cEXTOcO+qyN91WmAemkEBYp8Z7+JGviUnay51MODn5UFrFQ==
X-Google-Smtp-Source: AGHT+IHr6cIPtse8uoTubAv1bGLQ5YJFJMlo8fFp5uzleSsgFVzX7cUspnX76HmoEaHTdGlhoc+IPQ==
X-Received: by 2002:a05:6512:b9d:b0:53d:d3cb:d90b with SMTP id 2adb3069b0e04-53df0117178mr1668132e87.47.1732701722968;
        Wed, 27 Nov 2024 02:02:02 -0800 (PST)
Received: from pop-os.. ([145.224.90.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa547ffb152sm421887466b.62.2024.11.27.02.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 02:02:02 -0800 (PST)
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 3/8] arm64/sysreg: Add a comment that the sysreg file should be sorted
Date: Wed, 27 Nov 2024 10:01:20 +0000
Message-Id: <20241127100130.1162639-4-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127100130.1162639-1-james.clark@linaro.org>
References: <20241127100130.1162639-1-james.clark@linaro.org>
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
index ed3bf6a0f5c1..a26c0da0c42d 100644
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

