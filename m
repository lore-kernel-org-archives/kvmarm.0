Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632D236A009
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781274176; cv=none; b=Nb5nIsAv2SiuUy1N5O7/oHqQF195aPnkRrc2xmZTJ1QUe8T8ZT08UmMosK9bWHqpDHSt9qoM+SlDFp2jR+iv+oHPhh3Cnt7LRrTDIhCfZALwjW8yl6WIgMFlja3UjGLZrz+lBCoS8S+rTa4QLTLjdOhfa3E3sQGbwDIj1PuPdJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781274176; c=relaxed/simple;
	bh=8Q73MooLEk26mrOKPo+4oe+OTrUeK0F4sZCo1RasFHM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=geeQzVJ68hwlyXV+NGOFddrvTrn1razqJCgDRAxG8py+/agGVfEEaiL7OgRxCMgCvrFZ9qBq+gq2YBpxplrqMQv2EQsPX046CwHXb66zrS9xAJNHStK1fiejs/QUy3SAdZiCXM4DsHHiWgOv4wjoYJKC838lsfjJKYf0JAUXZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bivEnvC4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bivEnvC4"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490ae3bcf4cso4803235e9.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781274174; x=1781878974; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BOk3rPIMN9MJANkiEj+yRZwzOhJQDKG+UEQQtAnaeSo=;
        b=bivEnvC41SfUM7f/JuUKvWDHl3mLh4vLjUaD0QSV774dDTt3jC1AjnbBO8AUQbh5xJ
         nJ4PxBDkkhhC09gpbGwhohD/WSGZFJ4PfptwujzefZF27RWRyUCSYVPlFxzozqq8eohh
         ls62UGp7t60IDyyzc7BFAsdB8aX9X64xbdTq7Ls+j0rRhNVEPq+CmEGcRSgUxkjCpXtY
         prZHwpqpfOp+q19UQu83h3uAa2ycCST1Omd7hEA2khdKaRRh+F0KeYP4GnF5Lpcpim03
         ArcV0gXBQQPpPOzL62YQ7Ny39yhM4KyY3G2wPt7TXK1YtqHHipM7U44QO+IQfnnWWUm9
         zdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781274174; x=1781878974;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BOk3rPIMN9MJANkiEj+yRZwzOhJQDKG+UEQQtAnaeSo=;
        b=L/mJKTlxTYj3jyLn61LXeemeVERmmfOFAgAKbrxWKLgOsRjPex2ffdT/DEMIPYOqLC
         FijGPlVmNQ8Z7n+KPzgcDopEOSYTy18a1Nr3N2OSbWElXNEpy2/VIvQWUq7Mo0IaCSPi
         eL0Anwh6YempIugtOdfROKQy4ZQctK10lhFDscxmWRpxq8G1SEKBxwRlGesBWwuLrrPE
         zQyjzzy1nlvzrws3Owrzj+dSqWrIfrHV0hQx3ZjtKUc/82jq/r1pqKGgHIc+ZRfceuaK
         /rFxz9qkkPLrFzxjQgrC6j8h9z2W8rNHUagjtTvx3oTejPSjLi0Ls2BENDL40wN88HuF
         lzNA==
X-Forwarded-Encrypted: i=1; AFNElJ+6HdKuDeqVBRcSZOs8/XYKvp3b/4lJ36TGRUUWCXIIpltBToZRVNpXGwH81SZvEf24fW3QGxQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxycYTIOqcTTzvk9khXVPmdyIN8LtAhcE8ek6MjZsVYChlbOvgn
	5eiKQg+dTRQbCDh4BHqk9XM9wAHgivOIqN23CC6+9xiV3K9JU5uSaF0rzbuQu6iZF9h/02jCASa
	gM+vw2pGi5JaGKA7y5/bPhQ==
X-Received: from wmaz11.prod.google.com ([2002:a05:600c:6d8b:b0:48f:c914:1996])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83c5:b0:490:be14:bfda with SMTP id 5b1f17b1804b1-490ec48058fmr42511215e9.6.1781274173422;
 Fri, 12 Jun 2026 07:22:53 -0700 (PDT)
Date: Fri, 12 Jun 2026 15:22:41 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612142245.1015744-1-vdonnefort@google.com>
Subject: [PATCH v1 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, tabba@google.com, qerret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series adds a hypervisor event "hyp_printk" which enables
developers to log pretty much anything into the hypervisor tracing
buffer, just like the kernel function trace_printk().

This enables rich logging from the hypervisor, while leaving all the
string parsing burden to the kernel. This has been the main way of
debugging pKVM in Android.

Even though not strictly related to trace_hyp_printk, I have added the
following two patches:

  * KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp

    This one mainly intends to support one of the new features I have
    posted here [1], which allows to enable tracing as early as
    possible. I have added it here to limit cross-posting.

  * KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/

    This one is just a cleanup.

[1] https://lore.kernel.org/all/20260605163825.1762953-1-vdonnefort@google.com/

Vincent Donnefort (4):
  KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
  KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
  tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
  KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp

 arch/arm64/include/asm/kvm_asm.h              |  4 +-
 arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
 arch/arm64/include/asm/kvm_hyptrace.h         |  8 +++
 arch/arm64/kernel/image-vars.h                |  1 +
 arch/arm64/kernel/vmlinux.lds.S               |  4 ++
 .../define_hypevents.h}                       |  0
 .../kvm/hyp/include/nvhe/define_events.h      |  2 -
 arch/arm64/kvm/hyp/include/nvhe/trace.h       | 65 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
 arch/arm64/kvm/hyp_trace.c                    | 60 ++++++++++++++++-
 include/trace/define_remote_events.h          | 19 +++++-
 12 files changed, 176 insertions(+), 9 deletions(-)
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)


base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
-- 
2.54.0.1136.gdb2ca164c4-goog

