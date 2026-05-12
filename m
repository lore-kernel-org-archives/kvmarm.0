Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEB53A986D;
	Tue, 12 May 2026 14:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778594885; cv=none; b=ZEf7PKZ+HFLb3CmoKeTI+BMaCtRHJcIH0RABDIQeKICm8QJTFkCjSJ6BJQF9hjJAguCSDoUlb7GyPe0WsxoGh+3x0A/xXE4T5TFwf/hMfAsw2KZ+7e1xMHoFsqSY8LOTac0HvfF3CYmH3wuoTDTRdi43yDi+iaZyT0wMoKSeaqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778594885; c=relaxed/simple;
	bh=2z0QUbRfd7RQy2VdTzINQY27ivTVVpTJV9yTHwNGfXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FKOhTchMlJkyiSMp8QbqHCGgGa6J3UfGCt2k8U9tEblf7CiJnTJ60ebERwLSiqcqUGJyuzwLhNDDp+3poXT8PBtvrYk9pQKiNgfeX0PVtdGJQBfYHlpVunpA/ALJP2ocq/y+Tfrom6/i1u0YM+7X3SOcs5OzNEkwP+p+1ccfK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZxpbcZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZxpbcZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B27C4AF0B;
	Tue, 12 May 2026 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778594884;
	bh=2z0QUbRfd7RQy2VdTzINQY27ivTVVpTJV9yTHwNGfXQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ZZxpbcZbuxxboPRxAOcWEUUjyEggALZMoAkjgheNjXj3ATYmpjl55r6kScF4HCLYh
	 lhbkpBkLbRuVsgQZ1FOnoy4dy7++6VqebjJql+nLaf5rOI9hEvgi02H6/67rSmIiyz
	 kHpnoOrtPg2ZbXnUgToqjNqYdsb1NwwzUZOc6K5KmlvxD9Ias3mo4ocN0cHvOC84WA
	 I9ySauTnCuxU6fIDA4HmG7K1s7NyUW1bQoSQv8VVNsX/U/L2EmPpHaokMUs/mOvamg
	 48lZQkhRLvDFbuoJW3eBarqzctog8hLhTFNaGfwh0jzb4GAcDq1mOfUjrcUAgjpwio
	 dA/D/4rWNiKqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wMnmE-00000001Zsc-0q45;
	Tue, 12 May 2026 14:08:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 0/2] KVM: arm64: nv: Reduce FP/SVE overhead on exception/exception return
Date: Tue, 12 May 2026 15:07:53 +0100
Message-ID: <20260512140755.3676306-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, mark.rutland@arm.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Staring at NV traces has shown that there is a substantial amount of
overhead being triggered when a guest switches between EL1 and EL2 (or
the reverse). This is caused by the naive put/load mechanism we use to
multiplex EL1 and EL2 onto EL1 only, and the FP handling appears as a
prime candidate for optimisation. More precisely, there are two
distinct sources of overhead here:

- the FP/SVE registers are saved, and potentially the host userspace
  state restored when doing put()

- the FP traps are reinstated as part of load(), as the state is now
  the host's

These two things mean that we end-up with a lot of work during this
switch, and that we are 100% guaranteed to get a FP/SVE trap very
quickly, as the guest keeps using the FP registers. These traps
themselves result in some horrible trap amplification in even moderate
levels of nesting, which we could trivially avoid. A bit of thinking
indicates that it should be entirely valid to elide this stuff in the
context of a nested exception/exception return.

The first patch in this small series just add a new vcpu state flag
indicating that put() and load() are done in the context of a nested
exception from L2 to L1. This is the exact pendent of IN_NESTED_ERET,
which tracks an ERET from L1 to L2.

The second patch uses these two flags to abruptly elide FP/SVE
save/restore when any of them is set, sidestepping the overhead
entirely.

Performance-wise, this is rather impressive. I get a 10%-20%
improvement on running the Debian installed as an L3 on my QC
platform. Combined with the use of the EL2 virtual timer, it almost
makes L3 usable.

But of course, nothing is simple with this stuff, which is why I'm
cc'ing Mark here, as he's done a lot of work tracking funny bugs in
our FP handling. Hopefully I haven't subtly broken anything, but let's
see!

Marc Zyngier (2):
  KVM: arm64: nv: Track L2 to L1 exception emulation
  KVM: arm64: nv: Don't save/restore FP register during a nested ERET or
    exception

 arch/arm64/include/asm/kvm_host.h | 3 ++-
 arch/arm64/kvm/emulate-nested.c   | 4 ++++
 arch/arm64/kvm/fpsimd.c           | 8 ++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.47.3

