Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124A07B
	for <kvmarm@lists.linux.dev>; Tue, 25 Oct 2022 15:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B91C433C1;
	Tue, 25 Oct 2022 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666711856;
	bh=3YeEg2Oa90timi1XZ3PvEOat7cXoDLZyE/kx8ALR0fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2yihkhMF0oKJomV48MeRvLFVsSnru0KmNrFtpW16uRT6BiJY9OhgvKDH10K7CTZQ
	 xMBfgpF5/h6qwvzmOzDvlkZtpT6g53Bv0xdDRxNPfzUkP0tGGeUsKniHkUPXo6pDQl
	 pC6Hm8II/0RR1F1GXlTU/VpCV81j3ZRedzb7pRczs2cfvLLn19HL8bZ9EoFO2BoKjd
	 v7RFJ+0MzlqzfLPoXjtIz/KlHn0N1gXMBIJnl+yXygMtZE1CxqD9myABnczTMeWi+w
	 dIa3Ka3SkhxFjRqmqSyBTzQyaKv136UemXswzie2idwwq316NWsVHZqYVcxDTYrVYS
	 G3Sa9uMhWGL5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1onLtG-001ZDz-L9;
	Tue, 25 Oct 2022 16:30:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>
Cc: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] KVM: arm64: Use correct accessor to parse stage-1 PTEs
Date: Tue, 25 Oct 2022 16:30:50 +0100
Message-ID: <166671184422.541929.12583367055859537857.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221025145156.855308-1-qperret@google.com>
References: <20221025145156.855308-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221025153050.l3HpIH9O2Srji1GkO60gAocc_w5kaluJt11S_woNvak@z>

On Tue, 25 Oct 2022 14:51:56 +0000, Quentin Perret wrote:
> hyp_get_page_state() is used with pKVM to retrieve metadata about a page
> by parsing a hypervisor stage-1 PTE. However, it incorrectly uses a
> helper which parses *stage-2* mappings. Ouch.
> 
> Luckily, pkvm_getstate() only looks at the software bits, which happen
> to be in the same place for stage-1 and stage-2 PTEs, and this all ends
> up working correctly by accident. But clearly, we should do better.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Use correct accessor to parse stage-1 PTEs
      commit: 6853a71726b6f5930b4450889faf02e8f1cfe35c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


