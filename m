Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0FB7F
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 12:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CBEC433C8;
	Tue, 22 Aug 2023 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692708001;
	bh=QxJMKfUj5j1DEhUO56xv8uYRlBwjNJuW16s1Ob0iUmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wysn+bltQnLIBS1Fs3gWPqZ/jibBUY7LPtij+ckm9PBv3CLu3FAaDp6K3h6KO6ZpG
	 pBcoaITJ4R2jYJpInVuSn/KqZONhLt9LA4hDR4m7HfMNSlixgAKAO6Is1/fFq+d8Hb
	 +nPgkZz9n1m0wg1Pm2sbs4TaEGW5LxIml5QKWJ6X/F5/Zi86tODQ4Xh/CqzMdsKEqO
	 76+smr/pDnkTANFxYLAnduSwRp30XpAOBTORHCQjIHPJXjYMQhjJLbrgeAG6FuESw9
	 pHCjtNai/5NSzkbD4yoBNo8dF1GPCWvx1MqDIc0XRi7wze49lUiAvseLYgmnb9HI0K
	 m8NPLVT7xjT7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qYQfv-0071ho-8E;
	Tue, 22 Aug 2023 13:39:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	James Morse <james.morse@arm.com>,
	Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH v2] KVM: arm64: pmu: Resync EL0 state on counter rotation
Date: Tue, 22 Aug 2023 13:39:55 +0100
Message-Id: <169270798678.3074463.12855795724918170184.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230820090108.177817-1-maz@kernel.org>
References: <20230820090108.177817-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, maz@kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, yuzenghui@huawei.com, shijie@os.amperecomputing.com, james.morse@arm.com, leo.yan@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 20 Aug 2023 10:01:08 +0100, Marc Zyngier wrote:
> Huang Shijie reports that, when profiling a guest from the host
> with a number of events that exceeds the number of available
> counters, the reported counts are wildly inaccurate. Without
> the counter oversubscription, the reported counts are correct.
> 
> Their investigation indicates that upon counter rotation (which
> takes place on the back of a timer interrupt), we fail to
> re-apply the guest EL0 enabling, leading to the counting of host
> events instead of guest events.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: pmu: Resync EL0 state on counter rotation
      commit: b1f778a223a2a8ad6262e5233cfc3483bcf6e213

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


