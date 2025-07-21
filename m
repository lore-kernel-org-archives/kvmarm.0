Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236972D640E
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103257; cv=none; b=OwQFrlxq2uEMolvV7MOWGfrfHCB8ceVT95wOM1JB3Qm6VcJxUmbvnhdNLuMKUcWZoAGr6u1uUUtl5w9zArZJH/rNGprESv1QTnOQ9H+97jC9x7fQttsC3LfDAd6LhvUGRe03V8rJhXJEVz8e4JbOrauMEqW8kINWgY1HScSOCl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103257; c=relaxed/simple;
	bh=q6B21jNgjxNNbn1toxYsG2+TSTzsrfyP6+kfk/EB6Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gOL3EINILn7YWur35IGaul0H4SYHNPqOCc6qYktUdE9fFL3CEghYuTVsESolXRpdvf2wbGWDtDGDlt0iCXC0n/zWDdMYiuq9hv8x7qPd9IlLmb3tK+Mm72ESPXoA0YmDyx6zki5EjPEnv4KlYGKALULSVF0FJyHbnl2oFQuyFfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PmVHDGPb; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PmVHDGPb"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-451d54214adso30729865e9.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753103254; x=1753708054; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DLCx+sqKyQ6H6n1t1Iho4DguHkaJ1c+mG90AYPKk4U0=;
        b=PmVHDGPbb0uUmc6rgIVvlf5WNxqoLnSOOjUQNloLE3cPrdh31o9S4sHrWCDM3WsR82
         vbEHOKepE0aw8/A2v5zwC9Kmnwani68u7p3Tfs/VzwqIJIt+MyGJrOeGuqi6x8ff5eTo
         K2KCVuD/kEX0IaFrbCx8dBsPgs4qYEIk3ea0bZWDF7MiRc35VivBfoTrNu3yTnhORGep
         iCbYkjyfXESFOCXOdiqtODGlwgq/uEDSq9fJmZMPSsnSBdm9FA2aOdDittARARfYBZuE
         F92KU4srPOQZtjjkgre+kWlWn6Q1wmrxeRUHAtW7QpQfxQsNOhBl2A0uR0uduXrr3UfP
         cstw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103254; x=1753708054;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DLCx+sqKyQ6H6n1t1Iho4DguHkaJ1c+mG90AYPKk4U0=;
        b=k2MZM7J0UhBvzFUGLgMAhTebutq9m1WlXPyPq+raR+ev5WGGxz/a9QppXWn8xvGbff
         rU+kC5nynyIdiBhq4fGp1njGW4mn6VxGK2KJIwFPPgSBGterpMI1/XTFTrd83LyAM3Mu
         Vku4WWOD7VUFdP4Ty5AVQWQBEbS/B6hHh/6SORcAfuiEyIbggSU1Dcv/OLXoBoxZ7KAN
         3aiuFzKqRgSThPejcQXtZ2nD7kIGN/lVUJ7VPYH8avbPI6xiXRyvxA7e1QMysUlBY/f4
         z3RS4A06h38YPIq5hQQ2vRwrVZeqGymOXctg686SgLHtxeAIewIHvAYiVCH16SHanjn7
         4cxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlSW9IFelJ1QFHmDZmV/VMXMIotWc8uEmHPpNH5wuU1GK2/YCpjO2i/7SuXGprs7GhCg/Vxos=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhGCJeur0PZ5jHEPyacH01pB24X5wKISA599OGnUbkZYIs0+R2
	YskgAvzJZmDxnlrU1cZhaBlwhcC3t+7d5EwpODUgL01R1qH5lncrzI9W4Dpwig==
X-Gm-Gg: ASbGncs4Upn71leGvS4TcSEq/eYOXnoxjc+P7Xl16aDcuzfybP3sO3lKDtBKYj9R5mW
	NLPMJt0EXhrn70Euyb66yRrJIG2bTGP9VTnu/ynMYDeG+MGtExazAmxw+61/x7UGxrVwwfdp66U
	RFxVuaInCfVrNyDXt4FFliJ3+5VSJEqHwx+ryUodLsi9DnIG1sZNnpOZNDecnSj/LS8qpIF9lzq
	1aEjez02Ki8shVHHPa7CajmfDHvx55ksyh0Z+uiqPHVNnZAGTmC1g0koc2L3Bp97bJnRl3ttKbx
	F4gkK+Jj1sSADru3MBOTj3Q9q2pLaO/egITGIVT46g8jYAF18gaLJYyyoummfRCeDsXWjg+o/n4
	ZZI3giBaR1kfJWVIL7yHqcx+FenxrT2wrhXsr+UOgkaJib0H8q5z+QMmSw1BpnGupL8US5/1gIQ
	==
X-Google-Smtp-Source: AGHT+IHmDCTmiGnsqtX1YVYWRcIXEER5wbunM4O6C5Aoi5lFM6U8OAVQsEhiHj1NA9lOUgYhy7795g==
X-Received: by 2002:a05:600c:4f42:b0:456:eab:6344 with SMTP id 5b1f17b1804b1-456352f8f1emr129426955e9.15.1753103254113;
        Mon, 21 Jul 2025 06:07:34 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e7f2bb4sm157681365e9.8.2025.07.21.06.07.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Jul 2025 06:07:33 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	arnd@arndb.de,
	wei.liu@kernel.org,
	romank@linux.microsoft.com,
	mhklinux@outlook.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	kvmarm@lists.linux.dev
Cc: roypat@amazon.com,
	Jack Thomson <jackabt@amazon.com>
Subject: [PATCH] arm64: kvm, smccc: Fix vendor uuid
Date: Mon, 21 Jul 2025 14:05:58 +0100
Message-ID: <20250721130558.50823-1-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Commit 13423063c7cb ("arm64: kvm, smccc: Introduce and use API for
getting hypervisor UUID") replaced the explicit register constants
with the UUID_INIT macro. However, there is an endian issue, meaning
the UUID generated and used in the handshake didn't match UUID prior to
the commit.

The change in UUID causes the SMCCC vendor handshake to fail with older
guest kernels, meaning devices such as PTP were not available in the
guest.

This patch updates the parameters to the macro to generate a UUID which
matches the previous value, and re-establish backwards compatibility
with older guest kernels.

Fixes: 13423063c7cb ("arm64: kvm, smccc: Introduce and use API for getting hypervisor UUID")
getting hypervisor UUID")
Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 include/linux/arm-smccc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 784ebe4607a4..50b47eba7d01 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -113,7 +113,7 @@
 
 /* KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74 */
 #define ARM_SMCCC_VENDOR_HYP_UID_KVM UUID_INIT(\
-	0xb66fb428, 0xc52e, 0xe911, \
+	0x28b46fb6, 0x2ec5, 0x11e9, \
 	0xa9, 0xca, 0x4b, 0x56, \
 	0x4d, 0x00, 0x3a, 0x74)
 

base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
-- 
2.43.0

