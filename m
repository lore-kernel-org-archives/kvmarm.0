Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C7551DAEA
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864650; cv=none; b=GOzvrL5J0ESrrPGuDL2QsX0ykOUXM/v9ftOhMZMpqelowDUMmQmCaBOhJQyBMM8odji7cGwY2HBycUiw1LRXRz2UQXvbp/BJQuhUFDYxQxZYyQpBUdRaYSWnLnKZZQTZZDJTURvOcrutn/01AJPm6wCpxhjjcRflcFDS8hYZCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864650; c=relaxed/simple;
	bh=AsFMZI8xdqEy3Q6w8V4G/EplGrKldUILof5pMFeaVNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAhKjaqPcCVRYeBomTmYTQ89QmI+6wB7vJhsBTA4WiP83hVBXUIaJHZfMqBJDLyCVTOLdDEEXHjnn6pbgQB8+yq+J2z+tpW63phr8As9aXZsXDQWywOQ9u3ugSFOxueWNmXInxT8/lsOCRfUqxtjMgrVt7/M+4O/0H7pLoFD1a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2SeWX0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2SeWX0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40291F00898;
	Thu,  1 Oct 2026 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790864648;
	bh=NyQWHHCSmslcWPV2x1ylZVNMBV/seL+Wm39p7DMyN18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2SeWX0JiXkYZzwbySNjiyQFfYIvhrSpPFrJzcXtkRM0GjyZbzUUM9LE58PzSBWjH
	 Dy4meAJYjpIJLeg2dNacqW6mqLwv0jmyvooP/5pwWNaTbg6O72ei19KLXCrnMI0zig
	 XRX2cbJ2O+49ZFIEUfIDAoRsiV0KCvYTPORYmn9rp549fPyZuBvSMKWBlEtohcYrwj
	 McBzxbuCt0YsSuXENRm6EBzkow3ZXyyt+I6txyQLSH0/EMgtoQ7YI5STizqTZfmvLP
	 UkzCPtyELEEDkDHXWAlwPWqlX45n1iOrQd/87evGSooeNuvVc41kLjG5340ISqehP5
	 42XUO5UHnbKZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xCHhe-0000000FpD6-1kxa;
	Thu, 01 Oct 2026 14:24:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev,
	qperret@google.com,
	weilin.chang@arm.com
Subject: Re: [PATCH v2 0/4] Fix guest_memfd and protected VMs on systems with pages larger than 4K
Date: Thu,  1 Oct 2026 15:24:03 +0100
Message-ID: <179086459527.3904893.12825390067092520410.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928095454.3255918-1-vdonnefort@google.com>
References: <20260928095454.3255918-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 28 Sep 2026 10:54:49 +0100, Vincent Donnefort wrote:
> This series allows booting protected VMs and guest_memfd-back VMs on
> systems with a page size larger than 4K.
> 
> Currently, the fault handling assumes 4K alignment, as HPFAR_EL2
> provides the IPA minus the bottom 12 bits regardless of the system page
> size. This leads to mapping failures on 16K and 64K systems.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
      commit: 6c29285e78b5e4811145ebda382ac0ba732ce56a
[2/4] KVM: arm64: Pass kvm_s2_fault_desc to fault_supports_stage2_huge_mapping()
      commit: 10c5cc50f056a6425305557063ad70c3eb0e686b
[3/4] KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()
      commit: 80b0b86dc5e4344e62a2fd3ee43d0ef816fe9122
[4/4] KVM: arm64: Use kvm_s2_fault_vma_info in pkvm_mem_abort()
      commit: 0cdcc1039200b3c4fbc2ae3f9b5c1be1bc9155e8

Again, a large number of conflicts (prefault, rmap). Please review the
conflict resolution.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


