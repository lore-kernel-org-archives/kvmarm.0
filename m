Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795574693;
	b=z8QmDL2OAJ6MSsetRR1Wm7pdBL4ZutZfkLnnm2e5ELHYKtgrmQ8X5SwWiU+9p7nbR08T
	 t6v8cqKGGxqB87aLxgpLp5uO6SxkHrLE4ATQcDCk83BglvghE+Lp9J3IhUqbisT/MlQZN
	 TeVW3hG+IxRcWrwbt9/Nuhdf3BX5zyP0KF7vPfOkDe7eVgnUzJ4HAxpAH753GKwyNDl6o
	 BAe7pGRRO72vdKAOTnNeHUMXxJV3xOn7uMQHbxyuOHv4cvjjifk3ixdo0K75QouIjfxR1
	 qn0RbGj7Sy9jcFeQQB6l/NAzDrEGA4+tj+o8jgLngzidc+nPEJXYlFThGTChvcJmfbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795574693;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=B7IVwaLX709fibbh48hYcRGHLFjLr6z7tBEQ95zSkf4=;
	b=VT0Wo8WMoNnP246yxU8myWrFH8ikcPazMi8PORwTmogYEsl5Q7GfjhOL7Z+pG1DTe2Qq
	 zbjmvMhjXzbG6jF5HezuV3y3P0PT+iCook8zGhEtoRp8XfyxElW4B2B7p8gQUNEENy3td
	 KO/GF7OJ31xQ9Iv5U6ipbB+Fdod145puvL5eWisN2EQJTUx4fhif450aSfy+hWT5XRyWL
	 q9uwlgwt9cWzEJ/w6wBdlj+lqQ2Cy2d5uZMD7uMryeGmDe0mtZcaZcbNGFt7DnCwb0oL7
	 VPnieMpYdH6k/GQKbD1C1wi1gqWsa2U6cVn+j9oiSMFA6BBnmeYsb+kEkFqQ7RSjw1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mqmVlJ8z;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20889606A31E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 02:44:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20889606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mqmVlJ8z
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D8F3497;
	Tue, 24 Nov 2026 18:44:49 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8F7BC3F86C;
	Tue, 24 Nov 2026 18:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795574692; bh=EH5jCtEKN4qmBLVKifvj2kcfoizIrrQECfZK1Ci94BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqmVlJ8zKYlxN4YCP7cbUFVxvmwF3D7MByf6dm8glttu3k4ePY9wlc/z/eTX0j1IK
	 ozB08w7LtbLcSyrXdYUVJjTsiYTtfWUZA17LPMaQXrOIDrJ3Amd/96Y3j8gMDcuCyV
	 rNAe9ND7Zmuu10nJqNdOmLw3AitJNa5WagvLy8fU=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jia He <justin.he@arm.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 1/3] KVM: arm64: nv: Inject an SEA when the VNCR walk cannot set the AF
Date: Wed, 25 Nov 2026 02:44:24 +0000
Message-Id: <20261125024426.3464050-2-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125024426.3464050-1-justin.he@arm.com>
References: <20261125024426.3464050-1-justin.he@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the guest hypervisor enables hardware Access flag management
(TCR_EL2.HA), KVM's stage-1 walker sets the AF in the descriptor that
maps VNCR_EL2 with __kvm_at_swap_desc(). If the descriptor is in a
read-only memslot, the update fails with -EPERM and walk_s1() records an
SEA on translation table walk in the walk result.

kvm_handle_vncr_abort() does not handle -EPERM. It neither injects the
fault nor maps the VNCR page, and returns to the guest. The guest takes
the same VNCR abort again and never makes progress.

Treat -EPERM like the other walk failures and inject the recorded fault
into the guest hypervisor.

Tested with the selftest added in the next patch on a Neoverse-N2 host.
Without this patch, the vCPU exits about 1.3 million times in 5 seconds
on the same VNCR abort and makes no progress. With this patch, the
guest hypervisor receives an SEA on translation table walk at level 3.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-230439@kernel.org/
Fixes: bff8aa213dee ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28..59d82a29ec01 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1737,6 +1737,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	case -EINVAL:
 	case -ENOENT:
 	case -EACCES:
+	case -EPERM:
 		/*
 		 * Translation failed, inject the corresponding
 		 * exception back to EL2.
-- 
2.34.1

