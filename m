Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029BB349AEA
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 07:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040625; cv=none; b=EsDXKAtvvpUAKSbHS6YjQtBiZwwf9w43trOeteuyo1sM1tRlT+8FklevC/yVs1Ugt79BLUMRwE7yN8403mQ86ydRvcIg0m1lz1e7OPSfOeeOcYFxXH5iKF58DXm7BHyf2kodJ2Jsm4vYX2Rrd8jXalRE/BhKeL07jbQhibXVyco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040625; c=relaxed/simple;
	bh=AQc5VySXy8q2Bk6xN/PY4/4Xyl5t9boY6mhk63Pe8VQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Yy8k6VohkQl5JONskt50CdHKg1z61dSLa/qkZfNN9v9BLbrm4J4F+ipidpu4uVvkeF49CvCYjg0wqvhYFjeKU7sTP89g9+/IZOrQI4V0SqPpW08ei/ffEIx/cRESpdI9kgg8aaua6F8pMLiX2lB3TrSJNxV0CbbyYOhwbCV951A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rVl3q1D1; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rVl3q1D1"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fde68e420so103403105e9.0
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 00:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780040622; x=1780645422; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QroFkfsIzFdk7bYeD2yDP4/NwbzDZKM8O5SP6AVtn2s=;
        b=rVl3q1D1cbcbpa19zT9dhA4Oi+wgJMGY4ow2BcdkGWGTA0trdd6wi3fGHMG3a0dt4a
         Gtejggut1GDSxPalYp0aczhqAuhRIoqA+/kLIf2SbZ86gMB6s9FwgaUfyroACxf+He0A
         +WeySkZh94mnEUWTGoxkOrRVERqW0qcFVeA++mi/ONWEPT98XNwNm0fpsBWY7UoAgJXI
         0b9rL3dEN6/OcJPzXLdh7GuVbVVpdX4hNYR55TYUkAHMNCjGFwOBEIPXcXh2akeHWd5J
         SNU1WusL2GUWUMCgUhrBnkJBnOsqrDV0l90v4tMjM82bF9cEXUj0ZaEJBPPKDXdK5fjB
         6XOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780040622; x=1780645422;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QroFkfsIzFdk7bYeD2yDP4/NwbzDZKM8O5SP6AVtn2s=;
        b=Aaj2ytSCoMUpiRtX9YoXYZspNJjCyOCUB8L/yrmazDZZHTW6s3329hKJb00PwgpKSV
         e0MDSYRaql2pLkI/dQt+Ubv/STN6433DZW7teR2ybNmrTdoEOfKIQlYAJ1W2kgbgPcOO
         QTZEFhsrzOWlS/jPIssEWjnXIVzrEiRugk31bsqWf7qq7xB3lMeT4uqEPqcizT/I6eqS
         QbrwrOnEb3iRep+v51GTMjVjjm+pz3VhED2MP0X4+M5Njs75KCDY1Ut3wiycTMdimxxD
         Emjdo7kJ4yUUP9ToXfj6E0HZaSbGiGGg/M1tnTAW3xb95qeEKjqsAsqhEUkC8DHx0AjB
         qsDg==
X-Forwarded-Encrypted: i=1; AFNElJ9Tp3MydPx8++sL/pHuKJbcuZQsvaSc/dACMQg8VqMrAT9fZ4qLzfdP09sakIpZ6fs0y6YO9e0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhRbZDX6zp79t34VV/e/hFKSdapB1UBHqI2Rn34fvVCi/UwDSF
	SBRAXxVKBGO56nmB9j3ADQ/qoGMHXf+aJZE3Eq9C+EwZBwOWrQw2k9mu61/UBP16eFKPD3IHk1F
	uSg==
X-Received: from wmco20.prod.google.com ([2002:a05:600c:a314:b0:48a:5531:d9cb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:cc1a:0:b0:490:845c:a1ea
 with SMTP id 5b1f17b1804b1-4909c0b0c32mr22550225e9.21.1780040622146; Fri, 29
 May 2026 00:43:42 -0700 (PDT)
Date: Fri, 29 May 2026 08:43:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260529074341.2271950-1-tabba@google.com>
Subject: [PATCH 0/2] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi folks,

Yet another bug I found while testing Sashiko locally with fixes to
review-prompts.

share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
maintain a host-side RB-tree mirroring the set of pages shared with
EL2. Both invoke a hypercall that can fail (page-state mismatch,
EL2 refcount still held), but neither cleans up on failure:

- share_pfn_hyp() inserts the tracking node before the hypercall
  and leaves it in the tree on failure, leaking the allocation and
  presenting a phantom share to a later unshare.

- unshare_pfn_hyp() erases the tracking node before the hypercall;
  on failure the host loses its record while EL2 still owns the
  share, breaking later operations on the same pfn.

Severity is low (no isolation impact) and the failure paths are rare
in practice, but the desync is real. Both patches are independent and
apply cleanly to current mainline. In other words, this can wait for
7.2.

Cheers,
/fuad

Fuad Tabba (2):
  KVM: arm64: Free hyp-share tracking node when share hypercall fails
  KVM: arm64: Avoid host/hyp share desync on unshare hypercall failure

 arch/arm64/kvm/mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
2.54.0.929.g9b7fa37559-goog

