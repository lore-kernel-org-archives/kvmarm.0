Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7029F51AFCD
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 21:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790113359; cv=none; b=j23y9FjkzI9XFiG/uIgP/NbiPbCIKvZwaPAoM18Z1ZvejOJSi8D4nYbf8kTk72hkNJY/tQkcjXIhgnPtGgeSdvLOffD76VBMu/f/vRtsD9qydvUQ6W7d3pl3w02I1dT3eUXuURSH8xSdA+/mZcwsy46dWi3V7h1oFaftnISMngo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790113359; c=relaxed/simple;
	bh=12JRLMh/M6XOSou8Mysqo3VtOfUZh7uz6UjK+EWC+lg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bRbJh2EYfv9G9Sy+ATrx+w1MZqw7PVaYaN3vCKRXoRFSiKvHkUQS4kPz+g88uE2hDp+eWXZOAvFne+TLk/gEwoM7q7QX54KzFXnKvWOYJ5XVumYrge0ma93Msw7UVhIgm03ZUvvRmGK1ZsTsEsxreWDL2hx14RFXzEOKx/p2kmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esjP7qAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esjP7qAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B717C1F000FF;
	Tue, 22 Sep 2026 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790113344;
	bh=6rXdzRPRFaAkzJK2CTbotf/X0PgO5pvJQVZtTI8XXN4=;
	h=From:To:Cc:Subject:Date;
	b=esjP7qAaLzUReZuUkYkPuocF/yKfoJxpuO0zFP9b3dxw4ydnOI1aEZzI7EOLOKs8O
	 V9/trT+ZtO3X2bVXgc7+SoOEKd8RWDlbg/rPOBqyvOlT/KJM1mkOTlJo8hdJtm/91O
	 hOpf8olk23q1yQtTDvHNYJkZ++BBuKfiiQ2uDOhpeOysm/QG01zLDqTAsVWEkC7aU2
	 2WSGEwCRIHPC+1ApnXsijAvmshnwgF77BrHUUqou6mmceN44RU9homJK3CfkfWJarO
	 f7wSfZAQfi9oq2MjKSjxjxaw4wuerk406DH6s7YebmqCLEvO/oMk+0yF2wYe+hj2M+
	 xAezx+rJD8tlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x98Fq-0000000CFxJ-1mQv;
	Tue, 22 Sep 2026 21:42:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH 0/3] KVM: arm64: vgic-v3: Make LPI disabling robust
Date: Tue, 22 Sep 2026 22:42:09 +0100
Message-ID: <20260922214212.3327146-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, ndaugoing@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Yuchao Zhang reported that disabling LPIs on one CPU from another
could result in UAFs and other horrors.

There are two reasons for this:

- the last_lr_irq pointer does not contribute to LPI refcount, and
  that LPI being removed results in a dangling pointer

- LPIs can be deleted from a remote vcpu by disabling them while that
  vcpu is actually running, and has LPIs in its LRs.

Address the two issues in one go, by actively taking a refcount on all
IRQs referenced by last_lr_irq, and making sure that disabling LPIs
force all vcpus to be paused, making it safe.

Marc Zyngier (3):
  KVM: arm64: vgic: Allow last_lr_irq to be NULL when LRs are not
    overflowing
  KVM: arm64: vgic: Take a refcount on IRQs referenced by last_lr_irq
  KVM: arm64: vgic: Stop the VM when disabling LPIs

 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 10 ++++++++++
 arch/arm64/kvm/vgic/vgic-v2.c      |  6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c      |  6 ++++--
 arch/arm64/kvm/vgic/vgic.c         | 21 ++++++++++++++++-----
 4 files changed, 34 insertions(+), 9 deletions(-)

-- 
2.47.3

