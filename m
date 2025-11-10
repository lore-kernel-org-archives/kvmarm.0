Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDC828000B
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 21:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762809061; cv=none; b=fRMpyW5hJR0ZIdU+/UnrFCf3Hv07bxngjfc/MgILEM6mkOaa6dsJ+zRwV5UdkwJPsNGOTD+KxJhNRoFxchi4Q3HFio9fcHXr/fdGkahdLmiXBZREjfrxlBKN6geZTVaqJqPtXvL2Vu9xUGZalHUWQ3G4KHXDE1gX8B0OC7pJXH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762809061; c=relaxed/simple;
	bh=5A2x3M04AnvOkfewgoNI3cPsxt1f+pgjuFoeucr4xmU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LShFtIynBKD0/e02NRuOiQdHOJOSIa9Mu2fS2Jz/sacGu+pPq3Jz/zMy1TgSZdmBjnvD3QdbcK8Aci6zMzXHaB8xofU44p2jYBDTcGV8O6V2kBP+H6MySTgOq1UsITbu/W2yFdeNIh7WPN/iZMap2he+26arqy3jvpkSRMuyId8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cNy4vuPp; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cNy4vuPp"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4710a1f9e4cso26898345e9.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762809058; x=1763413858; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s6pHR7F03/pIPTipT8rH7/Q5PrxczVrwgluDM2gAtnY=;
        b=cNy4vuPp+dDITzJatApX1tb3unF1vTaW7yC2FIvnEKYi23dqkyjwN5HSQRLUUwsLe8
         PaIFGmo4YCICH2f2DiPPQRwroE/modayOLXSTPkrH7nRTCnSFALKvfF/td1dUc7Slbe3
         VHPcUwZSr8Li6OxbPgRYGt3OjRYvShbVwxTB6s/tgnEd6Y5IM6NdQ8n37vwHsQMkY5O0
         IXksj4PeD3QOVmfHMxOGSiUO3XFJxcZxqYg9rp5GUB1Ulaar1MRiYESq2vRdzw+Ib5h3
         kGE9xktNM8jMrF2w5hTUcz/+Oyn/F6D6lgMYvM6nAhAEvC3qOkHgkp3r4uBgQ3oUwTtv
         IjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762809058; x=1763413858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6pHR7F03/pIPTipT8rH7/Q5PrxczVrwgluDM2gAtnY=;
        b=CxotEhLj/qIe58I1s5XlZhIpmiTbAWvr36bL59GNijxUWOc8LPjI7JQXeTp7C6fk2E
         QSDik2DyQwvlo5iaBfJ6NTio9GdPUNjVcTgXmqIPLk3qYooBcem6oneMrEzMHrRFYW7p
         ESD/bUCX+qO3fSBWotfKGkcpqmSo2PYie/01YVij3azBs6bIn+jlwobyWGd4Ozef8Zmf
         fGHu+z1c0RZpnonyEwVy5T9FGCkfK/6ISpxpSB6zzkJYDHVo0I1VxQMwx+S5mCwafM1B
         YWcEtduz3hhuIpoiKfTQC6+/n5rHzr3CNh6MQuU78c39IL6rUAjmnyJ+gHftj7+pnIoY
         g3HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn2QJ8xwU/1kWyCOu9DOPwhnalOguW44ld+8W0fgB6ltVcbEvzUsspAZRo6uNIEv/VKAj8cM8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxxrLpCIRCl1mW5JuDBjuBhmPkGwLJdqAauZS4K2ti7KztcSx7
	dBelV4hW3O8T/AbJEQRgyEn1knT7RHW/XpwOgRs5qciBkdhL71eTssIO
X-Gm-Gg: ASbGnctbrAZJ3jehnv07oz4vSAuJyreLyujSpLlsIhaHkzhiNRXGSfQh4cXetFPqu5t
	K2iYNK0/wDhSPCJwkkHxbGXbPw8ds5RAUZDPyzSlwAlRLp+Or3ISx+pIgCL1hYUu2GPUVIJs+rc
	bSntR6YOrBlIJJed+93hg20O3KbL5/8E7J1Dr2EHu9SV4qDxiPRPMKUcZV7eFOJMDxzLpmiC6gc
	p4rfo0azmKfiI6raJ4VE7Dm1SOracMZl2KFgltzylSqJ5y76e2MUeoBurERIgKt1sERU+t0OpWu
	g6etIZ7SL7Eyge0pSRu95383lysrsnp1m28oEyNyO9Hi/HirqfN2YzhN/C2mC0v+1fofGCxxQom
	wTvrZGiEfxTnUEUdsbBSkxwOfPsqUoUXbR8OBOkiCUktL+/O4BJFa6y4Wbm6xAiH1rLq5ioFLKk
	qTPhLp
X-Google-Smtp-Source: AGHT+IGoIT5w+QUViZBORjTwCO0tphc5Rsw+ZwM/XoSTGH0I5syp92nB5jyHfqFFdSWjwPM/eSjHXw==
X-Received: by 2002:a05:600c:4c98:b0:477:755b:5587 with SMTP id 5b1f17b1804b1-477755b5694mr45928235e9.8.1762809057974;
        Mon, 10 Nov 2025 13:10:57 -0800 (PST)
Received: from osama.. ([156.223.120.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47781d68e3bsm1181165e9.7.2025.11.10.13.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 13:10:57 -0800 (PST)
From: Osama Abdelkader <osama.abdelkader@gmail.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Osama Abdelkader <osama.abdelkader@gmail.com>
Subject: [PATCH] KVM: arm64: add missing newline to sysreg init log
Date: Mon, 10 Nov 2025 23:10:51 +0200
Message-ID: <20251110211051.814728-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

missing newline so the  message is merged with follow-on logs
the change only affects console output formatting, no behavioral impact.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..156cd1a6106e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2845,7 +2845,7 @@ static __init int kvm_arm_init(void)
 
 	err = kvm_sys_reg_table_init();
 	if (err) {
-		kvm_info("Error initializing system register tables");
+		kvm_info("Error initializing system register tables\n");
 		return err;
 	}
 
-- 
2.43.0

