Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B5925D209
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918878; cv=none; b=e6WXlWKq5N0JLTxnrW+wPE0xTKKkdZpIRiZ9KTngpR2W49RhELRxYxhu3UNHrXdhlV2oPBgOg1FhK+RukzhSb5VUNZSJm15CyRKMOjmQfkvMNX8XJFyDpeHFD5u9TW+Xu7DoMIp/B7lPUWUne0DFFUcDRrUalY49D5RpWlPkA0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918878; c=relaxed/simple;
	bh=Mjz+dmxCYSCza0clR0zsI/0WXyyGJEvEQrlUQgo2L9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFd7kOI7uW7B30FEhXRIs1HO6RABpeuYKFB4aDrDI0gLwvSyaxHZg4XcaVSB0FLeH+lKxwAXCnB658KxdsHr0IGKtyjtbRtaCqxXAx6nmURVu4tj/pGdF91KdeOuonPvgL2TVPkwz2gUwGCs09nEmDQc7XDa3pTjqttob6vgDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sBOPf6v4; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sBOPf6v4"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso39524795e9.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 09:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918875; x=1743523675; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fK2tkGsZN3Ahq6Hp1U78FfDDer2UDSH1+xmbDUmwofs=;
        b=sBOPf6v4MZG8TXJ6dmo2vmLSSCSS8OSjhD9LSByf9YHiZOsUrmy7A8PP1DfcdFWXpR
         sLS0TAyjusQO7L/5zf5KLlYj3UWrxR2XuVfwEpX3vLTDOh1LzayP8zOM7bOZIG62UU/r
         fXwy9jij5dRtP9otuaWhUU+RV+E3jg80/qVIjGj8wuc2AMoeSTiSSU7OviV8g5l8Y0TY
         yaTRtq+CZbY0JI1/SQd9fdP167hzogS62yjSL6vhYsWCDg8UMiETPXed6eI50Fn8a1GV
         Ssj2g59KUJVM3v/VUk/jkN46hRE9tAyjW5Fj+kC7WLHroq2alIK3Rr5xQxJPgcf7fYNJ
         +V7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918875; x=1743523675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fK2tkGsZN3Ahq6Hp1U78FfDDer2UDSH1+xmbDUmwofs=;
        b=d8mHVQkGss2UT8Ao/+47gobl2COS12OwWtZo6m/cs49TSesP2MJa4tPZY0TcUJPx+q
         IzL8NcAJ3FArwzvAHWkD2C4AWjQ0aRMUsx8n/3aUApE1qbVUip0nfbCQKPkkQ9idi3Qu
         clIFSs3tQw0HkMZldBywycy6F8+nGU/ET0R/SSTO+Ma08LexhKRqHHMrIH8CaOXskWV7
         OBjMBqTBfhL/3AoSODzqvGgy15tCkGPYvlW9LgumKI0K1wcZQ9/MBQKtTzFifo/WJavo
         FoaPoclvPBHg1ppCs0MV1fmjcQuKKAodusD8xrmfZw5TAQBjwQi9XH7DGr6yS/Te4n75
         wesQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpNVOSS7tajZz6hyY6gCKV0CuqOy8QsBjxTWJbPhSRm1kFfmw8pybJ/TlIAuzo5TLxFuvforE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/YwjYp0AyQ3PMDSuM7ZAAAu4J6DKApJ6rQdMZAZMTeyjoNwcG
	BzlSOrG+XP5n0n4i8UYajFLhWOCV16oz9A2SeeN8CK3b9Nl7v1QA3nrmxR+njfc=
X-Gm-Gg: ASbGncvAYxuf/pm4XHa3DIqNTALcq5+VbS30CPmJOu1MYntmXIO8q72wXK9mkIKrjht
	wVm9QKy/ZIAGq3iZQOxyXhHDFXTGu+o346OZb0YzKLMbIUfWK4W4bohHnoEICNMp7hdUbd8Q455
	MwiDk9SRiolB7Ty3cLUAsv2Ov2oywxcCU1SFq4vKl0xkuJrc2cWrTWngoLDNPV0mqp2I2zm6G5R
	iWGkPvp8E52DRXZR54viAnD8SrNt0NKbnEWyGX/TM0VBZdCXVGzNDVHPIViH3Oik/bRX+iV6VeU
	nW798U/4Jytfe64F2kFMz/yKdxzAGQgBjsOFJW8o3/2w2vJ9Wnee2GfsEXGBORVzhLbyV26dOA=
	=
X-Google-Smtp-Source: AGHT+IGMPJ/vzfbmk0M4EXxA8yEhXdjHJu8uBAqrg18jftKydcKcsI8JHQeO/UcY0KzF+hRvMYRRpA==
X-Received: by 2002:a05:600c:1e8d:b0:43d:a90:9f1 with SMTP id 5b1f17b1804b1-43d509e64ccmr178534705e9.6.1742918870382;
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 1/5] configure: arm64: Don't display 'aarch64' as the default architecture
Date: Tue, 25 Mar 2025 16:00:29 +0000
Message-ID: <20250325160031.2390504-4-jean-philippe@linaro.org>
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

--arch=aarch64, intentional or not, has been supported since the initial
arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
"aarch64" does not show up in the list of supported architectures, but
it's displayed as the default architecture if doing ./configure --help
on an arm64 machine.

Keep everything consistent and make sure that the default value for
$arch is "arm64", but still allow --arch=aarch64, in case they are users
that use this configuration for kvm-unit-tests.

The help text for --arch changes from:

   --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

to:

    --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 52904d3a..010c68ff 100755
--- a/configure
+++ b/configure
@@ -43,6 +43,7 @@ else
 fi
 
 usage() {
+    [ "$arch" = "aarch64" ] && arch="arm64"
     cat <<-EOF
 	Usage: $0 [options]
 
-- 
2.49.0

