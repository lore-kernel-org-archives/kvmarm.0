Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802622AD1B;
	Tue, 29 Sep 2026 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710378; cv=none; b=d9T3iPoopX/PAMpDA1eK7zTPDG1Tl9nQOTH974/iodwYQXSOeJQ6mYvjvQn9UDbGyymf6p/X5rmhY74T93KaoCEvWi/rLl5lksdVuEYuj3jl5tO6mGChWL/1cnboKFPuYsRwftFkZhVmVZ2b9nzFNdBnNKclzbN655q/lNTezWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710378; c=relaxed/simple;
	bh=sX27KGQtyN62UHaTnPRgJtDI+PC+O7kGFSzjRgNzjCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hINjzUI3NOQ1UO5t5NH7RDK3Gd1noy95asAQ0+DPStCOKBoEsac3uUHWJXEHsZOxZ+toFWrorFFSplBIDdE7QBwn4ePGLs3Yq245AhbM9hs96RXk16CNNNJd4Y2wJ9cEIK2D3azzpTeR05av2jfiL1ktim2Crp/eFjuGkPIoeyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGqNQ2Ro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGqNQ2Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329571F00893;
	Tue, 29 Sep 2026 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790710376;
	bh=/OfoBrmWG0bD9vaJRjd0S5rVgXGLpoNdNRXURAF0ZLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGqNQ2Ro+s162Kh1Rn4dC0vD9IhjQndkykHb5cglE2KR7qfti31OdfG9NSJIJ+WOY
	 5A3XRybO06J9BlMwuKzbXzEYXA43hz8Qx/tFVP+ADadyGBUDuT95mJyVCbxFVZAag2
	 uTMmN+lJO9NTV9z6tw0Cz/kxylAyi2+Z03tIC8PGRmumdSmIlWY6cK2Dc9bGYJ0mQA
	 KZEQAMSYM284fLzndQHYGWhYFE9ypJMYX72EctmMcHXeolykzuwHhky0D+TKTONzda
	 WPOkZPxjyu6nSSnOCsdVba7Magggv08NfiZXZNDj/mpjquXh8U7GyIrxWM1DCg62oP
	 QnGKSgp5cnwCw==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: arm64: Fix HCR_EL2 for non-protected VMs in pKVM
Date: Tue, 29 Sep 2026 12:32:52 -0700
Message-ID: <179071036893.5634.18190465958377898679.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929090031.3829185-1-fuad.tabba@linux.dev>
References: <20260929090031.3829185-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026 10:00:27 +0100, Fuad Tabba wrote:
> Changes since v2 [1]:
> - Patch 1: apply the FGUs on a CPU without FEAT_FGT instead of moving
>   the check in handle_tlbi_el1() (Oliver [2]). Wei-Lin's Reviewed-by
>   dropped with the rewrite.
> 
> In pKVM, EL2 sets a non-protected VM's HCR_EL2 in pkvm_vcpu_reset_hcr(),
> which misses the RW, TID5 and TTLBOS handling of vcpu_set_hcr(), and
> takes only TWI, TWE and VSE from the host. As a result, an AArch32 VM
> can't run, a VM can read GMID_EL1 or execute a TLBI OS its ID registers
> hide, and the host's TVM, VI and VF never reach it.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT
      https://git.kernel.org/kvmarm/kvmarm/c/4bdd2b3a708c
[2/4] KVM: arm64: Clear HCR_EL2.RW for 32-bit non-protected vCPUs
      https://git.kernel.org/kvmarm/kvmarm/c/80ae56184b57
[3/4] KVM: arm64: Use the host's HCR_EL2 for non-protected VMs in pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/04447b95c62b
[4/4] KVM: arm64: selftests: Check a feature hidden in an ID register is UNDEF
      https://git.kernel.org/kvmarm/kvmarm/c/afb4334fb52c

--
Best,
Oliver
