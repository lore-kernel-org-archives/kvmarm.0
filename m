Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F13284883
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776775825; cv=none; b=mRZeKQhdfcddKhqrqJKsPckjoyvPXBOGDRfYl8l5Wnjdm1VrjK05nred6ZeMPGQRRVkmH+KI/74U4SJHJ/04p/KbJin7h6tSPt7z0PoGFDkKbykt1w8raumEmFc9lfNpdk+NWnARACafdMmIQVrT8bDhC39e2wVhTAQX3GcTNOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776775825; c=relaxed/simple;
	bh=MIBNdfn2tTRK5iTJfoWsKX9aUYA34uCXEBimixXhsiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRQGs1rYi3G4ElLdonn10YulWeAAwSA2/1VMQ3gqHeeT+y2U10gMDTv9uu+RMFybCDDzAxJn8n0lULKI2CaTc94yp8LkqjlJxPW5Ep34yKBeZyVdgK0HsPN4iQBUGNWUYDXL1E8/yxNFrh8TiMpAHRD7K5spRgGzLsn4TyOy1RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S+rH//yE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S+rH//yE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0685F2454;
	Tue, 21 Apr 2026 05:50:16 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A3013FE76;
	Tue, 21 Apr 2026 05:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776775821; bh=MIBNdfn2tTRK5iTJfoWsKX9aUYA34uCXEBimixXhsiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S+rH//yEb9awLsr3u7V247G6FaCBB1GziF7HlaD/iWBJd4BSks2CbYdDNqX2gTOiU
	 Zje7bwvTfSh7N5Nhxmxwc7e/Dx85jW0hrMVKWxEohJorUob8GlZWwnKmKNvI/RpnOG
	 mZsj8F52vSUnbYpj3LuQvU5NT6UcCZ364QN5Hk9A=
Date: Tue, 21 Apr 2026 13:50:15 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com, peterhuewe@gmx.de, jarkko@kernel.org,
	jgg@ziepe.ca, sudeep.holla@kernel.org, maz@kernel.org,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 1/4] security: ima: move ima_init into
 late_initcall_sync
Message-ID: <aedyh61iTnQRyzMv@e129823.arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-2-yeoreum.yun@arm.com>
 <a6a0e15286c983d720de227c6827adbe976c5b9b.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a6a0e15286c983d720de227c6827adbe976c5b9b.camel@linux.ibm.com>

Hi Mimi,

> On Fri, 2026-04-17 at 18:57 +0100, Yeoreum Yun wrote:
> > To generate the boot_aggregate log in the IMA subsystem with TPM PCR values,
> > the TPM driver must be built as built-in and
> > must be probed before the IMA subsystem is initialized.
> >
> > However, when the TPM device operates over the FF-A protocol using
> > the CRB interface, probing fails and returns -EPROBE_DEFER if
> > the tpm_crb_ffa device — an FF-A device that provides the communication
> > interface to the tpm_crb driver — has not yet been probed.
> >
> > To ensure the TPM device operating over the FF-A protocol with
> > the CRB interface is probed before IMA initialization,
> > the following conditions must be met:
> >
> >    1. The corresponding ffa_device must be registered,
> >       which is done via ffa_init().
> >
> >    2. The tpm_crb_driver must successfully probe this device via
> >       tpm_crb_ffa_init().
> >
> >    3. The tpm_crb driver using CRB over FF-A can then
> >       be probed successfully. (See crb_acpi_add() and
> >       tpm_crb_ffa_init() for reference.)
> >
> > Unfortunately, ffa_init(), tpm_crb_ffa_init(), and crb_acpi_driver_init() are
> > all registered with device_initcall, which means crb_acpi_driver_init() may
> > be invoked before ffa_init() and tpm_crb_ffa_init() are completed.
> >
> > When this occurs, probing the TPM device is deferred.
> > However, the deferred probe can happen after the IMA subsystem
> > has already been initialized, since IMA initialization is performed
> > during late_initcall, and deferred_probe_initcall() is performed
> > at the same level.
> >
> > To resolve this, move ima_init() into late_inicall_sync level
> > so that let IMA not miss TPM PCR value when generating boot_aggregate
> > log though TPM device presents in the system.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>
> IMA should be initialized as early as possible. I'm really hesitant to defer
> ima_init() to late_initcall_sync() for systems that the TPM is currently
> initialized in time. For these systems, continue initializing IMA at
> late_initcall(). As a compromise for those systems that the TPM isn't properly
> initialized in time, define and instantiate the late_initcall_sync().
>
> ima_init() would need to differentiate between the late_initcall and
> late_initcall_sync.  On late_initcall(), instead of saying "No TPM chip found,
> activating TPM-bypass!",  it should say "No TPM chip found, deferring to
> late_initcall_sync" or something similar.

