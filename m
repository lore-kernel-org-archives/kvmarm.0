Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F0218F
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 00:38:47 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6667e221f75so627395b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 17:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686789527; x=1689381527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LNogAbOui3VcxIgpFmFmpIdKc1yO2VTsr+3l0iF/r34=;
        b=Ga473fOoHsGbkffFcKvrnx60Ml2oDlstulm5s40vgRYt857O1tovN4df8/GF7tMwdX
         enn872ohiUCkoVeM45Lq5/HShADOjHcOm+QT4lKIScuqQhYvcV6YtQpm8c96RUCieuht
         PyKhXuJIK1jkNuLCvwEiOQ8+jtRPBnBkwIXXVO7eAlbFCLqMJBqHKldVfS3IWTgcmvxQ
         tG1MZT3R/Bqa5Hiplpg1r62Ll9zoLal8Adp4a2iyvcKbr/3Ihy5H8izI/Ez3cwdP9hMR
         T6HW8y4o/EAvdOvTnW9VgaXGRb0/p12zmCTXpu9HXp6zjpCgbUXd9ZfpM7KRVzJmzpQG
         3IBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686789527; x=1689381527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LNogAbOui3VcxIgpFmFmpIdKc1yO2VTsr+3l0iF/r34=;
        b=Nd/O1i/SRcQlQ4eU18sk8+Cox05tL+6x8NjmXv3lUfwigKXuAqBSZV+Wb0MivjwzmZ
         3aOPAH88GG5Lv8JEONBr020En6b/5Kq10oa/cQrZOK1WhIAi3qyPf+L3FQ/SgFGj1wtr
         OpEb8byBunzmY09pmXiUUoypbXI/kLWbyc3AiRxrSPisb/RLa5LaNTdEX0ZLdBbkDSx1
         VMEyNI5uiotRrSThbE4NolHJ/Xi3lRg9aZP2Zs+P3jvAOkv+H94ZzDn0ZV0oO8AY7qjy
         QPHuzKhbYQ+Mn2icYluXkeNdsRnTSM6V3zakOvU7XrhPU8ovnVRF08pBicqs9INbapwB
         tNhQ==
X-Gm-Message-State: AC+VfDwxwWIOxUrjq5hNqr6kYdhdLtCwgxYWrr/8NZLsGrSqdl4R/CiA
	SGJ4uIYcowYMSnnivrdb03s=
X-Google-Smtp-Source: ACHHUZ4cRgURBq0pdeq90UORGtG4YXx4LfbGh6ow6l9kG5q/BjEJEY0fZc/zOgDxxhrlxrFwoV/noA==
X-Received: by 2002:a05:6a00:1594:b0:657:67be:d1c5 with SMTP id u20-20020a056a00159400b0065767bed1c5mr3939763pfk.27.1686789526777;
        Wed, 14 Jun 2023 17:38:46 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x1-20020a056a00270100b005a8173829d5sm5478597pfv.66.2023.06.14.17.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 17:38:46 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] arm64: timer: ignore ISTATUS with disabled timer
Date: Wed, 14 Jun 2023 17:38:32 -0700
Message-Id: <20230615003832.161134-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <nadav.amit@gmail.com>

According to ARM specifications for the vtimer (CNTV_CTL_EL0): "When the
value of the ENABLE bit is 0, the ISTATUS field is UNKNOWN."

Currently the test, however, does check that ISTATUS is cleared when the
ENABLE bit is zero. Remove this check as the value is unknown.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 2cb8051..0b976a7 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -256,7 +256,7 @@ static void test_timer_pending(struct timer_info *info)
 	set_timer_irq_enabled(info, true);
 
 	report(!info->irq_received, "no interrupt when timer is disabled");
-	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
+	report(gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
 			"interrupt signal no longer pending");
 
 	info->write_cval(now - 1);
-- 
2.34.1

