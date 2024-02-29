Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947D51D6BD
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 02:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175489; cv=none; b=emYSHWRqt3d1CoQbDbs8Thd9VTtEEfgNoLG3P5vvoJ84j70Y/sPOWwU7i3y53QoVQ3H3Wkko40gnHrbcAXE+Abg3pnT2jsxuGEVwViO7OrXvF8rOiT7pJQAkL+iiiyUNAKE3qMrr833Ia6Nt1VmjibxQRt+NLpkqgDAhf0y3b1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175489; c=relaxed/simple;
	bh=vTo43K8wKC81JH1cmE6G3o/ZjBDx+QgMlTVTqwHGI38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T7hTYaxxM9Jhu3fhlTpIqNB6jd6HRnQRhXswyafbn26jw5kwTpIlGoXi2ckKalRq8sfkHQ2uTyx0ME3RnkUNGfxetKA0AcuYmwGR5L9Rg82KHFX3/jOJNUMdftJ1E7UIrjqN4F3Rs+W1pP7AV+0Yzl886n+w+hHsk+Ct3iwKFeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=eIE/rVUF; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eIE/rVUF"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dca160163dso4776725ad.3
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 18:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175487; x=1709780287; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GYrIjEX8sBb4dT+FuvYa3Se1T3Bf/IWCGgkiK7PdSp0=;
        b=eIE/rVUFb0SD/U0LSdChz7X2bpMpJjDb2MLWiBLjOpxZqBxK7pq0hUpskO9Hx14/He
         G/TS97p9oDKhEAv/0rZ6sQYZcsjrY4jyjN7rOxVE1N3mcnU1fPixnfOrWCO58U1ng69G
         DRxDx3ql0t9IEQM3d9PZlnj/MtX0NRDEna18Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175487; x=1709780287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GYrIjEX8sBb4dT+FuvYa3Se1T3Bf/IWCGgkiK7PdSp0=;
        b=FtzNKHQP1wIr6dA857tkLK3x/rPBAKbEaduIgcsQROnRPW7Yd6PRPkANB/Edd6IBqr
         E7AvEYGd9PxvJDCKUNpkWJgbaTPlwjH9D39fRQx/znZwjBpC7O1J/XwRin9uWHCwFaiA
         8pkVulE+xF/Flq+skTPhWFOjkItJWoX4IRz30weVAYutWXFYISaA4OFKn7++b10UEwm3
         7aYPBCmUu+vsso4NPZO6fynm3xWBwv9uK6FmwzW8wApmZl96lSl1x6eUGVtoWhdFy5U1
         sUw1ualUTpQUZgdtC+XwEpMs9/dwy/vjgvLe5m4vlKEwQttwD5P97U55tYmZ4tQCniaI
         BI8g==
X-Forwarded-Encrypted: i=1; AJvYcCWqCEMzAeabebFgzunwswbkA/BwavvfWd5qWrcRl14njVlStSnOfKTbrE22+GyWuJesx9SWwZBK8zIoEPcYYArX1294sC8A
X-Gm-Message-State: AOJu0Ywy6DM36yKgJRSvMgtNukgFtg+T8CQGDvsZvRYowQzE0b6KipqD
	SOo1fjJHvUWg/0p7rqtPGtBvLZasoaXYuLstnsK1vOtrpNONYzq54NNkoRKuvA==
X-Google-Smtp-Source: AGHT+IGX2J1qRGPAk8Cl6s48psnsoyoG+In7Glf3fzZVHLi4UU8vhZ5C51T0Oye4gDcJQGTRUdVsaQ==
X-Received: by 2002:a17:902:6b41:b0:1db:ccd0:e77e with SMTP id g1-20020a1709026b4100b001dbccd0e77emr849550plt.35.1709175486838;
        Wed, 28 Feb 2024 18:58:06 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id i6-20020a170902eb4600b001dc38eaa7fdsm174087pli.278.2024.02.28.18.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:06 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Date: Thu, 29 Feb 2024 11:57:51 +0900
Message-ID: <20240229025759.1187910-1-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

This patch series adds support for mapping VM_IO and VM_PFNMAP memory
that is backed by struct pages that aren't currently being refcounted
(e.g. tail pages of non-compound higher order allocations) into the
guest.

