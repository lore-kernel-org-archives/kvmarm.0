Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567A819CC28
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099979; cv=none; b=hiySDo6/mABjUZSKxMVPfO8Gf0UBKhmimtg3PKKCGqZy1AB5Ezl4NZpMyd4dQnTfuvY0Lv/V9qsmvojWfaOqWBuTd8hONEKqD8MEKqXB1xo87GKgaOPQGUBzgNwoyyw7OPYEHwqLtVrx5KLLdPE045MTZhX8aSf+dxnOaPJo9m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099979; c=relaxed/simple;
	bh=91JnzzaWXayBJ4rNdW7zxVXM8B6OCFg+HxtYERfaeZs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kUTP/7MQO768mPFbWYHHlnoK0+oQnoaU7KZ8OqgFKHz6MPTyH7RswaR5QvBdoJxQ80Jag9yMLyuna53RiGt/C2Wy/l86vgyprigir4/FgLlV/pdDg+rq4vZA2DlB3sDjssJzmXlcb5CBB0mHRRB5F05q1APcP/6py7jeJ5K/bkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=swyHIW5j; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="swyHIW5j"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e35e9d36da3so3496727276.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732099977; x=1732704777; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FHhbZGchrrZYNelaupOfg6fP9x+BokooGfDZlzPZG5g=;
        b=swyHIW5jt9i1mnBUVpXLCTqe4laGnU+ROSqdTNsYE4etNiyc4EfT2JAzBPAzK5C4s6
         aT/8PnLckLZ3fKPhsbjhwBHyD4NSVzu26teK2MD1uRAlPGPHFYSHTRQDbLnQ1E07CRGV
         FmCAOabMq+CQp3vntq4Tr/WKueCtYfbO9ybL0JFPvjH1SUcuGlt1whNpnPlxy0Ty2vv/
         IQH/AeD94HJLdp+QWv91W6POZRAWJfxaRY+TaUhEQQ1a9pc4TSCiX570Ffo1+WsuV5L/
         l7ixm/CS+U5ptyXGjnteVQCsOFSUqyWpngv5kFINpB57S61nOxUIzbh74evbDeclFSor
         pcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099977; x=1732704777;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FHhbZGchrrZYNelaupOfg6fP9x+BokooGfDZlzPZG5g=;
        b=u9sqZc4y7o4abkczywDn+MCHpZzy9r7cfoakk5xZz1qUgJ2Bcdqn6+QoRBK7nDkVPH
         NQI4WG1BPuj7LnBkYN8oLduKBVVpypHTD8uvDlDqwmgX0hokuPYcQSBUphuFWBnbAT0D
         1EmUjg1G0hkiWL8GFnmLHYzqK+6tIoKEAjYtXXW4NiRafVt5L3xtdpBHt7hUL5V/Yu8w
         blBr1wNHQVqrYCSejJyz8NvG1jJSc6OzOb7HeN+RpQdBknq14b6UstQZxcZMzkQE1qRJ
         1Fvjtnl3a1Or2X79z9BORw6rvGh5qS1Llic9mJ/zmhKLs7zjYj9v9p8GBOT3YxRueQlu
         LGwA==
X-Gm-Message-State: AOJu0YxeNqFCqR9VMeuiOKTFHM8G/cwqxwURWcjsWLQwL8MjwTRcx/hA
	T5ni04lX7vgJS88sqtAUJeBSBl+/T/zwsLSliVRQDLAi9WkYMzGrg9+mCrNlnKZw/9ROwOInUyv
	9EeBIbckPcUOabjw4Of5XS0fBU5zYOOhGEMdWFbxfjAPCdSGqsWsm38IlrJLanu4pHI3o8Ar6TZ
	rycAeatmnsD7zzEzUlZO7OKjg9pis=
X-Google-Smtp-Source: AGHT+IEHB1YOXijgGLZrRIlmTdc5FO6mh9kPr95x/aAbfNOvWt1pqsH9KS2Zz85273eXR5AYVlwVSiRaew==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:360f:0:b0:e38:10a7:808e with SMTP id
 3f1490d57ef6-e38cb3de86fmr9039276.0.1732099977073; Wed, 20 Nov 2024 02:52:57
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-1-tabba@google.com>
Subject: [PATCH v1 00/12] KVM: arm64: Rework guest VM fixed feature handling
 and trapping in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

This patch series redoes how fixed features for protected guests
are specified in pKVM, as well as how trapping is handled based
on the features available for the VM. It also fixes a couple of
existing bugs in the process.

For protected VMs, some features should be trapped if the guest
tries to use them because they are not supported (e.g., SME), or
if they are not enabled for the particular VM (e.g., SVE).

Initially, pKVM took the approach of specifying these features
using macros and grouping their handling by feature id register.
This proved to be difficult to maintain and bug prone. Moreover,
since the nested virt work there is a framework in KVM for
storing feature id register values per vm, as well as how to
handle traps based on these values.

This patch series uses the vm's feature id registers to track the
supported features, a framework similar to nested virt to set the
trap values, and removes the need to store cptr_el2 per vcpu in
favor of setting its value when traps are activated, as VHE mode
does.

The changes should not affect the behavior of non-protected VMs
nor the behavior of VMs outside of protected mode in general.

This patch series is based on kvmarm/next (60ad25e14ab5), since
it requires the patches from the series that fixes initialization
of trap register values in pKVM [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20241018074833.2563674-1-tabba@google.com/

Fuad Tabba (12):
  KVM: arm64: Consolidate allowed and restricted VM feature checks
  KVM: arm64: Group setting traps for protected VMs by control register
  KVM: arm64: Move checking protected vcpu features to a separate
    function
  KVM: arm64: Use KVM extension checks for allowed protected VM
    capabilities
  KVM: arm64: Initialize feature id registers for protected VMs
  KVM: arm64: Set protected VM traps based on its view of feature
    registers
  KVM: arm64: Rework specifying restricted features for protected VMs
  KVM: arm64: Remove fixed_config.h header
  KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
  KVM: arm64: Calculate cptr_el2 traps on activating traps
  KVM: arm64: Update vcpu state with live value of VBAR_EL1 on injecting
    an exception
  fixup! KVM: arm64: Initialize feature id registers for protected VMs

 arch/arm64/include/asm/kvm_host.h             |   1 -
 arch/arm64/include/asm/kvm_pkvm.h             |  25 ++
 arch/arm64/kvm/arm.c                          |  30 +-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 ----------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   5 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 313 +++++--------
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |  31 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 414 ++++++++++--------
 9 files changed, 403 insertions(+), 640 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h


base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df
-- 
2.47.0.338.g60cca15819-goog

