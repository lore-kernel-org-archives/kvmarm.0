Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FFE62F
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 12:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A6DC433D2;
	Thu, 12 Jan 2023 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673527134;
	bh=+LEeLMYkd9RkMQSIuh1SSyTKV795y+lqyBKTQSXPkNA=;
	h=From:To:Cc:Subject:Date:From;
	b=b42dJms9soLm/YDE2LeMzTf4lI5WlvRJ96yQfMOuoPnmjY2QXoomjBnc/9Gu797U9
	 zbDCKso8jzmby21abrxmUhzzE9WPOHPw8U/nNUQdx4DXy1lNIvSJpzmuvZ9UOjeqQ4
	 ZwbAGlgVU8c0QdsnmCXLqx+3LKIDvo5Ljpkd8urk51rai4MFkovdgoCuabIIuYhSzU
	 xf2tmzMHKP0p8xSdCWFDbvKw1j9ONIi4caM7IwB7HA9zwrsHg3TcEvTSE6h0rNqI+H
	 VbmouXa09RwN/m0qnVv+8BFapYbYOQDk8Wtg2GEL/+bhb/8i/di7YcVzUKMoTVIPGU
	 aF1nBpbTGnDJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pFwr6-001BBa-F2;
	Thu, 12 Jan 2023 12:38:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	<kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org
Cc: D Scott Phillips <scott@os.amperecomputing.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: timer fixes and optimisations
Date: Thu, 12 Jan 2023 12:38:26 +0000
Message-Id: <20230112123829.458912-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, scott@os.amperecomputing.com, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Having been busy on the NV front the past few weeks, I collected a
small set of fixes/improvements that make sense even outside of NV.

The first one is an interesting fix (actually a regression introduced
by the initial set of NV-related patches) reported by Scott and
Ganapatrao, where we fail to recognise that a timer that has fired
doesn't need to fire again. And again.

The second patch is a definite performance improvement on nVHE systems
when accessing the emulated physical timer. It also makes NV bearable
in some conditions (with FEAT_ECV, for example).

The last patch is more of a sanity check. There is no reason to BUG()
if we can avoid it at all and kill the guest instead!

These patches are 6.3 candidates, although the first one could be a
6.2 fix.

	M.

Marc Zyngier (3):
  KVM: arm64: Don't arm a hrtimer for an already pending timer
  KVM: arm64: Reduce overhead of trapped timer sysreg accesses
  KVM: arm64: timers: Don't BUG() on unhandled timer trap

 arch/arm64/kvm/arch_timer.c | 77 +++++++++++++++++++++++--------------
 arch/arm64/kvm/sys_regs.c   |  4 +-
 2 files changed, 52 insertions(+), 29 deletions(-)
