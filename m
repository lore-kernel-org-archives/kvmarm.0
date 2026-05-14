Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B77D3AE193
	for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 12:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778762570; cv=none; b=U7IaQ9bSvs1xp1ue2VB0NJaawys0FdOi5iv2dDNzgyfVwwLN0EDz2C3FYQPXUZBHHl6fP21QUmZNnHa/xZL2UxlPcw+YJyO2hdvWZLYMMZv4ElGiAgp9xqm4aX074YYSXIpLFjsYmdasc5qJoDuTFnIIZmJ0uZVFrfmM9LF4LDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778762570; c=relaxed/simple;
	bh=CSZGuhEMgcVv+yjLSc1VRGD3BlRDfXMIcohRaOGnXhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTjrF8vF5VYdLtupXiyOJohTqDZnnr8TBtJRz56IKX5Mc7PUfS5Zje5jl3dshQbMZc9ovXEbkvl74kPNdtpGRCZhvv4zKplDj2dTMTL6ZCvrtAb2MjEMelpc7r5VzqVv/LmSOf/Bb2yVlu+YrkaiAYdJqTiUDOcOJzZ+5WYVKwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YLD8FxWG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YLD8FxWG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78EB8244B;
	Thu, 14 May 2026 05:42:42 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1A283F7B4;
	Thu, 14 May 2026 05:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778762567; bh=CSZGuhEMgcVv+yjLSc1VRGD3BlRDfXMIcohRaOGnXhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YLD8FxWG6lmZaF+56qA4ExHRj6gmec4W4Jy6zLkG6oqEGkL02iZdRMKmMRRZjCR0U
	 xVNyfG7Hlzpevqw0I2XS7WY265pckgOkpMzxKPGXjvD5U9THwi517swXo7gmN3Lc01
	 lO/Kf4a3JDrJykgmj9Ar3XiURm1HGddmuTvrsPkk=
Date: Thu, 14 May 2026 13:42:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Safford <david.safford@gmail.com>,
	Jonathan McDowell <noodles@earth.li>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com
Subject: Re: [PATCH] ima: debugging late_initcall_sync measurements
Message-ID: <agXDQhREKIpN7mKX@e129823.arm.com>
References: <aftIuPwNeuzc9nY1@e129823.arm.com>
 <9d1af933ef218b159762884357d127e3644dfe2c.camel@linux.ibm.com>
 <afwoDgaJxmKwOhXp@e129823.arm.com>
 <f19081f1eda19d6d1ae133d8ec93e779ab1a25e5.camel@linux.ibm.com>
 <afyIbW5cljh5ZvTL@e129823.arm.com>
 <afzwJn+5r15jFxrB@e129823.arm.com>
 <77ad49cca1acf707f4152ed3e2066b2f24c90c16.camel@linux.ibm.com>
 <af2nhZyyNaP7LM3w@e129823.arm.com>
 <2b3782398cc17ce9d355490a0c42ebce9120a9ae.camel@linux.ibm.com>
 <af3oFfdSMUglZVHa@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3oFfdSMUglZVHa@e129823.arm.com>

