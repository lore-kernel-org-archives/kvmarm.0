Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AC414691B
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041263; cv=none; b=RDLEyl5FpQkNEgsq9Xo8r+MCut7vxKvohaLTk5ZLPYrcBZV4hKmX2hVnv7O47e6jEKdmDhrFf7byGiDkDhzP5R/h3YM9B27GSDZgYjNbtFh/mipCn4Sz7x8+IAHdWw5NttCtRDkD7cFTafKF+Qv7VqIYTf9PsH/tUjAj0xHWMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041263; c=relaxed/simple;
	bh=YToCq6YE1hZ8sueGTK5tm1JNAU/Na0mmX/7tgTx5B8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fo2XCJibeBJm1G6x0kfQFBTqTH/3d+BneEtUKuevszcHTjRmxc7m9IU9HDXbEB7Cadebq1U3fuz12p2tJG8wEIQiP9FqgUe+yvQDZsto8y29Je606v1alc6Q+wjvaNickocKcpcSMB0PJNCXHdL2bG0Za5w5DEHRab2xrUiZw84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OKDDBZRv; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKDDBZRv"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b269686aso2204299276.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041261; x=1708646061; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a2S+MA0gE/d7KfEW/MnTZniPFqQuhRYWD821pFFz3JE=;
        b=OKDDBZRvdSW/y6CmT2/+YmcZiD5KvxRtQ+5GKeGWfUbwyUOEAQB4Iy1F7cs8k3JIW6
         sIH8hQaFfakGR4cKByhsA2HvjyIw8JvO36XL+oJOyW1FtEn3Irmh4a7YafhtIf9i2oJe
         4bH6JEcdV4wV+uld78fBLCZTAwTaPUK/cDUCDv+KEuXTcoD4eVv/Pwm1JbJuvCgS7hyk
         Fm8qD1fUmYzBelVuHnukUOM5GMLufc35mBisSZzkBvL2u4T4WpIMcMY8tCFMPirCfZ6F
         CYVeDN907BjHC9XhTdqjZHXbHUsWJIIe2NCwIwP9yottNO+L9NbU+3tNdWcmvQA1itfW
         3Opw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041261; x=1708646061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a2S+MA0gE/d7KfEW/MnTZniPFqQuhRYWD821pFFz3JE=;
        b=R/9PaKnqeWF19DIOweCwRE/ZJBxAErMeJ7hxbrf901Fau0KTE3KDA7oHIQwGLRJhGv
         y818G3tiXude0hCyGraE5Pid77b3HoQowseOOEA9HfPAEQqWQPvI115eOYKcPl/ry4gN
         tWwvsH06aTxO8jkDdpxAY4s6dmhtvnStUn4vdTtRNiphqGFpkc2xQxzKaV02NUI77+Jv
         Iq79Uk74l/n9WV81G3AdySeLN1QRtzlAnDIowvacHtRKL3YBiZ65T27f43Z1RyPS+Vq3
         +QHZHChL+BU1okrS/KzdCRn0yscycOPvSX9AqpCFgYxQqIy+2xYXhJy7p/OYC+I/ge4p
         PuIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKntXd44IKXglQcNP7UEBm/SGLEF5DY6Cu3fe8PC053+1ZYL1JbydWTJKxWzLLqQ6B/fCd3+QJh/J3EE7eOKni37xR99Kf
X-Gm-Message-State: AOJu0YwacjvatsuKWPvCikMRc/sj9pZG+AAv6vRRVwAtiPGGeu86Scd5
	j/8d5Tlc5XT8ToS9gg/fVC6GlDmc7bBDp2HvGv+WPIDwvx32adbguJdRN5FRYp5VO81SweVkYRK
	zIPbO/txDxA==
X-Google-Smtp-Source: AGHT+IGz7VwdL3z2Ro5FaEmODCGgndNM7ib0sMxb1cnlGqMmU2k8rLAE706Rj6Rrb94BZLFTt+/xxEEKwv9eHA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:110a:b0:dcb:fb69:eadc with SMTP
 id o10-20020a056902110a00b00dcbfb69eadcmr129670ybu.6.1708041260877; Thu, 15
 Feb 2024 15:54:20 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:00 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-10-amoorthy@google.com>
Subject: [PATCH v7 09/14] KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Prevent the stage-2 fault handler from faulting in pages when
KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
call to check the memslot flag. This effects the delivery of stage-2
faults as vCPU exits (see KVM_CAP_MEMORY_FAULT_INFO), which userspace
can attempt to resolve without terminating the guest.

Delivering stage-2 faults to userspace in this way sidesteps the
significant scalabiliy issues associated with using userfaultfd for the
same purpose.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/Kconfig         | 1 +
 arch/arm64/kvm/mmu.c           | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7012f40332b3..01b762272b6f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8052,7 +8052,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
 7.35 KVM_CAP_EXIT_ON_MISSING
 ----------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 01398d2996c7..309d8e7ebc1c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select XARRAY_MULTI
+        select HAVE_KVM_EXIT_ON_MISSING
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5b740ddfcc8e..b0f1fef0a52c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1487,7 +1487,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, false, NULL);
+				   write_fault, &writable, true, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.44.0.rc0.258.g7320e95886-goog

