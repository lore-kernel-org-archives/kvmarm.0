Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4714379927
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709582419; cv=none; b=Bd52a3069DDkqq1ZsR8xPdH7p9k4sbqPEPRatBKSncDLHxVBol4vkLCyL2rQ/nNm2UwwS5bOeu2mjo0xtNQsKFlCY2amAk9TQhSUYcG/AGvCcO1A0QikRdInQmRBhmYJUpQ+g3jpJph9lQ+g+I5wSrOCKVECrCeMmkEKoX5j2WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709582419; c=relaxed/simple;
	bh=PwswC2QLgrfGkqvGJv5hVy5xAgaXNLvrQ1PnKfrapGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlWXz0QHX5GHy/Gy8yDzFJcmjPEw6IQIgFw1GM3Kwg5kVvUZjklTYcKa9GyDbDtY3yZy4nYBhTL0Ai1GLKgSTYA1wOaP7uHtCwOz3p/uKDpqQU0oiYxLtlTmesEL8E5U0+Tp7iV5/ccQVyKoQGs7kMHsuT28BzwPQ/GQGwNAm4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xCtRhKDX; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xCtRhKDX"
Date: Mon, 4 Mar 2024 20:00:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709582415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XxJdQM9M8oSJx2poffbncc5kqBv+MVDtqlApqur8M/Q=;
	b=xCtRhKDXkGmhyRTyD7OJzgZUEK3tlqvB6S5yysaKAkG8DWMPf2NiHcf1f4oLoQinspRh0d
	hEuhzXeXZBnkGIBAag+W0QAyxwW2AvlMdB7Y1QunewULzkMjxHPh0Ebbbvz6qnc8tKpdZd
	hbixfhz+jID8YGZM8gWc05QrPcOlw/I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com,
	jthoughton@google.com, dmatlack@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
 and annotate fault in the stage-2 fault handler
Message-ID: <ZeYoSSYtDxKma-gg@linux.dev>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-9-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215235405.368539-9-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 11:53:59PM +0000, Anish Moorthy wrote:

[...]

> +	if (is_error_noslot_pfn(pfn)) {
> +		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
> +					      write_fault, exec_fault, false);

Hmm... Reinterpreting the fault context into something that wants to be
arch-neutral might make this a bit difficult for userspace to
understand.

The CPU can take an instruction abort on an S1PTW due to missing write
permissions, i.e. hardware cannot write to the stage-1 descriptor for an
AF or DBM update. In this case HPFAR points to the IPA of the stage-1
descriptor that took the fault, not the target page.

It would seem this gets expressed to userspace as an intent to write and
execute on the stage-1 page tables, no?

-- 
Thanks,
Oliver
