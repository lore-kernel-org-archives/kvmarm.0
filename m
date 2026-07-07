Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A0F3F39FB;
	Tue,  7 Jul 2026 14:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433087; cv=none; b=l0/coNfzol/uCMAFujgzqhHVv16y8a4ZswjtavuGwfkOLJmDDGnvziVtE8HvFPogOz0ivg3ufpd9vJVl7MbEczrYRCdGhqyWakyAH5fWpl4GsyfDx5e+IpCQIBurO3z3C2p6n42QZvDE9F2wHCMFe3pHfWaEhKWsKYobQ/e1SCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433087; c=relaxed/simple;
	bh=2wUNMdFEMEiPLAe1GVpIniuPQq9WqUwfzlszraiTpWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iRkF87b49fi+Y467p6RdSjcXsTOstMC5oyhplSwIBVnBmNlxwL0i1AuURDjSKO1qOf5NSB5YKZ2yrMW1esh4obqZtZc9jBZ6ghCLNNxjAY8HEi/+rORv6Ke13+Kbfm9Rj5SyIhF9CoK1Iyix8hzzu0S9I6GVLd2uJ8bDyvuC6Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VORi0ayZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VORi0ayZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B551F00A3A;
	Tue,  7 Jul 2026 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433086;
	bh=sWmdVczZNzTBvgYhqBLWG38saCe5L4qLnfo2fRbcBuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VORi0ayZvl8ZkSGFQeQ8nBgFBrpg7rJs7lS5cMipb05PoCqrRz4wKHl7lV0HnRwht
	 ausRGdW5rPZMzkFasC5B6rbmnkEh386iZNFBShkAnlWhXeld5ma4dY9JlP8x9eOZfC
	 G1hbl8M8jzNRrrf8VKMlIBuaGoOf0yq0Xub8HdtATAMJasbiamW18BVAuKR0DBp7mT
	 4UtdUBw6lZ2a+qQMT1EQ5r6501wpBo231CmAQjnfp9qQDWSCsis4A5udIiI4rxUHEg
	 YMTBm3nnsu72cR0FeeeQP+JggA5Uk66UAejpVW4RUm0ylRRg4Yz5QFo32DYlBrXqRp
	 Ck452iwzZgf9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wh6Pk-00000002RIJ-0evq;
	Tue, 07 Jul 2026 14:04:44 +0000
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
Date: Tue,  7 Jul 2026 15:04:37 +0100
Message-ID: <178343306571.1899612.18300071098746030610.b4-ty@kernel.org>
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

[1/6] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
      commit: 3383ffb7ef937317361713ffcc21921a7848511a
[2/6] firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset calculation
      commit: b4d961351aa84fdf0148783fb1f3a1391b8a0adb

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


