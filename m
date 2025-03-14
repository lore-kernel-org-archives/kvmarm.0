Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74359202C39
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967481; cv=none; b=fmEweTjfYojZ53OBGQWiX1DXT5Ma767vWKktJqEr4Zeg5Lw/iplOLoD3ao9DDs3XHI4b6vESip0rBkuTO6Jr5aZI1lUAzaGsIOIrcRxTqErr49yrFXeUkTaHuvlwzxh801baYgAAiMsVIcXH+ZjyyHafCfZrBHJNoT3AE3A+2bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967481; c=relaxed/simple;
	bh=/7OM+oNyDXmm/2LdOGMTaA6SqbTbV/e/lr9qj1j+GQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIVRIMVjOVpOkHRWrBorr8siLvTWhVYFD6SPp9g09jxLa/WoKlchHRIt0sWzwNXs34ybuX5w2riWuRmGa9U7xP2293SnjdVwk/3eVnw5QkaEsHFZCd05ZGzs0Jf2xg+q/LC4baZCIkZxHMVqJhX8J2XxoXhkqKWW+zeXPSS4wIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=toOFkhUS; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="toOFkhUS"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39133f709f5so1411614f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967477; x=1742572277; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++RCXC80KQUw+yCRaKjq5JOqlP9+bD2jusr4EJFhpro=;
        b=toOFkhUSqy1g7exl+pQehHVB/QMU7ewQD5qvFUDKpWRYiWehp1rQBmxxcLC2L2np2k
         G4Sief14MonexkpsdlLTYEqkpTgrDwQprfrcjSyyluob29JNbU0UW2G6w4Yghgpg46k0
         ReolDANMhEzX+y1r3WItCEvig5iYXhrVVM8sXVmQyLh97Difgfke6WwTbtEEEjyMnMKg
         wrFhPexhW8UTVDI+L738HNwB188ZS+azESJ8X488c3AqxrgZGFnC7svrsg1SScepEptp
         zWTQ4BBfm8YdZevsJ6q1H7WlYuRFaOSOb2WJ9+WduNfjqmtwbItNecImvoqjaYAqsXri
         y4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967477; x=1742572277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=++RCXC80KQUw+yCRaKjq5JOqlP9+bD2jusr4EJFhpro=;
        b=Cyynfcg4lJ8pjhHFcurfVdX6m7JqVbMy+3z6Af4bv7Ows8oH1PsGgbe6z1275YG0M5
         m84uXD/d86s7Hn4ofXwH+c4e3fNcIrI7hqmqiMI859jqXHwHICh2eyzEgd7TiuwrDeAh
         Dxu313upbrviEtpbo0dUW7pMij/Kdv3v2MlB6W3QH3nwhM0bbWhJoTyEpbapZ/JEWkEe
         5eFhW/JVvkXd00jrzLea3+zSh9w2/ZxCFRNHqqmAGcQTCXCoT4Egnagv/kjPl1nUJaiy
         c4oi2961KtiRVLQ1t88yinDb9mj6iPIZNScS81GUVB+zNHjLcDybJezLrH26jwZy7F1E
         Wveg==
X-Forwarded-Encrypted: i=1; AJvYcCXbOJJWKtNqQPexVykcZvpNQkdWniL+RyslEfN+zU6tsto4mNQR40TkvlDLgZ4oY6ws8QWGnRc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyN+zJPfveL+4DnfcjMpUJXpWrkG8YY4/ax6/xjN/VjpuTISDVA
	t1LcaMtXvXnsOqGLDlcfHrPnJ2uw25mi/u+SE4aDZTxutX2ZRMsb/zaI442Zp78=
X-Gm-Gg: ASbGnctrwq3eoXzegfUTvlcwClAmqRsUiALlah3LthghLD8qWQPYeTOipdD9OZ9pHPX
	OI5Nh+VftwOfdJzM90ykm0rq/ty3ISUsG9V1h1lOHrlRR+jNRc1UumenhTiy5o/nBBrIKcYSt2b
	nB1cMMrfJYEaPSjnuHDZiD1v8IldR2sgvF8KdDTfeFE2CG55NLu+I8kEUrFHmBHYSjuWxyGuEsI
	441Sp3dqiGRejPiR54iH8E3Kx9sPXRcsng6rJiKBQFvlNDIzE2A9mc/7IceL0q9dqlX2XbgTWut
	tSfMnJ/oSl74Mh9aFwicE/1asN69EjJVuUKmyWWqSnBDT0lk8uYXZPQ0chWCL40=
X-Google-Smtp-Source: AGHT+IEMzZIo8rHTV1Dy8xpK/5z2eXt1opT7nvqywgo9i0ShyunydBCLs1cS/ckJWtUYCIoMRCwBHg==
X-Received: by 2002:adf:a454:0:b0:391:4ca:490 with SMTP id ffacd0b85a97d-3971e3a5680mr3380574f8f.29.1741967477465;
        Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default for TCG
Date: Fri, 14 Mar 2025 15:49:05 +0000
Message-ID: <20250314154904.3946484-7-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to test all the latest features, default to "max" as the QEMU
CPU type on arm64.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arm/run | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/run b/arm/run
index 561bafab..84232e28 100755
--- a/arm/run
+++ b/arm/run
@@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
 			qemu_cpu+=",aarch64=off"
 		fi
 	elif [ "$ARCH" = "arm64" ]; then
-		qemu_cpu="cortex-a57"
+		qemu_cpu="max"
 	else
 		qemu_cpu="cortex-a15"
 	fi
-- 
2.48.1

