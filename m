Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4A13BADD
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884800; cv=none; b=U7WTd0wmqGjQKT3B2izUj2mRc5wOUei6fyzNrY+0mhFqnWrr0JZ9YWQdrmgvfLRf8tpVNAD5UfllVoBgj/xrYZkC9ksOXkt5+5SLjfBgRWvO0NLmrUhZjkYaQ3a+oXO/AbSRdN9FmJzpcvuxAcdSn7ygCN3VpLyJe1dwDB+GDug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884800; c=relaxed/simple;
	bh=U2hWJlimg0PScvmQvSNiutrP8PBKAJ/bc/iqzUX2aUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZQ4FV0AIDlA1SoLAXZm7frOQuZnocedL35BPGdw+3KWSYpUadDoqOaQho3sgOgdp4N+ab55Yb3iWZ5Wafy6hPANucxXfx6sU0Dyg3VdEI6SKzRSjadxX2WIFFLk2eALZX2pyh+VrKXhOg6aMFAP+Tl5zJZiPJPIQ5yP1F+R5cws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zYhvegCW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zYhvegCW"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b13ce3daaso135670437b3.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884798; x=1714489598; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=debhuxEdWbHQLqSSpCg9aCajtV4sBqhjNC75Uyo8+ck=;
        b=zYhvegCWgZ66yXOHoCKzs+7NZySPoYqiMmWUgD9XS55dS1ccgZJ92GM2YBoOd453RS
         a4yshSv9987kvyRVFUpud724F+08hi/JNaOvkonU1fIPLRgFglYp6tJYysnQ6j1heLje
         Io9z+6eWZV4h11ezJuX/dpz1nsZY3EzkXqQt2t/0lYcZ00AduIBaaZib72nu+/5GWrj4
         dJO+uJXXj4vEWBF/GmNFn9+p7A8EWE195dd7DWeQKqPItQ2BDfvM2X8pgCjNpqKNDiT1
         dH6t1FNeRj9J3cZmX2xwZZ7b3bTRcXXq+jTRDm3IBjmnJj3ylPvHhzjg3qkNZmUBftdM
         pXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884798; x=1714489598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=debhuxEdWbHQLqSSpCg9aCajtV4sBqhjNC75Uyo8+ck=;
        b=fthfksym8hAZJiXd/2xLC6e+tz4foDP5hnfk5gDkN81VHgYxk7cll+fqznL5RIlWgs
         agisW50FIABSq8KS8pqE/lANa45stt7CdvOjhSREyHrm5eYdE2pdTN4pCbwrES2mH9CF
         2yEha8xncXgnH18wkGysfcc5plL95XAiWjr8ARwf6q0lTOs2KXNmfwQOZUmpmG0553vb
         WojMjPeEEKY6eR6efQJGSIL2ce1xALdegiMnaojzc6GQuoXhapQwBzTM4SwZC8d5tRih
         FYP+ouVmmlbQhlV74Jwlyn/9yjW6+O4VYhx2+Y952Gq4ksCTAsBY+xf2BA8kolz35Odl
         cYJQ==
X-Gm-Message-State: AOJu0Yy/hJHLGmJYva00S8Z6Q+VImJD6eKbYwQFHDukYdac9zYGS6S7c
	Hh8JRYenpMghNnJnmoFiTA+W2FTmUABBTT1uwLyoI3Ssqqv1nf6t4zldMG3B3uWOtuElbUH6zeS
	1DRJ81I7XjFLYL2C6AcD4oXwg2yboy0JgSOgFKZKyyfFWE8I5N5sN1RtWGwxxxdZiBrHQJJT4zF
	ubeUbeTh/lRYJhwBXF5IF5nurzNB8=
X-Google-Smtp-Source: AGHT+IHdvE3dDkFxCiTI+ibYP/Ey2bDxN9QkTPqpenGS/+rYgsQD5ZSHtDY24vf3hOPbIqEdrt/tF0pEhA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:cb85:0:b0:615:33de:61d5 with SMTP id
 n127-20020a0dcb85000000b0061533de61d5mr3247702ywd.1.1713884798296; Tue, 23
 Apr 2024 08:06:38 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:33 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-26-tabba@google.com>
Subject: [PATCH v4 25/30] KVM: arm64: Reformat/beautify PTP hypercall documentation
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
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
2.44.0.769.g3c40516874-goog

