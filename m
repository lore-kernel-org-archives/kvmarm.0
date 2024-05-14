Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFD51D55D
	for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 07:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715671385; cv=none; b=lvIhnSkEC53teyo7G6iZx+o3/ms5FDaA4+hmzhPWluGmFPK4dAIIvfRtPS/hPDLjCi08bAdlyWIgFZYFSbhH41h1jGT/aM929IFSRbQj4c9JrlYLBxxYGeCMfHn2FoZcF7CAb1CJNVCc/FLrU+aDatmrueOlw1U0Et2BndcwveY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715671385; c=relaxed/simple;
	bh=9MRXPzUlRAYo5pzAwRVOa5w1gi7ImIRMKYnxTgHh0GA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hgzMvjO0banDJoLlWlFYj/4plucJWQ7VPRSo0XcgXL2L56/mskeOJJvwKkT1OOHcsIUH+5ffK8FheTV7fhoX1+BPqGFrTmt4ExJDxemzk+37DC4tvKxiRWCdfriNVaxdeoaIvsjVgCju0gYYJ6ywsF5WwILYqt+2UcRQq6YKu9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTWiMIUb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTWiMIUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715671382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3QF2HJKGNlPys8wAxT2FA9PPh0N4R/xH1MiJB7dYGCs=;
	b=DTWiMIUbhZOLzeqLTKxmrri3DiLj3tDrglUmw8jXg99R51JYl0alam6GZFI4s9TeiSTEFo
	XyEbr3AR0ZKYYaJOI8BwPn6cj++VBeW4aFVjC/sy5hmtisx2nASabwF83eyR4hKqzLJvHe
	NUnhusLH9PBTJrgAmaqToS2ar2NVK44=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-dPM4fbkiOwmCo4E0ZX7--g-1; Tue, 14 May 2024 03:22:58 -0400
X-MC-Unique: dPM4fbkiOwmCo4E0ZX7--g-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6a137f8fc62so67611616d6.0
        for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 00:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715671377; x=1716276177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3QF2HJKGNlPys8wAxT2FA9PPh0N4R/xH1MiJB7dYGCs=;
        b=jx3XxPV9L7DUA/2uPzPObO1eT3byRkzNEMIa4RGpZeokHmm8PrOxV+jMK0fEyDJ0vZ
         HZovYI5zkV8zLBM6Q6cxpNBz7pK2P/pjCSvGct6ZdhGDQn6BDaS9fbuon6DDSFYbihwa
         NAIGhGoCRGtV8LwF6bUeybFPSZF2zjINOh7g3wnM1Bk1YdVrZiU4Ux3vkR9JWtf/Exf0
         dofmuXFxFzGnuNiY0bFnf4w6+cKzSh+/PGkvo3PUKM35P2rFIXCk8RHGDZHkbpr46jZA
         Pf9QrZpP3AgtP6zO+10+XbTzDwO3qguT9N6JXIHjEtGI3nRjxsUh2mpwfP2iSc3vtt+5
         RY0A==
X-Forwarded-Encrypted: i=1; AJvYcCUaO196/IXAWgwde9Ic48lxHbpDF5ldjkVN09h/0ruFI0fgOmHJHOLtQj0i01QyoPiEA+PR/nYfckuVN5AD0ITy3hZxEIdM
X-Gm-Message-State: AOJu0Yyc5YhVoBFfEF4N4fGjUnijsYama6S2hyW24UoIiKE/1aUAo1Zy
	U4m7qpl95cRV8OZjJ/FbkV6HOycoecunmddz/YugXqrkaIuHV/o22SiHO4V2uEoL23REiPhvsOS
	qk1QFCAxv71sACKEzU68y6Yoo+i90xhUo1GZnDNtV+yR4pjgDa2kwUg==
X-Received: by 2002:a05:6214:5909:b0:6a0:5a42:9626 with SMTP id 6a1803df08f44-6a1681a15e5mr141243396d6.31.1715671377518;
        Tue, 14 May 2024 00:22:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaEUQGOEUQFnDZDXr+zdvWksst8k/8OEPh2kWOkvqabpndfzr6LB5yQPavrrmvQuSu19lXtg==
X-Received: by 2002:a05:6214:5909:b0:6a0:5a42:9626 with SMTP id 6a1803df08f44-6a1681a15e5mr141243316d6.31.1715671377176;
        Tue, 14 May 2024 00:22:57 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f1ccd4esm50917516d6.97.2024.05.14.00.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 00:22:56 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 0/6] KVM: arm64: emulation for CTR_EL0
Date: Tue, 14 May 2024 09:22:46 +0200
Message-ID: <20240514072252.5657-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Hej folks,

I'm looking into supporting migration between 2 Ampere Altra (Max)
machines (using Neoverse-N1). They are almost identical regarding
their feature id register state except for CTR_EL0.DIC which is set
on one machine but not the other.

CTR_EL0 is currently marked as invariant and migrating a VM between
those 2 machines using qemu fails.

Changes RFC [0] -> V1 [1]:
 * store the emulated value per VM and not per VCPU
 * allow to change more values than just the DIC bit
 * only trap guest access to that reg when needed
 * make sure to not present the guest with an inconsistent register set
Changes V1 -> V2 [2]:
 * implemented Marc's suggestion for keeping registers consistent while
   not breaking userspace ABI / expectations (I hope correctly this time)
 * keep the shadowed value valid at all time
 * unify the code to setup traps
Changes V2 -> V3:
 * rebased to kvm-arm-next (to include Olivers idreg fixes)
 * fixed VM ops trapping for non-FWB CPUs
 * fixed writable mask for CLIDR_EL1
 * re-added manual ctr validation (using arm64_check_features() had a
   side effect with the way .reset is working for these registers)
 * added a testcase

Thanks,
Sebastian

[0]: https://lore.kernel.org/all/20240318111636.10613-1-sebott@redhat.com/T/
[1]: https://lore.kernel.org/lkml/20240405120108.11844-1-sebott@redhat.com/T/
[2]: https://lore.kernel.org/lkml/20240426104950.7382-1-sebott@redhat.com/T/

Sebastian Ott (6):
  KVM: arm64: unify code to prepare traps
  KVM: arm64: maintain per VM value for CTR_EL0
  KVM: arm64: add emulation for CTR_EL0 register
  KVM: arm64: show writable masks for feature registers
  KVM: arm64: rename functions for invariant sys regs
  KVM: selftests: arm64: Test writes to CTR_EL0

 arch/arm64/include/asm/kvm_emulate.h          |  40 +---
 arch/arm64/include/asm/kvm_host.h             |   4 +-
 arch/arm64/kvm/arm.c                          |   2 +-
 arch/arm64/kvm/sys_regs.c                     | 210 ++++++++++++++----
 .../selftests/kvm/aarch64/set_id_regs.c       |  16 ++
 5 files changed, 197 insertions(+), 75 deletions(-)

-- 
2.42.0

