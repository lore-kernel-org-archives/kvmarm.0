Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE921E32DD
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395083; cv=none; b=HqQpYD8zlJknU20WW8jlRdHKTQxPU/9kGBhD8mVCP+Q38JKdWE+SbbIt7HBIhvefvIZTuj4fAeCv1Ys63nrF6j5ZQAWfIsfVQUtk6llHI4Eb7Hz/ssTJ460pKgjEbN80h95oaoSHy5HhYbDwrsQw/reTOMGXMKTIiNA+f5XmJwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395083; c=relaxed/simple;
	bh=SWQiLXz3UQSRH0sgda5pipDAoE1Jf6PULp6wnmA0Nrc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dWW+UcHiCQhuA1i8qlFaGbLkC37yAuLlzDtAiZW6VEJpmm9CaSnRr0QIyynaKkVjRtjEg5XrIE6VxTIYHwq3rsuf0lgCsRNVSqeKJF2AQxqKNOrut28Cm+9syGDgr5Zn/UZd0ZxaVm1i9LrdTlyQKMCrpRr8f3SQha6H7P4O/bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gvQjGWyU; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gvQjGWyU"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-523ee30e0d4so3337136e0c.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 07:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742395080; x=1742999880; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EAQMc4ueVeym6ao2O+BFRKNQiM2evdanfHeGpELVuW8=;
        b=gvQjGWyUcLZDixj6lBH240kH6A5J+pgU2Wtqq2bWI9bOJ1maLc6rziNMo0tMquInsk
         sUsLptjW4UdSe1hjI8N+JmHaNkW/bMbTCN8feb++9U2wA4Z5O17C+F4h1+0nsc92ffCH
         61txIKXBG5HCEIk1oehLlbQPFHNl9OBbfgOZHWzR1mPCkE3zUDKLbRkHJLe3YcIoi4fc
         Yp58JVTH48yT0xMA0KdTko6pZp+TuG30FBM/9dhqMVuM3YtIfVG9kfDBkBkwHPJNde8N
         Cc5Pa3kWhki2wBu3OUXf5B28Cqo9vbk2NrZebOueL8STgojKjuu67fxSsK4pPWvrNsuR
         f4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742395080; x=1742999880;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EAQMc4ueVeym6ao2O+BFRKNQiM2evdanfHeGpELVuW8=;
        b=UG4MJ0SOajRMgd9EDExLHEwREcOA0yoSTsRW4urcFYw5XT+XooYYw8yRiSKEnjCRB9
         Nf46kvl/aRPz4FmYe8dPwkb3idEdVIE5omZWZi2T0N5RMYLLTROMlnPokDTiXc4Hvleb
         ci1uMok9y5ErRl0xaQcpq6/uvVZTeVn3oW1IVTY/OImOMWNbsHh5ICDu2qjgAcTVX+mr
         +zrLVw1nIJ+7PgkAe7lTZ24Lhe5jn265WMtWuucZl+Zu+RmbMVqRA7/+8A0FHC+BzASA
         dtli5yY/obPl0LsqPV7Unh5fGfvjE+Krx/Rz5Vs/8suZOW8Td4j5rTS+lOelz24qsbhP
         ephw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ3xffmvKvKCcDIfSIu6hl3ssWh+P/dM+2fyIXehs+wo9PAMSsYVfWxnuZkzLNhyPIVsVH4cc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt5cq6Ka+7uWXlizl5jdhJDodPCgyo+P4CBmW3ekBAY7nfjEWL
	byMNisGKe/j384XJtzLcp0Uby11zkKGOmPHa51L2VQbFffgs6BONHENeP7G8RYlCpgk4TeBn9wL
	K/Sh6lGPkDQRgtoSRb+JvDgiCcpv5i5UuzAIXJA==
X-Gm-Gg: ASbGncvGEUZ77+ggYEjcCnW2ViP3SXyE9ATC3BgRMGu8g4GhuaRzdLkp7vlMEw+/iGs
	MHgxYzGsAVAyT44iWxkrJz1swECRoTEFm0fDwZp/L3eeGjoNrvUxRpImEW+tfA1gnj8Jon8SAcU
	yTREztRvcYIjXfzyuMwEiJJx3YZ4ksyrthuT2nfr45oFwcHWVMC+cCKxw=
X-Google-Smtp-Source: AGHT+IGxLhVT/ftDT8iYJ5Mr8vDPr54sfBtr7wxTMeJWhsyv6YLFWJHjY8iY8qPGLL2vFTHUSH2SqM4ZK2rC2ioWlfU=
X-Received: by 2002:a05:6122:1d12:b0:520:997d:d0b4 with SMTP id
 71dfb90a1353d-5258918cba1mr2246266e0c.4.1742395080564; Wed, 19 Mar 2025
 07:38:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 19 Mar 2025 20:07:47 +0530
X-Gm-Features: AQ5f1Jo_Jk6yP8Zz1gP_WLfB-CYzXNkDEG6hUQTy-hEqsCfLQJSmsIGoXWLSd3U
Message-ID: <CA+G9fYvPu+MQKhYyPZSSDpAn-zhRGmeHQ8hJksT_cdDdxfbB-g@mail.gmail.com>
Subject: Fast model boot failure with Linux next-20250312
To: open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.linux.dev
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Rob Herring <robh@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Aishwarya TCV <aishwarya.tcv@arm.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

Regressions on the arm64 Fast Model (FVP-AEMvA) caused boot failures starting
with Linux next-20250312 and persisting through next-20250319.

First seen on the next-20250312
 Good: next-20250311
 Bad:  next-20250312 .. next-20250319

Regressions found on FVP:
 - boot

Regression Analysis:
 - New regression? Yes
 - Reproducible? Yes

Boot regression: Fast model boot failure with Linux next-20250312
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Anders bisected this to this commit id,

# first bad commit:
  [858c7bfcb35e1100b58bb63c9f562d86e09418d9]
  arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9

NOTE:
  LKFT is currently running FVP Fast Models version 11.24.
  Planned upgrade to the Fast Models version 11.28 in this sprint.

## Boot log
  <No crash log on the console>

## Source
* Kernel version: 6.14.0-rc7
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
* Git sha: ff7f9b199e3f4cc7d61df5a9a26a7cbb5c1492e6
* Git describe: next-20250319
* Project details:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319
* DUT: arm64 Fast Model (FVP-AEMvA)
* Toolchains: gcc-13 and clang-20

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675685/suite/boot/test/gcc-13-lkftconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/config

--
Linaro LKFT
https://lkft.linaro.org
