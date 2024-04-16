Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399032907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261474; cv=none; b=WZWEoyZiUY1h16ABR36O8hGIytM8kJbjUsNedqBAcP0gWNtgMD/rekMA7JDDYfCK/bKnprwfTbgF03ovaZ3J8jauqCO1v0FgqqnZpUS3t9j3vvg7H9reR1Zgozg94v+DjB3D9K2xv4lXXIOCWWVgJpVIkJVUwBs3pHtNml6z8qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261474; c=relaxed/simple;
	bh=PvsGts94/Zj9bo5UHnX9mEc3uMwuzygh//7CN14IbzQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=COXGCPd0DBs4/t1pQ9GusnHIdVaRLefmnIkzgO6OShK0hJw82A9hAENtkxSWqtmpScwJalAue0XxqlPBEpIKCdxceTRm6k8JgCso0XhntU24uMsRzhNr/rk70+vixx6eioyPkXHO2gCDNOorpMdULW9gs1hcovQOeubSwiUJnEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oUNVeeFA; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oUNVeeFA"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-615372710c4so69455257b3.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261472; x=1713866272; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5P3LyYfZT+aQXkSPKePeLh0OJ/0jG67RAP5Uoy/Tuo=;
        b=oUNVeeFA4yEp7x9hj0iFFUXJiN7ahOrhjMkUvrUlQeHRmnOP2pqYrDdxnNCGJOkFpJ
         +st36eD4JUEXaihU9dwxXWlb1Zx21CGoVveKE2/13RmK0UD9IhsSYr6K9aoECC7R55hp
         t26VyOnTqs0Bu0KrHOVjBi2AxmwOsOdcSWW/R/4JVy0i/sVMA/RDt0HyhbXBe9uDXYTG
         aIuttTgl7Hi7J+nQ7xNYgJ05To1HwuSbtDZLo7/qPDIphxVdyiqDa3I6iBMMebm5AIUY
         kK9akwqf+mcmxB9p45ECFngF2bFerV21mjfbgULby6lBI2PCSpJ2Ck2stKT3pQk9aSbD
         /iaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261472; x=1713866272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5P3LyYfZT+aQXkSPKePeLh0OJ/0jG67RAP5Uoy/Tuo=;
        b=gNKN9m8B4fsvqbVajeWdr/6M/rjrqb/tYXVGR5PpHBKfJqU5ezJ6Elu284zXHRFZXm
         bOF0fYnG/9ga7CTqLRd7+8Uz7wW4Hj2TXqhI52fNeaWuscYQke20GhD9Fmk0uyHHsokr
         EzvBwfrWmQQ2qCetKtAbQm4c91EyXL7c4giYrjfdfU6kRJr1oya3ANFEBwSORsVBssP5
         D/+S/Y9jNVmJEq+tWMdXARrflkaJPIuUmu0bOlusx4PrQlfeePGOjx7Id1lKEM6K3CkT
         ZkYxW+B8+jrtte5lr2gqN23b9JdVmNDtKcjnVq27GODPtVoX7XHiCOaH5ZlX1vstHuW0
         zV+g==
X-Gm-Message-State: AOJu0Yxjq79dbyfqX4+WVPQB7hVe+uw0xFo4cQRIATEKzVpmWnrrEQ1z
	mEav3AYEcfikn4ukLMqE9OSZ66tF/5JQbdnHCHkxdmYc+20lp2EzYsXEmG3Xpe27cgtJkrCDnqq
	A+fCKbFWfm45g0YZ/NW0stkrl0Ms/V6+hg1WL56FNdH7kX9aZvCZxuhRkjpNzd9jHiwgn99xU2S
	iEkTJdEiutQ7P13OzjSbHJMab/biI=
X-Google-Smtp-Source: AGHT+IGtIOP2F1vis3Qw3EwYTf+pT0PqHT9/k0GkU17G0izJEmPKTRwu4cpSwW+CBzmeNAxy6eENdmIJEQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:6f89:0:b0:dd1:38ec:905d with SMTP id
 k131-20020a256f89000000b00dd138ec905dmr1298502ybc.11.1713261471812; Tue, 16
 Apr 2024 02:57:51 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:22 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-32-tabba@google.com>
Subject: [PATCH v2 31/47] KVM: arm64: Reformat/beautify PTP hypercall documentation
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
2.44.0.683.g7961c838ac-goog

