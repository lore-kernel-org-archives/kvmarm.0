Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FCE19CD1B;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755652212; cv=none; b=DOboDl7C1eWBTS7Aw8h1Xwwuy8Ubd9z9RKdvOSf4F7iRow+M8YY4o9xmuaQX3uc6R3izq3tdks5ZquImamyGqnRav+kY6W12BnKml2UhcuzCuLG5l8Sb9oYtmu94f/FDwOEd4OLZP/Km1T+FnW4stOXb8v/OjUUVSE7l9GBri7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755652212; c=relaxed/simple;
	bh=tOLJC4XmErVOk1Sghyu21V/WaFzS/sTkdBmrgl3W6yo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K6vpwC3oPU/eMyqdgfFzMABLiz6Uw93VZtskeZw2weWLcrNWKyu1Bw39h4qq7Eig46QN2iqi0Hit4Ib3lRfEYqZlYm8NJGDMMCL3KHay2EiDBo6u61jtEQoSGSwnlyJtl0h7GYC/8457jJBwQ5xUk8Itx6cWcLNtD89BNYV7N9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W10m9Gei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W10m9Gei"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74CCCC19421;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755652212;
	bh=tOLJC4XmErVOk1Sghyu21V/WaFzS/sTkdBmrgl3W6yo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=W10m9GeiBephdiYEc/sT08pqz2c8zw1eaF/xmzWAhyzdmrgeQRkAcc+jcYIRbdnEq
	 /qN2oMr2e31JSJ4YPPHS71fj0k7d7hGZcWvBYpNy1z55PFabtbO8LkBYuxRtBCTcWO
	 RW9HKgaud+FWXrWCPsuX+bsa8jMvivtVSva/qkan5UXjHPKhQ8kSi+Ir8pdL/0O60O
	 kzCe1NhMIjvTfdz9wk9QS84NlFFsBTUzitCNhByWizXZuEd8pnlUxmhREUXmDQfUGQ
	 PdjcPDqxYMVRVTTZ/aCnKMP7fM7HY8bU8OB7xfLdvkDBM/WCSLT3RkQRKa4NNoHPQb
	 X6hO7wC/Wx/BA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67600CA0EE6;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 20 Aug 2025 01:10:07 +0000
Subject: [PATCH v11 3/6] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250820-virtio-msg-ffa-v11-3-497ef43550a3@google.com>
References: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
In-Reply-To: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755652211; l=1012;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=+NnU5kbTyzDsIIrdmhBCiy1drOF1PzOEKH5ncvoLdR0=;
 b=lN3fWnDz8MMhIOGVf5N0OsE4YlgyP2zM3y+yQNZk0pus91GZeGMXsH8yoy3Iklu6aIPMj4rm1
 bgaMrfDrNVLCktM0Ff1IcsgQPl+HUwMvwA4zQOD9qE1xCItiCnAxJLH
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
index 8290396384a2a3294fd64bc0378459829941a64c..40a785b6ed063f9de31f51f1e82ebd9c70b13de9 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -670,6 +670,14 @@ static bool ffa_call_supported(u64 func_id)
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
2.51.0.rc1.167.g924127e9c0-goog


