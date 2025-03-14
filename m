Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EAC202963
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967479; cv=none; b=k5JIo4fjKuScnD6XfnDub3f7x2zmrjF9eXRBU0YQw/vd07mF0b0xMeuax89Oj5x5P8FtamMpGDjUgeyqmAKs+VGt7Ym5/h7gprpcR7frmo7rrZHwEQpOhqtSz70qoUQnViYJEU8ir3irTQHSJY+zvNrhz2X1n7/7UkchSdLMxro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967479; c=relaxed/simple;
	bh=kzP55/MIfAnJXYhci7u8/DYGzdl4OSe501J7B855nOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emC/FV/UNc+we83HHAT83ez/zOdqcAmVZ7Q+khbaEbZUv1XP0Y1x6/GzcxDC9TP/y27Qmx7mBphvbCbtAekoRvR28pD0/IRrEa2WtBbNhKHXoQE83snS5hC6Ybei7MF+h9XEmfgZtfV8rsY4c3Uu938BqwRFloVwdN3Y5RR8CCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w19SL070; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w19SL070"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43d0618746bso15754715e9.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967475; x=1742572275; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZgQ0Ki7S7zg6nzRN4ZWX4z5ZVEFjxmGZvTrquNKZxZU=;
        b=w19SL070yB892GmUUEYMmPDuFnUSWIrwOn3f14csv3yEzIAPkovPJXchCyeqN+/Hb6
         +OV6gZ7i9h/6oCotcvr8wC33/DKWyqc7+LS5KEl8Bjoz2LSawMXQ6ep7lgdknDOyRzn/
         cx1LEre/4CizoCnoR/Mqpz5czGzHGuDfA7V0B0wtdAiDUyYHbr7inJWjqQSu5Fk9y/nW
         uvZJ6JBwueUL7Q1GeGQ9F3d+zQl27YgjA2cjqSelkEneRfJoGfyJGSJen/CeoqezRnyS
         gCQW2Dd2UIivecM+OrE34sAGdzAeE+ZIImTm86ixOa1UX47i7mgDjAJ93YRZE8JwiWEA
         cmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967475; x=1742572275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZgQ0Ki7S7zg6nzRN4ZWX4z5ZVEFjxmGZvTrquNKZxZU=;
        b=kqgjr122jPnfjPd8XPCM5ceUNJqeH0XtookYE+a5tL5pR6YAnUMVhrd2dd5I6mbkay
         MFWjm1bW51cAolZAqK2hsuNNwxr3DNGL/L+h7yK6FiMdHmLvJSJDDKtz4t2e0sqAvsi0
         piQVaWt67l2SMJIFr+SFH9Y/eC/dEZutAY9mQ5mP5pHVC5O6CucrwRkG50j7sXsJ1RaV
         R0ABgb2tf5/ARK9aXA48DZF+IDgEJDueUOg6xSSCk1sCWSS/3FeqlBJ1N6Hl1uenIc2x
         RRMegmACkrPM0f6c5ggstwVRnBEW/LKeRaG6s804X3M7oOk34pjHN6Hj5bcyszgSS5J5
         MaaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZyDtVfpF8feLVSuySmhvjlsmKzjFSx5PcgBcvJFZq/36IUY0ea+lfPwKcyvD5eaY/cczEpy4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRtyuFwxhoJcEISB5n2IKZwMmEmeAkUWJLcaMPxs5F0CY1kg9s
	0RBLRE3NVlM0ePdv3RCQwZw/adH8wRqtuik6AXvimNCPG34vRY+NMfPMHI9Xkzg=
X-Gm-Gg: ASbGncv8LB89mYIngyd1Gp+48G5RHkjDLeKeN3sx1pvlGSJPgT0U090S4I9kByyQvL/
	HRKs3vzKtSVER+IjmtNyZbYzABgiN31HrZaKKKOgwY0Dk8ChOcG69Sow0e/D0+8dvBWDoKkjTHg
	XocDyFZz/BownObHomNnVJC9wv0RDTp+ml3Rf3HvxJVP5FV2QM8lgsRTZ81p9vSpYAAvL+Ot4dJ
	W/9YViXEO135BTTULKKH2lMjKvVfuxzskOlWKi8ot4V7O6PlddSm04qYVd0DfQCXPfvNUEKpIza
	bpRAlLkl006QJvDvPGdQXoCVuDEYDJ4cd+CDZLXdDgA9c1o8nALgajVJTcDLvBw=
X-Google-Smtp-Source: AGHT+IFLNDlpPyRHd7THTJueCfShHv+cshQugLdnBwo9BUmrTvt7xn9ewfp+VyqjXp3lJ+1TO4LSpQ==
X-Received: by 2002:a05:600c:3ba6:b0:43c:eea9:f45d with SMTP id 5b1f17b1804b1-43d1eccbba1mr38605875e9.18.1741967475088;
        Fri, 14 Mar 2025 08:51:15 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:14 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display 'aarch64' as the default architecture
Date: Fri, 14 Mar 2025 15:49:01 +0000
Message-ID: <20250314154904.3946484-3-jean-philippe@linaro.org>
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
---
 configure | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 06532a89..dc3413fc 100755
--- a/configure
+++ b/configure
@@ -15,8 +15,9 @@ objdump=objdump
 readelf=readelf
 ar=ar
 addr2line=addr2line
-arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
-host=$arch
+host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
+arch=$host
+[ "$arch" = "aarch64" ] && arch="arm64"
 cross_prefix=
 endian=""
 pretty_print_stacks=yes
-- 
2.48.1

