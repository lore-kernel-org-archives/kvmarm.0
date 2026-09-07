Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A951E428
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801580; cv=none; b=gizIcBHVuArQgKria+MpsLpjUENNqyrNuz5KFaCk5XMZcqNua5338v/6ye1wlKBzW7oRpSGVegw4wJVCeJsIwzL8rflPk2ILS0T1CrcFwzHP7084GG1rQEvHfmkaju60BLJSOdXWTycQZaHBKfZuv9rH7Fl0CIj109vlJA01cTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801580; c=relaxed/simple;
	bh=kqGezF/Wfqj/foPPQmc78QGbp5j69FCz61dTL1wNtA8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ge7nvu9IbrHJ9cGnGTao6EAun8/QHUxsAir62s+ICRQUdFwqEsUzIdV0hcFG/5zJhlf5dH7VvPcfaZFs6D+yMMcEGp/4aLXDUWvCGOeXLm2enGp6W1YQ/xC3ppvupK+Ufm6L3fhZ6I945DNcIEKoOG81X7ufD2MtMGXj8SQslfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vj8cJotk; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vj8cJotk"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-485835753caso2935012f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801577; x=1789406377; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BDhNx6T7nc+YilNr/gP5RkiGsPYaJuQR8YZHHWYGhrY=;
        b=vj8cJotkxESkm0LldUCGlxTwAI3lj+cv3kMX6VT4vWuOH3gYiTDg1qM9/686SRDN07
         1zt9WJU+m2jjnHH6Iz0ob2mZFT5HIshDAJrAKFX0q80GcCr1hIhYNlpeSi1CFCFpXZAB
         MYjCxZd6iXI+oVVbp4cZ4c3C+ePkudUWnZ7F4nLWvId5pfTgjxDzKT6NOdkSyK69laKR
         bkcd8sLYWgDMJidVJZUvSDh2/NFyuDmsGojV+8KZ56EYoxrHrtPei7G9buZ5+yEgaUVQ
         MoGiLFfgcbVO6/GBPW0mzjkyXWk654GkfoVnpNAtzMvwWghEPBurnts9s62Wbn3icpFC
         lTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801577; x=1789406377;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BDhNx6T7nc+YilNr/gP5RkiGsPYaJuQR8YZHHWYGhrY=;
        b=GXjYsY1hgY2tl7QhhZjByP1acBWHVoJyanlZ1zu5gyple4WHSDoQPHQs5LXDSmiwNI
         1Xzo5wjjmcjJtf2hI+6raaemXfaKOLfwL9KIfWTrRw0HRoQlv6w5tm7uAXkaBDIsgDRt
         2b5xAdSHREWn8S9EjjbJ8zkF0vNgHE6akk5VcID/HDPfURQMFSy7BMJ5rM1kjGwTxn9Q
         UF9nTZJ4hzV8laXquTekbdC0UNbSaafie+mUcj9sUsuP4vTsw17i+/WU9RibPp9dSh1Z
         RYkI2RLZmuWK/Hiv89Fm3CWXaIRB8a7JLUAPoP4ip2aCkWvfLqlBxI7CIPDdAate7Mrn
         Si5w==
X-Forwarded-Encrypted: i=1; AKwUvBwtbr6YvdQIy7xWOQwF0trYDR/0o3zQL/Dgkwu7HI2aeSLqZCADEPXo7qmdaVH+vUot+YFy+Y8=@lists.linux.dev
X-Gm-Message-State: AFuF++mdCRlVNDdK/0dySm50xrb3N/f7zdppLgl+OHwj/VUyaNK4l/f6
	aI2MhN4lPwVR9VsEiqWJo1v1SjIFP74AEvuQNtXHhx/o7fcwIyHueRTTtqCToiKxoIrRoH1it7a
	rBnQd0L+a7/rpkN4p9nvnTafMBqbENw==
X-Received: from wrqe18.prod.google.com ([2002:a5d:6d12:0:b0:484:3a05:4b1])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4304:b0:484:3311:3702 with SMTP id ffacd0b85a97d-485872db94cmr27152632f8f.25.1788801576435;
 Mon, 07 Sep 2026 10:19:36 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-1-sebastianene@google.com>
Subject: [PATCH v9 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
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

The pKVM proxy behaves as a relayer and it doesn't currently have its
own FF-A ID(only the host has the ID 0). The behavior of the setup
flow is covered by the spec in the: '10.9 Notification support without
a Hypervisor'.

While at it, enforce the MBZ/SBZ fields defined by the spec to prevent
odd behavior when a new version starts making use of the reserved
registers.

---
v9:
- rebased on 7.3-rc2
- no other changes

v8:
- rebased on 7.2-rc3
- no other changes

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

v8:
https://lore.kernel.org/all/20260729121306.1519473-2-sebastianene@google.com/
v7:
https://lore.kernel.org/all/20260629093558.2425257-1-sebastianene@google.com/
v6:
https://lore.kernel.org/all/20260626074545.433234-1-sebastianene@google.com/
v5:
https://lore.kernel.org/all/20260623115354.632361-1-sebastianene@google.com/
v4:
https://lore.kernel.org/all/20260616154149.2763214-1-sebastianene@google.com/
v3:
https://lore.kernel.org/all/20260616105417.2578670-1-sebastianene@google.com/
v2:
https://lore.kernel.org/all/20260608165549.1479409-1-sebastianene@google.com/
v1:
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
2.55.0.979.g7e5102b832-goog

