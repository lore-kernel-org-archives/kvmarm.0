Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7848C1388
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477818; cv=none; b=gEJrbjNo7qtl7hNrcQvlKniVwFHmKnoNzDO7b181aF/z7OmNxF0yeT+4hTZg26V3qy4+s3SSCiGh5mQlbHYBLrwOSUxX7ax7Il14cf3Vc5qddb5kxMeVyUsF0dAFIEoZWzcLz7c6G9RJiP5m10gUnnM8TETB97wHRdSSjmR6/gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477818; c=relaxed/simple;
	bh=q4Pf8REeDn6zPTgEzQOUqXBRXxifB7GsTjoQ5IovxH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kriSB58IiNm9dPyuR8+k51bylojmmAu5U88VYqulokCGzyh6dyH6LzvhB39Gm5EC4xTytqZOFB0ciPFax88FbBzqFSYI5K/NtsmVEIavwWh6IK7uZXroe4AMQyfVjSGL+BboM0kBQkox9/nOyY2MWSSEsLvY04JJSxphtHqDto4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RidQTXaN; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RidQTXaN"
Date: Thu, 20 Mar 2025 06:36:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742477814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J+7q4ucTkuxZ/GIsXuSXHu6HY+R+I2RGDBlvs6omtoI=;
	b=RidQTXaNn9Rmb4iNyV0F1FcL7J/EEsQvs4Z6jG7mX6put9gPxJ9/l3dpv8DpKPFCbxb9kw
	iKEXkLwp6JGXPXJYa254lXH0lTxH2sUlHXF3kLpP9ziWGkq+2n/ENagwy0EedbHtPk0WOp
	215TvQ4sNpkg0+t1glN8329Ze+CjFaQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Akihiko Odaki <akihiko.odaki@daynix.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.15
Message-ID: <Z9wZ8EuChPyJ6PiK@linux.dev>
References: <Z9uZpZKfqWP8ZwH8@linux.dev>
 <86ecyrn9hf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ecyrn9hf.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Thu, Mar 20, 2025 at 12:59:40PM +0000, Marc Zyngier wrote:
> Paolo,
> 
> On Thu, 20 Mar 2025 04:29:25 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hi Paolo,
> > 
> > Here's the latest pile o' patches for 6.15. The pull is based on a later
> > -rc than I usually aim for to handle some conflicts with fixes that went
> > in 6.14, but all of these patches have had exposure in -next for a good
> > while.
> > 
> > There was a small conflict with the arm perf tree, which was addressed
> > by Will pulling a prefix of the M1 PMU branch:
> > 
> >   https://lore.kernel.org/linux-next/20250312201853.0d75d9fe@canb.auug.org.au/
> 
> When you merge this, please also apply the patch below to address a
> mismerge issue caught by Stephen, which causes a build breakage.

The kvmarm-6.15 tag is fine, I caught this immediately when I was doing
testing for the pull request but forgot to push the fix to /next in
addition to the tag.

Fixing that right now.

Thanks,
Oliver
