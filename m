Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2F154855D
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084685; cv=none; b=jRdTorqg7cKahZWo76qGV9YpB6INIpsck3qY0au3jzYfYEkts1tEO9ZTvo24tqvvS1S/umysirQEC8OIqrGhHiFqxKcCUjiesGDyW1YRZBjG/pPHhAS8ACK8OzvTUPSYxNIdB0cwiT6dMhsxm8q5dWYp74SGIe0R5OVDmZYu4uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084685; c=relaxed/simple;
	bh=0SFlIh2a1t3j3rT/bk6IJh8ffwrgGJ66xEj1bDplnm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCGpzc+Ey5gfnEKrz+iAr06dMJWv75MJVvLCxvW9hrXdqMu1HdYrpVbjAHMpLZyapIP4f9IcWGkXnsvbOyKSFiED5sfW0tYmVhBypQ04oaOWCkHg7iymXQXk5CfZU6dUFSHXMFJM6oSHyxK57MAbsEp4igmBDdeVas0tOdkwc5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aE0xEjAK; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aE0xEjAK"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1ca5b0d6so31034485e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790084681; x=1790689481; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4EtP8Gib+oGUfFDioYcMAZLGT/7xIaokAymk9C8xEMA=;
        b=aE0xEjAKw1ECHD1SpbpDR+K2dEvDsSv2kNUc/fHmOuE6UPtfh+3WK7D4wxiUjysmxc
         BPUbrOiowMvNHxWLVwZ9KMcsxMFk1+vKoLsVhpc2Ilv/9iYMPowqOeP7iwFxUUrm7pjB
         4YeM28YW+eeN9e+GrwoTzAU3+OazdSinWHX2NF0s2EATlCcX9lprUGctNyu1tcE6LU1L
         9R/asoYZTe7S9eJcMDhB5rl2kOiNg3lFcpUXVPg+nJoDyVPZheTnODdkAcfS0ObREurP
         7n3+0plt1tUT4m9GZOQx096zz2i6NRUgtH9fRpjHt6uOTGLrlVbHQ6Zs01Z7/wwiDWjW
         YfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790084681; x=1790689481;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EtP8Gib+oGUfFDioYcMAZLGT/7xIaokAymk9C8xEMA=;
        b=H0toLIpqg8n5MYLCT4XMljKFBOra38GuH4TXv7JPHPJyvuyI2fGxXpP/1G9STFCALe
         bIMLRAFfDO0D0EUySPLg7kVWXApgfUt0mBCoiwl5VrZP6Jn4z8KIAD+zskVo9Svgg3rs
         pUIPvb6LCHg5vzcmNL4K9mLCChlT9Z6mojzz/7PiMtZQyblsHb+FxYvyuXDsG6ACUdrD
         L5e9rovlT8T11TxpSeNNY0VosBQ45KFIwqkXTOP9nx2zTWOcLgK8n+I0RDBPL4T/oQxv
         msZgFKtyEZrwsm9UrCHIHpUB1B6ATggNKtu23J/+aqoPGz7+sEhPO/GfCSDf89d8pnj/
         X2tw==
X-Forwarded-Encrypted: i=1; AKwUvBzJTG2xSVDFmsSPHgS8XmJyRZ3JfHvh5FLt2rIneSNl9VReNNs4guY1kuuhj19LHCi/MzcOjC8=@lists.linux.dev
X-Gm-Message-State: AFuF++nQC5p2IAfvMARUpw6Wpvbpx7R0jqY1AdMcm9tlImFZXV4lPkO2
	VrJjK/rELjayCdvHjU+a7QWmlcju1vhEKF6cjfuhVi+irS2Kn9ksfGpwan7esNeFEtI=
X-Gm-Gg: AYBFou0f1C4xm6H9jA+KEi/O8QxXSdMqxZwezPHsQj0htxNgByHyycspyXgJEG1Au9M
	YBK5gfB2Ty8Iog8j7U1E4PSk13xMpI2Bfh1KKoJQfwZ/xVn6PM/kn+UHf/VO6xGwbTOQ4mzdCia
	1ktJwey7Y3HBWTlK0uPBS1DQw1SZ7+SL+Aj51Uvu99Wd6S00LvEEFfzM8CdSphF8dbGfXN1JT9p
	m13iGeg8hnQK/oKdo77jhd+PwwbarEjIAlz2nf3LfXAk9TNlqYZ+au+jYoQih0gA8EgF1lMXwe4
	7VaAy/UM5HJjkslvfamE+g3Z38idVRzVSwHA6WDk+kqbGhqYuaHVCOBXHtgL0DE8/KwDXv9RDYu
	nrkWuNDc47nlUFrmLO+SUkRLAwxDdOUfI3EudkjG3Oji9jv7Nwob2GAm7kVv78nXGCOYMPBSaA7
	RFNKvlibNjcmTTCjeCtpOqwMyjtWJynCGKcG3slqdoFPerKdvzMzZUGWnYbVOWvV993Gr8b2oOk
	w==
X-Received: by 2002:a05:600c:474e:b0:49e:7cff:f8ca with SMTP id 5b1f17b1804b1-49fc5743c69mr189508785e9.29.1790084681055;
        Tue, 22 Sep 2026 06:44:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdad2a3e0sm72269425e9.5.2026.09.22.06.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 06:44:40 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:44:38 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/cgroup: Make the object directory an
 order-only prerequisite
Message-ID: <arKFe3JRF3n2h-26@localhost.localdomain>
References: <20260922071945.693714-1-fuad.tabba@linux.dev>
 <20260922071945.693714-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wz67vp63rqm7k2iu"
Content-Disposition: inline
In-Reply-To: <20260922071945.693714-3-fuad.tabba@linux.dev>


--wz67vp63rqm7k2iu
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] selftests/cgroup: Make the object directory an
 order-only prerequisite
MIME-Version: 1.0

On Tue, Sep 22, 2026 at 08:19:45AM +0100, Fuad Tabba <fuad.tabba@linux.dev>=
 wrote:
> libcgroup.mk names $(LIBCGROUP_O_DIRS) as a regular prerequisite of
> cgroup_util.o. The directory's mtime moves whenever an object is
> created or replaced in it, so an incremental KVM selftests build that
> rebuilt anything in lib/ recompiles cgroup_util.o and relinks every
> test on the following run.

I'd expect the other test would recompile stuff in lib/ but not in
cgroup/lib/, however that distinction is likely lost when $(OUTPUT) is
expanded from the included *.mk file.

> Make the directory order-only, as libvfio.mk does.

Sensible approach given that vfio.

>=20
> Fixes: 2c754a84ff16a ("cgroup: selftests: Move cgroup_util into its own l=
ibrary")
> Assisted-by: LLM
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  tools/testing/selftests/cgroup/lib/libcgroup.mk | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--wz67vp63rqm7k2iu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCarKGQhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah2DgEA8Xdl3JGOJIGtK6hwQh4u
Jb+PcelMIF9Zbpm+LvcVQysA/2EdCxDp5Lq6779UZxftUj9At2iFIuFnLA5vHe4p
ZbcI
=BJVd
-----END PGP SIGNATURE-----

--wz67vp63rqm7k2iu--
