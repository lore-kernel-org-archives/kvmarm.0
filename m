Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411169;
	b=sdHtIM6N6lu0a19Pi7K59Ff+1x7lJ3vBx1F4ejcj6dF5hIqWgPmgmYRfLc9eNd7QyWmw
	 qCkVRo24s1m0CJ+0k1P5fPR/voLkMXDdqm/qd++JcGdhfCU6r1EFz+aT8qkRC7Ha0j1lD
	 pHS9YMoiEMaH9FmHVnpOMDJ0sp5dcl45AYs2AYKRZx1k/8IwgutHaieI5eldH1gBeWcqG
	 +uAUoruRCtMZlbx/SlazRFZAw9UpZwr02GcRi5XkF8VPV6RyXZbkZYPqUlc2oxbKFcpIR
	 J3Uv1ojpibxRaxVN53TKuiSeVTYLIjzy8BU9I+wzuv4OTcafvS9AXAbUI3EpMXTaMAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411169;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=EXB+uPBraiEi9Fxzrb/OQqOcGOpyOCq3/nVjFHtbk7k=;
	b=2MomwPecvVuox91XL6obegdQjdhQV3WX57PkzhwU9zbIAkFTd2nF26K36wG/0mDwtB6D
	 ZnN/PX7b3PM5jEZf/uoL5K9v+OP06XuT9YMX7323G696/4uDo+dx43fgjl3t34cJj09Tj
	 d2ZoAUE2BOl6yYYctEIB98i6lFh1zgFclV8Fn2LHfJWS9XhSgzsarafFZPXP7TVXaxPdn
	 XeSiH+YKmzHiVmQhUKMr1ZqJYA35J1Fzz7sXl104auDpxTKA8EsaP8SttUAkAbAXt6izg
	 lhPIxekL/TfopNkKJr8eKy5aEoZ7UKj2mZdswW5XXplx/xTwar+cP8QBun1YtIIke7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sIRMzQ6h;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B97606A337;
	Wed, 11 Nov 2026 15:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0B97606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sIRMzQ6h
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E8261576;
	Wed, 11 Nov 2026 07:32:45 -0800 (PST)
Received: from e142392.arm.com (e142392.arm.com [10.2.213.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E6603F632;
	Wed, 11 Nov 2026 07:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794411168; bh=qZRo/y/SL8f1h9sIl4GD34baEFZgFt2Hfr13Sg12NeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sIRMzQ6hL/XQ8RhWLuNf2erE2aN2p/mc9YmJSvqY5dRfoZ8KtrC7Kqde7O5/nksLn
	 ezwzT1L3VMW8YFxb7E8xPg9IbMbE5y+8wFE4w1EApOrVwjNYmeeTThw+6JwZg4+rEs
	 ywN6floPvxAVhDUaXUt88N9pPWe1dVR/j4hN2UMY=
Date: Wed, 11 Nov 2026 15:32:38 +0000
From: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev
Subject: Re: [RFC 05/12] ACPICA: Add TLBI table definition
Message-ID: <fqiztye7frn6z2ltr4tm2l2bkdrdr7atg67pim4f43xloiuydx@4yqzybdjgtcg>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-6-kristina.martsenko@arm.com>
 <20261001115614.82F9F1F0089A@smtp.kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001115614.82F9F1F0089A@smtp.kernel.org>

On Thu, Oct 01, 2026 at 11:56:14AM +0000, sashiko-bot@kernel.org wrote:
> > diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
> > index baef525367b5c..68849c9f7cf69 100644
> > --- a/include/acpi/actbl2.h
> > +++ b/include/acpi/actbl2.h
> > @@ -61,6 +61,7 @@
> >  #define ACPI_SIG_SVKL           "SVKL"	/* Storage Volume Key Location Table */
> >  #define ACPI_SIG_SWFT           "SWFT"	/* SoundWire File Table */
> >  #define ACPI_SIG_TDEL           "TDEL"	/* TD Event Log Table */
> > +#define ACPI_SIG_TLBI           "TLBI"	/* TLB Invalidate Domain Table */
>                                    ^^^^
> 
> [Severity: Medium]
> Is it appropriate to introduce a draft, non-final table signature directly into
> the global upstream-maintained acpica headers?
> 
> The commit message explicitly notes this patch should not be merged as is
> because the TLBI table description is not yet public and may change. Merging
> draft specifications creates a risk of dead uapi and compatibility issues if
> the final specification differs.

The commit message already states that this patch is not yet part of
ACPICA and should not be merged. There is nothing to change.

> > @@ -3701,6 +3702,37 @@ struct acpi_table_tdel {
> >  	u64 log_area_start_address;
> >  };
> >  
> > +/*******************************************************************************
> > + *
> > + * TLBI - TLBI Domain Table
> > + *
> > + ******************************************************************************/
> > +
> > +struct acpi_table_tlbi {
> > +	struct acpi_table_header header;
> > +	u32 domain_count;
> > +	u32 domains_offset;
> > +};
> 
> [Severity: Medium]
> Is it acceptable to add a Linux-specific out-of-tree structure definition to an
> upstream-maintained acpica file?
> 
> The acpica headers are maintained upstream, and Linux kernel policy typically
> requires changes to first be accepted by the acpica project before being synced
> to the Linux tree.

Same as above.

> commit cb4c50a2ac546f3127893846943d61a1ea5cc49e
> Author: Kristina Martšenko <kristina.martsenko@arm.com>
> 
> KVM: arm64: Hide TLBID from guest sysregs
> 
> This commit hides TLBID system registers and fields from the guest to prevent
> them from discovering domains. It reports the feature as unsupported and
> sanitizes a nested hypervisor's HCRX register bits.
> 
> >   * Sanitize a nested hypervisor's HCRX.{VTLBIDEn,VTLBIDOSEn,FNB}.
> 
> [Severity: Medium]
> The commit message claims to sanitize the guest's HCRX_EL2.FNB bit, but it
> appears HCRX_EL2_FNB is omitted from NV_HCRX_GUEST_EXCLUDE:
> 
> arch/arm64/kvm/hyp/include/hyp/switch.h:
> #define NV_HCRX_GUEST_EXCLUDE	(HCRX_EL2_TMEA	    | HCRX_EL2_PTTWI	| \
> 				 HCRX_EL2_EnIDCP128 | HCRX_EL2_VTLBIDEn	| \
> 				 HCRX_EL2_VTLBIDOSEn)
> 
> Because HCRX_EL2 is a VNCR-backed register, a nested guest hypervisor (L1) can
> write to it directly in memory without trapping. During context switch, KVM
> reads the guest's HCRX_EL2 from the VNCR page and masks it with
> ~NV_HCRX_GUEST_EXCLUDE.
> 
> Since FNB is not excluded, will KVM apply the guest's FNB bit to the physical
> HCRX_EL2 register, breaking the virtualization boundary?
> 
> The impact appears to be limited to the guest's own TLBI coherence.

No, the FNB bit is sanitized in __vcpu_sys_reg() as a result of this change:

+	NEEDS_FEAT(HCRX_EL2_FNB			|
+		   HCRX_EL2_VTLBIDOSEn		|
+		   HCRX_EL2_VTLBIDEn,
+		   FEAT_TLBID),

Thanks,
Kristina
