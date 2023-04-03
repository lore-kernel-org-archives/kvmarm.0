Received: from out-55.mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D946FA1
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 16:28:37 +0000 (UTC)
Date: Mon, 3 Apr 2023 16:28:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680539315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GvxFOZBOVWHszkoU/0TQdixWdE1wHzp9oicoxJvKafA=;
	b=uD1mFyxTDk3BHiesLPOM6j3AA7C6bsz6Z8gSyS3aa0dtLIQ07q6gnXG9cin4dbIuzXZiVV
	G52IWca0iuK72YFMblhHJN7tbOevwsBAkolPuBvlof2qOoyBpTiT1emJGasDON0ShwLgp2
	EM1aRpkjI6xJ/jBZ7GXqu+bjjJ34tdA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH v2 09/13] KVM: arm64: Indroduce support for userspace
 SMCCC filtering
Message-ID: <ZCr+rqzT9FIre8xX@linux.dev>
References: <20230330154918.4014761-1-oliver.upton@linux.dev>
 <20230330154918.4014761-10-oliver.upton@linux.dev>
 <864jq0wx7v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jq0wx7v.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 31, 2023 at 08:13:24PM +0100, Marc Zyngier wrote:
> On Thu, 30 Mar 2023 16:49:14 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> nit: typo in the subject. Also, this isn't so much about filtering,
> but forwarding.

Oops, thanks for catching the typo. If you don't mind, I'd prefer to
retain the term 'filtering', as this patch provides UAPI for _both_
forwarding and outright denying SMCCC calls.

Ack to the rest of your feedback here, I'll have it addressed in the
next spin of the series.

-- 
Thanks,
Oliver
