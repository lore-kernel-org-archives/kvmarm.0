Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213884DF4B5;
	Fri, 25 Sep 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790354589; cv=none; b=lMFP6CaPKl/sUKtE2ER/B2OT2RN7vBOH+odiK8ElIgQKeYY0KFniFLjMVtonfWSPEtVKM/DfjNtFRshdGtFIUdvZF5NKUuMLpp/+g4PDjpvZ+CUt6grNt0q9SeKRU+OScEzW+5JEa4fZXCeDeuBM6DjKa3RJUZ9EwBAAiByOsjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790354589; c=relaxed/simple;
	bh=O5sbNKI/8hIC1rgKBOybPs1hHlK7ry3JZUBZbb/JU/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPbme+uuoHEnIu4e8TclgfoPy8dRbV2XvcwLChXAxZT1Ce5tOxKKrk00QqvazEnw1WPczKcNt4eQtZU6ZXZQToDkfmtSrBr8XERAs7riR7tMQrlVDNXCVNC1V5imVAJOCVuT8bC2RuwlI8TKJoSzykehsNMJpYheaqbVQLMnKrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hVf2XdSc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hVf2XdSc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F19A169C;
	Fri, 25 Sep 2026 09:42:36 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B87E3F86F;
	Fri, 25 Sep 2026 09:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790354559; bh=O5sbNKI/8hIC1rgKBOybPs1hHlK7ry3JZUBZbb/JU/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hVf2XdScH/58yUk45BIMnxm19IlI7CCdS1+PH4A3lE0oPIlF/VnruTYA9tdwfB++q
	 tPALc4GdmxDZeRm3O69AumG5nuzFw10fti+WPdDM8P/WWPcR06/EG2TuL4kXguw8FS
	 tOxXhZwLUBa3ggNoDVUh/E34iEH5FW3oavECMG3c=
Date: Fri, 25 Sep 2026 17:42:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
Message-ID: <araketG70TIKeNuf@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-6-suzuki.poulose@arm.com>
 <arZmXFw5Jw2IbAmA@arm.com>
 <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>

On Fri, Sep 25, 2026 at 04:02:24PM +0100, Suzuki K Poulose wrote:
> On 25/09/2026 13:17, Catalin Marinas wrote:
> > On Thu, Sep 24, 2026 at 02:51:59PM +0100, Suzuki K Poulose wrote:
> > > From: Steven Price <steven.price@arm.com>
> > > 
> > > Activate the RMM after the basic configuration. This is a memory
> > > transferring stateful operation.
> > > 
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > ---
> > > Changes since v17:
> > >   * Inline RMM_ACTIVATE command and remove the definitions from arm-rmi-cmds.h
> > >   * Use scope-based cleanup to free sro object
> > > Changes since v16:
> > >   * Split into a new patch
> > > ---
> > >   drivers/firmware/arm_rmm/rmi.c | 13 ++++++++++++-
> > >   1 file changed, 12 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> > > index 035f21d3f26b6..0859f256e192b 100644
> > > --- a/drivers/firmware/arm_rmm/rmi.c
> > > +++ b/drivers/firmware/arm_rmm/rmi.c
> > > @@ -834,7 +834,18 @@ static int __init arm64_init_rmi(void)
> > >   	if (ret)
> > >   		return ret;
> > > -	return 0;
> > > +	/* Activate the RMM */
> > > +	struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);
> > > +	if (!sro)
> > > +		return -ENOMEM;
> > > +
> > > +	ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
> > > +	if (ret) {
> > > +		pr_err("RMM activate failed (%d)\n", ret);
> > > +		ret = ret < 0 ? ret : -ENXIO;
> > > +	}
> > > +
> > > +	return ret;
> > 
> > It was raised earlier this year [1] but I'm not sure it concluded. How
> > do we handle kexec and kdump? I think RMI_RMM_DEACTIVATE only succeeds
> > if nothing is delegated, so it would need all realms torn down first. If
> > that's not feasible, we could at least block (non-crash) kexec like pKVM
> > does.
> 
> You are right, we can't DEACTIVATE until all granules have been
> "undelegated" back. Not just the Realms, but also the GPTs/Tracking
> Metadata etc would need to be reclaimed (when we get to support
> dynamic GPT/Tracking metadata). For now, we should block the kexec.

Looking more into this (and the memory hotplug story), I find it strange
that simply having RME and a valid RMM imposes all these restrictions
even if we never run or intend to run a realm. How common will
RME-capable systems with RMM firmware be that are not used for CoCo? Or
do we expect only CoCo systems to have capable/configured firmware (RME
may be present in silicon anyway)?

Ideally we'd defer the RMM configuration and activation (and the
tracking/GPT checks) until we first attempt to start a realm, keeping
only the RMI_VERSION/FEATURES probing at boot. Not sure how feasible
this is (memory is more fragmented by then for any contiguous donation).
If we manage it, kexec and memory hotplug just work on hosts that never
start a realm.

The next best thing for kexec is to tear down the realms, undelegate
the granules and deactivate the RMM before invoking kexec (with kdump
that's harder as we likely no longer have a controlled shutdown).

Similarly with memory hotplug, allow it if we haven't started any realms
and refuse realm creation afterwards if untracked memory was onlined.
Also, if the memory is onlined to ZONE_MOVABLE, neither guest_memfd nor
the kernel allocations we delegate come from there, so we could allow
it even with realms running.

> > Kdump gets even more interesting if it starts accessing delegated pages
> > and getting GPF.
> > 
> > [1] https://lore.kernel.org/r/CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com
> 
> Kdump may be a bit more easier, as the kdump kernel is supposed to use
> the "reserved" region and vmcore access could handle the GPF and
> provide "0"s to the reader ? May be this is one case where the
> host needs to be able to handle GPFs.

Yes, I think so. I now realised that metadata delegation to the RMM
doesn't come from guest_memfd, so that's another case not helped by the
old series to unmap guest_memfd from the linear map. I'll reply to the
GPF thread.

-- 
Catalin
