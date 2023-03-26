Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A9A372
	for <kvmarm@lists.linux.dev>; Sun, 26 Mar 2023 01:19:54 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id y15-20020a62f24f000000b00627dd180a30so2626033pfl.6
        for <kvmarm@lists.linux.dev>; Sat, 25 Mar 2023 18:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679793594;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4AdblhZEHm//uRFsWabYDVuAv1CTU23Gx2a5/zWd7Zk=;
        b=fuP6m9MTHjiXuIxZrs+rh6MP6B5q/xQ2kqA0PIoEZ2Kc1YPpTzP5b7EJnxJ3DSRVDw
         oVcvFgbAAe6sZh/yB+8/Z4WXOlyqNfZRD5yt9ZlfYVBhz3csTlZbTg2KWt+EG5V+A922
         G4bgNh8hJCgy3RWhR9YJS3yxCcn/HxqWyLBiWa0xIKW+FSs9epyTryCmfhYkgK3xWVUX
         9yXZR7ynRBuibZ3xRX0Y7208PLarQk2jiF7Y/BItI+43QnPgzHAG29hHauGmuQvcBfrF
         Et8CKAUS3PMl3vjiAfEIo9+Ar5b9YDUxPnn9Ajrm/RSJWy3v/2APdzpvkCrm478le8d0
         Qmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793594;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4AdblhZEHm//uRFsWabYDVuAv1CTU23Gx2a5/zWd7Zk=;
        b=ql88l6LC7KeCx5Di5l9PH90wA7r7sEMqe5gZICnliDmWgg5GyDQo3bMPG+5f2yHF8N
         wkGN2/9nC7Jom3kuASeKedlANCcVx5+zlumC+EvDsCWBnytXFDiTPMU1ggT7VIxBKzzq
         MS25mgoIaREC3flf/s2keCZkpdfWqttBm4a6vNknbSg5cSz9c1cjeF4yvoWM7/vN0Wdv
         iYdmrF37cfkD+iRPnHt7aHXfOB8JW9uZa1plq9NxMGQ/2I7UVo5YF9RP9S6skxPbG3IN
         aGHVaYn9kKWbJ5yMIKlTh15twbfKSRfZvG44m2R6nWjMSQFqVryUMaBMcdQBqDXw9/WP
         LbDg==
X-Gm-Message-State: AAQBX9c9woEGJ7kwIF9UWIAMzdIbAqgpnHKDnCwG2ZANEEffyE/TpM9Z
	LwclzfBgAc1kII6pm6m/qOYxVPfuz3Azf5qTKQ==
X-Google-Smtp-Source: AKy350bE3Sf1p2xK3QENi7/awHWmwhm0zLowXbSZSUe3G/TX+QbyZk6Fvzag/iBkznD4HhUrxqLGGHPAlupyq9aHLg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:4955:0:b0:50f:8d8d:60f0 with SMTP
 id y21-20020a634955000000b0050f8d8d60f0mr1867213pgk.10.1679793594164; Sat, 25
 Mar 2023 18:19:54 -0700 (PDT)
Date: Sun, 26 Mar 2023 01:19:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230326011950.405749-1-jingzhangos@google.com>
Subject: [PATCH v1 0/3] Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series is based on a previous patch series which adds the framework
to allow enabling writable from userspace for CPU ID register easily. That patch
series is at https://lore.kernel.org/all/20230317050637.766317-1-jingzhangos@google.com.

This patch series shows how easy to enable writable for feature fields with
dependencies and enable writable for a bunch of feature fields in an ID register.

---

Jing Zhang (3):
  KVM: arm64: Enable writable for BRPs and CTX_CMPs for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for remaining fields for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for all fields in ID_DFR0_EL1

 arch/arm64/kvm/id_regs.c | 45 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)


base-commit: 020e96f196a31bf5c5aa2549cdfc4a401a8cf478
-- 
2.40.0.348.gf938b09366-goog

