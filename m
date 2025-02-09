Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2247B15F41F;
	Sun,  9 Feb 2025 10:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096503; cv=none; b=PtRCaF6VOGGZOysyP4xthG+f/Lsv/fi64U2Iu44m+k3mx5qU+fanuQ3BgjgqmJpVebsr8cSX0xuJ9RrKC695LyJuBhSSoJLegKTTTBuxlDON0O2lWnXAVSeqk4GDjGcRIrz0g9PYtZPVvqRqsgy+Tlkw/a8v8wefCAoiKKOpi9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096503; c=relaxed/simple;
	bh=ljE5yUYKD7VORy12kAg7aDzprFkq/ZEsUxC+fJE/JKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9nVhI8d2iKyCuagigsfwrcvjvOXO4uHA7dACyAcOGy+B8q4H4RI6c5OtsuiVNHQtvGGiV2os27Id8E33GBDgFM/4yvE3ZD70ON4i1gSklLMAvyNUZs635bQsWRmqZOi3Q2GXDF744kRioaUPwCoQivEyaQbg1U88WoeIghWPpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcOx08Jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcOx08Jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932D6C4CEDD;
	Sun,  9 Feb 2025 10:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739096502;
	bh=ljE5yUYKD7VORy12kAg7aDzprFkq/ZEsUxC+fJE/JKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcOx08JcDQwd/5MPhSO5Me7KQAI6EDSijqvqQAb+Ga00Cd1eZFfYBIxLr1pR7tS32
	 eNFzyH8DMqHA14LFKNe/5I29sWf4VBMLhPo+uA55qGdlKvINLqcISmKrdf/wia5RzC
	 4+4Iaul0PXoqN2/fVYj0FKQuyT5CthpRALR3EHtQny1ABMAVMyelZnpfdAEr7UiLBE
	 Qc9nmiijGeOgF2BWyXbYwYt6IrKjl1AvO6RtWJsUlwB+7f43ZnHL+M2+Vcu3gOu1Dq
	 mh/mu4Al8vhQEWSQPKU4RYAqMOAtOyxMTTuSOb12AzVipiGjAXj3JZM3bdehzTx9EX
	 IQGD5RihQ+CqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1th4RW-0029ai-4E;
	Sun, 09 Feb 2025 10:21:39 +0000
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
Subject: Re: [PATCH 0/2] Fixes for pKVM NP-guest support
Date: Sun,  9 Feb 2025 10:21:33 +0000
Message-Id: <173909647948.1598393.13009014212384755720.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250207145438.1333475-1-qperret@google.com>
References: <20250207145438.1333475-1-qperret@google.com>
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

On Fri, 07 Feb 2025 14:54:36 +0000, Quentin Perret wrote:
> Here are two patches to deal with a race between the handling of
> permission faults and MMU notifiers with pKVM that I found by
> inspection. Specifically, pKVM gets thoroughly confused when it doesn't
> find a page mapped in its relax_perm path, while standard KVM deals
> with that trivially thanks to the -EAGAIN special case in
> user_mem_abort(). The second patch addresses the problem by simplifying
> the implementation of multiple pKVM hypercalls, which also has the nice
> side effect of improving locking by not taking the global host stage-2
> lock as much.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Improve error handling from check_host_shared_guest()
      commit: c53fbdb60fb61fd6bda2bc0dc89837966625c5dc
[2/2] KVM: arm64: Simplify np-guest hypercalls
      commit: eabc7aaef7a553b64bf6e631ce04526af6c8d104

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


