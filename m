Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF54E3D75D0
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779578; cv=none; b=hbmPhWC7CS2m6w/48bDC8w6Pw+MKpQ1fg1V6c8LGuDQQTcz7u7DUiYtmr0eFiVvbP/PvvRaBGU5SmmW3dlyu68u188+04ZaRWoMDvfQnmgjPVUouzpxKntwBpNgFlMf1KcmBGIELwf1Or0bHZyA3mRg5jmAw71OEWRTKQvhf7B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779578; c=relaxed/simple;
	bh=r+WwHEnqkbBMU0GIdnMgG7lQPhDE+bh/j2FW8OmYQ3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rnq0EPtAWchJy1lguZpep39UP4qkEc/zEzCrR2QmYCarOihp973o2XYsn+go35eZHcIYOauUGwV/mhSUBQu9LDvzahkj6xczgByx7dUYxFG6XuZ7i6Qq6H9VB8RXAED/BvkFH+/A8LTYUcoR/iM+238/mv076m7m83kTmhOHa6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hh8OJUln; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hh8OJUln"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d95017a68so2805273a91.3
        for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 06:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776779576; x=1777384376; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0u/vOf9MRjGdS+aUvxA7BuDlL6EoYtTCq2GhHcWAQUc=;
        b=Hh8OJUlncajlgb+Kvade+gdZsK1nJgQVi1FBBC0VCGPW6Wrs3hcHS+rMD0djkidtnu
         Y+HX0qabwU3wUdnUNmSZCPt1eF2S1UXdM6fsMr//6guw5/ZCuyIEKwprHpq3gQwvtA1k
         Vs4cQ+GbuQukMoCEV49GHK1PPEWlng9HYoihTuF+3nmb7mlsXxQqQFPzFs/VE8jR9gas
         q9ugyHz1aUOMM38quS7MfrcPLGe65Bni4TzwQ4TzAD/xt88uhGfVTOE2Mk85wHz6pUdx
         jpRShJDsEvEka0YMJM37jAjm8rYoaQ9ZzK5jijZnXoGTT0jySB/J+xmMMpJDBMBr6Gjv
         xppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779576; x=1777384376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0u/vOf9MRjGdS+aUvxA7BuDlL6EoYtTCq2GhHcWAQUc=;
        b=p8qV/ZBK83DpDMSeVDBEewYvL4KBjuAiXECxf2af8z8R8Q4qezbn6tJmM15FGlMn8F
         ZucAQfaUrQpoMelvsXvcImCm4MAmaEn7kGAYyVbv4QLQqlBNnxe7elHuh7JbwWYTErxX
         Khg5S+tbbJAMk8Ca3wlIw7Q7u2jyyFxLx2Oa7gZO4y+6y6CbDoMMZtZZwjbGdnL+3ImP
         5ebhRohNBHTBaGbbLZqRN61xrAptKDwkbY+UBtFDAju+AV+fbltljAVDTEEP95XDwk7J
         w+EHtf7q0dtWB8g5ru+vrM59LmLcoEACpq32p+WrLcZMhEDcJIsnAnjyXHLm92i+UQow
         V6QQ==
X-Forwarded-Encrypted: i=1; AFNElJ/KD6rMuJRUWuMNNb5Yr16TVmcVBQpLKyu4X9Os0wgQlCGyRSYw8x/HKXpp0BkG2Nfz0Xe1an8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRoD/dR9MUCF33a6+SnWzqxwrWXjvdcRg/+ultle0gXp7Xobss
	OqozdQHGqVlcV8lE/satdigapACdwUlka2MDxq97ORfL617Uu1YDjezN
