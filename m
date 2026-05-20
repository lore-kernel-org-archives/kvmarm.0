Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46382D7DF1;
	Wed, 20 May 2026 07:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779261268; cv=none; b=q2XBUtYVJJQpc/lay4cvDjIqSFVrk2A7SfQiFmZMAPQy5KMZ+Qubo7ITgqJmIx4DB9FyJwnoskbFySzxICOIyAwGmsu6wLdZUzT+d0PXLtTcOAQyZJrLZWAhBaWDbA6l97IcBEXPCj13QPOex1ernYL33qGzgC98Cp17ULgWfn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779261268; c=relaxed/simple;
	bh=PfgjOyklYBKmxhj3yozNkhUXgrjHeGScaKQYJona5Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rB68F/TkxcdZCym28qI21w/u5SfbkCL6rLRLdHZKUjdVkwUMryE5hKJr38o7e0HuOrl1d7BlFXwggR+snB9os+yAFA31uFrlLDC7nEBneh9UYIBaRKF8ZWowXchMXD2+Yj6XCH1njPNEAZxWaLpwhQsadmXEZrptFJABfln8cFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGkGkQxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGkGkQxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76BD1F000E9;
	Wed, 20 May 2026 07:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779261267;
	bh=jvS5YVZbLxA7iOkR2e8CFT766YQGynaBCTDZgGeJd2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGkGkQxR399Z84m9AqDprFVuQzRyvMv04I3ST7nwbjTS1oPplxQ5hb9U16T5aE+hr
	 CC9ZnpXfw6A5Grz0E4/jqRJRyMp687v/uoBffICZIXXqi8sqCvBhXOkpLuXsdfqHIC
	 5K854m5pVzY0sEbiOcQ152FkuqBABPf3BWNWVAh9mIwKM4rPINaBY/zLEStJDu9g1r
	 DQwr98L5usPbuhltOUJ8+tGuyVPxag8AggP9CEy6J0ZiVxKnFjI7fGS8pGjOIw/FKH
	 lopr1fuLh5lk1mMpAiNQh2xwFDW14dVa7Wg44w4CHjKa5gsuhskZaFJKshnKveTNUQ
	 xCkgzPKjyXD+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPb8L-00000004FZc-2vhX;
	Wed, 20 May 2026 07:14:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: vgic: free private_irqs when init fails after allocation
Date: Wed, 20 May 2026 08:17:38 +0100
Message-ID: <177926141814.52935.6341366310707329067.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519135042.2219239-1-michael.bommarito@gmail.com>
References: <20260517181331.367676-1-michael.bommarito@gmail.com> <20260519135042.2219239-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, michael.bommarito@gmail.com, yaoyuan@linux.alibaba.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 19 May 2026 09:50:42 -0400, Michael Bommarito wrote:
> Companion to commit 250f25367b58 ("KVM: arm64: Tear down vGIC on
> failed vCPU creation"), which added the missing kvm_vgic_vcpu_destroy()
> call to the kvm_share_hyp() failure path in kvm_arch_vcpu_create(). The
> kvm_vgic_vcpu_init() failure path immediately above it has the same
> shape and still needs the same cleanup.
> 
> Call kvm_vgic_vcpu_destroy() when kvm_vgic_vcpu_init() fails so private
> IRQs allocated before a redistributor iodev registration failure are
> released before the failed vCPU is freed.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: free private_irqs when init fails after allocation
      commit: f19c354dbd457759dfcf1195ab4bdba2bb568323

Cheers,

	M.
-- 
Jazz isn't dead. It just smells funny.


