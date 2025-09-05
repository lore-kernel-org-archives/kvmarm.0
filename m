Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72799286898
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757075341; cv=none; b=LoAub8Tgu93FsbTjEQDowptxGiNqyfVhstq/XwddH2NhNGh7Voz1ZUiUPZtOu/kQghXh7wsSqn1pGGAfOfBhSA8Lg6IAunK+SfaN7d0zZpA+maGmYJAy4AMs4DRiVo8gM+e6ZxkillKcDEITWW24sa7o3MKaR+3hrG4g/bVq9fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757075341; c=relaxed/simple;
	bh=1e+7pVVhym3gaMFer/Sr7WBp0M9KyyXCLvjyMZeZThc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=H6ipUvNDYFNG57HH+e9CXXXJ0y2lVPQHoekdZby1ms/ISH5WQC603RyfAHd0e3t2LJWz9kjC6BxiQwOuZlxFlHPlRnt46ktArxERe1MT74AsBda337qSRe1JodRVDJdHkbRfdTjRKNcQutlTgqG5iOaKnCMHSLR7lBzYBeElYO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bWc1WyzD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bWc1WyzD"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2445805aa2eso20648925ad.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Sep 2025 05:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757075339; x=1757680139; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vt2kS9Ofun09w/F1kEUInf1+goE6RJwp8Jq2yr6GTno=;
        b=bWc1WyzDUkw/E3rIv+X5AJF444XiOHLjzzgGmvdxn123lZbOo5aQ3KwiGOqSLxZBql
         SofT3JfRg/v7JqIVdAsncS0gnlrTxqB6nB6FZu64d7NtV008V6SxOunPo6PQT7khGVBz
         TSxVFhJLNw6roW7FgjCwcMpjip3qCzII6lbcQH2VZNXPM7Rxpguqrld8U4YnZETLFbk3
         dCg5BuotcQLOzQNUg6Fcx7IZP6DQYnMCD9+8c8srbcpCNObKmCra9knFqUiVpAjjz2eh
         zQvwvSjMIIEmSWcOQtfiYmFB6NHc5/esNGijxnKCtgBSl0+BynxapYbDyN6uVme9uSHR
         CuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757075339; x=1757680139;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vt2kS9Ofun09w/F1kEUInf1+goE6RJwp8Jq2yr6GTno=;
        b=SctaVn7pk4TnD91Jqor2VcL6vFMerAQCLOXPXFogEigmykHjiBou7oU676G+F0cm7c
         lMrobZIvTlRuZxaRqr8Ege0RKcTSsQW4Ul0wJQpEWWuA09nbCd59MGOri3WSMBqLmbE6
         hTBaaRS9DVSuKlc2VCL/tP8yhvf45LDLoc8VnYPpJaUzcVLmir41VkYZ3TQIYAOAkiZ7
         A+/8S2YOXWA/37JFMQkCV754Uakjc/sMJoykr2/9fFYe6Fw7hLN8XJ1LNLM13zMbZaqY
         qm20NurCH2wYRl+3AkUWpbNxoMOc/U6SOBffOC2ZPClI0e4TgA4Ygyjdj4/9FXrQKU3U
         BkeQ==
X-Gm-Message-State: AOJu0YxWLUes18QaieIeBHC+Om4D5S1sGVCQ3zy4IlxlPnrzlAJFL0os
	KgUUpSB2E8XA4fh/ceOfbJaUNEjMJiuoEK1OZaRdXPq0CkY3Bx6h+62vconQjYYm5XZ7XkrvK/v
	N+PHKUW5xCnBkSdUDEbm9TuH8bKSlBA584IpXPzLP4QrceXAFOltmVRQ=
X-Gm-Gg: ASbGncveRsmsbqLAEwOYyG3pRE/NeOVKAOTpkPq20rC8jn0pPrMo2xYODkiryPsEcRd
	YgNhp5to0IfeXzAgugPQyBft4doYOP8YxwgrVXafVtpplbHij2BR5y2rYa9mNLcSSU+vB4q0gAv
	HVjH1NY0P8kLhehz+sbw4hoqF2Q5KLHKgQmkA5SywQVwuKgpgRuk6+1s5pumAbES1wua/4yRSjN
	k5aNaLYr+J8W3bhV5PtHolp+FE3UrxSNH5rcuAl
X-Google-Smtp-Source: AGHT+IF2VyihlpYLlMLSpcAIk2s/i+EE+s5Gnsq5S4v8IDPjr3MF6OBdBjnQtI+Tuw5M38cyKFUCV97IWUQkg/iXocw=
X-Received: by 2002:a17:903:2385:b0:246:80ef:87fc with SMTP id
 d9443c01a7336-24944af38c7mr260768135ad.45.1757075339192; Fri, 05 Sep 2025
 05:28:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 5 Sep 2025 17:58:45 +0530
X-Gm-Features: Ac12FXw7Gdb40oCU__VJhJHzl8UybprNIkBlFrRCtJMXzI7n6pFfMa6roDMYZnY
Message-ID: <CA+G9fYsT3b3Qd-m6tSDOgAXpgLPWz0QD_Z6a+_ff4oTecA85PQ@mail.gmail.com>
Subject: kvm-unit-tests hang on Arm FVP with protected mode
To: kvmarm@lists.linux.dev, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>
Cc: Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>, Mark Brown <broonie@kernel.org>, 
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Content-Type: text/plain; charset="UTF-8"

kvm-unit-tests consistently hang on Arm FVP when booted with
kvm-arm.mode=protected across both 4K and 64K page-size kernel builds.

Running the same tests with kvm-arm.mode=vhe completes successfully.

Anders, bisected and identified the first bad commit as:

  066daa8d3bc2694c392e14091978043aed7b1f23
  KVM: arm64: Initialize HCRX_EL2 traps in pKVM

Regression Analysis:
- Reproducibility? yes

Test regression: kvm-unit-tests hang on Arm FVP with kvm-arm.mode=protected

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Environment:
Platform: Arm FVP base-revc
Kernel: arm64 (tested with 4K and 64K page sizes)
Mode: kvm-arm.mode=protected (hangs) vs kvm-arm.mode=vhe (passes)
Test suite: kvm-unit-tests (./run_tests.sh -a -t -v)
Cmdline args : kvm-arm.mode=protected
Kernel: Mainline master and Linux next master

Test run log:
INFO: running kvm unit tests ...
+ [ True = false ]
+ ./run_tests.sh -a -t -v
+ tee -a /lava-1/0/tests/0_kvm-unit-tests/automated/linux/kvm-unit-tests/output/result_log.txt
TAP version 13

Links:
https://regressions.linaro.org/lkft/linux-mainline-master/v6.17-rc4/lava/kvm-unit-tests/history/?page=1
https://qa-reports.linaro.org/api/testruns/29720932/log_file/

--
Linaro LKFT
https://lkft.linaro.org
