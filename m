Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CAB2040A7
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741095834; cv=none; b=oXp0wUXLx9ITehJwu74lVSHK+3FPgnrnAvP8b67kl4kkfKb6oMpBK4yozJCaGAraEBfzp6FTE6EhUJ5eRoKfCI1v6aHYrHTC+JBvnax44V/OgDRfGptUmjzIJISUfy5V4N/aC3GNS+WtcEmiu9spF4NH8xOH9In1SCFwqY0CEuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741095834; c=relaxed/simple;
	bh=80+eCrT6Rmn5Jg/jRx7FsLXSYZEFXC8qPz/qSbLB/YA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nG9u9qGPKLxrYBmbpN18NgAy5dJZ5/r+LrqpKn0Q6QZK0K9r9af9oPUlQASzkdpB2dhgnuM859mDJllUtNoqk+t9dL/o4tZ5OTEuh7D3lCIK23T6Mgbjb8Ji9X72jGNIx2G9AIpyQFnK4Ab+SZlnXO3Uiz0kF8GJoBTmnqJTT3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HcBjHu3r; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HcBjHu3r"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4393e89e910so31194675e9.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 05:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741095831; x=1741700631; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uj43tHXd4oUvGh93mFvuqSAi4hbUgB5iGKnK2cXXgbo=;
        b=HcBjHu3rAzRC4Lpz6GQQnfSVvCOHcp194352jcC4s/r+UUgwO784hGgPGlEjXV/j1e
         0yIhER1ARZB/fVxm3nPhus4uzCCwf/tKotEkAfrbspNUzoHLEuxmjFv7qrgemAQjriON
         gcKzndoTaPT+8YvPjZIa6/fdj0H/5SrLnzUylAVbCAmiBeomjgW++vz6zIZsO6asF7Id
         Qk6MFL91GPZhbXjj4t4LS/6qgG9aQpyuK0q6rd1SKCLZUrOuFlJVXRgaDIOSqXQt2AxX
         dnpjce1aI7y1bcTWy8ctkCZrLkYZ0dFIYrnH/1deVVqmqNs1n063qOsf3mrpxPJ4YA6o
         vgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741095831; x=1741700631;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uj43tHXd4oUvGh93mFvuqSAi4hbUgB5iGKnK2cXXgbo=;
        b=hHJ05tx5Uu6TUXoo5cSQFNHEnA7sP2LhhQmnDKKnqcghFtA0l5xZmRBU6cQEBG/CV2
         ZCvSUL1oBg0fwXQTCbmlkyn4t59gYK9PS4IVugf2XAeeRJ87O+BGh1stHp/qJBd9eXSi
         P/iTvctPM4RyFWElH4P3siSH8B/obXobIp6f9dFAGniTd8ni4yahRafljFKuAe62o5Ui
         PKB+50lqG8X9uPqmzbOtxruDyj2KlIr90vAkxI715sHUafsiDpxDeoE+GE5T5O6ztNt2
         4cVLtyU/xWrO8f19zjqegxcxNqbw6IXqWTFi25JOw7ojPuSVa9x3zVUk1n9RQxGj936x
         EmQw==
X-Forwarded-Encrypted: i=1; AJvYcCX+Mj0GD9ERMbZF0ppxTrnnxFYQBs3pQFNZtPtiOBxQa2Qm7sk1l9zAFDRqn0VHTlZ8AiXCWyQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4Nb1BOmewwvLuP4r5jYKLya9ljolG5TksBlsJ8hSJURGjFX8b
	SLmhK33PVdKu89dVZmQCcDB/GUzKYH+AXtsH2kZr67fixYQsZJCmB29hBvRatS5VOaDrEIkYZyD
	mHZACdTtThr7+X0k45w==
X-Google-Smtp-Source: AGHT+IFG5YXAtgs7Ad4x4+52R1NyxCiNTd9hIFuV0gbUB92z2vGjINs/6+xkAMSQEv2wr8uDuVNZWAe24g0ESfG4
X-Received: from wmij20.prod.google.com ([2002:a05:600c:4114:b0:43b:cacd:235e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c8c:b0:439:98ef:5d6 with SMTP id 5b1f17b1804b1-43ba6766cddmr131565855e9.22.1741095831304;
 Tue, 04 Mar 2025 05:43:51 -0800 (PST)
Date: Tue,  4 Mar 2025 13:43:43 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304134347.369854-1-vdonnefort@google.com>
Subject: [PATCH v2 0/3] Count pKVM stage-2 usage in secondary pagetable stat
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This series allows to count stage-2 related memory when using pKVM. The
value can be found in the /proc/meminfo field SecPageTables.

Changes since v1: https://lore.kernel.org/all/20250228121355.1377891-1-vdonnefort@google.com/
  - Flags to kvm_hyp_memcache
  - Separate stage-2 memcache
  - Account for PGD

Vincent Donnefort (3):
  KVM: arm64: Add flags to kvm_hyp_memcache
  KVM: arm64: Distinct pKVM teardown memcache for stage-2
  KVM: arm64: Count pKVM stage-2 usage in secondary pagetable stats

 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  7 ++++---
 arch/arm64/kvm/mmu.c              | 18 +++++++++++++-----
 arch/arm64/kvm/pkvm.c             |  5 +++++
 4 files changed, 26 insertions(+), 8 deletions(-)


base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.48.1.711.g2feabab25a-goog

