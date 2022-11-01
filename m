Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D47D7E
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 11:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892CFC433C1;
	Tue,  1 Nov 2022 11:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667302367;
	bh=t8VKqvFmmk4RxuCoYN5dBw2gikcBUHP9PRuaDdBB7lc=;
	h=From:To:Cc:Subject:Date:From;
	b=C29gKNkl7FL6JBv7QoboZrAF7u0KHRkJ3JxsTudVc6JTQb4Khskqgwu9XkA75S8jP
	 p4crHoMrGMs7/t4J9QldfXQhrBYZxCUhB1zsqVpa9rgISHpPox/9Tmazp42LL023qj
	 q1rn1LNv6ZqkA6YGZvknzjcIhsXd09HxuVZ7q7HfP/AGHRewV+0b5QJFx9tWXytyjE
	 ZkkwkNFLV7C9XXDDSi3U9o9IDZoM3CmvHLaLyOrxUrrIFOQrL/NmrI5Lt/ZIAXd0ff
	 CfKQXPv6DKyA6S2KI19VkI0jNEYFRVbPpnxyHhuc7vkwWRpizeQeXCzFNscj9j7ghn
	 KLmk89L88ce+A==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/2] arm64/sme: Fix SMPRI_EL1 traps for KVM guests
Date: Tue,  1 Nov 2022 11:27:13 +0000
Message-Id: <20221101112716.52035-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; i=broonie@kernel.org; h=from:subject; bh=t8VKqvFmmk4RxuCoYN5dBw2gikcBUHP9PRuaDdBB7lc=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjYQKRhCas+5q0XzqQQ/bqrnd35MlB994XPFOtdf0w LRG/5o6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2ECkQAKCRAk1otyXVSH0LpFB/ 9jyeu+a7OHlR1tPzgGpH7Hrk2SyDEGpwSxU2sGfI47oAnuRdmbxoLr1bGBo6sze61dgki4gV0dTjjn L7s+Y5iixH1pzuX+yB6L6fib0WL3GWDNnATMHxcR4q/w82dDa29w5RF3jp75SBr25vbcHm7KdoUAuM D9PpuBUDyzRammxMtRwLNGI4y8vUi3yYg+iXbiDeDnUR0tUhz6fAAwtWIcHxk/zUhy20pOG6eup2ZC dJpT4Ml2W7WoX0OjVjLe5tA83Ga0V6ORRQ6lxcRp/XLhA5TLjihGiR5c03/UDQaKZXNTJUmKHuI5d/ C69JfgW3vLKuVjHKCZgsji9Dag/Ylx
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

When adding support for SME I missed management of traps for SMPRI_EL1
in KVM guests, and also the need to manage TPIDR2_EL0 fine grained traps
for EL1.  This series adds that management, and also updates the
documentation to help avoid such issues in future.

This was noticed due to Vincent Donnefort noticing that qemu has
implemented support for SME virtualisation but not fine grained traps
which was causing problems for qemu in nVHE mode since that already used
fine grained traps with SME, the FGT registers are not implemented and
UNDEF.  As a result of this change VHE will also be affected so a
separate series "KVM: arm: Refuse to enable KVM on systems with SME but
not FGT" has been sent which will ensure we don't run on such systems
though initial review suggests that this will likely be treated as a
qemu documentation issue.

v2:
 - Rebase onto v6.1-rc2
 - Also manage TPIDR2 fine grained traps for VHE mode.

Mark Brown (2):
  arm64: booting: Document our requirements for fine grained traps with
    SME
  KVM: arm64: Trap access to SMPRI_EL1 and TPIDR2 in VHE mode

 Documentation/arm64/booting.rst |  8 ++++++++
 arch/arm64/kvm/hyp/vhe/switch.c | 26 ++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.30.2

