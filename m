Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC193F8EC6
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 07:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783497475; cv=none; b=a3yoT6MXLjMV/bqkq4+Xq6/iblt/pwGx9A/v1hr/rz+xETUu7LTorUrmNp1lUpsRGztj0VPPxH79AUc0LTMtUCIyKVx600+xviLMbnp7wvjxqwQhC/+o1zoIWgAOUk+ZNNrBp1R114wLxLQ6QbfxS8f/TCed1EirZdAT9E+tduc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783497475; c=relaxed/simple;
	bh=qlJ//R+zrN2UCFhuVoeh0f8WSwNtkFs3oJAd94Ej3GA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=g5ZVds5uRUakFEpYxmqAY5M4sDYvVrJRgeU7GGILGB4wBA3UCW1pF9qJven7YPJQyuz4zvENbgS7JINxkhML6y/TZN9JIT57okicNbJMIYZceZKbQMq9dlUiwgmruUDx7CGba7TYNLrDq+X6caGQE7WvVVvbm1mbuR31iEWco6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VYpLAKT9; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VYpLAKT9"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c15ceb17a28so26181966b.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 00:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783497463; x=1784102263; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PxL6rMmvaAb+6E9RAHDZ9xlGXg899687R90+P4Nthl4=;
        b=VYpLAKT9iU0o/XYcwdmkDT2MaQhjF5y5glPq3mKhmDf/ztVy4ofqdNlzbk4r1QWuRs
         IppIBgKZAL6gOtMmnhObIyGdlPQ2KxqPJbidUnia87q3pXK1GZRWljrXMVlDoGA6PorC
         wipk8XqHj/8pwha+Z3e09LrzGCHQGRlW2sA7str8cxOTRVLVvdBkLFBkXMsNEcqUoUo5
         g6IUJ5Lfqwaz7vwt6lRkNDT1RDluZYwMqyZVbdodTjL0pgMDjsNu6mi7TwGex4I+dsG5
         QeyzY7iSib6PfzGo1haqFRgGaNeCfAY/bWuRR9XYEXLediBGbLz32S4x6kJisLwoHLj4
         zsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783497463; x=1784102263;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PxL6rMmvaAb+6E9RAHDZ9xlGXg899687R90+P4Nthl4=;
        b=AeQkPcAb0xTD/beAkJPMtVo8gwY52g0OneBJ9bqNsuqYrH6qWJJpFBrmYuU+rp2Fcm
         8naQAlnD9vvKGQkDTcKtggQ49o5Gixnq1wKrX+4jpBM5Qv8JNpgRpYBga2jczlt7WPVg
         OBpPEBot/e+ExrN24TW4l2doM4MVGsxv6YHkdQ6d0T2MkHo2umelwr4GHtGTREqcVhvA
         tpLsp43NfgiAZh3MxFTVIwsKBOMMR+pZ+r92sOY+V5M6hW3lwmwl0MLltzRD+ETPKbWc
         Kxs2Ma0jMIqW8C3N2yQaXSXs2FulGIRhgHalpRdmdbD7P97sPxdyduO45z3FryULeA35
         QvEw==
X-Forwarded-Encrypted: i=1; AHgh+RpuOWDdsFrfuDU1G2Xa/ozLTBKf7m+YgV/4EJER0DVLBgvFdJ2SsQcIFuSd1Qv09i9XiEb3Xrc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpAsQSf2BqnhJPVlnuOijdm1K4hCW4BaGecaZGVVyD3PHC4pOu
	QFDrRsiIrTMZ01L79IpoauxveLr440S84BmFC/FyxhWzGexrpjwOw9mKAXB/nKfGJSxCjmPimIy
	pFC2lo6Q/m/lNH2lOaUawfg==
X-Received: from ejie9.prod.google.com ([2002:a17:906:2d49:b0:c12:5e2b:a869])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:1b56:b0:c12:6c2e:ae9 with SMTP id a640c23a62f3a-c15ce014ec3mr43200266b.22.1783497463092;
 Wed, 08 Jul 2026 00:57:43 -0700 (PDT)
Date: Wed,  8 Jul 2026 08:54:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708075435.47419-1-vdonnefort@google.com>
Subject: [PATCH v2 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	linux-trace-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
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

Changelog:

v2:
  - Collect Fuad's tags
  - Rebase on 7.2-rc2
  - Warn when trace_hyp_printk callsites are exhausted (Fuad)

v1 (https://lore.kernel.org/all/20260612142245.1015744-1-vdonnefort@google.com/)

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
 arch/arm64/kvm/hyp_trace.c                    | 63 +++++++++++++++++-
 include/trace/define_remote_events.h          | 19 +++++-
 12 files changed, 179 insertions(+), 9 deletions(-)
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.55.0.795.g602f6c329a-goog

