Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CE8C49EA5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 08:12:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CBFA600D1
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 08:12:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CBFA600D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D694E4B1B9;
	Thu, 24 Jun 2021 04:12:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id briZT-4HB83O; Thu, 24 Jun 2021 04:12:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A56E4B1CF;
	Thu, 24 Jun 2021 04:12:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5B84B127
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 23:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T7OxRr-PLeb2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Jun 2021 23:59:18 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3EA94B0E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 23:59:18 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id k6so4024318pfk.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 20:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=BxIaFDPbAuZHR6J/S83W0A67K8R9coNY4bId9HsipsE=;
 b=RBtU16Scd9URJKreXZFwanEfHJ1XRZJXhO4qEt4uU8YvBtSRsG8M0Msq7z7U3gBGbw
 UdDX7s8F5odJ8nqB9b8EVGbHLmPHB74/ZvZg8RK4YeZb6UMq7MIYumlvjDcfnL6WHIaV
 l3qHnUTf57CgLtDUOfr/2EStz1LFXjnziJK6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=BxIaFDPbAuZHR6J/S83W0A67K8R9coNY4bId9HsipsE=;
 b=jBKT/d/ovlNJZkJd0KInFTUYdOtn8pnhNz6uf63kbJIOfeQr7cbVojKg9BRhoWM8GF
 V91Q7ejbNpvnTtAYUdaNekUWE2vEfTqMQHKLB9G35XPOWFEg0jUG/KkCBDc5uCzQqn75
 pbgGNSwG4AKvA2lvFiDAoawqU8vAX+kQ35//FyHewYgeaNehuJ2fqTi5RQ8h3L14BO0u
 7Q+ez1sEa7ElEp61RM6ofzhSo6v1VS6MibSFeDXafoLKioFyhUmxqZQBXU7jPxX4rgPK
 oKFERP8/1hUFtuRdbezkwK8mTGiY2kvtlsliaYGPQjI7BxzJM0oi3AjkH6TkAYz132rm
 vHaQ==
X-Gm-Message-State: AOAM530iWkU+wGTp9sUAQK6bNEKBAG/A9o7GuyQgs0HJMcZIpRXXUC2/
 mgHenDDTGuN46MDvDB458Dgnfg==
X-Google-Smtp-Source: ABdhPJw/0bUD4wxiHYbbe+W1J6aaPXVUUYjx3vGkULT22ezX3dEs1tG4sWixYLws/tdmOS++kmqsRg==
X-Received: by 2002:aa7:96fc:0:b029:2e9:e827:928f with SMTP id
 i28-20020aa796fc0000b02902e9e827928fmr2818805pfq.49.1624507157546; 
 Wed, 23 Jun 2021 20:59:17 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:5038:6344:7f10:3690])
 by smtp.gmail.com with UTF8SMTPSA id j15sm1163260pfh.194.2021.06.23.20.59.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 23 Jun 2021 20:59:16 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>
Subject: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
Date: Thu, 24 Jun 2021 12:57:43 +0900
Message-Id: <20210624035749.4054934-1-stevensd@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 24 Jun 2021 04:12:35 -0400
Cc: David Stevens <stevensd@google.com>, intel-gvt-dev@lists.freedesktop.org,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
follow_pte in gfn_to_pfn. However, the resolved pfns may not have
assoicated struct pages, so they should not be passed to pfn_to_page.
This series removes such calls from the x86 and arm64 secondary MMU. To
do this, this series modifies gfn_to_pfn to return a struct page in
addition to a pfn, if the hva was resolved by gup. This allows the
caller to call put_page only when necessated by gup.

This series provides a helper function that unwraps the new return type
of gfn_to_pfn to provide behavior identical to the old behavior. As I
have no hardware to test powerpc/mips changes, the function is used
there for minimally invasive changes. Additionally, as gfn_to_page and
gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
easily changed over to only use pfns.

This addresses CVE-2021-22543 on x86 and arm64.

David Stevens (6):
  KVM: x86/mmu: release audited pfns
  KVM: mmu: also return page from gfn_to_pfn
  KVM: x86/mmu: avoid struct page in MMU
  KVM: arm64/mmu: avoid struct page in MMU
  KVM: mmu: remove over-aggressive warnings
  drm/i915/gvt: use gfn_to_pfn's page instead of pfn

 arch/arm64/kvm/mmu.c                   |  42 +++++----
 arch/mips/kvm/mmu.c                    |   3 +-
 arch/powerpc/kvm/book3s.c              |   3 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |   5 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |   5 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c     |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c       |   2 +-
 arch/x86/kvm/mmu/mmu.c                 |  60 ++++++------
 arch/x86/kvm/mmu/mmu_audit.c           |  13 ++-
 arch/x86/kvm/mmu/mmu_internal.h        |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h         |  36 +++++---
 arch/x86/kvm/mmu/tdp_mmu.c             |   7 +-
 arch/x86/kvm/mmu/tdp_mmu.h             |   4 +-
 arch/x86/kvm/x86.c                     |   9 +-
 drivers/gpu/drm/i915/gvt/gtt.c         |  12 ++-
 drivers/gpu/drm/i915/gvt/hypercall.h   |   3 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c       |  12 +--
 drivers/gpu/drm/i915/gvt/mpt.h         |   8 +-
 include/linux/kvm_host.h               |  27 ++++--
 include/linux/kvm_types.h              |   5 +
 virt/kvm/kvm_main.c                    | 123 +++++++++++++------------
 21 files changed, 212 insertions(+), 174 deletions(-)

-- 
2.32.0.93.g670b81a890-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
