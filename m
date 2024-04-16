Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FFD2907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261477; cv=none; b=O17+52WLZID8PmXGOHaDgfgvOFxrlcJwd2YaOBWHkzCKz+mUBEc3LMPxo+no+M9kNMOe8SmEy1PYZQr1Rz02EiwTpJVN4XSm85cWB0lX0GGPeB/w+Y3E52TJf8wY4LQku8bZn+PQcTiw5VPgLjHODWIGDjloo4o2zNBEsxF9PdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261477; c=relaxed/simple;
	bh=0bypc35oqGP8oqQncBLLSnIW0Q8rdKIKpuFR/21VbXs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sNKlQ271fmVysRoaHvWL35OGcnkDaTUSNlZs2e5ofKWjDgdVZnqZ9sUBbDPp2DW38YQ1tiIZuoRkyrOX7aild8cpVu8R3FFRfu03iWEwu7oWssaWPhwjewmMDYozWmqmkJY/E8OOTzA0vZtRl9QARdjClV+tm2SFvxbQinRJPI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V4vPTdcE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V4vPTdcE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-416612274e7so18150035e9.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261474; x=1713866274; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rr93vWBaoAxl2935Scon+wIzG/Pb4O7mCJAImdnyM/8=;
        b=V4vPTdcE0wJdz9pbiHcm8xX0QsRTEWfC66Gf5l26NJmr0R/rHH5mcWB4kJ1VlAJ0iI
         0TljJZYQ2cBp784n0ANSnqYeK06D/XgwKaLrM19MxBfd54lFUGZL9INoi+rWDs2a2Gk8
         lVuEg9ym+gegwpxCdorS7EFrkRjiqk71gqp0t3nQQUj6O7WxJg0XbHL/zMp9suY1n7gF
         BYHei0dK94STVn1fHF4v664qIqc2V5pmRVBheRtH3CnAcPwJ9ue7RHo/vvN3Dp9vSamA
         PNXW+HdVwbcm82U/ZJH46KKDDNB24EE4r0/L5KksgLjQjWMpSHLCSNr0DvzG5+mjksTw
         LeaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261474; x=1713866274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rr93vWBaoAxl2935Scon+wIzG/Pb4O7mCJAImdnyM/8=;
        b=H5VCMZXh3nz8rqSLmUGwG1tx+2AlpvH2PsNpifx5Bgx88hnTZNVR/47W48qJE8wYbP
         tQbEdQBVY/81Ngmwme3m/cKlODuGE+Agy1BgL/CJFCT8k4XkYW7hZZJwuDyw4g9rHMKh
         guv/xvTFwWHx8QmnsrCVZXlkl7EoRuC2E6K/eHW0Edi/Ypj/3fuior4+k1YYt+1pP2lo
         50kYPtkeu2hIcJO+zoWHYtQc8mrV3VO3oxDq/oyvntFt9anRf0BP9mkiryNtZA4208KY
         XW8+8/9mnJToB9egobDfDcQLz/pR6nyalqvO4MXV5nPzUkn43P2McWbEH0or+w76beJy
         Dpkg==
X-Gm-Message-State: AOJu0YxY2yElLbPHGViscYJC8K/uX0IE0AtArM3qzbBXuIty7TtgLeHR
	nbZucqSTtRxSN+v2+B1OzrZULdtJU+jfNMohu/lk12dp1DwpHxaNKLtEdpLxOZE3VHlVDdVl6MB
	ZlU3ps3A6sWvVSTtTeoDpsHSCM9EiTD4tb/zbgko4+IAAHBgkDQdljosxkOY4S496bqcT7cQdQd
	ne7VPvx5OS8q/HoIMaq4JPaHdM888=
X-Google-Smtp-Source: AGHT+IFSDTGN+lYV0VQcUEFfthUFAEtAwuFrN1WUD6A7Q3yngABMqtg2cIS4GtuSLkcHPhYLWpospW4TXQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1d97:b0:418:932a:f458 with SMTP id
 p23-20020a05600c1d9700b00418932af458mr7345wms.6.1713261474106; Tue, 16 Apr
 2024 02:57:54 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:23 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-33-tabba@google.com>
Subject: [PATCH v2 32/47] KVM: arm64: Rename firmware pseudo-register
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
2.44.0.683.g7961c838ac-goog

