Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A336F1BDC4
	for <kvmarm@lists.linux.dev>; Wed, 25 Oct 2023 08:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ipjYx7PO"
Date: Wed, 25 Oct 2023 08:25:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698222312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vVwFanUFLa3Y0XsNMbD4ttfz3IZO8tUM2EvaVKR7O1E=;
	b=ipjYx7POmr2jCZv3GijEQff2XjhT7nOE6t4JnGveCvZKoSbLaxoi5ed0p0iA31pP20ax8Y
	Jnh6ZZXF3WmxKRGdI7wOtZZVDnbDn5IOa08TwOc9qANUOObSXCBiAz5ab2Xmzd28SOBAP6
	HYSFWTPFYS34IdTLnrCZ20/rRrdYfEo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Stop printing about MMIO accesses where
 ISV==0
Message-ID: <ZTjQ43gpJUvfh6rG@linux.dev>
References: <20231024210739.1729723-1-oliver.upton@linux.dev>
 <86il6v3z6d.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86il6v3z6d.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 25, 2023 at 09:04:58AM +0100, Marc Zyngier wrote:

[...]

> While I totally agree that this *debug* statement should go, we should
> also replace it with something else.
> 
> Because when you're trying to debug a guest (or even KVM itself),
> seeing this message is a sure indication that the guest is performing
> an access outside of memory. The fact that KVM tries to handle it as
> MMIO is just an implementation artefact.
> 
> So I'd very much welcome a replacement tracepoint giving a bit more
> information, such as guest PC, IPA being accessed, load or store. With
> that, everybody wins.

Aren't we already covered by the kvm_guest_fault tracepoint? Userspace
can filter events on ESR to get the faults it cares about. I'm not
against adding another tracepoint, but in my experience kvm_guest_fault
has been rather useful for debugging any type of guest fault.

-- 
Thanks,
Oliver
