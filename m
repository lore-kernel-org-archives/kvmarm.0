Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021B7801;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752891114; cv=none; b=XJzwK76s6XhLkBZ9iq9zcjuQqPUkldmmuYqBXc49xIaEn7UVoGnlPxJ3NG/TOf+i32yTBIEsg6WWQiwoT5kQnnlzVH+7t9WhQAwabqJNsxFeHTg/vfE/s6nk9n5PM9umKz5Y7QOSTBaRr0BGE/B1XhfdiSEmafAeNqVywT9tORw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752891114; c=relaxed/simple;
	bh=z9zKqXOSztmepElhFfcFd2r9dFNNAVlWOFmeg8346cA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ee7hFqBeWVCXK5jiroLeNW4psx5qIK3Cdd4NaGpZfIDjnCGd7JVhqwgVcJVMWi98QjFApQWJsi5Q2+qJRe0KO+IC+lCn7Nyfw0tFp35gnAWncW82UT2AxUFGnjy1RwE1BKW0ppfge+5uGvz2WazOZNuzt9IyIZLTVkxg5iAW3sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfDonPwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfDonPwy"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB13FC4CEF6;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752891113;
	bh=z9zKqXOSztmepElhFfcFd2r9dFNNAVlWOFmeg8346cA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FfDonPwyTC2Vyi3OA/+yHSTNM5VcNAmFnRbfzYriv8wyrt/BTZgzYSzuveG6qgiXK
	 JWQbc4FWknlEvm1+Qif9urxFj1yf8JX8pWUb4WHwmEpmHLZgHWhsGdyCNlcIJNyvcl
	 ZyAAF8eBc9W/FQvQinThwYu6IpBxzKHDSa20oXh2NDF7Udm9nvScEnEhEXkESKH/hg
	 +O40X+G7qj6byZBmsOL6R28TtPJ4c9cp1Vi1oZLxlZ5DxJi9nAME3RruzI3NEjqxUN
	 q6cpJIEduMKEjq3tsN/qOm7y8cNMQd4IFMzXdKIpqXBi8ClF7bg777VGGrLr3syTHE
	 tG6cLODrRRFKA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B086AC83F17;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 19 Jul 2025 02:11:25 +0000
Subject: [PATCH v8 3/7] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250719-virtio-msg-ffa-v8-3-03e8e8dbe856@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1752891112; l=1008;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=eQvexLnYoTcxsrnl0Pu9EhkGFuUrJCQc4aSj6eFtezc=;
 b=ApBsC/BlD81Hz0BWfbZYdBl0BwB/z9CBGvXFont7uPFbpjiEcaQFLI26mF0x2FqaERmhWlMst
 2ouZvB9XsInANbSCy3Islp4cVzYEtein+r3ifjM3lFZ9DUUuhiBshV3
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
index 52ac3e2689f0c200ebbb57ec564f71a37b0ddc8f..50ec52bcce4b4443c2f3ffeda455594733f3a5a0 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -663,6 +663,14 @@ static bool ffa_call_supported(u64 func_id)
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
2.50.0.727.gbf7dc18ff4-goog


