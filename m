Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2912D267B12;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754706813; cv=none; b=gWsn+7lgtSNX+FFLWFl42i8YyPSHRJfn2GHNuNESAkJWdjNOkLVsF3gErZYvwmhuJiDlU3WSPEkdF7JBwc3fT2jqfGHM0VHI/DfwSK6mz5Yo2XrFn/4y54H2OCEMvBDNN68+zVGeEkxa9rtOwkpe/3/1ZDQt2DUURZYZGbGpklM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754706813; c=relaxed/simple;
	bh=QZCqGr01nfVX2SQxGUdgMSnfcT4DdbvyxpzPQtbLiIU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mZRy6eDBpf6x1JvfwAsvEWakLMrLTMl4eubRKYBMFd4BRc2tFgCsXw0QL53PtTGBLUQEb3gEi/jB/fvdRyKnc129tfYpHualIXDnsZSn2ItE7eVtZ5VAadkxtgzEN1+kzZ++yO9TKb1HlXhtSwkJO6J9NoEflxtV1vgfsycGhL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9PegTXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9PegTXf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF801C4CEF4;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754706812;
	bh=QZCqGr01nfVX2SQxGUdgMSnfcT4DdbvyxpzPQtbLiIU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=n9PegTXfcjQ3AvuL2id9OSI1F2KgacPZcQ4maKkFJUgiEbkhtRNvnWIg5ZqJjFm2Q
	 0fcCezgBNS+dMLm6eAO2pAoLTZwPbHuopeLmF8mqAUScOIqdvK+5ORK03aQBY+VoxO
	 eVfNRUFe7jplzVUb7nTVBNtF2p/OIhuI+5LbDLwPPpy39L71NroFkk5eOArVpAcGy2
	 T11dx3XlDXmJo0Es563qKA3byRTqE4FcyXLhbzc2kclvpO3mYYJgi8hpbdc0dMNdRx
	 K0cdlLDd0LlZof1l25TLaeZHHLh6RTdclOFzd2ZFK2MCiWLq1gjnPYM4RQSUTmAuUq
	 7ZscgmXTeG6Ug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C2BC87FDA;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 09 Aug 2025 02:33:21 +0000
Subject: [PATCH v10 3/6] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250809-virtio-msg-ffa-v10-3-189eeecf8ae8@google.com>
References: <20250809-virtio-msg-ffa-v10-0-189eeecf8ae8@google.com>
In-Reply-To: <20250809-virtio-msg-ffa-v10-0-189eeecf8ae8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754706811; l=1012;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=bwnE4nGlxomBFpOzY2EGPC8YmhMC+Sz1wV7rnPIYoKM=;
 b=k5S5fXzXxfzl/wDoZKbRNcByrY2bIHzKltHWYl3R0Skwox+05E9XPMJK9jiYJjWPkcX1TTbsc
 fG7JPGNCDt9Cito5wfknm6VV/IGr4g3XmaPavz38RNTlot1AVCceDQ6
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Prevent FFA_NOTIFICATION_* interfaces from being passed through to TZ.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 19239f133a1cfb86db1b85251035709481cdef5b..9311268ad77f50fc596ebae77f451ea144418359 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -665,6 +665,14 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
+       /* Optional notification interfaces added in FF-A 1.1 */
+	case FFA_NOTIFICATION_BITMAP_CREATE:
+	case FFA_NOTIFICATION_BITMAP_DESTROY:
+	case FFA_NOTIFICATION_BIND:
+	case FFA_NOTIFICATION_UNBIND:
+	case FFA_NOTIFICATION_SET:
+	case FFA_NOTIFICATION_GET:
+	case FFA_NOTIFICATION_INFO_GET:
 		return false;
 	}
 

-- 
2.51.0.rc0.155.g4a0f42376b-goog


