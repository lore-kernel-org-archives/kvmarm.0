Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE4245948;
	Mon,  2 Feb 2026 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770047257; cv=none; b=mQfGQI45wsN2raBa4a1ZSRwUb7ue7uQcG42OYzGD7Sauk60Rao6uSlRABIokx2XHj7n2BxNldrLXANZO6Iruh5peln6CtrHWgXouxc4Lg2LerlxeOl12DSxyclupqj2EnObdtpmzh/K3r1+vGmH6YEuEpHb9pgs8W8wWuZ/SO/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770047257; c=relaxed/simple;
	bh=DQHMSgsv3Ovvgk7wrUhAAoPFmN9TTDqtPHu6Cz7HA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7YE17e9tN0JY8z85njE0DaG5h7M18mDxqGrR+Dr9JWVJ+N8wGzQ60EsfXDl6xlbzuOR08yguAPyJWLTd1LRpLvsmPz1NnzUzceYzyHmhvyb0lJQVf9F4WGDZPLw5iq85fv+OMuuB+xcFRgAjbraJO/CBjwZLnbqXE8mYVZCiu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfsrRkto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfsrRkto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5516C116C6;
	Mon,  2 Feb 2026 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047256;
	bh=DQHMSgsv3Ovvgk7wrUhAAoPFmN9TTDqtPHu6Cz7HA7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfsrRktoympOnvAdNukfodGNDG57OpTppFaeZUdDCTWc08e5pktKeeyIy6iMkaaF3
	 4J+6hXYdrb1E+IYZHxefkc/te9dqgZh7EMAWS/Vk8ITrBHA1IsJYQe7Zx2MXtDanlL
	 SNj+7YAA+pCre+3IUVjJFjRNoLSDgE9/iDyx4Pt4wAvwejiL8/M302wAwTKIqTAd9u
	 NCqG4KsaqtqZ7x0uVN3sVCVhNLMiMLh1GCFzmwvIyoRddjQ+J4zG0mMtcoS/gd9MhL
	 5N9NdEqIys5AkbDfDr+mDxI0B/q+vJuBkq3Zmh5QlGhSwKPNQOJ3rKth3itJFcpoL1
	 8ouC5IMV34uDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmw9G-00000007pPD-1BGL;
	Mon, 02 Feb 2026 15:47:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	qperret@google.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v1] KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported
Date: Mon,  2 Feb 2026 15:47:31 +0000
Message-ID: <177004724421.2704560.7699222325442161081.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202152310.113467-1-tabba@google.com>
References: <20260202152310.113467-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 02 Feb 2026 15:22:53 +0000, Fuad Tabba wrote:
> The NV stage-2 manipulation functions kvm_nested_s2_unmap(),
> kvm_nested_s2_wp(), and others, are being called for any stage-2
> manipulation regardless of whether nested virtualization is supported or
> enabled for the VM.
> 
> For protected KVM (pKVM), `struct kvm_pgtable` uses the
> `pkvm_mappings` member of the union. This member aliases `ia_bits`,
> which is used by the non-protected NV code paths. Attempting to
> read `pgt->ia_bits` in these functions results in treating
> protected mapping pointers or state values as bit-shift amounts.
> This triggers a UBSAN shift-out-of-bounds error:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported
      commit: 0c4762e26879acc101790269382f230f22fd6905

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


