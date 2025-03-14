Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828A920011F
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967478; cv=none; b=WSN0EXZHCnvZ8CV9S3qe2e5RSxlRMWxBDMtNcJgeWAlT2aKdlsNSMKDD3QVxmQW/MdcUJCBvIJImdQqDWh2a0jphAgUFcRJOlAF8IN0Caix3TJY9/hSvHvqQZ4tpArvsrwODefjsqiWUMLdWINh7C6brErITz9LizMI8bvDJM4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967478; c=relaxed/simple;
	bh=WTX54HjQel6kBn7szTO3R4mdhkKKzPvKjY+5SxMqCKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lhyNNVrwVmY/Q483eb3OfygVyl7/j3k4KutNpr5fpFGZ+8D4bS62O4bs6aUHvMBswXjU194FQ8Qz57qwZAP7i9UqIsXpdtYecJxChWDVfh2/Ra/P/jzfeGpFr+y0I/aO3hxjmXY3BbnV94C0cFuJ734Q80ICCNKkHjdLzngL6o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KpTaISM/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KpTaISM/"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d0a5cfd7dso15474225e9.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967474; x=1742572274; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BxWbhv91Bg9/1FyB7uOy2VxTZzLp0dnb4oXLuUhTuuc=;
        b=KpTaISM/7c16yfjG2N7X/j5LlOlNzt0He75azGMPaKt2SA9F/HxN6FXp88+ivLn4sX
         qPIHE/NB1AK3oc6B9TaaS2t+7xO1QCx+H+elwH/1ckhtkYP5whYGf8D98IuIAvz+PUF2
         OU/GE3yAAnT5F+qjLbuKq60iJHR9TJQdej4HohBp1nfE7TT3LiEe/1Jgp2p0xRhtpu+I
         KxepVVljTA4XlFdP5FcLKl0XfjF0Oupon613y1ez8lo/9FTQznyMaAuefgaqIvqNdOZy
         QsSoTCm9+d1kwuxiUDAYqUoALvPY2QL0JGFBXU/3d4JcLdisJpTmDBd5GHMJBQ3sb9Ur
         vcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967474; x=1742572274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BxWbhv91Bg9/1FyB7uOy2VxTZzLp0dnb4oXLuUhTuuc=;
        b=fZwyn0mYQhIM8LLXCZDTN8Err3DMf4dT3R7mXEeCxOlP1qZN+h4lmWi+wIra+1VHID
         1zxo9jz2Xn7EkELs72J8jFzj+ytkoJMH4VQT5F+o1kQuqROVDLvKz9R6RAfA6GCIUD/m
         CawilL8EgvK5UPEEOYwMP/PC27FdfQMVm+3RK6Xp1YOAxuEZXAn58WN6jTuVZ0i0OtyV
         v+GyaNVPAqRnhy9sxCCY1xnKRItvmqloQrbjH2UmT83iBVGWrA7aYdlovuRoM5pZlCLr
         k2d4eBHDrGjRSTKOWsABo/76FQMyS0D8p8XnYl2Mfwbd1mXMp2s8dRlz6wv4TxFk/K99
         m27Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1j32eOY4Tvv8gR8wIjrleYLs80Rz7/QiR2rvSs9P6uGAKn5FEXGR7cicNiNmSROCxJRdoZF0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAUklBw89N5KWdc0tWGSWQRixn2coo10Q+wtrcskhrR30zP31j
	OwppbEyRixvPwboox9iY6MPfd9nX2Nb6c7mzyle1wj4ksCsaE6mjs3hB4VyrYwY=
X-Gm-Gg: ASbGncuLKMg9ednZHx0GnT7BlJb1PmUzBJqWwryVdnShpkBlx0Qk0IYTp30DsBC3+bn
	GInbsvJ0hM/3MUg0Zy5Gp43UTHXfoXqjZ9AAVcOBDcFyiZseGWhwHHpPUjZQjd57S+bo5+5UsDk
	eitEC6Kz3gwoE6ihsbMzKCqc6qWy6d7t06DEItd4Xp8+lMe6zE0dJH6RtPa2wmblTYce2t7VhM7
	MfVzaAIYlHkj21v3PzWd9c1c1IbQsRaVE0gwVEqH0NsPeqO07syLQx3GkgqUDQnuYk/dTAuNK53
	a0hsgdTlcHHKJlwSOTNgCsEK7yhC1Kaj4Ni59tWXya6GOS5yLY5NvHDHfiTeqLw=
X-Google-Smtp-Source: AGHT+IEokO+3Wk6AyeH4Dqm42uc1ybfhtzvrL/+C+eKBmDBhVkHi2YIMqZsjG3HR2Rb8VWwFY2Q8XQ==
X-Received: by 2002:a05:600c:46c4:b0:43d:24d:bbe2 with SMTP id 5b1f17b1804b1-43d1ecd10fbmr38111635e9.28.1741967474548;
        Fri, 14 Mar 2025 08:51:14 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:14 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v2 0/5] arm64: Change the default QEMU CPU type to "max"
Date: Fri, 14 Mar 2025 15:49:00 +0000
Message-ID: <20250314154904.3946484-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the series that cleans up the configure flags and sets the
default CPU type to "max" on arm64. Since v1 [1] (sent by Alexandru) we
addressed the review comments and distinguished "--processor" from the new
"--qemu-cpu", to configure build and run flags respectively.

The default TCG CPU on arm64 was the ancient Cortex-A57. With this
change, we can test the latest features of arm64 QEMU, and for example
run Vladimir's MTE test [2].

[1] https://lore.kernel.org/all/20250110135848.35465-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/all/20250227152240.118721-1-vladimir.murzin@arm.com/

Alexandru Elisei (3):
  configure: arm64: Don't display 'aarch64' as the default architecture
  configure: arm/arm64: Display the correct default processor
  arm64: Implement the ./configure --processor option

Jean-Philippe Brucker (2):
  configure: Add --qemu-cpu option
  arm64: Use -cpu max as the default for TCG

 scripts/mkstandalone.sh |  2 +-
 arm/run                 | 17 +++++++++++------
 riscv/run               |  8 ++++----
 configure               | 42 +++++++++++++++++++++++++++++++----------
 arm/Makefile.arm        |  1 -
 arm/Makefile.common     |  1 +
 6 files changed, 49 insertions(+), 22 deletions(-)


base-commit: 0cc3a351b925928827baa4b69cf0e46ff5837083
-- 
2.48.1