X-Gm-Gg: AeBDieuvNG670clWiQ5tVUJ6R74SfEZJ9gRLtPHahl//+hBuR6rGNc4mrxF7NTHMhKB
	f7fnL+f0Co5veug4xJRTr73zQ4Si21ARlujdHiJY5LVsqcZZA36RV6diPhhh/rDmvCUoXOUXNUz
	lXIa8bIA15IhqpTpTQjRqoMp7eJoQaDlnyC41kiFb4lAjzNJKb23gnIcm+B9ah85iTP7DS4p99G
	uwzY6Ud4Zu6QnZBOU5oL0LkiE4E37FTQzbU86jgBru4ifYyUa7QnO+m1/GbIvuQFHEhK0SGVnhR
	TywlLFQ/4TEV3TOxngE9NL+qMFSm3nFTipOtEHG8Dz58l8AOEiC5KWN4u3QR7eiCemZDrDgiKQ9
	Lq4YlFHUzDDmPMVtAwukVALjgBIF7pzJajdI76gTDviyOxgPAsmLoyh3r7CNPXvIvlPYTCp0mFQ
	sXk2n3PiHa/DP6HoWPhhwLSs7vS/QA9ptRmDSFNrpO/ctYpdkYqX6HcWM=
X-Received: by 2002:a17:90a:f16:b0:361:4521:d311 with SMTP id 98e67ed59e1d1-36145221bbfmr11784735a91.18.1776779576240;
        Tue, 21 Apr 2026 06:52:56 -0700 (PDT)
Received: from BF-202508301248.localdomain ([39.144.124.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa33486sm165571555ad.33.2026.04.21.06.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:52:55 -0700 (PDT)
From: Jiahao zheng <jahao.zheng@gmail.com>
To: steven.price@arm.com
Cc: alexandru.elisei@arm.com,
	alpergun@google.com,
	aneesh.kumar@kernel.org,
	catalin.marinas@arm.com,
	christoffer.dall@arm.com,
	fj0570is@fujitsu.com,
	gankulkarni@os.amperecomputing.com,
	gshan@redhat.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sdonthineni@nvidia.com,
	suzuki.poulose@arm.com,
	tabba@google.com,
	vannapurve@google.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
Date: Tue, 21 Apr 2026 21:51:45 +0800
Message-Id: <20260421135145.14789-1-jahao.zheng@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steven,

I've been testing CCA patch series and noticed Realm VM cannot boot successfully when the host is forced to run in nVHE mode (e.g., via `kvm-arm.mode=nvhe`). The kvmtool debug information will be truncated in set_guest_bank_private_gpa. 

Currently, in `kvm_ioctl_vcpu_run()`, running a Realm VM (REC) bypasses the standard nVHE EL2 stub. `kvm_rec_enter()` directly executes the SMC instruction to transition to the RMM. Upon returning to the EL1 host, the code falls back to `kvm_vgic_sync_hwstate()`, where the VGIC save operation is explicitly skipped for nVHE. Since the EL2 stub was bypassed, `__vgic_v3_save_state()` is never executed, and `ICH_*_EL2` states are lost.

To resolve this, I have a couple of thoughts:
1. If Host nVHE mode is not intended to be supported for Realms:
Since RME implies ARMv9 which mandates VHE, running a Realm with an nVHE host might just be an unsupported edge case. If so, we should explicitly reject RME initialization or REC creation when `!is_kernel_in_hyp_mode()`. This would cleanly prevent the undefined behavior.
2. If Host nVHE mode is intended to be supported:
Since RMM should remain agnostic to the Non-Secure VGIC states, the burden of saving these states falls strictly on KVM. However, the EL1 host cannot access `ICH_*_EL2`. Therefore, KVM needs to add specific logic for this scenario. We would likely need to route the REC exit through a dedicated nVHE EL2 stub to invoke `__vgic_v3_save_state()` before dropping back to EL1, rather than jumping straight back to `kvm_ioctl_vcpu_run()`.

I might have missed some documentation or comments regarding nVHE restrictions for CCA. If this is an oversight, it would be great to see a check added in the next iteration of the series.


Thanks,
Zheng
