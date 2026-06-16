Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FBB44D03B
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624524; cv=none; b=oyCZ5uUc57huTrBl/Los7SgolA9Pk5bxM+0ndjI/Tc5/Te6jUZptvF7OT1VXJOHwnKuWqpC9MzNsg3QkLPRcx4esLcqnLcde8lK48RBHp5b1HgMf4mUKkHG4Y64YjhE8PstWnPc7T5OOeEdJCHboJRaAlzsn7OY2cPjb4vJPciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624524; c=relaxed/simple;
	bh=sVmyW2ZCcI5kqJbpqnmxwTzPiRwlsWCVcE00L7W5JWk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=h9TBUJ0k5YJQMC8DJIW7GZh6fhjq0Va8w/zWJcmS3d2Gq3o0UU/Tvq6Tfe8DRmOLUAvoYVskJDHHkP/+sgUzVfJe8D6zk7Q9+aVzahGP5EpNEHUrNB12RXeh7QVGoFiPHi+5NHzo3C//ecvnY1whdRi+sjvo1cA57tys368PBgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fcp9jyNU; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fcp9jyNU"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68f9f08cfcaso4309188a12.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624520; x=1782229320; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fHtYPZ3p2t9f2nLF/1WXA269aMaG2YVhAxwX4n4X/s0=;
        b=fcp9jyNUikghgJTzVpszvn4ajKNdburv3fcWXMJ0ckZK3/BKoaFKuL3EJ6d8Y4Qd5y
         nTOUXhC+xkd8ptvb9Wxun+Ejg1X4MdpMJOg6/oYV7btG6lUcP456wOQK/rOIIxwWx9Gr
         kLfl18s45eorqkM7cKhq0XhipuQGPDZuFqcIKPe2fARLUW+v3MBg7/MGvhAlk8mAkqn0
         SovnO4KexOwV/olyOocf2GLM2WMeoooYdS1gYIr21w+9xlCYWmsdqtoY3NABMHmDjpUB
         hTTk1nWayLf2ZeRysi8FzkScMXWNXsR8I+bmmRPLy1/JNceO5kwU481CDufn/toemqg8
         yJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624520; x=1782229320;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fHtYPZ3p2t9f2nLF/1WXA269aMaG2YVhAxwX4n4X/s0=;
        b=Qy4BTKdhtLPwywrkXmPLbgisIvWHrYJDJSJybA2d6AjStiFHuu0sQRS05OHWmqSiP1
         F4z9mz5Am9WE1IfHh4EjdQTNuXM0VU0/jjo45NRZVvUzHA7qDpBOvCKogqNUcvmknDn+
         G7GzHjhC+Pkxi7rGmWFOZYd8Al3YJrJNcfT9Gktzp1+8iG4YG3sR/Rw0bZYEgOUR49DE
         ij5dCm1/0gqclSvjSM3841cyYS+G/A5uNHLsoBX6lgWt0J9fZYUakJ+DRtcZszy9wfBQ
         FOsaG1wPYTzI6VMj5nvS/WU91UlgRj9LtSzOYuZKuh+HvbcymDOXxZgT30x9ZfuXlIe/
         GDsw==
X-Forwarded-Encrypted: i=1; AFNElJ8rh0DgLiCbjMTsu6Ona2HXRXsGVIn3agRB2hpO3TPArfMTBE81rSGiYhHfBbRhuYxWxFYrUe0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxu42FVGHPLHRdhWcjJV6jyhzFaL1e/tuRpbGVb8YVJ7nuncozy
	bbZ235jyekLzO3LLly6jZu73+P4XRJ/UhQbYIdTIwoKPcpn9++eLETEPf/ef+DeaThCVYDLiTYV
	xcA69G9sXnc5SFsg7PS6DFw5MEd9/HA==
X-Received: from edrj2.prod.google.com ([2002:aa7:c342:0:b0:695:469a:cfda])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4498:b0:68c:bf82:884c with SMTP id 4fb4d7f45d1cf-695086dce09mr2519000a12.6.1781624520031;
 Tue, 16 Jun 2026 08:42:00 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-1-sebastianene@google.com>
Subject: [PATCH v4 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
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

Link to v3:
https://lore.kernel.org/all/20260616105417.2578670-1-sebastianene@google.com/
Link to v2:
https://lore.kernel.org/all/20260608165549.1479409-1-sebastianene@google.com/
Link to v1:
https://lore.kernel.org/all/20260501114447.2389222-2-sebastianene@google.com/

Sebastian Ene (7):
  KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
  KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
  KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
  KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
  KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
  KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
  KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler

 arch/arm64/kvm/hyp/nvhe/ffa.c | 211 ++++++++++++++++++++++++++++++++--
 1 file changed, 203 insertions(+), 8 deletions(-)

-- 
2.54.0.1136.gdb2ca164c4-goog

