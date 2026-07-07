Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7393AEF27;
	Tue,  7 Jul 2026 10:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783421890; cv=none; b=kkt12G66FcOMbKWq62M/V7+3K3dO7mcecBG9JtwCQ8JgOi/C+2uKB0hh2r71MI05s8cSD+TPuXR64QaHSzOf6QAuWeeSEcXixAp7Uy6AKC5UEdFSosM3jg5gpKYQbnc71sgqmQTuI/E8SXzT+rkqpSh6NyqPVQBKVefMWGboCo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783421890; c=relaxed/simple;
	bh=qyKJ1jdxX//ZantfaEkOSW3gCjQ7uvyBoJq8xDvb9v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fTS1N2C2mZM3R0jmLvirO9IlCLMTGECxThAf3+L3CtuYMLjW1QWwa/DWCi6YIUuDndcSB8s+c80IPO9MDDBcEwYJYUPAERkzBNVeg+8I8Yi9NVRKHRmVQvXTs7Fzvrj3VvcZzUL7sFq96GI9DSz7N0t+IHIGRSNWer6HBeMlbAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmoPaXEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmoPaXEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D591F000E9;
	Tue,  7 Jul 2026 10:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783421889;
	bh=mQON4yUhDZuxb8gaF10sc6vnH8fe+VK9AhY37O8cwS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmoPaXEpEZQFiYzdoJqj/qbj+DnlI3yBM/H1LIY38fkCEIM4CcXvF3z2dam3dnUwa
	 qKOtg54u7hnFUSzxPotBXi+S+MyolSbY8kNFLOVqzmsx5sOVjdgag7EeoZ8rf+kW5L
	 bsR8Nz8iWCVdCckvF6WTJBvv/3exef9ZhZjXPrbix4/yeLiIJ9V/gRIfKrziOZhBHk
	 tFZctlfL3mBUojs1cno1n8Q4qrmYIcTViuaZ6cY6NXUIA+aj3B7o/wZem3ep8e6u68
	 kD2ds9xF3xjPHN9D/b1EUTNZScVRbjrm8L2WAgWoKAUmqSYXv762cRlXhCs4FV7HIz
	 Z76Lv9I/uupmg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wh3V8-00000002MtZ-2yTw;
	Tue, 07 Jul 2026 10:58:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: catalin.marinas@arm.com,
	oupton@kernel.org,
	sudeep.holla@kernel.org,
	will@kernel.org,
	Sebastian Ene <sebastianene@google.com>
Cc: jens.wiklander@linaro.org,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	android-kvm@google.com,
	mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org,
	perlarsen@google.com,
	seiden@linux.ibm.com,
	smostafa@google.com,
	sumit.garg@kernel.org,
	suzuki.poulose@arm.com,
	vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: (subset) [PATCH v9 0/6] arm_ffa, KVM: Fix FF-A emad offset calculations
Date: Tue,  7 Jul 2026 11:58:01 +0100
Message-ID: <178342187223.1892339.1923162787460489447.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702103848.1647249-1-sebastianene@google.com>
References: <20260702103848.1647249-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, will@kernel.org, sebastianene@google.com, jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, android-kvm@google.com, mrigendra.chaubey@gmail.com, op-tee@lists.trustedfirmware.org, perlarsen@google.com, seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 02 Jul 2026 10:38:37 +0000, Sebastian Ene wrote:
> This series fixes the Endpoint Memory Access Descriptor (EMAD) offset
> calculations and adds the necessary bounds checks for both the core
> FF-A driver and the pKVM hypervisor.
> 
> Prior to FF-A version 1.1, the memory region header didn't specify an
> explicit offset for the EMADs, leading to the assumption that they
> immediately follow the header.
> However, from v1.1 onwards, the specification dictates using the
> ep_mem_offset` field to determine the start of the memory access
> array.
> 
> [...]

Applied to fixes, thanks!

[3/6] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
      commit: 8c6db30d79528279abbeb416e4f533f1f91b8724
[4/6] KVM: arm64: Validate the offset to the mem access descriptor
      commit: a6b49d27c17909608d54523220bb6f3498d4a1df
[5/6] KVM: arm64: Ensure FFA ranges are page aligned
      commit: 6a7a181f6921db3d9aed1bba7e15547fefd7eedc
[6/6] KVM: arm64: Zero out the stack initialized data in the FFA handler
      commit: 2bd3c6c702f3a9e2bcb3b536b0fbbaa645005d71

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


