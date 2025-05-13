Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0536578F4B;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747117741; cv=none; b=BZHeEng2qtNXxLIWxtpeq2WxS1mkstbhKygMqV8YQLwFaZ0ZL7O5SfJ3VEIol1ivjhk2i5QCI/J5+t8M0eHdQbxbDZxSsa4sskVT48crjn+O0+iWkkODVRZCbCaEv07cvzuQFbEJyDcOrE8a6ETvhSqnGeGAkszODjF3d44RrtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747117741; c=relaxed/simple;
	bh=4SKA5HPa9ZWoOTNyb/Gf9+n/i7cYSFTNHi/tHOeBnGE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gx7yMDQ4jyYHMlYTt4WB/fSQyVbL1i0BzAcXQgehSW88rWLe/38RJ9m39kzfOzU39ALlcEAONE/0xndHqDWBMI3s1Hy9mZuexABt/LTHp+onD2HIdbm2ejrgkdnZKvhYkx0+TUZZQWxFGaaI5WWYmYApTaOzx5if8v6uKuR3B7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGZfiRM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGZfiRM2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F61EC4CEEF;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747117740;
	bh=4SKA5HPa9ZWoOTNyb/Gf9+n/i7cYSFTNHi/tHOeBnGE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=nGZfiRM2uM6B4s9C1yNel7dnpkxLE3GcjwlI1vyKrsbMeM5iGmecFHCYOlEVacT28
	 2tW+j+Jcki/XhhTg4zcZteOWsOXmPv9kLfkWhIei9SNaG/sL7UoSLX2rwZ5xZZezXz
	 GqB2PdG/g6hnS1sTds1wgUeqH0us+cHaNsXf/cckhyeEaK9zFeQcIU/aLPKnXA3fkb
	 oDNMZgqAvxbrbuG0ihh8T1PAmKGDn47VvbhCdrNF1ovDZ5hqtOuEPNEq/XxHJeEB5K
	 tikenGLdR3zp8GzCUj34YG9ZQD2HykKvItI1QiSaOB0brlTrvQFKaT/ESJt9fSMV9x
	 XtqclChfNRLnQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F22C3ABD8;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v3 0/3] KVM: arm64: Support FF-A 1.2 and SEND_DIRECT2 ABI
Date: Tue, 13 May 2025 06:28:29 +0000
Message-Id: <20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI3mImgC/13OQQqDMBCF4atI1h2Jo7G2K+9RXASd6IAxklhpE
 e/eKBRKl//ifbxNBPJMQdyTTXhaObCbYuSXRLSDnnoC7mILlKikkiWs7Bd2YEMPxmhA1OaK7Q0
 zJUUczZ4Mv07w0cQ23llYBk/6l0EZB7JKc8QiLzLIYCY/1mztc9LTkrbOHtjAYXH+fZ5b8SC/Q
 PX/Y0WQQF1VmEqq/FaquneuH+mkmn3fP4broG7qAAAA
X-Change-ID: 20250506-virtio-msg-ffa-22af72c92150
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, sebastianene@google.com, 
 lpieralisi@kernel.org, arve@android.com, qwandor@google.com, 
 kernel-team@android.com, armellel@google.com, perl@immunant.com, 
 jean-philippe@linaro.org, ahomescu@google.com, tabba@google.com, 
 qperret@google.com, james.morse@arm.com, Per Larsen <perlarsen@google.com>, 
 Ayrton Munoz <ayrton@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1747117739; l=2845;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=4SKA5HPa9ZWoOTNyb/Gf9+n/i7cYSFTNHi/tHOeBnGE=;
 b=1iyk0OED6t5ZdZaQjVBHOGlvdab42TBPKVqb0E58bknYWEhi9P0ZeJCrXMVghFpYu9Dst8/1l
 ljpFFiAEcyVBxzosqMZpk7SUEY4132d7cjj0tjzJUKhYXOQ85+WsXOB
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

Hi,

The FF-A 1.2 specification introduces a new SEND_DIRECT2 ABI which
allows registers x4-x17 to be used for the message payload. This patch
set prevents the host from using a lower FF-A version than what has
already been negotiated with the hypervisor. This is necessary because
the hypervisor does not have the necessary compatibility paths to
translate from the hypervisor FF-A version to a previous version.

Support for FF-A 1.2 in the hypervisor is added as a precursor to the
addition of the FFA_MSG_SEND_DIRECT_REQ2 messaging interface. The bulk
of this change has to do with the upgrade to SMCCC 1.2 required by
FF-A 1.2. Additionally, unimplemented FF-A 1.2 interfaces are added to
the list of unsupported functions.

Tested by booting Android under QEMU and loading Trusty as the guest
VM and observing the SEND_DIRECT2 ABI being used successfully during
guest boot.

Changes since v2:
- 2/3: Removed files added by mistake.
       Add and use ffa_get_hypervisor_version to access hyp_ffa_version
- 3/3: Use ffa_get_hypervisor_version to access hyp_ffa_version safely
- Link to v2: https://lore.kernel.org/r/20250508-virtio-msg-ffa-v2-0-ed84f8053965@google.com

Changes since v1:
- 1/3: Simplify commit message; drop long comment in do_ffa_version
- 2/3: Correct use of Co-developed-by: footer
       s/arm_smccc_1_2_smc_fallback/arm_smccc_1_x_smc/
       Always access hyp_ffa_version w/lock held
       Remove superfluous comments in ffa_call_supported
       Add and use FFA_FEAT_RXTX_MIN_SZ_MASK instead of constant
       Add FFA_PARTITION_INFO_GET_REGS to calls that require SMCCC 1.2
- 3/3: Always access hyp_ffa_version w/lock held
       Correct formatting

Thanks,
Per Larsen

--
2.49.0

---
To: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org

---
Per Larsen (3):
      KVM: arm64: Restrict FF-A host version renegotiation
      KVM: arm64: Bump the supported version of FF-A to 1.2
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

 arch/arm64/kvm/hyp/include/nvhe/ffa.h |   1 +
 arch/arm64/kvm/hyp/nvhe/Makefile      |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 202 ++++++++++++++++++++++++++++++++--
 include/linux/arm_ffa.h               |   3 +
 4 files changed, 199 insertions(+), 8 deletions(-)
---
base-commit: e9565e23cd89d4d5cd4388f8742130be1d6f182d
change-id: 20250506-virtio-msg-ffa-22af72c92150

Best regards,
-- 
Per Larsen <perlarsen@google.com>


