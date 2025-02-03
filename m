Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB1B53AC;
	Mon,  3 Feb 2025 00:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543399; cv=none; b=FO2pZbf/lfhVhIZtsLWJOxmUCKXzyZngSmvC62SZ0n3h09YD7WLmshBNrRyY45QlqS4FSyhTFNyA6yMiv6d4uqFFWR1DB49ITr0TQZZi1VMonwQNHgDanlly23qqg3VUIZJr8jN0JkuwXNQLxBnKxjlUl+8H+86qJqQPvslrs/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543399; c=relaxed/simple;
	bh=V8wrbmv6+iU82R3xdPrcgfmHhCpNAQtvlPJUttOpxTs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oVd8RUGXhU+fKViiINsbJWf1r755YfMWCyQtXYdG1KNCuig0K2XStP19b22b9HuLaezyqyYSc/Sdi/xYlol79oYm29fcdN+JNnPZPfI9Wyzsc6oeEPIH7qYC6lExsAlaP9nbaZKPMuTJLAr6JqnFYGh4UrI2aaru4zIYNZabb2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RkUzq0+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkUzq0+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A62C4CED2;
	Mon,  3 Feb 2025 00:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543398;
	bh=V8wrbmv6+iU82R3xdPrcgfmHhCpNAQtvlPJUttOpxTs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RkUzq0+shuRFTcI2VpNYT4svHSo2rOdw8L1hZKiMwZcgKwXfeZzpJGGWA140p0oP8
	 MS+rKCcRRYqVeg2+xjXlyIYJ4KhVIehW6Y3TbcBB14GLPJQsWncO1lrvqhh8B+IbdK
	 hPMILjYi/BosJtzaiHuNGQBmbIbQi16fWsQplDYZaZ8yeBtQ/z5fkctxVxkDLUusrK
	 UKX6wf7OV/7pZ+7QAX1rBrkXL4dbTd6CT/y0C1W+2XWn9sDPU5Gy5cv4JdvBl+m7am
	 qqVeoW+7g0T1uLg6lDNOL/HI9075HZQUepvXEVU4w6oCAFteqO3MtijLXXFtQ6w1rQ
	 Yl3UqCd20c7Yw==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:42:55 -0600
Subject: [PATCH v19 01/11] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0()
 before enabling counters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-1-1c1300802385@kernel.org>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
In-Reply-To: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

Counting events related to setup of the PMU is not desired, but
kvm_vcpu_pmu_resync_el0() is called just after the PMU counters have
been enabled. Move the call to before enabling the counters.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/perf/arm_pmuv3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 0e360feb3432..9ebc950559c0 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -825,10 +825,10 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 	else
 		armv8pmu_disable_user_access();
 
+	kvm_vcpu_pmu_resync_el0();
+
 	/* Enable all counters */
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
-
-	kvm_vcpu_pmu_resync_el0();
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)

-- 
2.47.2

