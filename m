Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41116215C4E
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731409002; cv=none; b=uB29DswFewQnwCyUCtAuexvLM7nc+zJJXIdc6eT7qSZT7XyNjZDuhy6q/2izqycg0q64MvVD0Rgxw/+x3/WlOmyIhilIEYfnMs19fzQe5DJxpGx1COPQYHZ8XHFLC982k4Q866O3wF13K+Wr8N6HMken8PsU8S3NrnAqyDELO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731409002; c=relaxed/simple;
	bh=JZxAEgGxHQWBt6q+QSSE/uiFAiC7QtIJ1zAHsyKz/F8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PrCiFLt5K+6kFQgxuBR7VKATmOhMuj2uGWBQcITLpy4l7KugknKSNblUDDwjzNy8BkjafaP6clju/f0DV+tFUEJRn2hJrFmFZUimxOo3AajlUxdbwLP6tQxUQ2Q7C+pevwUslwiRaKWk2jQG57qRjPc/3uswsySvvz1/jJulQ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Me2iCtli; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Me2iCtli"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37ed7eb07a4so3643180f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731408999; x=1732013799; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SUZb9Z1/W7ca2STbTF5/tGFSoH8Cx+ksuikIOfGFMUI=;
        b=Me2iCtliXfkp5bfq/Yq4m3YLazX4eCZ1HfpGJY1AQnOv+grPHdcGE3jIq2EF0oi4cC
         AmyuADYOunviBz+cDVIJen0gyzdgW69DbiGXCYjiCdGPK7hjjRX7HcrJdve2ZNC//fzg
         4jgU9GKxV8JPaInlXZNhvybnVyib4BvrwSNH/ONFU5ysm/vVmzxlOr5nGQLlwuLVlNSQ
         YkyGg+HB7ozzE70+T7vAzf8A6zxW1rPIukdGx0jCPtmhY7yfh4UwOfJ7zsgH8Pmw84yo
         pLUlWOSaBe2r8PPXkQyFIB9q637dUyocQ9R1qNCaMLxN2s4cT2MQheSzJmxJFIU7ZTqY
         xaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731408999; x=1732013799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SUZb9Z1/W7ca2STbTF5/tGFSoH8Cx+ksuikIOfGFMUI=;
        b=CpEQjYZwgbcde6tZUolPNhWjK8ZZypNc9BM/znaRFK+nzJusFMg66pKvSdxHd1H91p
         d9i/miBWsvxtxNsFFaxUlzTcjyqP64JIYQ8ka8jtL4NAx+D/CyxQGA4t7+g+LQGfRMLD
         Mx2yHHEO4t//hDC5k6kfPYTlJmlBzQDQVovpW576Jg14uIlUobaTgjlgWBllhgqOoDlr
         Mbny3ZUy9omYZOyDEMROhWWKN9xArineOFOLV3ZcwsbZq+fEql0syXsueUuhZw8NLnIx
         eUMLGjKgKEMYOXFuYcCXu9vmjcd3MfPZcCC/ST4UJI4f09jQDaoagTCP0rT1oqb9qP0R
         c3zA==
X-Forwarded-Encrypted: i=1; AJvYcCXvPI3hGJT4XC3X8PhygADIv5Sv2kP6NvTdfcCzbRa7q49JhZUdS3p4C2vbB5BXp7E42uFF/5g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwtQGyB6QXiwk3Zd0o4v8UCwi8iDEAL2EiLacSvdK4Kd5u6bvX
	Kg0vdoDDTMK4CWyvhWblpu38i/rRzrapnlzByBVEL4HxWsr8Fe7ApI2jqDTyhZI=
X-Google-Smtp-Source: AGHT+IHvq8za4ODwagi9eMCX58JHSHwa35A0vD53q9ShdqUM3Ry91k3zNmwqMO4C+mOEfDBMTSJnrw==
X-Received: by 2002:a05:6000:2a88:b0:381:f443:21bf with SMTP id ffacd0b85a97d-381f4432609mr10071022f8f.2.1731408999580;
        Tue, 12 Nov 2024 02:56:39 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed970fb7sm14943629f8f.21.2024.11.12.02.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:56:39 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: tabba@google.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev
Cc: James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Pass on SVE mapping failures
Date: Tue, 12 Nov 2024 10:56:03 +0000
Message-Id: <20241112105604.795809-1-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function can fail but its return value isn't passed onto the
caller. Presumably this could result in a broken state.

Fixes: 66d5b53e20a6 ("KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM")
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 8fec099c2775..cbdd18cd3f98 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -146,8 +146,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 			return ret;
 	}
 
-	pkvm_create_host_sve_mappings();
-	return 0;
+	return pkvm_create_host_sve_mappings();
 }
 
 static void update_nvhe_init_params(void)
-- 
2.34.1

