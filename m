Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879B288C1F
	for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755103512; cv=none; b=mAJ0nlGMIg5XOxrmwQzu5DkqVKtkXXGdpNM+HL7TCmO47zGXtZP5/6JfvSN2CiTIGox8FHSsJHg4E1NK1iloGuAth3VrV7qnQ3lFqz2vJjWkXe3Yvk9bpp8lKr0bUeGZ1J9lXvVAmNi5tqs91KltF6Z5s2mwmkw+NYw/C/ZNVKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755103512; c=relaxed/simple;
	bh=EjiuLxZT56+7VxVscZG/+Ytzfkhf1KNKoogTvoqEnnA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=U9Xdv9VTyqEftPLpbug3iIVYWTOfSGX6sG7rWZahm/0HUs/jdaD/MWRba0b5V66191DsFmgddCdL3sKRbfRhjk5RsH2aAlM/wfeXrN0EpUzB02Qd+3I2b4EnSoE54uH+Pnef4onxkDYkTtczRb9/TrL2WaBtPSs/GTDHtrgtuec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lsg0LcqR; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lsg0LcqR"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6181f6936d6so3107846a12.3
        for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 09:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755103509; x=1755708309; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i58vDD8ciCG4tqEiOdS2g0gU9MJ6vUoA6yHuonpgaXs=;
        b=lsg0LcqR72x9hs3STe76JW/x+QU1PwokhZKB2vztGWWF4LUaGxKGAjM5nzRz5xTxE5
         pOXGJWFAJYZhTmJhFBRMP8s6Ic7HMVMm6IbDtkx2ae6uMZj3GMbS4et0v985wlj9pzyi
         lEy0dBJU6ESjmh350hWGuHEI6XtWCvpwAStoyW5Ozw92ldayaz/VV2Au6Cbxj+HszeB0
         8g/eyB8CUchtniPIHDaXt1rL97s0QcRs7NHmlVhPYb7VBInnqhZDqDRV9NqoTO6sCUC+
         yTPvFOCnhwwIk9w3Rpf/zt8Bh1rBpAu85hY2LnqQaZyFrGoaLAU9sLJvifLCI9rKX1gg
         lfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755103509; x=1755708309;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i58vDD8ciCG4tqEiOdS2g0gU9MJ6vUoA6yHuonpgaXs=;
        b=j5VMMuuygFI8gOptf/x/VayNj9xReAnQbRRtYD1ptBCOrm+rbtN1qKl/q/l3RBk7Ia
         6xFnjxilUDcnfwuxFuAyiHJj8fbL7zB4RBdhuDkwKel1nVCQUYi82yK/bi7OBVYru4oK
         2l7x+i2LInIyMMtF3CXBkBwaA1xDJXSOg2Wl5e5iMvXRVI7ubhywlI3kyqxCyDUA+Jr8
         VdKUh1HX5kt59mE7lKTWbNPy5u4cIZ+4cqMSqK7ko7QrEOSlg57kAT/OvJ0RLVF4lP9W
         F8wpRBuNnjDGOsZRl8Mzi0/RSnCLv1RqiMiLd9V2iHkD344CAu0VlY8gMNIJhpVeBUGd
         ksQw==
X-Gm-Message-State: AOJu0YwqeuoUH9vN4vqBjDJF+cPMk4YRy33gbTIvy4nSWW/SYUxGd2og
	3e3cdmEqnIpURi9KXOQGYbP9iYhUYOTqpVKr4ni7BeIokuyk6bQOGDmztI6fn3SsM+daNktrpqN
	jhyqdmvirfomH5rcYU0kOvUTwiw0WA3C5t567nqS6uT3QjXGQ/sbEni6vwbaFdB3PAwt6Nq+SzW
	XRlSCd+eDZ+SZpxYGKaq8xb+UKpiLqzW8=
X-Google-Smtp-Source: AGHT+IF0drcCjeBdG/uPQgP82HDkur1vntaYSIKvrMuZrEM2KABBBPD2dmHvJX65Xz6iE3/3L6JbiBwVPQ==
X-Received: from edj1.prod.google.com ([2002:a05:6402:3241:b0:617:b625:f131])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a50:a6d3:0:b0:615:a847:c179
 with SMTP id 4fb4d7f45d1cf-6186bfc2c65mr2002154a12.18.1755103507594; Wed, 13
 Aug 2025 09:45:07 -0700 (PDT)
Date: Wed, 13 Aug 2025 17:45:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc0.215.g125493bb4a-goog
Message-ID: <20250813164506.1203851-1-tabba@google.com>
Subject: [PATCH v2 0/2] arm64: sysreg: Fix sysreg field definitions and
 generation script
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The sysreg file has an erroronous value in the Security Enum, where
NSACR_RFR is set to 0b0001 instead of the spec value of 0b0010.
Moreover, the file has some redundant definitions, e.g., RCWSMASK_EL1.
While these redundant definitions are not wrong per se, they add
unnecessary code into the header file and could be a source of future
bugs.

Fix the Enum value, remove the redundant Sysreg definitions, and while
at it, tidy up the sysreg file a bit.

To reduce the chance of this happening in the future, add validation to
the sysreg header generation script. I didn't want to go overboard with
validation, so I only added validation that would catch the errors that
I've seen, which also are errors that wouldn't generate a build error
later on.

Changes since v1 [1]:
- Remove redundant definition of CPACR_EL12
- New patch that adds validation to the sysreg header generation script
- Rebase on 6.17-rc1

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250808123744.2087648-1-tabba@google.com/

Fuad Tabba (2):
  arm64: sysreg: Fix and tidyup sysreg field definitions
  arm64: sysreg: Add validation checks to sysreg header generation
    script

 arch/arm64/tools/gen-sysreg.awk | 20 ++++++++++++++++++++
 arch/arm64/tools/sysreg         | 18 +++++-------------
 2 files changed, 25 insertions(+), 13 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.51.0.rc0.215.g125493bb4a-goog

