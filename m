Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5322E261380
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 17:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742922154; cv=none; b=V9iQowv4JiUFUCKIqnI8C8/I9/+CYcokpERain2qNeCQxnRvVhYM+vW2MDCGdPcAHVFkWvxsVVY/d/h9Yv085chcuRk9Lsdrd9y8a4GTvXqBm2UlS078KbX3pqlnVHoouSbrl5foUtD4X8DAS3WhO5bw3ScrCXCjHYbPPui/kWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742922154; c=relaxed/simple;
	bh=XXde8LJYQO8tatSoKIRCR8CfXJxdd+VGx9Dn01SUWvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XT8UgF5RX0tJqwbXtYTebzqYuYpdEuH4RDowp9XF0sdKajZyZos8IOHEpwNOHputLjyt74TN3zI91ztgV1b/0ATbnPRjhaSFYalbA36mNlJPHb1MWHKEm9MeUchKaQNtXHMQRTkeGs8+XHJ18H+/KzlOrNItIZiF6Xij5b4X3to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m8d4PUdD; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m8d4PUdD"
Date: Tue, 25 Mar 2025 10:02:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742922149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pvm/JJUDO3VfLlS+vzoxNGh7x3V6BVgwZ85y95H3Jjk=;
	b=m8d4PUdDuVu6yV2S9ASbtiIyxl+PhnNVBtqvXCEuz4sqzQhi9rqUL1UEXSJhw1/6qHwv0z
	WDa+0uTcyx1S2KWKI0iKyGevm7fPBT8ruEkIBYjK7NTBCEyyclQt61QymDZXCw3jN9JRtZ
	9G8XvtLYeRF0mDS7SrIeKTEFc6Do6dA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC kvmtool 9/9] arm64: Get rid of the 'arm-common' include
 directory
Message-ID: <Z-LhoOxnQ9xpqL-Q@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
 <20250314222516.1302429-10-oliver.upton@linux.dev>
 <Z9xJ10c4pwJ-TF3o@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9xJ10c4pwJ-TF3o@raptor>
X-Migadu-Flow: FLOW_OUT

Hi Alex,

On Thu, Mar 20, 2025 at 05:01:11PM +0000, Alexandru Elisei wrote:
> Hi Oliver,
> 
> On Fri, Mar 14, 2025 at 03:25:16PM -0700, Oliver Upton wrote:
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arm64/arm-cpu.c                        | 4 ++--
> >  arm64/fdt.c                            | 4 ++--
> >  arm64/gic.c                            | 2 +-
> >  arm64/gicv2m.c                         | 2 +-
> >  arm64/include/{arm-common => }/gic.h   | 0
> >  arm64/include/kvm/kvm-arch.h           | 2 +-
> >  arm64/include/{arm-common => }/pci.h   | 0
> >  arm64/include/{arm-common => }/timer.h | 0
> 
> Looking at x86 and riscv, the pattern is to have the header files in
> <arch>/include/kvm, even if they're only used by the arch code.
> 
> Do we care about following this pattern?

I have no strong preference in either direction, I just did the laziest
thing here.

Thanks,
Oliver
