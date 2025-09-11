Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6821120FA9C
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607086; cv=none; b=Cwd33Qkkv39eZJp73PniPjrI4E13dP1BP6v8u9xvDXPzCbh9vqHVCMl06FY+BHJyKhm8VUF4R9Zr9TQld92LCus4gBRf3KdlSzUl3HtZ/NiSelLU43vQwLW/35YLwvqluq5ppiE/UKgy+0eLn9qTmmkCpQRsO/CrSk4iXAC1XY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607086; c=relaxed/simple;
	bh=F6rpAcs6AuSZfMpWOUiVYz+zbOkP8L8AQHJbK2gAKuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLGSsQff8feNs96vftrf1d8vJr+CMv9M7mq77L6IrWNlkuMZdiH1dodO2mcoqYWCCjwRI63tVzIBcIQgogNaKUjODS1SA7epyxutq5igyyzBoi74Vmxyoby9FV34JLT79/oE561U7zl5NEwtTY21bUlx4gHFpuQwqPSX1EHEYV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O68+ouop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O68+ouop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6392C4CEF5;
	Thu, 11 Sep 2025 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757607086;
	bh=F6rpAcs6AuSZfMpWOUiVYz+zbOkP8L8AQHJbK2gAKuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O68+ouopGE+jfpd24CxLs5kkmPVexpvQFmGHuxv1jys7ftxvaw+XhcCeLaOhD+O47
	 QDyBunLdjZ32E/ZirAJvv8y42expeYRHyTlc7m4SA7FSK8++uz3kDENhPJunF3i2Vs
	 F6zwZhYVHPfi8t4ctfiZUNjLx6Fib7e1Z2qJxd5B14aFzlgRQ6DP1J4FJT8Z+rrQTc
	 6oBLlQS56fF/CCPHpJI9aQPJo291kZvKFyFPoVMLoTIp9/FmsaEGCWQdqGTlKANe3o
	 sj3e+CW8DAyOrlhgFnLLNu+M6a71kIoopb/TEqp5zU53k4yXY8JU8zGcTLOi2Bxdd4
	 V00jLR2Qjp1bA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	vdonnefort@google.com,
	qperret@google.com,
	sebastianene@google.com,
	keirf@google.com,
	smostafa@google.com
Subject: Re: [PATCH v3 0/3] arm64: sysreg: Fix sysreg field definitions and generation script
Date: Thu, 11 Sep 2025 17:11:13 +0100
Message-Id: <175759836827.886602.11949922116281673131.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250829095143.123476-1-tabba@google.com>
References: <20250829095143.123476-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 29 Aug 2025 10:51:40 +0100, Fuad Tabba wrote:
> The sysreg definitions file has a few errors. In Enum Security,
> NSACR_RFR is set to 0b0001 instead of the spec value of 0b0010.
> Additionaly, the sign of the Enums DoubleLock and EIESB are wrong
> (should be Signed and Unsigned, respectively).
> 
> Moreover, the file has some redundant definitions, e.g.,
> RCWSMASK_EL1. While these redundant definitions are not wrong per se,
> they add unnecessary code into the generated header file and could be a
> source of future bugs.
> 
> [...]

Applied to arm64 (for-next/sysregs), thanks!

[1/3] arm64: sysreg: Fix and tidy up sysreg field definitions
      https://git.kernel.org/arm64/c/2c2529e47062
[2/3] arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
      https://git.kernel.org/arm64/c/f4d4ebc84995
[3/3] arm64: sysreg: Add validation checks to sysreg header generation script
      https://git.kernel.org/arm64/c/382cbbe7fb2a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
