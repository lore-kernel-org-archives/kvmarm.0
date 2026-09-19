Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9787A2472B8
	for <kvmarm@lists.linux.dev>; Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789821117; cv=none; b=KpBMhjblBLx/blwzMgUAtpUboM9LixuRSg7tz4HFzVKVMk3/JD24ToA7+0v1Io+s52L8NuBRq6kD9KOZAQK52S+SyIJcdDxt/hn+Va7yzAVikYLX7ETkWWkV7uc/YE4OkKb57Q3Mqfmz08TsvyTb8pzCoXEN5DmuvwMLWx8gQtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789821117; c=relaxed/simple;
	bh=Z09PM+sbiAw89zsf5mxv0G+eBy/fS8Te4LZ1v8W+7kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo0kcDcHWhA4H+1Hp+dJD+AIWCUib3waiq7i6bLJkT8QTbqgykpUiJ1Gr8Mr/18Mnh2fGmB7nL/zkfbqp36n3zw16t9n8jfZoSe18Ymco0MY3Sg0MEmqLqUy8tIi2hMucYujxlm9MHsUE4RTw37d6Lsobi5wjFdy8sQkrnbCCFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkPIttP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkPIttP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3421F00898;
	Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789821115;
	bh=CGtiJKFC+4PqVoLKD/yH9r97ziN6wjqXvuYJmigg/rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkPIttP3wENNkUS8Jqc7U3PZ8Zz3btYMznZ2rlc6Aj/Yt3gWBAQcHDShvUeYX5rCT
	 /SYADMXh2uySLF8MnAlbL9VeljSm0tD7HM+Dh11JrgnFGG6vqbKoGseHt7xgLgjava
	 CDHw4fIG0eMKjXGRdJSc5WXlmcOcQBq8nx1DPvwgAkb0XOCIGZqiT/QjRXhZWKdqGk
	 w7dUDSgo+68m+iJ4XSZ75hSXX8LDRsgoIYs1w8EtCE7CbtuehPCuxucdEjUwGew9Rv
	 B44jkOamU0sYjm880Ssf2mocwh93BUuNzS2jRmroZ8dnlbf02krpTV3iU+PwJ8yemv
	 j+QVOKDVIHbdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x7uET-0000000AwvV-2LdR;
	Sat, 19 Sep 2026 12:31:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 2/4] KVM: arm64: vgic-v5: Correctly reset h_lpi_ist to NULL
Date: Sat, 19 Sep 2026 13:31:48 +0100
Message-ID: <20260919123150.3283606-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919123150.3283606-1-maz@kernel.org>
References: <20260919123150.3283606-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Resetting a pointer to 0 is not completely wrong, but sparse
legitimately shouts about it integer/pointer mix.

Use NULL as expected.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609190952.glUgOBvp-lkp@intel.com/
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgic-v5-tables.c
index ba8a8d5fcc2a3..d7196ed5d1bfd 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -1066,7 +1066,7 @@ static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm, unsigned int id_bits
 		/* Free the L1 IST again */
 		vmi = xa_load(&vm_info, vm_id);
 		kfree(vmi->h_lpi_ist);
-		vmi->h_lpi_ist = 0;
+		vmi->h_lpi_ist = NULL;
 
 		return ret;
 	}
-- 
2.47.3

