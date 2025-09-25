Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9DF158545
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758840423; cv=none; b=ooz/7UkKHBDwi5kfH29GOY6ypNw6TEgx7zRdEYxzLWb/mA8fUoblg0gibSlm3LSU6GBjE/fEcn6E4WiWR/aZf08RymNUBK5hnIcUT+SLCWZQ2Ugip46m74n5m3esKUoaBq4hLVT7VPuQrdMFrN0VS/sWP4J5mHFaWK6UGPMqMAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758840423; c=relaxed/simple;
	bh=a1sAzZtMIVzsVStFgqsULDjOFyrrQTy18Vek1hP1hnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIq2bm2cZrXewCcPsT3NmeYidQsRQNNPDJFT8IV10Al4Hv8yTwUfJVVVAN8BUyUSDRgtugaMmPMH4sFnavAt9++R2XvzE3qZSgREbgBxvg4LkUn6MpnEie07Q9EG3HZAqKAA2YzjUdLma0ePGEGieBrFg+jmVmbeDEuQhp4AFUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XTW7y5n9; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XTW7y5n9"
Date: Thu, 25 Sep 2025 15:46:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758840418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UCxr7/EDa6kIX3HdLra6Zg2rSstiBXln9nQtEteQlFQ=;
	b=XTW7y5n9nkSgFryqJqKb8JmIPTPe0jZLmS08sdhnNRkfPD6WgsUgZNQverhMDkfBEY0Atu
	W7jyN4VpOf5eFGFRBoay+IDq2/TlcEDX8V29hB69iFjW7oJEkOTApCfJC7F1edpKUdL7K+
	8z15tGH8edDxNopsvfmaZV61oo1xS1U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Jan Kotas <jank@cadence.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Message-ID: <aNXGW8C_S1TbFR9-@linux.dev>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <864isq1r66.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 25, 2025 at 04:35:13PM +0100, Marc Zyngier wrote:
> On Thu, 25 Sep 2025 16:10:22 +0100,
> Jan Kotas <jank@cadence.com> wrote:
> > 
> > Hi Marc,
> > 
> > Thank you for a quick response.
> > 
> > > On 25 Sep 2025, at 16:38, Marc Zyngier <maz@kernel.org> wrote:
> > > 
> > > EXTERNAL MAIL
> > > 
> > > 
> > > [+Oliver for the SVE stuff]
> > > 
> > > Hi Jan,
> 
> [...]
> 
> > > 
> > > I would also recommend to update to 6.17 -- 6.16 was the first release
> > > with NV, and while it may work, it will also have a lot of ugly bugs.
> > 
> > I will try, but as I don’t own this machine, changing kernels might
> > be… challenging.
> 
> Well, you're already passing something on the command-line that is
> documented as "experimental and should be used with extreme caution".
> Changing the kernel is a walk in the park compared to that ;-).

+1, also it'd be good to know what you're doing in the L1 and the L2
that leads to this bug.

I just tried the original test setup I used when doing NV SVE and things
appear to work (kvmarm/next + initramfs at L1 + L2, tested with
sve-stress selftest).

> > If there’s anything else I can provide to help track it down,
> > please let me know.
> 
> Testing the provided patch would be good -- I would if I could.

Although I didn't repro the bug, the patch itself LGTM.

Thanks,
Oliver
