Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839EE3C490
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 10:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X5+1efbR"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-332e11a22a0so4862549f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 02:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701771771; x=1702376571; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9t18tGFYr+sidi4j7S8LuvInz9BurB3PbtEfB1rEvz4=;
        b=X5+1efbR0AhvyGMvCglpHf8hbpOFQoawCCXez5aI/OrRs0uxKOHWWpxbCyyE4KhVMn
         1NpQrqpHy9oTHeca508I3fim494fIURDgfFxGdWqgE0MP9judRchXt2C/dh1WdlKXqhw
         oBGR7nbjByAkRlUEWS40qtWhUII6DYChhMFZtGjoZ2Xgv0U7dGhLPOiVHa4heu76eTSs
         AosLRqVz2TMordFseyp0m8+yhWkKCZepKfPn7G9OuhrBAJAiWvav6Ng1APulpzVjG6Oj
         QmbvRPwDuo6416zcKYQGIxsGTPNppB6cx1HgU/oF2hdq0F3f5IEw7/OjJLBb6tEdtu3u
         BDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701771771; x=1702376571;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9t18tGFYr+sidi4j7S8LuvInz9BurB3PbtEfB1rEvz4=;
        b=cg8e2BR9PEOD8SPNy1OLSvyKc/hhxaXHVPPjPB/z3JcrH5N4eaoe0M/I+r56hFmChO
         BNRmcH3f6YBqZqA2qGQ+iFADA4EK+beF1sPepsS2IUW5mkBcnqD3oHuhb4l4MovNrx/P
         Sssa/a5x0Hh4J/gGqqYC0ZBiZMIvdEO2WEFawM2PF6bTygyk4kSKWkURRzSpbZ4qcvUR
         PYCqJOZL11ZwAKBOg5i5IjGxWhyZ6f74mPz+23rWGFE68KaC+mBhwxm0Rxhy2bti2Mnh
         /6WquU4g5Rl/0RcH+bInHud9gxvGZ/2BBX1EjiSQXLzJsYEQhIyvfaXiRi9koniJGoQM
         j0yA==
X-Gm-Message-State: AOJu0Yz9ZvYkPOqhW2Wpcr9SA1PczrAEa/rWHE8svzWrEZ7hfqEbMmeM
	l2q4kFkcJOim4f3jg/G4hbg9K/gWYZv/SSsXOlny+zG1e7mcY6VkiSJp6T99nZngnE95Xl1wgvI
	inlZJ0VANfqruJeegMxPuXcZ7NTnxiddshoF83n3uoXB5CceDoTvjP1b4NDk=
X-Google-Smtp-Source: AGHT+IHBNt8mVY9BRjxlPkPSAlByF0bIpNxxBtLE8A9fq7bJa4dCdkcUDDFks8BIN3A4T8cIC2aHLMudew==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4d04:0:b0:333:3175:5afa with SMTP id
 z4-20020a5d4d04000000b0033331755afamr134491wrt.14.1701771770646; Tue, 05 Dec
 2023 02:22:50 -0800 (PST)
Date: Tue,  5 Dec 2023 10:22:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205102248.1915895-1-tabba@google.com>
Subject: [PATCH v1 0/6] KVM: arm64: Fixes to fine grain traps and pKVM traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

This patch series has fixes, updates, and code for validating
fine grain trap register masks, as well as some fixes to feature
trapping in pKVM.

New fine grain trap (FGT) bits have been defined in the latest
Arm Architecture System Registers xml specification (2023-09)
[*], so the code is updated to reflect them. Moreover, some of
the already-defined masks overlap with res0, which this series
fixes. It also adds FGT register masks that weren't defined
earlier, as well as build time validation that the bits of the
various masks are all accounted for and without overlap.

Based on 6.7-rc4.

Cheers,
/fuad

[*] https://developer.arm.com/downloads/-/exploration-tools

Fuad Tabba (6):
  KVM: arm64: Update and fix FGT register masks
  KVM: arm64: Add bit masks for HAFGRTR_EL2
  KVM: arm64: Add build validation for trap mask values
  KVM: arm64: Calculate FGT RES0 Bits
  KVM: arm64: Trap external trace for protected VMs
  KVM: arm64: Mark features as supported for protected VMs

 arch/arm64/include/asm/kvm_arm.h              | 56 +++++++++++--------
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 16 ++++++
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  4 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++
 arch/arm64/tools/sysreg                       |  5 +-
 5 files changed, 59 insertions(+), 26 deletions(-)


base-commit: 33cc938e65a98f1d29d0a18403dbbee050dcad9a
-- 
2.43.0.rc2.451.g8631bc7472-goog

