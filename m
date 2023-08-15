Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5821426C
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 19:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F470C433C7;
	Tue, 15 Aug 2023 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692127770;
	bh=YUhBv0J6Gc231wiStSU2vUwX+JbUWEWfxDvQljOUgcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4AZHUM1Zm74aJ/t3NYO+Tlaymm6vLwLSu1SXWdvfyQ/vOUpzvYmzuIHXPzEAJ8dD
	 mm6cBxCogdCXWDx8QYzOiv7CduvQo0nA9/pbxYy82xjcz5fP52vm30y5xoXUh0BjUr
	 nh0GNdOL9QxV7gFUUHuo/5hYWgpgExlL3nnStLVgzmz9+a9ZzTBwn0tttmsssErofv
	 IfOfPWKAXJQvmcXLP9/RJ/iv46opm/s3SHcL6YoN1Rixh7+jADd4GMNEnxWM1cP+06
	 B9jZ061YrqOQQDXvdrWip+/lUMvCYg97wQVUQMmoScBa09ZtRNBz2T8u24Y0wek/Bt
	 eWcIt7yw2GzuQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qVzjL-00575e-VP;
	Tue, 15 Aug 2023 20:29:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: Yue Haibing <yuehaibing@huawei.com>,
	suzuki.poulose@arm.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	gshan@redhat.com,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	yuzenghui@huawei.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH -next] KVM: arm64: Remove unused declarations
Date: Tue, 15 Aug 2023 20:29:25 +0100
Message-Id: <169212775346.2736618.8506251309188166364.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230814140636.45988-1-yuehaibing@huawei.com>
References: <20230814140636.45988-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: yuehaibing@huawei.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, gshan@redhat.com, oliver.upton@linux.dev, james.morse@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 14 Aug 2023 22:06:36 +0800, Yue Haibing wrote:
> Commit 53692908b0f5 ("KVM: arm/arm64: vgic: Fix source vcpu issues for GICv2 SGI")
> removed vgic_v2_set_npie()/vgic_v3_set_npie() but not the declarations.
> Commit 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early") left behind
> kvm_arm_vcpu_ptrauth_trap(), remove it.
> Commit 2a0c343386ae ("KVM: arm64: Initialize trap registers for protected VMs")
> declared but never implemented kvm_init_protected_traps() and
> commit cf5d318865e2 ("arm/arm64: KVM: Turn off vcpus on PSCI shutdown/reboot")
> declared but never implemented force_vm_exit().

Applied to next, thanks!

[1/1] KVM: arm64: Remove unused declarations
      commit: a6b33d009fc1fe80c935f18b714b36c81e1f1400

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


