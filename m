Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128E753BA
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:32 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-56942667393so59288857b3.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202312; x=1690807112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vD5sDH9aSpZwfHz3X2XeLkelNTnqnKkM+fkZrOXsQiU=;
        b=SKv/ipbnzr2Wvh6V6qcHXclTTW5eAcPu4V74fTf/XDCM2Xsx0Uq2SY7Ii0l9RwsBQI
         xAS834P/soN13Z5dNQVrQJT8FM4WDzUciTFouhJ52W2NSrXzx2ZdIMRYuzcsNCkR69NH
         RIE2/A4hgErQpqRAexuh1WJYS3vJ1TEppRw0fltp0Ea5gkBK+874RcO+OBFISVZCikg5
         /TnXXUWSqQxtHKBdfRAgSTq59yoKsLwy4MD4FhoAqtrEXjuK83ft7X1pD98ubFTGCxUA
         REJam8ixFhugyliYf26Qv9pepT0TjGM9anWy45UbC9H7dr15S4crmMoQ6R+Qio/19AUK
         bdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202312; x=1690807112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vD5sDH9aSpZwfHz3X2XeLkelNTnqnKkM+fkZrOXsQiU=;
        b=UME5pS1m6nW/gFENlLXr9wtTuLDv65c89LHhlDnmdY7pHtA1VHwpS1ZlOyv/B6oQuR
         tnzcNhBF13a5JEYOk8fc2WwnyXLJYAzqemhAU1xbsQEMk5Su89dKOZA8hk0S3jty/+n8
         T144gwBvm9zsNVd5vLpkwx2q46Ro6TriJ4E0DNajLe4q0ckI1DXQseoE9kufLfIGwa0K
         41Mm39vnXPU3wt6c/BjFP6Vtk8pEEGXb97+10d6xV48pk7lUjKLghSGGQna6EDEXRFbL
         R2YvJZAgJG1U9G+6UFhbzibc/f1hRUj1bHEtlWX5O9u4BMOX7nu4DEqBrbvI3p+m42vQ
         lUMQ==
X-Gm-Message-State: ABy/qLbHlAiP4cOQp5LIqPrer4erw1ypc1g3mnRDKe6VZz8t/4WQS+g1
	PkDrR0p9QODK61TjxHaHPztkIIA0QeHYctM0P9EPoNFYgE5SCBd9Yv9TYQMuMpLiyw0Zb0JqcCq
	5hwv0gH+rGboZ7v+PfKsD1kTaykfX/lb+8oQdNO6l4lcsmQvBspFzWngMWU4=
X-Google-Smtp-Source: APBJJlE+mPlSiK+IVekm7B4tht00QHTF3tE8TsKjDirHu2t+xevI/j8885m+3tgcBo7zWl+t3KI1Fs3SVQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:707:b0:576:f3ee:4e67 with SMTP id
 bs7-20020a05690c070700b00576f3ee4e67mr66125ywb.8.1690202311338; Mon, 24 Jul
 2023 05:38:31 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-1-tabba@google.com>
Subject: [PATCH v3 0/7] Fix setting SVE and SME traps in (h)VHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Changes from V2:
- Rebased onto Linux 6.5-rc3
- s/__check_e2h/__check_hvhe/g (Oliver)
- Fixed bug in calculating CPACR_EL1 reset value for hVHE in
trapping SVE

Changes from V1:
- Expanded the cover letter to clarify the reasoning behind being
consistent in writing to the architectural trap register based on
the KVM mode (Marc)
- Factored out the code for checking E2H into a macro (Oliver)
- Factored out the code that selects which register to write to
into a function (Oliver)

The (re)setting and disabling of SVE/SME trap handling (mostly)
done for the hVHE work [*] misses a couple of cases.

This patch series ensures that these traps are disabled on setup
and reset. Moreover, it makes the code consistent in using
CPACR_EL1 or CPTR_EL2, depending on the mode.

CPACR_EL1 aliases to CPTR_EL2 when HCR_EL2.E2H == 1, but by being
consistent we don't need to issue a synchronisation when
alternating between one or the other accessor. Moreover, when
running hVHE under NV, we don't trap unnecessarily on accessing
CPTR_EL2, while CPACR_EL1 can be used directly without any trap.

Based on Linux 6.5-rc3.

Cheers,
/fuad

Fuad Tabba (7):
  KVM: arm64: Factor out code for checking (h)VHE mode into a macro
  KVM: arm64: Use the appropriate feature trap register for SVE at EL2
    setup
  KVM: arm64: Disable SME traps for (h)VHE at setup
  KVM: arm64: Helper to write to appropriate feature trap register based
    on mode
  KVM: arm64: Use the appropriate feature trap register when activating
    traps
  KVM: arm64: Fix resetting SVE trap values on reset for hVHE
  KVM: arm64: Fix resetting SME trap values on reset for (h)VHE

 arch/arm64/include/asm/el2_setup.h   | 44 ++++++++++++++++++----------
 arch/arm64/include/asm/kvm_emulate.h | 21 ++++++++++---
 arch/arm64/kvm/hyp/nvhe/switch.c     |  2 +-
 3 files changed, 47 insertions(+), 20 deletions(-)


base-commit: 6eaae198076080886b9e7d57f4ae06fa782f90ef
-- 
2.41.0.487.g6d72f3e995-goog

