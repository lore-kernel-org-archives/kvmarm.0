Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F57219D8A2;
	Sat, 19 Jul 2025 02:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752891114; cv=none; b=aijxgxcJ40yZTM4GBXbkqoa9zjqpOYYWtBPyUird9iV5FP63vnFQQGqiC+VidbUlzBeTe1Zvr5IUlh5TZ6I1AIHMkKOy5hpGz+rPYIkbQjV6KvGxnr4C7np83O29aoOL2lpSFFftt3qfRfUABI9cPoaP09dK/N9NRVHREkVuDng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752891114; c=relaxed/simple;
	bh=Mp/jgK6Xt9LoSu/naNECO65nKErgpdesQbN446RlRp0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YGl+Kq5mDf0MOoS8Sk7hjZCX071E6KF983CH2gAIR24z0lnSlFo/wBoR8GkmRu9TKrJH2g/NOrdv89xJhrp3mWhWQS7SeG4XStBydhqebc7p/ndEZCcImbvWrOvwmu44PQer+adfCg020MPm6/KCV0YVq3val2SNlsuqPr55YwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/ayT6l7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/ayT6l7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C743AC4CEF7;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752891113;
	bh=Mp/jgK6Xt9LoSu/naNECO65nKErgpdesQbN446RlRp0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R/ayT6l7wFXlgg7aGJK8S37b0YdFH5sFrRyktLemEsrkBxRPWE9G0cFsXPqmhET+j
	 p5xhbLPnzya+vFCgQrfyJrzzGVCR6roN4kOwhMBtMn0r3u/x/UXmPAXrMZnmBo8htB
	 2lCgcRuOCWRqbXOSlmL0tXdWMlnFkt7YcxAQYGFGI4gABjKkGWRWF5Cbc4bLaXWhsu
	 KNFaOtJ1rbUT9d0V0I/GCX6+b07no3TGFULDUteUt+oLKgQp07f9PgAoDqMYUZuF/B
	 Em0N2/sor7dBnaOoiNx5ogVQqrEEwt+CE4jd+ZEDBLzsMglMkvhtUKWuC6JRHrNU1D
	 uur1MzkYlfXdw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2FEC83F3E;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 19 Jul 2025 02:11:26 +0000
Subject: [PATCH v8 4/7] KVM: arm64: Mark optional FF-A 1.2 interfaces as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250719-virtio-msg-ffa-v8-4-03e8e8dbe856@google.com>
References: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
In-Reply-To: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
 arve@android.com, ayrton@google.com, qperret@google.com, 
 sebastianene@google.com, qwandor@google.com, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1752891112; l=1289;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=dgBVrMdjAZFSIYAnESFiV+uLEGMo1SRSm+p8aDNjGJQ=;
 b=IMDnhHhg0FoazYMmOZA5MqsjVPfiAVVoRRaOwqYguuaRhtoI9suue0RLYVCELMYFA2XwFnrmW
 SiPndnyo+0qDWbM6/aUAyJ88rBrYneqLwdQgpn7XWKjl1F0F3qQYkKZ
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Update ffa_call_supported to mark FF-A 1.2 interfaces as unsupported
lest they get forwarded. FFA_MSG_SEND_DIRECT_REQ2 is not marked as
unsupported because a later patch in this series adds support.

Also mark FFA_EL3_INTR_HANDLE as unsupported as it is only valid for
physical instances.

Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 50ec52bcce4b4443c2f3ffeda455594733f3a5a0..5a173ea481940236356e2bc4248d094a858a0923 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -671,6 +671,12 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
+	/* Optional interfaces added in FF-A 1.2 */
+	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
+	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
+	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
+	/* Unsupported interfaces added in FF-A 1.2 */
+	case FFA_EL3_INTR_HANDLE:		/* Only valid for secure physical instances */
 		return false;
 	}
 

-- 
2.50.0.727.gbf7dc18ff4-goog


