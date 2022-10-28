Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D9B23A3
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 11:44:49 +0000 (UTC)
Date: Fri, 28 Oct 2022 13:44:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666957487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lKr3ZxRBxgAbbIERdXuMUId7MnGr7ccUy84WJo1ZacI=;
	b=jmaTdc1O9Ni7gnN7EPpz4XsShcVsE2LKa/0jt4JX+pYR6wRQmGI1SdAgt6cb8svXn1T08w
	3s4Nhv1mw3Ts86k75CC1iXXAQ/OmYRCQ4zROS3uyvrJ06qMSUqPEEe77PaL4d0XQjl3EKQ
	CgAfBzY6Ef+Rilow6Gy5/z08Rr1Jwg8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Message-ID: <20221028114446.zn2xz64lrzptskgd@kamzik>
References: <20221025160730.40846-1-cohuck@redhat.com>
 <87a65gkwld.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a65gkwld.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221028114446.y293Ry5tXwGZMUIGuNEm74HueBmlIMevvB0PRCoxP54@z>

On Fri, Oct 28, 2022 at 01:37:34PM +0200, Cornelia Huck wrote:
> On Tue, Oct 25 2022, Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > KVM/arm64 development is moving to a new mailing list (see
> > https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
> > kvm-unit-tests should advertise the new list as well.
> >
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> >  MAINTAINERS | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 90ead214a75d..649de509a511 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -67,7 +67,8 @@ ARM
> >  M: Andrew Jones <andrew.jones@linux.dev>
> >  S: Supported
> >  L: kvm@vger.kernel.org
> > -L: kvmarm@lists.cs.columbia.edu
> > +L: kvmarm@lists.linux.dev
> > +L: kvmarm@lists.cs.columbia.edu (deprecated)
> 
> As the days of the Columbia list really seem to be numbered (see
> https://lore.kernel.org/all/364100e884023234e4ab9e525774d427@kernel.org/),
> should we maybe drop it completely from MAINTAINERS, depending on when
> this gets merged?

I'll merge your patch now with the old (deprecated) list still there. When
mail starts bouncing it may help people better understand why. When the
kernel drops it from its MAINTAINERS file, then we can drop it here too.

Thanks,
drew
