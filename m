Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05571214812
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907591; cv=none; b=e0hdZ28dw8hqgD64HRign39mOQ/qg+1bOTpzK+72bplYsN95FGt9pDf9TTUyH0SrKLCwwFo62vgA61SH/eQZwz5eM8TAy6XAgKCTn91hEG/grewsy+ejEDEZlNt0j1tqHXTC0eNd9JfwrRmDmVGqNjbTWXIIW4ppYY8hw6QXtzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907591; c=relaxed/simple;
	bh=c89JrwDAHCN1zXHSsnRD+OtZ3Xb5quCSSl2lWosvGWc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WC8KPJC8PlHciyR09SMhHIloe12omkxCQtzkfySHfByQEdcWqbg5gjQLRj/ONQlD6ovgCz371p9BlOcB9FdOC726OOcbhrDZ8mOrR5uimIAVfM7G7/bdad8KvSj5HI1wNoBs8iPfOpmffQ1C32QBRpWPNdgAHlIGQEsTKAJy3xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ps9nEmUK; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ps9nEmUK"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b785aee904so2027464f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907588; x=1755512388; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YFqWTTk05Ml/MIvsxQnEF+TYVUSm4fUy0wHLdAWzEyE=;
        b=Ps9nEmUKJAsQtcIkFbbLR3LYK/XceSK6t4pOOhNLzQMGJqCUsnN6sZ8tSnVQ6CpVo8
         Roi2M/zbqKGFJqghmS/8uqtxD2je30aVOByQd8WIQqAdfVj3b4XgudCa6ahNrPtefjbN
         KsLu9P9fzFNb8LnW9Vk2bAYr12/AZdaU2X8BK/mMqzbzrkA4hdRHrgi79Az7BhKniVPt
         PFa6S5Q2rundMCeYXjci0P3tMEUtvIsaATq9SSJ4WJYraDQp4Qsu1bKxj3z09O4b+wL7
         x01HQV3uyFK2jAgaPo1fvE5zqGgAeeTEIyRFGM0IZ8O1EcRpKU2ZTzGL1aOYiCANJcJ/
         aoPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907588; x=1755512388;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YFqWTTk05Ml/MIvsxQnEF+TYVUSm4fUy0wHLdAWzEyE=;
        b=Wwod69+a4991zlsHga7CCmNOgry+0PeUCHLuY2E3hTnVIxhjGcAllu9jkB9dhkdYKP
         uhj8MKPwNZjcR53uTmkx3oHiaVL9ENAgbH2+Mss0FmXqhpp8K6t2lvjuRwmdaliVD6iw
         D/k+CI1qzJ6Msf+xYx4StG1B9HVkTkObzxKOYTyo0M7eGBt5pT/ZSn2of1TIwCTO4kB5
         1Up0xbADJ5HgfV9FPk6ct+Ikj26KDV+KhMxlOh7z6F3zaESAyE5U2SoupIfiADmPuxRN
         YswJGhNpwOK/PRvu1Sq8JhcUMoneY4heEMKFKgJgngRo4mPrRJ5ff9ALRIpMBYhA4nv2
         86Fg==
X-Gm-Message-State: AOJu0Yy7Im0ppsbXKYpHiBckckwQJsaGlQKbf0b1gXVMrrZj2gbbA1wU
	jWa4xdXSFZNen30sBDUdGLPR6Jnn8RCix9bIuN67eWi/6rYJ/fckvPGQZOm7NsSXc3E5MPJDNjJ
	RBU7z/p1bWzqsLJTWnO/zNfQI4mAgveEOF7cV3kKCeQJoqANwh9srrfCAli5vK7dZzVRvw0Jeys
	F1/HQtmT3d3A8yDzE75klVfz8xs91K0L8=
X-Google-Smtp-Source: AGHT+IFwgUj6ZZlPnitf5n78PJ6BTTwk8mKt9u1l8JS3PzuP9YtYupCNYGag/GowQHUizsrvpKq/MUeIcw==
X-Received: from wmqe20.prod.google.com ([2002:a05:600c:4e54:b0:459:e13a:ffe8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d88:0:b0:3a6:d95e:f38c
 with SMTP id ffacd0b85a97d-3b900b4d414mr10490118f8f.33.1754907588356; Mon, 11
 Aug 2025 03:19:48 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-1-tabba@google.com>
Subject: [PATCH v2 0/8] KVM: arm64: Reserve pKVM VM handle during initial VM setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes since v1 [1]:
- Collect reviews.
- Add more details to cover letter.
- Rebase on Linux 6.17-rc1.

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

- Patches 1-4: Renaming, refactoring, and tidying up to lay the
  groundwork for moving handle initialization and to fix existing
  issues.
- Patches 5-8: Decouple handle creation from VM initialization at the
  hypervisor and move the handle creation to VM initialization at the
  host.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250729120014.2799359-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250303214947.GA30619@willie-the-truck/

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


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.50.1.703.g449372360f-goog

