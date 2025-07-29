Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72917235358
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790418; cv=none; b=lHv9OXsRS5vZ18etxXG4IZzhJdn1s1z5Co989QfTVO2OSYMXVqRXPfw3yfuOwA/nosk2Kmx8hRErczc9QIczlTbcM8HgwZ9ssgKp0rKWHtOLeY7Dsy3yVsNmnHlhG9Nqi9P1bTTEp7L5UabeIGsov3hPcW1eM0jPDowE8RmHtJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790418; c=relaxed/simple;
	bh=VfaOBGhpT3ZBzs+ked0YdFd4+72zRdRXp8MERQ4WQ+Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=E37jwB06OVjxv5FQq37A8wgC7m9Tex26ZuBKFivjAqFBqoZ3c+ZQrs3HCpPfuiEnV8+ATqM05Ky3YH8Y8FxiX1+jScGIrRnKUk0F1pN7fBk1mWuqVGjbt6YotIst8U2CRaa3cAnWjmpZ5sIF4o4ZRWBGTEEAVtazub1QlpN3mcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=clWT+cNn; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="clWT+cNn"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4560b81ff9eso27887995e9.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790415; x=1754395215; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X4/83bWvjHcitzad3pCSz+7Zeg+jLiSHIOrBXMY9vQM=;
        b=clWT+cNn6eBVpd9LSjs/QUhJUGoX7TRyjBaOEbWYMyPNdABtC66drh/eDp+rufTQAv
         SY4li9r3qV57HUkfiIzw6dBRAA34H9/u5MDRIoXlus6eOCqBJKJohukqRvNzlAlv3hMn
         ejHGkY8VlPYkqkgj8WA4TXm01yRJuFCwWO8Xa9gHYwx7+ibPbdx3zmubWOa9tCqAjpmO
         xIZvErpL232vrOnkxiumU6WJaZV1lvSeIE3/gZNsM8cyFJyhUvqlFTBZ1KRyd9hQthft
         kPkL9BmieRo0az4xz20C4R1ioosqjoH250p4DvplhKZigmUuEvEvaXyTc8kc/YF8QPv+
         1fPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790415; x=1754395215;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4/83bWvjHcitzad3pCSz+7Zeg+jLiSHIOrBXMY9vQM=;
        b=vzsgGCnSOmoO3NNZiOspoXeAJpNPGLkAPv11zfkbseWiwctwWyLI0MnqInT7VH7LJ5
         L0vDuWnKCPojIA4IkhmzfNIFK4a1uHpjOPs0L1QxzX4fBRACPS2lrpqNIw95kfsfNERZ
         jUeGMLi1nbH9p13XOvLx+LURZG7320RfG6BeEcaPenm9CWWb6UxO0+RcoZJpdG/aOaC6
         uvUnIAt6iaaIypwJ0ss+7eTRzTRxYfzLEWTZhI+jRWIUyj6K0xSteXnxtBQ+UocQqCCq
         kP7riK/afoe+l9FDv8dY7B0jSIcM2XhgUiUQtXZh+KhrZrjLGpFKTAhPC+J5WxlJB6O1
         E+7g==
X-Gm-Message-State: AOJu0Yw+BEfCeMlzIsW9Wjaa15AFsny8o86HLW4+xSKAsvzj1+9A41DT
	FgrDsJpfD1KWq1Qm+CKtVWpy5toK1qkPcmNaibTQOmJ+X2oXt7/31tTBDIZus3UwodnTXNaTuhl
	vkWtalVxG5Kip85zrlWEYufd43xd7xdJ41snTCeQnYsTGwMpDkdxSaQ4IA8wh+bazC/oSNp+P1c
	Q4yrsueV0S9pUOh2TTH5t4lj2lGMKkTgI=
X-Google-Smtp-Source: AGHT+IGueddsxal2939hNo7/TPjZYhCrBcl985PmCzKbFXvauW9HgNNhAeG9APmfm40qlT6512r7nhK46g==
X-Received: from wmin6.prod.google.com ([2002:a7b:cbc6:0:b0:456:1bf2:2be2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3f09:b0:456:1a69:94fd
 with SMTP id 5b1f17b1804b1-458855d3dbemr80179995e9.0.1753790414777; Tue, 29
 Jul 2025 05:00:14 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-1-tabba@google.com>
Subject: [PATCH v1 0/8] KVM: arm64: Reserve pKVM VM handle during initial VM setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

All VMs in pKVM identified by their handle, a unique per-VM ID. This
handle is shared between the host kernel and the hypvervisor, and used
to track the VM across both.

In pKVM, this handle is allocated when the VM is initialized at the
hypervisor, which is on the first vCPU run. However, the host starts
initializing the VM and setting up its data structures earlier. MMU
notifiers for the VMs are also registered before VM identification at
the hypervisor, which rely on the handle to identify the VM [1].

Additionally, in the future, the host needs to communicate with
TrustZone about the before the VM first run. Therefore, move handle
creation to when the VM is first initialized at the host.

This patch series is divided into two parts:

- Patches 1-4: Renaming, refactoring, and tidying up to lay the
  groundwork for moving handle initialization and to fix existing
  issues.
- Patches 5-8: Decouple handle creation from VM initialization at the
  hypervisor and move the handle creation to VM initialization at the
  host.

Based on Linux 6.16.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250303214947.GA30619@willie-the-truck/

Fuad Tabba (8):
  KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
  KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
  KVM: arm64: Clarify comments to distinguish pKVM mode from protected
    VMs
  KVM: arm64: Decouple hyp VM creation state from its handle
  KVM: arm64: Separate allocation and insertion of pKVM VM table entries
  KVM: arm64: Consolidate pKVM hypervisor VM initialization logic
  KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and
    initialization
  KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()

 arch/arm64/include/asm/kvm_asm.h       |   2 +
 arch/arm64/include/asm/kvm_host.h      |   5 +-
 arch/arm64/include/asm/kvm_pkvm.h      |   1 +
 arch/arm64/kvm/arm.c                   |  12 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  14 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 177 +++++++++++++++++++------
 arch/arm64/kvm/pkvm.c                  |  76 +++++++----
 8 files changed, 217 insertions(+), 74 deletions(-)


base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.50.1.487.gc89ff58d15-goog

