Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C3E2FCC16;
	Mon, 15 Sep 2025 12:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757938063; cv=none; b=VuqV0Lm+R129+Gp+3voLfJnDpTc+FKKBknoS5F+giWlAqTY3tk2goUAamnDalQ8TGDi/rVqJYFjowQhoTACn2lZ4me8xvdkgfb0A04wq3VPWZmmJ72GX8BzpdJSWcE6gYepKklrYSHa0z00QjppWXh46XV3n8SfPe+gYnrqC2Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757938063; c=relaxed/simple;
	bh=05ALcJgejdF5mIHtoaH3aZBVq91WR4W7mnRP5XLeWwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdVm3evDLqkUbj1/zHdE2AAQpn5T8OHAJIzML67Mk3Qz4XXfuriDY1ExKnwjeC7qAaR+vujMpF70AKiY4wMxNTqNuN0ZTMJOBCjXXZt+VzM7NK6BBUj1igdXaPKEZHeGoYFlMzTPFLNXJvEe6lBy0LN4S7uX1Z2xNASqLxA1Xis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxZJ1u4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxZJ1u4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEAFC4CEF7;
	Mon, 15 Sep 2025 12:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757938063;
	bh=05ALcJgejdF5mIHtoaH3aZBVq91WR4W7mnRP5XLeWwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxZJ1u4nCXwsus+hEae+/D/Vw437CbHUh2kp/YLZ0ci7MTEurN46y3GQq8I54huSi
	 +Jy6KObOJLT3Le8GSA8pW/jgdtbI7tzyYvoa52HVaLSsG6TorJxVY5h7PP20q2x7zq
	 8R8zuSZZ97ppsiBXHAdLJzjVuZtvwfWNtTFnS+nReE5znOvrzS7SgBoOPGExPbF+zD
	 74fYWwfxLk8/OQPYzvzMbl+Fh3q2NRxALAAkvTi0HEJZGuQkLJcrVtVGBeAwovhDgq
	 FOXazbFpFcPtR7WMVbyGpW1E5gmcTZ9rPlR1mCzhLKKg/+0Dt2++uJdmcBA6aDwMqc
	 1pn/IDVQcaX8Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7zh-00000006Mst-1Sx1;
	Mon, 15 Sep 2025 12:07:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	perret@google.com,
	keirf@google.com
Subject: Re: [PATCH v2 0/2] Dump instructions on panic for pKVM/nvhe
Date: Mon, 15 Sep 2025 13:07:36 +0100
Message-Id: <175793804436.660835.10602448198623077028.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250909133631.3844423-1-smostafa@google.com>
References: <20250909133631.3844423-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, smostafa@google.com, catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, perret@google.com, keirf@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 09 Sep 2025 13:36:29 +0000, Mostafa Saleh wrote:
> This small series, adds support for dumping the faulting instructions on
> panic in pKVM and nvhe, similarly to what the kernel does as follow:
> [   12.012126] kvm [190]: nVHE hyp BUG at: [<ffff8000811c5f64>] __kvm_nvhe_handle___kvm_vcpu_run+0x4/0x8!
> [   12.015747] kvm [190]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
> [   12.016044] Code: a8c17bfd d50323bf d65f03c0 d503245f (d4210000)
> [   12.016082] kvm [190]: Hyp Offset: 0xffeff6887fe00000
> [   12.016325] Kernel panic - not syncing: HYP panic:
> [   12.016325] PS:204023c9 PC:000f8978013c5f64 ESR:00000000f2000800
> [   12.016325] FAR:fff00000c016e01c HPFAR:00000000010016e0 PAR:0000000000000000
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Dump instruction on hyp panic
      commit: 92b7624fe052ffb0b7b70d96cd514e02e91664a8
[2/2] KVM: arm64: Map hyp text as RO and dump instr on panic
      commit: 6f1ece1e868839cf81a28c77e19420ff57df7ecf

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


