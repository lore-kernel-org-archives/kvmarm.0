Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4E32ED39
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778021760; cv=pass; b=nJLoLNOLqSFGn3dHhaZx4XgpopViFIyWwn7qjbUnCRkz5FHBC0VG8/UT2n0tCC77C3N+bqae5gJ8xPg+Qs2/R0U7nwmX8DnrmdV7WNFBtk7GI+2uJ301AMnYgZbvZPtjsSNDzwtIr+/EjEB2fIxEQSgZMvA4DYvUZqZDfIsW2qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778021760; c=relaxed/simple;
	bh=jp0ufABEKNNQZig+P4OStv7rq3Lf0B6nVuGfU3anl3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PKpY6c/BwyI6HSNZomRZ8tGRCoNsc3WCPlirEjzn4bl1lZF8AEu03poht+gN06eBfvyl/MEfUOkYE7/ZC8+o0Q+VR/va8Zo8LFjVohVGcSg+ixnvItxGleDPH+hO0LWFTaPXoyfDRkxMQRnQGJ5IeDKoo8yQfM055yzHM0p5HDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ErvKhqcy; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ErvKhqcy"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so572332a12.1
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 15:55:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778021757; cv=none;
        d=google.com; s=arc-20240605;
        b=QJc+0WiKfqFgnCoGzMpkzX8YNolHu4NGKQ9Y2DM62iJeQg/rrAA0fn8VJFvI1F23Hb
         imRboUXXxFItWQ6dF85zsRJUXQZXkPnuj6pJzoUS1NBEYz1JNgaKwv48/Haez4ohLY7i
         9lh9hUNDXX6YVi4Rc6yvDrfG1yPy1OoAzSwb73pTa464L1nMyG36PiTZWHdcQNpw3RIj
         fAnNJWGAXB+r4kuuWYYRGrBXkTfDfh39/QshK7Nc4Vp76nv7p4IPShe8Pv99wtbNZ56W
         9c9xcaSwQOMkDuPdrIBwo8z/8BmUEX25B/+iIx4d4PNhkBXKc4/ZvWoccactO7CBZ5Eo
         Uf0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=igXYnTt1y5W94mwyAvmuGSDvQ0T1atQGMaOaIv56W9Q=;
        fh=2VkU6vAjZftoa8S9MTYPcp+wuTzTpBrRDB0qeVJ8KoU=;
        b=Q98N2RJfhMCKojv3P8Yv3p5zxXMEEGQpsKPnZQy3sy1G9Iyhmln3pcsmNqgqUA2nG0
         JVEII3hvAe5eLZusd0/VHC3A5butFYoFMnqbYj7it/TLbpOsVvvDfRLCXkGx4fGVUJQd
         Y7V6JRYKgJ0nqE1UCSTb8/PZ5NcLsOJxlI+mqc0wAdlXuzc+0V4k2k+MyOlIkg8lhzJk
         v1lMhC5JVClEiMMGUIJuzaz5KTy7pRPMQWUthPQ3XxLpU7D62lkpyDTlgujVT8asgCb9
         uaCt01qK9Lcvy1+ocKPBsBEaAARJEVXuAlqQyshHOrxWQlHXLFNDeHgGAz7+dSpG8Fho
         9o4w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1778021757; x=1778626557; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igXYnTt1y5W94mwyAvmuGSDvQ0T1atQGMaOaIv56W9Q=;
        b=ErvKhqcytu3d9cvs3pkFbQp5RLr1ALNaAc28ix9T+dyfSr+5wuyj1ee8zzH2355eRi
         cr/KUQM/Od/ZbNQqq2aXbiBptOf8oP6dSbdJFhgCq8o3OcKt9suPTjVc6Q1mKs7gST6g
         s0ubnU+1vDJtrqdbuP9Lmwv8BwK2UWJHunHvs+JPJ3wRgTNBwhKweoUGA3YFPKtpOuj6
         +mR9YI4T8x+RNd2xpnmoKOawV1Hap5T4alaPBuqEysHuK3PpCI17Q+SzYTEVQT7DeiED
         FLoMDlfN5Gypr4/hdrrWV4Ag384xCXCRzjezumIs0U+d3LiQFk+JVgohpJRVfA2D2bV1
         cj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778021757; x=1778626557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=igXYnTt1y5W94mwyAvmuGSDvQ0T1atQGMaOaIv56W9Q=;
        b=JfZ38jiDdfb85K2OQx2pwgVU8tSA9TVUG/+Z/tZTEDw5XzUmgYvFMm+k2m2XptHEHi
         ETinx8spMRQ7uYkUOPm4e8pGEj36Eb+4SBMk1SYIid68Z6aGknGSPghcRo3KbciAlpFR
         AsYTDgrgN5gBlFPPzXMt9STxbQiI+hVTcLtpoSrFNKNzMWcrupAp5LpKhtXxE06txYU5
         od6YZR00pqI3ZrRMWMW0LF6XWE6ZQ6F9tk/u2SV7bDyjWAQdfyCmBvnZ756jxnUJ8XKn
         8ilvPSS9/aFH8ZiGqeKcoOwNplEMTGJ0TtiDnVwSIHSMImKs6xsq+jTrsumIYx6zirmO
         /ulw==
