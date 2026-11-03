Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711182;
	b=WJBicq4uswjK8OEtnl52SJG7BJAqMeT1sZv6rbzfOwuPcGhHk4LJ3Osrmvk8wohHmkTn
	 Vbtq0S3BEavFfpmdcIpCdb9Wo73HeE2rsKHAQkizNVRb7TGCicE6qW8ZebqmQqj73aw4X
	 9OHJ4lBnAu7t94FdlA6OqcWrLp6S1FSSEa+ou10gvlCYm8eJY59ci/O2xfZRgkY7GIaIY
	 u3tnTnKq8V4bPP/aNqAx5gzcsNeoH3jcGpSjbdfJoLe2PYc91BKlQYJS6a7fP/PpV2sv6
	 98bWUVs/Rma0p7Vf93BrhPeRx2Em4JBB9DAccM5hTiM3vMWiBgS6HwAsEml0SI+W5SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711182;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=lzQ3HNWhzYaDLrogyCICl28yU4XbYthw4RCyl8okdbo=;
	b=KbwQMGD23jtMN5oTE3hnR9/Pl1Ph5Y53rAHhQr/HDKdTCPtvd4igqzpuoy+MARHrkLdN
	 32VP7Ey67lKN5QZH8MLfyq3m3pkjlK2lWgR81PEZFtboqcQ478pIhZOco3kjDWwCkTkeL
	 B8yvWzWJuGIf+9fQ0/kGrOxYRkCjDKIU3shajukWWcRX5rRBIGPz9lJIV+aTnDTziXuqm
	 gspfcHGSmk6SJmlCjP+qRqFPTEiaElMYqOB85LRmXIoo5/F/9OvU+U9PD/aYm7oDlxaMr
	 pM3GIbCgFQlvNK/iOImQ9tyqo/e1T02j401HExU12cJjJwxVAF3UBfEYp1ays864ZDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbBcQE6B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3629606D82B;
	Tue,  3 Nov 2026 13:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbBcQE6B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929B31F00A1A;
	Tue,  3 Nov 2026 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711181;
	bh=lzQ3HNWhzYaDLrogyCICl28yU4XbYthw4RCyl8okdbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbBcQE6BgAKqsxg1qBSJIiZSgEW/5Tqudwhnc1dBt7B6Lb1VRvFKD+WlBiC5lFha+
	 v0TXNUOp3uvqeRXT8/X39JP+Y/ruH3Ti6UqVGo7ZzzLIhAqv1PjXSVidW6dav2udBX
	 G8ATcVcx66sGahb40dX+40sFv39oZ1n9T4yNzESrkL/uznIB553wVgR6kUi8YGu9XS
	 lw1HhJog6OhVqg4QNbMABxg5uut2ohPcmbLyDEcO/Hya25ud2tqUW9U5EcCbDX8wGJ
	 m7qnHLTriWPxvJKAWIxTun2C7Oq7Ml0FXqgwmMcwEqJbqvOnl5LcKli8/Fbe3Qva3Z
	 dDLQK1tJx8VUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDT-0000000ATWs-3npj;
	Tue, 03 Nov 2026 13:06:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jack Thomson <jackabt@amazon.com>,
	Congkai Tan <congkai@amazon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] KVM: arm64: Clear VM-wide state when kvm_setup_vcpu() fails
Date: Tue,  3 Nov 2026 13:05:39 +0000
Message-ID: <179371111283.2844725.1554269910653592811.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102075843.2556018-1-fuad.tabba@linux.dev>
References: <20261102075843.2556018-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, ljs@kernel.org, jackabt@amazon.com, congkai@amazon.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 02 Nov 2026 07:58:41 +0000, Fuad Tabba wrote:
> Changes since v3 [1]:
>   - New patch 2, clearing the default PMU left set by a failed INIT.
>   - Reworded patch 1's commit message.
>   - Rebased on 7.4-rc1.
> 
> A KVM_ARM_VCPU_INIT whose kvm_setup_vcpu() fails doesn't undo its
> changes to VM-wide state. Patch 1 clears the feature bitmap, which the
> PMU attributes read before the vCPU is initialized. Patch 2 clears the
> default PMU, which a retry with KVM_ARM_VCPU_PMU_V3_STRICT would
> otherwise inherit.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Clear the VM's feature bitmap when kvm_setup_vcpu() fails
      commit: 2c77a4a3040da8095e052849e2a0a05f598c8601
[2/2] KVM: arm64: Clear the default PMU when kvm_setup_vcpu() fails
      commit: 4d3361e4d60a46781c8697ee1ab9532f625163f1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


