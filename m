Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3059840C01
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954739; cv=none; b=DFJEK4yZeCLE/um5CI38FjMIC9DxRfggIi3lqSRdYY2/0p/1V4rb4WL5mKYDdV7ikD6htwUS2vx5d9SI+Xx/nLqzBoTrjJOQqFPcxhPz3XxRYIoNFjMd3GegXnQBnXT4SDQEXADFhelx6L474Nv6IAqH64bM/SEUgMX1mgiuU5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954739; c=relaxed/simple;
	bh=zJzedstPNPXZDOod74i34EIzt6/XZqUrd8Ks1qqhZvo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qyKjyj6siYwpKI8fE73r7puPG8W5br3HpQHvc/GTWL21+/DQat+5IX69sbsd3KaquMNTkvjGPspg0MuCa+q1eaBQ+50lHe9BzKQnc5+te3sbybkCSylt3lTIDyjG66e+Pimt1n53lNsY4KIEzw9MwUiMpQXZ1TBsEHsk5NUdTRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lB1eAio4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lB1eAio4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00961C43142;
	Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954739;
	bh=zJzedstPNPXZDOod74i34EIzt6/XZqUrd8Ks1qqhZvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lB1eAio4WfngrlOFBNYKkcWD7OBCwBORkR2//OU1GrpqH9Dk2SOqJJuf3VhFSOMQN
	 sjo0uflyvaoLTQkYhkWvYyW7dvHkW73E67j0vqW/6RxSaulGdEr0/VERVro4O4HU3J
	 JV0dlgyKVUh8s/a3gW9+q6vPouRZJ16ZX/nFUy2uZboyfQ+mB3E7Iid4sv8/TOr9Nq
	 SCUUWjUyjCp8D6hz86zQNJxy8RkGDWLXDj9200AB0HPwooTNc4q5OAtQZWGt/xLaiK
	 4ts72XpUmOctXKKjBKwcWm0BO0Y39LZnldYLx2bmT+m8osw5VZoTuuE8X5s/smZzI0
	 npzdKjE5BdCPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0kz-00DjkQ-3x;
	Mon, 22 Jan 2024 20:18:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 08/25] KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
Date: Mon, 22 Jan 2024 20:18:35 +0000
Message-Id: <20240122201852.262057-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

There is no reason to have separate FGT group identifiers for
the debug fine grain trapping. The sole requirement is to provide
the *names* so that the SR_FGF() macro can do its magic of picking
the correct bit definition.

So let's alias HDFGWTR_GROUP and HDFGRTR_GROUP.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 7a4a886adb9d..8a1cfcf553a2 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1010,7 +1010,7 @@ enum fgt_group_id {
 	__NO_FGT_GROUP__,
 	HFGxTR_GROUP,
 	HDFGRTR_GROUP,
-	HDFGWTR_GROUP,
+	HDFGWTR_GROUP = HDFGRTR_GROUP,
 	HFGITR_GROUP,
 	HAFGRTR_GROUP,
 
@@ -1938,7 +1938,6 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 		break;
 
 	case HDFGRTR_GROUP:
-	case HDFGWTR_GROUP:
 		if (is_read)
 			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
 		else
-- 
2.39.2

