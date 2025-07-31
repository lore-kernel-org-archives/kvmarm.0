Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E8826CE26
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753996817; cv=none; b=iOHSxaf1O4tTX02oma1DILP9tawEtvD1s7cqEnsDCebFyFB7pdoV0vPNYJYjfoEmY76McQwLABH5xJYSH3Kt1iKPlfihRMHJpGoGKO7aMxZG/4yX5BgtTCtAAxmat5ZFRRjS/aFo9U2Zcuet5cBK2FsjK4t77FBR6J7i7+RkZIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753996817; c=relaxed/simple;
	bh=JT3CWRDTYG4cChSrXWCLOhvpTNKdhai2Q1ZpaBmS13M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=adBPwjms2hq3ul7WyGbz0eqhUQE+4crRJAB2rJJFRyRw1zyRRQkORJFFf8osvoVup6oX12ImX7IS0WmBMkyNp02R1d59RWAlZ50BOTehuUS1GFuJAVeRr7hQqLbDWEj+hENpFI/G/1tbInd6FZrZn4kTE+RJMK5A7TvoRdlwON4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oD1xvL88; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oD1xvL88"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74928291bc3so1477914b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 14:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753996814; x=1754601614; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wTjiUI3VYu0NKZoAdRBhNFbi9ic5y3o11ghK/xobY4I=;
        b=oD1xvL88gpw5/sld/92qMQQ837kfNim9GdntIybVBtfPYu8L1A7sehkwX4SeFse6nr
         VCDamDzbfdLTwZF3pxftqe04L2r9HZ12ipstHtpczslZAKpSXP4ycrJy+u1iiZdVaktE
         Co3vlCBgzIFTUNWck964Hn3G9eytuZanu1YZE9VozgRnexCFWkpX009XMA8RIP+4EKqr
         +fDs3B8OqVIjiipa83xfzuogR9NHctid0ry0Jui1a6ScnonR48+eb7waV2BGk2/H9aev
         M7gsTNyY+/b4voFBpmn2D2AEzN0qkwNFJKWqQv9C0JVSjq9DAk08gB21bI+YXsNpdmwD
         WJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753996814; x=1754601614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTjiUI3VYu0NKZoAdRBhNFbi9ic5y3o11ghK/xobY4I=;
        b=gv8wqgiLV8N5z/iSE6VRUFxlsDnleG7Ia6Id3xKOiQc8QvIZB88bq6+sWEqtH/DM0p
         3HISweOSf/+OWF6225o0oq4pD7IW/aK8nIxXa7VbmuJ1Isgy7UJkl9DR9byiDiQ+dIaV
         qEn+rmyiXu5Kb28bnHZ3inTl5K5agL46266KvAJ0wUXJpzKlteNL/gWHVimWtZrGayqp
         brucweJP/SyKiKJAFpkfSTkF/+8Rc519EHWLNQiQVrS87AxupviilC9DtpQTg0mPghxL
         GwR/gXt8WNQaSsCgPjmXsEXdXWYd99gEGzEaW3HpnTSC4Ui4W0si8GCCQmbBY1wmF/fO
         pN+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZmqGAzi8lBif58ztQyiOdWerfVDVw5q6uHUJrO86/mwEO7FGoFp/0i7gLKlTidXfgaijsyZA=@lists.linux.dev
X-Gm-Message-State: AOJu0YydZ+XcQDE7DRT17eMrqpu+yY85EU9riK9v6lNBM3eafPFc4g+R
	wWqI53bAfET50Es71cb8EL6JX5YrgpNgCfPUth8STt7udL+LKEYPaLLIBvBQO/9XHi8MUQgckuM
	Bgk1e1dWXZlI5XA==
X-Google-Smtp-Source: AGHT+IFhVSv5g3S5dWH4OHRA2GJ8bC5E6G/7J0FiOp5/CduJgl6OwVsVKsUaRoPixkC/rA/rTNfaZg5FrktJgg==
X-Received: from pguc17.prod.google.com ([2002:a65:6751:0:b0:b42:2527:fdbe])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:939f:b0:233:b51a:8597 with SMTP id adf61e73a8af0-23dc0ea7837mr14728409637.35.1753996813871;
 Thu, 31 Jul 2025 14:20:13 -0700 (PDT)
