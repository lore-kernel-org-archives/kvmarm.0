Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE5F1799F
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558696; cv=none; b=q1Jkjj/PBKfSX8iDll2dUT4XhLWAEsfCkO6tKy7ZtE+jjBkN5iZFT+WfRvq3YaeQzFjwaCyR/17QRQdYO3bPFjm3vy1pj3YHYmfFih8ZXv1zm+dyBbNAXer9rWrCzsxgUdAULigRMiSdXW1ZHTNLIpp2xhvDLqXNPiw36+Q+eik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558696; c=relaxed/simple;
	bh=lQwpsShXHQI91s1IhBjcEI9cJsgfBQq8tkKtVM0oTIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=isEysPAAvsYHSDftQvDCAW6rZ41UQ/QoiKPXdRt0ddCkDMdJ3/eeKTT3er46tK/W01J3h2hvIM4qWjyQdSJ6qDpShJJyiW/qVxlROR1xKHCNxiPgB23A+HYgPTFYRYq1jrbKiZpgFUuJR5q1UUwbZMy74Btj4aVW2dt2z/7371g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bzUbZwZd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bzUbZwZd"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9743093so4787842a91.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 17:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558694; x=1737163494; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=L3TyIoxqzKbU5TOqXbLBWWXwSPvFkN5kGJBIZi+nPuA=;
        b=bzUbZwZd5dSH2DcLLCGAPB5EO98k80VR5msFg/7jkAaX2ivnUi7McZREjqlQJkVWvb
         WgzP61Pb/eW4jgTR2UdfH0+dpugeFgyEiWsIt2r/TveqJOJTNH+MFhsSFa/MLbHMkcNr
         akF0OdY6fPbCqMDsaNc02CteAm2xIMmTDhlEuTGoI6WmSo+FoKkGjZyEFqJohJKM2aKD
         HwJdhT3jFvKffVtX1QppsmPZLdNNRjl/0rpWLD6KlvmSYSOrOeEGwLaCJXH1cci7jXFE
         +fX6SGoGpOeQQnRRLh0Z6HzJnFfCBknRRp/l33uUB25kGEBHvYHh5brKjTFD6aaCJADv
         hdmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558694; x=1737163494;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L3TyIoxqzKbU5TOqXbLBWWXwSPvFkN5kGJBIZi+nPuA=;
        b=oiav2hF3vI1wy0+4SNwxkP2rYUbxoTEa/StCPlc+LsvPFGkoMetVjxr9BS5Y1nefvt
         +1N5I/eIhcj5aKj519gOhZYdew1PbtsDqWeE+/d317j6qRnhi7JPcCdB2Ai+blwBYIec
         3GevZNXInKbHxTzuu8XO9wJyWZhdvrGIi9qHShaa1AtmheI0/BoJMwiYaoS2uLkzgdGV
         6qRxS6blCZQIrHhGrF6i+JytlnAb1JodP/M8+asdh3aydLqWSLd3dE5fxfD1OdtUcuDQ
         OjWhovNdcIHnXslLNaJNmuZvHt05YRKU28jhfnE2y81LUf7Sb7IRS5NAC9Q8Vgyl2SYk
         m8JA==
X-Forwarded-Encrypted: i=1; AJvYcCVzOJMzbVJzoerVhRRAXKwOT2SHwNgWlMJrAeWczXad82dR0ouSGmsk9QO/gvclmh1S0KYYUKU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4yW2gdI0tuGlpjPnrpiQxw9PlEqC8oSGlVYihS+Eh+bMOe3K5
	UbxKlBCcNHb4DFMxr0Xo2RZFZshl9ECfsugkcAfaCVV2kyZfnMKVW5zpSvSSkzHTobLwbXvd9x1
	+vg==
X-Google-Smtp-Source: AGHT+IHQFtnrz9Qz4G4DVM+w+HCWHLq9SWFcOY5MsmF5EmSUkf18xpdPguK9lOowTA48c954eXDA8ByTfJE=
X-Received: from pfld20.prod.google.com ([2002:a05:6a00:1994:b0:728:b3dd:ba8c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:114e:b0:728:f337:a721
 with SMTP id d2e1a72fcca58-72d21f29214mr17702842b3a.7.1736558694264; Fri, 10
 Jan 2025 17:24:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:46 -0800
In-Reply-To: <20250111012450.1262638-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: x86: Document that KVM_EXIT_HYPERCALL requires completion
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Update KVM's documentation to call out that KVM_EXIT_HYPERCALL requires
userspace to do KVM_RUN before state save/restore, so that KVM can skip
the hypercall instruction, otherwise resuming the vCPU after restore will
restart the instruction and potentially lead to a spurious MAP_GPA_RANGE.

Fixes: 0dbb11230437 ("KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 39 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 454c2aaa155e..c92c8d4e8779 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6615,13 +6615,29 @@ The 'data' member contains, in its first 'len' bytes, the value as it would
 appear if the VCPU performed a load or store of the appropriate width directly
 to the byte array.
 
+It is strongly recommended that userspace use ``KVM_EXIT_IO`` (x86) or
+``KVM_EXIT_MMIO`` (all except s390) to implement functionality that
+requires a guest to interact with host userspace.
+
+.. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
+
+		/* KVM_EXIT_HYPERCALL */
+		struct {
+			__u64 nr;
+			__u64 args[6];
+			__u64 ret;
+			__u64 flags;
+		} hypercall;
+
+
 .. note::
 
       For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_XEN,
-      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
-      operations are complete (and guest state is consistent) only after userspace
-      has re-entered the kernel with KVM_RUN.  The kernel side will first finish
-      incomplete operations and then check for pending signals.
+      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR, KVM_EXIT_X86_WRMSR, and KVM_EXIT_HYPERCALL
+      the corresponding operations are complete (and guest state is consistent)
+      only after userspace has re-entered the kernel with KVM_RUN.  The kernel
+      side will first finish incomplete operations and then check for pending
+      signals.
 
       The pending state of the operation is not preserved in state which is
       visible to userspace, thus userspace should ensure that the operation is
@@ -6632,21 +6648,6 @@ to the byte array.
 
 ::
 
-		/* KVM_EXIT_HYPERCALL */
-		struct {
-			__u64 nr;
-			__u64 args[6];
-			__u64 ret;
-			__u64 flags;
-		} hypercall;
-
-
-It is strongly recommended that userspace use ``KVM_EXIT_IO`` (x86) or
-``KVM_EXIT_MMIO`` (all except s390) to implement functionality that
-requires a guest to interact with host userspace.
-
-.. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
-
 For arm64:
 ----------
 
-- 
2.47.1.613.gc27f4b7a9f-goog

