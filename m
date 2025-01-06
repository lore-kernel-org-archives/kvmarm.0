Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFDB1DE3CB
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173506; cv=none; b=BhMSnXpgDP/6712xMoOSck7AYTI7fvAb1mwkIyKZRr/c42w5H9AhUSo8pyVCWhihFWaonajdAlz9XP/6oYK5BikTVBAvde8ZNQCQPI1Lf6WrXvPasyWwAgla9ATtlmo8/kfrlR7jukSX84QB/gOfu0DDeuKJ+XfXzX4jrVQw5FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173506; c=relaxed/simple;
	bh=G9rRuC3G2YaoSkuVlJ4Vp1culXRO3s31raBx1lelOs4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DDhbn+RTQOTQz1H7DGJx4P7eCihWKxP+nG8Kg6mpSWwoYPT+kpEkQQ2W097a0PUMIDCBx3rvIOzhXjIPrDxQof+3NsuSZpaEbqCe9cQKwTk8DJqyvx+tOkNIaPzii657dpdVa60QBZ8ZakIvJD8FcEh/7reEXjJCuz1FdfIbZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r0eGLPaw; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r0eGLPaw"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4361b6f9faeso87021795e9.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 06:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736173502; x=1736778302; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYKAYFSavL2qrh7QKasXIoDw8tHxDZ9ErXkuN1nzLXI=;
        b=r0eGLPawLLGM1kgNuPhlcoYVT25i9LbuxbxdPlomVmewEsFwJqDfc0UJgWXkEU4SQl
         KCQLnsKMASN9zins2+qIlvSMOaejfFDXRcQKVtJaNE7JKsvgU8o66FwpNR3qhFC4siKs
         UKnuDsnsy243Qjq6rmrNcfVyh/8DMKAVdarmMom+zNEIulM9EorjE2Pp3gApqq+PkOJA
         N8r1DWlJq7uAoliuUjvFstHykK3BZsEQ6eqNBFnxjDCeMZKk4IPKg3B9c/mwK3UGo4v6
         6YVYo+Sp3CYpx+jNWRkqeKYHZyn6tlfu8mz+PCAIar/2NUT7Hw+Qy5vOvE+ckj1s0i/c
         O/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736173502; x=1736778302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TYKAYFSavL2qrh7QKasXIoDw8tHxDZ9ErXkuN1nzLXI=;
        b=ZGcVhgio1hReO52IGUWW5MckLn80dAgEY4Dbu/YUiSiPj9+t8zBxQxlWhcKBXDhDoO
         kDzNMRp1sFr9txGehOW9Cd+eNEqinjlhclsi/Hokj4M6iE1kA9shoY97qyUO6bq/fZnF
         jkcujAfzRNUsvQQyWJeYzZljyQcjEu+5Em7XosMupoTTbU8IHTzib5cRpavQ2MQbImwR
         GZUC8MMhbwdnqxGlMMsBon+mwPM0mRNAgtbe0q3YwfRgzsdt6Qa/nDhgRlJTda/kl56w
         9X3LOURdJJXO8egykR2iDKJ5N/sPxiWvZ2xL+NS0tzc6iz1sAfSLcw5FcZJjEbIxaEhg
         yh+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkXWoBb9uKQhU/OpfNcOWUKrYHVN3OmWoNHH0r8RWWPDXRylt7Fm6TFhU9iWCgxM780cPz7nA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0Kla4RImcjfTRpFN3OmbTXsVSr7DpFIyxD72yOqRhW9MVt7Ll
	jBfR8NWrTu0GeuWEmgtjylzcZE+bRBIGA29+3MG+PBtpDYMagNxhiwjKnWbO9Po=
X-Gm-Gg: ASbGnctzyEW/In7TPDehlZiv3RKs9Ot6v5/dn8xujW4VivB73Q4rkZuvy44vjz0v2FX
	buwRYhfuu6xhpcIILJDethm+sSq9yp35XtJp6KFly8V2p+lF/3CEYWJ12RY5Hwrr6D8l3zeRsGX
	60V4/okh8gcYJdyAPPmZbEB1HRifn70FFDYR6Mt0qeWLwj83gwQtLuryYWwKrV/IvT8ozYNZMQk
	p/8q4giJ68/QBES+yoO2KOqDL1O/5y6WiB8NiGmfc+QlUu9/FA9UHWP
X-Google-Smtp-Source: AGHT+IGvfKHKPelpjJIIKzzgOO6ZbMtRPsuhPmTddU6cCPPRvQrUnpkGik7ELz6IwLeAhD1ciwaPgA==
X-Received: by 2002:a05:600c:1506:b0:434:e65e:457b with SMTP id 5b1f17b1804b1-4365c763d36mr525116695e9.3.1736173502053;
        Mon, 06 Jan 2025 06:25:02 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4365d116d8fsm577295045e9.17.2025.01.06.06.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 06:25:01 -0800 (PST)
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
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 1/7] arm64/sysreg: Add a comment that the sysreg file should be sorted
Date: Mon,  6 Jan 2025 14:24:36 +0000
Message-Id: <20250106142446.628923-2-james.clark@linaro.org>
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

