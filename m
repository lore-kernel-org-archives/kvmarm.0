Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597A927E04A
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 23:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750289101; cv=none; b=HvB7u2yBa2lzAzxBMUQ4b7f+jBlogzhgx8cqVWJ/7p1pH1IjI1NC9B/RMce8M5YJbFK6H1wgOyZsWXAo8uyPRGkgqVfuJQy5ZCyMIQ9asf21RXG8nmIyWdhEumJLzYIPFK2+5qL7NhrMc3DHp7gfuqnAvGSj3nNOBAbjOBb6Vvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750289101; c=relaxed/simple;
	bh=mpsyaZM6A/eruigZ3NSJqal62PMFICXzeTz3pckdd6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9gtL28muDXdEIsX7Poc0+DhutLEfGEBPhzW7L1ZZHwaQWkefgXOsMnrEveiWCZjgw9UgcFECTpNYQ3XXk/DpgEpkfdNnOLUOi2XHGBjPAiLjj2QtWwSniQk8Vb89mD/lS91G7ivM0LvmmyKlHlBGr4Fu29hCIUOPydWL84hODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nOQhMYcg; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nOQhMYcg"
Date: Wed, 18 Jun 2025 16:24:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750289087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qrxD2n0/TPw17Uc8nkUtK6jXpsmer9Xjurk1Z29eM00=;
	b=nOQhMYcgxS/j4foBRzM8x72Ps/2vwu3podTsW2GdwB6L5WptAFrt2zoVmkn7ZjE2CtMxwI
	Ke3zJFXq2P7kMgU6W800fjEMmLCr8l1IMicqSUwXSi5dq+M0rO/X3yznPChqY0NlwTkFdL
	Qqvfl1RmsbEX+p3fnUWdHkfvrghENe4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/15] KVM: Introduce KVM Userfault
Message-ID: <aFNKuGVWGn0dzKuV@linux.dev>
References: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 18, 2025 at 04:24:09AM +0000, James Houghton wrote:
> Hi Sean, Paolo, Oliver, + others,
> 
> Here is a v3 of KVM Userfault. Thanks for all the feedback on the v2,
> Sean. I realize it has been 6 months since the v2; I hope that isn't an
> issue.

Not one bit. The only thing I look for in patch frequency is the urgency
with which the author wants to get something in.

> I am working on the QEMU side of the changes as I get time. Let me know
> if it's important for me to send those patches out for this series to be
> merged.

It'd be good to know we have line of sight on a functional
implementation here, i.e. uffd-based handling of non-vCPU accesses. I'm
not expecting surprises here, but patches always speak louder than
words.

Don't want to block the kernel pieces if that's a time sink though. And
FWIW, besides the nitpicking I'm quite happy with the way this is
shaping up.

> Be aware that this series will have non-trivial conflicts with Fuad's
> user mapping support for guest_memfd series[1]. For example, for the
> arm64 change he is making, the newly introduced gmem_abort() would need
> to be enlightened to handle KVM Userfault exits.

Appreciate the heads up!

Thanks,
Oliver
