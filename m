Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4691C18A6B7
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 08:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728981058; cv=none; b=rGql4HPsoLs5IkPaRdBPLuXIhOdj7Mok9ApsrJW6CwksQV6jH44EuuDN1smY575ttPvKsWU+UdgAMUjEv/7aXAtfaet3GPFZ8+zOexuGB5FnmLwpDhhhaxUHseUswFeudBduCZuikqFUbAM6UtqHiVUJvCq1GlYnEWVnn8FD8sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728981058; c=relaxed/simple;
	bh=xjW+Dbg4SbbPjLiIb+obMlAVbTKZxWFh/MzGbBC+oG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFpxZfsvcFxH9nGi6CYyIdx/nxV7VzNLOuWlTAIZbIXpi3vB01+/G+NH4TfJMTtkVkGiik15rjZ96UM43xfnJ2eXNLtEmTbS90YgQskVBOIKXXJz3xehUNgkZBPHHzfA8wHK1FNFmLwuUbUTgsuJGsPf0anWtXMEG8+o7k2Q+mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZCYbrbTY; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZCYbrbTY"
Date: Tue, 15 Oct 2024 01:30:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728981053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0USN5MN6OnhhWV6JOtX0BGlRiPuogXbfPrbEhA7OD0w=;
	b=ZCYbrbTYaqPfN4Zdt0aIFeWzhr+v2wVnbL0KAQQw8+rpzbq6xSFpTFDf1n87KCtzyP/Qyq
	KJAfsyeQuA25AED/j3dzEWnlm9ut+3TBaby5+waIMYCqNvLIXvQEs0t9yCXK+9i33U8PRd
	MwsMI+Fd0Tuh96YDzuBp4GZPGVuK60w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: [PATCH v1 1/4] KVM: arm64: Move pkvm_vcpu_init_traps() to
 init_pkvm_hyp_vcpu()
Message-ID: <Zw4oOI7GzHnGjImP@linux.dev>
References: <20241014102413.4092725-1-tabba@google.com>
 <20241014102413.4092725-2-tabba@google.com>
 <Zw4byVfZngXV19ni@linux.dev>
 <CA+EHjTwLE+zpSKMMaRDNbuuBmvMJZZAFoha7hpiRuNhwgP60Ww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwLE+zpSKMMaRDNbuuBmvMJZZAFoha7hpiRuNhwgP60Ww@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 15, 2024 at 09:22:47AM +0100, Fuad Tabba wrote:
> Hi Oliver,
> 
> On Tue, 15 Oct 2024 at 08:37, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Can we instead get rid of this hypercall by implementing the one-time
> > late initialization as the comment suggests?
> 
> I'm not sure I understand. I thought this is what I'm doing in this patch...

You're more than welcome to say when I'm being a damn idiot, such as
right now :)

I've been staring at too much initialization code and forgot that the
hypervisor's view of the VM is created late and not at 'vCPU
initialization' i.e. KVM_ARM_VCPU_INIT.

> > It'd be great if the feature configuration for non-protected and
> > protected VMs is done in a similar way, and that is userspace changes to
> > the ID registers before KVM_RUN.
> >
> > So we need this sort of 'late' initialization for that behavior to work.
> 
> I think this is related to me now quite understanding the first
> comment, and by extension not sure I quite get this one.

Sorry for the noise.

-- 
Thanks,
Oliver
