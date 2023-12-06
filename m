Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990E91A725
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QF9iBH6N"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3334b472196so510400f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857108; x=1702461908; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+hb6XkMaA8wq8n6byWbZcgbzRuAU/Da9bRJr34V2lOA=;
        b=QF9iBH6NZZ5AyFhm/PJLCnMkhNp+ev0f/umcdgBRiibn5ZzQNIZbazggjKkx6BKmR7
         IicYd1/5tE2ozYNyKkzt+W6bQp9ws8zeF9Equ4baCaxn8vdnv+CvrAw15PIayIzQM39C
         Kwf6qMvZBxCssDcV3lHSqqeqBXI4/LGbQesAjXRln3jxMpeK9amBX7h16d65c3PsS5bm
         eGsQNm6fyeK79GFjLArxz1ZJbiCzSERqXcBngnSM/oH+uBDA9zyxKAoCl/YswSKF+cSF
         dLxI4pY37pSiP2n89t9+6rcuqiIDfoCttQqrHZRaQHzHDlYu2Ti/PVVsKuCPLk5xM1E0
         pIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857108; x=1702461908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+hb6XkMaA8wq8n6byWbZcgbzRuAU/Da9bRJr34V2lOA=;
        b=XgaG0GWxlOETc4H1Sc8VpNEx86nrFE8cnDU6Wul2535Y4xL9LxgIe434Bnq9e31l8q
         TKpuRQuZAGuqZcIabFgolOMq/PQAZEDuksz7GfX8VxnzxQdciJKBSLZ2b+jo8KuNm8Vc
         7Z/lRmYBnMtNg1KZqYpWeNKn4XGUTk1zLycfzz/9YFbpPXkmoS0STpM7TNDcF0lP0TjM
         XRXMiF1fkShtp7CfZYqS2u/3aN5DGtViv2VuwdljDnhuJuVkhk59jQY7Y3p52cSx/dC3
         xMMkAUkn+8FwC4ALboH3GFN1CpQLXoKyOxXXBng/tLwUbEvWKWVwcUzTKN1cznvDBDOm
         OlmA==
X-Gm-Message-State: AOJu0Yy7M+RCNKkZuwjmLc6R0H3X6gAC6BK+JP4dMvKrU0y6MR9p/jio
	+/DWXPXqYwXE2rPrW05qfEO9gTAPa+OiHe7cGauApSdWeBpQhb8aqYKBlYpg2gq33071cp6mUx8
	lhlPzOVu1d5wk5/GCEovUJ4hQgXIMJNdiNwZGtb+OuPs3ASr8qTIBzGxqXkk=
X-Google-Smtp-Source: AGHT+IFSPIaZXt3uxp4qWQADPeVuALXIH470f8vIbOpzJeFZxkCVe1ayPA4dezVGvXu7nvOTxIzYki2wiQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f1c4:0:b0:333:347a:581c with SMTP id
 z4-20020adff1c4000000b00333347a581cmr2799wro.9.1701857107866; Wed, 06 Dec
 2023 02:05:07 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:51 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-2-tabba@google.com>
Subject: [PATCH v2 01/12] KVM: Add missing HCRX_EL2 field definitions
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the latest field definitions to HCRX_EL2 from the 2023-09 Arm
Architecture System Registers xml specification [*].

These fields aren't used yet. This is done mainly to get the
correct generated value for the register's RES0 mask.

[*] https://developer.arm.com/documentation/ddi0601/2023-09/AArch64-Registers/HCRX-EL2--Extended-Hypervisor-Configuration-Register

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 96cbeeab4eec..c6cc8f2396e6 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2300,7 +2300,9 @@ Fields	ZCR_ELx
 EndSysreg
 
 Sysreg	HCRX_EL2	3	4	1	2	2
-Res0	63:23
+Res0	63:25
+Field	24	PACMEn
+Field	23	EnFPM
 Field	22	GCSEn
 Field	21	EnIDCP128
 Field	20	EnSDERR
-- 
2.43.0.rc2.451.g8631bc7472-goog

