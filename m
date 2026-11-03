Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711182;
	b=PQolzVcgGJXfEwWyxEiz9MZxk4OOSy+9fSdgBNGiFIbnJwFTFW3Jzv8l4IYwAy2KqjBJ
	 GAGVSwXTgWbMKPJBSpoKSRnw3R3y0dtlqlrC2xUVa4jJPEhHBZQTOX8W1xZxFjtRsvQkH
	 yJg8x1GwF3D11QQ+YAv3S6dqp6uly7zJbAV5KJLt7SXY8GK4gh1T3jFOqnckXJ/9nsr7j
	 uGctKnaBkde3Aj9tE4L0U596XeCXCak4kDxpnyx+sdMv0hBaGWs2GJKpxUOwElGO2XwK5
	 UjJ8LWiSLNXt2VDJ0apnaSxRvYxl6TqMNAZpFF/Xdl0P28Px3fjQhspLEyyVkfxUUHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711182;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=vCbJtWSQWA+dOppoLln3XQQI8iTRF07B0RxyzIkvfdc=;
	b=3yw9O23hOQCNE3ilLP19zXRHcxSlm8VcnhbdOGCFHxOSW1iUidoo5OA/Ro/vWdyrKRLs
	 sT0YdQ39Rn4OkwTzG+oTdkKgxrJ5D1mFD6DSZpnJQEA+FJD/iB2cM6yKGcyu6aIdeb3aO
	 hUgtc/0OqJLv8F/LphGEcEN+cVJ41ltdWrjJIw3bEfvBKrrPdXE4/wDbDY5/7FPHrUv8I
	 LdgTFDVVUtwAhKXQ9AJKKWRtuzKGCRfI8Un5Rlq0aV0+n4U0kQjPXVtv5uchnhcBMuLNh
	 3Vrj451EFKn2qwFArSwJK4V1zoFJ4RnU4Rz8HVHiWr38FGCkgKzIjOqq5qTwiDKD8Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBbfLRUi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE67606D83E;
	Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBbfLRUi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E851F00A27;
	Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711182;
	bh=vCbJtWSQWA+dOppoLln3XQQI8iTRF07B0RxyzIkvfdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBbfLRUiPpiCX6Fgou3CvHgZue94Mcmz5/yGZPxQwvZlXGb/5yhGuBKNC8FB4xvwZ
	 JL8SF1aFcUvfyulmDMwjCP2erGQpbn53D2cU8Yl80yS3FPdp+M3/XJ6xPnxEtxzz8h
	 gM+jbu8sK5xGqcOn0+7hzQ4ylcHb45bjcy6o9NmwLv0cnd1ygqP3Sc9PqBUsCJxqnD
	 tbsDK1V0TojW9vS43YezrF6i3peXHhwymukFNBDcLuh2Y0LC1NTyM0g2mlIsR8+f5S
	 3skV73lZgAa/gQKm2LvzH5XRlVuqx8s6DFsy0kJ8w8YGn/CNhU9gr+2DVsGWHA8kRa
	 fqnCmlLDKgyig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDU-0000000ATWs-2dNj;
	Tue, 03 Nov 2026 13:06:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	Joey Gouly <Joey.Gouly@arm.com>,
	seiden@linux.ibm.com,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] KVM: arm64: vgic: Serialise CTRL_INIT against vCPU creation
Date: Tue,  3 Nov 2026 13:05:42 +0000
Message-ID: <179371111236.2844725.3353773125671356763.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904174419.76057-1-sascha.bischoff@arm.com>
References: <20260904174419.76057-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sascha.Bischoff@arm.com, nd@arm.com, oupton@kernel.org, fuad.tabba@linux.dev, Joey.Gouly@arm.com, seiden@linux.ibm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, sashiko-bot@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 04 Sep 2026 17:44:20 +0000, Sascha Bischoff wrote:
> vgic_init() compares created_vcpus with online_vcpus to detect a vCPU
> being created. However, CTRL_INIT only holds config_lock, while
> admission of new vCPUs and updates to created_vcpus are protected by
> kvm->lock.
> 
> A concurrent KVM_CREATE_VCPU can therefore increment created_vcpus
> after vgic_init() checks the counters, then block on config_lock before
> publishing the new vCPU. For a GICv4 VM, vgic_v4_init() consequently
> sizes its vPE array using a stale online_vcpus value, leaving no vPE
> entry for the new vCPU once its creation completes. The upcoming GICv5
> IRS support would hit the same issue when sizing its doorbell domain.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: Serialise CTRL_INIT against vCPU creation
      commit: 5f54835d94db2e896ec27415b9de2e81cb56009a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


