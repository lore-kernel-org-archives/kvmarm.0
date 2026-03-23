Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE763659FD;
	Mon, 23 Mar 2026 11:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774263928; cv=none; b=nu9wLbmrrNxQqxq2QBe+KrfJII/73yJzE7kMqcuyXuFWIkEZbwrvVwsIsQNq7umiB39feUAtU4wtQ/6eUaNiD18u7c3pACge6DahC1XFSFgxEtsySoyx5KUZhgrawGRsbkAPyelEHEFp3vLogj0aWIIKFXzyY01IzDSDb+VgUXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774263928; c=relaxed/simple;
	bh=BraRdjLKc4SBE/RNIplurqe16L3OY8fCXATiwXvXBFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TMdK/OgTaMhDZU/+SNdOpHvXGcF2TRsO9ZXiGzFIeJ9KpvjvJOUnLzaqfS7loqtjJxlQ4O3MdAMoRqc8Q2wdjRQ98XpD+bDcqoyv/uBdCfswoCb7RDEZ4JUURGsgRipvvkYJAcUpBPXYb4rA44nA2fdxbVhqvFRbnXYBgYYjMkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwUbIkl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwUbIkl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0850FC4CEF7;
	Mon, 23 Mar 2026 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774263928;
	bh=BraRdjLKc4SBE/RNIplurqe16L3OY8fCXATiwXvXBFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwUbIkl1n1u3i4R48wH2slAwkHXeOjV8pGmvtWJqJL6OQh6//txLlkVlj9KpXddfa
	 C9ABLZEQutTyzJ+TsZ9fO4DyqhhpM+xoX1Y6THbK+OsmtWY5B68UHp+V8WkgZLMx5R
	 e+WGkcH0HUGYZDjJjWmhIeSg3l6cDwuVvm5Kr3RBN/1goI8uPQeE9oXkafwBNw/crs
	 k6JJ9bqF+sWIcnhJTw8yxeYWzuzmMdWLQq5dL+/fvXUHML50QYwwggm8gr4SYLo+fc
	 bQeaNpKaMoGv890dPFDpniP/qDnOUe5nuEYdRcnLCtDDFU+iLVv7cbvvNZEBgYt4SB
	 C8VtXQktYGnKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w4d65-00000004gzt-3Q5b;
	Mon, 23 Mar 2026 11:05:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 0/5] KVM: arm64: pkvm; Rework aspects of the PSCI relay
Date: Mon, 23 Mar 2026 11:05:23 +0000
Message-ID: <177426391593.2932170.8726976984414575226.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321212419.2803972-1-maz@kernel.org>
References: <20260321212419.2803972-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, smostafa@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 21 Mar 2026 21:24:14 +0000, Marc Zyngier wrote:
> Having recently spent some quality time debugging [1], I ended up
> reading too much of the PSCI relay code and felt that it could do with
> a bit of spring cleaning.
> 
> To be clear, this series doesn't really fix anything. It simply adjust
> things to my own taste, which may or may not be everyone's.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: pkvm: Move error handling to the end of kvm_hyp_cpu_entry
      commit: 4ebfa3230b40728638a6acceb709f900f920f921
[2/5] KVM: arm64: pkvm: Simplify BTI handling on CPU boot
      commit: 1536a0b1386850b67a9ea840e57b7b475e895fed
[3/5] KVM: arm64: pkvm: Turn __kvm_hyp_init_cpu into an inner label
      commit: ba64e273eac3d7ec4a2b621b3620c4d3b0399858
[4/5] KVM: arm64: pkvm: Use direct function pointers for cpu_{on,resume}
      commit: 59c6e12d40a5b05038b68bcdb4690456fee68e8a
[5/5] KVM: arm64: Remove extra ISBs when using msr_hcr_el2
      commit: 54a3cc145456272b10c1452fe89e1dcf933d5c39

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


