Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5C11A5BBA
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 19:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742326263; cv=none; b=JbIVnRwdQJTCvlbFpg9WxVXXZ+DHdAOXIY+s7vuae31lwY5SUp+Ft3ahUehdggY6H9GGk702ESw7WOyeWOiZPrq4xzkVlYo/vf/ip+doAbtAqbhkCo0CSDNaid/o8CxSGgOahghV1oPoAlxI/QnJGhWUqK6wc87uT2sQHtOspUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742326263; c=relaxed/simple;
	bh=A1LZSMurMCw7XAEPCH04A8KrfnT4c+AjtIzus6XHTkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liLdjUciYEExQg38/rSxzMLXOjiY1XC8FB+DruGohj0TmW5fsQHd/AaYLXpzDhdkgqFjOZe0ECqtWXwMUSfzD/q7ubIZ+vqCi/u7u7CKrHsb6WX8aRL39tLelnVbWWTIAV+B70HYcFI3kYNQai0fG4MvYgwK9z1wHGt217R8HdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WlqGmwDR; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WlqGmwDR"
Date: Tue, 18 Mar 2025 12:30:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742326258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uLREQAcpdVHD+RUaVABJCrC10uCF6Ks8siHlbc6H7tA=;
	b=WlqGmwDRsO1UUaFH9yUFZMy9CfFkpAGDcne5CiOP+6AA+Wo4pYhnbYm0Jb+DsRO9k71Yyn
	IHIuNY1g+eEMFvWMGhToC1muOIENThRa98bhSmT6/woLCNYhIla68ON0lImFdZpbLorZ6K
	kCanSbMELDemVUArW689c91yyMrEQ14=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <Z9nJ42PllG8a7AY7@linux.dev>
References: <861pv5p0c3.wl-maz@kernel.org>
 <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318125527.GP9311@nvidia.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 09:55:27AM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 18, 2025 at 09:39:30AM +0000, Marc Zyngier wrote:
> 
> > The memslot must also be created with a new flag ((2c) in the taxonomy
> > above) that carries the "Please map VM_PFNMAP VMAs as cacheable". This
> > flag is only allowed if (1) is valid.
> > 
> > This results in the following behaviours:
> > 
> > - If the VMM creates the memslot with the cacheable attribute without
> >   (1) being advertised, we fail.
> > 
> > - If the VMM creates the memslot without the cacheable attribute, we
> >   map as NC, as it is today.
> 
> Is that OK though?
> 
> Now we have the MM page tables mapping this memory as cachable but KVM
> and the guest is accessing it as non-cached.
> 
> I thought ARM tried hard to avoid creating such mismatches? This is
> why the pgprot flags were used to drive this, not an opt-in flag. To
> prevent userspace from forcing a mismatch.

It's far more problematic the other way around, e.g. the host knows that
something needs a Device-* attribute and the VM has done something
cacheable. The endpoint for that PA could, for example, fall over when
lines pulled in by the guest are written back, which of course can't
always be traced back to the offending VM.

OTOH, if the host knows that a PA is cacheable and the guest does
something non-cacheable, you 'just' have to deal with the usual
mismatched attributes problem as laid out in the ARM ARM.

> > What this doesn't do is *automatically* decide for the VMM what
> > attributes to use. The VMM must know what it is doing, and only
> > provide the memslot flag when appropriate. Doing otherwise may eat
> > your data and/or take the machine down (cacheable mapping on a device
> > can be great fun).
> 
> Again, this is why we followed the VMA flags. The thing creating the
> VMA already made this safety determination when it set pgprot
> cachable. We should not allow KVM to randomly make any PGPROT
> cachable!

That doesn't seem to be the suggestion.

Userspace should be stating intentions on the memslot with the sort of
mapping that it wants to create, and a memslot flag to say "I allow
cacheable mappings" seems to fit the bill.

Then we have:

 - Memslot creation fails for any PFNMAP slot with the flag set &&
   !FEAT_FWB

 - Stage-2 faults fail (exit to userspace) if the above conditions are
   not met

 - Stage-2 faults serviced w/ a cacheable mapping if the precondition is
   satisfied and pgprot on the VMA is cacheable

 - Stage-2 faults serviced w/ a non-cacheable mapping if flag is not
   set

Seems workable + would prevent KVM from being excessively permissive?

Thanks,
Oliver
