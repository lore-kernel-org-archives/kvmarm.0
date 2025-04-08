Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DF1282F1
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118466; cv=none; b=mST5x3O+NGAcpdG4IfqCTwUXRDphvr7MiBijmSoi7zpBKCIADibLUa/hnTlHv30SxV0jXJrPVrd1shd3bcOBlAO00vIoELo1OP0jjhvyfZ0C93/A1nxLI0MFLA4Tc02tfm+Z1BmVoB0Dy8uNVmlQeIb/wLjClM1Bsu5Hii29MqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118466; c=relaxed/simple;
	bh=4jPJPXMgY6/GNH/PWCQbZnehb4Ap/K+ZFSF2TYMKD2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPHBv7RCH8g+t8pStT2VmBri1GNrEmnj1NcvOK1u2FaVsm9l5S+G769HB2V9sbOSXGbP/dXaQkMOCZnJCGXDxZuLUtdHbclI2r3IhmXkJ5GXUTm79kGR9HzjLNbntXaC9YhrjeTTG9wuTvSSftmFwNYbwaU1UBxE1+ASTGPg718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IHwrDFrE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IHwrDFrE"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so60253315e9.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118463; x=1744723263; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SRH4HHKjDjKZC1O9fqzVBp1Dw5VmTF9lQVHJ5oF2lVI=;
        b=IHwrDFrEDXYygPwwXKBlJUukBz4mNPyqD5q0VwoiPLJP3I5kc4XX3GGCQP3BhnEvBm
         72lyBGMs4+O61t27jWJjaG6T8poGFmdf6kDSVWsS4GEErjljGp+UYH2bBIhOSUV8EdFA
         XCDpzKOzAm3gRA+Py8BlnBTEFSiOR3RLIyHbq5E7rYY2qJ3Eh7eG4GOwUeK/KsAUU3bN
         qIjKKDwCOKGwlk+4v7g5ovHPTb/eOKrfoUzOrfH31/U9m7fC16igYV39x5vonVBv6K9j
         fdKH0HI95OBbr+ui48ENUbhopuvt4R/EA9ODgRHGqy56U4UIXv7D8Dgrq17P1JSoJWjm
         Gcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118463; x=1744723263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SRH4HHKjDjKZC1O9fqzVBp1Dw5VmTF9lQVHJ5oF2lVI=;
        b=YXa0D4ZAQzt8yRJXyKT7a/DQu9PDNlehQpYIytoEuOt6x3T2UkpKG4LUQxkE6Jwt0l
         4QPmIKaMVP6mc8gjzHx8rTT7r5atBJIQH4SAWhsU3cC+dYa6976a64IU9bwV2LL6aGpB
         NDLNL6n3+xr0eb2YkroqrC6TXKAGgrUx9s3/EQFwf5aAKaP47x3QCHbca9LrCL96BeHq
         QOVZs6jfmjVpn2DK4FujZ4hb+CbepBLQ6Hz/kpM6Px5RG/ajMAyGOseFPPe2mvCeNLZi
         uLqhOUo9V3nCQiTcMFp3C+1VdzdXpqzUhZe+RSxO39JvgN/YxPk6wf0f1Gvwmhtb2vhk
         XFyg==
X-Forwarded-Encrypted: i=1; AJvYcCWhyUsuMFmzHS1ol9JtcIPaBLVlb9ntyyMrkZXRwUOg3ruvpwwiMy7Aqc3cfwuAqP1z078kHrM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQ8vHoA8AgDV1eNnS2HFMlhR4bLz4hCtOa4x62D338jC/EnOk5
	oz4/GjM5fhZBN/g4MmxPPlyR6iO0O6qvgEHy2bPdwNAZ0ZbV9qUYs8sVLQ8duAs=
X-Gm-Gg: ASbGncscYGmq+qczY05elkEP7XL+4upVZCfXX1DxU++nOWq/Kst87nzR7utV8K1WObO
	3Ype8aXIha0wMSu7RGdOW2wRH1Rnn8zBEqGkZcuXSh1cm0O8yxdsgc3SaJUhx2uRphMMfJbQHnF
	vmYjELrS3XyYGD8lLyRIVvJ+YxAPsYuDqNnuDgitAbwyOCMB46H9eKuHoNDtjfcqqSNzpk06UHl
	JcqcXntfQKjc2OxK88EDLokGcUnwvPIWdwXRTdKJqOfiuWxkFUo9Y+mLoCTaOPiRghf4gnspr8A
	3txLHsSfAPjPtvFVd0pBYDEDjTf/q+89UpIkkENYt/1ON01t+CTdV4lMVkqRvKitknna0AmSIQ=
	=
X-Google-Smtp-Source: AGHT+IGXvBRS2ISmkSgOkaf9NDWmbD8mKXwPO0SBtc5D+QUv2VkxB2qWcK8BGtwXEr2R0/0t367Gpg==
X-Received: by 2002:a05:600c:4e0e:b0:43c:fda5:41e9 with SMTP id 5b1f17b1804b1-43ed0da5960mr184760875e9.31.1744118462693;
        Tue, 08 Apr 2025 06:21:02 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:02 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 1/5] configure: arm64: Don't display 'aarch64' as the default architecture
Date: Tue,  8 Apr 2025 14:20:50 +0100
Message-ID: <20250408132053.2397018-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

--arch=aarch64, intentional or not, has been supported since the initial
arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
"aarch64" does not show up in the list of supported architectures, but
it's displayed as the default architecture if doing ./configure --help
on an arm64 machine.

The help text for --arch changes from:

   --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

to:

    --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 52904d3a..010c68ff 100755
--- a/configure
+++ b/configure
@@ -43,6 +43,7 @@ else
 fi
 
 usage() {
+    [ "$arch" = "aarch64" ] && arch="arm64"
     cat <<-EOF
 	Usage: $0 [options]
 
-- 
2.49.0

