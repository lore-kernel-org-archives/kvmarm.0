Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DB121C198
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527158; cv=none; b=BIgtOkY4LViXjWNUNxi2A6kAvdAUc0bjDxhH6QxqvhN0+zs2MP82neO70pyjsVu2cEnBWUxZCbYd6oED1LtDbU0kHhdQQXD2haw3H/KfOZe/GifLsF2l2ggjKmCJXcrceLZdfrfNpKdrg389Br1gBWvWhcOfMko2OcSy1MZFBTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527158; c=relaxed/simple;
	bh=KXerYYejaebsX7jbyb1Lb5RpqboiWkfKzCdImI0qQB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umZwDxhKbyt8Oi0d9hPuiBSSVyKs23M/NQupZqtVb7AQT1mP4ArXmG8JVYHxOfy1llzgXYXkPXf4qOwRQYEyLhBwieornEw807fP9ixbTGekOAw58XJLfptuJVgv7CkXvZ40U68vwNBbiax9b9Dg3Igg6lpSYyRafLn90riFKfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SbE9JwvS; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbE9JwvS"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22580c9ee0aso118953975ad.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 10:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527156; x=1744131956; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5jy8qC0h8+P67i9ZAO/Zho3A5/9ZziVLel9NfnuQo2c=;
        b=SbE9JwvSBYno895t7yP7Mb8lcen3LA6ONyjL9FI7aFsKaMZP8IE5nZKYLvwdQvk2kX
         M/XilRQoWbW37lZYrvXlaineopLTaCFGrwXUrHpf/Ze+vlOGpfhEoQn62kdLXooMVkqc
         3A3rcVA6Y06S0bZ9NXg4+BM4McgX1pY4+vWd+Hb+JxVNeQceZL6bvpB8kEaU9mar2VT5
         4EDQA2n72KbBr50heFmLnAZr8eBN9C5YRyCeZRvufteYfgxMOoSRxWlUnxC7oi27Ax3X
         fGvhf7l2Dvn6Z93M8BXeuDkFM+OFMZTb+2OTzlPrsFwgl5rYgik5/WGjsBBLjZUq6lvz
         mixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527156; x=1744131956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jy8qC0h8+P67i9ZAO/Zho3A5/9ZziVLel9NfnuQo2c=;
        b=OFyqrNfIuO1bfaZzMLIoZaPLT+q0TuSld4yTbvsA+TRXrfKpo2dJ5RWOgezPX+FTHS
         /BUrhWNn2AIz+aVklpc1xF3E8e+sSdTMfBQwLUJR+Sxl+Aeq9t7emQMUmy0lo73Z89RC
         FJ2ZkcdybC9tlwUvBG9s2bbltZLCMKga/yyjUMvISwBihAXpVvEkwL56mpIp1CEofbEw
         H/6K4pCZZ8k2tpSJfBp2pCDKkBgvawO9IYGEtAFBMO59A3FZqteWhV10H+PHOQoKR+gc
         RNpun4tfYchzzJ+ueWMmDckWW5Ac+uqt8oJ8ezW39ULmUFx7tYUUAOkcUoE1aXMMhR/c
         tnCg==
X-Gm-Message-State: AOJu0YwFKKm4qI+C5qj3ReBYJ/CAuGtoyfuPKn2L7KE9E9Mon5uTAAIx
	8pgyR74P3W0AQHbb6imuWZQfDii/KvrYJeKSmb7tMX5u4NxqrL83u7WgcM9M
X-Gm-Gg: ASbGnctOUdpnH7Iy7LeaQAjXSjD1GeYGlpEE54UnYhGoKPkpfOwxRatIP79nbLrzRKI
	ntn2T6/RwwGORMiL7UgOJG9iqUa103kk4x1mQdEn3DeXH8Cvw6IclNtEbhQP3As3qQhViy2uf5w
	jcpbcf6144X01qX0n4SORpzwr/abWzvvXFD/qs+GYpNyqs7g7pbUc9xQTwBZJfkSRY9gJcDvsGD
	Yy04bI4x7SZo0qLMRx3ilu+QwZgrHYy8jMYe+IsisEeJoOaJzx80cleukuu6Smo05pawPw+3JeQ
	LM2zcw2UDr66anfW94pnol7ximYmmdRipf/JM0a7
X-Google-Smtp-Source: AGHT+IGYkL73/rVCuY5eIXCc8VPG7MsAP5ixlU5mMgBMLHSz5fauZRADZEMVVYLaM4aLq44Kjk0EYQ==
X-Received: by 2002:a17:902:ef09:b0:224:11fc:40c0 with SMTP id d9443c01a7336-2292f944013mr234995215ad.11.1743527156410;
        Tue, 01 Apr 2025 10:05:56 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:05:56 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 1/7] firmware: smccc: Add macros for Trusted OS/App owner check on SMC value
Date: Tue,  1 Apr 2025 22:35:21 +0530
Message-ID: <20250401170527.344092-2-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds ARM_SMCCC_IS_OWNER_TRUSTED_APP() and ARM_SMCCC_IS_OWNER_TRUSTED_OS()
macros. These can be used to identify if the SMC is targetted at a Trusted OS/App in
the secure world.

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 include/linux/arm-smccc.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f19be5754090..da2b4565d5b3 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -56,6 +56,14 @@
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
 #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
 
+#define ARM_SMCCC_IS_OWNER_TRUSTED_APP(smc_val) \
+		((ARM_SMCCC_OWNER_NUM(smc_val) >= ARM_SMCCC_OWNER_TRUSTED_APP) && \
+			(ARM_SMCCC_OWNER_NUM(smc_val) <= ARM_SMCCC_OWNER_TRUSTED_APP_END))
+
+#define ARM_SMCCC_IS_OWNER_TRUSTED_OS(smc_val)  \
+		((ARM_SMCCC_OWNER_NUM(smc_val) >= ARM_SMCCC_OWNER_TRUSTED_OS) && \
+			(ARM_SMCCC_OWNER_NUM(smc_val) <= ARM_SMCCC_OWNER_TRUSTED_OS_END))
+
 #define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
 
 #define ARM_SMCCC_QUIRK_NONE		0
-- 
2.43.0

