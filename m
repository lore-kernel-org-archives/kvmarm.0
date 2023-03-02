Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A0B5381
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 11:52:33 +0000 (UTC)
Date: Thu, 2 Mar 2023 12:52:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1677757951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Exd3f/Ghc1iGR4gajWUjcAYxFgYFkLRTz32ntOPrBc=;
	b=ngTUwxqRWtF85TTvnRkd0MydvBUtsS00IrzUQh/x+9XqODC2Pm5kN8Zf6oOdJiaH0MWwMC
	snpff2/IJ/BdRoq6HxJmZSORV9hwP2gMhdigljAazxwz/Y4MxaC9gLKNijX8UtUtrR7Zrd
	P/xUqbfJVttupvdb4gThADWZRAd4LL4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, "open list:ARM" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests] arm: Replace the obsolete qemu script
Message-ID: <20230302115229.cphrnp5qaxmdg6wz@orel>
References: <20230301071737.43760-1-shahuang@redhat.com>
 <20230301125004.d5giadtz4yaqdjam@orel>
 <5b019bd3-cc57-017a-e0f6-bf9ebc97ad11@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b019bd3-cc57-017a-e0f6-bf9ebc97ad11@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 02, 2023 at 06:09:36PM +0800, Shaoqin Huang wrote:
> Hi drew,
> 
> On 3/1/23 20:50, Andrew Jones wrote:
> > On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
> > > The qemu script used to detect the testdev is obsoleted, replace it
> > > with the modern way to detect if testdev exists.
> > 
> > Hi Shaoqin,
> > 
> > Can you please point out the oldest QEMU version for which the modern
> > way works?
> > 
> > > 
> > > Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> > > ---
> > >   arm/run | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/arm/run b/arm/run
> > > index 1284891..9800cfb 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
> > >   	exit 2
> > >   fi
> > > -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
> > > -		| grep backend > /dev/null; then
> > > +if ! $qemu $M -chardev '?' 2>&1 | grep testdev > /dev/null; then
> >                                ^ This shouldn't be necessary. afaict,
> > 			        only stdio is used
> > 
> > We can change the 'grep testdev >/dev/null' to 'grep -q testdev'
> > 
> 
> This just remind me if we could also change
> 
> if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
> 
> to
> 
> if ! $qemu $M -device '?' | grep -q virtconsole; then
> 
> And all other place like that.

Yup.

Also, unrelated, but can you change your patch prefix to

  kvm-unit-tests PATCH

as suggested in the README? My filters are looking for 'PATCH'.

Thanks,
drew

> 
> Thanks,
> 
> > >   	echo "$qemu doesn't support chr-testdev. Exiting."
> > >   	exit 2
> > >   fi
> > > -- 
> > > 2.39.1
> > > 
> > 
> > Thanks,
> > drew
> > 
> 
> -- 
> Shaoqin
> 
