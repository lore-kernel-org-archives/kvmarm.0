Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991F0322774
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756289994; cv=none; b=LFyYQvOPaiuPyOaew3zLzYxxHxR+7+Lyy57KjTIryn+jSsGElnw5BQ0q57chSRZMCvpFgS55bIVgHWmBktePGa9byx+6IabKyKbe2Cinn5lnTthuZzzh6LCLbooCczm61JFil2Tzq28T/0fBxykkzH7wETRIfgSmtoi5OtS2eMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756289994; c=relaxed/simple;
	bh=b1Dk9Oq2CgizABENaWDpDpAnxzoMzkNEA03wDQzrIsE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D6OpUZ5ev8FC3U85OOlkXhMbOEj6bmYCVHTXQN9k/M0Hc+INI7oCcReOrBODG50i7/g842CNz41QaFlgD+CIGPU1YzwvXVfYJJ2RHK4tvAqWj+8dXFuROvyKX7/Bi4X4xg/agrbHLwMq1Xm7+i+cE+BzvJFA8nV4xyvvPnlyOv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KqfDqdLM; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KqfDqdLM"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso46476935e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289991; x=1756894791; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aY/HOY3esc7iLj6djBy7POlcraK1TTeiecvmcTtxq88=;
        b=KqfDqdLM3OCEN03zMvKRBE731TFkNt0vXgBH1ZurzFG/3VUYLXSqCRYXiSzKyiMb/m
         ToHluOrv9NOm+fgpUfF1fYpFgMuMVPU62JVQtDu/ZZVQwnBL6aNVtHVYpPpdhZd6TqTs
         izKlxRGbeDM+GCOCRu7jkETMOC+Yo1u2lVEEBcqispavtlIZ78HtOUDoAM0cL5z/SDz7
         VjW3A72KTVC3RRhktZSfLl7HXJpIy50MWfCcazeg6uX8819GtD5I3fYEu7KbEOZT96Zx
         AGx9g2snOy4SCf7xDYN2H3NIrK/jiG09/kJ2z5Y50OvjguoDQrceJaoxJxb+lkReLv4a
         5fDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289991; x=1756894791;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aY/HOY3esc7iLj6djBy7POlcraK1TTeiecvmcTtxq88=;
        b=QZaNYk6jgZriY2elBATi7JTxKM6ThDGEJ0hJxvc8SSmWJYECykUJ88uSWqEeFk6ckZ
         vKwr4+ynf8rpw4pCL75hzsx7H6ZXY1hzbboJZ7Q1U9VQJqKSx5r5i4chA1EjFDw07+9W
         JOJjkmD22uYHmi4hLfYJ6t2zr9QSgLMBVXD6T5pQgDg+5JsqmsO2A1ze+cY692ZJJfE6
         veSw8vIB4rjNwCjyDq7RL/JIvejA/6u9lthC2a1MUENfdTyMxGf9+TWw/1NXXMjnISzb
         ARIlUNdgy72DD4JvhP+ilqEo2EOB08NnpF1XPPR0DhwvzLZVIcywt4HQtD6bjFArNxkC
         JUBg==
X-Gm-Message-State: AOJu0YzSyh2a7qic2o5mI6EeozQ0WAa73jUAqhQOU3w+mkCXp70pialK
	nBC0hfq5/kG3PDbNliy69ZZbZvtRw9Mq54YTDEnrAr3lN7QHsAwNSAM0J9isagLtzirN/vv7YEk
	XksOEzqFZD2N4yxRkwm2ZKn2aDc/elVxUSG9qKx+kwn56PZExAR5MzldacKYb0fOq3PwsvcW1uG
	gjrYtyswEIsv70Shx48Pmvr+9xDJJPakQ=
X-Google-Smtp-Source: AGHT+IGVx8dVPxAEwHkMwTbEjRKkAi25ytMaI23qr+UCUfvHQCf/8gvOt0+gLqsmTrkGgu27mc6kH+cznw==
X-Received: from wmbay25.prod.google.com ([2002:a05:600c:1e19:b0:45b:66d9:7573])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f41:b0:459:d3ce:2cbd
 with SMTP id 5b1f17b1804b1-45b517ad602mr160115725e9.13.1756289990971; Wed, 27
 Aug 2025 03:19:50 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:40 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-1-tabba@google.com>
Subject: [PATCH v3 0/9] KVM: arm64: Reserve pKVM VM handle during initial VM setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes since v2 [1]:
- Added a patch that checks for duplicate DECLARE_REG use
- Rebase on Linux 6.17-rc3

All VMs in pKVM identified by their handle, a unique per-VM ID. This
handle is shared between the host kernel and the hypvervisor, and used
to track the VM across both.

In pKVM, this handle is allocated when the VM is initialized at the
hypervisor, which is on the first vCPU run. However, the host starts
initializing the VM and setting up its data structures earlier. MMU
notifiers for the VMs are also registered before VM initialization at
the hypervisor, and rely on the handle to identify the VM [2].
Therefore, there is a potential gap between when the VM is (partially)
setup at the host, but still without a valid pKVM handle to identify it
when communicating with the hypervisor.

Additionally, in the future, the host needs to communicate with
TrustZone about the before the VM first run. Therefore, move handle
creation to when the VM is first initialized at the host.

This patch series also takes the oportunity to do some refactoring
(mostly renaming and fixing documentation) of the code. We are in the
process of upstreaming pKVM. Refactoring this code now would generate
less churn than postponing it, as the upstreamed codebase grows.
Moreover, the exsiting names and documentation are at best misleading
(and in cases actually wrong), which could lead to more confusion and
problems reviewing code in the future.

This patch series is divided into two parts:

- Patches 1-5: Renaming, refactoring, and tidying up to lay the
  groundwork for moving handle initialization and to fix existing
  issues.
- Patches 6-9: Decouple handle creation from VM initialization at the
  hypervisor and move the handle creation to VM initialization at the
  host.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250811101947.3637632-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250303214947.GA30619@willie-the-truck/

Fuad Tabba (9):
  KVM: arm64: Add build-time check for duplicate DECLARE_REG use
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

 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/include/asm/kvm_host.h             |   5 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   1 +
 arch/arm64/kvm/arm.c                          |  12 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   4 +-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  14 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 177 +++++++++++++-----
 arch/arm64/kvm/pkvm.c                         |  76 +++++---
 9 files changed, 219 insertions(+), 75 deletions(-)


base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.51.0.261.g7ce5a0a67e-goog

