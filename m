Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D63FE55
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 22:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722985175; cv=none; b=XREuGD1+zEaZl72VNKQPHBLsYfTkRgEJbYsmQ9j/Rg42J8N0s6N4GueQZSiGoOejLrUizjlsRYy/HHuarA3Q60V5fIrMn5bp3tuMhcwpyvCRi09OzthUs4KPEJqmBXQONiQnx5tm7f13W6HsyVDZ039+6O2Py3e6nktCIWGBOSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722985175; c=relaxed/simple;
	bh=ds9pqJh7H9fMOWP6se75ivaqlkU29QAObaWXCWyWx9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2v5S2ftsmENYUUKLIe2LGiXChWcdt1wk71iWknbMe2Eirm4ubTxLIXTi6aG3gSobknvlhbKu1Svahb4/kTVv25xfa8UzT6YcqatOsXQUSx3P1btf0Flqg0bVAffOFn4i905U6xQaUk1OuiABPG1iUeCja5Immny+eAeWwH4/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t9OqXWrr; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t9OqXWrr"
Date: Tue, 6 Aug 2024 15:59:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722985170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czRgRDeRzLrqBrQivBvizwUbT0h+w1TNXUGWQtXg8MQ=;
	b=t9OqXWrr8NixYPqY6nc80jW99/6NeLrV2HCWr6yUBunDx7UPLELnjrVzzN4qoVfPhsxF6V
	L6OSjGitosA6JNlL/hEacVd+VrB9M1fL3dtNs6ZO646Z7Wh8G5DUU5Z+ZEnbcF90hyMc3C
	hjA1wKcVQKSff/vgqIJ2ORksr/t65Uc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Rutherford <srutherford@google.com>
Subject: Re: [PATCH 0/2] KVM: Protect vCPU's PID with a rwlock
Message-ID: <ZrKqzrPF_y4momna@linux.dev>
References: <20240802200136.329973-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802200136.329973-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 02, 2024 at 01:01:34PM -0700, Sean Christopherson wrote:
> Protect vcpu->pid with a rwlock instead of RCU, so that running a vCPU
> with a different task doesn't require a full RCU synchronization, which
> can introduce a non-trivial amount of jitter, especially on large systems.
> 
> I've had this mini-series sitting around for ~2 years, pretty much as-is.
> I could have sworn past me thought there was a flaw in using a rwlock, and
> so I never posted it, but for the life of me I can't think of any issues.
> 
> Extra eyeballs would be much appreciated.

Besides the nitpicks:

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
