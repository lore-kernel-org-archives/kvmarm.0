Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEB3195B37;
	Sun, 12 Jan 2025 10:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736678535; cv=none; b=fSpACoFGg0myqXqJiEOmFEGDuVRzwNaCss1EyhxczutLMhJb7VOml7cazB1i14KqQ150k2BM+WxFwihfEHu2ahl0H+rrRdQZ1GPhC/fBIicdZUTC2tGXx5LqmU7khOW/UY08eUZNEbkpqkl1FgfC5RHnQ8JQ7ZdDLC/l3u8q6EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736678535; c=relaxed/simple;
	bh=R7njldLDOz8MV+CZLpoFpvBPG4OpdGcvpLOzHB78ebk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9j0+hjbQazGjrvFNfquAYR95Ax1mdslPJyyj+iNge0TslOyA/I8ZjxpCFyDc3exr3umvtS4+VbBWgdFNbKhA+XO1UXfeRWuRddQYRMlX2Zdb0hoL3GUvFMv0Fpu/U5upaV5opSgfr6lHeAKeEi58i9G1ls8uH2WL9AxnBDGKS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o79/Iqzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o79/Iqzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B29C4CEDF;
	Sun, 12 Jan 2025 10:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736678534;
	bh=R7njldLDOz8MV+CZLpoFpvBPG4OpdGcvpLOzHB78ebk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o79/IqzlgeWXj8aFVfeBJ0yTS6UJ4ZM5TaD2tf626OSCln+In8HPJnvW4+R2vDG68
	 7WfGLN8ZlnI1A/lNz66TRBgM81AFGCebhSViaRjfYTSG1k2S4xp3mWw4shP99vedJt
	 fAgWSAcSMfmv/2/fzCsF5SZqxttWAfsn27TuhCuoF83fEX6E4NbCyrCOsVzLZtkfbB
	 E0+pgCJSHiCKW6674OH0L15SVy12WoWkdWqwtl66PWXNBCWjhwoDC0Ua0Zn1Xd4+9v
	 HChnmpU5Ibxi1xVTeHBCL4pZD8Msl2wYs/kNFeqQiyXpyP3jYHfeihja2Px/n8rDYu
	 MfazNqKy6LvvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tWvQ4-00BKDr-3a;
	Sun, 12 Jan 2025 10:42:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Cc: Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: arm64: Simplify pKVM memory transitions
Date: Sun, 12 Jan 2025 10:42:07 +0000
Message-Id: <173667852147.882737.8982373220700597868.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250110121936.1559655-1-qperret@google.com>
References: <20250110121936.1559655-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, tabba@google.com, vdonnefort@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 10 Jan 2025 12:19:33 +0000, Quentin Perret wrote:
> Since its early days, pKVM has formalized memory 'transitions' (shares
> and donations) using 'struct pkvm_mem_transition' and bunch of helpers
> to manipulate it. The intention was for all transitions to use this
> machinery to ensure we're checking things consistently. However, as
> development progressed, it became clear that the rigidity of this model
> made it really difficult to use in some use-cases which ended-up
> side-stepping it entirely. That is the case for the
> hyp_{un}pin_shared_mem() and host_{un}share_guest() paths upstream which
> use lower level helpers directly, as well as for several other pKVM
> features that should land upstream in the future (ex: when a guest
> relinquishes a page during ballooning, when annotating a page that is
> being DMA'd to, ...). On top of this, the pkvm_mem_transition machinery
> requires a lot of boilerplate which makes the code hard to read, but
> also adds layers of indirection that no compilers seems to see through,
> hence leading to suboptimal generated code.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Drop pkvm_mem_transition for FF-A
      commit: ed2f80fd76bd2c6e00d2e90f78d21a3055ee3562
[2/3] KVM: arm64: Drop pkvm_mem_transition for host/hyp sharing
      commit: d3b3473c15e4391673d8dca9c36dd5e9c3a8a4ac
[3/3] KVM: arm64: Drop pkvm_mem_transition for host/hyp donations
      commit: 2d2aa2eb275fa6f80d68ed442c3328273bbbecba

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


