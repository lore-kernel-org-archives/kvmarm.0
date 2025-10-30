Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBEF3191AC;
	Thu, 30 Oct 2025 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827391; cv=none; b=JeJR6PUZ6KtC2YOwbfeiBixVbArI8qEexMUzGqBrJz60WDP2EjONrHXUhpZPc5YbBTYZrCOXMk7vLmykvLPgFhYhzRcc6CS0rpDPFLCmOfRyb8H4BBAn5e1sHDTD3BaG4a5IJcxXahoQJePaCo33T2lnYTwxqiFf+mousw3sUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827391; c=relaxed/simple;
	bh=8lOt5hjMRohwbmB1ls9eEfGExLapiWvkkYYw/nN1DJc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Q8W/lZKH6qsnxPlgE6Nz5Lr8HbrU90eZf0SERVcBLt8fZHiguTIgHj3Sq/QS6/VVGNFz3T6xTcthH+wnqkzleMCR7Yus3ps1MlLusJeEBdMUyWWODczFmqxwegvOrZbnHParozMjADgxF5xu0MBcLx/TQpAJZRk4yCLEggQQAVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pqj5hn5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pqj5hn5v"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C63C3C4CEF1;
	Thu, 30 Oct 2025 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761827390;
	bh=8lOt5hjMRohwbmB1ls9eEfGExLapiWvkkYYw/nN1DJc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Pqj5hn5vGCM59+8y+IfnD+NqIKiP+Xtio5j4+HF6yFJoeYjW0mhV8G6NM8LNCo/6H
	 y/DfKeEzHQFvd6pc1/eyGJY8FFchHQv1e9WsEXmIAV7p9+wQNO0izv6NeLLgkD9EZt
	 qF1HrFtYAv29uJpQxzP56fwtn8n/IfDw8TbhUOrtYdAXqgjuep1YkcgsZwgumWdkQs
	 hk4X7OKvq34qE75vCwdFPEANodb5k1P1J0ljsEuP5dPM0ZQAKEqohuq+JBKLVmNejB
	 mGp6eEpLVwLImaZj9bPbdez7gtrER6PkGg2fh8JEm8h1mPzpFT1gTzl5ppyDdSv+bG
	 a1nwdG1BUS9wQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8B8CCF9FC;
	Thu, 30 Oct 2025 12:29:50 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Support FF-A direct messaging interfaces
Date: Thu, 30 Oct 2025 12:29:38 +0000
Message-Id: <20251030-host-direct-messages-v1-0-463e57871c8f@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADNaA2kC/x3MQQqAIBBA0avErBtQQaKuEi1Mx5pFGY5EIN09a
 fkW/1cQykwCU1ch083C6WzQfQd+d+dGyKEZjDJWKzPinqRg4Ey+4EEibiNBa5QOQ7TWrQFaemW
 K/PzbeXnfD7oEG9ZmAAAA
X-Change-ID: 20251029-host-direct-messages-5201d7f55abd
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>
Cc: Armelle Laine <armellel@google.com>, 
 Sebastien Ene <sebastianene@google.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761827390; l=1005;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=8lOt5hjMRohwbmB1ls9eEfGExLapiWvkkYYw/nN1DJc=;
 b=SJc2WqLL6M7DVif/tAgJkM8/baVdgfC8ov9MMIpqIYFzZPFOsWgplIQTkOdS2vLv+95zxxAYh
 2taGWk+ftFWCco5JzZEUezmUWPMA5uE16SLfkeGoq5HMLDAN/meb0wr
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

Support FFA_MSG_SEND_DIRECT_REQ unconditionally.
Support FFA_MSG_SEND_DIRECT_REQ2 if hypervisor negotiated version 1.2+.

The second patch was part of a previous patch set [0] but was dropped
since the use case was unclear. A clear use case has now appeared [1].

Tested by booting Android under QEMU.

Best Regards,
Per

[0]: https://lore.kernel.org/all/20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com/
[1]: https://lore.kernel.org/all/20251027191729.1704744-1-yeoreum.yun@arm.com/
 

Signed-off-by: Per Larsen <perlarsen@google.com>
---
Per Larsen (1):
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

Sebastian Ene (1):
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host handler

 arch/arm64/kvm/hyp/nvhe/ffa.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
---
base-commit: e53642b87a4f4b03a8d7e5f8507fc3cd0c595ea6
change-id: 20251029-host-direct-messages-5201d7f55abd

Best regards,
-- 
Per Larsen <perlarsen@google.com>


