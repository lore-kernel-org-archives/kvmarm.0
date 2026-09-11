Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5243C411A00
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 11:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124567; cv=none; b=i3+BkB81+BTLyYqUfFQm0q/uED18Rbt9uApZQZSeF69M6N35E/Jk4pkq+M12uY3s+jCGtxg5RAh9ehqoOFxX0MYFIc1dSono3WK7W/QYqksFxpCmgGNeuwR8Ka9iPeZ50cMi0zHTx2UMmdS+bQKYuiFNTxohejMGMRbTJqHoUCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124567; c=relaxed/simple;
	bh=2BtxCMG1UX47JcL8m4ihOyCgKpPZe06qT00gvOC7j/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ilg/9zXfsERpBGrQMl4AZIRnB1I+VV57Px3YecEB6dCdhhe3i/RMXxuhdytg2xdG09DGyZhUoPLBaJqvSUguFJxW4cH8JPdMbiBvCucT4G0cgsQbGBb4mo9AZt5bHWUxwUJ2fc8UbObAebKLydPVadoe2sSKkFmT0qn5v8pJdkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=obUGDoB5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="obUGDoB5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1230B1570;
	Fri, 11 Sep 2026 04:02:42 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 429CD3F7B4;
	Fri, 11 Sep 2026 04:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789124565; bh=2BtxCMG1UX47JcL8m4ihOyCgKpPZe06qT00gvOC7j/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obUGDoB5mO5ZapOGEOXwSu9TIw3WlzWx9awf9ut2JExQ8RhFeGflliaoHfZyd+u/U
	 IMlwzcDeztMq8+YNnw8RP8xsZDLDK5C2dWf/OiiRb2sxsjmf0YppaQ5RMniifYXrcf
	 z5ARdbhFgjGzNQwBNdc2PGQgUbIXJef0PVM8Syts=
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
Subject: Re: [PATCH v20 14/14] KVM: selftests: arm64: Add GCS EXLOCK exception emulation test
Date: Fri, 11 Sep 2026 12:02:35 +0100
Message-ID: <aqPfy3EkSodbANj0@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <da1439eb-8205-4ba5-b37b-7a9aa37e1701@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-14-f31750bdfadb@kernel.org> <aqLm3qT755sXH_D9@LeoBrasDK> <da1439eb-8205-4ba5-b37b-7a9aa37e1701@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 10, 2026 at 07:26:59PM +0100, Mark Brown wrote:
> On Thu, Sep 10, 2026 at 06:20:30PM +0100, Leonardo Bras wrote:
> 
> > The part of re-running test_udf_exception() with HFGITR_EL2 set, IIUC, it
> > that part of fine-grained traps. It seems correct, although I am not seeing
> > any tests of the EC syndrome being 0x1A to make sure it's in use.
> 
> Now that I look again this isn't actually effective anyway, we would
> need to run the guest code at emulated EL1 which for something that's
> basically just a double check.  I'll just delete the extra runs.
> 
> > There are also a lot of expect_exlock being used as an int, even if it's a 
> > bool. I understand the idea of summing it as we expect it to be 1 on true 
> > or 0 on false, but is it really ok?
> > Maybe we could change it to int, so we just set it when we enter 
> > test_sysreg() or test_udf_exception() like:
> 
> > -	expect_exlock = enable_exlock;
> > +	expect_exlock = enable_exlock ? 1 : 0;
> 
> The conversions between int and and boolean values are part of the C
> spec and widely used within the kernel, we don't need to open code it.
> A zero in a boolean context is false, any other integer is true.
> Similarly false in an integer context is 0, and true is 1.

Okay then,

> 
> > If I got the workings right, and both above suggestions (0x1A and 
> > bool->int) are either fixed or considered not an issue, then:
> 
> Thanks.

Thank you!
Leo
