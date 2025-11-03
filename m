Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5639C1F5423
	for <kvmarm@lists.linux.dev>; Mon,  3 Nov 2025 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193035; cv=none; b=Z+v1GFMFca0vyWRVvA32xWQWCDqs3LwGQBIXYGBwReiDtBRmvxUs5vuU3JOwt2XSzNLBQ2jtdM+iRzXRKIIFomjoeVHeXudBMzHU2tPOhFo2cqOSmAENArLQDEMgkqttI2QatgEp5rUFPsubpwTR6dM7yQqh5DmI0vPytWubSbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193035; c=relaxed/simple;
	bh=TAi4Gy48laJw0gvuU2GMYz2SgWgyaCZPtyVFQG8hCOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUG9pr8enVzJV3tLq/3T0c0hSQ1vQ7uUv1jpVOiSjmxTlnRAM3d+BMagqobleyKLpbY3Qq4YA0f+yXBKrBQRkq31hb5lPXmYsCZBbjwjgDOyuPfeeU2O0W196i1YPgrVnyBbnuom50J+DEEL/WUWkbNe+e78vGUF0INkbtP0rzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B98B62A6B;
	Mon,  3 Nov 2025 10:03:44 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 129933F694;
	Mon,  3 Nov 2025 10:03:51 -0800 (PST)
Date: Mon, 3 Nov 2025 18:03:50 +0000
From: Leo Yan <leo.yan@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH V6 1/3] tools: header: arm64: Replace TCR_NFD[0|1] with
 TCR_EL1_NFD[0|1]
Message-ID: <20251103180350.GZ281971@e132581.arm.com>
References: <20251013052945.2197190-1-anshuman.khandual@arm.com>
 <20251013052945.2197190-2-anshuman.khandual@arm.com>
 <aQjm7wmvHa79hkyi@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQjm7wmvHa79hkyi@arm.com>

On Mon, Nov 03, 2025 at 05:31:27PM +0000, Catalin Marinas wrote:
> On Mon, Oct 13, 2025 at 10:59:43AM +0530, Anshuman Khandual wrote:
> > Replace TCR_NFD[0|1] (used in TCR_CLEAR_FUJITSU_ERRATUM_010001) with field
> > definitions which are available in tool sysreg format. Helps in completely
> > dropping off the adhoc TCR_NFD[0|1] macros later.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Leo Yan <leo.yan@arm.com>
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  tools/arch/arm64/include/asm/cputype.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/arch/arm64/include/asm/cputype.h b/tools/arch/arm64/include/asm/cputype.h
> > index 139d5e87dc95..dfa12df5e290 100644
> > --- a/tools/arch/arm64/include/asm/cputype.h
> > +++ b/tools/arch/arm64/include/asm/cputype.h
> > @@ -243,7 +243,7 @@
> >  /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
> >  #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
> >  #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
> > -#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
> > +#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
> 
> Isn't this file usually updated automatically (well, someone running a
> script to sync) from the corresponding arch/arm64/ one?

Yes, usually perf tools maintainers (Arnaldo or Namhyung) will sync
headers in tools.

Seems to me, it is also fine to send this patch.  Please kindly remind
perf maintainers after the kernel changes have been merged, so it is
safe for picking up the change in tools.

BTW, I built the perf with this series and did not see any issue.

Thanks,
Leo