But can we really move those initialisations to be called again?

I am referring to functions such as ima_init_crypto(),
ima_add_boot_aggregate(), and ima_measure_critical_data() in ima_init()—
first without TPM, and then a second time once TPM becomes available.
I don’t think that approach would work.

In other words, unless tpm_default_chip() can differentiate between a TPM
device that is deferred and one that does not exist, we cannot distinguish
between the “defer” case and “-EEXIST”.

It might be possible if the TPM core tracked the state when a driver returns
-EPROBE_DEFER, but I am not sure that is the right approach.
For deferred probe cases, the “device initialised in time” check should
likely be done at late_initcall_sync, rather than late_initcall.

This implies that any such check performed before late_initcall_sync
does not reflect a valid state, as it cannot distinguish between “not
present” and “deferred”.

Therefore, I think the TPM check in IMA should be performed at
late_initcall_sync.


Am I missing something?

Thanks.

>
> > ---
> >  include/linux/lsm_hooks.h         |  2 ++
> >  security/integrity/ima/ima_main.c |  2 +-
> >  security/lsm_init.c               | 13 +++++++++++--
> >  3 files changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> > index d48bf0ad26f4..88fe105b7f00 100644
> > --- a/include/linux/lsm_hooks.h
> > +++ b/include/linux/lsm_hooks.h
> > @@ -166,6 +166,7 @@ enum lsm_order {
> >   * @initcall_fs: LSM callback for fs_initcall setup, optional
> >   * @initcall_device: LSM callback for device_initcall() setup, optional
> >   * @initcall_late: LSM callback for late_initcall() setup, optional
> > + * @initcall_late_sync: LSM callback for late_initcall_sync() setup, optional
> >   */
> >  struct lsm_info {
> >  	const struct lsm_id *id;
> > @@ -181,6 +182,7 @@ struct lsm_info {
> >  	int (*initcall_fs)(void);
> >  	int (*initcall_device)(void);
> >  	int (*initcall_late)(void);
> > +	int (*initcall_late_sync)(void);
> >  };
> >
> >  #define DEFINE_LSM(lsm)							\
> > diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> > index 1d6229b156fb..ace280fa3212 100644
> > --- a/security/integrity/ima/ima_main.c
> > +++ b/security/integrity/ima/ima_main.c
> > @@ -1320,5 +1320,5 @@ DEFINE_LSM(ima) = {
> >  	.order = LSM_ORDER_LAST,
> >  	.blobs = &ima_blob_sizes,
> >  	/* Start IMA after the TPM is available */
> > -	.initcall_late = init_ima,
> > +	.initcall_late_sync = init_ima,
> >  };
> > diff --git a/security/lsm_init.c b/security/lsm_init.c
> > index 573e2a7250c4..4e5c59beb82a 100644
> > --- a/security/lsm_init.c
> > +++ b/security/lsm_init.c
> > @@ -547,13 +547,22 @@ device_initcall(security_initcall_device);
> >   * security_initcall_late - Run the LSM late initcalls
> >   */
> >  static int __init security_initcall_late(void)
> > +{
> > +	return lsm_initcall(late);
> > +}
> > +late_initcall(security_initcall_late);
> > +
> > +/**
> > + * security_initcall_late_sync - Run the LSM late initcalls sync
> > + */
> > +static int __init security_initcall_late_sync(void)
> >  {
> >  	int rc;
> >
> > -	rc = lsm_initcall(late);
> > +	rc = lsm_initcall(late_sync);
> >  	lsm_pr_dbg("all enabled LSMs fully activated\n");
> >  	call_blocking_lsm_notifier(LSM_STARTED_ALL, NULL);
> >
> >  	return rc;
> >  }
> > -late_initcall(security_initcall_late);
> > +late_initcall_sync(security_initcall_late_sync);
> > --
> > LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> >

--
Sincerely,
Yeoreum Yun
