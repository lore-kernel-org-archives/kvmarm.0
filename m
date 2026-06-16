Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC6A211A14
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607266; cv=none; b=vCsYtmTe6BFb5J31nvg9dV/TEt8wJNvQ1UDBP0vEkB817EdMjOmV6OmnuGLPNDZGXyhC8sQGd6fvBjMFo5RRylvni+ziKbvhQeH+uQx0//XiX1d1yUNt8/vSRuhrdurRJhhYn9SZeoF9/lbe6+QN8J4tBRrJo26Ez99kDHD0xQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607266; c=relaxed/simple;
	bh=yo1C7Hud/AvWo2PT1z8B4266fJtRMwiYiQVNqQO5DeI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=t+lLyyfr7VS1NJ5sNFPCtU+VcprE1CqS1F6euK1Iw9IFUSQTw+D/XngyNhkf8wH9dEdDNhCcmhqUEcd2dpjtvIMf90OaC38uoZuafci5uYALkP+UOVq1QtiKRIv7A57ISzKZNBRq3A3hXIioNd8CgCucyQgaUnw6m7cA8K9Ck4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ft8yK1nS; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ft8yK1nS"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4619e150838so680456f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607263; x=1782212063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FV02eNruyFpNY0VqdlUhlXmfFOP3V4dDqxbZnj7/URY=;
        b=Ft8yK1nS3N6idllmDTaEEUveu/2zgH20VUtiNK+4iSUhg2enes+lbfF1AuzbHnREGZ
         6yRWICwZLN2cPk6IV/PTCfJHKyZ57OqKFdO1ap3sFk8n0H7QVqXHrXL1vgqKJaUqca3L
         ovUmp9Z87YIFV71bNubf76k9zbdftltH6d+gwh85PmzVKN7ovvOAsiUn0gokZbRql2Q3
         H9uS+NvnEPUR/+Hw86onlE+YPaBJAsDN4uAGUYiP172ZMf3umYgnjaDNqU9MFINeB0wO
         rgPtDd1MNhuJhxCOGXd09pepXEBIUSjZYNxLJz1UXyt/yvVvle75J2QQBJADwDFEYxrJ
         t0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607263; x=1782212063;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FV02eNruyFpNY0VqdlUhlXmfFOP3V4dDqxbZnj7/URY=;
        b=Iyxy9CJUmvf651c6Oz3/RaX1cThwT2BmECe9XHdjq71mb1ZW3aMeMzGPD+7sYUTP+d
         3hZhN42zOF9v83djNZqxCD9KocLAXZUmWcXU4aVN98x5OMi1iqPAg43/3102fMPbzN1a
         U1TEmYJdd/9wR+k0APIkFI1ySzjjeaMFBA5HdaGJK/TvuJTdtUXP4KpqzKjAvNkuQHEh
         OXaUlVVQbqlnZRdXFZ6FvhbUzskiGkHaXm/02jWYRObj1F3BNLvHofOmKV+9Bz+uTEZj
         cFGL4tkppc4+mJn85H/vx9524IvqmrvAKe+ssHnRfQ0s5pFHFrZHd206e8Sp0w2Jl/HS
         ni2A==
X-Forwarded-Encrypted: i=1; AFNElJ+JJrmBlCB2rUc1FDxsv4G0YOIU46cNFy2OGrBDflit2r9X1+jOaOrjy/J3DBCFPuQMZbdaV5o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzGbkIaaXyUVb76mOcx7mU/CkeIW69dPzlaAOnbwqmfIcGqMB0
	+60PElfB2b9xmmceNzbpANVj4UVoLmzs5LiQ4DGSj4rf5YSsZlQ8h7IzoaLshJKuhEfk1fCNdTi
	VLx9BJldu5cInmOnjADMlwZ4mA2Z8JQ==
X-Received: from wrqd7.prod.google.com ([2002:adf:f847:0:b0:451:e1c2:5b4b])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2883:b0:45e:f8d0:d22c with SMTP id ffacd0b85a97d-4606dbde14emr27992139f8f.25.1781607262521;
 Tue, 16 Jun 2026 03:54:22 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-1-sebastianene@google.com>
Subject: [PATCH v3 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
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

 arch/arm64/kvm/hyp/nvhe/ffa.c | 205 ++++++++++++++++++++++++++++++++--
 1 file changed, 197 insertions(+), 8 deletions(-)

-- 
2.54.0.1136.gdb2ca164c4-goog

