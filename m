Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDE518D656;
	Fri,  4 Apr 2025 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773246; cv=none; b=XlhBKun127/rZ9xlE9Iz64zPNu8GeG801tYvpwARKt6mXDe7GFWzGxSnDMyXYb8tEAz+7Z8JY+PmvjZFvrYxwVXgwdKrZ+f9kfNAxNzRWmtdfEf4zrrDwVVA9Woo1pprq9EtkmEhB6m7Vll80UdTLy9lrbWRVudedCHS1udjk18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773246; c=relaxed/simple;
	bh=dMnezC4ayMJ3IPQofFQCbhpFIaP/JJW0J5RFebyBYdI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NJMW1Nt4N6XgPyEZHT2ktg+L68J8tJfMUu+/QZLrrBHjFRDpWn/jKwXUE41cmgqfVQLJY597dXPzdUYs5MfdylfCQrxSwzF2TzbB9Jy9fNEZT2z8nscJhJmiVEAJmvD7f2+xbHRMJds/Ox9KDTRYojb0UqzwUODAtVPb8jsqMFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gd+jY7RZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gd+jY7RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B24C4CEDD;
	Fri,  4 Apr 2025 13:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773245;
	bh=dMnezC4ayMJ3IPQofFQCbhpFIaP/JJW0J5RFebyBYdI=;
	h=From:Subject:Date:To:Cc:From;
	b=gd+jY7RZUXZ0kOoZ2XiFFPXQP6ZMMDDACnuer+FjZUgdHqHnrqs48zMKgSoskVsZS
	 wx5B5yZ0lVRHqM3eRu+NPIuCfGNRFqKkA3CY9D4cntQO8duAruDvWJRcGuGnPSofXK
	 Ep+pQmLlg9mVPMboS+sghyvyMh9SLPbqCkJ4I5dsCbwTYP98+0EQ2jbVTTEPzUAKMt
	 paAFtm9Izb9YJP1tkO5OgPmdi6hXm2kJLUWGeQ71KERAOIXxvE4QTUUhWq3Rro+r25
	 kVvfKMWr6wQy3+pVDa6OTHluE2MaUn7tCSEW5JSqVOJMi8IG0ArBa+zRr6vphHCX+I
	 F/vG3x63VstWQ==
From: Mark Brown <broonie@kernel.org>
Subject: [6.1 PATCH RESEND 00/12] KVM: arm64: Backport of SVE fixes to v6.1
Date: Fri, 04 Apr 2025 14:23:33 +0100
Message-Id: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
 Mark Rutland <mark.rutland@arm.com>, Eric Auger <eauger@redhat.com>, 
 Wilco Dijkstra <wilco.dijkstra@arm.com>, Eric Auger <eric.auger@redhat.com>, 
 Florian Weimer <fweimer@redhat.com>, Fuad Tabba <tabba@google.com>, 
 Jeremy Linton <jeremy.linton@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 James Clark <james.clark@linaro.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2157; i=broonie@kernel.org;
 h=from:subject:message-id; bh=dMnezC4ayMJ3IPQofFQCbhpFIaP/JJW0J5RFebyBYdI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn794txXB3OZqTgH/yZx7cbfa487bPc3Liz4ZeFZGa
 ukIFRhuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+/eLQAKCRAk1otyXVSH0EYdB/
 0cVMQ5Viwd6UigabPwoQZpINzNEs17/eljGRJpuyRiWYmew/Hpi86hN9gu0al+ZIbqBgH6yDai5aEL
 lcqIBxOmem6lfO9uYSW1Txehoe8kodHHcNMB5zsbkKO1W8V8BUsjDEl6rf2hJyzxXQGrO69SFaYI9Z
 +52HlEvn1cpQasSWynL85kl6sZPHeyzLNM4ZEKcdk9EBmirzpX0pzluAOUwslexbSwc1olP3qPBckd
 8hYtMTgCwtCZ+ldykCJiarv/5l5OZjvFdbOMQlGoEf6eBAQOP4QoHVVt+5Vho7ogJAtfPDSC1ECxGn
 lXeWW3ZFdGfQ7F9uaymJ/VMRuOZOOm
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

This series backports some recent fixes for SVE/KVM interactions from
Mark Rutland to v6.1.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Fuad Tabba (1):
      KVM: arm64: Calculate cptr_el2 traps on activating traps

Mark Brown (4):
      KVM: arm64: Discard any SVE state when entering KVM guests
      arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE
      arm64/fpsimd: Have KVM explicitly say which FP registers to save
      arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM

Mark Rutland (7):
      KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state
      KVM: arm64: Remove host FPSIMD saving for non-protected KVM
      KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN
      KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN
      KVM: arm64: Refactor exit handlers
      KVM: arm64: Mark some header functions as inline
      KVM: arm64: Eagerly switch ZCR_EL{1,2}

 arch/arm64/include/asm/fpsimd.h         |   4 +-
 arch/arm64/include/asm/kvm_host.h       |  19 +++---
 arch/arm64/include/asm/kvm_hyp.h        |   1 +
 arch/arm64/include/asm/processor.h      |   7 +++
 arch/arm64/kernel/fpsimd.c              |  69 +++++++++++++++------
 arch/arm64/kernel/process.c             |   2 +
 arch/arm64/kernel/ptrace.c              |   3 +
 arch/arm64/kernel/signal.c              |   7 ++-
 arch/arm64/kvm/arm.c                    |   1 -
 arch/arm64/kvm/fpsimd.c                 |  92 ++++++++-------------------
 arch/arm64/kvm/hyp/entry.S              |   5 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 106 +++++++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |   8 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  17 +----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  91 +++++++++++++++++----------
 arch/arm64/kvm/hyp/vhe/switch.c         |  12 ++--
 arch/arm64/kvm/reset.c                  |   3 +
 17 files changed, 259 insertions(+), 188 deletions(-)
---
base-commit: 344a09659766c83c42cdd4943318deabde89a9c3
change-id: 20250227-stable-sve-6-1-075c1295b363

Best regards,
-- 
Mark Brown <broonie@kernel.org>

