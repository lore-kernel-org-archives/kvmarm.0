Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10241DDC2B
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273588; cv=none; b=Ov3mCWMePvEfxQBX0G8edbXwqicj3w+NR/GH4eru0AvsvqZra8vkoybejpax4F/eQhnL5traHw7losTqWPQJtePjO+LH96IwqLbPImVgsDQ0KxAi79vY9Ij1FxAIo0tm/tBjERWykQRumjU5bGwm/TftlTwSiJ6sMfok7a4YvfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273588; c=relaxed/simple;
	bh=EDb3ozP5mLl1KljEq2fcb4u5+KOwLXrTdgksvEtxX5I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rfx9YvOylNk3OK9RDBjyqmawmM93Td+U6ze0W6xl4U5mpWP3FOZoh5e3mjNR+a4hvfrIgi8671CnmZTvXsVFeThoR8DGld4Iek6C2Ec6v+1K7WKsbrqQwRWzAY4aICBA4IGDueV3aE9CiinPuR6Hjl2SG4p/iO95GUJhJIBPg5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OtMgoV4T; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OtMgoV4T"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-431518e6d8fso15027185e9.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732273585; x=1732878385; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W+gFQJsTATeSfAv/m9GGHSpYyzh9z7yQrFoDhSG221w=;
        b=OtMgoV4TDFKOuz7Yj746GI6mpXjHEKVzHlTr943SijPPzLAw7lphZTO8ItaNFcAXG7
         kFRsfO0PXG0qdFtT87/TmIUbADN3B5LjOw65gRPIL4hrJSokrsBqL0IuhvwjpsqtjrbG
         4F89wlp80Pwz4yAl/JIDBUtBcvLllY72WkkCVJJ7Wa9kmsxZC0VOO6yModzKPKGXg0Hm
         BHx1wG7HKoPFhL3yCPn15KsFa7f5gSFJroGUX60SIIwUPBqbfnnEBsrW9gL4o2p31ZXv
         OshtDOtuFmj6rcPWwP/E1EvuLdS6Y7Er0T07bkeEP+yBELe0z1++QB6sD7z4+rvn8Vh7
         b/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732273585; x=1732878385;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W+gFQJsTATeSfAv/m9GGHSpYyzh9z7yQrFoDhSG221w=;
        b=CGpxVoA5FX5snSk6d72CX8S1bkJlqNlAtLWDPigjfJTELM9b06l7HfMeyhJTb1BbZX
         FHD2nPDmGhjfOrrerkBNJeCDft6k6Jmgh/zpcDmXRCZD11AvWJOJsU++yIFXSTjlajkK
         oTcazS7qlQm1nBE+bSQyJCfgJ9wf6VzMUIN8Mwoa2Vm/kEMVLp8RklD+++Q7y4r5ym9Q
         9MCwt2Sa0oQXCaMUYh/BgdpysHhnPko6d4f4R2icdm2PSjsjO+myM7kWDSjzvlJgkHQ9
         BWG8wA0wbM2gnGh48tn59phKsWjamDKtQ9D9RCwJRAzUx8/mwQBPIbhVmw+D931nUtqX
         ldBQ==
X-Gm-Message-State: AOJu0Yyz+oKnqetl9z9flXh/uuynkalKlkiS9OHGeXpXc4Rw/98Dabkj
	TOjmfv2c7eLtxRpP2vE9CEh7m0UWd9vjNlrFZJBvBcZrzYu7DMXdU7qEDv7r5TYHDoUiHqNA3Dx
	FXRk9w6T4DtX4lhkwc6vHqixkET9uSwy7wA2zv3I+nUPf7RvMh6axKbVkGQdRfUg6BFrSVDdTt0
	xrIuOBkoywplzEkySr2EhAAw9MtVw=
X-Google-Smtp-Source: AGHT+IG0t9w7kmbT8JNuZIEiuFugQ6HVGw6Cw0at25JfbkCNdt1E0H7W8wgVmXSbM0PTmKhnBEX/LThHng==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4082:0:b0:37d:5299:c401 with SMTP id
 ffacd0b85a97d-38260bc7d21mr646f8f.7.1732273584571; Fri, 22 Nov 2024 03:06:24
 -0800 (PST)
Date: Fri, 22 Nov 2024 11:06:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241122110622.3010118-1-tabba@google.com>
Subject: [PATCH v2 00/12] KVM: arm64: Rework guest VM fixed feature handling
 and trapping in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v1 [1]:
- Calculating cptr_el2 is not based on
kvm_get_reset_cptr_el2()(), since that complicates things.
- Added two patches that refactor cptr_el2 related code.
- Dropped unintentionally included patch.

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
storing feature id register values per VM, as well as how to
handle traps based on these values.

This patch series uses the VM's feature id registers to track the
supported features, a framework similar to nested virt to set the
trap values, and removes the need to store cptr_el2 per vcpu in
favor of setting its value when traps are activated, as VHE mode
does.

The changes should not affect the behavior of non-protected VMs
nor the behavior of VMs outside of protected mode in general.

This patch series is based on kvmarm/next (60ad25e14ab5), since
it requires the patches from the series that fixes initialization
of trap register values in pKVM [2].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20241120105254.2842020-1-tabba@google.com/
[2] https://lore.kernel.org/all/20241018074833.2563674-1-tabba@google.com/

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
  KVM: arm64: Refactor kvm_reset_cptr_el2()
  KVM: arm64: Fix the value of the CPTR_EL2 RES1 bitmask for nVHE

 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/kvm_emulate.h          |  14 +-
 arch/arm64/include/asm/kvm_host.h             |   1 -
 arch/arm64/include/asm/kvm_pkvm.h             |  25 ++
 arch/arm64/kvm/arm.c                          |  30 +-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 ----------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   5 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 313 +++++--------
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |  52 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 413 ++++++++++--------
 11 files changed, 415 insertions(+), 664 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h


base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df
-- 
2.47.0.371.ga323438b13-goog