Our use case is virtio-gpu blob resources [1], which directly map host
graphics buffers into the guest as "vram" for the virtio-gpu device.
This feature currently does not work on systems using the amdgpu driver,
as that driver allocates non-compound higher order pages via
ttm_pool_alloc_page().

First, this series replaces the gfn_to_pfn_memslot() API with a more
extensible kvm_follow_pfn() API. The updated API rearranges
gfn_to_pfn_memslot()'s args into a struct and where possible packs the
bool arguments into a FOLL_ flags argument. The refactoring changes do
not change any behavior.

From there, this series extends the kvm_follow_pfn() API so that
non-refconuted pages can be safely handled. This invloves adding an
input parameter to indicate whether the caller can safely use
non-refcounted pfns and an output parameter to tell the caller whether
or not the returned page is refcounted. This change includes a breaking
change, by disallowing non-refcounted pfn mappings by default, as such
mappings are unsafe. To allow such systems to continue to function, an
opt-in module parameter is added to allow the unsafe behavior.

This series only adds support for non-refcounted pages to x86. Other
MMUs can likely be updated without too much difficulty, but it is not
needed at this point. Updating other parts of KVM (e.g. pfncache) is not
straightforward [2].

[1]
https://patchwork.kernel.org/project/dri-devel/cover/20200814024000.2485-1-gurchetansingh@chromium.org/
[2] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/

v10 -> v11:
 - Switch to u64 __read_mostly shadow_refcounted_mask.
 - Update comments about allow_non_refcounted_struct_page.
v9 -> v10:
 - Re-add FOLL_GET changes.
 - Split x86/mmu spte+non-refcount-page patch into two patches.
 - Rename 'foll' variables to 'kfp'.
 - Properly gate usage of refcount spte bit when it's not available.
 - Replace kfm_follow_pfn's is_refcounted_page output parameter with
   a struct page *refcounted_page pointing to the page in question.
 - Add patch downgrading BUG_ON to WARN_ON_ONCE.
v8 -> v9:
 - Make paying attention to is_refcounted_page mandatory. This means
   that FOLL_GET is no longer necessary. For compatibility with
   un-migrated callers, add a temporary parameter to sidestep
   ref-counting issues.
 - Add allow_unsafe_mappings, which is a breaking change.
 - Migrate kvm_vcpu_map and other callsites used by x86 to the new API.
 - Drop arm and ppc changes.
v7 -> v8:
 - Set access bits before releasing mmu_lock.
 - Pass FOLL_GET on 32-bit x86 or !tdp_enabled.
 - Refactor FOLL_GET handling, add kvm_follow_refcounted_pfn helper.
 - Set refcounted bit on >4k pages.
 - Add comments and apply formatting suggestions.
 - rebase on kvm next branch.
v6 -> v7:
 - Replace __gfn_to_pfn_memslot with a more flexible __kvm_faultin_pfn,
   and extend that API to support non-refcounted pages (complete
   rewrite).

David Stevens (7):
  KVM: Relax BUG_ON argument validation
  KVM: mmu: Introduce kvm_follow_pfn()
  KVM: mmu: Improve handling of non-refcounted pfns
  KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
  KVM: x86: Migrate to kvm_follow_pfn()
  KVM: x86/mmu: Track if sptes refer to refcounted pages
  KVM: x86/mmu: Handle non-refcounted pages

Sean Christopherson (1):
  KVM: Assert that a page's refcount is elevated when marking
    accessed/dirty

 arch/x86/kvm/mmu/mmu.c          | 108 +++++++---
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 arch/x86/kvm/mmu/paging_tmpl.h  |   7 +-
 arch/x86/kvm/mmu/spte.c         |   5 +-
 arch/x86/kvm/mmu/spte.h         |  16 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  22 +-
 arch/x86/kvm/x86.c              |  11 +-
 include/linux/kvm_host.h        |  58 +++++-
 virt/kvm/guest_memfd.c          |   8 +-
 virt/kvm/kvm_main.c             | 345 +++++++++++++++++++-------------
 virt/kvm/kvm_mm.h               |   3 +-
 virt/kvm/pfncache.c             |  11 +-
 12 files changed, 399 insertions(+), 197 deletions(-)


base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
-- 
2.44.0.rc1.240.g4c46232300-goog

