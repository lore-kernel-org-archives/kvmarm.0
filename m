Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1F437AA83
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776704662; cv=none; b=QHLbIOFVZwlScEa1uhC5D1hQYjNq13Sbn2F6u4DtOaeThw3CxytyBvxRThESlePar5JNEzhHZ3MRsPcrW11xwASSCk2f4SWHo7yX8fyA9oEjVBNHx929nQBMXeKdZmnp50S6pktnEi5E3HkbbcoHAioqL4CP7aCwrcf1Fb1Qo+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776704662; c=relaxed/simple;
	bh=yRc6tzbhIjqa28m1qmW4UX0qWCRaHh+34fkYVAyFgQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lW1mIIVi3snIufcIgcu1nxjtpEPotr3zSSV8zgy48alExUyT5jyTq5yQ6rTyrppphZQWsQPpiTdUl4OYD7IMMFsd5+2z40DQ6dmutwsH20XGdeNSeHqCmJqzGn1znmjg81HOUWRcFxvqtWdciRw+JwKji0msZmyOjM5ZQ6pmXMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wacy9S/Z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wacy9S/Z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B54D01516;
	Mon, 20 Apr 2026 10:04:13 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50C183F915;
	Mon, 20 Apr 2026 10:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776704659; bh=yRc6tzbhIjqa28m1qmW4UX0qWCRaHh+34fkYVAyFgQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wacy9S/ZPt9Y7v/ct+Hb+QPydm3fjVRQplB9QxXGOsLTBekpTPqnsaMca0kamuoEW
	 SGQ6QONwRmBlO8d/cVwMwpP6TU7OmYw273xBR7Zj7hU5thdu5jlLJAp8INH5VzhLz9
	 ijzBSlASATvCse9gHcojqyT85ag+98biT096gBAc=
Date: Mon, 20 Apr 2026 18:04:12 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com,
	sebastianene@google.com
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aeZcjPaIiCHYVwfd@e129823.arm.com>
References: <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <87se8sbozv.wl-maz@kernel.org>
 <aeNeNjfO7i128TIP@e129823.arm.com>
 <87pl3vb5bm.wl-maz@kernel.org>
 <aeS4rAeVQ0yJIPYw@e129823.arm.com>
 <aeXp7WSqpXNytNPG@willie-the-truck>
 <aeXxCe4hdizdQbFD@e129823.arm.com>
 <aeYDMEgWdt8F9jWb@willie-the-truck>
 <aeYGeojpqcYAN5++@e129823.arm.com>
 <20260420-olivine-cobra-of-brotherhood-bfd4bd@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-olivine-cobra-of-brotherhood-bfd4bd@sudeepholla>

> On Mon, Apr 20, 2026 at 11:56:58AM +0100, Yeoreum Yun wrote:
> > Hi Will,
> >
> > > [+Seb for the pKVM FFA bits]
> > >
> > > Ah sorry, I mixed up the ordering of 'module_init' vs 'rootfs_initcall'
> > > and thought you wanted to probe the version earlier. But then I'm still
> > > confused because, prior to 0e0546eabcd6 ("firmware: arm_ffa: Change
> > > initcall level of ffa_init() to rootfs_initcall"), ffa_init() was a
> > > 'device_initcall' which is still called earlier than finalize_pkvm().
> >
> > Right, and this is what I missed when writing patch
> > 0e0546eabcd6 ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall").
> > and it still exists even if it's device call.
> >
> > However, rather than changing ffa_init to rootfs_initcall, moving ima_init
> > to late_initcall_sync is a better approach, as it also addresses similar
> > issues for TPM devices that do not use FF-A. For this reason,
> > the FF-A-related changes were reverted.
> >
> > As a result, patch 4/4 addresses an issue that existed independently of
> > 0e0546eabcd6, as you pointed out.
> >
>
> I was not fully convinced by commit 0e0546eabcd6 ("firmware: arm_ffa: Change
> initcall level of ffa_init() to rootfs_initcall"), and I had raised this
> concern at the time. However, in the absence of a better alternative, we
> proceeded with merging it.
>
> My concern remains essentially the same. That change moved the initcall one
> stage earlier, and now, by introducing `late_initcall_sync()`, we are
> effectively shifting the dependency issue one stage later instead of resolving
> it in a more fundamental way. From my perspective, this still relies on
> adjusting initcall ordering as the primary means of making the dependency
> work.
>
> I do not think that is a robust or sustainable approach. Tweaking initcall
> levels tends to be inherently fragile because it addresses the symptom through
> sequencing rather than establishing a clear and explicit dependency model.
>
> I also recall that `finalise_pkvm()` is itself at `device_initcall` level. If
> that is correct, would this not introduce another ordering issue or at least
> leave us exposed to similar dependency problems? That is exactly why I remain
> uneasy about solving this by continuing to move initcalls backward or forward.
>
> More broadly, the fact that we are revisiting the same class of issue again
> after such a short time reinforces my concern that this direction is not
> sufficiently stable. We may revisit it soon after we merge this approach.

I understand your concern about relying on initcall ordering.

However, I think there is an important difference in scope in this case.
This change primarily affects the IMA subsystem, and the impact is
largely confined to IMA (at least based on my current understanding).

Also, this is not just about FF-A. The issue arises when TPM devices are
deferred, and IMA does not handle such cases properly. From that
perspective, moving ima_init() to a later stage is not simply about
adjusting ordering, but about ensuring that IMA correctly handles its
dependency on TPM devices.

In other words, the goal here is not to align dependencies indirectly
via initcall levels, but to ensure that IMA is initialized only after
its required dependencies are ready.

Regarding pKVM, finalise_pkvm() runs at the device_initcall_sync level.
Because of this, the FF-A driver needs a reliable way to determine when
pKVM initialization has completed, rather than relying purely on
initcall ordering.

--
Sincerely,
Yeoreum Yun
