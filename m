Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDF413664A
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884804; cv=none; b=poodJUKP6e7CFXQZLXjQFXg0fC4i4J+NfSx5TDlcp+j6JqCy37zfCBKLtxzzmnWY17zCT+LTi1kZnkP/m4K6qfJAz4ad+X3raUVfK4dejyn1pDERLZDmq4jUyQta+n85pER+kAzNBCOasoT7VioVEjhISdB36p/SfcUP9ckFQvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884804; c=relaxed/simple;
	bh=MZSVKp5cR+kw0x1bWOgfWUh8Ullh17DKogOayPNYAUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p5o70zqBuSL3im8V++523bWhENPPdAK/di/aKwL16SwkPT2KcEX6CT0tlTPamdXzub8v12RMEAKx56rpU+obuzWUvhswLvSv+4kxxbc8niX3ROWtd8yZgSYpNChDoFIrzi9vSPyTUdyOuk74af9livTHUSZQiU6p/CbEjfmRZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uOjmmovD; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uOjmmovD"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343e54fc19bso4033294f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884801; x=1714489601; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SOV7811wPLzhw1FHjBlhdYYjAPxbNp84RGhdZIl3Ung=;
        b=uOjmmovDIU9RsmzkeE99rWATf5JKzgfXhQrxIhbWG07yijYMy12hrWd22rJBTeLUjq
         ehz/8gndk1u3dGXBhJxk6F3GxIfe+1pYuqX1wONqD5j5DHRQFFdCwLhvKYKFTNMS4L8M
         F/oBkZNIKqhQQ96XeO+Irnq/Whi8eJxppwpMZcdC3fJRf5+Q4Tfjif9h4a5tflAjdx5q
         7qJHvcdWb7BZOP5th0RK8jaweRUbPTfh4cwqwCGB0pqtwcHOAwwFbZtsXiCexYd/lkP0
         At2NHQluqm1xSjHw5ipj7EPFoox9NKdidcCvg6Tccz+6UL40vPYq7iPf21Mj91tKALO+
         XMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884801; x=1714489601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SOV7811wPLzhw1FHjBlhdYYjAPxbNp84RGhdZIl3Ung=;
        b=fTFn5QgtyCOVXaxCnrn4jald50vpSVPMJtrfpnX83sMEm4RQ8+YK9ufZvlzRdAAd32
         yCTohvG0kXLK80LhVytfZybzPjtg8f41plLM7uH57V2BDxa+NknYrh9fzQWi1hPMKjgy
         l/35hkdMXgMDBocA7GUdFzFk86fjfsp5PCIOTANP6+y7OZYYhcJa6yFwPpgmWDT88TQ8
         JSprybsf9nc4OFfJX4pb2hZcakwdF5o8ozE7rhI6fQoCBznAULuGsrm1/oQwc12Ajq1s
         kzw9KwiR2hxbZqH/S3rl1myUf26GY3qnjgfcMoGsPe7jyRdbyEPe2Rehr746xspdntFS
         tN2A==
X-Gm-Message-State: AOJu0YyNFNCJpb1spoojp3hIEPCrYMAnWP9MgBkJxpIe3nXtpqEslPGH
	3MZRilH+1PLbrqzTTiygUKfR/N2ohVy45kiMhFP/4pzniz93ot/ACHET6iHK0glbjuelIyn/SGK
	yqfaFxXEp5SGxXGIEGxYXed+redQZjyYK7oCBe1hPjwScn8bgLEzZBY6RX0qKBb8dxA4aEjQR2r
	7j7kInc5cDAVt97ReUV8u939dIous=
X-Google-Smtp-Source: AGHT+IE0NIcBpzOqa8h86QNLzy1Kp2CcPvyF4bEHK5Q71o40YzDx5TrkTZixeKHQ1r8v58O5cZUL4D/bGw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ef88:0:b0:349:b639:4827 with SMTP id
 d8-20020adfef88000000b00349b6394827mr28391wro.5.1713884800608; Tue, 23 Apr
 2024 08:06:40 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:34 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-27-tabba@google.com>
Subject: [PATCH v4 26/30] KVM: arm64: Rename firmware pseudo-register
 documentation file
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

In preparation for describing the guest view of KVM/arm64 hypercalls in
hypercalls.rst, move the existing contents of the file concerning the
firmware pseudo-registers elsewhere.

Cc: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../kvm/arm/{hypercalls.rst => fw-pseudo-registers.rst}     | 6 +++---
 Documentation/virt/kvm/arm/index.rst                        | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename Documentation/virt/kvm/arm/{hypercalls.rst => fw-pseudo-registers.rst} (97%)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
similarity index 97%
rename from Documentation/virt/kvm/arm/hypercalls.rst
rename to Documentation/virt/kvm/arm/fw-pseudo-registers.rst
index 3e23084644ba..b90fd0b0fa66 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=======================
-ARM Hypercall Interface
-=======================
+=======================================
+ARM firmware pseudo-registers interface
+=======================================
 
 KVM handles the hypercall services as requested by the guests. New hypercall
 services are regularly made available by the ARM specification or by KVM (as
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 7f231c724e16..d28d65122290 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -7,8 +7,8 @@ ARM
 .. toctree::
    :maxdepth: 2
 
+   fw-pseudo-registers
    hyp-abi
-   hypercalls
    pvtime
    ptp_kvm
    vcpu-features
-- 
2.44.0.769.g3c40516874-goog

