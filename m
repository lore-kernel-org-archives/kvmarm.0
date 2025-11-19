Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E27227EA8;
	Wed, 19 Nov 2025 02:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763518094; cv=none; b=FCZ5OQPPzRufFhH9OLjvSVQDEi+Gabvp8dT/MGEHO7qAqT5yFUEH0m1qouGo1SdCN/FhIRifTO5PpxK8GMdlJHG+fPsxb2yTwNFAUR7Xz7+FngI+veCk2lT53x+MnFamQ0pdL+5hOLf9kpJ44isK/ys7l9I8XUfCMA2y4ES/TAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763518094; c=relaxed/simple;
	bh=mNMEmJgEYNIBOSgKfDnjr28WG1m9XhnWBodP8OCCvxY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=k9/7uUQD7r6NlzW5YYOdw9vxedMezMfawlI6/l09AfKrN6Ladtu7OdpDQaQVWMKWNbioeUWRoT+p5vVxYk6P1gFr5PBoZBzfgTL0fg9TOpPzydMb3VaYXuNm5NTZx8mZW8hOJVg5r21AJHn6Gu5WQy0QcRn4aT0Zq1Q3lqQ9lTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gx1jlkT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gx1jlkT6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D301C116D0;
	Wed, 19 Nov 2025 02:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763518093;
	bh=mNMEmJgEYNIBOSgKfDnjr28WG1m9XhnWBodP8OCCvxY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Gx1jlkT600yGc6Yfc7/HoAy3FABVGIz799McJl+zOkcnbis0U4worhN3oySvwho0P
	 0KEtfAaAIeYtwIHxMHxDMqGM9zy+v3IAgYOabd0/iY9NTgWNZ8FNY1ZEmoezKImVir
	 XftMMnSnNDFHNCy+EorOLwJTGD8ueXJ+nsuPM9+fk9XWFLsHk0bw3+Gnz1qaNEgBPB
	 GAhEAEtUIIL5wLt00J7fGtCrjWGbx+iFIeQeADeiEMCi8MwKQxE7L7rLf48AwlLCO5
	 ET8nObUKjBbpPF5K7VzxYigjPoTpK0jb4pDE4yEIgz6Rket/u2tF2VbTAObaGVwg3z
	 fZtGaHoETOQUA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150A1CEE35E;
	Wed, 19 Nov 2025 02:08:13 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v3 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
Date: Wed, 19 Nov 2025 02:07:52 +0000
Message-Id: <20251119-host-direct-messages-v3-0-c74d04944b26@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHgmHWkC/43NTQrCMBCG4auUrI3kxzStK+8hLmoySQO2KZkSl
 NK7mxY3gguX7wfzzEIQUgAk52ohCXLAEMcS8lAR03ejBxpsaSKYUJyJlvYRZ2pDAjPTARA7D0i
 VYNxqp1R3t6ScTglceO7s9Va6DzjH9Nq/ZL6tH1Cy32DmlNFTLUHpRnPTuIuP0T/gaOJANjGLf
 xRRlNYJbcDJWkv2pazr+gb36vfl/wAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763518092; l=1768;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=mNMEmJgEYNIBOSgKfDnjr28WG1m9XhnWBodP8OCCvxY=;
 b=wtFY4QBdUD08j2qc1AJqDZSKK1OvUYEL6zlb1B48v3NdUfiw3eaGLkBm3PmsQLp5ST/sXvDZn
 qF0op+1cQv5CWqUEDSHGTRU2gk4NuqL84Q5cOcpxdYeJ9UoRGQtVk4A
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

 arch/arm64/kvm/hyp/nvhe/ffa.c | 33 +++++++++++++++++++++++++++++++++
 include/linux/arm_ffa.h       |  3 +++
 2 files changed, 36 insertions(+)
---
base-commit: e7c375b181600caf135cfd03eadbc45eb530f2cb
change-id: 20251029-host-direct-messages-5201d7f55abd

Best regards,
-- 
Per Larsen <perlarsen@google.com>


