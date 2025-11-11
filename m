Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7552853F7
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762887013; cv=none; b=X41BQ0+L4jePlhMhJLPv52GAIjGQuzv8d9mze0lORMMy1lV2GLMsFJt3j+/PD5hbgMGNF7J9KxwvJRbbLpcn5VuJI4Z3/9xHg12bBj+s5tVavYKk98PHGkg77LqsB2wRtKpipb1eGh0R4QkwM+p3jOAqk0v/HG22LxnY7USGofk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762887013; c=relaxed/simple;
	bh=zh5qlv2jzu5zwpymlV61eYkKmky2VbNHJ19tw5WJCzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gC4GeBvh5KZ5uKJoySvJ0Hlr9EtxrmAcojLSdv8Lg0vSNFxCWGqaYh988J3Rjd/s7RHMQy8tQK2WWlAgYKraH54WXhtTJ89KbDwKGtvPDFKtMO5lyyQBCNLN0n65siE1h9Mh+aQ9NRCmzQiETKzR08jNzRsJLiJNqyOncGn0kf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/XhNXbU; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/XhNXbU"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42b2dc17965so2744909f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 10:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762887010; x=1763491810; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hecw6SGTcbrCqUAbSZzj/G3btrpHikJf1SssivaJbCA=;
        b=V/XhNXbUnXAprPP1DOf3pBMv+8oLSNQ8dhRDjZY7qeFdKqaS3XVBJgE1DZ7bXHcI4N
         ChOEhLQiiHDBi1jgljbpo8fPl8KzDz5iSBs3NguFzM2iqHb3nprBakSm5U8fo4d/cXSF
         0ngjJvd7oR+Xu0v9xQTF/5IvFSbsTm0ihJnMO96hVgnCPNfgZrcRTC18AfbnwPrt8iRr
         6PHx5VhX6MrD9nt+N6XCZKxlUsDeGzf9aKI8bKu6swp3X3qFBwdaV5nrHyxgHsN3oXum
         GcCKc4CK+mTEUxblwbZn9EE0avYYJD8mIMjqDpSbpFDeZ0Dh037MdNQ5MFH8HJuujqBj
         phJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762887010; x=1763491810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hecw6SGTcbrCqUAbSZzj/G3btrpHikJf1SssivaJbCA=;
        b=MMSkDtbJGzvha/8LAUUnAuPBRSly75ocSm3hSPwygpXfFZTFbQM9HQCog9UswoPSuW
         FC1rEgh/RbnIyeBlN3kg/tyMAY36c1SUVnW2OfaEu6tMYV4pSQn/5umUMMCCpiAAzazE
         /kcs8exE7gkQ2O/LIQ10xQo5erFNVuVthiHVKQC+2kC72bQEvL2qYOngFFJ/k+P1XtG/
         2E5dnUqO8DmRZnDVbslkxpufUP/uLVcx9LUl5kzyumMQgtfySCX3XD1yeKIn9xJJNwB2
         tZLsNJeOoucutDlf/iCkFMeDUX1FE84JMCzt0L0FjgS8s1hzZB6UP5gyW9YnMyCSLfIa
         NNLw==
X-Forwarded-Encrypted: i=1; AJvYcCXRQxbdC76S5kUfWwKO2bCmPs5IvzHzoQsoU5Pe88krDZNvHPc5UhvmRMk7/3pyYL/iCGd8a1g=@lists.linux.dev
X-Gm-Message-State: AOJu0YztdOaRbLgQYrzrUvZGk1rn4mS70wAjXucatfwUVMdedRQrZdNM
	+EoiLkYgIydBQt2s+NOY80yDWX7qUXgydYSOlp2U6Ns5KnkaD3acn50z
X-Gm-Gg: ASbGnctaJCWjXJyob4HWCRPEmTJXa0KsvXRplfRq1CQbRohAji0TuxwS2TJrxTsH2h1
	FQp2P5Sdpw8NvB3T//oHioOWnKM64z0gzJDxQ2H1Wz9YCmh+BoXQcYBvjGzddfUrAbE2CNSsdoR
	BmBojQFabDlRi0IMNAiLTXBl8FPnM9pBAZh4S4ZW7G8YLOgQ7iqqRKpvk0fRvM8GAhBW4Y6IwSx
	+CJKDlYLacjTZytj+enjuezYtTFs9JT3SwsdJL6whgmi3/QuDbVjohe3s5jOyGky5azv9+pJH19
	e/xK6VnrxQYyeETw76pxN5RPxleWtjg++nvGh9jnSEzr9bA4lumethiYkQAMFAGAo8MLPZfx9YQ
	Uhv8PbitTGrot0OZ0U65CmWuxOIF80lBYLorIOCryL40dI0/TD4HxqluecqkCn1jsWhGPx4QvN5
	Z7lxa1bBdxd/AS
X-Google-Smtp-Source: AGHT+IFSvM2CsB+t9jolqji5xVyqJeQrmqnCERVjosfYiifdGVyx1RnjwV0p/nlqbwxmejN0WMpo8w==
X-Received: by 2002:a05:6000:26d2:b0:42b:396e:2817 with SMTP id ffacd0b85a97d-42b4bd9b823mr211802f8f.40.1762887009974;
        Tue, 11 Nov 2025 10:50:09 -0800 (PST)
Received: from osama.. ([41.236.140.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b322d533dsm18787142f8f.0.2025.11.11.10.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 10:50:09 -0800 (PST)
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
Subject: [PATCH] KVM: arm64:  drop sysreg init error log
Date: Tue, 11 Nov 2025 20:50:05 +0200
Message-ID: <20251111185005.12842-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The failure paths inside kvm_sys_reg_table_init() already emit
excessive error messages. The additional kvm_info() in the caller
is therefore redundant, so remove it.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 arch/arm64/kvm/arm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..af2fe3cb3356 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2844,10 +2844,8 @@ static __init int kvm_arm_init(void)
 	}
 
 	err = kvm_sys_reg_table_init();
-	if (err) {
-		kvm_info("Error initializing system register tables");
+	if (err)
 		return err;
-	}
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
-- 
2.43.0

