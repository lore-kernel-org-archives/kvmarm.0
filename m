Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214E625776;
	Thu, 17 Oct 2024 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153396; cv=none; b=UEuiF4s0GLe8kdIbRtEAocsM/xJq6gmJizpG5eO/ZEB0AnoqBTxr23yUix8FDZf4WlsfpdcX7E8ymRIoCTM4VBMQotSs1JLrZGq1AYn5owsxP9bFVVfohJcTj33P1t04i2B1e8I3c+fXEebUN42xeKNuU2OongtjK8B/Mj3+flc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153396; c=relaxed/simple;
	bh=1KsqZNolBHazkASsyK7p/JCNfrY1ma2oIBPweDnshBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lb7UKmUJhrN4kaOy38YFVxLxOy26BBe0bPIHi8R7ZPUTfEC5PnhXj30QqDMPakUHQDiLjhwtEHJSc5/z0eztQEB9cXraRJnbRrGktj63MTrY5Qyq9OYcfpakppgjasH4vWgrdgop5W3ez56x7CBVxT+EzRixkTdvznSxZkBtH80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWkzHAnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWkzHAnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A574FC4CEC3;
	Thu, 17 Oct 2024 08:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729153395;
	bh=1KsqZNolBHazkASsyK7p/JCNfrY1ma2oIBPweDnshBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWkzHAnx8cOVzSaJAAwD2F9oNXJpvVxMnlzkgmIu6HpnbmjDOY9afOVFRksyB09NK
	 rmQhYYeYNA8yItxD5Iad3/vHGGrvrioYUvuv9KPR5hSQJLBvmuVPLeFrZY89E8IK7P
	 5H/oNRSXbp0n7wg3vRfROGlZ/cJb1TItymnepnZvLsvJqZTXtKV982j2FTuUZPo2Xp
	 vIoOXQMUANADCY4k/Ls8F05XlBd1yp9lvmiQx+3eWuu6KShiJpxNjRiYJh933Yf2PV
	 nwHdXOlujTk6wlEmjU3Ld+Bj6KcEp3w7BE85VqYs/xmfSeTUnVLljnUntHxmQF4Pce
	 7HQTC6yqQ3FdQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t1Lmr-004MES-Gw;
	Thu, 17 Oct 2024 09:23:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix shift-out-of-bounds bug
Date: Thu, 17 Oct 2024 09:23:10 +0100
Message-Id: <172915337759.953359.17693189186554582464.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241017025701.67936-1-ilkka@os.amperecomputing.com>
References: <20241017025701.67936-1-ilkka@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: gshan@redhat.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, akihiko.odaki@daynix.com, ilkka@os.amperecomputing.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 16 Oct 2024 19:57:01 -0700, Ilkka Koskinen wrote:
> Fix a shift-out-of-bounds bug reported by UBSAN when running
> VM with MTE enabled host kernel.
> 
> UBSAN: shift-out-of-bounds in arch/arm64/kvm/sys_regs.c:1988:14
> shift exponent 33 is too large for 32-bit type 'int'
> CPU: 26 UID: 0 PID: 7629 Comm: qemu-kvm Not tainted 6.12.0-rc2 #34
> Hardware name: IEI NF5280R7/Mitchell MB, BIOS 00.00. 2024-10-12 09:28:54 10/14/2024
> Call trace:
>  dump_backtrace+0xa0/0x128
>  show_stack+0x20/0x38
>  dump_stack_lvl+0x74/0x90
>  dump_stack+0x18/0x28
>  __ubsan_handle_shift_out_of_bounds+0xf8/0x1e0
>  reset_clidr+0x10c/0x1c8
>  kvm_reset_sys_regs+0x50/0x1c8
>  kvm_reset_vcpu+0xec/0x2b0
>  __kvm_vcpu_set_target+0x84/0x158
>  kvm_vcpu_set_target+0x138/0x168
>  kvm_arch_vcpu_ioctl_vcpu_init+0x40/0x2b0
>  kvm_arch_vcpu_ioctl+0x28c/0x4b8
>  kvm_vcpu_ioctl+0x4bc/0x7a8
>  __arm64_sys_ioctl+0xb4/0x100
>  invoke_syscall+0x70/0x100
>  el0_svc_common.constprop.0+0x48/0xf0
>  do_el0_svc+0x24/0x38
>  el0_svc+0x3c/0x158
>  el0t_64_sync_handler+0x120/0x130
>  el0t_64_sync+0x194/0x198
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix shift-out-of-bounds bug
      commit: c6c167afa090ea0451f91814e1318755a8fb8bb9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


