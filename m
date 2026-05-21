Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A103CB2CF
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374004; cv=none; b=X/BW7TZJk+X7Y4ZM4HWpW5Z7MJr2Hu4p3v2yNCsTgh1Lhl+3QDzKY7U4BUINCNuC6hLRNlotdIPExgxwuBtOaBDnREW6iTOhsie3yvc8oyy7VEvcZokinyWxadDerqZmBXSj2cLBPTim3HftoqkaROD0HDBI2TgGcInIUq8hc+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374004; c=relaxed/simple;
	bh=LV5hpR3wnVTOnpwr5blEOSQMuQ17TQTO55CG8gY7q5o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N4p0HBxJgMZA/AdGa46OdFn3geD/0j2UxKK+z5fLavWIFxJwdLLz+Pb1xc8HNyfqeMyqZE2AFVB2ekUDXwzFqw6T/XLmQWZjkbqQtVcinnwbHTOCQ4ZK2QIGnyUTx5ruYPbnkSrEZ6otu350KOvr5JXAuDi6y8K6nFGEySxLnqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RX+rPsRa; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RX+rPsRa"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-687157a1739so2501194a12.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374001; x=1779978801; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D6BscWoRfoF5G2iEIlMgQxNFZ2Pew7ZRjTmGHaq5Wuo=;
        b=RX+rPsRaDJVCuoeTSfWmyVwC87Uo+Uc4gF9jVJujSyP/B3HcP+hY5app+BDLfS+R1U
         VA7p84DJSvkJWoSBn8afV4uEGX6u+xs0T10Qvc4qEAm/Pb8A+DzBG5OPgEWpzousLdpp
         uUYrJG/U1Wj8y0g2649+NN2j1zIG1mHp7/qVESEKmKzD/TAOaCypBYMeNQYGDmgWKwLq
         UIB/nNl3nbRNCROi4lnABm9adCZ0ln0ch0mDTxwS8B4agALWDJXZmiDBQgvXBiS8689c
         3heaGeCbOHWIyURV8uG36E514SDtuRK17DaFvM0sdDxUTrvR+UVRPxbNeu2ySM3SZxQL
         yL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374001; x=1779978801;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D6BscWoRfoF5G2iEIlMgQxNFZ2Pew7ZRjTmGHaq5Wuo=;
        b=Ly2bfykd0jk54Cw2zwu1jLWfIalmEy60uCZy/drPxnFcaT/5PIhMoeTijQjyq1wH5z
         V/C6vTQJguHOWYlVNXNOzCB/fejQ4HlLAjK/3qr1X52INCuvocvs3uo5VgtFRD/QU4Tv
         MIsJc1SK+FjR+DqZ0NY+w+wc5z5WYpz5K8clFRW+n1x6xK5e04LKMy+oGekA5+L/riwZ
         LXNQHk9hIeKaytdoclYO2jT/Vkx99f1lpD4l2mSXX1om/7HJl7b/0W02PNPmTJZNmHX8
         pFuz2Pd79AvkybIDaegiZX1pezDq2e8MGLi+gY8uVGOf0wA/rXZ1t/IdBIQYS7gsN1RV
         eAGQ==
X-Forwarded-Encrypted: i=1; AFNElJ+qIPkqM5qyDPuZqdgyDPF49Z/O5xm/1+SYyPJp+Q4V46JATCUo1P+3VXWCfE+F4hHsgWhRpmw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhIRjHTa5sqiaV/n5X6jR1gvP2Swn73FPJlhJsn0RGCWe5teSc
	GaaXfb8+Q4EKIMAnBY/UWNevTxaesDKaEjMCoWYRDMIQfiSgu0hhbemoYD5/Q9ucFEkG1rXLOf7
	xEzGnnLGM+QYo34Azxrp/WQ==
X-Received: from edyc13.prod.google.com ([2002:aa7:df0d:0:b0:67c:3c95:d0cf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2694:b0:687:cfde:ddb2 with SMTP id 4fb4d7f45d1cf-688361e0fc2mr1758793a12.11.1779374001206;
 Thu, 21 May 2026 07:33:21 -0700 (PDT)
Date: Thu, 21 May 2026 15:33:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521143318.1002172-1-vdonnefort@google.com>
Subject: [PATCH v3 0/3] Fix __pkvm_init_vm error path
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko reported a potential refcount leak in the unlikely case where
insert_vm_table_entry fails.

While at it, I have added a fail-safe to __pkvm_hyp_donate_host to ensure this
function doesn't allow leaking refcounted pages.

Changes since v3:
 
  * Enforce order-0 for external pages, making the vmemmap ->order field
    completely private to hyp_pool.

Changes since v2 (https://lore.kernel.org/all/20260521102149.804874-1-vdonnefort@google.com/):
  
  * Proactively init hyp_page order field in hyp_pool_init  

v1 (https://lore.kernel.org/all/20260521081250.655226-1-vdonnefort@google.com/)

Vincent Donnefort (3):
  KVM: arm64: Reset page order in pKVM hyp_pool
  KVM: arm64: Fix __pkvm_init_vm error path
  KVM: arm64: Add fail-safe for refcounted pages in
    __pkvm_hyp_donate_host

 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 35 +++++++++++++------
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 21 ++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++-
 4 files changed, 45 insertions(+), 16 deletions(-)


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.746.g67dd491aae-goog

