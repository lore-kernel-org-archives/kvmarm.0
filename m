Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00304187855;
	Fri, 23 Aug 2024 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724431274; cv=none; b=RuZel4nNpPVvRAC7U90SHk3YffowF4gzTcDCUCWNEY++5ZKcyedHNei0vuFSzolzocttslwC8DOpMBGo92yXqGjFQfcWAPRsquu1HEFZWUOrptnSTDyFkdluS4NCVLZz7ioSg5qKwIxbS7Tb+kzTkVN4Bg4OnTEcEwnnrdTDB8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724431274; c=relaxed/simple;
	bh=ppzAQCslayB1hl9YWar70+u3v8kuzOARmAZmCO5P9e0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNb6sTE1ji3RoqBTZ7ns2yxiKgaYcuXqWPEuADkA9mbAtQ0DGPJGpSlg0LWb5eOltbxRfSJIuYXR3tT078N62/oDDwEgHWFVPzj5xe9wshGaV8U/3JsveNPRWqN1gRbHefM1uhsZHA96JLIsK/YCJxzs2nb4ei8FgguksG9dRhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB56C32786;
	Fri, 23 Aug 2024 16:41:08 +0000 (UTC)
Date: Fri, 23 Aug 2024 17:41:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
	nd@arm.com, akpm@linux-foundation.org, aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, bp@alien8.de,
	broonie@kernel.org, christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, skhan@linuxfoundation.org,
	szabolcs.nagy@arm.com, tglx@linutronix.de, x86@kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 06/30] arm64: context switch POR_EL0 register
Message-ID: <Zsi7ovLOfuFdfuuz@arm.com>
References: <20240822151113.1479789-1-joey.gouly@arm.com>
 <20240822151113.1479789-7-joey.gouly@arm.com>
 <20240823144531.GH32156@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823144531.GH32156@willie-the-truck>

On Fri, Aug 23, 2024 at 03:45:32PM +0100, Will Deacon wrote:
> On Thu, Aug 22, 2024 at 04:10:49PM +0100, Joey Gouly wrote:
> > +static void permission_overlay_switch(struct task_struct *next)
> > +{
> > +	if (!system_supports_poe())
> > +		return;
> > +
> > +	current->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);
> > +	if (current->thread.por_el0 != next->thread.por_el0) {
> > +		write_sysreg_s(next->thread.por_el0, SYS_POR_EL0);
> > +		/* ISB required for kernel uaccess routines when chaning POR_EL0 */
> 
> nit: typo "chaning".
> 
> But more substantially, is this just to prevent spurious faults in the
> context of a new thread using a stale value for POR_EL0?

Not just prevent faults but enforce the permissions from the new
thread's POR_EL0. The kernel may continue with a uaccess routine from
here, we can't tell.

-- 
Catalin
