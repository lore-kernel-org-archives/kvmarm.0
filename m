Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE1736A004
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094840; cv=none; b=fdMlKDXawg64sufdVvICfmnrrbsRix4rrnPsOlsugO0Nv65Bx/kNp6V3Q6MRsAasSRCUnhT1Aq28uLcKvQZ3zOyWH2mRZKArb5Pa6cjpLdwdQe8Wu9J0FUmVnIPXUvRGxQLE9lAjrTqlRsucKU0TbHJE5E3A06/J2m6jIMyNqa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094840; c=relaxed/simple;
	bh=7EhnDCa5DdDVVOaHZg9iRoMPUPP7DFCJeLFhd4Rbjo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=MeAg6XSZnQvwfLiSBOlTOJO5SVp2M9sz0YtSmw7Bo4ZuxSDxeJIixtTbbvbimS7xVcMMSfj40sVj9SfdsprlDnMewL7SumySQn3akcKpzcsqyYmeK1ZIjJp478/QtvR1JVJZ0eJmfSG3YKYjKCRts0XWWvGuW86AL/8cS2lGIUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF2B91476;
	Thu, 22 Jan 2026 07:13:50 -0800 (PST)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 050223F632;
	Thu, 22 Jan 2026 07:13:54 -0800 (PST)
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	oliver.upton@linux.dev,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	linux-kernel@vger.kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yezhenyu2@huawei.com,
	xiexiangyou@huawei.com,
	zhengchuan@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v2 1/5] arm64/sysreg: Add HDBSS related register information
Date: Thu, 22 Jan 2026 15:12:28 +0000
Message-ID: <aXI-XHF2jz7arOwg@devkitleo>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <86wm3iqlz8.wl-maz@kernel.org>
References: <20251121092342.3393318-1-zhengtian10@huawei.com> <20251121092342.3393318-2-zhengtian10@huawei.com> <86wm3iqlz8.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Nov 22, 2025 at 12:40:27PM +0000, Marc Zyngier wrote:
> On Fri, 21 Nov 2025 09:23:38 +0000,
> Tian Zheng <zhengtian10@huawei.com> wrote:
> > 
> > From: eillon <yezhenyu2@huawei.com>
> > 
> > The ARM architecture added the HDBSS feature and descriptions of
> > related registers (HDBSSBR/HDBSSPROD) in the DDI0601(ID121123) version,
> > add them to Linux.
> > 
> > Signed-off-by: eillon <yezhenyu2@huawei.com>
> > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > ---
> >  arch/arm64/include/asm/esr.h     |  2 ++
> >  arch/arm64/include/asm/kvm_arm.h |  1 +
> >  arch/arm64/tools/sysreg          | 28 ++++++++++++++++++++++++++++
> >  3 files changed, 31 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > index e1deed824464..a6f3cf0b9b86 100644
> > --- a/arch/arm64/include/asm/esr.h
> > +++ b/arch/arm64/include/asm/esr.h
> > @@ -159,6 +159,8 @@
> >  #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
> > 
> >  /* ISS2 field definitions for Data Aborts */
> > +#define ESR_ELx_HDBSSF_SHIFT	(11)
> > +#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
> >  #define ESR_ELx_TnD_SHIFT	(10)
> >  #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
> >  #define ESR_ELx_TagAccess_SHIFT	(9)
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 1da290aeedce..b71122680a03 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -124,6 +124,7 @@
> >  			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
> > 
> >  /* VTCR_EL2 Registers bits */
> > +#define VTCR_EL2_HDBSS		(1UL << 45)
> 
> I think it is time to convert VTCR_EL2 to the sysreg infrastructure
> instead of adding extra bits here.


Hi Marc, Tian,

Marc, IIUC the above was implemented by 
https://lore.kernel.org/all/20251210173024.561160-1-maz@kernel.org

Which was recently applied to next, and it its way to mainstream.

Tian, I think it's worth rebasing this patchset on top of the above.

BTW, I am working on using the feature enabled by this patchset on a new 
optimization, so please include me on any new release.

Thanks!
Leo
