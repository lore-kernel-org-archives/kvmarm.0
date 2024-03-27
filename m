Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369AA13049E
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561005; cv=none; b=hx03Bke6Jd72MvAJcKXXc0011xQ6EhdkEE/g4vBnYljhuREzilqtxnCsbsfVgy+bvhj8OveGWT5HvR1yO3fh/ZYdDchrouW1w7x2TjRcFt7EhZWI7FsUSai1+l/zkxnEMrHHTFTXTPY5J9sYdW9udiPfqLvKJdV1UoJVpv5Pc7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561005; c=relaxed/simple;
	bh=6X/PSwAPc77DGOvtOgRYtXJ0cQGotXYcF40EBRouvKw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pVZ2NzZTDcr0SOGMYu5ZcMZFKNCslrqsLd2jrchP3zVGN0nA2SUy4CzQ7AD8P4/VIXXV7APWRDCF42ZVJ1CodXkdTUy1km8UC+4pl4NE80BK/mcLZz/3Os8LSFAtW+NaW0TOgKITJA44f7a7xsE7EwuVZ8uM73G09fbCcVA7xj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TQUl919D; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TQUl919D"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a0815e3f9so1205267b3.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561003; x=1712165803; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ECXfCW4cQqSCYi8yOf6SXzZmwllBAl2JB/dl2uMy/io=;
        b=TQUl919DKkyC3Ln1zpEhBI2wGahCnvitPc2u6e+fSNN6K+sZtvPPYZjzsxPQpB5Kxr
         A6pv+XUxO9Pau7dJ0XZzOeFXWuK+YMdIjIqqfn2r12TRH2B7JMpw/w+AxDmZWKh+9XKp
         M6vlqI+xwn9/l/oOwTRuX24OivPniQ95T7jcmd9eTCGUcHiS6dSv4GzVyLl8QMuZhsm1
         jw/MysjL128B5Iqv3zV2854WmW1qaJ7zWWY05+Vz3Y/GN65n1/AgvqxAsOB5FCR0IbNG
         FZuX9GbN10ZmsL2ycPZbyDvR/bcOqYdLeBCvK1mGP7/AjAPYjKpdl4jIxZX9lYodNDeu
         W5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561003; x=1712165803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECXfCW4cQqSCYi8yOf6SXzZmwllBAl2JB/dl2uMy/io=;
        b=bylone79cuMROB0C2xBhs8t5SRKY4YG32q9dKqlr447a0S6OM99Z3Zi2rPhUG4pqBC
         IhDbBjMfQMXyC5zFMey0qtnyyywCnkBBStgKW1mqJjGJ4oxcUomBVDffVVdEN7hAKqR2
         38oj1l7NFLTgERWkK40f/4hZ1RRjktrOKy4bpw770ol1aYEgsp8KE65staREyvFPUcwF
         J0cCrET9eOo1L/19VTWqY/4Ne7pWJ8uNn7YXxt4r9n9p8sB/24sGkWFc1jfpqEOK8f+U
         At36RfOSOvITvf7UOjOdQR6IEh1m6xnWQBvdDoLdGoJAOybAOdiw6gTfhUogj+jwf8B7
         W26w==
X-Gm-Message-State: AOJu0YyMTQE514rEp4ywaaZa6hc8KR+53+VvNYbkMRdPc9q07EDTM5yP
	TuL5kKii7srreuYcfu0KUJ38hb1Yiqw7ep4p9l+msdluiImqN+k5L9yrNAq7QDTrQPuauhSFMI+
	KCg2Yk4AyueOohFeLiAl/QI8kawo1nTXE/tTExoOrhszPydvs357xw3jR3KDSmP2vXNmHbPg9xd
	gWChMu2DhdyosMxq9w5CzM0Io1vZs=
X-Google-Smtp-Source: AGHT+IHbI4R97HWJE9MLD8Ag1fwdR/qpkV6OaECnSjOYWuXd0HMnrmK1Z4Jf5ezA60N1PUlmyXXid4Lk3g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1009:b0:dc6:b768:2994 with SMTP id
 w9-20020a056902100900b00dc6b7682994mr64898ybt.0.1711561003268; Wed, 27 Mar
 2024 10:36:43 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:17 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-31-tabba@google.com>
Subject: [PATCH v1 30/44] KVM: arm64: Rename firmware pseudo-register
 documentation file
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
2.44.0.478.gd926399ef9-goog

