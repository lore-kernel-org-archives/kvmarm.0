Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7941CAA68
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 00:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777509431; cv=pass; b=oYR9qzyp374b2VNdzYTKbhjnu0l4YwFscxR0j9lukCdR6TjHdm0bE7BLQBcx4QSeoT8QF2jRp0888gMLoyLrymiVr0aEngSvDU9bW6v49sSlzt4jyiXcIU/1wKE9o2DUcrhM+3FmkpngpY4zk/xv9qNkJaiEI1FHi3VbfAApf0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777509431; c=relaxed/simple;
	bh=jxwagxkzPi78qwqEQPmxVQVl+/Y1Vrryfq7+F8b392M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qC1pwVtsZBQEZU5rVvwUr1mAtsnd3Qoa51bmQqUig2W0WC+y0fvJKJDTXCm1q05v6y2zDQeQv0Rw1LKgjFncbPs60XeFNxkca2HT2SHuIYsqUWVI746U/G4WmjcKXyC44LIT9f3sSkKfV0stJYBZrpX2Md+Giyen/eQKXoJQ5ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=DpreYDnq; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="DpreYDnq"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35fbca04006so136177a91.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 17:37:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777509429; cv=none;
        d=google.com; s=arc-20240605;
        b=II3i1QOBEV2JjZdvYukOyqjKA2i2qAwTHRUUp7A5TNyIPyLsMIWvgMzowOh3HnbOep
         J5+B831xOifz7XigLS02LbyT5X84oigEzI0ZRHThQ3gTRemI/8cdPmWW3qrnLPlS55Qn
         eShLtnLJ0ZsmfrfTfCGqHzEvZpOQURYen8rshKnOYz1pBYPCYC2d9Toyh7JJ7fZSZk51
         jpG296AVykwONfrZUNznjcBst0VgjCqswP1Ra2iFL/I7pH7lVCIZBVgr2OXqrfE9w6H6
         I0IY8L6GghvaeXsas5hSZsDlqp23hd1QDIknPErmFWzeb/lJDow5GIxQ+uoBQYiBGQlq
         C/Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XxIaGXcpSE5LxIReZcGgBcZB3ReO4RJbfPvanWg+Ksw=;
        fh=vawAIJ2qmdnHUxhpdJXeHCReOnRc49i0zVPPU+/HwBI=;
        b=JVVGQyH2f/zfuOps9awBWNEm9vE0T2kug394bxIsy4iaqmm7jAOOeYtMEGk+/i0Uhr
         qUp1X1hrdB5L7rtt3HFXKvxVm3bur5Apni1k0148nCXWjwbTRd4kWl7aOrvmNAWBT2ZN
         iE1TSR4qAs+1FoQGwpAMaK1tG4t6HL41imMe8dURk6BvfAE2CDWZKgmKqownr/yN7fHR
         3GJ2+uZl3dlDdjAGII98Yoeo+slddim8SIZI254dBkJ8V6vkCUOQIDJarhQ0rZ+byAw8
         4CQnJVA/fBjutamM202i40Y4a2fHfqMK9o+kwUd6RcxlrnFTK/Sg7tk7iJmsHnyR66NA
         864g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777509429; x=1778114229; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxIaGXcpSE5LxIReZcGgBcZB3ReO4RJbfPvanWg+Ksw=;
        b=DpreYDnqdSzMlkJ1NIRJPYmxsRlV1KupgC4QIlSbYGt7z3ws3XLV/nO5TCPZvGjWdN
         XMbzPjqMadsnkrupXlmv5WwnLLRszkg0Nqt3JU9qNbEJeayPNIp/CGGog96GT668xN20
         bMn3RLDXO3SdfhMg7nWb4+fcRPGnXOuVNGIk8SB3nLKIkYopZVOkPqABRYz5ibxfvTV5
         Yjn9xx9EC6CdWM+XkrZgNmw5U0d5waX5WLBFvXd4xiaSKGkO0cnv0lMkWhtjyKaeyoIE
         rsqpiZ21SV6qg0+hR7PXPd0dysFkEZ3PQ3PHMEeLcSHFprhYNnqjMSDKNOYm5aqZVXch
         sYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777509429; x=1778114229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XxIaGXcpSE5LxIReZcGgBcZB3ReO4RJbfPvanWg+Ksw=;
        b=H+2Q02GesVvZRWYeQyFk/NTH2tiArYshSlbP81b7R/PwYlDxu01gcu6nJMEQIcrbLg
         48sfZflIvdzqH8EqUwTHKsHAwVYGK5t5cKaj/IM1UROlJEwFc8bw8QzygNCLdjdg71kx
         B1zxj+go+8YNuH35hQeDfzxLhSAK8nuUoB6wn7spNznLaUeyC0u0kn6jYxBqHNnhdkU3
         KTwnj9264t2SB3NB8mqOMjuPhbykhaEeYcq+05XU0sWlGGCPMLNhsWnUUnTdRb5D7XQw
         zVOsGskTEcO6bUQ3837dy4idGp0b0Eq0LqvadqrHVnyeUWK6swj/zIvZcAxAkCxp7aMN
         M9cA==
X-Forwarded-Encrypted: i=1; AFNElJ92yy66XXiMTTlCX7TFXDpwzOMJRgLWxOzcIe0cPpn0fi7DEY5EZA9nZlcfvbAf0vi00CXj8Co=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRX+5wVGCHP4CzvYr2t6htpw5V+iG9fST8PTlbD95rA7Amly6b
	RcP72/r7b1pleSrbXPR/f6TmkP9UjURyn3rykwNBZTMAgMCx+P0r7jksW6M/Q5CAz9M71QNOkRV
	3ER3xYE4CfGqemtAwR4u3gWVJ39YzeQeD0lDu2/om
