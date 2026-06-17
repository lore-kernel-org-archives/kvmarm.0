Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFEA44CAC2
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707902; cv=none; b=M6VQegG2AzJxavjr4e67s/Pz/XvbnaPhLFKnWKAh17bjbiMQls27EzD1uzdsGYKk0Z0lN1xdfGKUHSULhy2A5velmsskZ6j0Mfims4AA0a5MvBktGvIoiVPejtASRwqs0+68q5vN+poSiHRLnO+pKm5zn3f+7p5ehMsceKX+k2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707902; c=relaxed/simple;
	bh=fmNOj5noDV8FLWJ+KWreCVyhF0Hc+7vAbj6fINFnd0Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c5Q6GvyL2Yr411sSvwts5Us6ni+q5fjMAgBlua/uodyyfwthRlGT5Bv/vO4EvB/wYfOmdrkNG/ZqL1yaCcqOy68EITPhxmcHIgY69X6bA1FEQAddr4gXt4sKQz4dwoJnBd5Z4TJQy0bSSKBKiyEXFYiIsQnOr6yfXr3g2A4r9Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iEvgnb2C; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iEvgnb2C"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45efa2f7009so4067037f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707899; x=1782312699; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iDAOdwtxrmt1yvz0cAbxnb4xCO26mPsS8gCJRaVl/Ak=;
        b=iEvgnb2CZ8ofu4JFXejo11TmhBE8SQM6XFt5EnS7f/Y0tl4TFdZ6efdo/sCfR1KY4M
         BFAznD51Ans7iUQV66G7xqCM26T5vq5ZU5XdrraoXUCi4EGZPjdY6/froQePrp2KaFSm
         ObFz6dl5Z9LtS/OOXw+aXU+2axZATiiZxWNoRT+NcaSqt9ikyE0MxzeCrkj+m24LGlj7
         6rRWvH9KtG0Ft++Qlu5kvm6dFJxIv2o4XVO2m2LMusF8ERDCOp/AIU9sIE+Dq9D/jzXu
         RuGoGUlJAqzy0uJW1UL5AU4yFEm8N+dwdpD3pAl2kRPhELS8ISqJosuSeI70XfbAKjCx
         B0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707899; x=1782312699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDAOdwtxrmt1yvz0cAbxnb4xCO26mPsS8gCJRaVl/Ak=;
        b=eIeG/gnzoGXHO307zHjGbWy4t9wG3TtWlHnHSUxUNS91nD7op2u2juqvXoqsRBIELk
         kwNKe1weXtj31kgIJHeC+P5pE1uyAb5+BTMChCubF+QusxzKlHeR6dNUifbHZzdXfAL2
         hWtngRKf7K4CxBp96z4TMwcOVH6Qvh0/DaAk5G5cAB2ju7/USLsuLNP6Mu2ve65qRl+/
         CTdaZesT5vJRa/CcpKP44PMLeyco0Ksfrr9ccmNoB9wL8pQ7druuI+qQCkiM9hBL3UlN
         UNshK7rf3a9vNiAb63N727namwukA1NO3qrtzMi1FqTbeQSNRyxA3Ftu9bIV+5Ca8oxW
         SGIQ==
X-Forwarded-Encrypted: i=1; AFNElJ8rnyQ5/a+P97NdOxI2iKC4dRa9HWcv79JurhDfGURGBbpltOV20mVSHuABWRTHQVNGu60aJ6c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/BXVTG3F4PByDoxFSXvHd7oyhPdD6Bi18bmHOoQO13crvosz0
	lzk5jGVh76HFJYomF4v1vJ+Oc61kcEejThzR+1ay4g6wSvnIjp+WvlIGFfbMc4WqMd7Vp+yFiAC
	5vbbpciYUh1NHVRqM9SDj0nHoHA4bog==
X-Received: from wraz22.prod.google.com ([2002:a05:6000:4696:b0:45e:e4d6:bba4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:f206:0:b0:441:1e1e:a050 with SMTP id ffacd0b85a97d-462374b8285mr5538800f8f.16.1781707898956;
 Wed, 17 Jun 2026 07:51:38 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:24 +0000
In-Reply-To: <20260617145130.3729015-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-2-sebastianene@google.com>
Subject: [PATCH v7 1/7] optee: ffa: Add NULL check in optee_ffa_lend_protmem
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com, Sumit Garg <sumit.garg@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

From: Mostafa Saleh <smostafa@google.com>

From: Mostafa Saleh <smostafa@google.com>

Sashiko (locally) reports a possible null dereference under memory
pressure due to the lack of validation of the allocated pointer.

Fix that by adding the missing check.

Fixes: 2b78d79cdf96 ("optee: FF-A: dynamic protected memory allocation")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/tee/optee/ffa_abi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index b4372fa268d0..633715b98625 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee, struct tee_shm *protmem,
 	int rc;
 
 	mem_attr = kzalloc_objs(*mem_attr, ma_count);
+	if (!mem_attr)
+		return -ENOMEM;
+
 	for (n = 0; n < ma_count; n++) {
 		mem_attr[n].receiver = mem_attrs[n] & U16_MAX;
 		mem_attr[n].attrs = mem_attrs[n] >> 16;
-- 
2.54.0.1136.gdb2ca164c4-goog

