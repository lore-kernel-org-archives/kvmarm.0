Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC1128E5E1
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 10:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746784814; cv=none; b=YidIHXktQBoahCXULGV/7a9CpZn8b9BDt7viqeOrgbB5B0pjrnywJdD06Yz8OpVDemAj5cVV0Ack2WOAS/7iyq2uPHzgFXCaagmA0KyBAJOSDebM1Q7xACtGvwDaFd1NiSizRDGGvQQLK16m+UGSybUF8kW0ssyMpGIXmrc/iL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746784814; c=relaxed/simple;
	bh=urWBHCD5yL4sRcpxDe72lFVdmLkE3SEYkUgV50YJwcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h0Jnus33kH/JTAhu4ISshf148aMUambR6/8pu0ZcR4gzQhYYW7V2xLF/0rY5mHC+xE4PTdRC7KlBcBTo3azfdGy/yXOEtXSAnnpXDrxgd4jeljwO4RABHHGQUAsJlyrCG/nwDKs/fznq3jK8/+zWl3TYRUQ+hEjsF0pdUGTRt5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JNs+FcPt; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JNs+FcPt"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so2086348b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 03:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746784812; x=1747389612; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=etoiHHyRBq2rLgJXv5Y9hE7Q7cEfLHiNK8ewd9bv5mI=;
        b=JNs+FcPtIC1Fb04NzwPfUAQlM7Sh/yNJZ2f2dH4+RCrZ8EZ59WB13C0iMtAYI2ESB6
         gggV2OYdKTWKIsupq4AS+3CjB4LLv8CUpgAlVyV4C2FES1rqYW5droK746oPspCE87oQ
         dmFinKzTYCmriGP+FVjqinugzr6h//vXQRR1KAIX19dHz6zef7HnWG6+yRwkOnHJwOH3
         ftvBQamttl+U97SaFL08ZGVjN9JzdXQvKpGt46yR5k2JpCk8wjIf9NnRIb5gPv3/pyj1
         9txjc+IR51zQo3CX5hQ4Q3SeLo/0SB3lk6seXyIIRV4Qi0SfItOhGecHwOJw4a0MslFI
         dBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746784812; x=1747389612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=etoiHHyRBq2rLgJXv5Y9hE7Q7cEfLHiNK8ewd9bv5mI=;
        b=rautWRNYdS0+WRi843S57JR6reKuCBPSqOc5iKAOMVPkaEV2t37lytnHbcbXTQP4EA
         8ka/us6c0YX4wuNysnnGW0G37OjM0fQn08YNlD56uOLBzrAD/9KGCJb64TMwCY2VY51A
         /gcLc3Z/JYi0kOoDW5q1+6i77f3Na0L9CuSR7BR8fl+pUqhGDlqxa97KmQpQI5y2cSlc
         4BxnlUhfQ2gDWgvy7cQGqWKucYFkL+s6wpGJ4gbOz68TgaHvqbI/MfjwG+wHY7XE4ehQ
         VS0rejQybHLkT4P5XuwWVlrZUlFgnjQF+W3qJT3LUutWnRnSwSOuHADP3UX9VZzXeoAv
         6+4A==
X-Forwarded-Encrypted: i=1; AJvYcCWWdR+nihKAK/6y4uTPsro5nZDr5vgdhnZDp9VcXzpDoLGKee0qTJcIP23BrryxgDyMSGxADNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWrOWNX6cXthW45P0WIoc3pNXxjwx0Ay+uPP+WgP0KGsk/Oymj
	qCCHu36uiojRwWsjQ2goujop2GMGRRnxL0hyf6gUPjXLPyaekLCq
X-Gm-Gg: ASbGncurm1DaUHNEqet/3rPN7xYS3FtlYdtEu9ajpfAfPVUlmmmhBqtL/PGEmb0CxdG
	8AhR86p6LwULuPX+j9/ZnKAczkC2XsswQHFCik/Bf5fQmXpn7AnabV3b+Wra7xdfWv+GBg3HZcZ
	DfiNAMQ6zLyCezkgUcy0wPBsjxgpcLBBTUOtQDnToG5xtQW90qLjFLhpWSpxbZPOhcNnJTJOuh8
	15mIiJZ+LQ9KYfijry779aT9la30gEB6KtWI/DNIvaDpqrxgzJqL/tFMyALpxAkP2jigcYK0VWO
	9l3xa8QiUgMzZLfBWKSwRxIfGOsl4AyhB/ovwY3S75SkeMl010Ke
X-Google-Smtp-Source: AGHT+IEQRGYYdmuOQpYE6EFYgcT85Xf/QwhETlpYtJ33rrK6CmDFYaOZXAoRcYjJE621GAnYX0Yxzg==
X-Received: by 2002:a05:6a00:9286:b0:740:a023:5d60 with SMTP id d2e1a72fcca58-7423c032792mr3999373b3a.19.1746784809483;
        Fri, 09 May 2025 03:00:09 -0700 (PDT)
Received: from OSC.. ([106.222.230.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237704f36sm1419403b3a.36.2025.05.09.03.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 03:00:08 -0700 (PDT)
From: Pavan Bobba <opensource206@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Pavan Bobba <opensource206@gmail.com>
Subject: [PATCH] KVM:FIXME comment is removed since no longer required
Date: Fri,  9 May 2025 15:29:57 +0530
Message-ID: <20250509095957.6271-1-opensource206@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FIXME comment can be removed since finalize_init_hyp_mode()
is invoked after kvm_init()

Signed-off-by: Pavan Bobba <opensource206@gmail.com>
---
 arch/arm64/kvm/arm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 19ca57def629..36a4b6277537 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2856,10 +2856,6 @@ static __init int kvm_arm_init(void)
 				     "h" : "n"),
 		 cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) ? "+NV2": "");
 
-	/*
-	 * FIXME: Do something reasonable if kvm_init() fails after pKVM
-	 * hypervisor protection is finalized.
-	 */
 	err = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 	if (err)
 		goto out_subs;
-- 
2.43.0

