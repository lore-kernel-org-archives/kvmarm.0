Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C8614E2E5
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561003; cv=none; b=hpVVq37yN1hbGmRnQqEK7ZPpOfub/Gjmcy924tgrFw5yxL/qY6+02C3ustFAGBZ/ycSi6VL1NcDrUSHoUuSbKBY/X5qPLF4oA/QEytKM8vPV0xsEuU3/qSMo99kjad8E4n7tlhq3+5s5R40GjAYMce7KyXaWr0OUUCPdvx3qKvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561003; c=relaxed/simple;
	bh=bYmaOF1ob1oe9Y5D6VYqlPuhloY2wDLrXHSl+jaGS1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p17V9c5waLr50MgLVob2iGYMa8CdJKTd2/UFxyGKaAPNFYHXM8/9LeLVpSsmBOwXnJbvVrNcb6VFmRp+bX5VkQV/cFetfkLdXpfX/BHqh0wnHPDqjaRMFYGp9ztTL0GoiVKkZYN2LvOXzb2g6URaeEFvKuEfUtxspCYx6jA4xvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gWH9zxZ/; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gWH9zxZ/"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc647f65573so54442276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561001; x=1712165801; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QrnwjRpR8ayGFQ7qSq8ttTSNPnh+hqg7Tod4h7cVFQ=;
        b=gWH9zxZ/Jo2qOZsrEPHxhTRoZfT2nGoeKw2MnSTAOtt2lVP8GUnsdaEdcNcprqNC8E
         l3hUA1V8k3wekuqnxgpWhfegHkMa+OeKgqguiRcKb4wHRRnPrn+hJQmAzkNepe5Mbp95
         AvLg5whQWYLU6NxXdsF7LMZIHok/Esfk9zm1+K4P2fESqKnqmCDzLQuXmB9q72WSHZIE
         vHnNp/sgxwqRVrzb45XDLyc11+WNQgEyCDJjvKCT0yte8/PnHG+uqUFWKZTsWmp6L6tL
         KHMlFzyY9P+8ezVmtwguq6jTGK0gAjrt7qc6RxQmN9FJQEqwEKQHJoxQkkbhKaO1sZnI
         xbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561001; x=1712165801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9QrnwjRpR8ayGFQ7qSq8ttTSNPnh+hqg7Tod4h7cVFQ=;
        b=o70mmiqy049Qkel/wDOwpyHVKOoBHYPoJvWwb9YDuFsfafaqmNL4/Rr9U8rFJZnn0j
         Lk905HABBj4akVsHySgfJ94zMVPbt8VU3Fvf5UFiu6cv1iHka1PnwQUUBrrwv8RyyzXq
         MMYzXQ6XEscm/5esFuIyfRA9oJl8aTtawVL9MUzmsGCewYYysj+dqyaqbP9fMMyGoI54
         vU5FYSqN5TtD6MOeQbBvvqSsinx/ET5GBSpehIQ4g4TDYt1HwAGAOYu1IZ+p6xrc3IeU
         FVJYK3wYPXZqnaeuwq9G1u0QZkAE6aRsfg6PDw1HvPLKT+cStrfKApD5DOGKOheUv2CP
         8LIA==
X-Gm-Message-State: AOJu0YyaLrv40fknZ1llRb68xivTF/dYYfaScW1d68418oCKwKFQ6a52
	+b7OFd/6Yp9Frb+sE351tSbv/xI/Ux0ztGtEzFHNPqiZcE2CCzgZ1IbAPBvsFdbK0TXjdGgKcd5
	rX6tmPKTpL8SeyF2Jg3O4GIrpLN+6oTGAM45lMhkH1YSZKCZ24oq/HPlF3ZgqfHTHtRzhN46PhQ
	mkMPxzD3+HcNcDN3vnKEEL+6FzF20=
X-Google-Smtp-Source: AGHT+IEE9V1iuur8hYy9w51CAXGw/p93DB8mC3ZcR8b1bNgan8Ocr+YegAWgB6NbeYcePzJx8lFwJ+14lA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1b0b:b0:dcd:5e5d:458b with SMTP id
 eh11-20020a0569021b0b00b00dcd5e5d458bmr129772ybb.3.1711561000937; Wed, 27 Mar
 2024 10:36:40 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:16 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-30-tabba@google.com>
Subject: [PATCH v1 29/44] KVM: arm64: Reformat/beautify PTP hypercall documentation
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

The PTP hypercall documentation doesn't produce the best-looking table
when formatting in HTML as all of the return value definitions end up
on the same line.

Reformat the PTP hypercall documentation to follow the formatting used
by hypercalls.rst.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/arm/ptp_kvm.rst | 38 ++++++++++++++++----------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm/ptp_kvm.rst
index aecdc80ddcd8..7c0960970a0e 100644
--- a/Documentation/virt/kvm/arm/ptp_kvm.rst
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -7,19 +7,29 @@ PTP_KVM is used for high precision time sync between host and guests.
 It relies on transferring the wall clock and counter value from the
 host to the guest using a KVM-specific hypercall.
 
-* ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID: 0x86000001
+``ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID``
+----------------------------------------
 
-This hypercall uses the SMC32/HVC32 calling convention:
+Retrieve current time information for the specific counter. There are no
+endianness restrictions.
 
-ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
-    ==============    ========    =====================================
-    Function ID:      (uint32)    0x86000001
-    Arguments:        (uint32)    KVM_PTP_VIRT_COUNTER(0)
-                                  KVM_PTP_PHYS_COUNTER(1)
-    Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
-                      (uint32)    Upper 32 bits of wall clock time (r0)
-                      (uint32)    Lower 32 bits of wall clock time (r1)
-                      (uint32)    Upper 32 bits of counter (r2)
-                      (uint32)    Lower 32 bits of counter (r3)
-    Endianness:                   No Restrictions.
-    ==============    ========    =====================================
++---------------------+-------------------------------------------------------+
+| Presence:           | Optional                                              |
++---------------------+-------------------------------------------------------+
+| Calling convention: | HVC32                                                 |
++---------------------+----------+--------------------------------------------+
+| Function ID:        | (uint32) | 0x86000001                                 |
++---------------------+----------+----+---------------------------------------+
+| Arguments:          | (uint32) | R1 | ``KVM_PTP_VIRT_COUNTER (0)``          |
+|                     |          |    +---------------------------------------+
+|                     |          |    | ``KVM_PTP_PHYS_COUNTER (1)``          |
++---------------------+----------+----+---------------------------------------+
+| Return Values:      | (int32)  | R0 | ``NOT_SUPPORTED (-1)`` on error, else |
+|                     |          |    | upper 32 bits of wall clock time      |
+|                     +----------+----+---------------------------------------+
+|                     | (uint32) | R1 | Lower 32 bits of wall clock time      |
+|                     +----------+----+---------------------------------------+
+|                     | (uint32) | R2 | Upper 32 bits of counter              |
+|                     +----------+----+---------------------------------------+
+|                     | (uint32) | R3 | Lower 32 bits of counter              |
++---------------------+----------+----+---------------------------------------+
-- 
2.44.0.478.gd926399ef9-goog

