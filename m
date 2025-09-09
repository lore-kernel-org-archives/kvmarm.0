Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7021F30A4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402608; cv=none; b=KGOCsYX7+7EDXUah0gVGi+LCYf7yGlRQk2KQf+TDbDqtaXMoa2sosW8tt12Jhg4BfoBYmqOkh/d5t+PSinkSa6bId7dLBXN7s1iAtc67YKyq2nSsR1R9uTJRHMLr8T16DqTCm0IK+dhIgPTf9o6Bieu3IxaB1zyPwB6n2DVcoqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402608; c=relaxed/simple;
	bh=9GIA2BFF5eLSy6mrBzqSFzk5Ex1qE7rhRRN0WvjbZTE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lcwT/9/9J0kEVW2tR0F1zqlQ5ykEtGEdAb43EmUxAVFuuPQ4/lS4TDk11bxDwAOtWn3t8+LUvwxRAoZ3S1ZrDvBL/3rtZH7UtbqrIJnRTfkocMSvL0/pp9oRD/MGxhXrJeLWC7lHsR2XOVrFkpGqNhg0PviWTxmO5z83K7xjHVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ieUbXtZP; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ieUbXtZP"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-627eaf68bbfso2888619a12.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402605; x=1758007405; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=txk6Ntr1OB9E+08Z6A0ZYjiGrZLcfjKX3b0L/eGpWQ4=;
        b=ieUbXtZP0Zj1Q7QUcIrQCl8AvIghPrD/Z2j2bFx9cqd3LuwF8fesCZp7rNQzzDi4K/
         dStXp/+xCaTzdiXc4geG8jnIYq2fVnCco7CamO4MbclbzPfbhBKW9ZyCTZOhC6aAWzth
         xiCJXR8n08hxhphB3zwLV82BspWej4N8APy42YWqojEywawzvBDfro89fNXPZLt802hO
         phSn+Ty+/w57nQ3pY490Z0kYDIrBxZzMcgw4J6zeGr2s5h4fiwcYPtQiSeh8jcKiPcF4
         khYWrj+e6aepv90H7sLQ8fR1k63s4pRceb8WossqX6LfXQSdnKbnhIeKcMQE/n+eEi4k
         yzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402605; x=1758007405;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=txk6Ntr1OB9E+08Z6A0ZYjiGrZLcfjKX3b0L/eGpWQ4=;
        b=DDKEiv+SR8xjajadMQD+tjBO2vC59pZ1p4QPlmVYTgucXPKP5pyMEGWnXBcl7C7xz6
         gQQWVJ8ctnsnOjQ3Z7+qEwKlm7i8T88/pZBmX2mQqafRIGu7idPYcZpnIG87BLrvc+ru
         CdiRKE6EtrVPUi3A+Vzi73p1zh7xfTA0LEcSVSJUxKzNCUuUJQgjWh9vhtlHBtpUXoQI
         o+Y1g+i2ccAQhm6Ghmy1hWJ3U5eTqUPOXhvuyGGnDtVZ+f7OZTBiSblaqM6fMKI9n3N2
         vLRQRrmsnvww1Q4MlfbziIrIjJL90RlwflYJppFqkGwTcPWlujPkcE9hpekEun9KygyZ
         8jrA==
X-Gm-Message-State: AOJu0YyWPVNl5RmeV8fbEJwWXI6nrOr3phScYx5gFN0jWHldYHud0n9P
	5AFToQI0jgXSe/fORVQyyWL8Crf20XRWNQaJjkL8slZTVByhP58ANs7MpeFC1M2mbvIAoFZCmt0
	D9zNyBxX7IzHTQrnb/siyoE93FGsoACXmEyMs7mMFGQ8wn14XD3W5ThzpHQCpe5FNj1wTyzCwP+
	E9+I2wIVU+Z0c4Z0fuZUMx7Ssu/xGs6IU=
X-Google-Smtp-Source: AGHT+IE31mnI8tt35OKxh/bw5AtNubsZRR5apcr5fYboVoXcoTobk7h9dG7B1/QBDvJejQNdbu0DvRO4TA==
X-Received: from edbin10.prod.google.com ([2002:a05:6402:208a:b0:618:3425:80bd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4416:b0:626:d96d:c0bb
 with SMTP id 4fb4d7f45d1cf-626d96dc3e8mr8167866a12.9.1757402604824; Tue, 09
 Sep 2025 00:23:24 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:23:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072323.4106202-1-tabba@google.com>
Subject: [PATCH v3 0/3] arm64: sysreg: Fix sysreg field definitions and
 generation script
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The sysreg definitions file has a few errors. In Enum Security,
NSACR_RFR is set to 0b0001 instead of the spec value of 0b0010.
Additionaly, the sign of the Enums DoubleLock and EIESB are wrong
(should be Signed and Unsigned, respectively).

Moreover, the file has some redundant definitions, e.g.,
RCWSMASK_EL1. While these redundant definitions are not wrong per se,
they add unnecessary code into the generated header file and could be a
source of future bugs.

Fix the Enums and remove the redundant Sysreg definitions.

To reduce the chance of this happening in the future, add validation to
the sysreg header generation script. I didn't want to go overboard with
validation, so I only added validation that would catch most of the
errors that I've seen, which also are errors that wouldn't generate a
build error later on.

Changes since v2 [1]:
- Added patch that fixes field sign definitions for DoubleLock and EIESB
- Removed whitespace fixes from first patch, since there are more
  inconsistent whitespace use in the file, and fixing it all would lead
  to too much churn.
- Collected Reviews/Acks
- Rebased on 6.17-rc3

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250813164506.1203851-1-tabba@google.com/

Fuad Tabba (3):
  arm64: sysreg: Fix and tidy up sysreg field definitions
  arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
  arm64: sysreg: Add validation checks to sysreg header generation
    script

 arch/arm64/tools/gen-sysreg.awk | 20 ++++++++++++++++++++
 arch/arm64/tools/sysreg         | 18 +++++-------------
 2 files changed, 25 insertions(+), 13 deletions(-)


base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.51.0.338.gd7d06c2dae-goog

