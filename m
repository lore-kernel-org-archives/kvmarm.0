Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520AE23027C
	for <kvmarm@lists.linux.dev>; Mon,  7 Jul 2025 17:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751910275; cv=none; b=A27eemRwfmofCCTvjPJut9HCV41w2Kp/5sQD5ZJzMHTVN8CvWOuroJSywEcXNY7oaFkQTTYLgZcplMIE2pK4b22jsoOHwD9Kvgw+ikXgXpPhq5qXse8OdxlPA4wD+hmjbQ0JKDS6KX7+fMuSTCwsUjmvEy7/CeGotkz12rzi2Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751910275; c=relaxed/simple;
	bh=Z4N7YYE0TGBrDEbSJWXXS73BAcEH4T6haqOEU7WEqSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q28ROvWwx1H/ocd0igA3b2IyPu5itKvP+J0nKGWN1Q8It+OZgxcyOfI4GpI8c728p7L4G6cL3+Z5GVr75PMaxGcYw+FpiMXjYwzR+kF7H3rgZx2rotvgWjX99os7/uUXj3ZpgtHS4HJiQUfk2lYwOGY7KlDjRsEBSvsOU9dYlRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i/Yg7aZ8; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i/Yg7aZ8"
Date: Mon, 7 Jul 2025 19:44:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751910267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bDUHijd7Ti9O17zyCdhODo2Lyk368Lrbom0BpvxiUD4=;
	b=i/Yg7aZ876/AQ5JodBsxWooLMdVJqSThZmfMA1OCDworQ2VnK/uDFy8dalHu62qiMbZByg
	ll0gEP/g1nQD9jhQg+V+UnwI+oqPYesg1m2Do+dJs0KCu//V2luZX12094ChwH/DaEiQL0
	uP89BFd2VAfNpUI8VzMPTIfxjcACVZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, alexandru.elisei@arm.com, cleger@rivosinc.com, 
	jamestiotio@gmail.com, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] riscv: Add kvmtool support
Message-ID: <20250707-cdad2acc36fb5c313042bd86@orel>
References: <20250704151254.100351-4-andrew.jones@linux.dev>
 <20250704151254.100351-6-andrew.jones@linux.dev>
 <CALSpo=YKMa142xhS8KSEenBLemaK6rqYKEd3FotQtCjpV5CciQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALSpo=YKMa142xhS8KSEenBLemaK6rqYKEd3FotQtCjpV5CciQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 07, 2025 at 08:28:30AM -0700, Jesse Taube wrote:
> On Fri, Jul 4, 2025 at 8:13 AM Andrew Jones <andrew.jones@linux.dev> wrote:
> >
> > arm/arm64 supports running tests with kvmtool as a first class citizen.
> > Most the code to do that is in the common scripts, so just add the riscv
> > specific bits needed to allow riscv to use kvmtool as a first class
> > citizen too.
> >
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> 
> Reviewed-by: Jesse Taube <jesse@rivosinc.com>

Thanks!

...
> >  else
> > -    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
> > +    if [ "$arch" != "arm" ] && [ "$arch" != "arm64" ] &&
> > +       [ "$arch" != "riscv32" ] && [ "$arch" != "riscv64" ]; then
> 
> Are there plans to add i386 and x86_64 too?

I don't have plans myself, at least not right now, but I think it'd be
good to do it, so it'd be great if somebody would write the patch and
do the testing.

...
> > +       command="$(timeout_cmd) $kvmtool run"
> > +       if ( [ "$HOST" = "riscv64" ] && [ "$ARCH" = "riscv32" ] ) ||
> > +          ( [ "$HOST" = "riscv32" ] && [ "$ARCH" = "riscv64" ] ); then
> 
> Shouldn't there be a check like this on arm for when  [ "$HOST" =
> "arm" ] && [ "$ARCH" = "aarch64" ]?

arm kvm has been long deprecated and removed from Linux so we should
actually remove any references to HOST==arm throughout the framework
too, since it can't happen (any more).

Thanks,
drew
