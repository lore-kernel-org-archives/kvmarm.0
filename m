Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8009F129A7E
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419918; cv=none; b=Q1X6Q047s++Rz01ZsRpjJGg4OeZyM4wPbV7j+ZUoul5/z3bUkwGm4JLdzhHc4qNWapsmxcxzNdvHwb4jRO2WMXqOmP+ryrQFrGblj1/3oBma64omCvy2f74W0pgYthTBwn8zgCbPv7v8iT0Q4OEOm9qZqIEg9KHNrBb8ShOVdbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419918; c=relaxed/simple;
	bh=ZmgshMwK/h8YuHfgrohZ07iPt7cMhx0SOYi8UE3BetI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lR0vvORjmcTd7YzyGgUbGQArPUJHMoyADDHaXIRGXJtOadMPiwswxTNxEecgdtarVJrHpQhGCJ0SWIGjq3Aswzam0vpGOTxpCN1leU+L/fOup5zaOpLIaUOpIfQlB2jwGZTOBgVuKuY5sS4+5R1hRH/AbQH/Ydz4OMN3cA9UVF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gV4Ns0gp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gV4Ns0gp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UuAz2osHy9RXhO+JIQRbzgjz7RRp47pq6Qz525G205E=;
	b=gV4Ns0gpqSoXvkh+axqpG/0dE+pFxi5picXa3hXTmH2zezZt4eFr7LK8/XbDhd87ZwMd62
	Fo1KUYqmZxH+QfJCacHqiuJ075BOlAwv7cBWBGQfV8n/bLaFM9G8hHI+k14HU5cceh4peJ
	YpAoSf34SnSb4LfPgdBTl+y+esGQWKI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-y0kLCWg2PgKlGoOWLRKAAQ-1; Mon, 03 Jun 2024 09:05:14 -0400
X-MC-Unique: y0kLCWg2PgKlGoOWLRKAAQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6ae28390afdso70235086d6.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 06:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419913; x=1718024713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UuAz2osHy9RXhO+JIQRbzgjz7RRp47pq6Qz525G205E=;
        b=pu2ReG19zpOa9s0Dp2EyqqNuTSgu3rgEQ6jM7D14W9Fp3vhSmSHxzxVN/GeSOQEMib
         /y9XsQraCYFxwagK5w/oXHDCUDA93mGvKv2+5dC4vdRSU17rmipKuI84DAQoqztvyVTL
         AyH1QUNTDgHIFiJN1xjNqsk1F9u9YSuRVkMy2Ciyc+7ruZWfhnWCmIpbqtNsw+dJCIBl
         e8fkc47lu5z09Km/3fIYEU2/LccjtMbYtxTFB+Ji3hottbkH2d3QKjKDcwU1N6rrtgkR
         hgZ9qc+smbJlwbB8eIdhE+x5P5CZ2jyxZFkR3OqdcwT4RmSjoj9u3teR8ZeVq5dbEYOo
         q62Q==
X-Forwarded-Encrypted: i=1; AJvYcCW7KhJl1lYnOTiXBlhOwODzWQ09n+OCDV2Ao+WtR0xk7DxYT787Te/BMt1k+kE3ySXMEq/NcUwmrnPxQlhlfi2EWPmEnuh/
X-Gm-Message-State: AOJu0YxeFEyh+Ul60QNlHO32ckBLN4LBNDriLNk8Jk2tYo3IMfPpUIbO
	EhBjmqspqMFIC7f7pG+czCEfqn9WcvgszXVCx1QGw6wzSIb2cFR9vJe5dET1hcRtNUZXdj7Cue7
	nhN3UZltgruYpqacvFlIY/1/xEkvTpSsC981ysXyMSxX8GxlxS/p6PA==
X-Received: by 2002:a05:6214:4402:b0:6af:bada:7dc7 with SMTP id 6a1803df08f44-6afbada7ffamr49263696d6.19.1717419913557;
        Mon, 03 Jun 2024 06:05:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHENOGD7DUB04Noh/MHJb33d1NQPYihlzPMxsvVJEBOdeA1SEk/MwQVr1UO7l8+hz6gTZ3KHw==
X-Received: by 2002:a05:6214:4402:b0:6af:bada:7dc7 with SMTP id 6a1803df08f44-6afbada7ffamr49263006d6.19.1717419912865;
        Mon, 03 Jun 2024 06:05:12 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179f4sm30558826d6.113.2024.06.03.06.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 06:05:12 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 0/6] KVM: arm64: emulation for CTR_EL0
Date: Mon,  3 Jun 2024 15:05:01 +0200
Message-ID: <20240603130507.17597-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.1
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
Changes V2 -> V3 [3]:
 * rebased to kvm-arm-next (to include Olivers idreg fixes)
 * fixed VM ops trapping for non-FWB CPUs
 * fixed writable mask for CLIDR_EL1
 * re-added manual ctr validation (using arm64_check_features() had a
   side effect with the way .reset is working for these registers)
 * added a testcase
Changes V3 -> V4:
 * incorporated feedback from Shaoqin and Eric

Thanks,
Sebastian

[0]: https://lore.kernel.org/all/20240318111636.10613-1-sebott@redhat.com/T/
[1]: https://lore.kernel.org/lkml/20240405120108.11844-1-sebott@redhat.com/T/
[2]: https://lore.kernel.org/lkml/20240426104950.7382-1-sebott@redhat.com/T/
[3]: https://lore.kernel.org/lkml/20240514072252.5657-1-sebott@redhat.com/T/

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
 arch/arm64/kvm/sys_regs.c                     | 214 ++++++++++++++----
 .../selftests/kvm/aarch64/set_id_regs.c       |  16 ++
 5 files changed, 201 insertions(+), 75 deletions(-)

-- 
2.42.0

