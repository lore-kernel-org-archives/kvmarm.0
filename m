Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB41819D891
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918875; cv=none; b=lY/aoWSRAEK+p25locgx9pY6f0peDeUX9dKFle6Uah4NaUfU+N2vCwYHQMPfHSV9Hv82KAi1AbxMvkkBTmCT58Q3uHV44aACgFhz6cvqhhHkxilwQiKmQXgB008uSaEHr8dvo8P7+IdSQE4sMis6yHi4VRnTPmnqTVBHJmN+uyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918875; c=relaxed/simple;
	bh=DjE5lydHNpWSKlp2OS+ArgpAXc20b7JX+EYn2yeg0Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dugAEbspg1XpXYCreZ+eXaOZkKn9cWcTd+SGJ35WWiXHap8/PgHHAqTINolXEtIV5PeQ2TthfparrMsKU+7moWaF9C5fjdcknGIwPXh2ayJC9JVuE8dH18BPqT9HUddurPlh2C+I2ZR/NpXluv3OkMq41JcvAnvvRS3/81TA2Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NAhmv4Zk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NAhmv4Zk"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cef035a3bso41065245e9.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 09:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918871; x=1743523671; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=NAhmv4ZkRVP3QpZBXd2+CO66pONA3Evgkq5A0NOa8xyaDb2kHBOjZxwNWnAdrhVvQH
         ckZGAOg5RVUcN18dn4lkNri8ZDLWq114g/glLd4dKc+o9gXO2H0kkjkJ0HZpz0/D5RZG
         W66EwI/NRa/HeB/qcGRMLnsBawm+OCpCRtwRV/RJz8S0A33AOxmJmC2PQJHJOPHhn6u8
         RzMpf7RWhyhqdlQpG1HkRWTp7ImqogYgbMH68u1zfFEn4tcEH+FRaJxFuHQcimmogJbL
         LMaufqmspYgOWNBbm5Acs6+CkB5JIFOfiSCHChHt+rVosS9O9wori8YoteXA7kM1WknI
         piHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918871; x=1743523671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=xKlWj259gupJNZBQ4BBg7MoBhEIz2SGTfBqtaHhXFuhqM1gKMQ44RpMqITI702Z7gg
         MLGQYI4zYa7su23VLSZ4ykpUjHHrFOG/LUlarU0bxT8pn+MAJAw0HuzlYGXczbMU11Q2
         Xf0Gk53n2f16TzJ8qGZOgx11DIaQoNt0s/MrtmaHfFWMuya2xCIXNcsYBeOUvvIpTvkf
         uvlP5V0LVEYRzGoydqWnHPnZQ33XQxmNuFkctLq4JforEpk7nD5y1TAmwrtx7tTCU3bv
         6rWvozUCtXGpac5PCK9b6GSl3/GiE5Hd5TwQTlLWuyd5D5o/cuJlltkN5o3OGqv43ioD
         rJUA==
X-Forwarded-Encrypted: i=1; AJvYcCUs2Dr3+R0ll7dNwbuWMHFGhyksXYHAoHLXwkc3GvAf1zxc7ar09aaNFcJZ8NgJOpyZiGYWPGI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAa+kjoQv9I+6BIJl1FEVGz02eId7utWALwvGK4Y/FrXYucbmt
	69r31xi60ijXcnMJxw4EzhGa9AinuQYGo8UB8sk2O3fkR/u10bpJqEesEGaC6pI=
X-Gm-Gg: ASbGncu9de0Ujsi0rR4YhwKWHZwmBCQDW/7ifCwnkKI0YSJ7VsadJKV02rCjnqrsjbX
	npyqLze/teP6HiWEetd70Y6BXRZJIHY4TEXumC6VmxcPmhk6k3Q/epWc97Ox8sPusEmQUXBiyVi
	ne9IIg82P56kxd6HgsHq+b08n5G0pMcJeABzXyJwe6Tky7m6CFuQlVrTS/hs0bmIFid1UE7lG3N
	5ambxmOMb0y6R/Q6M0tTqQpSRajhe9nMvLS1H6CgfxzvSj8qWOwjSr4meDRIh4sjnb8Ir7+W/52
	OXp3sZTQIWj/g+hp/Hd4lUzNfQMrGetw0cpsQ3+CZPK7avx90h+YjzOxN5mONZI=
X-Google-Smtp-Source: AGHT+IFcVqxqtEj63q0t7fchOfzrlKAVFuDwmZJ4n8qfIqVbAeEYL3vXur/5eNhzGwJap/Peq1YHNA==
X-Received: by 2002:a05:600c:1e07:b0:43c:f61e:6ea8 with SMTP id 5b1f17b1804b1-43d509e3b14mr173288785e9.2.1742918871445;
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 3/5] arm64: Implement the ./configure --processor option
Date: Tue, 25 Mar 2025 16:00:31 +0000
Message-ID: <20250325160031.2390504-6-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

The help text for the ./configure --processor option says:

    --processor=PROCESSOR  processor to compile for (cortex-a57)

but, unlike arm, the build system does not pass a -mcpu argument to the
compiler. Fix it, and bring arm64 at parity with arm.

Note that this introduces a regression, which is also present on arm: if
the --processor argument is something that the compiler doesn't understand,
but qemu does (like 'max'), then compilation fails. This will be fixed in a
following patch; another fix is to specify a CPU model that gcc implements
by using --cflags=-mcpu=<cpu>.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arm/Makefile.arm    | 1 -
 arm/Makefile.common | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 7fd39f3a..d6250b7f 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -12,7 +12,6 @@ $(error Cannot build arm32 tests as EFI apps)
 endif
 
 CFLAGS += $(machine)
-CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -mno-unaligned-access
 
 ifeq ($(TARGET),qemu)
diff --git a/arm/Makefile.common b/arm/Makefile.common
index f828dbe0..a5d97bcf 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -25,6 +25,7 @@ AUXFLAGS ?= 0x0
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
+CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
-- 
2.49.0

