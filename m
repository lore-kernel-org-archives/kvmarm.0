Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B34E3C4560;
	Wed, 11 Mar 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773219530; cv=none; b=KFL2Wd41RVp8EOydoMOhYU6L0OcnM4sUqQ+NTCKrJFSXTr9ImgzDhMa/ag6mdXnv7vN9hi99DxSwcQ4NoxFlAe4yztafxE86SAurfcGHIPiJbmhp9zN3sCIZQEvk1L0HPDK+sReRCIuwUY1Osw8vqdPJoI+DJBMcIGwRWk0Bke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773219530; c=relaxed/simple;
	bh=WO0BNQjNxV78n5IOyPU7x3leCM/hYOPwVQjiO409PJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KB+JxLfc0uq1TYPR1DpZWgz6/6Y9eCzuzHPNzKPtquyyFXXaPlKlOnmaA4UAgn20K/VOo9gAdesYyj7i1tccfiJAL7yeCQ84VxlvBEB0o9nxoaKGdXe9v8lAeP0xUlrZZZrKBaSPH0oSxMizZLAtP/803MUWQLxn2cg02GZjsqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uRgaZoj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uRgaZoj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11627C4CEF7;
	Wed, 11 Mar 2026 08:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773219530;
	bh=WO0BNQjNxV78n5IOyPU7x3leCM/hYOPwVQjiO409PJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRgaZoj0FnzpUgGHuwMPA5AzG7DJ9T31YUKxsV5DFlbsT6HcCuMCpov9wGC9GdriK
	 wmGucz1pqSSYZIwnAFkyRi6D0OkGVX45FShxzC3ewEbGyOVfqFXTFghap2XXM93NuY
	 xu9hdfr3mDN+tzVpYyS8kduc3QeU3TLVfihS63TitOLlgYCDI3vDWsxY1DxFy8O24W
	 R3+M8ejtK8Y5jCqFKV6n9eUyKa3Wo536wOG5N+f2M60C+84Tg7ncqkyaCEzSkJMVPl
	 aYvZIq9qDnatDR7n1CcxV47Bjm+EPuYe7N44dcPeQoi0Vc9xoI17pV9IM8UA/79tj0
	 /z1TqkYVOTDDA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w0FOx-00000000mOj-2xfu;
	Wed, 11 Mar 2026 08:58:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	jstultz@google.com,
	qperret@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v14 00/30] Tracefs support for pKVM
Date: Wed, 11 Mar 2026 08:58:44 +0000
Message-ID: <177321950220.58730.2900926663831637604.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
References: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, oupton@kernel.org, vdonnefort@google.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, jstultz@google.com, qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org, kernel-team@android.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 09 Mar 2026 16:24:46 +0000, Vincent Donnefort wrote:
> The growing set of features supported by the hypervisor in protected
> mode necessitates debugging and profiling tools. Tracefs is the
> ideal candidate for this task:
> 
>   * It is simple to use and to script.
> 
>   * It is supported by various tools, from the trace-cmd CLI to the
>     Android web-based perfetto.
> 
> [...]

Applied to next, thanks!

[19/30] KVM: arm64: Add PKVM_DISABLE_STAGE2_ON_PANIC
        commit: 9019e82c7e46c03c37e8b108473d02b543222d9f
[20/30] KVM: arm64: Add clock support to nVHE/pKVM hyp
        commit: 405df5b55748d93d44666fd6005c60981094a077
[21/30] KVM: arm64: Initialise hyp_nr_cpus for nVHE hyp
        commit: 8bbeb4d1698fb0945107c69019c15207bbe605c9
[22/30] KVM: arm64: Support unaligned fixmap in the pKVM hyp
        commit: 4cdf8dec8c115d9531f80519db69846c32c580a5
[23/30] KVM: arm64: Add tracing capability for the nVHE/pKVM hyp
        commit: 680a04c333fa29bf92007efe11431be005e8c4bb
[24/30] KVM: arm64: Add trace remote for the nVHE/pKVM hyp
        commit: 3aed038aac8d897016a2b6e1935f16c7640918d4
[25/30] KVM: arm64: Sync boot clock with the nVHE/pKVM hyp
        commit: b22888917fa411d100339ef9d418b4eb86aba962
[26/30] KVM: arm64: Add trace reset to the nVHE/pKVM hyp
        commit: 2194d317e07d169efc113344c531621ce31afe64
[27/30] KVM: arm64: Add event support to the nVHE/pKVM hyp and trace remote
        commit: 0a90fbc8a1709f682e0196c2632027cdedae5e94
[28/30] KVM: arm64: Add hyp_enter/hyp_exit events to nVHE/pKVM hyp
        commit: 696dfec22b8e4ac57cc90558af2b6be2b37f4b95
[29/30] KVM: arm64: Add selftest event support to nVHE/pKVM hyp
        commit: 5bbbed42f71f771a70e974e3726d283690ecd589
[30/30] tracing: selftests: Add hypervisor trace remote tests
        commit: 39d5ca62a3dab7d162d49eb60b14cdd46138590f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


