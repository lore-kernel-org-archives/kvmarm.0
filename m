Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F863D8135
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781188859; cv=none; b=eYoPOnB4dlnpRzg+2t+nuq5oliTBJedw1nn22DCgYuWbTBNwy7QfUi1s6i5q+KSf3ezqfaVI8m+bSfCsxf4yRzg5nGYCgKdJOQLf6d8qXrwLSaXePtrxe2qgtVFyKLQneVvgwQK0uBjjY6hJ2IISNPkj4aHjw4N5K1JqI8A1FGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781188859; c=relaxed/simple;
	bh=Akxk/lgy04fLltfbUcYYHUlwVsuQerKKzVJvjg+TK3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbSAZsmy/Tdi0mT5MKWC0jMFyE1nBAs7osjJdqh48yY0ta+yXh0U4VcjEL4DV21B/ilXEMnjmXmnBI8knjMSIg2ZA2LMEXyii2axllCXZNh5VYiY3dTXaNowhqWe5MXDKFahRsqyBdFd4MH0A4TrRW1RaHJVD2hNy+YrnOBqEGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7ehzWP6; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7ehzWP6"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0c379e8ffso55353285ad.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 07:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781188853; x=1781793653; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swEvIx2nUbUpmMkz73waYd0ROkdvdxB7mxOEMjFA3sI=;
        b=B7ehzWP6t4WleyYkWVaXptprRMxhmwev0OEMvJc3FBtVge6fe/1hzXwJXtPLYKaUQg
         426bQewz0YSJBW6DoYY6PTSRPCQQ9jpZ2ISzP09PMc8pS5yFjwxUK9a6M1ZUWqefaBOz
         bs7ik6VZEsBD9MA4CnHcciFJl5Fuueude4V07+JsiFot9UWzfoFnmIK1Y1mE/1P/VOVz
         FofWTyOaMiV2zeqc6mJdNmny0MAfuaxTTw6MudstTcXA+b2WW1qOIYL/7qofPs7dCmT4
         sVTqxIVjf/XGls3NsYuVDo4LXsnRkia0ISsGVbgW9DGWAW3eaIr+FNiWbK5di63FkOCM
         AoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781188853; x=1781793653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=swEvIx2nUbUpmMkz73waYd0ROkdvdxB7mxOEMjFA3sI=;
        b=rLdTvbOld7mOdT1WUuzdLF6iQHCl7MPvOUNz/yBtQq9jU+lSizO387lmoyjjoqb89s
         SSB0kXTmDYRjJRAvXVTaKzLsv+S2SQthGSzh5zxoCfMsPODNBC0eos3NMsaSEvZSnVFp
         H43Ui8DWXioEXzF0H/4F8L0NnvM84f3lYjKzHpF6kTibFdxLB1TIMzaTEkocUctQUdRs
         rvtwxO1U38kGsXAjVjtDHyNPmvOEce8lM2ulD5sYA2lg+qowLJ11KLBaeLQeiaesa9pH
         qqg8cW/JlGwPl5if2J+zlgTBIw0vQ+MuV2bMhBpyt4cVpkN/xJXeN8Jpom5Bkh0AppPO
         xJfQ==
X-Forwarded-Encrypted: i=1; AFNElJ/gNlTN4Mu3a1pSptACAFNJKa8RIeQsIahkEC3Pf+jAr/8G1DArpJf94sywSXq6JUuNzp7LnOs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEtzMJpOaRila29f5huOnPFhIv3/ANmkb5y68S0bA/NM1P92SK
	I9cSW6f6F5/MRt0B3nv9Cr2lam9uUK51J0A5/m2fd1ae5GPnIEEZz3HG
X-Gm-Gg: Acq92OFK4mfwZj3VmkkxQCi1lpK2vxqx5xs41pZe7HKwXuIbsCboCbwS6bTXZTW6dl5
	7jqJzh2uafTFWUe/OIaOY5WLu8gi3SEL08J1y9bL/9PddeALLb40yDONdtzJdQc7X0xJH29v87l
	RCBpypXw7rz++d6jfj1QZjkP/bKsPr3qagH0UnKgQOsHM7qeOWHA4VpoEJoRZZluTLGbCrwSaQ1
	t6BT05lg/5iNJBNs5xGp2bSBI//WpRsMhAGQjku+jORLUj+vtGUUFsn4CjP3+uJISH1yG6H9asf
	966X5JSYCyrb31jRtN5bqttqXibhsD7HvGUeZDKM9QRcZDXpl+0Ok+63tQ75gzY5cOqe3YApsKa
	KFLCdf7S32IiYExpRXm08+vvJeN3v3a2BkC8zP/wwAt/QNlheg/0fsz3zzSchy2mMwJaAxqT/gg
	+l/9eBjG3rXv4cwwXR7Vk4s7WDGUzy4VOnsRJXKtliLcOwpT72VMR+EiuAC7PrGYfwlw==
X-Received: by 2002:a17:903:2b06:b0:2c0:c262:b919 with SMTP id d9443c01a7336-2c2f18dfddemr39224895ad.5.1781188853537;
        Thu, 11 Jun 2026 07:40:53 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:4a46:1ea3:200a:5fb2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c249aeb62csm161097355ad.68.2026.06.11.07.40.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 07:40:53 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: dongxu zhang <xu910121@sina.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>,
	fuqiang wang <fuqiang.wng@gmail.com>
Subject: [PATCH v2 1/2] arm64: Add MPIDR_EL1 RES1 definitions
Date: Thu, 11 Jun 2026 22:40:41 +0800
Message-ID: <20260611144042.97981-2-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260611144042.97981-1-fuqiang.wng@gmail.com>
References: <20260611144042.97981-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MPIDR_EL1 bit 31 is RES1. Add named definitions for the bit.

Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/arm64/include/asm/cputype.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 7b518e81dd15..22dc44d2de03 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -9,6 +9,7 @@
 
 #define MPIDR_UP_BITMASK	(0x1 << 30)
 #define MPIDR_MT_BITMASK	(0x1 << 24)
+#define MPIDR_RES1_BITMASK	(UL(1) << 31)
 #define MPIDR_HWID_BITMASK	UL(0xff00ffffff)
 
 #define MPIDR_LEVEL_BITS_SHIFT	3
-- 
2.47.0

