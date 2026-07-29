Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8F3BBFDD
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327212; cv=none; b=g8iv8e3GapFMMJJsiAjpx6j90u3VGByKgy8LeSOmg5pcMflQeH/v0Mk2JBd4nQKauQgdTD+xUAldSIhdCjOESMtvAE2HyK0Sw2au1uaIoOaGfrI4QQA/ECdCPTZQw12+JY83BRlbngQym0Fp9dqK2pk3HDNM4mCNgygVaKQS9Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327212; c=relaxed/simple;
	bh=FJKTe7w5oX4sNy96KRtCt95pc41IKsrn54ZS4gFoGX0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=K8ymOdxN/kDZavGQyKd/MKZnc/9T8aVBOnlI8JKxWAWgMKbTyv7wbPqfZAG7r9idFQkl2bwGCiG2mTMiMGLuxgLCKNyXK2ZL9iO24P7g/Y5lV59CCslv/cHVz6MjpMHLSXrGNgjx6GrciadWSzOYwg71w9x1jStV7PF9F4z6wTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g6AEz/hs; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g6AEz/hs"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495529a93f9so8274825e9.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327209; x=1785932009; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BAmImkqu1SFwL8NSZDIz5I9w1IjXZHC7hoAV+KdJnaA=;
        b=g6AEz/hspms3loUtnmW09D8DfzjlPQh9CXTOx8CC1UPKQNS8E3xUTTgqR2xV3y7eoc
         NGRgzxQGIG+4/stxgdgqd+6u6AUH8DF2DD44FROfYp5eaq1EegmPb2y+7rBJQsJCreSD
         Ti7ewhBXBSwKKGA0oEFEKBdEkAbyQmJeGUdkXBXRof8qnSou8qSUGI5+0UJYx2NJWPvh
         sLWzUPXdGrSiChELGftby2aIgcEJCaFOtgAFbGkY+2FJc98g6t5IAzVBQLTTa7pkJlMC
         /BUAzSG1LnhpyivlKmhBwUeTYyf2gGdVN4TfEq/LAdR396FX9SgEpbwW4nVuKZow1eE2
         M0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327209; x=1785932009;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BAmImkqu1SFwL8NSZDIz5I9w1IjXZHC7hoAV+KdJnaA=;
        b=C2LtdTPxEzAggJJlfSsnbXk3B/OJEDl02HQ/UzWyCdEUrLkdSgJx+yabNFir+1oSAC
         haIc2L4vkNOPI+90BhETzGwpSIiHdNeX/5/kciC49gFWamkcHYuJ475QF4LtsdbGJDsg
         U83C7YOOfSDgrWyflLhUuObd5vbX0pwV1/By5/aafMRoMIF2JJj/xGjGKIpa21cLUjcH
         a2sTrViw2Rd5/O8O/0n0tzsmifrOGT82yBhj/33KETg7iro8nbAWdUC37ygovsczqFya
         qUgK6dlbqFuV8rFRO5qo7PYerMuitOUDgnn450/X3MhqWSbEI68ZFX5YHf6Gy+C1IYGT
         xTDA==
X-Forwarded-Encrypted: i=1; AHgh+Rq1HYQ2eCilsNqfontbdvy5wIlmJROAsZYHn+1P4W84HhULeJm9bwkYnucXwy/EOuiT/6UGdCc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0K6E4wlTutwsgzG5IhG0H9C0v+Rmz/VJXjvRVBwUdcsq5PyIp
	mN5VufxlltYG/KKWT4/ZMkbLEKRjFf8Nd8bJ8nZPaTPVx7TnD2kvYe2duTtZHq4bDDTlnjaeOyw
	yrGWyAAAkoPF4pqIMEZzFHI8cB33TdQ==
X-Received: from wmbjj19.prod.google.com ([2002:a05:600c:6a13:b0:495:54c7:8c97])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4eca:b0:493:e460:1f6 with SMTP id 5b1f17b1804b1-496c60ba34amr69095735e9.0.1785327208512;
 Wed, 29 Jul 2026 05:13:28 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-2-sebastianene@google.com>
Subject: [PATCH v8 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
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
2.55.0.487.gaf234c4eb3-goog

