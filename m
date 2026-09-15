Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82C03B05AF
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 23:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514564; cv=none; b=PvVVX00B6xPKu36fHtTcPZk4lEcA2UTbYd5HAFp+8F2xxBqMpFDQ9ZyZ3sXjNKrnB3W6sHpsD9XuA8wb8OpyOIiSBUaf+sG2ko2ZnZj0iIN6+uZmQv62WX/mFAF//dhO90a/qKlXPFAVXT+RfVhXJUOrdrNpYRisxKipmDKKRHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514564; c=relaxed/simple;
	bh=OS0wxKZCFNEfEztQQhdc6654Pd1/uEe8rOvUd/XNr7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azWV7iif9JAoX3pXgja4qzEUTvH+uK6vrB5KOURtxNbEnAYzus9ZJhSEhZx+s4PIV0WvM5HdhqRWDm9FaoNVWaQaJs/ewKApFqVrYTHxwB/Q7bGlZnrbfCzmLhphSada6qLlQLFeosNqLEEc5hLW7gAsWZ6cwAbs95G4BEzZmFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b85rL/S5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b85rL/S5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 373C31477;
	Tue, 15 Sep 2026 16:22:38 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 240723F7B4;
	Tue, 15 Sep 2026 16:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789514561; bh=OS0wxKZCFNEfEztQQhdc6654Pd1/uEe8rOvUd/XNr7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b85rL/S5Bgsbb0R+fUSlSOCkOlBP51VioBE+38M+lJaIena0AFPwnBVvWiZK5Xlyx
	 OrJZDjU1YvF+XjsuDN9pj2rDDGAqa/bBlD6v6vd39r8ptOvL9zUxfoAZJKOQl6zhgV
	 lfoAVKa3vEFn24BYn/dSmHsdunLXBOPfnRF3sAkc=
Date: Wed, 16 Sep 2026 00:22:30 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Wang Han <wanghan@linux.alibaba.com>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <m6ldbr7hdafmoycx7xjcbsg62mblcakcu52ndowwzqgxdjb3q3@huv4i5bfxtza>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
 <aqm9hXB6X9IQ8wHz@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqm9hXB6X9IQ8wHz@sm-arm-grace07>

On Wed, Sep 16, 2026 at 06:49:57AM +0900, Itaru Kitayama wrote:
> On Tue, Sep 15, 2026 at 04:42:58PM +0100, Wei-Lin Chang wrote:
> > Hi,
> > 
> > This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> > notifiers.
> > 
> > This version fixes a few issues, and adds Marc's space optimization
> > for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> > 
> > Tested by booting L3, and running in-kernel targetted tests described
> > in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> > carry them over since some bugs fixed in v6 are non-obvious. Some
> > retest would be much appreciated!
> 
> How did you boot into L3, with KVM selftest or recrusively boot on HW?

I just recrusively booted VMs on hardware. :)

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 

[...]
