Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F332E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LCQZ7a2m"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-333501e22caso6168852f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548125; x=1703152925; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TguY2CRPZsDbC7EwriWWWSxwKPNn+kyygMIufDgE984=;
        b=LCQZ7a2mh9fg2oRM1vH3N7xLfYlPCNx2Gpmvi9jd+dDtpRpvmMgdBjWD8Aiy0A2LIY
         P3OlEvgyOzu0lOY4eYLjtMz5JakmpIq55d57J3J7aOoszPswkkqH7SBmKgYb/4fRbrbB
         fCx8oc6fOLN/dSpDAImdblTAc/5HphoWxLRt7xQe0InK2RFlZbTsmQWUwmh6FQPh56nx
         EpVxkNMF3I5i5Kor01oZZiLl4qDGymB+XuqrmRsiIYtk7NN4nIrPr4frd2SP49PXbw4L
         knhWLwo4y0XMO52le5vMHB1RwPYlu3MBE7kEJHKV87oX9Tc2wOy/90H+B4V+dIgyFoTs
         RhGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548125; x=1703152925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TguY2CRPZsDbC7EwriWWWSxwKPNn+kyygMIufDgE984=;
        b=PRfiwhn2/TWXagDevaO0i1Srq0LAmc7QTzWvLjvWt6lMZ0SXX2kbsByUl5/CS9v7uo
         42w81lKa1GJkmiINwG+7NtxGXLWY348gn+gp5cTdBQEhu9z9R/EyMVyhl1nX+fd6du0c
         Q2oAvd7Dp0gI4K2aeZZhIrd76vfv6BOWNV2MxFDReDy5nZzMWdo1cwfeU+ir8mezfx9g
         metOO86tgYAmWDe8urG4VqoUL/voNKaO0XzcBj6pZcUcsoHb7iolWxWIVN99W8DUPXXT
         4gRPBjFGv518fCNon8p1jtmngRi+WOWewpiynBsk60xaENyJQeoVDwYF2kEB38JkFDMW
         WZVg==
X-Gm-Message-State: AOJu0YwpE7PUCb2foP2ZbXeNBmF/077xfekWWuRBYG5iykHW1PVfdjGz
	XwJJo7c7bedZQWTcz85oCTUZxsc5LVCntgks+MqTFLrty7G22LOZWBp2Nti84SYqir2amGK5+TO
	J+RkOzXS53BALJmOoVagXt5nPVXBzWbqoMa5fNy5ZsA23Oco/GbGM3EFPbXc=
X-Google-Smtp-Source: AGHT+IEzmFHlBxyZF8O+LbvH0QlS0e2LiJp8Xgrv+Xa+5a0SbCpGGf2FmJL17DH3UiYhv0VTN7gqNhALtw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6daf:0:b0:333:543a:9f9b with SMTP id
 u15-20020a5d6daf000000b00333543a9f9bmr52179wrs.11.1702548124858; Thu, 14 Dec
 2023 02:02:04 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:42 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-3-tabba@google.com>
Subject: [PATCH v3 02/17] arm64/sysreg: Add missing ExtTrcBuff field
 definition to ID_AA64DFR0_EL1
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the ExtTrcBuff field definitions to ID_AA64DFR0_EL1 from
DDI0601 2023-09.

This field isn't used yet. Adding it for completeness and because
it will be used in future patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/tools/sysreg | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index d596be2599d1..a8e36640c027 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1189,7 +1189,10 @@ Enum	63:60	HPMN0
 	0b0000	UNPREDICTABLE
 	0b0001	DEF
 EndEnum
-Res0	59:56
+UnsignedEnum	59:56	ExtTrcBuff
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 UnsignedEnum	55:52	BRBE
 	0b0000	NI
 	0b0001	IMP
-- 
2.43.0.472.g3155946c3a-goog

