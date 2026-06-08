Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B6C3D47A9
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937759; cv=none; b=RuvaFD8ZZNwDYgDDYqXVxneuoCrQnutBP+wzSDn7FVO/9/gMZDBS3nMRZrtAEFxAIDUm4F2p8UEN0xTnTNU3sukv03am4OsAOa5+ml1bHCsu5XaSuJtnDPi97QpSoRm+xa1V/ZzKD5OV3+0iMAWmf4Uw7W2pwak0U7ogjDRBc84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937759; c=relaxed/simple;
	bh=0uDN3QQnJUA3aH554YozVv/EwKFw4ZPiSxTZl6xsMyA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=emt67Kje0UDk/ACaQEq+Gmk1Vli9naK+nZxAI5IEwXsGFR1rG+VhEM+nkvr3pPgFH6joYxufonpsJK52dd6YRzHFBNRk3iqfh+zt+Z1PDft2fH8LWVyVHHL/CYjWZUBg3O8LMJih6KNDzch4+qQ7sf/l+U3JT2LNro4lIfvuMa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oJN+zQ77; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oJN+zQ77"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bf381078ac8so418005066b.3
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937756; x=1781542556; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NJFUZ3g9aKS+Y4VWSkImzVqj/8GtScBQXmsXxxvJoCg=;
        b=oJN+zQ77xsK911f/WDRjtqOYaCiqUMG/WUjnSH5d+JvkVjfXPyGAAcNm7DGfDDvlO4
         wvhq+BGDYrchRA1YsADPDZQwW8wuoq/cE3DAKBafx2bexdydqsX5gsOHyfVZ17sBRauD
         KJ2I1YtR+m3FpjFfJIj6SJ+ZlSKyA/gJWmQ+jcFRn016TDNNaWHZIf5jvc3nCmltSMNe
         /HCQu5JDL7JZgrpBhQCbNjv7Jka6NYHyzJlbsvugH1+//eE8AX44wHPGN7U9yYbxbJgL
         MhBBO87JhY/9AHp+Q1CW8pmxdkBHC1h+mv2Q3cuQNF8EKK0a/lqaKn8AyjuosvaTHcVM
         VpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937756; x=1781542556;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJFUZ3g9aKS+Y4VWSkImzVqj/8GtScBQXmsXxxvJoCg=;
        b=q0L+fYMdvhTTcuVCpW30L9OF/Mys9o35UQGRgv6yMxbJG2Dsl0okUGvTJZ1LlVeTpl
         M4eMXadFNJ42ZmEReyMb+11TFZKYbHwj2SVHw9DH7xtQ4zT3DznGoQQd7kP+sBGyFPxd
         xOFc64oNYSHSCRmk15LR804U5Re/DdaF1ZHPSechU0qsHPJA77HxtfLgtQp9oOUy+MPu
         LxWPRdRDvnhVc/TA9dS1f0bGbNTYSISAcSzlhlC5K+U6ucgHkVv+rwQSzqmEbgRMNWdK
         C6g/szczwcZko+NVhePz48TgPM7bngtGp4gyL38E424MfGj2Qicv/+IsgV+Lb0afLWNo
         ws2w==
X-Forwarded-Encrypted: i=1; AFNElJ8paem3/h6H+4HSjyTrLOQu7di+Tu2GPg/hmwx031nW/8yIqVfr3fjyKQ4Y5UqD1g1lhn4FRCw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5HunY8gYA1mYVQLnyc93dmhbt1Yuw1s9801oRp7rYhTY55vWi
	dQSqLXCVzs9UMZ0IcfZN5rN5LEVYKBul/2zSxPei59ENdvDlFZcLbP1wrJCMo7ow3IFD+va6BUu
	U0GIlVa3u8hyx2uOD9siTJbqI8kBm6g==
X-Received: from ejmj9.prod.google.com ([2002:a17:906:4309:b0:beb:4344:f63b])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:5a62:b0:bd5:405c:7964 with SMTP id a640c23a62f3a-bf3752e703amr582230166b.48.1780937755139;
 Mon, 08 Jun 2026 09:55:55 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-1-sebastianene@google.com>
Subject: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
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
Changes in v2:
- enforce the MBZ/SBZ fields
- split the calls into separate patches
- rebase on 7.1-rc7

Link to v1:
https://lore.kernel.org/all/20260501114447.2389222-2-sebastianene@google.com/

Sebastian Ene (7):
  KVM: arm64: Support FFA_NOTIFICATION_BITMAP_CREATE in host handler
  KVM: arm64: Support FFA_NOTIFICATION_BITMAP_DESTROY in host handler
  KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
  KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
  KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
  KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
  KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler

 arch/arm64/kvm/hyp/nvhe/ffa.c | 190 ++++++++++++++++++++++++++++++++--
 1 file changed, 182 insertions(+), 8 deletions(-)

-- 
2.54.0.1064.gd145956f57-goog

