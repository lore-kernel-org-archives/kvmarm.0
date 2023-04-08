Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB391854
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 14:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74966C433D2;
	Sat,  8 Apr 2023 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680965037;
	bh=qaFp4flueH7UQbqZO77QoHx6kPjhzYfOcp4ZUG6IkwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moOL4MTcV6WcWhX0Htu2e9xVtsuKvI6ndTeZIf1E1GwqSCAZr5c1XAkeVK+ThY+7R
	 Ji7VZusfmbfOnlPnqJ4bEMu4c8Rt1j3aS5WdnQ/4mCe7sTbHig6bwPu1K6wkdjO5k+
	 nCvJ8CFPWeTm1DqNiBdw4OnSKq53c391FMvnqExSJinvkVH4ZkwieJybRY0SPgu01N
	 OCZnLl6oHCJBu25W+PDQnGVzf2y4wMlGjBjNCmTQww3B8sncX+PEIvSGq6WmyVLcSy
	 01fP1xS7tB/LidGIbgCatOiFCVNlBoFy2ozLNgZKhaMiCqCgUjZ9Vf7/cTX1wsOM9A
	 /bLULB5uuCeEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pl9nH-006vvg-1e;
	Sat, 08 Apr 2023 15:43:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Colin Ian King <colin.i.king@gmail.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] KVM: selftests: Fix spelling mistake "KVM_HYPERCAL_EXIT_SMC" -> "KVM_HYPERCALL_EXIT_SMC"
Date: Sat,  8 Apr 2023 15:43:52 +0100
Message-Id: <168096502866.4154147.16883387096134090990.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230406080226.122955-1-colin.i.king@gmail.com>
References: <20230406080226.122955-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvm@vger.kernel.org, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, shuah@kernel.org, oliver.upton@linux.dev, colin.i.king@gmail.com, suzuki.poulose@arm.com, pbonzini@redhat.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 6 Apr 2023 09:02:26 +0100, Colin Ian King wrote:
> There is a spelling mistake in a test assert message. Fix it.

Applied to next, thanks!

[1/1] KVM: selftests: Fix spelling mistake "KVM_HYPERCAL_EXIT_SMC" -> "KVM_HYPERCALL_EXIT_SMC"
      commit: c5284f6d8ce2b9cf96643da441862434233a4ea3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


