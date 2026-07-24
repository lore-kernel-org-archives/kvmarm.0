Received: from mail-wr2-f1.google.com (mail-wr2-f1.google.com [74.125.225.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7106838F642
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 12:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897545; cv=none; b=A08LZUxz11S3zj+0nQ4BM79UdxofM2VrC2AUe0CLgZGoQ9hB7daJeWAzWgdFMs/n9xoJOZjLgBOjDL9BtqHMHunxaX5vl5Zt05MtIJPN2Mvqz7kJ+zkOJbs6jGz5qJKCR+yP9V+z8t3S2b7VBnkeJdamV0BPlKbru6XeP/T6N1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897545; c=relaxed/simple;
	bh=mk1BQnZGtudR7XDj42PbREbR3Ki5M0tr3oqDAtI6TZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMkK7xsyjLlRa8zJzNrkykxctFS+y5Wq/rpbGQq5R+BWEjS/CxIF9NjQnVppwonQGsdcbzleJn6paiBl9B7MoBXz1crSjvilb/G0n8vYxxDNvM01wELck9vH6xq/5IiJwbx7RABP5GEjUyv0uBLSYDD5Y7OPqP36P4uhg3TlTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TPtvp6/6; arc=none smtp.client-ip=74.125.225.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TPtvp6/6"
Received: by mail-wr2-f1.google.com with SMTP id ffacd0b85a97d-473913157edso205268f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 05:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784897542; x=1785502342; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mv5tWqGLGkHnf04eMqxVT5ugoOpACtQyu5RJWX4G6Hs=;
        b=TPtvp6/6Nv47q2BIBF84xV27TA3GvI3QGH3Stb+nrz183ZvnMdYVQtsFxbLcAio6p/
         72vt1LApP2bQM3H1uNKK13Y9KqTLLe2wa8bCXE+5zF56ON6yywP0L55d1UuH+ISTo/2s
         pjVeK2lQLFBlvp73P9E1DaOvCB5FOAQmAkjGsQgSmapcyq66IUsXj/j2EHO6bZ0PmADF
         AOySxIWLOZtQkOxHUbVGgcwRT7L7APPct6dJYnXybeXkMsZxIxDFd/7RmfRmsiBdqIK2
         rxB2QPWQr3LUl4IEx8+u0ZyWNA7/cIX++tmcBkqf80DMvHSjNpLXCijQuLczMlBBRLNx
         /THA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784897542; x=1785502342;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mv5tWqGLGkHnf04eMqxVT5ugoOpACtQyu5RJWX4G6Hs=;
        b=MSx98VZhTFfBqKetny6r2vfOZazk2JkJipdZ/WYAvJLuS77DY8iYqhGgIlGGqCK67v
         5YO+sNoNu8zN5naRenWbG9daw7CEYVwAITHo5uoOMiFLn74dwh3F9JCKsy65ARUIX65h
         nfYoYjF5i8LFKT0C/zeoSgrVYJu/J7cYeCRGsjmqaepIuAQOZKEqGugGsZiUY3UE4l6q
         ud5sVxgCmJJiE2krvzR9vyA4Fboz6KSPmp7wnzAFcf5FBIdTa+J4xkDQ+Sd4T02D7W8h
         4mx+/P5JDbyW1nRSsFSznFOmjIbJSzQ9d3KX6Wf1BXySAAG1UNl3HtkhL5IEeXm9HoIj
         Ll0w==
X-Forwarded-Encrypted: i=1; AHgh+RqjI89txSvNVeIPmnUiakMRSZa6IpvLe4ZA2IoTP+Qbi8BOAh3EFPfRRfDVqHQAOreEgO6cHuI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4v+xXtQNF3gKCwdDaQr0lwf+sqps3q5x4fWyna6m1YFPzX7fi
	a1YytI/aLhmC4ePzGMZo5q1Sk1wmSIr68yub81y79l9MLWkzuePCVNdpb+mEH3oNAnc=
X-Gm-Gg: AR+sD117qaVb5ZCAEDq43Qbhj15ZZVvTwpQS83s23fg/ecozZQGN4pzuS7d7J+fww2q
	dH5cp6HmVSWdIybjVjNW8NL5RoNANAOlpqnqenbN5wJ/DpJtDj0+zxyENjs4K6/TAeheMQLn6og
	8Di+GRHtVZAI18IC6YQ94GswBpcqrvAU4iOC33f06suYEXl6pJeA2y1oSzRbu/jZm2djifE+JuA
	e6vuUmR/puPYBwFSAqlBXHqulWiaWQhsAdGDDSwytvOUiQIC2rJdnLlL4F6W1tmiNgSr5ZBQAxo
	qoqaY4xcu39Qg1PXySLkkpNZ2NgOsbCryuvR36c7yB3GPS5pS0eALX6nNKJ/abGQVuAQDpHG/jR
	2Pf653tVR4oR83PpZbgh083AWkbUh7isWHlGSAsQR2VDsoHbLti3V15S8okVAJKS3C/VnL612+X
	zly/ohWg==
X-Received: by 2002:a05:6000:2287:b0:477:3986:9b54 with SMTP id ffacd0b85a97d-47f8d77c2dbmr9048250f8f.20.1784897541667;
        Fri, 24 Jul 2026 05:52:21 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c631fdsm23383475f8f.28.2026.07.24.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 05:52:21 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:52:19 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH v1 2/2] cgroup/misc: Add support for Arm CCA MECIDs
Message-ID: <amNfGkkI5OIBqpmZ@localhost.localdomain>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-3-enju.kohei@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ax7rchmwlrf277f6"
Content-Disposition: inline
In-Reply-To: <20260724094120.166536-3-enju.kohei@fujitsu.com>


--ax7rchmwlrf277f6
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 2/2] cgroup/misc: Add support for Arm CCA MECIDs
MIME-Version: 1.0

Hello Kohei.

On Fri, Jul 24, 2026 at 06:40:56PM +0900, Kohei Enju <enju.kohei@fujitsu.co=
m> wrote:
> Arm CCA MECIDs are limited platform resources. Add a misc cgroup
> resource to allow the system administrator to account for and limit
> their use.
>=20
> The cca_mec resource represents the number of Realm VMs using the
> private MEC policy. Each such Realm consumes one MECID. Charge the
> resource when the Realm is created, and uncharge it when the Realm is
> successfully destroyed.
>=20
> Realms using the shared MEC policy don't consume this resource.
>=20
> Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> ---
>  arch/arm64/include/asm/kvm_rmi.h |  2 ++
>  arch/arm64/kvm/rmi.c             | 44 +++++++++++++++++++++++++++++++-
>  drivers/firmware/arm_rmm/rmi.c   |  4 +++

(mainly for this)
>  include/linux/misc_cgroup.h      |  4 +++
>  kernel/cgroup/misc.c             |  4 +++
>  5 files changed, 57 insertions(+), 1 deletion(-)

Conditional
Acked-by: Michal Koutn=FD <mkoutny@suse.com>
(it makes sense along the other arches' miscresurces)

Why? I see this [1] (or followup) needs to be added first.

Thanks,
Michal

[1] https://lore.kernel.org/r/20260715142739.80398-4-steven.price@arm.com/

--ax7rchmwlrf277f6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamNf+xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhXYAD/aF4cHB3u4Ztw+Epfxt6r
owvtGiLz50NxCjHVwV+x/xAA/jW6M8nVIZ5COXi3AcXAaZ9Jg4Hbfex1q/uwG0FV
VjUH
=szup
-----END PGP SIGNATURE-----

--ax7rchmwlrf277f6--
