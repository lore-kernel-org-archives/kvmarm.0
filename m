Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CDD33509A
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683701; cv=none; b=DLuXBurCEdpAIZszmq9WEZRvmTVw8zUeZBNDMFKMYtwATYGwTns/jEDtnbZ5iRjz/8vVKi7lg0iUlJMbPJ/y38cE2acQHWcsCE9lbSSOBXiOfMLHFzPqW70kPrTgwVlvZnemtkfZ5v/AlRvp8X/K/zWl0MgWpqjUFqe03CPt/0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683701; c=relaxed/simple;
	bh=kc0QYskUhZvvSika4c/oWQOSCjo1FOrm8FnMBYmgaGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ON/LjZfWE+FPPPFU8gHuqfBex7Os8W/I47AMNF8iU7NI8k7wBiTa1E5sStL/4qCoa4ecGqZuvjaoS/iN0zbvWVdK6l8qcCpmq8VdiXKob2+kvXcu5qMEv9VMfmi6DiHqyDIg8vKTEkmW22B+5FuXgUdOSdOdMe7XIOswJ/NP0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VM+hZqNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VM+hZqNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79090C19421;
	Mon, 16 Mar 2026 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683701;
	bh=kc0QYskUhZvvSika4c/oWQOSCjo1FOrm8FnMBYmgaGk=;
	h=From:To:Cc:Subject:Date:From;
	b=VM+hZqNqMeIMprcqWH+yzUbjxk3Aah5zCrGlLlifh2U7RBw58lADXoNtjCkOWsnDa
	 NeU6Yw5vrEdyeRxfiZNzPk3KRVoMBlUzyHHar/K4B6sxBOC+03Obf/Cfqb9iTRO9E4
	 SFQwBqbDBNGzobJeCGbj3haW9WagTHt+X/xPvRe35jPROatarVR8/YnHiIIABG4VRY
	 qX06XiQWhS4RrIy64sKYwAXKS8HZ1kVaTp6vFLiJrAnok6vq/I+GWcupPlw6T7tWiw
	 z2crxDsxG8M9NyZ2j+9VjQrhntAj7Kz9yHGDMGKIbr4NhIN660jmWmfdVpBt32KYs3
	 ucvo6mM39uNvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9b-00000002XDx-077g;
	Mon, 16 Mar 2026 17:54:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 00/17] KVM: arm64: More user_mem_abort() rework
Date: Mon, 16 Mar 2026 17:54:33 +0000
Message-ID: <20260316175451.1866175-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Piqued by Fuad's initial set of patches[1] splitting user_mem_abort()
into more "edible" functions, I've added my on take on top of it with
a few goals in mind:

- contextualise the state by splitting kvm_s2_fault into more granular
  structures

- reduce the amount of state that is visible and/or mutable by any
  single function

- reduce the number of variable that simply cache state that is
  already implicitly available (and often only a helper away)

I find the result reasonably attractive, and throwing it at a couple
of machines didn't result in anything out of the ordinary.

For those interested, I have stashed a branch at [2], and I'd
appreciate some feedback on the outcome.

[1] https://lore.kernel.org/all/20260306140232.2193802-1-tabba@google.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/user_mem_abort-rework

Marc Zyngier (17):
  KVM: arm64: Kill fault->ipa
  KVM: arm64: Make fault_ipa immutable
  KVM: arm64: Move fault context to const structure
  KVM: arm64: Replace fault_is_perm with a helper
  KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
  KVM: arm64: Kill write_fault from kvm_s2_fault
  KVM: arm64: Kill exec_fault from kvm_s2_fault
  KVM: arm64: Kill topup_memcache from kvm_s2_fault
  KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
  KVM: arm64: Kill logging_active from kvm_s2_fault
  KVM: arm64: Restrict the scope of the 'writable' attribute
  KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
  KVM: arm64: Replace force_pte with a max_map_size attribute
  KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
  KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
  KVM: arm64: Simplify integration of adjust_nested_*_perms()
  KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc

 arch/arm64/kvm/mmu.c | 428 ++++++++++++++++++++++---------------------
 1 file changed, 223 insertions(+), 205 deletions(-)

-- 
2.47.3

