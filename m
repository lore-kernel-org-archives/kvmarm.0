Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA7A3FBEDA
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725771; cv=none; b=auRdvH5nzeZUXgQOEcqtfVTUy8vl8vMd7SHsk/nejXVUR2CVYii1/UUWixMYuN6dNxHWA4UTgxEQ6hCzFviC5quOzTfipsLbb4e0GvrXvY42F4ecjJn+lGLu2yRH5F5tQR0MJ9dR8Snzn1fh47qu1XHapRCHuqTTm4S1qhk63+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725771; c=relaxed/simple;
	bh=oFOJUTx2nfOpIFyWPfBkdtIYQgL2sxElS5Z7XARaF2U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NKKLZ8l1r2FEVMX12mapT/mXJBBjYiJf5E3Vlo7mIf44aXuPRRZ8/x/pbp/qHH6+rt17DDkuqYkJ0mYT6IgSFEJHoo2OhEqHpVCQPvXO+/dDLk976eRlp+HQKuHEFP+N4u03vcsh/yAoqsDuRjLTrTVbxvl/OXnuX5PK5fK1Mf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sFOVX7IS; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sFOVX7IS"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-47416fc1674so375960f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725765; x=1783330565; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wxpAfyKdQgVQrLozxDIkV2Sv+aNXarc/mWfTeStJk/U=;
        b=sFOVX7IS6zkQss/Df3XIATYmOTc7udLU73guGOsVnt71tGa8i8PLTyvbSFUCUeRASE
         ZE7fsbqxJdzhcvf+FhPF8HA63DB9qXPWB5ruJdq+c98GkVt98SdsrLziH2sL5S9WZ0jr
         3mbfiyTXXvQ++zT2FYbgZNrsx0WzwNOZK+Cv/hjyTd8H5ENLty7F874Ynb90AKlCxGQk
         YtJxOM8q6UsNBRCL7S0kX5e1KtNWqIrJrLSLwzCkdxPmiczGRQ0dCy+pftNtpaqq470q
         oMNcx3LSAcmmxHCrU2v7wmOMz2I0qEjkeRkHu5sFnR2YHVwYr0wSuKe5b7rmOMrDX4iN
         3DWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725765; x=1783330565;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wxpAfyKdQgVQrLozxDIkV2Sv+aNXarc/mWfTeStJk/U=;
        b=BT2Ktxn1g3+UM3kIXh3doB3o+KXUG0augict1MsdNkLWyicK10+Acbmy90iMCZ+AiF
         QeHJw7BItjJ4FHU62FlHUQ0Ivz7myro71nY09Z6+CnAadJcvJa4wD81SPA7UNXcETglc
         pNqs3PGuf8qS5oIq6KDK+ABpl8D36Ur34kv51UFVSgY8E18kbynTXuJXz5c9pqqaWbh9
         rxT4OqInBw2e4Fh63x/uJuM5J1rU3gPrGGXQvLqhqvE+bheE5Y2WbQrkyWnR1nqokHME
         1GAxlrjUT0i1MGa7GzPtRH5r+hCtwS793Joi0dkZNI8lswvQNXtzyER3Xe2qAQgLqqUY
         P1Yg==
X-Forwarded-Encrypted: i=1; AHgh+RoKt8J756ImxMoc4bq2XDKvmhOl2DSeZeGBT7MM0M6IJy3YfTqnQUWfc7QPssCK8fFZkb7pmhY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz88s/9r/jjwHEOyuQT3J662RKoWxh0HKtMoR+1/iVZXcqiXUpi
	9Az/H6AtsVTCvtZYLWTmuCDL7RkYwMsI2DYdhWHeVOZG/gaTyiTBQcQzmwMbt+HJjWldaT9DDQz
	7Pz0BoGujStLqmltpubPbQM6NzSMN9Q==
