Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D234224AF0
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759240623; cv=none; b=jEeKamzalRytIFlP35fI1QpD4HLg/xCxgLTyzr1ZEqeHRoSWZQGZqJGwC/ACdrnuoM5KY9HG8JetzHpPNWytq/SscidWGDGwVris7p1pVSf9hxVg+API5sVMYPdzjXQtLYKW/sr3FxiwqiOVVwleLjgrR7+IlrMRE6bfsZoqY+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759240623; c=relaxed/simple;
	bh=qtFuKldthuDqI8ZR74+ZNU7qKNRVPEmO3MK92/BIjdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ROvANASswrNCPTnBTXOL5DCs26h66Ug9UkGEUOnQ9FkfNbfUjhgdWc+tc3x+FzRXABuzdL/cdOpL9hfHHbIBtO84IbpfOO47IyAh+eXOVc/sWZ2sz8xGdNs7xx2cF1RT6rKuoTSPQApQmCNEffFhy8oRUG+LC/Wx/trRaGlkdHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xj+0dzMs; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xj+0dzMs"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e5980471eso7632455e9.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 06:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759240620; x=1759845420; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A1FGc0c7Pyt79arhBSB2ZwA4aD4/D9YDuG4eKl/UZpA=;
        b=Xj+0dzMs81g85WTddPPbaE07xZZUU2vMcoC103Mpphp5/2ZQkuiu4VMcJXBZ0Wmn81
         kdGcNCg7KxH9E7dYNeBnp4g2B09MvFzbsqiaAdNdKwHGo+nxvaB64/kL1JHEf6mydlJ2
         7joui6rT5DRY9qbZPFOktSAx9c7MLRs5+TrJ3uzv4rU5HiS0bK+pjW3vuNzqG4y7pncH
         Ws0i30oIMyMrJiFJZfujRmk4GlaiYxHNlUr8fiv9VMhR9NhJSx/uDZFf8wIIhVcF7G98
         Uig7wqL1BqqPyeQl5bxNVkDMYkGK+xxzoR19gf/Mlc6IMm+15cEo4qz/ogBelAIYLObb
         CZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759240620; x=1759845420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A1FGc0c7Pyt79arhBSB2ZwA4aD4/D9YDuG4eKl/UZpA=;
        b=CaLBQfffXIE8OzZoKMRnpf6W6NcnOJINxMRjN2Md9WGY22GydT9BJVU5h6S/T7YhK/
         yOxBwqz3fpEzDP7cs3PCaQWR1kN/pFKQdo+pwMUREoTkhGLcPDaZeVIagTxiHRsdQxJz
         6EXYPOLV0lkO4ry3dDCcq+n6oxxm64jLNER5zN/M1mvSx5dfxIUs5zm2aGefzaRcRQ9I
         qNA+JFPmMvmF3E5sZOt2/2RdJQJQi/3OzOWCaoeA7tn4SiaPqHzKxReG/ZTp7mKl5uI4
         gzA7N2HEwlKxsmQ02EPQh5Gd02Ua2M9hjmqmX1xtE6vC4BsaoRDgHRA5tL9YYFej2xpU
         Akrg==
X-Forwarded-Encrypted: i=1; AJvYcCVXhWOu+kPcUYQV36lVfUjKqp8xnVJBaBKwNeFeylRG4C7OZBEDLJ7AWFSBzUjYktRyhY/qmj0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxii4hW++X4ycGVhQCQC9p5J8ov0fzDTOZWCHGflip9/pFWbk34
	HGHwURCVcZTSKtUAmKaoMGj1JZKeYO0n+4rFaoNWTzQXui4fQchvbpHq
X-Gm-Gg: ASbGncvCF5RbAX9dHlNbxynSEVkZzLAe6iUFDEFdMXAKkAu24BGitfWmj2jhK7cfWpY
	Z80yz6VrCZPI/2xzzasPIAOwHbcZGufdH6ZDebFqfr4M5j68o51nDK803Fvc9Ut6khqynpPF+9h
	KHy9uudZS5RlCDIGKpITRoY6VSsWIJNz0+0Ko41i4oj0ZKgFKk6EOLnUXE5q1zOka2INOWZI4eX
	aJmEVVFMUst+FS0XQ4O2BsymY2Wax5cwy4/oQOztz5DhsD453p6hM7Ev6x3w2Q1TzWLIBm6swDj
	K1eDsmesnoLjaCUW335VNgcCuYqFCGPwLZBXEHGcU0iHPj9oJZCpyFjrmmRDE1IgrLMjF7APG2A
	yM3ao+FqeJgbtBmiM6TxI37JkeVeJbp4yfnh1GxBTikIbGS0Nnxx7VzTEmOv9E+xD9coVlaF88R
	vWnuqwkgHQ36m7ximeEU07Ib7xcQ==
X-Google-Smtp-Source: AGHT+IEl0eV+Oe9fa7cMgeQckQ/Gji3bBkOIXAKMi+nEieK0u/LUPG6fuatnTc3ieztZ20R+dNzEuw==
X-Received: by 2002:a05:600c:4743:b0:46e:33b2:c8da with SMTP id 5b1f17b1804b1-46e33b2ca06mr166142075e9.32.1759240619373;
        Tue, 30 Sep 2025 06:56:59 -0700 (PDT)
Received: from osama.. ([41.238.33.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-41f0c467ecasm10062839f8f.38.2025.09.30.06.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 06:56:58 -0700 (PDT)
From: Osama Abdelkader <osama.abdelkader@gmail.com>
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
	Osama Abdelkader <osama.abdelkader@gmail.com>
Subject: [PATCH] KVM: arm64: Remove unreachable break after return
Date: Tue, 30 Sep 2025 16:56:21 +0300
Message-ID: <20250930135621.162050-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove an unnecessary 'break' statement that follows a 'return'
in arch/arm64/kvm/at.c. The break is unreachable.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 arch/arm64/kvm/at.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index d71ca4ddc9d1..b04c00f95944 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -43,7 +43,6 @@ static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 o
 	case OP_AT_S1E2W:
 	case OP_AT_S1E2A:
 		return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
-		break;
 	default:
 		return (vcpu_el2_e2h_is_set(vcpu) &&
 			vcpu_el2_tge_is_set(vcpu)) ? TR_EL20 : TR_EL10;
-- 
2.43.0

