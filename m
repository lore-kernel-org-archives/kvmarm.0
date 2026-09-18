Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF1539C631
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 02:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789699601; cv=none; b=u92mBqnSE6NvHf8kmE6gWhLOVNs+dVqZqzrKM5vWhflKN1+rcmTyWMN7tBqFzU+PhD4e2m7Wmf5sYownE6X22ChRP4JAxc39aHAKgYQ6GTfRMBRbZUoKKDDS2GP57xOMKCoCNVJHkDYAGHR0LedrNR1tYO2ciFEjKFEecwtW2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789699601; c=relaxed/simple;
	bh=LjJ5sJnEi5EE0IvALN7ryhHg4MlSKSnPS1b4dRznO70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E6/MOBwlz8zTMQg6xNYrnVzXy4F3MAq4fHZ0+olyPTkOVo/aYPcJWP7DN7zpDyuIV5+W/DdGAmr0vAKYKqxCjfXudfu8kWYWaV5PyknNehlGzvlhgbsV25Q21HN/m+RkPptsSwfKuOM2RS0L304nuuXsj+kBzsghiOz3gE1vzOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2UKx5/N; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2UKx5/N"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396cccbba92so243525a91.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 19:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789699593; x=1790304393; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gGnBH0JUMzyPu3dd9hYfJ7ZyZxE1z3RVWLOS62okldY=;
        b=e2UKx5/NXhE5HPfu/E/+Whq9IG/wmEPGPG7jU2mUi97n+//ay9thRTooKvid9az/hs
         Rx5XGh/o7ZNqZydgtKE4bfPeej4ZOlDuEdz/9w39X+UxVQKQd/11hRr0KYdUOKcMTeAZ
         ZJ/OVRuvYdG8/jpdS9Ru/rQPpX9KL+t4UldbtVsYdxN2r/vPeJMLLrDrXRzDGNBgCw7j
         RXwjWxpEueo3PPEEl7nANBObJrojZEP4jKEFZGsGL4XW1EygB42haYeBtMJjNUn9ORA3
         FFy78IG5YRzVH4fZXhbEUBcyRdzjOcgvRWrLPjhLH6GcNpYMil7yscXGyVko4g9lGvqY
         B60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789699593; x=1790304393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gGnBH0JUMzyPu3dd9hYfJ7ZyZxE1z3RVWLOS62okldY=;
        b=ReN6d7T4aqsKGZuY71nTICAn1FaAM3QJQJTdW7nPrPR34AKjaGc+/dzZxbm3LD07CB
         T7t5sngBbtv1Dm+AWSi4Wbeij3dozzGjKtTDgqbYuGZT5bn+MDnXFApac2AawTtqo1xl
         0YFudFKNGs3Cbxh0t3T2w/gE+4oej/ct+QfLT6bRTMbo42AE52o1XdfLgQvFCrnZT1gY
         uwW9icoL9/qlRHq3RaZgXtUT25qhowjExA1T4pgDDFjbG2rnRi5BOouWxs4n8kxIuHyg
         IN+KnXBi2JvQij6EBk3SDgjrKqnh0tXz0TiAT83Q4iJoD/mFcGZiY4IPvnzVpYYZ9gwe
         gBPw==
X-Forwarded-Encrypted: i=1; AKwUvBxTsk6xtD8Nv7uW5Zc97N2c8uDqgW3JwDEpvqbtmWpsuDghp4/Qxq9cRdN9IED6ViFKjIzevZQ=@lists.linux.dev
X-Gm-Message-State: AFuF++nBvFqUHlumVptV8Q65G/6TPh1LtJdrBbFAskfXn7NIXqOlCgIb
	KDfE7zLGn/WMrM+XXEnAQHk5efeqVpm88SwmHcC+XIicsNItHYxzYyiE
