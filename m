Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E113E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513652; cv=none; b=X/o+x/uWs6n5IC0+EJpu7jJh94FqgxCErEP3N4uCAHbkrCF9C4yyPsHkEY37SDW78WTUfF3+Xk4Y1mkAwYdCIei0I6RWQ4s6ZR0Xa5NHTbJL69NLjFsezoZvRQMLBB3+aXrtXFtjdN6sokUa0K40dHUeZ/CsPymVjnLDuQrPMn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513652; c=relaxed/simple;
	bh=MZSVKp5cR+kw0x1bWOgfWUh8Ullh17DKogOayPNYAUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tP1mspvoJrFSAB6xjJdJyYfcVowg3QOba02U53S5STNz3e3JqqrEJDiwGczi85nzV27vqrxJ5zbwvzBGavQOHYkTb0ZB5e+Z3Ge93cqr+ApOsELrgt6Sxdvdw0C/cnB0Y7IMOSapcUOV7cr5MpeVDzW88iC2xfdIsVfc+Hn0i94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E0SeJVeo; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E0SeJVeo"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3455cbdea2cso1210945f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513649; x=1714118449; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SOV7811wPLzhw1FHjBlhdYYjAPxbNp84RGhdZIl3Ung=;
        b=E0SeJVeoifP5Da8/H/WQHA7xPZ3c2AkJo8A/aoovzzbhFMopfZ9opMxxUXqtAXn3eJ
         FS3mWln+SrtxWP0m1YgSwqB5i21Y92WVJhPjhlFk9BtsC3uDUUGOuQy5J3htvJwGH8nr
         hrJLDmcD3u5yMWc9BNOkZWlfNTp+veR3TiHcr6k5Y5F0m7pXWedToQW8iEIbMWpn8LGH
         YeNGxckxdApUwtuE0khqTIgVptzFv32egjw4xRvkhmLNqjIyx4rOQIF/Xu3CS1a+PCXa
         u1snIzYSKUnecF45UmjWCThR4TE6OZGgIjgVrAGBx3GW/oVdMuG+nq2TGQAyaBiHBObV
         HkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513649; x=1714118449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SOV7811wPLzhw1FHjBlhdYYjAPxbNp84RGhdZIl3Ung=;
        b=HUPl4/hgRPwCSJHmWp+1oYCHF/O3igHtXAX3Zdd2zJfLYSail/o3lRBRwhlzyWtIji
         y+3IrqFrqydkuk0u34xiLink2m/WR6ro3z6FmzUkulbgY6ZL+18ogTYg3E7BthVwR4ch
         DhWg4aQk8by08/rg6Iwrozxmvg1Og9HzKi+nd78JBG//UzYQTR4Pf3Gqln2K5wHpBvzk
         er9F3gsBcIiN1pRaNPEzm2H/RgRv+IKa6ze1JIYYBWMuW4uo1ogjKgbqIJr4fOTvL0sC
         MHYuWn4sOCYSH0/+SylAXYkXCPy45L0zAVXIoFosX+6g9nOKc5gi0lhMk5UI5IFlvPk9
         J71g==
X-Gm-Message-State: AOJu0YxDLU2GZt6YpJvI1TYlzo0rEp4wULIo4s+/wjW1yR2SEFSTsQox
	bd6ah/bcsB0e/lxXg3bQdJysdXmA/+951xkAmiMjtnxOesD/BeG6xHpO3MTZ3ffPABJOTumTbwj
	nlp+iMxCepbe8zCWxUJ5y7y3XFqnnAGu9zS6f6vnOBHjwrAp30GU+rmoIRjEmsaZXTleiQgNKo3
	EBiqoQA2moZ49TH+X2M6+PMcqxVSE=
X-Google-Smtp-Source: AGHT+IGk5iRaNbM+XqokWRMrGJZpi7kLKJpkzUdHlg/xtjgp1gNEe5JYtPuyYLS4J7kQYdFghOkrvvCUvg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4202:0:b0:346:b261:d930 with SMTP id
 n2-20020a5d4202000000b00346b261d930mr11412wrq.1.1713513649491; Fri, 19 Apr
 2024 01:00:49 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:39 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-30-tabba@google.com>
Subject: [PATCH v3 29/31] KVM: arm64: Rename firmware pseudo-register
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

