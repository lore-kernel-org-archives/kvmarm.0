Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D82F2914
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758139100; cv=none; b=bWvUiydPqqXWb+atemXQFXJhfXxLIjGYhHPlmanOcME/FhQ+RKNMB2lN+LpJaOCniCxA0TY3r01y5R7CwsITBhCSnBaN7pUnId3aNwukrDLsyqM2NMH0ghR5z3j7HHSFrh4RBB+Z+m02aXFTMvmNHNTDqc+tOkR2zxwiUovtGB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758139100; c=relaxed/simple;
	bh=++K/PDu6ONEBVfix9bUP26opRV7k3zTICh/JJM19N6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNYvOZNdJo4G3w+5fc2Ul9usjci8becnWRmj0LCI6KgXyR91NL7qwDcTTuYeu5LXSXFBlLbH7WtGJmXe/iRYP3b7JxvumVe72mvKQDU+VWFly+3LIn5VieYBjqD6NIJsDtQzjA5w5md61wMDpL5KIIh6kUpzxXsnmD79kQhgL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dgSwnH+4; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dgSwnH+4"
Date: Wed, 17 Sep 2025 12:58:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758139094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=axLM7SM1M1gPLHiJS2eIg7jyFvifPlO5uWh3xMQYZJo=;
	b=dgSwnH+4+f66Ikzk19q0rR8cQttfhSzJBLlDvZVLXoIeeIYeyUrkcu6d0szkPvlao4PIIH
	T4ziSwS062uU2fW0RG+BF4CPQC05hTjfFywCMS5aCLAabZ7z+U26nouF+8Zk9ay2nIJit3
	DdUFC2UC4FyQ0BbtOpjEcfOILkuhTeg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 changes for 6.17, round #3
Message-ID: <aMsSz9YUcd4Qf0ND@linux.dev>
References: <aMHepH8Md9gSu2ix@linux.dev>
 <6e598aec-f55c-467a-abef-6d183bb9cfca@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e598aec-f55c-467a-abef-6d183bb9cfca@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 17, 2025 at 07:56:15PM +0200, Paolo Bonzini wrote:
> On 9/10/25 22:25, Oliver Upton wrote:
> > Hi Paolo,
> > 
> > This is most likely the final set of KVM/arm64 fixes for 6.17.
> > 
> > Of note, I reverted a couple of fixes we took in 6.17 for RCU stalls when
> > destroying a stage-2 page table. There appears to be some nasty refcounting /
> > UAF issues lurking in those patches and the band-aid we tried to apply didn't
> > hold.
> 
> Thanks for pointing this out, I will put a note about reverts in my own tag.

Appreciated, seems to have been an unintentional omission from my own
tag.

Best,
Oliver
