Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481F3683A5;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761839366; cv=none; b=XL9sE78zNhxa3R1AYfLI8y9ukXidU2sSIgkuPBM9tImJ9I/4gEJIvbG5PctV8UgANGD1AB7uXQg5t9k2mFtggkgAVqrHQH3ASE9cMshc55GXjrDG94pYjimAp8NbPuYwDVoyP5ACxNeWeQxqb5cbsLNRDIXoyC7ygBWxH9nqhNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761839366; c=relaxed/simple;
	bh=8s1gw4zxVz4gFDdlU/JyqSmtBI+GywyPiSCpoHCeD+A=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=S38lRwMR1TiSSJNeKgOwpDKLpE/W9he+peBx+xZms/N5S5vLsLEYjhm8SlarSeyHwP0MY5B9PA5b7BqlwZy8ZCt0qdRwkI+JvpZSUPV4qq/47Hn1DYHZHfgrvVy7s4Y4E1b4d+2w7NcfGhDLb0HHTzAybLj1nczcEMpZ+SYZvD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rItTgC//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rItTgC//"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5E67C4CEF8;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761839365;
	bh=8s1gw4zxVz4gFDdlU/JyqSmtBI+GywyPiSCpoHCeD+A=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=rItTgC//OUg6UGbkjCfoDruFY6dB92CLVOIbktYOV5ydZMLmIH3uwEO1mRcm8ooUY
	 bEqlVIKZHHigKgnZ0NfBj465wditDbSJG7IpivPF8P3QElGYnZAcxG9AoHeoyq8j5v
	 NgPAb7h5OzZVEgk0kx8NxkwMfjQtACPR6tnGnFib1GGLcDrtMLf9vOoLm8YDHNLuVR
	 S1KJPH5D9V3Ern4vkc1I5MNgbMgjcj4y9HFific729i3yJ1zpAWufq1QneN/EeWwm4
	 CQMeMjRgzn5m6vAQcOr2+Y0rfJscKmD/nl/HvoVXX7owgoMludpJALMfGLQay7a/8s
	 q3BJKDeqT75lw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98697CCF9F8;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
Date: Thu, 30 Oct 2025 15:49:15 +0000
Message-Id: <20251030-host-direct-messages-v2-0-9f27cef36730@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPuIA2kC/22NQQ6CMBBFr0Jm7Zi2WEFX3sOwwHYokwglHUI0h
 LtbiUuX7yX//RWEEpPAtVgh0cLCccxgDgW4vh0DIfvMYJSxWpkL9lFm9JzIzTiQSBtI0BqlfdV
 Z2z485OmUqOPXnr03mXuWOab3/rLor/0FS/U/uGhUeDqXZKu60q7ubiHG8KSjiwM027Z9AFX+C
 wa5AAAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761839364; l=1188;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=8s1gw4zxVz4gFDdlU/JyqSmtBI+GywyPiSCpoHCeD+A=;
 b=9LSJoD3lZA0ogsX7LA0xU+vNMbRxY6n7pTFWh3e/JFxXdDlXTr4KtfUhi61CMD8w5FrWi1l4E
 vmPTjkBVwR0B0wYyH1/mV+O0LauiIy68LWToplSP+/9mmOsGl6fa4Jk
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
Changes in v2:
- 1/2: Drop support for FFA_ID_GET interface in host handler.
- Link to v1: https://lore.kernel.org/r/20251030-host-direct-messages-v1-0-463e57871c8f@google.com

---
Per Larsen (1):
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

Sebastian Ene (1):
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host handler

 arch/arm64/kvm/hyp/nvhe/ffa.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
---
base-commit: e53642b87a4f4b03a8d7e5f8507fc3cd0c595ea6
change-id: 20251029-host-direct-messages-5201d7f55abd

Best regards,
-- 
Per Larsen <perlarsen@google.com>


