Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF0C2DCF58
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777635921; cv=none; b=WolMritHj5iXM4Jd7fzzU9aHRfeCa+KH7+PjhI5inFV2Vd2h1VyL8MN8PqbK1NHeSMIa8AIgKsxK7GzcVz+NrYlcWJx5QlJ8LabYbDCdmkPwNJx87DsQx/5gXh1Q/w+70fdNdrVTJ19ix1qkkFU//GEorX/XtcHx6ufwhvhIH90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777635921; c=relaxed/simple;
	bh=PXr4pbDQjM8g61nqlSL4uG2waHwu49CNFEu9ciJNGUI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XhkV/FrWaMqjWMJfURftaPoal9eROrilUOULoGZM081+Not6bit/WMxn0E58UUKB0/ImoWjSrkMOCh/vAWLAzRgpKdW345ISYkArdqw6hbfsTKWhCv9p5CZnWqrNxgamrK7xksY4aob7icA3706KoX65m85i0+iiUr6IdLSKWeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kW+t0bm6; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kW+t0bm6"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-67b88d32ac1so921072a12.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777635919; x=1778240719; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7KgqZx+Fsyugile3PZCp4dg4EBjBcAxKu/8HH+dIz9w=;
        b=kW+t0bm6TrrEUZt0uIAhr0VmSIzYJBI/CQmu7ocVPsXF7JOmM/U/m/8KzTZDoDemJU
         nB8ljfM7GORpXo6kXVOEhIuTegO07WkSUl/fEiqoeVrCXUyGUefDKGxZkPpxpNLe8qMD
         yzvGpDggs9mx/UY9N0DOb4wY70DaxBNmk5DZuVQreWW+qB5FvoD6NJ94W/5L4LLX2ZsY
         l37gI7RIMWLL+f2zvkZaQ/jA4buFHVH4FYRqIG+c4+dotoyFxtKZZO1l1De9n4xB6NV0
         9GEQQTDZUuB1WbY3zd9kSvWONxR7oI8R5uOGA7kQq+P/qoMls+6XFKw3elJHsEbsU50B
         FXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777635919; x=1778240719;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7KgqZx+Fsyugile3PZCp4dg4EBjBcAxKu/8HH+dIz9w=;
        b=mHKHRlKcdn5M8k9HxCeaIomrBAZIaUAIdhMR8G47Pf6oCePkqG/5tWG6p7tr0M8wWF
         LKvbuUETl67wsvAmYXKTBIx962DFu74qf7iXl6RcDk6zRy+3i0SxNm8JJbdz8a+PnzdT
         2jPm8gOwQdLwXbDr72L6OoT8kDRXehD7QvzmCxgANGJH/6uBUX2C6zDNYWQCfBXjsqrN
         sjslrIqgcvVfSahNAz/+N9Gb7JY+gMVphHDZFVzjO+XlzmvG7Hev4kAqMUCy0bEFRkhQ
         5gCWVEKr4qtkd2OwPlaJ4NFftsU++G5Igqp/QbTYWXiJeUX9D9PxztpRV8WCvu9j4PfK
         +pzA==
X-Forwarded-Encrypted: i=1; AFNElJ/nTnQHjE0nzNEoyOXJniwLo499BVDYhtBATdpORA/mVE4xmal1ffb3RBbzk0whNOICuSWENv0=@lists.linux.dev
X-Gm-Message-State: AOJu0YypR75hon2kpn9NcRvbIcxfDl026RCE6ry4Oof9bl8QqlHWEb21
	A8MB0PyJBFnM2ZRJpixlJUTohhVm0kxXyr/IHJKwrjhFVAsfjA+z9iJeQQXOcXOQ7EpyhvMdcNY
	HFm5XX5zH4XSQoSNdtNOyy72sF7K+6A==
X-Received: from edbgy7.prod.google.com ([2002:a05:6402:5bc7:b0:674:dc48:b1f2])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5209:b0:672:8f26:8aad with SMTP id 4fb4d7f45d1cf-67b96e73d68mr1282304a12.9.1777635918653;
 Fri, 01 May 2026 04:45:18 -0700 (PDT)
Date: Fri,  1 May 2026 11:44:48 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501114447.2389222-2-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
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

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..a82d0cd22a17 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -675,14 +675,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
-	case FFA_NOTIFICATION_BIND:
-	case FFA_NOTIFICATION_UNBIND:
-	case FFA_NOTIFICATION_SET:
-	case FFA_NOTIFICATION_GET:
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
-- 
2.54.0.545.g6539524ca2-goog

