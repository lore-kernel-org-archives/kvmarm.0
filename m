Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044242F24
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 18:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B182FC433EF;
	Thu, 30 Mar 2023 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680201418;
	bh=fBgGAsJKgW21eCAvrmu96jxiCVsUUWV/yN2g3bfy+ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i70gmwmuEwTQxpim0L+E8LlzE9qnYOkwmIgscJeqM/rWIHhQwEhLJSFe1+Yuqer64
	 50Mxnd92t4zhOjJOMJqvNQnxLLBMxe8gP+JkspztBCLc5Wf9THlbhnF8lw+RjpcfKI
	 QPkM3KSAeeV1Z3CifaVUmp04KrcE65hk4nl3tojT59KKr0buQgq9B4BFB/j8SUG9Ce
	 Wn9NEMOeG02CqA4cAl4QGYuEpTro2D8cWX5nYpJuejEhWYEA5K0nUGY0op4BjicZ82
	 7J0d2bbiykvKM59Pq3YYNHv9h+ga97kp0NZOVMFb0n9gNNHwtyTKi78FyHSCKZ79Qd
	 Uf//VcnomMaYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1phx8q-004T02-PP;
	Thu, 30 Mar 2023 19:36:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 0/4] KVM: arm64: Fix vcpu->mutex v. kvm->lock inversion
Date: Thu, 30 Mar 2023 19:36:53 +0100
Message-Id: <168020137263.2928811.2034794726830368289.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327164747.2466958-1-oliver.upton@linux.dev>
References: <20230327164747.2466958-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, james.morse@arm.com, seanjc@google.com, suzuki.poulose@arm.com, jeremy.linton@arm.com, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 27 Mar 2023 16:47:43 +0000, Oliver Upton wrote:
> As it so happens, lock ordering in KVM/arm64 is completely backwards.
> There's a significant amount of VM-wide state that needs to be accessed
> from the context of a vCPU. Until now, this was accomplished by
> acquiring the kvm->lock, but that cannot be nested within vcpu->mutex.
> 
> This series fixes the issue with some fine-grained locking for MP state
> and a new, dedicated mutex that can nest with both kvm->lock and
> vcpu->mutex.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
      commit: 0acc7239c20a8401b8968c2adace8f7c9b0295ae
[2/4] KVM: arm64: Avoid lock inversion when setting the VM register width
      commit: c43120afb5c66a3465c7468f5cf9806a26484cde
[3/4] KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
      commit: 4bba7f7def6f278266dadf845da472cfbfed784e
[4/4] KVM: arm64: Use config_lock to protect vgic state
      commit: f00327731131d1b5aa6a1aa9f50bcf8d620ace4c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


