Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B80199248
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608021; cv=none; b=GR6eJiRE75AHxBkGi48nUVpj6cJgQmA00pxAZj90AkUzlQDs/J8dm2bi9pF33/EiEmovZyKCyJQPgWdkAPqfkZmUrfAa3G2puuTr8h+LILWJOkRs1EIjY28/SyLfhtHpmZ3zMn2w+X0qSOHmvIvgJ3yWW5CMzCRPW6iGVag1B94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608021; c=relaxed/simple;
	bh=hM3RLqwvypSOep8dQhDbJN+CxR9fQGncFd2fOZkcEOI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fjZ2Eh+UhW/QuAGzAliDYU2e7OmfSuxrIgdRZhvXSOPxOJrM9ukuFYYaBHk6DtzgQrK/p92VC/hSTas2dd3yKeumCwseQ0w3OG2TMiM6ZiMJ5Rj0R0iogVF8ftbSUmQYZ8Zi6wuZ7OXUwgJu+xHjKOg150/QdjcjDEUJ68V8DGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgcxk9wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgcxk9wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E727C4CEC3;
	Tue, 22 Oct 2024 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729608021;
	bh=hM3RLqwvypSOep8dQhDbJN+CxR9fQGncFd2fOZkcEOI=;
	h=From:To:Cc:Subject:Date:From;
	b=kgcxk9wY9EOsmaSDGs4jGUBXlnET6mZY2zIqaYsIVCheuVk7ZbPxxE+O6fi9GTT4h
	 //V3+obkwrApaivUMN+FfGRFyu7lX9aTP1FsrVBIg5tBUWDHC5MjN8LjZzppNBKRDd
	 zotcwlYDgpf8nD51z/Z7eU8RqmS8JCLni78XDEgSd2k8TEJPfapRB1ir6nYI6VY3rS
	 K/wVWDM2ig5Og8poxzN5rBMdHhzIFlDNbQy9U0p8TIURcwA80U84z3lUIy4fOoIY3A
	 tM7KlwhlD92skxSoOWEdOwBYEsamA76m1Eyykwnw6IttVxehR6o5k6Jt90ql1Qky1i
	 DX5EZGRUMFJUg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH 0/2] KVM: arm64: Simplify handling of GICv3 hardware with broken SEIS
Date: Tue, 22 Oct 2024 15:40:14 +0100
Message-Id: <20241022144016.27350-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

While looking at reducing the host memory mapped into pKVM at EL2, I
noticed that the GICv3 CPU interface emulation for hardware with broken
SEIS implementations can be simplified and the corresponding mapping of
'kvm_vgic_global_state' can be dropped.

Please have a look!

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev

--->8

Will Deacon (2):
  KVM: arm64: Just advertise SEIS as 0 when emulating ICC_CTLR_EL1
  KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2 with pKVM

 arch/arm64/kvm/hyp/nvhe/setup.c | 17 -----------------
 arch/arm64/kvm/hyp/vgic-v3-sr.c |  3 ---
 2 files changed, 20 deletions(-)

-- 
2.47.0.105.g07ac214952-goog