Hi Mimi,
> > On Fri, 2026-05-08 at 10:06 +0100, Yeoreum Yun wrote:
> > 
> > > > The kernel selftests caused the measurements between late_initcall and
> > > > late_initcall_sync.  After disabling all of the kernel selftests, there weren't
> > > > any measurements. Re-enabling the FIPS selftests on PowerVM LPAR resulted in
> > > > measurements.  (I didn't try re-enabling any of the other selftests.)
> > > > 
> > > > CONFIG_FIPS_SIGNATURE_SELFTEST=y
> > > > CONFIG_FIPS_SIGNATURE_SELFTEST_RSA=y
> > > > CONFIG_FIPS_SIGNATURE_SELFTEST_ECDSA=y
> > > 
> > > Thanks for shraring this ;)
> > > 
> > > I found the reason for those mesaurements. Those come from the
> > > request_module() and usermode-thread generates them while handling module
> > > loading request for crypto-x962(ecdsa-nist-p256).
> > > Since it's not a real kernel module,
> > > I confirmed file measurements between late_initcall and
> > > late_initcall_sync are gone for modeprobe with below change:
> > > 
> > > @@ -1246,9 +1250,14 @@ EXPORT_SYMBOL_GPL(ima_measure_critical_data);
> > >   */
> > >  static int ima_kernel_module_request(char *kmod_name)
> > >  {
> > >         if (strncmp(kmod_name, "crypto-pkcs1(rsa,", 17) == 0)
> > >                 return -EINVAL;
> > > 
> > > +       if (IS_BUILTIN(CONFIG_CRYPTO_ECDSA) &&
> > > +           (strncmp(kmod_name, "crypto-x962(ecdsa", 17) == 0))
> > > +               return -EINVAL;
> > > +
> > >         return 0;
> > >  }
> > > 
> > >  Though this is the only request_module() call between
> > >  late_initcall and late_initcall_sync, but I also confirmed there're
> > >  request_modules() call before ima initalisation before "late_initcall":
> > > 
> > > /*
> > >  * NOTE: kmod_name is printed on ima_kernel_module_request()
> > >  */
> > > 
> > > // This is called from module_init(stm_core_init) -> device_initcall()
> > > // which is in driver/hwtracing/stm/core.c (built-in)
> > > [    1.421986] ima: kmod_name: stm_p_basic
> > > ...
> > > [    1.444900] ima: kmod_name: crypto-pkcs1(rsa,sha512)
> > > [    1.444903] ima: kmod_name: crypto-pkcs1(rsa,sha512)-all
> > > ...
> > > [    1.452029] ima: kmod_name: crypto-cbc(aes)
> > > [    1.465321] ima: kmod_name: crypto-cbc(aes)-all
> > > ...
> > > [    1.467845] Key type encrypted registered
> > > [    1.467848] AppArmor: AppArmor sha256 policy hashing enabled
> > > 
> > >  // IMA is initailised at late_initcall level.
> > > [    1.467850] ima: [init_ima_late:1336]
> > > 
> > > If IMA should care request_module() from kernel before IMA init,
> > > I think there is no way to solve except queuing those events
> > > (kernel_load_data/kernel_load_post_data and open for module binary etc.)
> > > though it breaks "measure before use" principle since IMA couldn't
> > > measure at that time.
> > > 
> > > But if you don't care about those things -- some events happend before
> > > IMA init, I think your suggestion -- controlling the init time of ima_init()
> > > via a Kconfig option is good and ignoring some usermodehelper request
> > > including request_module() before IMA initialisation upto user by that option.
> > 
> > Thank you for the complete analysis.  The early measurements before the TPM is
> > initialized is a problem that needs to be addressed.  As to whether the solution
> > will require queueing is yet to be determined. (Roberto has some thoughts on
> > addressing it.) This discussion makes it clear that simply delaying IMA
> > initialization by moving it from late_initcall to late_initcall_sync could miss
> > measurements.  That said, exposing it as an opt-in Kconfig for those who accept
> > the risk is a sensible pragmatic compromise.
> 
> I think once we address ealry measurements before intialising TPM,
> It doesn't matter when IMA is initialissed since they're considered as
> ealry measurements anyway.
> 
> BTW, I'm not sure whether we should take pragmatic compromise first to
> support deferred TPM initialisation or solving it together via solution
> of ealry measurements (whatever it is) in now.

I wonder what's going on for discussion to resolve these problem:
  1) measurement event (via file operation)  before IMA initialisation.
  2) deferred TPM device initailisation and IMA.

Might someone could think it wouldn't be a problem since initrd is
measuared in PCR9 by boot loader (e.x) grub, but it still has a problem
for the case uses root= boot option where it doesn't use initrd
but use specified block dev with a filesystem.

I think soluation would be determined whether IMA neglects the
measurement event before its initialisation or not in current state:

  a) Case for neglecting measurement event before IMA initailisation.

    In this case, As you suggeested, IMA initialisation should be
    determined by build config whether it initialises at late_initcall
    or late_initcall_sync so that make user can choice upto their
    platform.

  b) Case for considering measurement event event before IMA
     initialisation.

    I couldn't image any other solution except queuing those event
    and extend them after generating boot_aggregate log and if those
    event can be queued, it wouldn't a problem to move IMA initialisation
    to late_initcall_sync.

But you mention there are some thoughts from Roberto, might there was
some discussion with him. If you don't mind, would you let me know
how the discussion is going on and your thought to fix this all?

Thanks!

-- 
Sincerely,
Yeoreum Yun
