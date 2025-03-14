Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1A6202993
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967480; cv=none; b=HxevrnTIh5Tqjc+HAgixRltYrdtx5E5p36aCNDoQN+sZaPbXYmb5d265pzncp8RX2uUveNmO88q+isWBe4WnJDxGw1iCLLBWym76BywTb6BhQaWPARcD0RtXO4obMZ+EAnZo3FBTlcauI9Bzm+uC+70chxhmP5H17T39/ZSe9fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967480; c=relaxed/simple;
	bh=DtYKD0hNvoy2Uxc1fJMAJI5G7nMcQlm4w8CtL1HgE8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thDyRUp5ppf9P45nIJYWYmRs1FKgSHRcgp/tzJuDDk7VGXKVIydEaxBVOGM240BG2IQQ3jUCdoROGeq2r1h6E4+tAVMctJXqQ0Fl6HCsKzHlZWml5F98FivFLgWT48Lg8k/4z4K9RRuUdr0pp3cyboUm/5VRN2QeEbMFM/7jg0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i8Sb7nOv; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i8Sb7nOv"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so15325245e9.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967476; x=1742572276; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fRHRzXgCjmP/bnGMZgkYHknTcPw+tYfWwUZWqv1wRU=;
        b=i8Sb7nOvq0Pu2JCGn+iOUsJAqV4f8t0o78uv3/93rS0jPWY1Ff1ZnjDPqiLBmSJebV
         HGdCnFYywxBZTUimhJ2b13UmQ0CqToy5L0YRxX5ecqQjzkuZdw838rG0rHbOhO22+Q0f
         4ukCh1B87RGUxECzCQVxmxJi+Evqx7fcE2msdcMGtuZFWsD4RPmpWwUuaAwqg1KXB9SQ
         K2lIgo5GP834royuUJgogDzMQul1AuPB9o+VUXCWFp0DGtlBBwHLPR5fi/E5HFXd40A0
         20Iz9zPutElPd52p+KGswCGaMGU9m8vVE18gt7eZLiN8IfI+cRZ7BmxA4SU9saIYynoP
         qzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967476; x=1742572276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fRHRzXgCjmP/bnGMZgkYHknTcPw+tYfWwUZWqv1wRU=;
        b=ruAtihFdg8Er9fwGkscsdq5rdv+yZbQxJeediOHCrrA6AC2tpZC+Ioc8OtT6mNMCU3
         TruxYkdVc3JL3BFHJp+ef7gJOw8RC4lmLtoBHreaT5jQPc3DLFF2+4yNGxSR3Wz05VjK
         Wmh9ReRJbLTsrDzmslGmcoI/hfnfj66r9RvYH0o5KrUHt0DDg109HYmLnZrWpCHa4bw7
         jwdX+XwSPa6lYI+E86Ah4VUaBfTvMWYRCM4xcpakEoE+HSjm5fSon2CM9tGsZVRZoTif
         c/1EDgcWyRK0Edb2HBmKUZ7nwjPb9WxFDb7fVq5AF3c27XjX09kO5isEddF4Xsyd8ATJ
         KYbg==
X-Forwarded-Encrypted: i=1; AJvYcCXm8muhWkY/APNGz6BVB3h/xwGPWApkPOWLxyvYvlem057EXsp7VGwKBHIcWQotoFaa8FT2HbA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyByLXYIPvB5ea8VJSyL7LXXW8aWUK7XsKaUSVgJBtwF56o9ozH
	8yskSjNZD0miwe77b+1JhwRxKj6a0DOC6n2T9zkzsuW8q8JoguU2LwpYEh8Q4wU=
X-Gm-Gg: ASbGncvPbOHgiXorCX9oI9EHAGk2y+UYue6aVFkfC3oU9Qiqhzk/N36KPAFPHEEuFwk
	u2U8agffWO/bUr8qTFE+YSf807BOpcleJN4/eG8nNq9439Udfy+ISYjhQrkB6UgPgN8ydphDybg
	4RojbYFtci+Nkjavq5ADV9aHwtGl0c3ttJc++E38NMKJ/93Py3DlyOjzO/soCOXnehNUmgcFTgX
	bFmIAfPjEJh0JrdRdTMDV04rzFVGyedd99vHrErCgccH/8C6QwUlpB27h6iOfELYW7xmy+4LAMH
	kkL8i4qsKgNQFv2YHSsS2Rblfu0jbzYW+FyB9PjTwpZUgueQd4zT2Dq4gQ3Jvzg=
X-Google-Smtp-Source: AGHT+IF0xfqiSOAD/aXN3C4RaUAgjkDnEUSmI0lHDHuOw3S7x9Ps8i6yZGeRqXqx/ijFDdbau6zaiw==
X-Received: by 2002:a05:600c:350a:b0:43c:f70a:2af0 with SMTP id 5b1f17b1804b1-43d1ec8643amr43633015e9.16.1741967476398;
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: [kvm-unit-tests PATCH v2 3/5] arm64: Implement the ./configure --processor option
Date: Fri, 14 Mar 2025 15:49:03 +0000
Message-ID: <20250314154904.3946484-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
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
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
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
2.48.1

