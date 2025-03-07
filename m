Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE772066F9
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 10:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741344936; cv=none; b=JdQoBvBukkDzxYSA4I+IgVh7Q2FTdrmD8vAg4Cb1UYYSabVMF4RL6fhQcsuaFa5nnjlXmkP1sV8Fx9O9/8rPCeXZAXWOiLTubwi0hPwiUmoF6iDRS+nNwc3F2NfYzODw6B17eMpjamDffctJXyZtN8hWX+FVESD90tFlAgYf/no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741344936; c=relaxed/simple;
	bh=rUgfMxakYAyG1K2sQb8oARmISO/+0M15GeWTZWVVqQ4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UFnIJuPA4OCJfsb+OUTEaPe05miBKWUkaNqbOBbpPvEmrsgQnvaESdNFY8CANydQVzSXXCMy7ftXqq/XcWJiucn81cXqSTX/4lDrbhwPZjB0Rwv+/UszHKDY5xYbzk6F9pyzrZfFwSMPWM99NLrpBD8NfbF1R3NpgzMldJ6YVHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=il8bsfiO; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="il8bsfiO"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223fb0f619dso32862495ad.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 02:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741344934; x=1741949734; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LHGAvVOy+z7tslJkuRFoq74XjD23wZovKlYyMhZTzi0=;
        b=il8bsfiOuM48Nim9Za5OerzYyUAkUegmWspsJhPQk/x1lhigi6xXMb1L7C5q/Pb6jJ
         6K0lKgWD93yQgh0fVDDUsrCvTCZ6i9mzYEla7vuX50M+6YVS3NB+NhakVCD84uoIw78H
         DUNqjlDS/UEdHkvmPcwW6Om6RA0EaembAAUNpu//bBqTkzxvC1kOr6tHhCAyedlgGNtx
         ZYfi6yaQbaY+YsoFOvlHDWShVA231usNioi0OUR6aFCTiaBZu67wM2XXu59TxOGK52j5
         Ah3hJr7h6XjiKk6wHav5XlvyhsiygJzPcxLXoW7miSpD1cMhY/llA6odEumOOtv+ccc2
         x21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741344934; x=1741949734;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHGAvVOy+z7tslJkuRFoq74XjD23wZovKlYyMhZTzi0=;
        b=AWMt4m24M22LWkb6aIMIsOfaKFBoRbAVV8oqAlptFBx+svSsExolu+eutjCWdrtoI0
         n4etEQz7qvuqPACFol0ZndqssFoAIA4nWqtz3OmDJnnS9dZgI0GVn848r1qRyXo8hAxA
         cWS1T3r5jOAjPpdp8qfYhrACYHrlYUqOOth1Civ6GLj2nqHwERpLo2YHC7nf8X8GAPBH
         ls0/GgsLOOSxXo2q6NHs7UTPcM9FU3jNp+5ShNa/DpciMphS38uixD4NnmZty6gpUppI
         hH7SuUdY5bhElG4T88OQHC/dZKWWiVk3Y0mktdcYAc9FCyyoqS7Ccsvsq2MGugd9U2IP
         ZcjA==
X-Forwarded-Encrypted: i=1; AJvYcCXjuQXRaYka4dUZmI59pJmoWhuQO655+hN70TUoHi1NJ0G2eYd3EPYuwDBt/ofDZsx/Lao5As8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcjAltVejAJgj0e+TK4f6/1W9rACYqH6u3eyxkcy/GdVfonUsN
	pCIoqzwb3DoukoGJ3SbGHVJqp0L/bsUtsUYXOibkAWV4Av777i/I6Z7X9WCLRXU=
X-Gm-Gg: ASbGncuUFy4JkJAPxyCla+/Z7F171QzgVOEaTzjCCnLq58iXbuAcOXzJ2PlGvD+SB19
	XzFSyc3+Wpdqpa8rgtyuJwKIFNJWkLOlv3TWm6nYXfrMnfnmU4IarDb4YygwGbyfjVxUHR5SRgx
	fN1h+4LMm3h/TrsWyyD6Ueyve7IJXlofczx9Bx1U8O05Qtser8bmk/+E9FUaQxRJceGB3c7UBi8
	S4FzPCvVtQRzBVSDHzHMvNodv29EgQU2ZPNaJljCQMG4momsAWfN13DDNSZF6ypwBfRC1nl+ean
	PnDb00mBhC7jo44+iW3VUtfqceD4hcoROz5nkZFBXJRP9DCu
X-Google-Smtp-Source: AGHT+IEiVKc2iHhF+yedYxasrw/RgvPlEuNFYHbgkXWiWq7Wuopt6Hk+svT+6fLFsvnb0h5t9ef08g==
X-Received: by 2002:a17:902:e811:b0:221:78a1:27fb with SMTP id d9443c01a7336-2242887fe65mr42409665ad.11.1741344933733;
        Fri, 07 Mar 2025 02:55:33 -0800 (PST)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22410a91e66sm27027945ad.202.2025.03.07.02.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 02:55:33 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v2 0/3] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Date: Fri, 07 Mar 2025 19:55:27 +0900
Message-Id: <20250307-pmc-v2-0-6c3375a5f1e4@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ/QymcC/1WMwQ6DIBAFf8XsuTSAtZGe/I/GAy5Q9yAYaIjG8
 O9Sbz3Oy5s5INlINsGrOSDaTImCryBvDeCs/ccyMpVBctnxlku2LsgmxXX/1E49OoT6XKN1tF2
 V91h5pvQNcb+iWfzWfz8LJhhq51SvuGoNDkbvnrY7hgXGUsoJXHQftZcAAAA=
X-Change-ID: 20250302-pmc-b90a86af945c
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14.2

Prepare vPMC registers for user-initiated changes after first run. This
is important specifically for debugging Windows on QEMU with GDB; QEMU
tries to write back all visible registers when resuming the VM execution
with GDB, corrupting the PMU state. Windows always uses the PMU so this
can cause adverse effects on that particular OS.

This series also contains patch "KVM: arm64: PMU: Set raw values from
user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}", which reverts semantic
changes made for the mentioned registers in the past. It is necessary
to migrate the PMU state properly on Firecracker, QEMU, and crosvm.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Changes in v2:
- Changed to utilize KVM_REQ_RELOAD_PMU as suggested by Oliver Upton.
- Added patch "KVM: arm64: PMU: Reload when user modifies registers"
  to cover more registers.
- Added patch "KVM: arm64: PMU: Set raw values from user to
  PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}".
- Link to v1: https://lore.kernel.org/r/20250302-pmc-v1-1-caff989093dc@daynix.com

---
Akihiko Odaki (3):
      KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
      KVM: arm64: PMU: Reload when user modifies registers
      KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}

 arch/arm64/kvm/pmu-emul.c | 19 ++++++++++++++++---
 arch/arm64/kvm/sys_regs.c | 44 ++++++++++++++++++++++++--------------------
 include/kvm/arm_pmu.h     |  1 +
 3 files changed, 41 insertions(+), 23 deletions(-)
---
base-commit: da2f480cb24d39d480b1e235eda0dd2d01f8765b
change-id: 20250302-pmc-b90a86af945c

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>