X-Received: from wruk15.prod.google.com ([2002:a5d:628f:0:b0:461:ab57:c986])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4289:b0:45e:f302:95b with SMTP id ffacd0b85a97d-46dc18a5a3amr27301738f8f.37.1782725765154;
 Mon, 29 Jun 2026 02:36:05 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:51 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-1-sebastianene@google.com>
Subject: [PATCH v7 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
FF-A proxy. This restriction was preventing the use of asynchronous
signaling mechanisms defined by the Arm FF-A specification to
communicate with the secure services.
While these calls are markes as optional, there is no reason why the
hypervisor proxy would block them because:

1. Host is the Sole Non-Secure Endpoint: The Host operates as the
   only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
   Because all forwarded notifications are inherently attributed to
   the Host by the SPMC, there is no risk of VM ID spoofing
   originating from the Normal World.

2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
   operate strictly via register-based parameters, passing only
   VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
   not contain memory addresses, offsets, or pointers, forwarding
   them doesn't pose a risk of memory-based confused deputy attack
   (e.g., tricking the SPMC into overwriting protected memory).

While the pKVM proxy behaves as a relayer, it doesn't currently have its
own FF-A ID(only the host has the ID 0). The behavior of the setup
flow is covered by the spec in the: '10.9 Notification support without
a Hypervisor'.

---
Changes in v7:
- rebased on 7.2-rc1
- collected the Ack from Will
- check for major version as well when doing the SBZ/MBZ enforcement

Changes in v6:
- applied Will's feedback and re-ordered the patch series so that we
  apply the MBZ enforcement at the end of the series
- update ffa_check_unused_args_sbz so that we take into account the FF-A
  version because the spec changed the list of unused parameter registers
  for 64-bit SMCs from v1.1 to v1.2

Changes in v5:
- handle 32-bit smc variants correctly when doing the MBZ enforcement
- add check for FFA_FEATURES
- handle missing FFA_FN64_NOTIFICATION_INFO_GET
- collected the Review tags from Vincent, thank you 

Changes in v4:
- previous series(v3) had serious issues with the patch number and it
  appeared like it used a mixed bag from v2 as well. Resend this to
  restore the correct order of the patches.
- fix strict check in ffa_check_unused_args_sbz and make it "<= 17"
- check the receiver endpoint Id in
  FFA_NOTIFICATION_BIND/FFA_NOTIFICATION_UNBIND instead of the sender
- use hyp_smccc_1_2_smc all along 
- check the receiver endpoit Id when doing FFA_NOTIFICATION_GET  

Changes in v3:
- applied Will's suggestion to use the introduced method
  ffa_check_unused_args_sbz for existing calls and added a new
patch in the beggining of the series to do this.
- merged the handling of
  FFA_NOTIFICATION_BITMAP_CREATE/FFA_NOTIFICATION_BITMAP_DESTROY into
one patch as Vincent suggested and create one handler for both.

Changes in v2:
- enforce the MBZ/SBZ fields
- split the calls into separate patches
- rebase on 7.1-rc7

Link to v5:
https://lore.kernel.org/all/20260623115354.632361-1-sebastianene@google.com/
Link to v4:
https://lore.kernel.org/all/20260616154149.2763214-1-sebastianene@google.com/
Link to v3:
https://lore.kernel.org/all/20260616105417.2578670-1-sebastianene@google.com/
Link to v2:
https://lore.kernel.org/all/20260608165549.1479409-1-sebastianene@google.com/
Link to v1:
https://lore.kernel.org/all/20260501114447.2389222-2-sebastianene@google.com/

Sebastian Ene (7):
  KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
  KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
  KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
  KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
  KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
  KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
  KVM: arm64: Enforce strict SBZ checks in the FF-A proxy

 arch/arm64/kvm/hyp/nvhe/ffa.c | 220 ++++++++++++++++++++++++++++++++--
 1 file changed, 212 insertions(+), 8 deletions(-)

-- 
2.55.0.rc0.799.gd6f94ed593-goog

