Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AD8C2C3
	for <kvmarm@lists.linux.dev>; Wed, 24 May 2023 12:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D2AC433D2;
	Wed, 24 May 2023 12:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684932599;
	bh=HCqiNG2g1d52QdlwrmLQNafbNg/sJk+27H38CFX7j+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv76FXmLLTYGlylIcK3F33a5HNU6Axq/5kZ/VrBI4NxLKh9TTk8BHi4sgz4LcRPxs
	 HgfBZmt8OMlRaUAzMr78lt27Uh0D0XC4DdCwVD/Zoqbmy48uja5qPZ+/o+sJudDl9B
	 3fglW0braONcV7G1dEZiWAmvTzkMbQ4t3hDXL6XW7ThWR+YWHhth2SQ+ww7cmhtp5B
	 xEaLeHA4T1Juu7/EZmY8yGOLbZtZbMSs/GNnWI68GR+U9YihRWX7OS3b6pxN0raS6V
	 6BzpOXXj6c0lAwp7L3RTxge/sENWk3b5J8n8An8R2tdJASznfyYRrgmzPyy29R1dYT
	 4Chvu9/zJWfVw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q1nw8-0002Lm-Ft;
	Wed, 24 May 2023 13:49:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>
Cc: peterx@redhat.com,
	yuzenghui@huawei.com,
	dmatlack@google.com,
	linux-arm-kernel@lists.infradead.org,
	seanjc@google.com,
	bgardon@google.com,
	oliver.upton@linux.dev,
	gshan@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com,
	james.morse@arm.com,
	will@kernel.org,
	qperret@google.com,
	reijiw@google.com,
	suzuki.poulose@arm.com,
	catalin.marinas@arm.com
Subject: Re: [PATCH] KVM: arm64: Reload PTE after invoking walker callback on preorder traversal
Date: Wed, 24 May 2023 13:49:50 +0100
Message-Id: <168493254802.3630329.2856173327975133953.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522103258.402272-1-tabba@google.com>
References: <20230522103258.402272-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, tabba@google.com, peterx@redhat.com, yuzenghui@huawei.com, dmatlack@google.com, linux-arm-kernel@lists.infradead.org, seanjc@google.com, bgardon@google.com, oliver.upton@linux.dev, gshan@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com, james.morse@arm.com, will@kernel.org, qperret@google.com, reijiw@google.com, suzuki.poulose@arm.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 22 May 2023 11:32:58 +0100, Fuad Tabba wrote:
> The preorder callback on the kvm_pgtable_stage2_map() path can replace
> a table with a block, then recursively free the detached table. The
> higher-level walking logic stashes the old page table entry and
> then walks the freed table, invoking the leaf callback and
> potentially freeing pgtable pages prematurely.
> 
> In normal operation, the call to tear down the detached stage-2
> is indirected and uses an RCU callback to trigger the freeing.
> RCU is not available to pKVM, which is where this bug is
> triggered.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Reload PTE after invoking walker callback on preorder traversal
      commit: a9f0e3d5a089d0844abb679a5e99f15010d53e25

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


