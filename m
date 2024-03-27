Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF0613049E
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561012; cv=none; b=NlQoBDOPukeil2iOILFKMAN3zUpa+PJ95sxnCIw3dsfkyOAj3g+Ak4GYVBEIufyxpeQWjleSRyT7sE9wo+Vd05fnkwwHDvHxLk8plDILATwArnj7IqfqNFxWHOd21jS4js8yWNRtAyNb/TYm5mbRvVFszGgIMvuCe5sLLPdse+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561012; c=relaxed/simple;
	bh=UlMTg2UQgFxhZYMY5URQrCBK8CEb+NnqOoRlLspx3qs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f+9uU7hu4kQENDUL0TORBjok/0VtQNUO5i3huhLEI//a6FW1TntJO4vm7w57OBpTsBkuqRH2kur9MZhiKHwdUTNm4ztdYFLUUBJQiWKSwwfLezMUxm5GnqJmIER8w920nwlSs0rjAKYexaj5CEpo8C0e4kQKgOVG3GMfHSHk0VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2O6rBhOQ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2O6rBhOQ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4140408c7faso238765e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561009; x=1712165809; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T6qSmKpPD0BQomJfljtsyvUWjNauLzY+yWPm8tMLEkM=;
        b=2O6rBhOQroRcCwgpsvjZX1mz3GWV7dwYsWZ54Ycob7IQof7w219+xtV3Ogj0EANE6t
         ZalSIjRpLJuvQLLHD544EqbX+XBIQ8gpRgKPgzKoSTD0OAgxI6yCEFZY0g0VRC1puUWR
         l3CRSGZOo1oDiXICcn5G1Sd3HNsQooFInEE11UbmErumbhszNYVe07XrJOEnRfFWY1UZ
         X3Lyt7030tzlC6soD9HPvyg6rLu0q3hOC2TxgKVviWDp7xNP/YKHIXUp83qV6q8Cu4EU
         F67ncvjtpPx1HGk/pMibqWVQwYY3f4pEqMun7hYC6290pxTwNi5GV7xh6s2C+Tolu/Tm
         xluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561009; x=1712165809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T6qSmKpPD0BQomJfljtsyvUWjNauLzY+yWPm8tMLEkM=;
        b=EP9O+LlHG13na4ksj7GxSp39daVLuzKyQvmJ4L2d1rW1Ds1zusMERNvaahrNSjom67
         rqbkz92MFUdJjNsrTGte0PGeRrOF0apUgdYR09H6sVT2Nd6JGXzbvS78NcZFj8GmthkU
         Gi0KWGjIPGodV++dWHmOEO/yJgtBCr0p3CdwYNExNLBYDnKEQuvgnlbSeKkgeyMRjDij
         t8QRhHISH25WtDf6glYa9ch6/flGL6GJKXNZA7QAeGt/bld3fGc5Xmc+a/TXSpDTCe87
         n9Jtsw1dBhg+jj8nSLr3iBlDhMidUMc9ih9RrmyyqU8Q3vY1d8o04QNQuvSxCOSWJ0rM
         +avg==
X-Gm-Message-State: AOJu0Yy25CB7Knak8FSacV/1Cwh0kZSUGIpdMizG1zha+9aAW5rxNXWk
	ullXqc0V184sJDAPDJ0TdyOAm+po23ibcVGWVerl86+zhz+4QHQQOKfkfSvSv0nAzUGSTDNAcFn
	9EIy8JQosufNLbaOwEAxe3/QvPoH+SFMWyRSDZz2texXG/e8ki8XPaq24ZvCU0D0YzQNbfK3A8Y
	0OL8oTVjzEgIB0Cn3hTff+Fjmsjv0=
X-Google-Smtp-Source: AGHT+IFoRp529fo7gcYWq7Yv7ny8K7zd5NHcapxEv36e3dZjPBy9UmODBuBgXzZMq9xKhk4+hwoj0RrM9g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:310f:b0:414:81:f9bd with SMTP id
 g15-20020a05600c310f00b004140081f9bdmr112wmo.1.1711561008355; Wed, 27 Mar
 2024 10:36:48 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:18 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-32-tabba@google.com>
Subject: [PATCH v1 31/44] KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

KVM/arm64 makes use of the SMCCC "Vendor Specific Hypervisor Service
Call Range" to expose KVM-specific hypercalls to guests in a
discoverable and extensible fashion.

Document the existence of this interface and the discovery hypercall.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/arm/hypercalls.rst | 46 +++++++++++++++++++++++
 Documentation/virt/kvm/arm/index.rst      |  1 +
 2 files changed, 47 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
new file mode 100644
index 000000000000..17be111f493f
--- /dev/null
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -0,0 +1,46 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================================
+KVM/arm64-specific hypercalls exposed to guests
+===============================================
+
+This file documents the KVM/arm64-specific hypercalls which may be
+exposed by KVM/arm64 to guest operating systems. These hypercalls are
+issued using the HVC instruction according to version 1.1 of the Arm SMC
+Calling Convention (DEN0028/C):
+
+https://developer.arm.com/docs/den0028/c
+
+All KVM/arm64-specific hypercalls are allocated within the "Vendor
+Specific Hypervisor Service Call" range with a UID of
+``28b46fb6-2ec5-11e9-a9ca-4b564d003a74``. This UID should be queried by the
+guest using the standard "Call UID" function for the service range in
+order to determine that the KVM/arm64-specific hypercalls are available.
+
+``ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID``
+---------------------------------------------
+
+Provides a discovery mechanism for other KVM/arm64 hypercalls.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Mandatory for the KVM/arm64 UID                             |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC32                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0x86000000                                       |
++---------------------+----------+--------------------------------------------------+
+| Arguments:          | None                                                        |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (uint32) | R0 | Bitmap of available function numbers 0-31   |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R1 | Bitmap of available function numbers 32-63  |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R2 | Bitmap of available function numbers 64-95  |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R3 | Bitmap of available function numbers 96-127 |
++---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID``
+----------------------------------------
+
+See ptp_kvm.rst
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index d28d65122290..ec09881de4cf 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -9,6 +9,7 @@ ARM
 
    fw-pseudo-registers
    hyp-abi
+   hypercalls
    pvtime
    ptp_kvm
    vcpu-features
-- 
2.44.0.478.gd926399ef9-goog

