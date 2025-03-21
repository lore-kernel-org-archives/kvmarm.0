Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DE91F4C9B
	for <kvmarm@lists.linux.dev>; Fri, 21 Mar 2025 12:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742561865; cv=none; b=dEC8iTP1G+NndUjM91hHjUjGmNLral5Hr+xZhMEzOPoKIUEFr7DFEAD9tfCHqsdwMyjSHLC4QX9S3wRj0oQ7wcxyQReuVNjpaT2Ye1QfY+u7eERH/BW7WnbNYLYlv51kDdRSqe9buoTdOVLdwvBFuHzKJSrt/6dMvsKzG2+ELm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742561865; c=relaxed/simple;
	bh=9V5F+5KE+QgZzg0jOhP26TdHasnAHrPxMgAE6T3UHpE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H7fGbf7ndgrCF/UEA0xA3TZHRW9/3yOB4LSDxm336xP9rFTF/o/uKXbltmfEVO1AHdtdNLcUGY3z2UUhfcqSgKO5aKjTM0XZU0Gz5XypcALa3YuRgBtoT4MB8lqEb5NUn8zRwntUr5ZIqkHob7/bo20cEpWFMhv9Jl0c37zPWQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 408B5106F;
	Fri, 21 Mar 2025 05:57:50 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC44A3F63F;
	Fri, 21 Mar 2025 05:57:40 -0700 (PDT)
Date: Fri, 21 Mar 2025 12:57:32 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, open list
 <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, Linux ARM
 <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.linux.dev, Anshuman
 Khandual <anshuman.khandual@arm.com>, Rob Herring <robh@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Aishwarya TCV <aishwarya.tcv@arm.com>, Anders Roxell
 <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, Arnd
 Bergmann <arnd@arndb.de>
Subject: Re: Fast model boot failure with Linux next-20250312
Message-ID: <20250321125732.6def5eca@donnerap.manchester.arm.com>
In-Reply-To: <CA+G9fYuw_jXCz07Dsk46QXQr3+y5-NfkC30ZNh+XmyeWgibQhA@mail.gmail.com>
References: <CA+G9fYvPu+MQKhYyPZSSDpAn-zhRGmeHQ8hJksT_cdDdxfbB-g@mail.gmail.com>
	<Z9ra3I2axii2HRVb@J2N7QTR9R3>
	<CA+G9fYuw_jXCz07Dsk46QXQr3+y5-NfkC30ZNh+XmyeWgibQhA@mail.gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Mar 2025 16:03:32 +0530
Naresh Kamboju <naresh.kamboju@linaro.org> wrote:

Hi,

> On Wed, 19 Mar 2025 at 20:25, Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > On Wed, Mar 19, 2025 at 08:07:47PM +0530, Naresh Kamboju wrote:  
> > > Regressions on the arm64 Fast Model (FVP-AEMvA) caused boot failures starting
> > > with Linux next-20250312 and persisting through next-20250319.
> > >
> > > First seen on the next-20250312
> > >  Good: next-20250311
> > >  Bad:  next-20250312 .. next-20250319
> > >
> > > Regressions found on FVP:
> > >  - boot
> > >
> > > Regression Analysis:
> > >  - New regression? Yes
> > >  - Reproducible? Yes
> > >
> > > Boot regression: Fast model boot failure with Linux next-20250312
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > Anders bisected this to this commit id,
> > >
> > > # first bad commit:
> > >   [858c7bfcb35e1100b58bb63c9f562d86e09418d9]
> > >   arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
> > >
> > > NOTE:
> > >   LKFT is currently running FVP Fast Models version 11.24.
> > >   Planned upgrade to the Fast Models version 11.28 in this sprint.  
> >
> > What firmware (and version therof) are you running within the model?  
> 
> Fast Models [11.24.11 (Nov 29 2023)]
> Booting Trusted Firmware
> BL1: v2.9(release):v2.9.0
> BL2: v2.9(release):v2.9.0
> BL31: v2.9(release):v2.9.0
> UEFI firmware (version  built at 22:31:25 on May 26 2023)
> UEFI v2.70 (EDK II, 0x00010000)
> 
> We need to update the firmware version at our end.

Oh yes, please, v2.9.0 is quite old by now, especially for a moving target
like the FVP, and when enabling new architecture features.
FWIW, after Anshuman pointed me the problem, I made a patch for TF-A to
enable PMUv3p9:
https://review.trustedfirmware.org/c/TF-A/trusted-firmware-a/+/35884
You would need that for this Linux commit here to work.
FEAT_FGT2 should be enabled already by default for the FVP.

Please feel free to leave a comment at the TF-A gerrit, stating that you
need the patch, that should accelerate the upstream process.

Cheers,
Andre

> > For example, if the EL3 firmware lacks support for FEAT_FGT2 or
> > FEAT_PMUv3p9, the kernel will trap to EL3 early during boot and die.
> >
> > It would be really helpful if you could capture that in the report in
> > future.
> >
> > Mark.
> >  
> > >
> > > ## Boot log
> > >   <No crash log on the console>
> > >
> > > ## Source
> > > * Kernel version: 6.14.0-rc7
> > > * Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > > * Git sha: ff7f9b199e3f4cc7d61df5a9a26a7cbb5c1492e6
> > > * Git describe: next-20250319
> > > * Project details:
> > > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319
> > > * DUT: arm64 Fast Model (FVP-AEMvA)
> > > * Toolchains: gcc-13 and clang-20
> > >
> > > ## Build
> > > * Build log: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/log
> > > * Build history:
> > > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675685/suite/boot/test/gcc-13-lkftconfig/history/
> > > * Build details:
> > > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/
> > > * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/
> > > * Kernel config:
> > > https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/config
> > >
> > > --
> > > Linaro LKFT
> > > https://lkft.linaro.org
> > >  
> 
> - Naresh
> 

