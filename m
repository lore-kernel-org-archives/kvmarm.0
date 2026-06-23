Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE8D34BA50
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215648; cv=none; b=GpHXqVz5QigHBxmmgX0P6iwkmYxFLVsxBQti3Ledk3VTtGaU5bdM/Uyo30heGlTgTNwcsk5z35PjalUsMCrvO7pqnEmUsQeTfflMpV4a9xHqCyCGtOd0HznNt2ni+qdjWNUNKFlF5o81O9nUAeZmQL/hjKKHOYbx2MeQSMQjXa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215648; c=relaxed/simple;
	bh=JZANyJc0cATAWBETMqgz5If+U1U4yoqB04drXi4iBcM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=B2FgNpLG7cXte1/iFXeX9wuGqDPSY60iMy3eHxxLCXdZqWilTtmVFBLao1lV0eN7aAN2GkRP1JlBTAczi3/hWQVtoBASROkYd3ho/CmyRH03xIui9nDXQXuD6uwKAnOEhpu1Gl7YcqIp1zO1Y5i94a3xoHPWOYJVt4wneTSlri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=By/VyCxL; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="By/VyCxL"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-46ab0ea1f72so624510f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215645; x=1782820445; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pQYTCkieiArSO8QgN3A7DsdongSxCEFY2bYSSqBfmwY=;
        b=By/VyCxL7RX/aiLtGwu1j+bYm8F/xIBfQG6CBVFn2rO/7TF0J18/U2uIqq8lO5w8W8
         TTrjoAa+cVXGtYgjV1YeTMhpyiGQU3gnqxmqFA0qRiQsYsTbUnhl084kQJPzMBZq0WWY
         5ryOyi/mlmzoTjL3c5pcSV/DMuQvYpQxFleBD2e1EFLjfzzL87lF8aj6QkDuFBD9gQIK
         7dJ7m8dkplkWrqeeNCdK0cEHPmdawI1uEf5/+006oxUu8vBPNSRRgCknhg0pvlTCnOgN
         79lKVe784oo6KStbcHmn8W/1L6WXfZvaz6bCd5Oxg3DPEQ3hyispnPv1fLifEVPn+47m
         2LQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215645; x=1782820445;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pQYTCkieiArSO8QgN3A7DsdongSxCEFY2bYSSqBfmwY=;
        b=V6H8AbHhB8th9ydVZ5dimEHma1ZTLALg/SDhlBcjqCrDdz+xPOlGzzBvQRuj4bnOMe
         A2PDNPojm6vU/QrT79aiPCh37fSFh5jdYWzk23RsCXlQN4WXE80P+M+rKxuEWqlh3cNe
         xGqMgf6Eaymf6I4/B4EF6+TxEWLvxXyBJeaiqyiKkRqFJf3/mWXyYZx4RwxbrZAsRdr8
         v2u7syS8zt/Q7DKQDjmDTA6zwrULldoAUvKIQNiqikgOE9jJ9zUMFcQ4IGebMxQKHPAM
         QqOFfBfctc9vZ4tkHXplroJZTwvLG05tKqDpGBE0/spPRyy5yr+9V3yMA9SFWUBiRDEb
         fcmg==
X-Forwarded-Encrypted: i=1; AHgh+RoEp+phW/eRpmKv+u1LJ1xEroqo1YOsFUcl39uX98UZ3bWj1rCl9CSDywUJ56YAAEiqImkSX5s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQb0C+BJ2elprYaBk3XqcECpY7dOn/SQBQryQszVXEByIvWvGy
	5l/i3IBMLgeLIAWIobIsIkqR63vZCUi/ekhcJDMEXF6l0I/MQmgTEFHKi3ZEH0qUNDSH5538Bxn
	EU+T8az+1iCC54Hx2mGUpDCsCaSfgbA==
X-Received: from wrql14.prod.google.com ([2002:a5d:480e:0:b0:462:257d:36d7])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2902:b0:468:b71a:6efe with SMTP id ffacd0b85a97d-468b71a721dmr14364108f8f.6.1782215644532;
 Tue, 23 Jun 2026 04:54:04 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-1-sebastianene@google.com>
Subject: [PATCH v5 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
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

Link to v4:
https://lore.kernel.org/all/20260616154149.2763214-1-sebastianene@google.com/
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

 arch/arm64/kvm/hyp/nvhe/ffa.c | 219 ++++++++++++++++++++++++++++++++--
 1 file changed, 211 insertions(+), 8 deletions(-)

-- 
2.55.0.rc0.786.g65d90a0328-goog

