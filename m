Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4322A3ED5BD
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778057917; cv=none; b=DWBQ+ruzAd1gDJFdhjFeFomiHWqYIPBESLN6A0aWobfwOU7oHNup1aDpWDeDFG8plYEh+4DjYh4e0mihuchx6oi5as2bVcadZcqO2nfrW3hU/9AYat9cZPx79uNmBNR+ddRI5SzUTGNE5iXjVmWLAQ16iat206K3Bm9Nx58uOOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778057917; c=relaxed/simple;
	bh=qmBmjzeAcJ5nql9S7tzn6aZ63xzXy+8siom1eVtABjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKlpoyK8Y6+aH35mXHL72gmEeLOA+DjblOZQokkrX5tcIW+Y6MgIslhM/9KQbxNw3Ymk5F/Snf1kSfNTGJgNQ5WOWi22hVNorv9JUr7yb9vmlgIIXCc0TuHc48r0mo29/jAvmx7e43dm6pLC6TaqUb+gU2T6zwkVNrKJrwg6ODw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WQg9q3wM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WQg9q3wM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F2AC1A25;
	Wed,  6 May 2026 01:58:27 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2E203F836;
	Wed,  6 May 2026 01:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778057913; bh=qmBmjzeAcJ5nql9S7tzn6aZ63xzXy+8siom1eVtABjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQg9q3wMZNS1Lu5L5NkIQs4DobfTcUmY2PhRDEDniXlR58HKmmfpRpdh3Aa8RmmBn
	 fJrO031dJgDWxwpzKa7fbFC5z3tMFCLuNVdeAurF7QW3BOT+hLdvJ0Oi+8wtkoAw1J
	 7KfSmYPOZnWpMoT140ilwt+hj1udjhcYEogZrObE=
Date: Wed, 6 May 2026 09:58:27 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	jarkko@kernel.org, zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 2/3] firmware: arm_ffa: initialise ff-a after
 finalising pKVM initialisation
Message-ID: <afsCs56KfpoMhPH9@e129823.arm.com>
References: <20260505095409.1948371-1-yeoreum.yun@arm.com>
 <20260505095409.1948371-3-yeoreum.yun@arm.com>
 <20260505-super-gecko-of-argument-655030@sudeepholla>
 <afoHizU8NgFWzvYW@e129823.arm.com>
 <20260505-adaptable-mussel-of-virtuosity-2751db@sudeepholla>
 <afohuFhVBIyUFEMT@e129823.arm.com>
 <20260506-warm-deer-of-energy-522bfa@sudeepholla>
 <afrygFx4OoCbbr+a@e129823.arm.com>
 <20260506-colossal-bee-of-discussion-08ac76@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506-colossal-bee-of-discussion-08ac76@sudeepholla>

> On Wed, May 06, 2026 at 08:49:20AM +0100, Yeoreum Yun wrote:
> > Hi,
> > 
> > I mean like DT node, it seems to add some "FF-A" device for this.
> > Anyway, right now as your suggestion, let me respin with platform device
> > again.
> > 
> 
> Please check my branch ffa_plat_dev [1] as I noted in the last email.
> 
> -- 
> Regards,
> Sudeep
> 
> [1] https://git.kernel.org/sudeep.holla/l/ffa_plat_dev

Sorry, I've seen this email after I sent former mail.

And since platform_driver_probe() prevents deferred probe.
I think it need to change jsut platform_driver_register()
for ffa_driver.

Thanks!

-- 
Sincerely,
Yeoreum Yun
