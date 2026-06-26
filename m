Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1CB3B993F;
	Fri, 26 Jun 2026 11:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782472082; cv=none; b=UZ1xegDJosyJaduh/TYcVTSfQMS8W1njPNogEWIh6P3kIno6vnhZlJlxPGRDCPiCXp+i74LE5M8rtEKa1UP8NYVaZrIc1Ax/T80P1LyEPzI6/jhZxb70GoIinX3lv9qQO3AFZRKYNm3XqDlR2KlYmpMB0NH3aFyCBWLVEdhQbfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782472082; c=relaxed/simple;
	bh=j/9jvoteWsbkAtLuaKbFyabG8x1Eh/y8feZ8DAxNQjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8FD8C+9euZICymt6oOSnpcn/tzA4kQbunjJS8Wj1GE1kLHkyZnRnw2s4Mfi9qtg20wvmiml4rZ3Mil1SWvwiO1QNhGCwlWrEAQ8DIwZj3Hj6/TJ+xVOJZE7JJEirnaxMt+D/tL4LOxahRYhQXy2V1IYMIj9XlM7jVgc/uypBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuQ1rsgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuQ1rsgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C991F000E9;
	Fri, 26 Jun 2026 11:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782472081;
	bh=4T79FAqc8VVmmUYXLFxQYYIV6s2yKhD5rKPvmdIsmnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuQ1rsgdTEEdySBhbXHnOq0al3OT2gGKyG+71aG+Cz3/NFNRjSOgCNn9RLGjqbRWo
	 tnvfTDDbomJsGy/lA+yeMwfL08/q1mqpNapQaY8vFOfn0atPU175bKkX7HhyhLXclq
	 GLROQWkou6JB3SD3CrOY1jGpY8sCei+QyG8jfa+AO3e2FNV6g4lNb3Zi7AmFp14goj
	 7bN0NABBgZuzm5nMVTQaWGYYvZNJrF3a8pBcoZQt1yHjARPcW3+bAgEXLS/UiQfjIZ
	 0Je55QPKDhsO/VYOfNkrUpF0KFa365NIyB9ADXhbwf+NaTa7GE4/OKgXW7+cvwKzoY
	 8/NvtvEKdsK6Q==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 kvmtool 0/4] Add support for running protected VMs on arm64
Date: Fri, 26 Jun 2026 12:07:50 +0100
Message-ID: <178247163652.4076831.16977927018980776093.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625171046.4482-1-will@kernel.org>
References: <20260625171046.4482-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 25 Jun 2026 18:10:41 +0100, Will Deacon wrote:
> This is v2 of the patches I previously posted here:
> 
>   https://lore.kernel.org/r/20260619115415.5475-1-will@kernel.org
> 
> Changes since v1 include:
> 
>   * Bail if user specifies less guest memory than the restricted DMA pool.
>   * Avoid silently dropping KVM_VM_TYPE_ARM_PROTECTED on old host kernels.
>   * Added R-b/T-b tags (thank you!)
> 
> [...]

Applied to kvmtool (master), thanks!

[1/4] Sync kernel UAPI headers with v7.1
      https://git.kernel.org/will/kvmtool/c/3c553570b99a
[2/4] virtio: Factor out base features for modern virtio transports
      https://git.kernel.org/will/kvmtool/c/9874e7b73d04
[3/4] virtio: Add helper for enabling VIRTIO_F_ACCESS_PLATFORM
      https://git.kernel.org/will/kvmtool/c/dff08c59150e
[4/4] arm64: Add support for protected VMs
      https://git.kernel.org/will/kvmtool/c/ca0ddafa941d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
