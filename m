Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909B3481AA6
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787160199; cv=none; b=WBbLubDyseyJIDm4fBJOwTl4aOc7SvITLDYsZblD+oHPICfWSpqymJsHAtsLIiWDTAG7eNSS/Sk4uWV8VYP33w78gBCvSUKPBUGQEjVbH9eHu+7atk6gaqseZjj0+ChQut/koaFr+6dG2+660mMOpUkO/2+WL6YR6z2o3Oqjiss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787160199; c=relaxed/simple;
	bh=oaf5ktsrI6b7DKdGMDPNdLd7SsRg66KYC+01Ywlnnos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=aknhDEnIvDpR4gS4df7Kfjv1PzvMCi7tyuooHGxxQ7CGpYWzYrdwd6MyEgWoQRzGVkQCXi7NlVGhewV9CaV7v3Z5TkzTd5tlH4eSP0Wupv2zyjnI7zOkUBWhi9Tdkg8MsMG9QIT8DZUtq08ziizPdmfTxtSi04z5oYzQLZs6nYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nBbiCvgu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nBbiCvgu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3DC214BF;
	Wed, 19 Aug 2026 10:23:12 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D6B73F763;
	Wed, 19 Aug 2026 10:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787160196; bh=oaf5ktsrI6b7DKdGMDPNdLd7SsRg66KYC+01Ywlnnos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBbiCvgujcMEfiB74c+ETm4tYN1UcQpl+DV/3s58aUlFmNnnHvioZ+4rjOtaiNuEV
	 eqEguOQk16IM0R0AhdplVdzif0tqYH+T5Qs1/Q7yTMpPZkfK7eec18dYok/keDguYx
	 QNPqBgne1B7ITaezBJ5STN0UVwamjKNii54Aqe/U=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 04/14] KVM: arm64: Ensure GCS memory effects are visible
Date: Wed, 19 Aug 2026 18:23:11 +0100
Message-ID: <aoXmfz5pPwRYRKTO@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812-arm64-gcs-v19-4-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org> <20260812-arm64-gcs-v19-4-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Aug 12, 2026 at 08:12:03PM +0100, Mark Brown wrote:
> In order to allow efficient implementation of GCS implementations are
> permitted to do GCS specific caching, with barriers implicit in stack
> switch operations

(GCSSS2)

> and GCSB DSYNC as an explicit barrier.  Since we do
> not use GCS in the hypervisor or host kernel the hypervisor cannot rely
> on any barriers being present in vCPU context switches other than those
> it explicitly inserts.  Add explicit barriers when loading and saving
> vCPU state.
> 

The same way we have a DSB, having a GCSB here seems required, as there may 
be pending GCS writes. Makes sense.

Question:
You state that we do _not_ use GCS in the hypervisor, nor in the host.
I understand that we GCSB() when we exit the vcpu context, but why would we 
need to GCSB() before getting back in?

If cpus will GCSB() on guest_exit, and host/hyp does not use GCS, there 
should be no GCS pending operation at the entry point.

Am I missing something?

Thanks!
Leo
