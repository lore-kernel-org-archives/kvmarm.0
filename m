Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD88013BAC3
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733446979; cv=none; b=VC8Y+aSp16j5whxrNZU2yierDkqvWxsrm1Wsx5ischm2Fbfo6H7lWjZ/S1AdJ4vcPfYZZZmmqqGjowA44O97xQBpDVpXYlqpb3Lcs+ItzijenHw5tHeZ9EohIHJinKU5UcVbxK01r9CR1MvLknvpLJ4EZqzwHkyLYGFMByz7V5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733446979; c=relaxed/simple;
	bh=ct+i7VPOT7WsAUB0e2nofOLm4XRPPEhATcLjH3zAifo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HYZrckV06tlJz56g/KMJNQkHd03AyYpgCFeH66pzeOomVVORzgqn4YnleH1tlFmp9O5WsiL4W2kOMEs9rzq1fx4GvHHbFqdjA2wnIsvy25kSKk7RYTYrto441oDS1DyA1e6jcuA05VERw5bKGUlTqH4DYEQ3TfMXItARjAyaD/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2wC2ZRDv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2wC2ZRDv"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso1765903a91.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Dec 2024 17:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733446976; x=1734051776; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E69J+2d2iF7wp/ivOT/6vtBgFfFDMf+WrmT04fDpQV8=;
        b=2wC2ZRDvXdT4DYG5JxOqMJ3IZNH+wqa6UjiZ2DqqVaIWEIPL8GiTitqkN39uFjFs5W
         pKyNrevCPyHad9eldp5C1a9+Quh7p3uAT8DQkkIVz5BdGzx7t/vJzNNTCSe7EDtC/dT8
         p07wLva3cBHKyvLmaNMjViR8buRU/Vmtnh6Lc32pVRyYJGOn9praK6mRYSg/w2TBEl/5
         7/d8GD6crp8m0pgQHtY00EsJNzeKlnrKslIQ9209UxCOn0PpgI+GLdKRfwcKLZa4NIiV
         neZRVH54sstJdzsauGvDqSOAQtaRjjZeYW8VNfd/GPmLdG8NHwfzvFC57YvfWSRCM1mv
         AulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733446976; x=1734051776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E69J+2d2iF7wp/ivOT/6vtBgFfFDMf+WrmT04fDpQV8=;
        b=Zc8SbAHv84Tm07vRmYn0o+T+iPX+Eu+wCoWbc1AgzUABJGLTTiz2luvVPS28HYfbuI
         /Uvr44/gtwwzvMEz4x8YFgq0WUJCh9pIQ241r5I3qqPRbo2ApGDac+Du1y4O1bYsDOzg
         3nWMR53BrGu0looqDcHFb2raqqVPJgR76NdwmX4D1ckLJQMo132Bb2njU0Amyyi9H7aD
         WK0kLUAYl5kzpgkZxUZrMowppRw3wlw+Ki6jKgpczzs/62ICIb0FMoB0SsAHLJkth3Qu
         byahq7eNMVs2vXJaQhcEkkBGWpq7brBVTAzhA5QjwquPeR8RptF1xJvHwCX6C4inPldn
         zBTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbLTED0fiuhUkirNBTUUUPCV3o54lMkYWAza3vzPSc6jM7AcE5nipctGijxVDcfDyyak3R+rg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFgCK0Ze0ZzmvHiFGQvLv9oGCPAYeOX0ViMfOEGJbDjFIxM23K
	TX3XvwTV8XPsPmHAikTHOBeCLEp3fd90Ukd525cXmPG8EVjoP8g+Nwnk19y4Rvp1SRnrnmva8fs
	Glp6TWqbCKQ==
X-Google-Smtp-Source: AGHT+IF8Xr3ZU+SUR6OpvZcjlpe9CogaDlgckw7I+MWP1P15dWO/yWLOygkWrh/pIlrxSKbsRGZqKXsI9AbbGA==
X-Received: from pjl16.prod.google.com ([2002:a17:90b:2f90:b0:2ea:9d23:79a0])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:33c4:b0:2ee:8430:b834 with SMTP id 98e67ed59e1d1-2ef6945f076mr2087792a91.4.1733446976124;
 Thu, 05 Dec 2024 17:02:56 -0800 (PST)
Date: Fri,  6 Dec 2024 01:02:46 +0000
In-Reply-To: <20241206010246.40282-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241206010246.40282-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241206010246.40282-3-jiaqiyan@google.com>
Subject: [RFC PATCH v2 3/3] Documentation: kvm: new UAPI when arm64 guest
 consumes UER
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the documentation for new UAPI when guest consumes uncorrectable
but recoverable memory error (UER). This new UAPI enables userspace
to inject SEA into the guest.

Tested:
make htmldocs and proofreading

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/virt/kvm/api.rst | 46 ++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 454c2aaa155e5..67645bdb66fe5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1288,16 +1288,48 @@ ARM64:
 
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
+Inject SEA
+~~~~~~~~~~
+
+- If the guest performed an access to I/O memory which could not be handled by
+  userspace, for example because of missing instruction syndrome decode
+  information or because there is no device mapped at the accessed IPA, then
+  userspace can ask the kernel to inject an external abort using the address
+  from the exiting fault on the VCPU.
+
+- If the guest consumed an uncorrectable memory error, and RAS extension in
+  Trusted Firmware choosed to notify PE with SEA, KVM and core kernel may have
+  to handle the memory poison consumption when host APEI was unable to claim
+  the SEA. For the following type of faults, KVM sends SIGBUS to current thread
+  (i.e. VMM in EL0) with si_code=BUS_OBJERR:
+
+  - Synchronous External abort, not on translation table walk or hardware
+    update of translation table.
+
+  - Synchronous External abort on translation table walk or hardware update of
+    translation table, level 1.
+
+  - Synchronous parity or ECC error on memory access, not on translation table
+    walk.
+
+  - Synchronous parity or ECC error on memory access on translation table walk
+    or hardware update of translation table, level 1.
+
+  If the memory error's physical address is available, si_addr will be the
+  error's host virtual address in VM's memory space; otherwise si_addr is zero.
+  When userspace VMM is interrupted by such SIGBUS, it can ask KVM to replay
+  an external abort into guest.
+
+It is a programming error to set ext_dabt_pending after an exit which was not
+KVM_EXIT_MMIO, not KVM_EXIT_ARM_NISV, and not interrupted by BUS_OBJERR SIGBUS.
+
+This feature is only available if the system supports
 KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
 how userspace reports accesses for the above cases to guests, across different
 userspace implementations. Nevertheless, userspace can still emulate all Arm
-- 
2.47.0.338.g60cca15819-goog