Date: Thu, 31 Jul 2025 21:20:04 +0000
In-Reply-To: <20250731212004.1437336-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250731212004.1437336-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731212004.1437336-5-jiaqiyan@google.com>
Subject: [PATCH v1 4/4] Documentation: kvm: update UAPI for injecting SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	rananta@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

- KVM_CAP_ARM_INJECT_EXT_IABT: userspace can inject external
  instruction abort to guest.
- ext_abt_has_esr and ext_abt_esr: userspace can supplement ISS
  fields while injecting SEA, for both data and instruction aborts.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/virt/kvm/api.rst | 48 +++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 53e0179d52949..8190ffb145c37 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1236,9 +1236,11 @@ directly to the virtual CPU).
 		__u8 serror_pending;
 		__u8 serror_has_esr;
 		__u8 ext_dabt_pending;
+		__u8 ext_iabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[5];
+		__u8 pad[4];
 		__u64 serror_esr;
+		__u64 ext_abt_esr;
 	} exception;
 	__u32 reserved[12];
   };
@@ -1292,20 +1294,42 @@ ARM64:
 
 User space may need to inject several types of events to the guest.
 
+Inject SError
+~~~~~~~~~~~~~
+
 Set the pending SError exception state for this VCPU. It is not possible to
 'cancel' an Serror that has been made pending.
 
-If the guest performed an access to I/O memory which could not be handled by
-userspace, for example because of missing instruction syndrome decode
-information or because there is no device mapped at the accessed IPA, then
-userspace can ask the kernel to inject an external abort using the address
-from the exiting fault on the VCPU. It is a programming error to set
-ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
-KVM_EXIT_ARM_NISV. This feature is only available if the system supports
-KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
-how userspace reports accesses for the above cases to guests, across different
-userspace implementations. Nevertheless, userspace can still emulate all Arm
-exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
+Inject SEA (synchronous external abort)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- If the guest performed an access to I/O memory which could not be handled by
+  userspace, for example because of missing instruction syndrome decode
+  information or because there is no device mapped at the accessed IPA.
+
+- If the guest consumed an uncorrectable memory error on guest owned memory,
+  and RAS in the Trusted Firmware chooses to notify PE with SEA, KVM has to
+  handle it when host APEI is unable to claim the SEA. If userspace has enabled
+  KVM_CAP_ARM_SEA_TO_USER, KVM returns to userspace with KVM_EXIT_ARM_SEA.
+
+For the cases above, userspace can ask the kernel to replay either an external
+data abort (by setting ext_dabt_pending) or an external instruction abort
+(by setting ext_iabt_pending) into the faulting VCPU. Userspace can provide
+Instruction Specific Syndrome (ISS) in the ext_abt_esr field to supplement
+the ESR register value being injected into the faulting VCPU. KVM will use the
+address from the existing fault on the VCPU. Setting both ext_dabt_pending and
+ext_iabt_pending at the same time will return -EINVAL. Setting anything not
+being part of the ISS (bits [24:0] of ext_abt_esr) will return -EINVAL.
+
+It is a programming error to set ext_dabt_pending or ext_iabt_pending after an
+exit which was not KVM_EXIT_MMIO, KVM_EXIT_ARM_NISV or KVM_EXIT_ARM_SEA.
+Injecting SEA for data and instruction abort is only available if KVM supports
+KVM_CAP_ARM_INJECT_EXT_DABT and KVM_CAP_ARM_INJECT_EXT_IABT respectively.
+
+This is a helper which provides commonality in how userspace reports accesses
+for the above cases to guests, across different userspace implementations.
+Nevertheless, userspace can still emulate all Arm exceptions by manipulating
+individual registers using the KVM_SET_ONE_REG API.
 
 See KVM_GET_VCPU_EVENTS for the data structure.
 
-- 
2.50.1.565.gc32cd1483b-goog

