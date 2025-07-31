Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DE9264A7F
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 20:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753995541; cv=none; b=pUTRsLeEM4/vUzHhxf/3GpbcXcWOWXVBm3NYy7AIGhvgvOc1/PDo8nYX6dIhMFSqTzNQG+7kTCZZEZozjwdUP+gp/45eB1D7XafTjw7o4Bz4lheQT+pbqmxBfM7VZcAXVdH5XrBeKBiUrCDqZsYbrY5lWaOMvRd7Z+b0bdu6sjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753995541; c=relaxed/simple;
	bh=yoT6DJExb3VRWLBkgFpzEF48Jk7YiXC2lt/RI1WEyLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ch8IOiuvwSTinpCmcwFmCiA9DYt+skjZO49inDPL9px0fZCA3ByGF0JgJfoGaDdacEmM7QRfeefQsSEnZpaIEcba9qmQrmxh2xWoiVrBN1EVMQmfegMOL6I3m5K+8dx6MTVrSPNZlvDJetDXxIileVLHdltqfp4eK1lPh0BGUSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FOAhOhXV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FOAhOhXV"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f74a64da9so1053648a91.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 13:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753995538; x=1754600338; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eUXB20g5KTDpVxkdi+cD6LrJ9ZPidMR3ejh7YHbLbWc=;
        b=FOAhOhXV4WHYY5tNqFwnBeVbrpJcTYrDZCqdqrczsbBWtME7NBC4dyhkgbJa7589Yd
         jF/LQY8jKx8sTe/ZlHpu8wKpn4sImXS2yJVcg86+lzC9iijmXdacvQVManAAYsI578Zo
         AalIekDnuWid5qb72X19twbAlArT509mBYQdw1/3YLClOeuvlq+1F1pVJPW1Jh3E19h8
         d8f3QC7xncoEXOvP8ugKs+A5AsP1EgT88rh1L7WbZy1eLsSf6BiwXz3XXErG2T0/XjCk
         N3H0OXN9gwn/OiuIjqNtb7fXtQO2PM88F45a18GCcqc0fXo+te+A9F3s3R2HU05LQg2Q
         BEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753995538; x=1754600338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUXB20g5KTDpVxkdi+cD6LrJ9ZPidMR3ejh7YHbLbWc=;
        b=ftrk+sCLuWIwB9YM/Ioc2NFYkK8Wi7OVv8MBuaFuuz6yklzwDHxtCELfWOPHUw582O
         9duULfkBd1sBWPZZxNdmE+5eHZf/NBTNK1Q0pVcTM2ynA0fY6ynq9599va4A8MtmvGGD
         LucyvTV2AoVEvwTZo55im1zGQ3TAm43nKMkGjkv4hALs6N9NqrcJGMwGE8JEo1W//NFs
         uyj882cRUlaBpksF8LUYsQYTWmIcRUS8efkppg9APbTXReT4w57PHjx7Duhl34uYkSpa
         59DTatxpj+VWOZCGFMm8r7OEjk5fyr5drWnCfNhzTkC3ZdRFHHtO6JK1O2o9J3xL7rOA
         4XuQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+sGXjfK0xlZHbDjVOOwSlLf5rC0NU0vIUM5yGVNkRYdtgNz3FbX/a5CsPSISymIaRbvevC/4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNA8SgjPCZJf7XxA60BdS8SddQNxNVzYjdBfX9RHQf2Mcg7kuR
	lbH2dS+5VQ+LTMlnrFWgdDVA2rk+WhT8mx+MuB2whiX5/t0rfvJAnoOgy3JTzU5EbEyGFlp20X7
	xE3a5OHIeE98Jzw==
X-Google-Smtp-Source: AGHT+IHpN+KMEdudZzx9R+o2+YGbSRX7Sb8ugKl+/4e/Osfparz535RYvSTWw1nMv5ihMLOYXj3j/6PFJN9K4g==
X-Received: from pjtq5.prod.google.com ([2002:a17:90a:c105:b0:31c:2fe4:33bc])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b46:b0:315:9cae:bd8 with SMTP id 98e67ed59e1d1-31f5de3f47dmr11403605a91.23.1753995538407;
 Thu, 31 Jul 2025 13:58:58 -0700 (PDT)
