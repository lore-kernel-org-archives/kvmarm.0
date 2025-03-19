Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F9625486F
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 11:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742384342; cv=none; b=pN5/lea/ma42k5umboBcweF23K5o3HlRWILb/it9taS0coAZLo0seBIo3p8OEWqZfX+yzNBBLQosoyWTuna9dOIRS84tbJbr+UpqZEJ0SHVW8VmDyoy0D4j+CN56Q4ppy4kO+tw3LFz75hQ16kzX4QYoJiMxPk/zCsOg670zq5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742384342; c=relaxed/simple;
	bh=Qvbtm6dfyen457gJvLvjX7P5zwfcn2yAepr9V7TxW98=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=k0j9QhnbbilRtyzWhfzuoL88tcf4+9zJ0mjqvlUjwDv8ikocYf5ftvwJfFS4cbTmKnldTowpwk0n+K9bO2OiaNZ1zA4BDkt0prImAgeRlO73Lw3rZqbywUj+LLiNqOdRGiiF9f8Y9E44/MS7b2dEeCeb2QQrK7nBf4s1FjbYv1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=MU7oltps; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="MU7oltps"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2255003f4c6so119807935ad.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 04:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742384340; x=1742989140; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3b2WbG9Dw9w7LVvz8ibLRK4Lkcz47Aas7wt/j6jq4h4=;
        b=MU7oltps1usFUmD+rHuwCt+6MLtua9evejnsw2v1IU9CRSGmJxIR0/USK11v0tY4DC
         K6wl9Sx8TebDL6jfu1LxUilDU1hGajC/m84823QETiNeLEsYSw6KQitXdiFsGAtfoFOl
         PiBPzMS6AcKqfEphY43VZYErZcpKzYRqkI/QsYDcww9TUIvUW3GXyfjG58CVNoj4BKeO
         NqNw2n4pwz1iSH+/VcXsAdcLq2Z/NPOkd181WkugbBW5P1Ea7Thq1JSxRb3v25Em+4CK
         Wg+28d3ephS7aKoN1OtVyCTinfmnburEHy+1ftvkRDYRugxqiSbsj9tUiMBjYxWf7yl8
         QBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742384340; x=1742989140;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3b2WbG9Dw9w7LVvz8ibLRK4Lkcz47Aas7wt/j6jq4h4=;
        b=CKjzZkrXkfaDyQbwfkPu+4tkg/LlqorMm4KiC5NjxjRq10OdWPBAYCBwA9MdYM+wkJ
         skvDXCQ18VcQ6Uco5+ls6mqtrH0UfKJ50LqC9GtgRLWii8GSWuBJYYdKViAxlnDSL1Bs
         xZk7NNKoE+KuqA/BKm9Mo6TRi2D7CQEr/JlqMcKR1SufrtNWo+hDgXuSX+WntCTmvKoM
         d6dRwIVAlkasW7QedkqyScN+/tvQwCIFX/vTPVp3CHh8QSEHvwtnKyg9aVMnd4Yff53A
         iYc63ilOBPtPj7KrAE+T+c3giGQwH+MB0IjmX44yN8Hf8C3JtTKmEoat4z5z026Ueucx
         RMKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU62ktyJkXg0Og4NjElHIoiCEzQhkTu6ZlNAoP+CO5pWHnYe9+a+rNXgtrmsG165/7OwJx9VM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqwmcdzBB4qz+40pfVkxQRKI/aYyWgMKflZ5odKgaxnQ6+NSk1
	0L0D+fmeLHXu88ibpNIXBlzPxxr2aqtG4oJuqTzKdViUv2m1LNJ0NKnpdI1XtcY=
X-Gm-Gg: ASbGncuxnnfXISKMohuTXiBfwVBTmkJvQlSmxlJ/t9NjvBoZNIay5mu6M2XXR1EEYxB
	3454OZLUMcn0GJjoarJgfF14SzZAIUdAg1Zo1/806X51KxxwpJZa1b2Zw4WmRplR1SeFgyzVwOj
	D6XBdZT/J7C/yjqWVYJhaQmnPnirVg9TglxIT9P7pljqSSPpfdaGft+Wqov/9gi/D27hSQsfCbx
	xcFCjTFdHw8vMsVGxtUGeahb6mL45lZALLAX8kKcEeyVgpKGD5ZZ5yR4KXR9RlWy5ID645m5snm
	v6QILDWWb5j4W6dOk9fmw5o4qcvJRw6sI/oW13lpwQgX6id3nndioEw5x3U=
X-Google-Smtp-Source: AGHT+IHYkRexp+H54sKtCJdj4SxUrr90D/xYbMKs4ypn4d6oGXxC0eDMIKC5k+tCMEC4GAo2sNq6EA==
X-Received: by 2002:a05:6a00:234c:b0:736:6ecd:8e32 with SMTP id d2e1a72fcca58-7376d6ff2b7mr3715385b3a.21.1742384339843;
        Wed, 19 Mar 2025 04:38:59 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-737115295dasm11333924b3a.30.2025.03.19.04.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 04:38:59 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 0/2] KVM: arm64: A few trace additions
Date: Wed, 19 Mar 2025 20:38:54 +0900
Message-Id: <20250319-trace-v1-0-0fff03204efa@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM6s2mcC/yXMQQ6CMBCF4as0s3ZMW5AAVzEsynTUWQA6rcSEc
 HcbWH4vL/8GiVU4QW82UF4lyTIXuIsBeoX5ySixGLz1N1u5DrMGYmwtjW2susieoXzfyg/5HZ3
 7cFr58y25fI4whsRIyzRJ7s3aXF2NSg0M+/4HaKrISYQAAAA=
X-Change-ID: 20250319-trace-80cb8d39de2e
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

These are tracepoints I added during recent debugging. I hope they are
useful for others too.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Akihiko Odaki (2):
      KVM: arm64: Trace values with kvm_sys_access
      KVM: arm64: Trace SMC in a way similar to HVC

 arch/arm64/kvm/handle_exit.c       |  3 +++
 arch/arm64/kvm/sys_regs.c          | 24 ++++++++++++++----------
 arch/arm64/kvm/trace_handle_exit.h | 26 ++++++++++++++++++++++++--
 3 files changed, 41 insertions(+), 12 deletions(-)
---
base-commit: 8098cf067a7aae92a4f293df03964bf8474faca1
change-id: 20250319-trace-80cb8d39de2e

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>

