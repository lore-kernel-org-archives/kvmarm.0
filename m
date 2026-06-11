Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CBD3BAD82
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168988; cv=none; b=MBrPM2WT+oGZUUj/NQHfojDuh8402htPXdVH9kqDUf2KnIHJdKdTeIBzEEvFQPenIFA27swz7ucNp7lMPhVOyZLeBVIQUDTW+kvN97rMl/3oCzxxzvmlRNtKTMxN8m+5KMsCnuSESxuY2tW0VO/bbe8GiOs7JTfscQZ+eKsu0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168988; c=relaxed/simple;
	bh=jRpCD0APJQJzdI/qHcB+R2x+oqjo5ZHBphi5nBCLTlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4dd/6vcMuhu4eOy7A3SK2a0VvsIsb0l5QoEBkn2vDc+wuTbiWBo3pBXqzE0TqkaN1TLQrp+q9Idls7HBwly3CbeuOQJxW54h2wlsr7FRl3Z7ElZRylCgzPJclG6XAg/ttOvvENJkZODFsakcbiVes/qO2QUeZGTFubq5vBDrXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diUZF9G2; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diUZF9G2"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c0c2c7e0c5so51207225ad.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 02:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781168986; x=1781773786; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4ImL4/aVkkVLk5cOjMd/B+1IgobNJsKFd+JPQDzmRg=;
        b=diUZF9G2jK/ONtBK4cZyWyzOmysa98Zo/lYfCCqeJlJgp1gyu6KXlwx9ww+g722qIX
         qJJCtvVtEQoXHfSIB9HzygDeES+peuOKEwpQnv5OQZCIeq9wHSr9geowLw0ISQAUnpED
         6vwIShy+wJlY81FPYFOKpgo3LL/k+AB7459Mlf021rxCg80wvoziK+uBFByMka3KZCYN
         NvPxtoCjR4vz5LRZivKHtOOKBpcg7yG48NrleIMrDl2s4RqC2CbaegSNIAHhNsDqlG+E
         VYxEueMr7mMGUYjz+PHGf0G+pcIfipQMzFBMw+Gl/qbFIgnqQVTcM/lU8qEYvYXOh4o2
         52aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781168986; x=1781773786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k4ImL4/aVkkVLk5cOjMd/B+1IgobNJsKFd+JPQDzmRg=;
        b=tWs8FSLIj2X1GcwN+MsFTtFzJhiT94FRe+HdLnet+z6R/19VZ/HHJMMYa6nAnZ3xM7
         PCreiFErWgGrVWNvgJ0qq1u/+lQtLGn6ipZcKj9miIkqL4nBj8EKCKvujn5Aue8YXFqu
         a6EyCMj+NBkVpA2ykZb5W0BuIgGoaW/bttY9g1hnf/jM2phR8y6OpkP1MpwaBpTujkvH
         VcnBp0qyEqjJckPAVVRbjwllCXX8GXikLIlEJs0kMd04o/Bet6PRe2TcpJESJc11aqpC
         2efd4yyvSNq+E6BnMqF2KO2ToKnug6Al48jcxpTuJwzNgirIoIqC7YwsvNuz6j3eO+Dh
         r97w==
X-Forwarded-Encrypted: i=1; AFNElJ9daSs6Pd58glfZTQ6DF0OlEZL8rh5uFM+0jR5hLAvAEATvcoRxiuPC1pg/q2BCijVwW9sBTdo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1njpSBtgr+mYkHHcl1Gl4SuesylFyGMR4RHsA41dtYzl6Iuq9
	nclpJlgiqPDdokpSzz8s0dIsXdKvIjbwJiAsjq6H+5AdtE/yWjcPx5El
X-Gm-Gg: Acq92OF5AVzGZx5GaOKPb1Jdn6hQqF/3Qo9TaLAIiFclm4JMFBvAnjMaSBWewmFCVng
	7GJWsXVWJpN4rySx1t9uT4FwkbLrxhEU7KoGJAFjLN0Iu+Jv2t5vpba5QG/HJDp5dQ/bTqqIg1V
	3JS38IR+WzekXLwvNE18tL6/RDgaaO68ei769XbLSsJL9rI2OfS0qI4QVRDZe12cEJC3r01dhK2
	Jd6z2ntKkShg2wna2KOvHYJtLaHXBKPXVOLU02aDH+ZXNM9hOnwxNXuovwev26sR87uDyvtvR4p
	hkrHirC6g9Z6DHNzFepDl/lWE+I0Q32uzqlhler+G9t9oCVo8zLzot2sOFHYqlF88GP7xWIMtKv
	qFToT7hJpFtAJ1Fs+RdkavyY+HuuJldWq8bM4MLpu0NgE5my+HvVDVN6cyrsAGKRaQuMdnnMuPo
	+J2nDT0U7AZ/XJ4+NEPyV+d7vib364ko2ixKI7hAjJSoG7bkDD+eDCxKKEdMjk/FcknQ==
X-Received: by 2002:a17:903:2342:b0:2c2:27be:39a5 with SMTP id d9443c01a7336-2c2f2c63dc0mr20752995ad.33.1781168985853;
        Thu, 11 Jun 2026 02:09:45 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:4a46:1ea3:200a:5fb2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f8792bsm279519355ad.23.2026.06.11.02.09.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 02:09:45 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: dongxu zhang <xu910121@sina.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>,
	fuqiang wang <fuqiang.wng@gmail.com>
Subject: [PATCH 1/2] arm64: Add MIDR_EL1 RES1 definitions
Date: Thu, 11 Jun 2026 17:09:33 +0800
Message-ID: <20260611090934.84469-2-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260611090934.84469-1-fuqiang.wng@gmail.com>
References: <20260611090934.84469-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MIDR_EL1 bit 31 is RES1. Add named definitions for the bit.

Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 7b518e81dd15..4322b219f79a 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -39,6 +39,8 @@
 #define MIDR_IMPLEMENTOR_MASK	(0xffU << MIDR_IMPLEMENTOR_SHIFT)
 #define MIDR_IMPLEMENTOR(midr)	\
 	(((midr) & MIDR_IMPLEMENTOR_MASK) >> MIDR_IMPLEMENTOR_SHIFT)
+#define MIDR_RES1_SHIFT		31
+#define MIDR_RES1_MASK		(1 << MIDR_RES1_SHIFT)
 
 #define MIDR_CPU_MODEL(imp, partnum) \
 	((_AT(u32, imp)		<< MIDR_IMPLEMENTOR_SHIFT) | \
-- 
2.47.0

