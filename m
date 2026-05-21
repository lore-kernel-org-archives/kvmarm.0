Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C8D381B14
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 10:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779358928; cv=none; b=iacLbzKTVxs/9XoFptAz3NNaPrzAok3cnf/mbl6dqVvHetzmi7gT36nlYGzNgclC9kwHvpto7VD2Nn37jshFZOej+Iai7UjNR4CXhF5LKA+EGjimAL2jAionlaZT3IHP+2NoVN77V2nOrmEE+Z/NioIz5uTesYcYGMq26WgDWHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779358928; c=relaxed/simple;
	bh=BEv9I76Q/6wEik0veYQX8ayGM5O9/YRU2aCoUAhEaWg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mF8Y2AKLeLLR+18XTHwzcrVAfcBTgFJWO+GBDiozJ9Jt/m/AIyuySJOW8kw2UfvUBmxdz9J9xI8wDNfYYbYJjExgQgzgocssqoykPPRSj/nCk2MH23+IsrYguLnZPzawaT98SzEz/34b3LvuN38ONAwvLo737hmfweg2rX+G+oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PIcRbDBI; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PIcRbDBI"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43ff19e54beso3963220f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 03:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779358925; x=1779963725; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dUBZuTft07Gz370Ru/23Ib/O5tsFjxExNVXyt5Ku5SY=;
        b=PIcRbDBItPWkfIz1RYTvN0rTYoiBNsQEHrhrEBYsO0uetMYW4Yi8E/0Gx4vATXgYvm
         KeTwbW0kWu/FlVg/d8QgKICvPMfwxvFuxGA8kCeOQi0K5FhmeYwQUImCHJKHWswv7Ym6
         w6xxlJqiiBfD+zabD+cirq+xsYncW09s+Is0Zkch4+O+KJsq8jtt0cCfzyMGddYTsEM6
         HYUBJ+BQaAXgxmNpkYfSCdoJQNQ3KT9PRk30a6GoV3HVVBioX0FtMo6Ul4o42akR0szm
         GbM/sImDWhFSGcy0xqL0Jau/C5IEMK50WfNXo2F2JkJqdSLOyin8sdzWh56n0xpn5Wfg
         8WOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779358925; x=1779963725;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dUBZuTft07Gz370Ru/23Ib/O5tsFjxExNVXyt5Ku5SY=;
        b=mhrs/UL/oWC/K2PYbAVwW0/yRoWQCiXVDFMkIEKMWlpYw6VHDHzabuTyejVldz1V4a
         O6oRelzbF6M7TGfI3tv8MtWn4PCkvHxD/FPmDlCaI9swXHr74D0rQfbt8Dmsu+DyLj6B
         tRxRqZUeoZ1ZqADxWvylOcsgFoODWi/2bwZRwB5DySxLhCPmgO+PDc9v4rYvAteCPAwn
         ZLzSR6G3uZdWv096k4q2tyAmSlVcymq/eCuwIF1qTPXSZBZtPj2w4ta+gfof36IRcIfL
         7E0ZSk4hNp+GjjhErre8o+3GG4kKN8NUGi2MidW/WqQsm7E5Ybdm540q+wWc3tOKDQwB
         oDdQ==
X-Forwarded-Encrypted: i=1; AFNElJ8x/cV5Ts+AqUnl+KGBPQ8IQzRQM5aYtGVitFn0ZEt87C7VCdezXZfsbyEJiWioaLS7WL5FsWE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsR4zUbsVMov0lvRemt+izEy1fPvCoQtvB+uyZVqAKYOD2+GZ9
	YYh1Y6cyHuPyzdQ1sJPFoySdcyv+vDQVOa7K8Cufo/Z0aPoHRLyw08ITOi1OhxnxHN8b+qBnJPP
	391Ujs6mdjBLOcFLzjwFkBQ==
X-Received: from wrup12.prod.google.com ([2002:a5d:638c:0:b0:43d:7c66:de1f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:40e0:b0:44b:ad5a:cd33 with SMTP id ffacd0b85a97d-45ea4165a80mr3528391f8f.40.1779358924813;
 Thu, 21 May 2026 03:22:04 -0700 (PDT)
Date: Thu, 21 May 2026 11:21:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521102149.804874-1-vdonnefort@google.com>
Subject: [PATCH v2 0/3] Fix __pkvm_init_vm error path
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

Changes since v2:
  
  * Proactively init hyp_page order field in hyp_pool_init  

v1 (https://lore.kernel.org/all/20260521081250.655226-1-vdonnefort@google.com/)

*** BLURB HERE ***

Vincent Donnefort (3):
  KVM: arm64: Reset page order in pKVM hyp_pool_init
  KVM: arm64: Fix __pkvm_init_vm error path
  KVM: arm64: Add fail-safe for refcounted pages in
    __pkvm_hyp_donate_host

 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 34 ++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  6 +++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++-
 4 files changed, 34 insertions(+), 11 deletions(-)


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.746.g67dd491aae-goog

