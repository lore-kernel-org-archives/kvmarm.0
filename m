Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418CA13FE6
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 19:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B358AC433C7;
	Tue,  8 Aug 2023 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691522406;
	bh=uHBqoM9zzNh1je/R5fZWDJ6r+ThQHbms638Yw8z8N60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jngDpdvO8ZDMrymBWDv4+Johg4StfoaCUt5EfKuzMGDcXy6dTKs/ullsXiQibGDAz
	 zv9Ud4KdATAStprwHIbrGYYgc16wDzPMR7WdUIW+p5Ev7H9JmCICxyXEidWoH5upF4
	 6jTyYcnleYF10eWz6jhhhNN4/GvnrSvqFV/zw+ViyjueDWqZq4MJAYf1NLWWs8kAdN
	 r+JAyZzYMq4jSpANBZkAm9MSA3/Xs3bMyQbbK8QLyCUkg64PgW+ocyYJCKJjKueIFZ
	 a29iWLo9TlRQRrAsyofoy7SVLP9sNq7iAdka+C112/7QNtC7PPfqsgoiu3n6odvKLy
	 0Wz0mHQtBqKkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qTSFQ-003G2r-9F;
	Tue, 08 Aug 2023 20:20:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v1] KVM: arm64: Remove redundant kvm_set_pfn_accessed() from user_mem_abort()
Date: Tue,  8 Aug 2023 20:19:57 +0100
Message-Id: <169152238419.2019869.16916322466699521843.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731114110.2673451-1-tabba@google.com>
References: <20230731114110.2673451-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 31 Jul 2023 12:40:31 +0100, Fuad Tabba wrote:
> The function user_mem_abort() calls kvm_release_pfn_clean(),
> which eventually calls kvm_set_page_accessed(). Therefore, remove
> the redundant call to kvm_set_pfn_accessed().

Applied to next, thanks!

[1/1] KVM: arm64: Remove redundant kvm_set_pfn_accessed() from user_mem_abort()
      commit: 4460a7dc77d00340c59f7e4252c65efd5fbe877b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


