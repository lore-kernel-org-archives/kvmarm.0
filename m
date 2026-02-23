Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3D031B81C
	for <kvmarm@lists.linux.dev>; Mon, 23 Feb 2026 16:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864288; cv=none; b=ZhQmHNmXiz7B/UtYv6MyAkTQ0h8sKY/eM5/oGHTFerLhS0bqRafo1wxgANbpXxH9mRY66BbJ0Z4VxcZxNjIUzfzbOlFK+Iq5gsSnBpDNLSrkg7i7avp49CD7XlDh469LiZB9syn/w/GvWtAHxa/H/uM7oxqX/rnAfQnTk09Rf40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864288; c=relaxed/simple;
	bh=kPMGu6rpFObsTaxnVjc9U9DSVyONlwHZ5psqc1gbbww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZR4nfYbjkPzkyBHnxpa0DOkPyP7WTTMSZBo3ZmKJjdbYohEl/CXrDrORzZJiAJbXpps0qc/FFOjTBIKaQi5sxrCz4jLZAtibx1gU56wzG76ZCT1jZpB6GQQ4je3Z7CsoNjHOvMVcztBFJ1hdE9h2EdG5F9Z2meewA8peKUTdBqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qp9hig4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qp9hig4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1B3C2BC87;
	Mon, 23 Feb 2026 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864288;
	bh=kPMGu6rpFObsTaxnVjc9U9DSVyONlwHZ5psqc1gbbww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qp9hig4IOzVjzuK0A9mfXAIYpRju/wh6HryxXQNZWDJEVfi+YupmTFToNLjKl9pkh
	 AhwTT38KNzOjwxaFPLQDZO9WpvBSpqzJZ6ppsi42CLdTsuZPZtFUHvux8SAe1XIPia
	 mNQkYMkFytwJA6ZMfNCUccvKEcvDZCBijdvOQFqFV7Iq9Iwq2nh+ma4nc6Tbc2ABpI
	 j6Hc7jLscqK82YrnC7ScaMnWPFNvoja5JWggqKydmzT9kGNQEFyfaB2Y80EfH1VlxQ
	 1hL5wl5eCBFn0ltlgUh2dwXEYXMoZWkwj6LOvQz4Q5A3yOS+TJbC666Vadc8paRjry
	 JaZ6NmpUBT1XQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vuYqE-0000000D3sd-0hiq;
	Mon, 23 Feb 2026 16:31:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: broonie@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	qperret@google.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v1] KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu() for non-NV VMs
Date: Mon, 23 Feb 2026 16:31:23 +0000
Message-ID: <177186426800.3533992.9302353405604914685.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260222083352.89503-1-tabba@google.com>
References: <20260222083352.89503-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, broonie@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 22 Feb 2026 08:33:52 +0000, Fuad Tabba wrote:
> Commit 0c4762e26879 ("KVM: arm64: nv: Avoid NV stage-2 code when NV is
> not supported") added an early return to several functions in
> arch/arm64/kvm/nested.c to prevent a UBSAN shift-out-of-bounds error
> when accessing the pgt union for non-nested VMs.
> 
> However, this early return was inadvertently applied to
> kvm_arch_flush_shadow_all() as well, causing it to skip the call to
> kvm_uninit_stage2_mmu(kvm) for all non-nested VMs.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu() for non-NV VMs
      commit: ec197dca8735f7627e5cff7e3fa8839b53a28514

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


