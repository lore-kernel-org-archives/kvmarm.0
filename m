Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F3120330
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118465; cv=none; b=nRpkxy6koEdaoKAd6fx/diA2q+XS9d8ZHZcYYQgeX56+SvmzDItg4LdGxXoS4EaOFfpGtx7XftfCO3ayiYCq9FpNpUOJpZOfCnBprjYtxc8P5zkqx3mGGdQTvAG+AaDOmBJ6eL/+9uzIDzXxcPZxSYvu3yPTiBUPDZ7T8wBeGeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118465; c=relaxed/simple;
	bh=KcTfiSOyKCaCnQHcVlRQ6JHTHx9LGVQ9b/cadvjGZ/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZx6qHBvPM5fYBGn48iJ08bGk45l14UPlGDDgngQ8scg1pfLF63ubdPtqcT5SKYgq/gSbaaHsqxxNc95eDSLeXRhHTFWQzRN5VGHwYbo+X7qLfAuALF60eBqcU7CJQNqEvPT4pmyXwmezMQBd99GocV66MTj+QzVcaeXZbB2jJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ku7q7/s1; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ku7q7/s1"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso6048798f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 06:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118462; x=1744723262; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tLzGVjfFwFoyJPuo3LFygEBdjW+ximdrgVz6RHGw44k=;
        b=Ku7q7/s1bt9eA3kuCE2c7lfOclS1jls84DXCPkE+WYVacxUc+jOsAE/xZPVt0iRge2
         vToUMErQ+gfi8zHX3NMJ4vHiE0jL0v4vhJSjZmyL8a/0DZhClXndyeQp6JnzQTENvuIi
         D2wkiwwMl5l40swhEroT8eNNtvxSna+vy9d/Y+oClXUcQMiTW+a9XiVe9/KBMnvO7HrY
         bIzjHoEA4NDfduzpYWXFd2ntvD7iK3xiPXWku2SGOJbtLYWQczC2XQka6w5xQ0RbZihu
         1grNR828Ohl8Nq52HDUUVmVeANRUbnEj1saLCZELJih17O5N0pftyTDa2scmwS/H/yCa
         RQ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118462; x=1744723262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tLzGVjfFwFoyJPuo3LFygEBdjW+ximdrgVz6RHGw44k=;
        b=RnDF4sVhSvBdE+qZzzRX4Gj9agH6bnSz6DRJX19bopzEedA03LgQN7QOCSM06+z6t8
         SD/ADdCUIyYhSHtJHmPpGMlVjD/AdM4qEVyL6RkVWXgJe2uDUnKv0lWSeM7seZVajB3c
         +mEoVGCEklL5zgwebl3hZJp+pRBoypDKGPulcPozBllaT8t3ArBK0OZGwTGV6yDAe32c
         +VAPTl2MSYSdKsvjHrdQkjGujPh8mGNV0b8BT1P3F5xtyCrJMsH+mSmcoyH+/ImJnbVh
         wMnZ6NgUjsmiIsh4ZgpIdPqgnFSX3SHPlyzR69CA00235kjoSHRS7fBYSu0+zCj98OnR
         R+YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy9DKerrlHPdXuCLUQeiyPEnGDrBNRvxX5UVvVVo5l0ZxJ3Ek0xWHDGqf70oE3rVc2rPzlkME=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywmz3t1mVsaFYHsP3VCeq69SavIX5VSELQCQsrr+USBII7OywWL
	h4pdo0mKCUkVpK6AMhhcMxarEnev1O00WIh3PNFUcz7fHM8+dX3z0W9Cu21Adk0=
X-Gm-Gg: ASbGnctJfeyBtCyJ9iuK+EJUwibRhisCN8xaHPbOcS5a8nTMof7O+QXMT+qE9RecDI0
	FRTGL9OJ9qE+ewnAsSxyD1pgiaK3OnD6qZ9SPT0D+WvhVGqJfX8+0lqHEXQ3rWIQMpT/NKPYqWv
	9ALperqV1K7U8yAyspbmnrjJB7DgETTKGrzO/qlDcSUCTw3JB0T0YgSHzmQpqUl1MfOdOEO3HEO
	7uEScg3TgFV1rd+BAJQtRsCQbhKrIabQKTgBqlyCgPdTvQOo0ttFdDPprzZjcNuttoIIVa/Cb8E
	oEhhol6ajEvbiur4aQ1SCzTs9RIgZhTOsGoI2IyNpqSMQXAhn16/2t3RhvBv/LI=
X-Google-Smtp-Source: AGHT+IFUXJbj+KVBhVs4CmMtvIJd0GuXCkofSH+KbPfymhQIkFcV7EPYfaSIBB6hI0EIGOuLDwtPXQ==
X-Received: by 2002:a05:6000:1849:b0:38f:6287:6474 with SMTP id ffacd0b85a97d-39d6fc49319mr11362861f8f.15.1744118461994;
        Tue, 08 Apr 2025 06:21:01 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:01 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 0/5] arm64: Change the default QEMU CPU type to "max
Date: Tue,  8 Apr 2025 14:20:49 +0100
Message-ID: <20250408132053.2397018-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v4 of the series that cleans up the configure flags and sets the
default CPU type to "max" on arm64, in order to test the latest Arm
features.

Since v3 [1] I renamed --qemu-cpu to --target-cpu, to prepare for other
VMMs.

[1] https://lore.kernel.org/all/20250325160031.2390504-3-jean-philippe@linaro.org/


Alexandru Elisei (3):
  configure: arm64: Don't display 'aarch64' as the default architecture
  configure: arm/arm64: Display the correct default processor
  arm64: Implement the ./configure --processor option

Jean-Philippe Brucker (2):
  configure: Add --target-cpu option
  arm64: Use -cpu max as the default for TCG

 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 ++++++-----
 riscv/run               |  8 +++---
 configure               | 55 +++++++++++++++++++++++++++++++++++------
 arm/Makefile.arm        |  1 -
 arm/Makefile.common     |  1 +
 6 files changed, 63 insertions(+), 20 deletions(-)

-- 
2.49.0

