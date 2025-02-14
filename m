Received: from mail-lf1-f74.google.com (mail-lf1-f74.google.com [209.85.167.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3790F3595C
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739545383; cv=none; b=IVTrhF+BnInYuuhxl4GBJ8LReYfax1clBISqvVkfeQ4trZZt9NV7BSUNWPDKiWSY09y+o7UQYmzwJbv0ZgtGtUpUBipF9/d1B0zA0kBSM/06+ra3uNCHbTwiHlOOOYbegXmyXMJPC4il078kr2ZOlz4EI8mgIEGdfehfy/EhIjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739545383; c=relaxed/simple;
	bh=IbMtes0KyE2mYY0b6Zruddbxdfb2o975s33q39s7vuk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NJ7P33FpvYXS69jpRG7pCI235pL6D0c1zJg42ik8fuZHKLO2mgww2IjRNJizEZSXxw/hpLUqKuxlDEw4uRc9u81j2KKm1BdesfCy2audP2GSQ7BcG0TkPkQ5ZPKuBHy7dsDyrbXCz+fNnxhut3dKVQNWIHxrFLy/Zn7OEgEP+UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bB8qF0h1; arc=none smtp.client-ip=209.85.167.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bB8qF0h1"
Received: by mail-lf1-f74.google.com with SMTP id 2adb3069b0e04-54508fa5d1cso1273543e87.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 07:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739545380; x=1740150180; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MuT0SdK7xXa7okOPanhG6y+T08LdgnDw3LDNbKyKy/0=;
        b=bB8qF0h1q+c0pXeADrYX/SuLRJx9YbcziDhkhXCEz7GT89YcftLcMwxg82mfrcn5uh
         zAIwTTHdycFyjK6TgGlkF2z/ErhOFfV/YyWtMcrcyvjOkqk0s6fnjnBrOA2linvOvfqW
         ylPdFuk/ZqmueH50eH1SWXn7eJNPMz+dO8uxu8D4BgCgJhnOaoxhcuCPUw1IfVjABVtz
         BQQf42FRshyS1FOtZMk1MxvqSRqXAxWWikTUmyjesAP82DsuU0VnCw3sIYCeZdyM69ad
         hP9g5rMwW6josOHAdgD8QHDw58iePQPq7PcbJBZ21HKmWew1PDVliDhGEksCjol+DFLG
         IXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739545380; x=1740150180;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MuT0SdK7xXa7okOPanhG6y+T08LdgnDw3LDNbKyKy/0=;
        b=j+TzPximpnL7EKoCOXWujQInooTOtUtV9dYscy5rS0yAi9hoZQeEfmp0d18BSFjzFa
         zY75/q2WiW+gD98aiMiJVwuqgrD4zqiCUeS9XCtRayv3AG5FOl2X2hdNnfHsxEpsj+KB
         +FfzhMRUabNAXCUmoc3InZ4Zg415iLgJjegaKef8C5sv/Rnnlsag7jbW1RpIbuMnxVAe
         a9zIrlp7xBu2KylfZg37pQM/ARaptzmgMPoEiqKNTxaDglaKE05EkmBCdTdkSIbJ2J89
         o4oFeiXv8Ay3iVCIpc5YkYF8l+5Yw0NMAr6agraJs72QLps746/dO5adJBLDKw8CYlDa
         YoSQ==
X-Gm-Message-State: AOJu0Yyow1KrcsCWKkkfp42oj+uS+j83MMJhtnXupAJ5h3AkQoAiP8wh
	+KCTPabYaTLHtARziT8zfE2NnMU9FQOgmzWcM0au16Lex9cOVlAeSIlBYY9dV4DjTufsIzCgjB5
	lTaY17mwLw3WYErpcN/4zKKK7H5zTzcpe0Iw5v7kpCMOWcjGfNCQa6s4tQOOZwVDo+gPAx9vx3W
	yolXngx2fhTEjMvZZlbnUTtKoL+8k=
X-Google-Smtp-Source: AGHT+IFw/r/gkZ/iRvXxaWP0G3NSL8AKpEXKuIDGJ2LZhDVuSFi7uIxQ5P1CupiTBcuVqdIzWFwpe/DwoA==
X-Received: from wmbbi19.prod.google.com ([2002:a05:600c:3d93:b0:439:5529:c5a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6512:1048:b0:545:1193:1256
 with SMTP id 2adb3069b0e04-5451dd84c89mr2102659e87.1.1739545380225; Fri, 14
 Feb 2025 07:03:00 -0800 (PST)
Date: Fri, 14 Feb 2025 15:02:55 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250214150258.464798-1-tabba@google.com>
Subject: [PATCH v1 0/3] KVM: arm64: Fix initializing HCRX_EL2 and other traps
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Since the introduction of initializing and setting HCRX_EL2 traps
in KVM, we haven't updated the pKVM code upstream do the same for
the hyp view.

Additionally, the current behavior of pKVM is to initialize the
hyp view of the vm and of _all_ its vcpus when the _first_ vcpu
is run. However, with the introduction of kvm_calculate_traps()
[*], some of the host trap values are not calculated until the
corresponding vcpu is run for the first time. This causes pKVM to
get the wrong view of some of the system registers, e.g.,
HCRX_EL2, for vcpus other than the first run vcpu, since it uses
the host's version as a starting point --- particularly for
non-protected vms. Because of these issues, it's might not be
possible to run a non-protected VM when certain features (e.g.,
MOPS) are supported by the system.

This series initializes HCRX_EL2 for VMs in protected mode. It
also initializes the hyp view of each vcpu after its
corresponding host vcpu has been fully initialized, i.e., run for
the first time.

This series is based on Linux 6.14-rc2.

Cheers,
/fuad

[*] Commit f1ff3fc5209a ("KVM: arm64: unify code to prepare traps")

Fuad Tabba (3):
  KVM: arm64: Initialize HCRX_EL2 traps in pKVM
  KVM: arm64: Factor out pkvm hyp vcpu creation to separate function
  KVM: arm64: Create each pKVM hyp vcpu after its corresponding host
    vcpu

 arch/arm64/include/asm/kvm_host.h      |   2 +
 arch/arm64/include/asm/kvm_pkvm.h      |   1 +
 arch/arm64/kvm/arm.c                   |   4 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   6 --
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 100 +++++++++++++++++++------
 arch/arm64/kvm/pkvm.c                  |  70 +++++++++--------
 6 files changed, 118 insertions(+), 65 deletions(-)


base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
-- 
2.48.1.601.g30ceb7b040-goog

