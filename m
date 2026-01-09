Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04622FC881;
	Fri,  9 Jan 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767998073; cv=none; b=YJFfFH6qkT6Egj3uUXhk8yRZnSgrVVs2Nim4YTykYjRFZMYJwf2pHIH58Ugt3HgaXHy1tj/R5z7qXMEkWJCbmS6GULWwmsXjzCiokKbEirLMB1fIogwTT9t04aAznVYRU6dwHvZyRJP7RzePlVmVWWE/wCpye8f4Pj8C5CoOjQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767998073; c=relaxed/simple;
	bh=uANFCEmcX63XWgQM35Dj9Sq/pNBgm6UWZiRuDN/bYHk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=dDllrv9Pesnz2s6CGIpozGg4UggITDrCheTLj+r97RFDyG+lO9MauwyGbZZbUygVNL1APOxuM1ESIhwmlRJ/J+3qxykwqyqteAw601R/QScbBomXLWexKWYKoiuAj9ZUeHl9H4SXoPMcQjXJw+XBHJxuD/0nna91N3yYWp76kBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Thoa/ioL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Thoa/ioL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30545C4CEF1;
	Fri,  9 Jan 2026 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767998073;
	bh=uANFCEmcX63XWgQM35Dj9Sq/pNBgm6UWZiRuDN/bYHk=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Thoa/ioL0nM6mNscnM56WzY7G525LisjSJgnXQLe1iKQERT+gZ5iGKQBuHyHOs6KL
	 Bj6amDZWF6vGWS/HdJwd+lR/kwjMdVylhAtROLS/dPXpvm0kENP6P0wSwsBUo7FAJO
	 YymYC5dmRBwRIUytvk3etprdPod4kl+V6RfLCwr6buniajidwKzr2n3sGBNG5ybCqg
	 C5GPtnjZUdDv92gf87GGDSMYluTjHp6H7wCg8zIQZwCX3SiWrvIrTm7vs8PpsXAZor
	 BFBhx0KS7OeUixVZS/hVKxRqPsedrISFgSr8Z+IVKtyOFZYRZLfsgALLPjEM+3Dnic
	 rKdl5r6JrmUSQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257CDD277C3;
	Fri,  9 Jan 2026 22:34:33 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v4 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
Date: Fri, 09 Jan 2026 22:34:24 +0000
Message-Id: <20260109-host-direct-messages-v4-0-95da4221d186@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHCCYWkC/43PSwrCMBCA4auUrI3k2bSuvIe4aJNJG7CNJCUop
 Xc3LYKICi7/gfmGmVGE4CCiQzGjAMlF58ccYlcg3TdjB9iZ3IgRJilhNe59nLBxAfSEB4ix6SB
 iyQg1ykrZtAbl1WsA624bezrn7l2cfLhvVxJdp0+Qk+9gophgUXKQqlJUV/bYed9dYK/9gFYxs
 X8UlpXaMqXB8lJx8qHwl0Lpj+cSz4pWwhBRC9Gy8k1ZluUB9++Vt0UBAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767998072; l=2128;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=uANFCEmcX63XWgQM35Dj9Sq/pNBgm6UWZiRuDN/bYHk=;
 b=aF5ssKxPqGYzDwYPs8/gWzPT7cTJyRm20BTQzTtIOoTQd/xoO6zxYErntLB+vTzD6UWo39jzZ
 dKqyl3XVnZ3BHNqSquFeV8afUAqccCekAcLicvAKDugexTc/BgVe7lg
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

 arch/arm64/kvm/hyp/nvhe/ffa.c | 33 ++++++++++++++++++++++++++++++++-
 include/linux/arm_ffa.h       |  3 +++
 2 files changed, 35 insertions(+), 1 deletion(-)
---
base-commit: 372800cb95a35a7c40a07e2e0f7de4ce6786d230
change-id: 20251029-host-direct-messages-5201d7f55abd

Best regards,
-- 
Per Larsen <perlarsen@google.com>


