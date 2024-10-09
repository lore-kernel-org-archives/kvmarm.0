Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884AE1E1037;
	Wed,  9 Oct 2024 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728498974; cv=none; b=USahXvbPMcyCTxTYGy72AzZdtrrNUPRudlnv1wF7hqSyviO03Dztj9aWKoJ9b+bev2uEiT+/NyDHDSB23Q3avLT/cPtOqhSJbySuU2gIxJxLywUipaQLqi3Z3un0WqEQgdXEOGAEJIpeST+iXNM+tCZbeo0adlJ+j9Q2dp+0kMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728498974; c=relaxed/simple;
	bh=M5VW0Gu9YVbBMQ306nAp0Pc7t8pAcoEFUBaMERzl5UM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rQsCV6ZrQCKBEfBwY8Wzd00j7yTXVuFlJfg2MalTdTn4xfOVjBDnWVStaLUmqKYxmLbmFPoD5HGt+/B7IqTWDCWPrqxVdu/A+EX/++NVKL1nTk6dMNw6Glf/LAHwgj0HkJnnQJ1l9Nw58gpNk/7v/XJ+A9nrVLAtoZXPHUowZGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=un+u5UtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="un+u5UtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC5AC4CEC3;
	Wed,  9 Oct 2024 18:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728498974;
	bh=M5VW0Gu9YVbBMQ306nAp0Pc7t8pAcoEFUBaMERzl5UM=;
	h=From:To:Cc:Subject:Date:From;
	b=un+u5UtCjY/0mVfkClFyMkfTvh8ud4sc6N0mD6dp5VOS/3XsdhSFDnAa98LXCfNHH
	 dsYhBiVpYZ6IX51doBPlaphXpd/O1O4syvQl4kDCfaDuIheX9S3b6MC2jkbMYZodcj
	 kOW9uC3wPBEVgt3sOB5dubW2JWOCPrFeNDhSxoky1D2KNzWw9J3KMlM9gN2fXKL5lR
	 RnWdfQe7A3dqNWHXojILKZMFekUncXFGHOQ8MFxxLrxfbmhNbSwbj6ZNjeSJwwq4VM
	 xpPk4Y01a7DPmcsAQAzhHj7RBCiQOdWm5Ou26wiYT5I+X9XavkVDrSt632vPgVz3Py
	 vaKwM9st7lBPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybXf-001wO5-Kh;
	Wed, 09 Oct 2024 19:36:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Date: Wed,  9 Oct 2024 19:36:03 +0100
Message-Id: <20241009183603.3221824-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As there is very little ordering in the KVM API, userspace can
instanciate a half-baked GIC (missing its memory map, for example)
at almost any time.

This means that, with the right timing, a thread running vcpu-0
can enter the kernel without a GIC configured and get a GIC created
behind its back by another thread. Amusingly, it will pick up
that GIC and start messing with the data structures without the
GIC having been fully initialised.

Similarly, a thread running vcpu-1 can enter the kernel, and try
to init the GIC that was previously created. Since this GIC isn't
properly configured (no memory map), it fails to correctly initialise.

And that's the point where we decide to teardown the GIC, freeing all
its resources. Behind vcpu-0's back. Things stop pretty abruptly,
with a variety of symptoms.  Clearly, this isn't good, we should be
a bit more careful about this.

It is obvious that this guest is not viable, as it is missing some
important part of its configuration. So instead of trying to tear
bits of it down, let's just mark it as *dead*. It means that any
further interaction from userspace will result in -EIO. The memory
will be released on the "normal" path, when userspace gives up.

Cc: stable@vger.kernel.org
Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c            | 3 +++
 arch/arm64/kvm/vgic/vgic-init.c | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0d01c46e4084..b97ada19f06a7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -997,6 +997,9 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
 static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
+		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+			return -EIO;
+
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
 			kvm_vcpu_sleep(vcpu);
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index e7c53e8af3d16..c4cbf798e71a4 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -536,10 +536,10 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 out_slots:
-	mutex_unlock(&kvm->slots_lock);
-
 	if (ret)
-		kvm_vgic_destroy(kvm);
+		kvm_vm_dead(kvm);
+
+	mutex_unlock(&kvm->slots_lock);
 
 	return ret;
 }
-- 
2.39.2

