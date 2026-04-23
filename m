Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C823DEFEC;
	Thu, 23 Apr 2026 08:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776934632; cv=none; b=WNcXiHK1KuceMtMvIEH8pWaXPXYoF/Djsd0qlP3uAnevd3I23ZpgVnMbtWBre+O/WikPS/C+o+nseePFNgUcQmVY/b4LrAoKdw5wzZRt9+WwHZK/XxNhSCCsG7CKglxQPo9ucFsVlLRwvTyrjmMFr+EetzmOk8SK2UHcv6X+w6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776934632; c=relaxed/simple;
	bh=5ntX/yXGaj6yZ4bq76PTKmMPNSGKbk0vd3cnMZFOzAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ovs6D7u8WWKbncoO7xvsedKwedBC3xavFVPemjObHpXYet8Kog8cZhELRJVao6gRNu56ehC8//ql2H6iZUsjf2FclmF8K9aAgrQ8wq0vrsBa7T/UOobHf/9OolFfAhw0l/7oiMK8ehtpiebULkXqXn87l4vcEcLhwzCCp+ASIOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oU9EzKHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oU9EzKHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAA1C2BCB2;
	Thu, 23 Apr 2026 08:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776934632;
	bh=5ntX/yXGaj6yZ4bq76PTKmMPNSGKbk0vd3cnMZFOzAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oU9EzKHXHhCS3oxdpn9a3sbRkYfo+xcSdzCVrOWCpxAHnCxEZFn8VCkBMCC9ttMCe
	 ZmOsm7aR37y6TpWP9iOqO1H/bLl05euPdKdKDVIn3/EXaVdap542NsVQ9UpoR0zliK
	 W6zZl5MdOk4F8lH3qgbKAxuLVaN5j4TTfmTc+wiILihAWlKlVUr52JybRvKy/vumPN
	 Tq0SnBZRVPKcYGHZVZRwss0lJ1hghu9jNVM6T/jeMvbVTxW9KmGb3vs2IGq6D7+MgV
	 JB7Rd/REPaGq3o+YDGY5Yoq8niGBRcf1irZf64DlB/VaqcQIjbHN+KnYdxpyR86sCH
	 SHHagNPzmWlPA==
Date: Thu, 23 Apr 2026 09:57:04 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Sudeep Holla <sudeep.holla@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, zohar@linux.ibm.com,
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com, jarkko@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, sebastianene@google.com
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aene4KFD5kbSbFRm@willie-the-truck>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <87se8sbozv.wl-maz@kernel.org>
 <aeNeNjfO7i128TIP@e129823.arm.com>
 <87pl3vb5bm.wl-maz@kernel.org>
 <aecf57rWloQwDh6v@e129823.arm.com>
 <20260421-married-liberal-ammonite-dffda8@sudeepholla>
 <aec/YSxYO1bOhXhn@e129823.arm.com>
 <aejN52lwaqfoMuGJ@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aejN52lwaqfoMuGJ@e129823.arm.com>

On Wed, Apr 22, 2026 at 02:32:23PM +0100, Yeoreum Yun wrote:
> Hi All,
> 
> > > On Tue, Apr 21, 2026 at 07:57:43AM +0100, Yeoreum Yun wrote:
> > >
> > > [...]
> > >
> > > >
> > > > Also, the FF-A initialization is not driven by a device probe, but rather
> > > > happens as part of the bus registration itself,
> > > > so it does not fit well with a device_link or probe deferral based approach.
> > > >
> > > > Instead, perhaps we could go with the idea I mentioned previously:
> > > > either introduce a notifier, or create a pseudo ffa_device
> > > > once pKVM initialization has completed, and
> > > > then let the ffa driver perform the additional initialization from there.
> > > >
> > > > Am I missing something?
> > > >
> > >
> > > In order to handle/cleanup some ugliness in interrupt management in the
> > > FF-A driver, we may introduce DT node eventually. But it will take sometime.
> >
> > Unfortunately, I think this DT node wouldn't be helpful to solve
> > this situation for dependency with the kvm misc device...
> >
> > IMHO, current situation, the notifier seems to good option. unless
> > we make the initcall to recongise this dependency.
> >
> 
> I think the best approach for now is to introduce a notifier to handle this situation.
> If there are no further suggestions, I’ll send a v2 based on:
>   - https://lore.kernel.org/all/aeS4rAeVQ0yJIPYw@e129823.arm.com/

I can't say that I'm a huge fan of that :/

The notifier will literally fire once, for a single listener. That's
called a function call.

Will