X-Gm-Gg: AYBFou1dGdnT3ta2jgdT4By4GxvwATxg7QZaSm7WsK4iIrn8I5zH2lLo2HVz9yvKohR
	oYtNpydByB7UD8H8tg3/zfLBASy5lBWGj6cUWGd0F48e1zfb/6bleOyVwUn2XBW/xbXM13rlxd2
	b7y9YhgVJtog9JoZJzaxBq8YL0gEdhvuWkwa37pg3VpklwfCZdT6FTPYcmvi7dKk0t2Ye/Zs3r9
	xcIT+LwezgicI1y/kmfFdpnp7dmlf1dSmHXzs4yUf3xHTfjsReNteVBCs1pHCYnZB+REWbTHUhE
	pjAMaurU7Zr4YXQf1Y19Hhg6hZ7eaIdPt4s/L/5A1OpKrA0cMUjyBGpiFtFFePKphheBiTXc4X0
	Y0+bb3rbYfDoUPExB4xfXJiqNCos1cZ6Ktf7mUVD1l3kgPyEgOWlpWuXI5zg/TLxqXy3OabzMks
	YRcSVrpbuDSugNdsUtvBLy5CLPCsartCja0/S2EcM7FFBscmieSLwMAxPguXZ9LbOaiwnvAAA1w
	l3JiegCMjahLl0xxjNtmTMAd2MwnlRo/ou29Qk=
X-Received: by 2002:a17:90b:3c05:b0:399:1f8b:d255 with SMTP id 98e67ed59e1d1-39e54af0c87mr2618598a91.5.1789699593167;
        Thu, 17 Sep 2026 19:46:33 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:ec74:2ce6:f939:d0ad])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c287b0293sm349521eec.24.2026.09.17.19.46.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 19:46:32 -0700 (PDT)
From: zjamg <ndaugoing@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH 0/1] KVM: arm64: vgic: fix UAF/crash on remote LPI disable
Date: Fri, 18 Sep 2026 10:46:19 +0800
Message-ID: <20260918024620.83869-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yuchao Zhang <ndaugoing@gmail.com>

Hi Marc, Oliver, and KVM/arm64 maintainers,

By code inspection of commit 6da5e537f5af ("KVM: arm64: vgic: Pick EOIcount
deactivations from AP-list tail"), a race condition exists when a remote
vCPU disables LPIs while the target vCPU has an in-flight LPI in a List
Register (LR).

Specifically:
- vgic_flush_pending_lpis() unconditionally unlinks all LPIs from ap_list
  without checking whether the interrupt is in an LR (irq->on_lr).
- If the LPI in the LR happened to be the last one populated, the per-CPU
  pointer *host_data_ptr(last_lr_irq) on the target vCPU is left dangling.
- When the target vCPU exits guest mode, vgic_v3_fold_lr_state() starts
  traversing ap_list via list_for_each_entry_continue() from this unlinked,
  poisoned (or freed) last_lr_irq, leading to UAF or an immediate panic
  when locking irq->irq_lock.

Solution & Scope:
This patch prevents unlinking LPIs that are currently on an LR in
vgic_flush_pending_lpis(), ensures *host_data_ptr(last_lr_irq) is cleared
after folding, and skips the ap_list walk when eoicount is zero.

Note: this closes the primary race (the last_lr_irq node itself is no
longer unlinkable while in-flight), but the fold traversal can still
race with a remote flush unlinking a subsequent non-LR node in the
ap_list tail. Fully closing that window needs the fold side to take
references before dropping locks (in the spirit of the prune-side fix
in commit 7258770e5814 ("KVM: arm64: vgic: Handle race between
interrupt affinity change and LPI disabling")) and is left as a
follow-up.

Any feedback is greatly appreciated.

Thanks,
Yuchao Zhang

Yuchao Zhang (1):
  KVM: arm64: vgic: Do not remove in-flight LPIs from AP list on disable

 arch/arm64/kvm/vgic/vgic-v2.c |  3 +++
 arch/arm64/kvm/vgic/vgic-v3.c |  3 +++
 arch/arm64/kvm/vgic/vgic.c    | 10 +++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.53.0
