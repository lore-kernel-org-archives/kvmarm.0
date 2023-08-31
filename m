Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A1C11CBA
	for <kvmarm@lists.linux.dev>; Thu, 31 Aug 2023 16:22:34 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-30e3ee8a42eso547006f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Aug 2023 09:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693498953; x=1694103753; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5e1f1jwIr39xnfoPu0/5wZ+z+ZWuODpVrtDXgqFCd/Y=;
        b=YQu8b/F2eHGkKmhyyZDKrF+/BT+wappZoAXnkwyk/yKBg8u26A1AuGmJvceAmt6v7M
         baSbQpPxjKR4FyQCF+NUQ9CMkyOJ3hoELfum4oXRvk6/jdZm8phgTPA0P5xNmWYwdrZ3
         WErioaqGzagtpQ8nsUy3l9IlAtXAOwwYCSCNwYN34z4cW3OuGgkPoLAoROok+EtuKDsq
         zFqKgtzTJ1cqBfUbt7n+3kfS1v8+A9mEaOITI7izGPAeJT0LwrJ/DTGOgCQJ5gRD2Cnr
         QlozWjkON8lyWNib+zCyaCES0dDyGo5c5OB1/Q3OfxsrhilkE9IanNbZeeHNwPHsPyhI
         PZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693498953; x=1694103753;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5e1f1jwIr39xnfoPu0/5wZ+z+ZWuODpVrtDXgqFCd/Y=;
        b=E+WChfEV3FGxOI+hNBgMdf+TfpBiRyVsDU3AcvREo1DNDoe4D4riYYWnpO8o5hPAIm
         6LjXEL75j7V+fyNmFYf7W2NI4UaHs01/64+DCM/oGNSNvuIgw+8Iul81rfd+AhC5Vj4o
         H1NgP0CW1huFZ4NDcHIEOGynGriWMrbI+YA9rrNulX7mMIylUPP+RqTUnee28pHkI8yq
         W7GQbzQ+yn4zvIcIL/7xmpxPjq8/VV3LkTNhTm6X90OalAb1E7AHYr+Ia6YFyq5T0jDs
         mcGED1h+V9uqaqN55aUx9XwyUG4bEZl0CnKLcunuNrIpx3np0/kKRkGmHOiAzyelhBwB
         WTDg==
X-Gm-Message-State: AOJu0YzwYTKuhSKz143EyG+HcL9jyGzxzITPlBDlc3sjnI9BhYY5VV3t
	SzBVxSjDmXWJsnrGDepVB6GfY4IvtTUMkg==
X-Google-Smtp-Source: AGHT+IEQ6/d4vxUA+8GYooqvM7bVUjnFltIXaDlryCLf8phmepAtkTSn+zOcKuwc2JiGI5yx+H5W0tXYse/6Rg==
X-Received: from mostafa.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:333c])
 (user=smostafa job=sendgmr) by 2002:adf:e706:0:b0:31c:6629:a583 with SMTP id
 c6-20020adfe706000000b0031c6629a583mr87287wrm.13.1693498952747; Thu, 31 Aug
 2023 09:22:32 -0700 (PDT)
Date: Thu, 31 Aug 2023 16:22:27 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230831162227.2307863-1-smostafa@google.com>
Subject: [PATCH] Revert "arm64/sysreg: refactor deprecated strncpy"
From: Mostafa Saleh <smostafa@google.com>
To: catalin.marinas@arm.com, will@kernel.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, kristina.martsenko@arm.com, 
	broonie@kernel.org, quic_pkondeti@quicinc.com, smostafa@google.com, 
	justinstitt@google.com
Content-Type: text/plain; charset="UTF-8"

This reverts commit d232606773a0b09ec7f1ffc25f63abe801d011fd.

Using strscpy is not correct in this context and the commit
assumption is not right "strncpy is deprecated for use on
NUL-terminated destination strings".

strncpy is used here to copy parts of the string(cmdline) separated
by spaces into the buffer and not a NULL terminated string.

This breaks the arm options "kvm-arm.mode=protected, arm64.nobti ..."

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kernel/idreg-override.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index aee12c75b738..2fe2491b692c 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -262,9 +262,9 @@ static __init void __parse_cmdline(const char *cmdline, bool parse_aliases)
 		if (!len)
 			return;
 
-		len = strscpy(buf, cmdline, ARRAY_SIZE(buf));
-		if (len == -E2BIG)
-			len = ARRAY_SIZE(buf) - 1;
+		len = min(len, ARRAY_SIZE(buf) - 1);
+		strncpy(buf, cmdline, len);
+		buf[len] = 0;
 
 		if (strcmp(buf, "--") == 0)
 			return;
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

