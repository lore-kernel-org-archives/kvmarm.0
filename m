Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5172620DE;
	Thu,  8 May 2025 08:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746693572; cv=none; b=IXwOZFotg2MWnCP9OYOe/9sIOTUBHVvnQNxLNYDCGdV1Vw2Pwuc8N/xpdH7Wn4epGRrmlavKkPPyeZbr6Mj/I8tB3gKSM/Kc2cK/dnT941+HkeFXIf6pFJRebjUSNReJ1j31x8B1dZdboNsY/fq70GCzKdxXmZMubYtcQDECrFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746693572; c=relaxed/simple;
	bh=yP9xdyLDn20icw2cXMc78rD9G2nlCYHASySS9/q/UWY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=s2x7U4CWQgW7pNA1sgWC8vvJnj31wZyRT7nTe5PlGhjGTx+8RgR9/SUjEra8Z228maOVPFBxpwcHHlj9VGA0pYzL1FiPtFgshJZdZ+jmMdvNZBEpgbyRj/2QDu+cNB+0/KkObrOkZl2Fs0Oura8vtiUKS0YhjzCz2jeT4pz3q1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8OzhZ1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8OzhZ1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0484C4CEEB;
	Thu,  8 May 2025 08:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746693571;
	bh=yP9xdyLDn20icw2cXMc78rD9G2nlCYHASySS9/q/UWY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=c8OzhZ1Zt1LdEDunQfxA0AbPbWBoY8rgntrXMh7h9KWi9r8TkOU3QirBvO7bAXcAr
	 tAJsqliC+s/EUWOyXK2HlvKAUViLswals9YZT0CHnlboyIq/JUoAliN4Qsdcb5Hb7k
	 lyZQ9K0AJvlcUo+C3cOKQ31GDtdUJihF6Vd8KggS64Ewil69fdIothcp0meS0+NFKc
	 2Efp4XrTCE1qMGa3cHXY8aiso5mch13+ZCuE1Ufn0noCWaw5Xsu/bqlqxB9USx36rp
	 FCjmgzkPklfNeN9g72d5U76p4dHOZ3ZjBfISika1yHUbqGkmt45CLKmwZBJwzH7+Nm
	 j6K47UXiz5L+A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC484C3ABC0;
	Thu,  8 May 2025 08:39:31 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v2 0/3] KVM: arm64: Support FF-A 1.2 and SEND_DIRECT2 ABI
Date: Thu, 08 May 2025 08:38:51 +0000
Message-Id: <20250508-virtio-msg-ffa-v2-0-ed84f8053965@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJttHGgC/03MPQ7CMAxA4atUnnGVug1/E/dADFFxWkskqZxQI
 VW9OxET4ze8t0FmFc5wbTZQXiVLihV0aGCcXZwY5VkNZMgaa464ihZJGPKE3jskcv5E44U6a6B
 Gi7KXz294f1R7TQHLrOz+N2RqYM5tTzT0Q4cdLqyvm4Twji6WdkwB9v0L5+hkpp0AAAA=
X-Change-ID: 20250506-virtio-msg-ffa-22af72c92150
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, arve@android.com, lpieralisi@kernel.org, 
 qwandor@google.com, jean-philippe@linaro.org, james.morse@arm.com, 
 perl@immunant.com, tabba@google.com, kernel-team@android.com, 
 armellel@google.com, qperret@google.com, sebastianene@google.com, 
 ahomescu@google.com, Per Larsen <perlarsen@google.com>, 
 Ayrton Munoz <ayrton@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1746693571; l=2462;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=yP9xdyLDn20icw2cXMc78rD9G2nlCYHASySS9/q/UWY=;
 b=BcBWajvQYRyKmjeB5Yj6Zkxe9AeDkqG3prhNn9yzobQ+fCQtnj/x0tFJCYFQ1Oxyv0zXqEPWM
 MY7RFpWic5iDyzSxgN/rDha05UcTIX/GW5slH1mzGzeNmIwCB5Ce9ja
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

Per Larsen (3):
  KVM: arm64: Restrict FF-A host version renegotiation
  KVM: arm64: Bump the supported version of FF-A to 1.2
  KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

 arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c    | 203 +++++++++++++++++++++++++++++--
 include/linux/arm_ffa.h          |   3 +
 3 files changed, 199 insertions(+), 8 deletions(-)

--
2.49.0

---
Per Larsen (3):
      KVM: arm64: Restrict FF-A host version renegotiation
      KVM: arm64: Bump the supported version of FF-A to 1.2
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

 arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c    | 203 +++++++++++++++++++++++++++++++++++++--
 include/linux/arm_ffa.h          |   3 +
 3 files changed, 199 insertions(+), 8 deletions(-)
---
base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
change-id: 20250506-virtio-msg-ffa-22af72c92150

Best regards,
-- 
Per Larsen <perlarsen@google.com>


