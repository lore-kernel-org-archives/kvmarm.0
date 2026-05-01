Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF073290BB;
	Fri,  1 May 2026 05:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777613682; cv=none; b=qgkeLxPoLL0am2dUFfrReZPTqNl9DPntHnPj5zbSU1mwTpAwrcWW7tPqW9hA0tzDTeouNXJLUISBybYXX550k3APLsuBXXe9hRHTGcAiqGX+XUXcEjwfL+NtwdJwkIZOW/JrDgTp9mTs5dt0ATdtA0Un739W/CAQullYd/yLMfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777613682; c=relaxed/simple;
	bh=IJOP1QjdMLA8jJRRjWnWIz8Iw1BhlCSTBd7eJQAsNEI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KZcCRA9VZCgL7OpVycDXvbmWP5K6/ZquLYtZDCYfXzdVb1R8I9/SwiLFvd68gHFoFlzohSwqiA4V8GDfkgS051QJc+Ww1SJv809iZrixv7YnSolPvM/RbrWZh1LvcHgM6TcwpURgBeKsUWau7lBquxAihk61iYjK+FE+B+xhl9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOnYNEzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOnYNEzj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3600EC2BCB7;
	Fri,  1 May 2026 05:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777613682;
	bh=IJOP1QjdMLA8jJRRjWnWIz8Iw1BhlCSTBd7eJQAsNEI=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=lOnYNEzjdOpa0zWPH1tEHfDVYSeFS1QHtSCzZ81uSrxOu0Vc6T0dVEigXWhSXLZMi
	 vSdPqPyXUHkk139BiDdEkIyS36JGrwfMahbshqmV6JCjZ1K1fOdf7lbeI3WxikWsJL
	 VL4V8ShWuZtXRc6XfxZfk9bGhq4v6RIgk8oblz88etB3cMhTP7wryQU3Advnlcwv9s
	 mgRuwWfyKrEUhtQ4iL41eOvD/d0Ck0FNrobCh+yUJq33ApVhU9W1U3Q0XRNVrpL+DM
	 DGvzZnkwrf34txyisZxlJ91S2LU1Q8W3cjwQLWsnedM7pm75loJx/uw0SIAmuH5y6+
	 b8tseDs467msw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22412CD13DE;
	Fri,  1 May 2026 05:34:42 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v6 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
Date: Fri, 01 May 2026 05:34:31 +0000
Message-Id: <20260501-host-direct-messages-v6-0-3f4af727ed85@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGc79GkC/43P3UrEMBAF4FdZcm0kM/lrvfI9xItuMmkD7kaSE
 nZZ+u6mi6JSC16egflmzo0VypEKezrcWKYaS0znFszDgblpOI/Eo2+ZoUANAns+pTJzHzO5mZ+
 olGGkwjUK8DZoPRw9a6vvmUK83NmX15anWOaUr/crFdbpJyjF32AFLrgykrTtLLguPI8pjW/06
 NKJrWLF/yjYlD6gdRSksVJsFPmtAOyUq7IpziovVK/UEc1GUV+KESD2FLX+ov2gEMFDt1X0DwV
 hR9FNQQcGlOsVdb8bLcvyAXfhNLbRAQAA
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
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777613681; l=2488;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=IJOP1QjdMLA8jJRRjWnWIz8Iw1BhlCSTBd7eJQAsNEI=;
 b=Dxaofd6X807oR6U7U5Ui78E2f1FQFaKs+SYpUR/QH2ZGlXVKOHPM2gU7WiDfchfvm474lHDdW
 6ap1TvouJE/B4+slty0QWylyDymrQq7O7EdqI58zasLyndB4zXrHwwM
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
Changes in v6:
- 1/2: validate that bits 31:16 of w1 is HOST_FFA_ID.
- Link to v5: https://lore.kernel.org/r/20260121-host-direct-messages-v5-0-2c1614c94e80@google.com

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
 include/linux/arm_ffa.h       |  2 ++
 2 files changed, 40 insertions(+), 1 deletion(-)
---
base-commit: 26fd6bff2c050196005312d1d306889220952a99
change-id: 20251029-host-direct-messages-5201d7f55abd

Best regards,
-- 
Per Larsen <perlarsen@google.com>


