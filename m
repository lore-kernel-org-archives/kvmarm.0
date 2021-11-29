Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DC0C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 08:41:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4A24B227;
	Mon, 29 Nov 2021 03:41:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4bCJQTsx0fYG; Mon, 29 Nov 2021 03:41:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C358C4B225;
	Mon, 29 Nov 2021 03:41:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB39D4B1FE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9VPyXZFKh66D for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Nov 2021 22:43:38 -0500 (EST)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D33414B1FD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:38 -0500 (EST)
Received: by mail-pl1-f171.google.com with SMTP id b13so11075888plg.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 19:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=g1AjNx0u4QsH0ydDfhoNnZaeQc7rEh0mvCty4L4f7eQ=;
 b=Wt8FaLZ08KUnARUpfZuFUX8/aWHCXUzDWW38X2tieklC/DI06HFADNTel2urdcLghd
 6xuwD96bktbINCX1L48Tnqrgt/rnLZX0XjKzef2OqinmBYRmyB92QmVHjIXnsa4D3adc
 Ewoo7Xso2SY8bIPCIsveHyTJlUKvgLq1OWVdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=g1AjNx0u4QsH0ydDfhoNnZaeQc7rEh0mvCty4L4f7eQ=;
 b=jR4M+gPbG35FgzLUYp9ZniYZaj+IrSBbnaMlDgp5BmAkgo33YAuQfB5LMC8ZYzkkjG
 8prNc2LgltZmpE9Ldv8cj9bT0vAc+Tdbocu/JB6HqC6hNIHD1f0BDqRCNhfTSKcziH9X
 FOCYGKk8go5xFquXOAgOc3esL8zKhrBtv4CDxbnEu3o2hkEF3qNXCV00zw50rxBcspkT
 RKerVX/ScfyIE+AIf5/9OqFfUTBMC0f8j0DUWcbge/KDBoyArGZSu8tJYZqU3OHtuYgk
 RZVgae1XoJ9rjuJlQNl1Lk9AsrqaCPI7X4H0Pj8CpoTMgzK8v0BFrIzJ4OIQK/hi2B/S
 BsZA==
X-Gm-Message-State: AOAM530RcXAGfHylOrUGoVdLkvAIC15ktsc8ruFfT4UIIZ3tI+jk38dR
 V+LMvrSOyPty9YnZG1/+mscjNw==
X-Google-Smtp-Source: ABdhPJxLhGhNYMx62P8hwpiqGSK0LeOGFyNZHJnZlg3ztGeJOu1G+77rZi203d7zD5d/O00+rTeohw==
X-Received: by 2002:a17:902:ee95:b0:141:f28f:7296 with SMTP id
 a21-20020a170902ee9500b00141f28f7296mr58161089pld.50.1638157417973; 
 Sun, 28 Nov 2021 19:43:37 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:72d1:80f6:e1c9:ed0a])
 by smtp.gmail.com with UTF8SMTPSA id r14sm6895238pgj.64.2021.11.28.19.43.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 28 Nov 2021 19:43:37 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 0/4] KVM: allow mapping non-refcounted pages
Date: Mon, 29 Nov 2021 12:43:13 +0900
Message-Id: <20211129034317.2964790-1-stevensd@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 29 Nov 2021 03:41:49 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>,
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

From: David Stevens <stevensd@chromium.org>

This patch series adds support for mapping non-refcount VM_IO and
VM_PFNMAP memory into the guest.

Currently, the gfn_to_pfn functions require being able to pin the target
pfn, so they will fail if the pfn returned by follow_pte isn't a
ref-counted page.  However, the KVM secondary MMUs do not require that
the pfn be pinned, since they are integrated with the mmu notifier API.
This series adds a new set of gfn_to_pfn_page functions which parallel
the gfn_to_pfn functions but do not pin the pfn. The new functions
return the page from gup if it was present, so callers can use it and
call put_page when done.

The gfn_to_pfn functions should be depreciated, since as they are unsafe
due to relying on trying to obtain a struct page from a pfn returned by
follow_pte. I added new functions instead of simply adding another
optional parameter to the existing functions to make it easier to track
down users of the deprecated functions.

This series updates x86 and arm64 secondary MMUs to the new API.

v4 -> v5:
 - rebase on kvm next branch again
v3 -> v4:
 - rebase on kvm next branch again
 - Add some more context to a comment in ensure_pfn_ref
v2 -> v3:
 - rebase on kvm next branch
v1 -> v2:
 - Introduce new gfn_to_pfn_page functions instead of modifying the
   behavior of existing gfn_to_pfn functions, to make the change less
   invasive.
 - Drop changes to mmu_audit.c
 - Include Nicholas Piggin's patch to avoid corrupting refcount in the
   follow_pte case, and use it in depreciated gfn_to_pfn functions.
 - Rebase on kvm/next

David Stevens (4):
  KVM: mmu: introduce new gfn_to_pfn_page functions
  KVM: x86/mmu: use gfn_to_pfn_page
  KVM: arm64/mmu: use gfn_to_pfn_page
  KVM: mmu: remove over-aggressive warnings

 arch/arm64/kvm/mmu.c           |  27 +++--
 arch/x86/kvm/mmu.h             |   1 +
 arch/x86/kvm/mmu/mmu.c         |  25 ++---
 arch/x86/kvm/mmu/paging_tmpl.h |   9 +-
 arch/x86/kvm/x86.c             |   6 +-
 include/linux/kvm_host.h       |  17 +++
 virt/kvm/kvm_main.c            | 198 ++++++++++++++++++++++++---------
 7 files changed, 202 insertions(+), 81 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
