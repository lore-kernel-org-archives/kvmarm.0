Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F2034D94
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 16:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5ABC433EF;
	Wed,  7 Jun 2023 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686154201;
	bh=T/3S/K34vbfo9IAZL69Dx3Y5c89O0/gI0FHIGvHgUlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgId0U0cOgftqtckUHyW14q6Am2rljEk//bqJHneGzdsHl4Ck3MUWzycVeNRr4y39
	 Fqs51tyTvlutLDESuMQ7vewZzv2ZOHvJZQ7LMTLRR+O18p6WZHYts0hXUmOsMqRFPz
	 jIQHCT34ZCBaLAQavfRmTEf/TIQWsNa/V5aPKlSUIwaMpYHPzghqzwics2aCG8mwh0
	 yWwAQlThimHldevy54bPSRhzyMQHl77fcoFbj5ZavlkTicUFp9QZpImB5Kkw2fHS4d
	 bS/B+QrnmcS3qQG9tTSBxHTUGDGF7ZOunhs11S7Y0ZBNhK25dVCxR/pV94LgRT2EMS
	 G5Zji9lQZdA8w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q6vjT-003Y27-DO;
	Wed, 07 Jun 2023 17:09:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	James Morse <james.morse@arm.com>,
	Sebastian Ott <sebott@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Use raw_smp_processor_id() in kvm_pmu_probe_armpmu()
Date: Wed,  7 Jun 2023 17:09:56 +0100
Message-Id: <168615419108.1840860.15425900821268741190.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230606184814.456743-1-oliver.upton@linux.dev>
References: <20230606184814.456743-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, yuzenghui@huawei.com, suzuki.poulose@arm.com, seanjc@google.com, james.morse@arm.com, sebott@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 6 Jun 2023 18:48:14 +0000, Oliver Upton wrote:
> Sebastian reports that commit 1c913a1c35aa ("KVM: arm64: Iterate
> arm_pmus list to probe for default PMU") introduced the following splat
> with CONFIG_DEBUG_PREEMPT enabled:
> 
> [70506.110187] BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system-aar/3078242
> [70506.119077] caller is debug_smp_processor_id+0x20/0x30
> [70506.124229] CPU: 129 PID: 3078242 Comm: qemu-system-aar Tainted: G        W          6.4.0-rc5 #25
> [70506.133176] Hardware name: GIGABYTE R181-T92-00/MT91-FS4-00, BIOS F34 08/13/2020
> [70506.140559] Call trace:
> [70506.142993]  dump_backtrace+0xa4/0x130
> [70506.146737]  show_stack+0x20/0x38
> [70506.150040]  dump_stack_lvl+0x48/0x60
> [70506.153704]  dump_stack+0x18/0x28
> [70506.157007]  check_preemption_disabled+0xe4/0x108
> [70506.161701]  debug_smp_processor_id+0x20/0x30
> [70506.166046]  kvm_arm_pmu_v3_set_attr+0x460/0x628
> [70506.170662]  kvm_arm_vcpu_arch_set_attr+0x88/0xd8
> [70506.175363]  kvm_arch_vcpu_ioctl+0x258/0x4a8
> [70506.179632]  kvm_vcpu_ioctl+0x32c/0x6b8
> [70506.183465]  __arm64_sys_ioctl+0xb4/0x100
> [70506.187467]  invoke_syscall+0x78/0x108
> [70506.191205]  el0_svc_common.constprop.0+0x4c/0x100
> [70506.195984]  do_el0_svc+0x34/0x50
> [70506.199287]  el0_svc+0x34/0x108
> [70506.202416]  el0t_64_sync_handler+0xf4/0x120
> [70506.206674]  el0t_64_sync+0x194/0x198
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Use raw_smp_processor_id() in kvm_pmu_probe_armpmu()
      commit: 30c60dda219ddda0bc6ff6ac55d493d9db8be4fa

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


