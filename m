Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE80288D6
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118469; cv=none; b=lIHJP+t94j0VjED0wuLuigRDKABC96/ayGpkKiBrhKHQ5ksZyj6dG9Pc6aUPjDItTwGq0LcSNCsv/yLyio8Wzjt1qcyM7sZaNAWNTyuQbLiVMG9lYdJp/qKKw4b87SLAv6ojjsH1O7lmC7CSjdUWlwHMbaOwtU0qxucBhNarnDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118469; c=relaxed/simple;
	bh=FAOMWgEt4ctVlbmvUA0C1egHbjcgOjxR0NjUHUtQWeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFNlCguH47Ij/7ATZtf9r1N83Y2+acS7NSJmxZlLx8PsH3RL3wLNNrtFgejwWANyw/s/NjLXGkqkVGKT70N3HFtHEhZks12RVQN8X8SkNYRKsi2qq6WO+8MeQpeq/1WL0J3au/AD6LtOIZ4cu5Bke9AcabWlDHz2TGU+UpnrWEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fbuEt5+s; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fbuEt5+s"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cf3192f3bso54843425e9.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 06:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118465; x=1744723265; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwsED9xLZcHWSWQwNeYdiP1D76YEuoP7ff0R7pjjcro=;
        b=fbuEt5+sb12gFaU1JrRAr4xA0wlMrkwgK/7Zz0mloI+BoTZ/02W3chsZO3z05ecZbE
         ArlrKbW6a+r76VsV6vVo1Kho+1dDagjfs/0SbN+ICMjYYUV02c/H23UF6s32XFLuV8Xv
         xONviqTehD5YQaPS1ZXm8TWQppEaiqZR2cvg81lt0Mna8e6DoeBa+77gdN8eJWWrsx6c
         JYN7YVlTcJ/nkjYzDr20zqV1qEDegpuUPkZQ7hG7tmbRTDtDS1DxzPbL9DaEvzeWCrtf
         Lln88uDOTReJorgY3IqEPTqdU6velVc4PhGkm8OpE8hpSKLglTz2uKlZ/tJz2PsbfpIy
         RvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118465; x=1744723265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hwsED9xLZcHWSWQwNeYdiP1D76YEuoP7ff0R7pjjcro=;
        b=dZG9sF8SX3e2UFwCfEWvylBhbqUhIpsAFryxM/Uix+DY206fov+x8suEJ29yo3x3J6
         +3kWxf8XrEamGjCymwx+wDC2sib3Lhya0Vglb65/EjY9/3MFHHn0GP0kld6JqIr0sEGA
         Z5eN+lHbIBhiXMzOP49IojmIfDU7odYCgtHGEkMsibj3Z6Whi+/bi56PVv8e9u0uBDLx
         IMD4ohrQxfxD+4T8OCfLXPYE4538tiltlXMz3cEXR6XlWTKd/VCEmL3HcwN13+8JIAPr
         zaSPPKs0FcDTKetBE16X9M5ix1yJn3PE2tP6r0vXj0udhgQbFGxoFDLpMfuGswPP7V3r
         T9aw==
X-Forwarded-Encrypted: i=1; AJvYcCWrRpm1hMTBHNW45Gn0sxqboHJXy4cEsEpKM9BK1/SHvQ9ml8LG9g067j4WnaSvxMc2h1pqSD0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH1flkJ88Bkmt4/Ua4kqumOrQUCNHPKk0WSZh6AFa/RQuedp2F
	Nyu1k7IEK0nqB7vuyqtCh446hSKjps9nHMyNSkw3fC2Z/DNHYSUcGxe6p5u0HB368oD3an4cWhZ
	qDUk=
X-Gm-Gg: ASbGncvj+1FZnROVgbQKlQyEpLR0kW2NiCpmq1RFUSgXQoI1c2/MixUkRX4PvO23jBK
	nKFGp5BBncptPckJsDbhToOGVcUghqrv2ALSOZab0mz81kDkIlxQMVX/NMvXVSEYF9iDHhlMiio
	L/MFAhu4po58nypFHtlWmZT2bGX2yHTkyqfBOj5cQy08MNw17GjlyssLDXK3ZfTmVy7LoeBzj+B
	DlbD9vqFyhkZg3gx4pvaC6xeHKfxZM11xcRLLxqeFIlgZnO0WVkgvIIU+GaYTe2nJCmMWc9iijl
	0jg9WQ7iOaa+R/Ajy/bFSXg0SiBLQW77go2+mCvc3DDsifp0OtJlUqt5r3fceOk=
X-Google-Smtp-Source: AGHT+IHZICYsUrjLH4YNZEOnxXpyTAQfzZP4OUy8xi2eNeiSzDjWYngsdEatS4fdZh+4tPkiN92iUw==
X-Received: by 2002:a05:600c:3d98:b0:43c:f81d:f with SMTP id 5b1f17b1804b1-43ed0bf62eemr158443455e9.8.1744118465399;
        Tue, 08 Apr 2025 06:21:05 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:05 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 5/5] arm64: Use -cpu max as the default for TCG
Date: Tue,  8 Apr 2025 14:20:54 +0100
Message-ID: <20250408132053.2397018-7-jean-philippe@linaro.org>
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

In order to test all the latest features, default to "max" as the QEMU
CPU type on arm64. Leave the default 32-bit CPU as cortex-a15, because
that allows running the 32-bit tests with both qemu-system-arm, and with
qemu-system-aarch64 whose default "max" CPU doesn't boot in 32-bit mode.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 configure | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/configure b/configure
index 63367bbc..20bf5042 100755
--- a/configure
+++ b/configure
@@ -32,10 +32,7 @@ function get_default_qemu_cpu()
     "arm")
         echo "cortex-a15"
         ;;
-    "arm64")
-        echo "cortex-a57"
-        ;;
-    "riscv32" | "riscv64")
+    "arm64" | "riscv32" | "riscv64")
         echo "max"
         ;;
     esac
-- 
2.49.0

