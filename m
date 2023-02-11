Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC95B7F4
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 00:56:55 +0000 (UTC)
Date: Sat, 11 Feb 2023 00:56:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676077007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CrZl5vUkAt4FS0BIHrg6dSLC9PKKZUVgtPkff++aKKU=;
	b=M1D3ha5CpjqEi4ic9S6kXv9kvH72O9KzzXQJ8BAclbXVM2fDAcqmCAbQQqwNH6Jj5Q49Uw
	m5guz0uEjl6e11QaufMuPnfdnybi7Mw43vV+cqZgSjuMEurSuF5xzYdx0ObOdogNKfMD0X
	c/NPsYkeY17ZQurvX9sBlCysJ7JcXPQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jeremy Linton <jeremy.linton@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Circular lockdep in kvm_reset_vcpu() ?
Message-ID: <Y+bnybGEkMpZzm/y@linux.dev>
References: <f6452cdd-65ff-34b8-bab0-5c06416da5f6@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6452cdd-65ff-34b8-bab0-5c06416da5f6@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Jeremy,

On Fri, Feb 10, 2023 at 11:46:36AM -0600, Jeremy Linton wrote:
> Hi,
> 
> I saw this pop yesterday:

You and me both actually! Shame on me, I spoke off-list about this with
Marc in passing. Thanks for sending along the report.

> [   78.333360] ======================================================
> [   78.339541] WARNING: possible circular locking dependency detected
> [   78.345721] 6.2.0-rc7+ #19 Not tainted
> [   78.349470] ------------------------------------------------------
> [   78.355647] qemu-system-aar/859 is trying to acquire lock:
> [   78.361130] ffff5aa69269eba0 (&host_kvm->lock){+.+.}-{3:3}, at:
> kvm_reset_vcpu+0x34/0x274
> [   78.369344]
> [   78.369344] but task is already holding lock:
> [   78.375182] ffff5aa68768c0b8 (&vcpu->mutex){+.+.}-{3:3}, at:
> kvm_vcpu_ioctl+0x8c/0xba0

[...]

> It appears to be triggered by the new commit 42a90008f890a ('KVM: Ensure
> lockdep knows about kvm->lock vs. vcpu->mutex ordering rule') which is
> detecting the vcpu lock grabbed by kvm_vcpu_ioctl() and then the kvm mutext
> grabbed by kvm_reset_vcpu().

Right, this commit gave lockdep what it needed to smack us on the head
for getting the locking wrong in the arm64 side.

As gross as it might be, the right direction is likely to have our own
lock in kvm_arch that we can acquire while holding the vcpu mutex. I'll
throw a patch at the list once I get done testing it.

-- 
Thanks,
Oliver