X-Forwarded-Encrypted: i=1; AFNElJ9Gv7ZHFjGW4NhoHiKBJivxyfb6CjgKUFwszOO4aVTLFZs0ZE4nlfJBnRA6eNc2V0LiVXSb3Ec=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywecbak6X1wMvG0muVlCmgBGlg63JQQLSCWSEWfi5Erx0WH9xMT
	7urINGwNAbrkr1W9J9sfZhQJTFbasE/KtMHAqpdaETLMGEG6Yzn7F5I2aI6wwoZCT7cTmPUTeOM
	fzTipHK4YUvXu6pTppciyJ/vktWY9sBagMQtDepfQ
X-Gm-Gg: AeBDiet+aIoiQwh6O3AFhpypUT3LTkUL66mE7DdQxNNXyDLTPTgKNm75FVdFnGSJYCA
	YriDKAV5BHDHDv2MamZOsJknsLeErVCkmdzdkIZAp1hwnrCZa+GaJ5ZpniJ0x7hl/zIAn0qgarN
	H61tS/GhmJHc1omnKTO9fJ2yeNy4izvqdt4wGbbdHYTJe/cgwdTnKvO8BOrd+8RxN7NRNm252oY
	B6MTrQChuj+DyX0OYqt6UOxA9shcVp/izRAmxcBAu/JcyYrwhf6eRBRi9cjTC2UviRXXjMgrvsY
	Jta/pzBIkubU+gApkTfkBfRsbJef
X-Received: by 2002:a50:8d89:0:b0:67c:a9cb:d85 with SMTP id
 4fb4d7f45d1cf-67cc392dbd1mr2021608a12.11.1778021756772; Tue, 05 May 2026
 15:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777036497.git.noodles@meta.com> <7734099f5e7fda5480bca016a9e6707983325fbd.camel@linux.ibm.com>
 <afMlgstqahnZg68h@e129823.arm.com> <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
 <CAHC9VhRsnmPp2KmQAns5uq5qXX5EF2xQQzyfTgrPi4O9AXyPpg@mail.gmail.com>
 <ba4bf28314b679474a6a8da6298e548e54b3754c.camel@linux.ibm.com>
 <CAHC9VhRE2kRr1fdDf6xgQgpSrtvqtP8Vy9LVGJhDZFUbzLKGmQ@mail.gmail.com>
 <ff28c6dcb60c357c752724927addaa8c4fd3bf2c.camel@linux.ibm.com>
 <CAHC9VhQY2TMkTvQq9P8oZteQWQSr7qq2utOuH+pdVx+8jWLBCw@mail.gmail.com> <a9412fe10e70ce95dd70556ace19368bec5c188c.camel@linux.ibm.com>
In-Reply-To: <a9412fe10e70ce95dd70556ace19368bec5c188c.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 5 May 2026 18:55:43 -0400
X-Gm-Features: AVHnY4LjwHbGYu80nNIZo2bt6oowEdScIKVunh9rMqRrLydWrBO3U9oWRNn2sww
Message-ID: <CAHC9VhRUgNA=Sj=jhD=zOt8R80Q+FQj+H0nYSy-FAujTL3EKPA@mail.gmail.com>
Subject: Re: [PATCH] ima: debugging late_initcall_sync measurements
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jonathan McDowell <noodles@earth.li>, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, jmorris@namei.org, serge@hallyn.com, 
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, 
	jarkko@kernel.org, jgg@ziepe.ca, sudeep.holla@kernel.org, maz@kernel.org, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	noodles@meta.com, sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026 at 5:05=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> wro=
te:
> On Mon, 2026-05-04 at 16:51 -0400, Paul Moore wrote:
> > On Mon, May 4, 2026 at 8:03=E2=80=AFAM Mimi Zohar <zohar@linux.ibm.com>=
 wrote:
> > > On Sun, 2026-05-03 at 12:46 -0400, Paul Moore wrote:
> > > > Regardless, assuming you always want IMA to leverage a TPMs when th=
ey
> > > > exist, your reply suggests that using an initcall based IMA init
> > > > scheme, even a late-sync initcall, may not be sufficient because
> > > > deferred TPM initialization could happen later, yes?
> > >
> > > Well yeah.  The TPM could be configured as a module, but that scenari=
o is not of
> > > interest.  That's way too late.  The case being addressed in this pat=
ch set is
> > > when the TPM driver tries to initialize at device_initcall, returns
> > > EPROBE_DEFER, and is retried at deferred_probe_initcall (late_initcal=
l).  Since
> > > ordering within an initcall is not supported, this patch attempts to =
initialize
> > > IMA at late_initcall and similarly retries, in this case, at late_ini=
tcall_sync.
> >
> > Okay, so from a TPM initialization perspective you are satisfied with
> > a late-sync IMA initialization, yes?
>
> No. On some architectures moving IMA initialization from the late_initcal=
l to
> late_initcall_sync does not miss any measurement records. However, as pre=
viously
> mentioned, Linux running in a PowerVM LPAR the move would drop ~30 measur=
ement
> records[1].  So no, only if the TPM is not initialized by late_initcall, =
should
> IMA retry at late_initcall_sync.

What do you do in the PowerVM LPAR when the TPM is not avaiable at
late initcall and you have to defer IMA initialization until
late-sync?

--=20
paul-moore.com
