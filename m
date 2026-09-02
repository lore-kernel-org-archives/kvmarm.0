Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292884AA404
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367467; cv=none; b=U5OVhViryTutIIQSEjS5f5YhIY/rcz8Uy+OcJYsuP6dJw0Ns7e0IP3t9NO0deCKB5bNDwmyhychFu5YRfEzPtDJ0saJYDxPgEA7TJhHflQNij8S7azpSTs1rr35YIW33ZblQZpveGOeWx1GzlhLADPjTUhyYuYK9buyWFRvMUQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367467; c=relaxed/simple;
	bh=fo+Lm5rgAEqscXe3PTqtMl9I58MX7lReZIhCjwIIG0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=rBI6mexDzymVlYhJISr40EDTC2CnpZTc0/bFKsDwRb6gcT0NZVfMf9fHcryAo8hm3n0cP97wbCxqao6oTSKRTbKBqub4uDEhvo/ZtKsm9ol1QgCPNDBwzYflf91CNl9YNXaQ8Uq4JPBA8OcquSCKifT5GF3SBvbJzFSy1GOoVJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CY5gEVoC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CY5gEVoC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E0F4165C;
	Wed,  2 Sep 2026 09:44:20 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44C7C3F882;
	Wed,  2 Sep 2026 09:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788367463; bh=fo+Lm5rgAEqscXe3PTqtMl9I58MX7lReZIhCjwIIG0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY5gEVoCrpvX5hEGWFgR6zCcIbDhyAgXBJKkidDhnKsnwmqjImb9kOGcr2cLLra6u
	 jJOHgJjKS/b8XaTz+KuI0jv21GWI/xGhA9NX+RxqTGaLkXZ4zCkBxIKnGU59yFnLAJ
	 VC9upgRDM6r1EtGVbilhQ8UpkhPYK2PCcE/+nWWw=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 03/14] KVM: arm64: Manage GCS access and registers for guests
Date: Wed,  2 Sep 2026 17:44:18 +0100
Message-ID: <aphSYqKrgUq5Qycu@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Mark,

On Tue, Sep 01, 2026 at 10:47:01PM +0100, Mark Brown wrote:
> GCS introduces a number of system registers, on systems with GCS we need
> to context switch them and expose them to VMMs to allow guests to use
> GCS.
> 
> In order to allow guests to use GCS we also need to configure
> HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
> CHKFEAT will report GCS as disabled.
> 

Everything you do seems the correct approach, and all the loads/saves 
are symmetrical, except for VEL2, for which the reason was made known 
in v19 discussion.

That being said, I may have missed something as I am still not very much 
used to NV code. So, FWIW:

Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Nit:
Reading this patch, it feels like it should have been two different 
patches: one for adding the registers to kvm infra, and the other for 
loading/saving it in the code (with GCSEn). If you later decide to split 
it, feel free to add my R-b in both of them.

Thanks!
Leo



