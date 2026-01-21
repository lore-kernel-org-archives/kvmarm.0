Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BEB30E0F4;
	Wed, 21 Jan 2026 08:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768984039; cv=none; b=WVz8g0bv0E0oE7X9MfW4qv7Dc33ka/jwoJCal1LyLU/ko8kw4dmKJWTZ83M7wxbBWWUB4PU7qMEEUiz4QMRxvkCdcA9rX84CJwHG66cSqS1A8S/zGY1IIioR7107uYuokPiIuM4eB6ARH8lMX6Oqvqjc6plRCGjIqOSx7Zm7zqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768984039; c=relaxed/simple;
	bh=cQzCdOlysfcwSAXig6FKFPi8qbVKzsFXGYR1TM3D2sM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JYEj35aaySVX5ppEVIOxpvfQptozQyL7T9suizml2z7Bb88RK7ljwWHE3XEYHLqzZOTx2LSyFSyxD52+0pLByCa8iaqqaET1RhhqxHsQ75OLPDiUsBPsEjK1yW7b+CxjA07aXG1N8YUxVIP1BIaxVguj6SiF/GutKV9O7xVVgxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lT6jnocm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lT6jnocm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32A6EC116D0;
	Wed, 21 Jan 2026 08:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768984039;
	bh=cQzCdOlysfcwSAXig6FKFPi8qbVKzsFXGYR1TM3D2sM=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=lT6jnocmKaTUTUIUSaR71vM51dCqr5y0XS/hX8kz41bkQsLsbUEEamUN6t/IYdE21
	 7tE6HjKfS6mtPfbzvGOrxidWDyE+1f/ia/trWks1zd9lE699/6MOImxLvibJmjjSWa
	 a4LdNGdo6APOWAMbl7QYoe0UaADzai44BXCNLZJ8o/TP4jkUTxDFBekxFZzkC+6Qgv
	 dLcFFauRoOBso3vQdyp3hVLR2cFyt7URypTM0YTzyNAM5C5jhcfk3Gb/nfRMdJfZjd
	 nmdmHuIVqOlCur4saqMhO5N9iuRMFEsfVR880LU+WKreq/C+mzI0DMPSZSd04ovfhs
	 EKSxRLaQktw3g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F37BC44502;
	Wed, 21 Jan 2026 08:27:19 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v5 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
Date: Wed, 21 Jan 2026 08:27:11 +0000
Message-Id: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOCNcGkC/43PwWrDMAwG4FcpPs9Dku042WnvMXpIbTkxrHWxg
 1kpefc5ZWOMrrDjL9D3S1dROEcu4mV3FZlrLDGdWjBPO+Hm8TSxjL5lQUAGgQY5p7JIHzO7RR6
 5lHHiIg0BehuMGQ9etNVz5hA/buzbvuU5liXly62l4jb9AhX8DVaUIHWn2NjeouvD65TS9M7PL
 h3FJlb6j0JNGQJZx0F1VsGdon4UxAfPVdUUZ7UHPWh9oO5O0d9KBwiPFL3dYvyoidBj/1tZ1/U
 TYrxToYsBAAA=
X-Change-ID: 20251029-host-direct-messages-5201d7f55abd
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Armelle Laine <armellel@google.com>, 
 Sebastien Ene <sebastianene@google.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768984038; l=2274;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=cQzCdOlysfcwSAXig6FKFPi8qbVKzsFXGYR1TM3D2sM=;
 b=tbWIPz2+0mSpsec3Xa3QoVglkBclxYCItvNgsUk21mpl9u7YjOgTnHoVxhKwd+Rz1XkEVsTsA
 3tEGoyXf7EwCFP5X0SfvcVeTrifAgIygwdr8/RQgY1zrcCx1dWrnp4i
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

Support FFA_MSG_SEND_DIRECT_REQ unconditionally.
Support FFA_MSG_SEND_DIRECT_REQ2 if hypervisor negotiated version 1.2+.

Framework messages (FF-A control plane) are filtered out. For
FFA_MSG_SEND_DIRECT_REQ, we look at flags in w2. Messages using the REQ2
interface are always partition messages.

The second patch was part of a previous patch set [0] but was dropped
since the use case was unclear. A clear use case has now appeared: use
TPM device with CRB over FF-A when kernel boots with pkvm [1].

Tested by booting Android under QEMU.

Best Regards,
Per

[0]: https://lore.kernel.org/all/20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com/
[1]: https://lore.kernel.org/all/20251027191729.1704744-1-yeoreum.yun@arm.com/
 

Signed-off-by: Per Larsen <perlarsen@google.com>
---
Changes in v5:
- 1/2: do_ffa_direct_msg: validate that sender is HOST_FFA_ID.
- Link to v4: https://lore.kernel.org/r/20260109-host-direct-messages-v4-0-95da4221d186@google.com

Changes in v4:
- 1/2: do_ffa_direct_msg: check that flag in w2 is zero; drop unused vm_handle parameter.
- 2/2: ffa_call_supported: simplify logic by reordering cases.
-      do_ffa_direct_msg: switch polarity of check and update comment.
- Link to v3: https://lore.kernel.org/r/20251119-host-direct-messages-v3-0-c74d04944b26@google.com

Changes in v3:
- Filter out framework messages as suggested by Will Deacon. Update cover letter accordingly.
- Update trailers: Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
- Link to v2: https://lore.kernel.org/r/20251030-host-direct-messages-v2-0-9f27cef36730@google.com

Changes in v2:
- 1/2: Drop support for FFA_ID_GET interface in host handler.
- Link to v1: https://lore.kernel.org/r/20251030-host-direct-messages-v1-0-463e57871c8f@google.com

---
Per Larsen (1):
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

Sebastian Ene (1):
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host handler

 arch/arm64/kvm/hyp/nvhe/ffa.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)
---
base-commit: 6c790212c588fddeb0d852f2790840753bb604b1
change-id: 20251029-host-direct-messages-5201d7f55abd

Best regards,
-- 
Per Larsen <perlarsen@google.com>


