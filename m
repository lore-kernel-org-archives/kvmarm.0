Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156A3E3DB3
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459958; cv=none; b=bJ2ejMDzUB8DmZgtfWXRgxu8Jwm+pF9ONb/ZjtNR9uub+oje9u7kWXYZI8Ook/rSmkuBwf1VORBBEYVV6RjfdY1o3+yCW/mmuyoJyzo5EPScD6eTDKHi36jNJb7rbu5++Ccq65IT0wiU5i9JUKK1y8WuhzqGvJnQWNIatRJoreM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459958; c=relaxed/simple;
	bh=PctLykWCghmyUisAVpQ4wOoWl4Aaqh6+hWz130v9m+Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qQn1kbTvtGeZfh3+RWXyMgspN7wN4+HFhvtdH6oN1+bcnJw/qJi2x+7FAWIQJAHgnk74pookH9Fw/9N/qh10fSEAdqnTxncplsL2wIef6H4MMCQ8YoOYrpBDiFy6Dtgo2LyPQzic+q8v93vyF6t63QLq8amCTj6VLWhT1ngcxQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gq2M0zIm; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gq2M0zIm"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-465874136a7so288405f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459955; x=1783064755; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zeJOCZLhCVkiT1VK2WkmVo/4/mMU1YIiY4Y789TDXh0=;
        b=gq2M0zImGzt9FBJkVWquC7fedk5i4FIGJTJQUSp7l1OApwdOPJkMe7jTMxwwpJkHeM
         n6+eBxrfYpy27stdO0OwYoB16BkOYGOlRxbzkFh5K22DQxt2YLzirKGKOulenXcKSnTD
         4kbYPmcf+SqJPaTMsmueIA6zw4wbnbAIdm5u+E0vh4hkzHai9/+j9Xb0y98ORBS3Zhwd
         TjEF5lnSrVfhSXbvj8dKNdrusPtGR/24mPWa9XciZgEOuQvl1SZju1rzhTRvjrPJbJEJ
         TsUqVfJR9eblWyZOsrhrap9P+fzo+uUWaFbTcG0Y0xLU/O6q2afHs8+7ITiA//sKkxq2
         EVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459955; x=1783064755;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zeJOCZLhCVkiT1VK2WkmVo/4/mMU1YIiY4Y789TDXh0=;
        b=Zz/LEmzpE6Y2y1b+dCWTxjfVZemaoeYxAW7egq+T5Zf0EdAJSsFJ1R3gJ+pbHNUej2
         cXjAe+pH7qPeuAzJTYb0klGVLURKPp7mkvu/WEvnMY7He7KzhBK+V7SEr8q0O4QgANRW
         rcVzNIbDBIpiG5edeGrwksa/ljNTTB5Kx3CHeI99TmIb2ggrsufMvnOl4Lq/EyOdOm4j
         LyrYjcURQqUYRZ7OkYRCOk/tRPObJVhqOIO2SN9iYnkZOh52/jtgy7l5JDsNFtmI1Gv0
         J8eq/H1UnHsmKtgmk6tSGXRbTPtWeXL5Us6SCXt3T4ALRKHuSj2MxCUW7M+fA0kPBQSs
         l7fA==
X-Forwarded-Encrypted: i=1; AHgh+RqSWkzYMRQLauUlAxGBOnniJ0D6ckTy8/hYQi9g2kFfZJR4WTwII2P0yttUxEzA+babeB3hNbI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+LzWQLQkeKYaoO11Qs+K5zuoMmHaoUMy9uQ5XNUfVGTf4MoqP
	6atHLLENk8R3r5fqMPbRgCFy/F7jpvtvteLyQsJV9U616mBEVjpwtY2kM6FS9gHfdqTFOY6RUPc
	AuAaQCS0Uc+mlV4GB6Mzm562w2fnY2g==
X-Received: from wrpl17.prod.google.com ([2002:a5d:4111:0:b0:46d:fd7:d50c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4608:b0:462:1a7a:9846 with SMTP id ffacd0b85a97d-46dbec3fd27mr8598500f8f.8.1782459955083;
 Fri, 26 Jun 2026 00:45:55 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-1-sebastianene@google.com>
Subject: [PATCH v6 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
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

