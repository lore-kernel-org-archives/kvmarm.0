Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBDF3E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513650; cv=none; b=mLU+tSBEwtQoaXnhSVBl+IlqtpfWPvLhfbslVfHLlHz7JmmrsQxynGMBBFHWhodoCZD0n1R+1toauAPB9rinzNacikX+CsSomOFPkIhpyayaD29S0k2ZP//qlEmEsN1dnN8Q0c+8yGxqhi2T7n/B0jRRedTqN9QqUM/1NI0iEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513650; c=relaxed/simple;
	bh=U2hWJlimg0PScvmQvSNiutrP8PBKAJ/bc/iqzUX2aUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MiGyz8mw0nEoLiSoDnXLYiO/mlj1q3P3LZlGWZlFQiBDrSqwpFvSYxVBznG3hdOuyGadAbGaNJsPmg4UelucF+hqridBbsctAGgHvENEpv9i1aNKxbrpAkpD1m3Q1jYbU3eZL+DnU9i4QtNKqPApNTb7nkHhrWofGpmM655EZJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fKd2NJlE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKd2NJlE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4165339d3a5so9865905e9.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513647; x=1714118447; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=debhuxEdWbHQLqSSpCg9aCajtV4sBqhjNC75Uyo8+ck=;
        b=fKd2NJlEf5Z1a5JV7RwSONeVf2lXpZIm4YcuNN6Si8l8rutQSpoYkQFVksQw4Jd7xi
         MgDVR0fU003ZiUeCDKGWHeGnY8xyhEUKFiqr+4lR2hXrvI+8UAyv8BsyFQteXBCtX1TG
         q8gflPpngW4Z5c8+yI6Py3UCIskqxb/leYu7Ibs5yXKsVjzLcHa+Dhlc9SdhR8IL7OMu
         vRq8sTRR1v2m/eJdNur9zzUndoE+q8vDJOHm2wJzOPgtSOQ29exha3Az5ALhRTQD2xv8
         mtvDavD6nPMUSCZ0dPtFUPJeR/D4ZTkcTGppzoDzH2UGgMeEIcgiUDLggcveXRLxOuGV
         4CGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513647; x=1714118447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=debhuxEdWbHQLqSSpCg9aCajtV4sBqhjNC75Uyo8+ck=;
        b=QotGBTUTJxW17aD1/qKnbK+EmdVFitKjA83k6tgmG4kDaaMqJVuuK7keaBOG/G7Ew2
         P3aKPzxbhOQGhHX22ywhX8wRFo84t6/7v9QB8zc82yyAkXp6BMIYdgY0DnP063UEbsAM
         s9DVuIpFqcKqC2njYsj5LvG5xVUZfOWL6eDZUKRqM4OTprSFZVJlNAalT35afSRHglt+
         NqxcesNcP2cWjmybMoCh6kJsHIlk38ve3sD3ZUXZGuWABbrIQOjz35NmsnbteXls0Lgk
         QEFIJYJNaGuKpGZwWAAeO1O+3YCjBqGfesOTGTyvhJ95OFWUvxS9cN0/ad0T1rJTassN
         MvKQ==
X-Gm-Message-State: AOJu0YyUhXXEyIwqZCbMt4Ihbft9/7gPl8CSLPG/wHu6D2/9KKYpCOsb
	2d840s7bAC3KTvwRtzkUaFmBAjIYXP4R8VCim/Mr0z4kwvczTAL6iZQYlDNfyhPMYJjLkJv/lKx
	cQAV2uI4YIz+EvVYQnKuuU+AYmBK1lyiv5mJawduzeLT+bRFYG2aZ7GuR/4CDJE2WWmst45QT2a
	G7GemlBQrEgNlzpgKVHrgLhJlRlaI=
X-Google-Smtp-Source: AGHT+IHdYNFz7OIUa/3n3D7VFZdXU9nCOx/lNNaeuEGSwRxl+uM2r5LHFAdLVXYQotXCw03LOso/4A2SSA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3ba1:b0:418:a706:33b1 with SMTP id
 n33-20020a05600c3ba100b00418a70633b1mr12609wms.1.1713513647136; Fri, 19 Apr
 2024 01:00:47 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:38 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-29-tabba@google.com>
Subject: [PATCH v3 28/31] KVM: arm64: Reformat/beautify PTP hypercall documentation
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

