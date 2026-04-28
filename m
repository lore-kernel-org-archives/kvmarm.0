Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E443ECBFB
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372212; cv=none; b=Z2Q6kCTUcbYFxSC8LL/wmH5ayzWeUxyuOUwjuMRxw4CSjkhC3wKt9YOOFYfSaJaAWiQzShXU0+vUWMedhOvM81r1LV/h98YLfpw+OmkRpww88fA36G5NF/qgSl7xspOPuY5ki7/lZYKHpILs4sgEh5/SyT17afC+kUWEyBptngU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372212; c=relaxed/simple;
	bh=Q1SQtMHy3aqsHkz2pqwBb00QPVJHhdgc6QUsbv3XMuk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hT3heevC75DUdIY2c7CQcRH0954DkqYpvX6Fqof8WeWykgVuX/Vx5D8o1DgoZYb7h3YlTow6yApbLmAHoNTKAXuwJ67IslyIeh7JqYpj4TE+ImdkOji1dbDVIGIaM9fZvIF/OLSKOYVzDsc6eH7ZlCAnlS9Xm9sayUNLCTL1ZaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KSzXv4tI; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KSzXv4tI"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso101742065e9.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372209; x=1777977009; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ybPE6uBPAKDLSIVRQh3Dd/khXkWqQgT9nsbAgFbes8s=;
        b=KSzXv4tITwgJY81SxGZ0mVrUqnt4nMnV5y3YSqpJ2G4dU8nD31QCOqY41p2se9laFa
         pBJRpBrlsnsHoHSXQUwxc6h3Bo+/5PjkC24XCH1RaOMZ7RhR+e/B2afq4PmuFzuq21dt
         SG/RoKQLGw8sEHtVM3bcpE9P8i38iPhNpXHWK7nefM3YNVApeqo1PF9lwSQbWlxB1pQx
         zbEzN5WNyGjXKNy+tngIw9GxoJA51xFY2kJ0fQzouxHlPOnJPUHkusbcRESriodo25a/
         zhFfSxpxAJRMu2jLV6b4+nnq1INo6fa+Nkt9FBBXyqtAGSLTI1g8Ce68OuT6L9zjTbl8
         ZivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372209; x=1777977009;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ybPE6uBPAKDLSIVRQh3Dd/khXkWqQgT9nsbAgFbes8s=;
        b=M8fUF/pL9dLlY1lTN4zDwsz8UG2jXXccCJq3v/0Hs5G3DpjRh+CcEfvPbxSkDzgpUm
         s1ILHi5DvaGZYc+nCC/vAlm5v74GaevzLJeczsX2S+9pIqKZ32L1MhjU1EHuKu6ou718
         PDMvdPOvNI4bn3NofE0BZnB95KwcQqlS3TAdAJLYEfCBHSnL60WI9feotiLFHZScMMpQ
         AvfCUrEXOffs3JeFtAOvq28qM2s2w2HSj658ZQzc9SXUr/ArKR6UlK/Givvt6b3l61H9
         8dMPluQ0HUdsDfkDRkrluAHTqDh5llaR4Bn+H7uLNW33tvSUEXr3Gtz8ILG2qLqVMBH5
         G41g==
X-Forwarded-Encrypted: i=1; AFNElJ9MvZJX0ROwDAylTVkpQeOi4M0CVD/xDC3xo29VwTXN37SdKGGoHtwTAPnJYPxm6vaq62XT6CM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8S5HgPD1dvV1ZgYxe0ul7OsF8iUIEuj8NyohEebpjSrvho7tH
	qA0Kl/fIcIQIxAyZYmq5Z1nNPblRU2ceh5+KGHDrtUzOl4HBu4V7VWr35mcmhSgmkDsqgeWHUj/
	lRw==
X-Received: from wmby10.prod.google.com ([2002:a05:600c:c04a:b0:486:fca5:7a8d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a013:b0:48a:563c:c8e0
 with SMTP id 5b1f17b1804b1-48a77ad5a89mr41979925e9.1.1777372209349; Tue, 28
 Apr 2026 03:30:09 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-1-tabba@google.com>
Subject: [PATCH 0/8] KVM: arm64: EL2 synchronisation and pKVM stage-2 error
 propagation fixes
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi folks,

This is yet another series of fixes I'd like to land before posting a
follow-up to Will's pKVM infrastructure series [1].

I found these while developing KVM and arm64 system guides for
review-prompts [2], an open-source set of AI-assisted review prompts
used by sashiko [3]. While writing the guides I tried to find cases
that would be easy to miss or trip up an LLM, and stumbled on these
bugs. A local run with the updated guides flagged all of them
correctly (some of the commit messages incorporate feedback from that
run, e.g., the impact of WARN_ON() in hyp). I plan to upstream the
guides once they are complete.

The patches fall into three groups:

EL2 context-synchronisation (patches 1-2):

  Patch 1 sets SCTLR_EL2.EIS and SCTLR_EL2.EOS in
  INIT_SCTLR_EL2_MMU_ON. On FEAT_ExS hardware these bits are
  UNKNOWN at reset; without them EL2 exception entry and exit are
  not architecturally guaranteed to be Context Synchronisation
  Events. KVM/arm64 hot paths rely on that guarantee implicitly to
  elide explicit ISBs after MSRs to context-switching sysregs.

  Patch 2 adds an explicit ISB after write_sysreg_hcr() on the
  __deactivate_traps() path. The activate path is covered by the
  ERET that follows (a CSE, guaranteed by patch 1); on the
  deactivate path, subsequent EL2 sysreg accesses run before any
  natural CSE.

Minor fixes (patches 3-4):

  Patch 3 fixes a parameter-name typo in __deactivate_fgt() that
  causes it to silently capture a variable from the enclosing scope
  rather than use its declared parameter.

  Patch 4 guards the VHE hyp panic path against a NULL vcpu pointer;
  the nVHE counterpart already has this guard.

pKVM stage-2 error propagation (patches 5-8):

  At EL2 in nVHE/pKVM, WARN_ON() is not warn-and-continue: it
  expands to a BRK that enters the invalid-host-el2 vector and
  branches to hyp_panic(), which is __noreturn.

  Four pKVM memory-transition functions wrapped the return value of
  kvm_pgtable_stage2_map() in WARN_ON() and discarded it. For the
  share and donation paths the map can fail via -ENOMEM when the
  vcpu memcache is exhausted, converting a recoverable hypercall
  error into a fatal hyp panic. The four patches capture and
  propagate the return value, with appropriate stage-2 unmap and
  host-side rollback for the reachable failure cases.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260105154939.11041-1-will@kernel.org/
[2] https://github.com/masoncl/review-prompts
[3] https://sashiko.dev/

Fuad Tabba (8):
  KVM: arm64: Make EL2 exception entry and exit context-synchronization
    events
  KVM: arm64: Synchronise HCR_EL2 writes on the guest exit path
  KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
  KVM: arm64: Fix __deactivate_fgt macro parameter typo
  KVM: arm64: Propagate stage-2 map failure on host->guest share
  KVM: arm64: Propagate stage-2 map failure on host->guest donation
  KVM: arm64: Propagate stage-2 map failure on guest->host share
  KVM: arm64: Propagate stage-2 map failure on guest->host unshare

 arch/arm64/include/asm/sysreg.h         |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 99 +++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/switch.c        | 11 +++
 arch/arm64/kvm/hyp/vhe/switch.c         | 14 +++-
 5 files changed, 111 insertions(+), 17 deletions(-)

-- 
2.54.0.545.g6539524ca2-goog