X-Gm-Gg: AeBDieuTLp0Qj3vS9hTE7hXsP0aItM9Y2pL1HKoPKv623+XhcbmOu6ZDQ6bup0ZPpxu
	Y1kNFML8HG0E/TXEzn4FQlzyqQn02aCZ7LjHzKW4zYEjhTOZjx9s8GO8mJESaMhA/wg5P8aArfl
	0jYF4ePphk3fDObfV9/x9AdJzCRwu3NBYUOg/f9HpfYzjNsVHgH52YfesLKH0KgOBXoY7a3l4ZN
	GhAecKI6qv860jx93rbeR8D7rg80h7r6We1lcsT0pe5i5eroTqCKLXy/+in+2vcAD9aB7H3tMAV
	ytgTOJhvVPelG06aFw==
X-Received: by 2002:a17:903:3644:b0:2b2:5314:e96a with SMTP id
 d9443c01a7336-2b9a2523582mr3745025ad.34.1777509429231; Wed, 29 Apr 2026
 17:37:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aephL3MzYoqFGaT5@e129823.arm.com> <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
 <aesGU8a3mbVzvteH@e129823.arm.com> <CAHC9VhSaT_quKYnpFjAfqvL07JNbWMgM6c4pB9F46NHawX3DCA@mail.gmail.com>
 <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com>
 <CAHC9VhTW3=RJ8L91RWXYYA9tFjfSXGN-DMEEwdiD6big9H57Ew@mail.gmail.com>
 <1f78fc75b2e95239973612a4b6c4cc782960b7ac.camel@linux.ibm.com>
 <CAHC9VhS4JmPmCJrYTdbjxb3TO-uK6cB3Zij-ef=wswGce2BGzg@mail.gmail.com>
 <1e51c2fd090e5ceb07b1d09e50650c70fd3ccdb1.camel@linux.ibm.com>
 <CAHC9VhS_WgwhW_NDO91LoTeSzdieGqbwqnwPq8KpavH1_Lwi7g@mail.gmail.com> <afC0UPfGhNTsXnyi@e129823.arm.com>
In-Reply-To: <afC0UPfGhNTsXnyi@e129823.arm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 29 Apr 2026 20:36:57 -0400
X-Gm-Features: AVHnY4L0F5CYsArVv0_Aux1I2flm7srRsxc7thS9QtQpbPKd3nDtBwoWwNOL0u8
Message-ID: <CAHC9VhR8Qc42xnoNHW+CEKGEAeupET-BFdYuHLuM3ZGzfDmEYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, roberto.sassu@huawei.com, 
	Jonathan McDowell <noodles@earth.li>, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	jmorris@namei.org, serge@hallyn.com, dmitry.kasatkin@gmail.com, 
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca, 
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com, 
	sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 9:21=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
> > On Fri, Apr 24, 2026 at 6:49=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com=
> wrote:
> > > On Fri, 2026-04-24 at 18:10 -0400, Paul Moore wrote:
> > > > (I'm assuming you meant initcall and not syscall above, but if you'=
re
> > > > talking about something else, please let me know.)
> > > >
> > > > Saying that you aren't comfortable moving IMA initialization to
> > > > late-sync is inconsistent with allowing IMA initialization to be
> > > > deferred to late-sync.  Either it is okay to initialize IMA in
> > > > late-sync or it isn't.  You must pick one.
> > >
> > > Yes, we're discussing late_initcall and late_initcall_sync.
> > >
> > > I prefer to look at it as being pragmatic. I'd rather err on the side=
 of caution
> > > and not move the syscall to late_initcall_sync, than move it.
> >
> > If you were truly erring on the side of caution you wouldn't allow
> > late-sync initialization without knowing if it was safe or not.
> > Determine whether IMA initialization is safe at late-sync.  If it is
> > safe, move the init to late-sync; if not, keep it at late and figure
> > out another mechanism to sync with the TPM availability.  If needed,
> > you could probably use the LSM notifier to enable the TPM driver to
> > signal when it is up and running.
>
> I don't think LSM notifier wouldn't be good since it a one time
> notification for initailisation and it wouldn't tell properly
> whehter TPM isn't present in system or present unless functions
> ima_init() are rewritten to discern the "TPM deferred" and
> "TPM doesn't exist" in the system (e.x) boot-aggregate log creation.

Yes, some work would needed to differentiate between TPM present and
TPM absent, the notifier would simply be a mechanism for the TPM
driver layer to signal to IMA (and potentially other LSMs if needed?)
that the TPM device was initialized and ready.

> One question, though.
> In the end, for systems where the TPM has already been probed by late_ini=
tcall(),
> init_ima() continues to be called at late_initcall(), while the above app=
roach
> is introduced for systems where the TPM is not properly initialized by th=
at point.
>
> If init_ima(), which used to be called at late_initcall(),
> were instead called at late_initcall_sync(), could this break system inte=
gration?
> In my view, both late_initcall and late_initcall_sync run during the do_b=
asic_setup() phase,
> so it doesn=E2=80=99t seem like this would cause tampering or affect thin=
gs like the creation of the boot-aggregate log.
>
> Is there any particular reason why init_ima() must be called specifically=
 at late_initcall()?

That is something that you, and the IMA devs need to answer.

--=20
paul-moore.com
