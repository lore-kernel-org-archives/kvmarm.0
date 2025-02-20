Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81882267B86
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 23:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094211; cv=none; b=APWDUNTPuUDE9nT7ODgktvKTzo52wUQLoEfgRoT+JV7v6JVpctbimDLLzokhf7Aka+1hKq7k2DSvH54+ePMlr/1FvkZKMCVQQM62cst3yOIMXNo4+GBUgULP7LlAsAKtgLAxN0ilKYuo5SqjJsVjRJCMC8UH/9j1g926mRjR3Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094211; c=relaxed/simple;
	bh=mWRk++/bQqQgZy4LEk1jYBf4PCsHJwDN0tHvqsBCXpE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=esDbRNO1IWsCPqHS9d7s0fpbxfyRlLrIFN9nLwaBa9wCDHzyeFeSvc0CAy1N9pnyH7OBIKmlDXGeCMylsZL16wd45Up/S4G045lkfAp0ZPFEA6zqD0dCf5eMrvf/pYclBSWOY1ujsDeg4R2EMJknZEKOAwZB8PnYgac+EV2FVP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=biB16Umv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="biB16Umv"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc404aaed5so4983678a91.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 15:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740094208; x=1740699008; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZY+qAPOicOUq8p2LK8IeikgixBi4lx8HxmpqAWAHnA=;
        b=biB16UmvF6nhZoqjdd8GG/f9mV5Av75cApSQpFPXcL+erFEP8StHGzA7/7yjhVPKkk
         KdeHp+/3tBPBBJUxtrP7fMZjSVkY8wODX50jCP1WSWh0mevm6BOAiA4B1EQLGkGP3YdT
         aQ4ESlvW4AwQPchBSCdhy5GBl2/ukROOhXoGXoUAetQwCaIeoWnyWol0Sjk1wi2LLLfL
         2hWU7MXu9J83Vj2dVgswQMEfwsL8Nho4PkqC1pIoIOdQh6Qn3aZI++vR6WdYavLFKh/S
         qCzl7Q+ljRzgOE10Qc3PyD1Cl7kyxidSvEGFODjLNFzkmMZEUd60grVfCgHVBqCiWk75
         fAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740094208; x=1740699008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZY+qAPOicOUq8p2LK8IeikgixBi4lx8HxmpqAWAHnA=;
        b=bFJpOG311J8We/bqsToSAENHJcImD+64Ds2MPgZgRFz2OAUuxn0SpwiKDAxJ8r1XcT
         LQXID1Naww85VVtuXLlcHsbMWqppA/zrtSFdbNzkEiTk1RVSunGlxeDE8tb5hx8PBpIB
         M/FhaSlbOHhXGSllYtC8m/4JNxb5aoBIO1JC6wEkhiV5IJNWjpS43Ktvmgu0WStpCj8V
         8rOl/dnMDPtJDRgAg8BOxpyq4js0w0JbZkiaa+UGUy8sLjMKc1p02hVjXEeNCX8zRlCL
         yMAetjcjaawnCGs5Mf1ahfk3GKd9kojphm+vfdzy74z2rike+oqVJHdA8zKU8017ulYO
         Entg==
X-Forwarded-Encrypted: i=1; AJvYcCW6IIGH1e7b6giYXxrjIapF+vlWDuUu//mXD3giwamuhzcuIzwQltJFcki/kX+lrTOiMAMxPLM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgWdZwlsEvyLK4IKURnbuxjT229iTFW0qBJ2jOAmCM0mHmbRdt
	OdwkS+WXYY67gYGriCZFNeg2mDq2ivkp3zZuSZJWpavP4AGduXP3sEWb3wdgQOYZQKzExxHtoOH
	6dCGyRVoi1g==
X-Google-Smtp-Source: AGHT+IEBaG/uVrgEVEadJS5uoF6GF3zEvxqFSthLZ+KCQQjV/E6qlAa7wWQxBxQYuGn6ZWD8KVd4x5+IgTERjw==
X-Received: from pjbpt3.prod.google.com ([2002:a17:90b:3d03:b0:2fc:13d6:b4cb])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e4f:b0:2fc:b40:339a with SMTP id 98e67ed59e1d1-2fce78a95d5mr1872440a91.10.1740094207918;
 Thu, 20 Feb 2025 15:30:07 -0800 (PST)
Date: Thu, 20 Feb 2025 23:29:59 +0000
In-Reply-To: <20250220232959.247600-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250220232959.247600-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250220232959.247600-3-jiaqiyan@google.com>
Subject: [RFC PATCH v3 3/3] Documentation: kvm: new UAPI when arm64 guest
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

Tested: make htmldocs and proofreading

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/virt/kvm/api.rst | 38 +++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29cb..20c7049508484 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1288,16 +1288,40 @@ ARM64:
 
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
+  - Synchronous external abort
+
+  - Synchronous parity or ECC error on memory access
+
+  If the memory error's physical address is available, si_addr will be the
+  error's host virtual address in VM's memory space; otherwise si_addr is zero.
+  When userspace vCPU thread is interrupted by such SIGBUS, it can ask KVM to
+  replay an external abort into guest.
+
+It is a programming error to set ext_dabt_pending after an exit which was not
+KVM_EXIT_MMIO, not KVM_EXIT_ARM_NISV, and not interrupted by BUS_OBJERR SIGBUS.
+
+This feature is only available if the system supports
 KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
 how userspace reports accesses for the above cases to guests, across different
 userspace implementations. Nevertheless, userspace can still emulate all Arm
-- 
2.48.1.658.g4767266eb4-goog

