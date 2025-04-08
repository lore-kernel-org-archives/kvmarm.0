Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D220A20330
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 13:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118467; cv=none; b=jbPjR5bQQmLfq2oRHRiIE6OOTlxewKseJ0H3n+ypSwCwTConqvIwbeGmR4dDqJJ+HhpcNOyYgBSKi6lSeWT1E+0fznLSgCX3zVPehyn2oOH8OBWEVPXBD5uE1XrxybxaxIC24R9d2O974D12DA9zP4c4r1LWVTC+h+KHwmoHlsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118467; c=relaxed/simple;
	bh=DjE5lydHNpWSKlp2OS+ArgpAXc20b7JX+EYn2yeg0Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHk0mrPRJVCQz4M76f33O3RbqhL0HT/RlWMwKuzh5SFuiChYal375om8rkOlfLaah/YZgn7Q9UT+0scWh0Z2GQshTGzSCK6Q+QGDqnNR2/2QIqbFDsZYhMcbETYqsRpBM1jXyfunoI1QyoWIinGsk8/QSrVlVZRJiCddl9x/9Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RE3z7G9w; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RE3z7G9w"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so3254033f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118464; x=1744723264; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=RE3z7G9wgvPEm9pUSpe7k6F35N+e/z2QL6+QkVOQlGVBlqU7La1hVNbu8ysVbfYZYn
         vRtzWu/Mmmif/8ZpkG2gY+nGfUFiROAIq8MM2aC+OPfJ9afwiADN2PlaGerUy/GhJlLw
         wGdi7EoAthSSLNFUssFiaNwPz2PNuGltdj8FDarfrh2wMt3GG/+fC3YV/26ZK6drVmxj
         qCo+84TMHlGXX4OOAv0GvQ/lR35o4x5ar55+ws3g31Qg6mydN7t68kX6sld6/+GmTdI7
         MFDieACpwIlfYl9QimOW7QDoQGU6Y7LSwp8niThTgUAkx9zpZKw2cfj0U5E9lg6RtTXf
         IrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118464; x=1744723264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=s0/WyG1FDQ+3UL69NpXn7OV034ZCF2Stu2DBn/4yDj/KWSOG+IWcfYuDzw7amuyfk3
         22uXOwcswqsA2EqJVeBn0GLRJBw8kvRSGifjODrP8kT+8ufXv50nHICMamftfOulZtUS
         ZB4Er+f/r4kbB73AHIDwkhoGf0VFsgGs1dCix4g9DNt+wwewV/vGqZPTEzevCLL4NifJ
         NR/thI9WGyWj4IkDQKNIRskWiGGY+yJomh/HPUG5kfOyX+DVqGVbF4QO1wEA83jbgc+z
         ZYIijFcfcUPllHIngJstEK1GdBw+aGRtK16XvKrAVzfc6jTs2MLUjGLYQ5YOgvXFhFzp
         zc3w==
X-Forwarded-Encrypted: i=1; AJvYcCX+5uw/w5EHEPJVfZ7AARgXA3V1wCppZTAHwxKpWbbRMNK/2NMe4ETtJWi9IztTCGSOVi3vntk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNh3RCCu7B2XqdNK9ki4BT5ZUcsWwhy9AakGeVHwaxKYPnF4S7
	Y3+lKHbgseAb+6n7+Fmc1+U8dm5SvznZaNOmUivHl/IzlpgJj8vmWUHxL491JxA=
X-Gm-Gg: ASbGncup1qb8oZZNJSye967kmgEV/etXSHm1zX8xY+YI/1UtdqYyh4XXdqbq81SVmKx
	2bb8Lw9K8rJuWM43iOV9DSXZw4xTVzAAiGvrZnVeveJYPFjerDvDrKsXPE/WZT3luhj7vspPYEB
	3L2k1LIJkIdcPSitvYPSIzEEOoIEBJDx5XZ8pyE3IvG2m6m1jByCgNPRMkhSz+IYqFon5vUKNqK
	q8qiZ7Qtk43Izah9OtS/gpDf9iWZD/PGCmk3TWebuXVjAA+k6Qoii/J0XTIDWzVt8jvJbgiEBR/
	jks/nhCNHo5QcffntodtoOq18b3ehUhdm7T7uu1k2y/x8auiknhkqjl6PF8gxRU=
X-Google-Smtp-Source: AGHT+IGEYZcVHqPxh9b9iWTJrtArQr/utyYTQwlK58Bu3joqs748+JSADbxOpv7hF62mBqzNbjJDBA==
X-Received: by 2002:a05:6000:4212:b0:39a:c9d9:84d2 with SMTP id ffacd0b85a97d-39d6fce0eddmr10745293f8f.46.1744118464024;
        Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:03 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 3/5] arm64: Implement the ./configure --processor option
Date: Tue,  8 Apr 2025 14:20:52 +0100
Message-ID: <20250408132053.2397018-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
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

