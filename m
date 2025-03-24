Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDDE25E82C
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742834019; cv=none; b=JqwDW7G7fblkAYkU9rxi5kDxjuDSWpKRF+vnjqXapQzNM1mt1WgO+aSB0R5r5xH+uenkQ8IhRrwS1hlKoMuqAfMjFMb8cefQd/HY+NfYOYqMipbtFUzNEWYezM+nX/xJ2oODFqIBtzoutHoey/4gTB1WAhP9gb5HOqX+TODnWo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742834019; c=relaxed/simple;
	bh=xcgHG4koUc8LepYIEE2hfF27YSSr+Cg32eomfNznc6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9CvVvHvIoSNcVKroxe2C1B1NFaOkBoe++v2KmMZqvAUa4c/aFTn17vSiQkZT81jpWGLzVNCqpOcJW0jQtXUxLL1GRfvgO4eDa4WAwMfLH7KORbLYudOAYjRAmB88+hIfj1EPWjUzhn43N8loJ+V+vAlrVzKJaE0Qh0ikMvwiaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mwF9pWNO; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mwF9pWNO"
Date: Mon, 24 Mar 2025 17:33:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742834005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CJjm4Sc7RH099dsaRrn3+hA3WmlW1iY5/eTvXCpC+iA=;
	b=mwF9pWNOmL4QAx8xRrw3JJ6gTshHI/7Pi+XDNWk+GDKM6UXMZdfbiWGiquUUn0ZtBJ9JRt
	3/bBHC4T6lSU6n6kyvTnJ0d/vjGjQI6E6qJmqcmmvz7iojmMah+oWhf/N3yPcaHqWuujM2
	0vHgPbYew2GRNlReqqL1/A4JkaezoS0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default
 for TCG
Message-ID: <20250324-9428d144e09d0876ebfa6f3c@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-7-jean-philippe@linaro.org>
 <20250322-c669034d2100a75ab6e53882@orel>
 <20250324155045.GB1844993@myrica>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324155045.GB1844993@myrica>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 24, 2025 at 03:50:45PM +0000, Jean-Philippe Brucker wrote:
> On Sat, Mar 22, 2025 at 12:27:56PM +0100, Andrew Jones wrote:
> > On Fri, Mar 14, 2025 at 03:49:05PM +0000, Jean-Philippe Brucker wrote:
> > > In order to test all the latest features, default to "max" as the QEMU
> > > CPU type on arm64.
> > > 
> > > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > ---
> > >  arm/run | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arm/run b/arm/run
> > > index 561bafab..84232e28 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
> > >  			qemu_cpu+=",aarch64=off"
> > >  		fi
> > >  	elif [ "$ARCH" = "arm64" ]; then
> > > -		qemu_cpu="cortex-a57"
> > > +		qemu_cpu="max"
> > >  	else
> > >  		qemu_cpu="cortex-a15"
> > 
> > arm should also be able to default to 'max', right?
> 
> Yes I'll change this.
> 
> I didn't earlier because it failed when I tried it, but it looks like I
> had QEMU=.../qemu-system-aarch64 in my environment variables, overriding
> the default qemu-system-arm (32-bit only). "qemu-system-aarch64 -cpu max"
> doesn't boot 32-bit code, but "qemu-system-aarch64 -cpu cortex-a15" does.
> Anyway, without explicitly setting the wrong QEMU, "-cpu max" works for
> 32-bit.

Hmm, so now I'm not sure we want to change arm to max. Maybe? People
have certainly gotten used to only needing qemu-system-aarch64 to run
both arm64 and arm, so this change would break that. It seems like
qemu-system-aarch64 should also have a 'max32' cpu model, but it
doesn't. So, let's hold off on changing arm to max for now. Users who
want it will have to both change their QEMU binary and specify -qemu-cpu.

Thanks,
drew
