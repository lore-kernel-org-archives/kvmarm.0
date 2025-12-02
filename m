Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A972C218AAD
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764685352; cv=none; b=P3ZijF2kLlD1flTe/XdYji3jxI8YnvO0Wf3ym2nUprJkCX874KQveqE8cuShDpSGO/2mbj2jxZjlxh+mEkmC567OABsBD9VswTuj1mnwEQ1/k8Vep77oycL5ZOYuFtlGQFNWxZl46WYQQGTSPyB45wr3uFma9Bbp+Zo4tAnxg5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764685352; c=relaxed/simple;
	bh=Z9J/YtwD6T45cE5M8a97Dj+fqTKHg477jT5R5TDYDZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9PQ48BhE2SJ7HGswVulgRBGH79TWUtJiShrRwDywZnmMnvdJlRav5MUsGrfvf60iKJ9ultN+eQJccx7fQksYNrsBmC2FzjzVssWx0EWQjKXU+T7J+avf/1VP1P6MR++R0Qbwp6Dpu7z8lBAXJnonlZjfkf5sZZGCpRXtV5spGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B00561477;
	Tue,  2 Dec 2025 06:22:22 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C35DC3F73B;
	Tue,  2 Dec 2025 06:22:28 -0800 (PST)
Date: Tue, 2 Dec 2025 14:22:26 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
	alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251202142226.GB3921791@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
 <20251127110832.GA3240191@e124191.cambridge.arm.com>
 <3a39738e-ed33-49fa-9f1c-0bbba6979038@redhat.com>
 <20251127145207.GA3265987@e124191.cambridge.arm.com>
 <20251201-2ae3e986e3c1242e7bafc247@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-2ae3e986e3c1242e7bafc247@orel>

On Mon, Dec 01, 2025 at 05:16:40PM -0600, Andrew Jones wrote:
> On Thu, Nov 27, 2025 at 02:52:07PM +0000, Joey Gouly wrote:
> ...
> > I will send out a new version with this fix, missing sob/reviews/acks, after you've had a look!
> >
> 
> Also please run checkpatch on the series if you haven't already. I think
> it should have complained about the C++ comments, for example. And, in
> any case, please change the C++ comments to C comments and generally use
> the kernel's coding style.

I hadn't run it, have done so now, and fixed some style issues.

checkpatch doesn't actually complain about those C++/C99 comments, I guess at
some point Linux started to allow them. If you run with `--ignore
C99_COMMENT_TOLERANCE` it does complain.

I will change the one place I used them to the multiline style anyway.

Thanks,
Joey
