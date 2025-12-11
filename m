Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81314A937
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 22:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765493541; cv=none; b=bp01iIzUaawllBXg8h1yCk6t14SiFZ7KoOSdwLr+HE3vnX6vx+01n/lMMZBK0yVASfVbdqg+PMbOSyb6dYzp9f/xFXQvYpegadE4VkFcMXGglLbqkkgfhg07OaC7MYoGCoLC4hOAwYdbHuXYfqmrL5i5r7f6GbG0iPS0OvrlgDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765493541; c=relaxed/simple;
	bh=SVgQmgMmdrrF8Jk885Zp2+GUEO/c9jXU9x/2G0WMaJA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EV7n6fpf8w21yE6lcq2QraGclynVgHJI6UJpVCKBoMUR9cpDLsqqynOymuVWRpUM1fjs30RYA9FDir9DGK1PptpZsKT77liV2VX1zu6pBQJqhNxfREmzr8CXLR6X2U5cISVQUEGdHhttk0FjGhaccK8qYSr2aYvL5xzazlHpGC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MpEXDSRB; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MpEXDSRB"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso876021a12.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 14:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765493538; x=1766098338; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=09llb/bSY0mgbOt0WKaxBGw/YRUrWWHAQNbkHm/vJI0=;
        b=MpEXDSRB+c8zmCltYYuj6qaLlijhIBaluKf/rcjx0AFekEiwnSZEuYgFdTFXvKh0Ai
         lO/SKw/Dsgp9u10CmWwLSu0iUSKxSrKToSMOSUUA7asiD8glrrPO+pKSG+xR910OJVw5
         alb++lxnVY2blN+V07AXmVcJPQ/TvjYmb619163OIhD/I58jyxWSWuFWbSAySbJPsLs+
         w5qVhrwjtCf1TpUbNLPPVO+yKoU43zcXqp2ANBvCYME+nG3ipHJ5scFp/U3q8wxRXXvL
         MiR4KyoeyIaujjkow9/NZ5j/LD0ezF6ueaWQidw5z5kHXWqF3O3R29Mxn5dkA38mA2NB
         Ok2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765493538; x=1766098338;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=09llb/bSY0mgbOt0WKaxBGw/YRUrWWHAQNbkHm/vJI0=;
        b=MbUX8o5FDdF0PVG5rsvg7K8f+LxhfYg/i/spCCoXetU0xcxT+3bDqLNHHOU/uwNJnd
         XMYJ8Vh9k+MeLUQ1aI/FkD2vHS83Yke9/U7gvfUy/4VUDl48SDwXTVox+h6RsKrl7qmZ
         9FWE++klX9A5yCnKI2sYxc/ORRf9f4vp6LcC0YNSgoGVa6kxIumNBU+eJSczj2UHkx0A
         OVXM6DNNxGqaWDmV4I71EUKAManoA7kNh3IAsfy5ffzTRcBEBwsGbYc2OLLWjzbQcCtT
         vuwBBfV5WRIXadD+AhhNQ3+FLPPGLeGX7M9iTfKZLP63fvC6DEzwm6hqaWGrZhr1x+37
         MBiA==
X-Forwarded-Encrypted: i=1; AJvYcCUniCENyISM316FtZ+rzavdEAv3OvF0fU+YD+FIMkqDgt3mw5EwwEdDzNnrFmD9/gCckvYZlI4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuAPLD5mSLcy9AZTP2qE+tjVBNGMQlhgMYZSGMhEX1wns+fdD0
	K4gXR4RuGL2jtmvE/Hc2tUh+5JeBaPwMBIHNQ1NBJYfgnpuN9W/vyZqf
X-Gm-Gg: AY/fxX6vIqFl8uGv/Vh8/Esh1yxj3IY5oSnlVcoALiUsey3yitvt73P3mnVA4ZMtfZ9
	G8jR7huolYkItEFoSvEZ5Njys9bfwa62/mCdnaqCCXw8JnLm34rHXUoUgCr1Vextzb5AphJyRiv
	uhg3BwK/h3L/2X58X3OmAM9epbwwpr1OgzERDa03CbkYqmALYPISIFhYKxo0j6ZprvHbqDpQEtK
	+R6Y1tc6Z+C3nWNXcfJjI2J36Ks+Z5nlRoisXjkjj7b/izYwPelGXPPOEf169+EeVfb+f5EV5ZF
	xYavkks4Wkh+W5VbzSbhYdGaHW2/aSiGsbhuAXiR5qigAlSqnhcEvCleD95/B32+rphEG+yK7BT
	FKwDXthijVBPb5P/Pu9hl/e8Saq/bL077xUIObbWlMU/eB9RXmIQtM5ObcC+yTC581SmRmoP+rh
	Hhtcuq1Ncpr0dlPmQxFFUSLK8zqg==
X-Google-Smtp-Source: AGHT+IEyDaVAxyVQR6Uk5+Qu2gG/4xuKgZJSMgON/U7wgtg5JENf1PcVjQ2HIj3b3UveLtFXLBRzTg==
X-Received: by 2002:a05:6402:1ecc:b0:640:a9fb:3464 with SMTP id 4fb4d7f45d1cf-6499b168982mr62178a12.7.1765493537712;
        Thu, 11 Dec 2025 14:52:17 -0800 (PST)
Received: from osama.. ([2a02:908:1b4:dac0:ddc3:acc0:61f0:9df6])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-649821316e4sm3771707a12.31.2025.12.11.14.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 14:52:17 -0800 (PST)
From: Osama Abdelkader <osama.abdelkader@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Timothy Hayes <timothy.hayes@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic: simplify vgic_v3_redist_region_full()
Date: Thu, 11 Dec 2025 23:51:09 +0100
Message-ID: <20251211225114.20474-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the function by converting the if-return-false pattern to a
direct boolean expression return, making the code more concise and
readable.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 arch/arm64/kvm/vgic/vgic.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5f0fc96b4dc2..04dd2055e7df 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -382,10 +382,7 @@ static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 static inline bool
 vgic_v3_redist_region_full(struct vgic_redist_region *region)
 {
-	if (!region->count)
-		return false;
-
-	return (region->free_index >= region->count);
+	return region->count > 0 && region->free_index >= region->count;
 }
 
 struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rdregs);
-- 
2.43.0