Date: Thu, 31 Jul 2025 20:58:44 +0000
In-Reply-To: <20250731205844.1346839-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250731205844.1346839-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731205844.1346839-4-jiaqiyan@google.com>
Subject: [PATCH v3 3/3] Documentation: kvm: new UAPI for handling SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Document the new userspace-visible features and APIs for handling
synchronous external abort (SEA)
- KVM_CAP_ARM_SEA_TO_USER: How userspace enables the new feature.
- KVM_EXIT_ARM_SEA: exit userspace gets when it needs to handle SEA
  and what userspace gets while taking the SEA.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 53e0179d52949..b61bca10a3a10 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7231,6 +7231,55 @@ exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,
 it will enter with output fields already valid; in the common case, the
 ``unknown.ret`` field of the union will be ``TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED``.
 Userspace need not do anything if it does not wish to support a TDVMCALL.
+
+::
+		/* KVM_EXIT_ARM_SEA */
+		struct {
+			__u64 esr;
+			#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID   (1ULL << 0)
+			__u64 flags;
+			__u64 gva;
+			__u64 gpa;
+		} arm_sea;
+
+Used on arm64 systems. When the VM capability KVM_CAP_ARM_SEA_TO_USER is
+enabled, a VM exit is generated if guest causes a synchronous external abort
+(SEA) and the host APEI fails to handle the SEA.
+
+Historically KVM handles SEA by first delegating the SEA to host APEI as there
+is high chance that the SEA is caused by consuming uncorrected memory error.
+However, not all platforms support SEA handling in APEI, and KVM's fallback
+handling is to inject an async SError into the guest, which usually panics
+guest kernel unpleasantly. As an alternative, userspace can participate in
+the SEA handling by enabling KVM_CAP_ARM_SEA_TO_USER at VM creation, after
+querying the capability. Once enabled, when KVM has to handle the guest
+caused SEA, it returns to userspace with KVM_EXIT_ARM_SEA, with details
+about the SEA available in 'arm_sea'.
+
+The 'esr' field holds the value of the exception syndrome register (ESR) while
+KVM taking the SEA, which tells userspace the character of the current SEA,
+such as its Exception Class, Synchronous Error Type, Fault Specific Code and
+so on. For more details on ESR, check the Arm Architecture Registers
+documentation.
+
+The following values are defined for the 'flags' field
+
+  - KVM_EXIT_ARM_SEA_FLAG_GPA_VALID -- the faulting guest physical address
+    is valid and userspace can get its value in the 'gpa' field.
+
+Note userspace can tell whether the faulting guest virtual address is valid
+from the FnV bit in 'esr' field. If FnV bit in 'esr' field is not set, the
+'gva' field holds the valid faulting guest virtual address.
+
+Userspace needs to take actions to handle guest SEA synchronously, namely in
+the same thread that runs KVM_RUN and receives KVM_EXIT_ARM_SEA. One of the
+encouraged approach is to utilize the KVM_SET_VCPU_EVENTS to inject the SEA
+to the faulting VCPU. This way, the guest has the opportunity to keep running
+and limit the blast radius of the SEA to the particular guest application that
+caused the SEA. Userspace may also emulate the SEA to VM by itself using the
+KVM_SET_ONE_REG API. In this case, it can use the valid values from 'gva' and
+'gpa' fields to manipulate VCPU's registers (e.g. FAR_EL1, HPFAR_EL1).
+
 ::
 
 		/* Fix the size of the union. */
@@ -8625,6 +8674,18 @@ This capability indicate to the userspace whether a PFNMAP memory region
 can be safely mapped as cacheable. This relies on the presence of
 force write back (FWB) feature support on the hardware.
 
+7.45 KVM_CAP_ARM_SEA_TO_USER
+----------------------------
+
+:Architecture: arm64
+:Target: VM
+:Parameters: none
+:Returns: 0 on success, -EINVAL if unsupported.
+
+This capability, if KVM_CHECK_EXTENSION indicates that it is available, means
+that KVM has an implementation that allows userspace to participate in handling
+synchronous external abort caused by VM, by an exit of KVM_EXIT_ARM_SEA.
+
 8. Other capabilities.
 ======================
 
-- 
2.50.1.565.gc32cd1483b-goog

