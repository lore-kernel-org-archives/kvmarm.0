Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD45AC13B
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717511425; cv=none; b=Xxo+PPdm053JYuc50MoRJfCWKp3WOPs2oCWaIuGyusoxwzMkhvl7Htw2K23hdmkuV3MX6LnyxKbngEF5Oh2J4dMpa73N3tuFcCDtI8XEjhY577v95qFOKA12j0UgD9eT0VK5sHDAb3Pgw8P20iNFDsG3x3HzfUBjNMIDK8hiWsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717511425; c=relaxed/simple;
	bh=/BkCZcbI3sC5qxo/tqyOt0I23MSl6HquKpA8ewuDTSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EW8N8H1hgupTU6hhb1UpuGIJJXM98QX3J2naCeI2EhcqXQR+5CNB4ARGSmB2+KMVAJUYdWVkgM/8IAHcV+X6oL8pALtRXZB7kQj21icZgfRZAP6qCjV/fdAEfhktT4StVpJYbq2PCYHu+trGcBf0fuBWQM8HbPeNRIiGoB3HHCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxsMwC8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxsMwC8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820DCC4AF08;
	Tue,  4 Jun 2024 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717511425;
	bh=/BkCZcbI3sC5qxo/tqyOt0I23MSl6HquKpA8ewuDTSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxsMwC8bInaUoyrBng+Xh7hvRYfmvkJaTtUpw94o7iL2hIMsJ9gzZgsnJNA2dTj5z
	 FT9PQ4Rot1diHYbDGN1p0kOiVcBvn1iafWCxwLfp3iH3VZkaOh0t1g7PY6UB2aBVx+
	 +lmdHMjQMYI5n8dAmlELzTxCi3Avi+JCwXr44Ni9fTIclfy/6EBEjzjHuhdBn/urTe
	 MMQlboSeh96WQg41hKXaLog76/wqmKeLgxZ4zXVfGGX8F0bqqKc//1xX8h5kZZoN3o
	 ZjlzRqDHMeMLiywDMOl6Ui1TdZ8EFhiVgTPqsigqWfQLi8I3GLEh11xib0yABc5Q72
	 jhd4WJrFw5lLg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sEVB9-000bjW-2X;
	Tue, 04 Jun 2024 15:30:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: will@kernel.org,
	qperret@google.com,
	seanjc@google.com,
	alexandru.elisei@arm.com,
	catalin.marinas@arm.com,
	philmd@linaro.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	mark.rutland@arm.com,
	broonie@kernel.org,
	joey.gouly@arm.com,
	rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 0/9] KVM: arm64: Fix handling of host fpsimd/sve state in protected mode
Date: Tue,  4 Jun 2024 15:30:19 +0100
Message-Id: <171751080453.266083.3919022563197793184.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
References: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, will@kernel.org, qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 03 Jun 2024 13:28:42 +0100, Fuad Tabba wrote:
> Changes since v3 [1]:
> - Rebased on Linux 6.10-rc2 (c3f38fa61af7)
> - Dropped v3 patches 8--11 (Oliver)
> - Removed unnecessary isb()s (Oliver)
> - Formatting/comments (Mark)
> - Fix __sve_save_state()/__sve_restore_state() prototypes (Mark)
> - Save/restore ffr with the sve state
> - Added a patch that checks at hyp that SME features aren't
> enabled on guest entry, to ensure it's not in streaming mode
> 
> [...]

Applied to fixes, thanks!

[1/9] KVM: arm64: Reintroduce __sve_save_state
      commit: 87bb39ed40bdf1596b8820e800226e24eb642677
[2/9] KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
      commit: 45f4ea9bcfe909b3461059990b1e232e55dde809
[3/9] KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
      commit: 6d8fb3cbf7e06431a607c30c1bc4cd53a62c220a
[4/9] KVM: arm64: Specialize handling of host fpsimd state on trap
      commit: e511e08a9f496948b13aac50610f2d17335f56c3
[5/9] KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM
      commit: 66d5b53e20a6e00b7ce3b652a3e2db967f7b33d0
[6/9] KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
      commit: b5b9955617bc0b41546f2fa7c3dbcc048b43dc82
[7/9] KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve in pKVM
      commit: 1696fc2174dbab12228ea9ec4c213d6aeea348f8
[8/9] KVM: arm64: Refactor CPACR trap bit setting/clearing to use ELx format
      commit: a69283ae1db8dd416870d931caa9e2d3d2c1cd8b
[9/9] KVM: arm64: Ensure that SME controls are disabled in protected mode
      commit: afb91f5f8ad7af172d993a34fde1947892408f53

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


