Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308E737C0F1
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777826797; cv=pass; b=vFHAPjXEqlo4oBBj6kij19lldYnomLoKebtG1iKDgQb+7ALpuIp9HPipb2PxHxMfl6LLI57l9gFToQwPNP22nhSflZXBwJEBSkLSOJhWjnZyJf8BezuMQVxwjHYXVgzAf1ApnPfzxR+cb71Qz53hHuPDuIIllGDHVmzLDsJwKjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777826797; c=relaxed/simple;
	bh=YM2w+8iga6X0KGUCUEQ+IcUBubK3K3glecWKuCK54Y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fnjbTluk2QQqlVzdsUH00c011iLtsYRW4tPE4wunAQnqRwFgxJ+f1g8qbKUO0sD1X3EuRBWRW2ZFQbM4Y8ePqt6eRo5+j87SxH4MatDzfUwwbjFqna5ObwsIK3YogD4CgcL8JU8/OO232xbnXLUGXHWcTqcD/EcPm2X956VVxlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=O7mirwxh; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="O7mirwxh"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-365313b86bfso295118a91.3
        for <kvmarm@lists.linux.dev>; Sun, 03 May 2026 09:46:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777826795; cv=none;
        d=google.com; s=arc-20240605;
        b=Fmy6Lg43cIzrp3ACtR0EYmI3V3l7JSGIdR9e8VDgjngMC1GOI79ELAb4YdoMAZKUet
         O15Qk4a99BDcCQzmU8yNoJ+9FGvqzQrgSdWWIBa4rJktBse0SxCSOhjZvQsi5eVzXRa6
         3Hh/CjEA9340KuO2zcCm6YyEgV8CYHQY7/fITVWU8P5mrtmbxoIM3QbtfviHewUYYRw4
         0kKuqMCC7PVOwcvdUF8NlmSvxdU2ErCGizikxVgBYwDn5vlEZ0ntfhn/9BTwndB1lg/5
         GPmIS4iaOs0I1PFmyR6gr2Y1E6LYXWs2eJvPxsge+zTCVxuAgjieHYiqceGHXDyGzRZ5
         8oig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lV+PWS6h5YsTugRvYXVkVMVA3Y637YXU6QnwmmlucsU=;
        fh=9Yr/LpOGLfqGfFaG56C6/a2+NwoNa86Tx7IRyLdcJME=;
        b=ZfvbuoyL/35BM4Cv0NWiK1SdHaj6FlaEmQR2uBYrd81/ATpxifG7oN3T8FxrcGyTIm
         XSeCsPfH5e+U0PIm3HRrM9umD0YFZV0gphARMTAGXeYi7aWCQJqoMAeIs3PEXvmX+Tbb
         /WtuaDZJjuKbaj99zcdXFsj4mVVjHVyUjejuGxJmz1oM62HfUGV4DkuSaAjC6W6h+tHO
         8XKZBQRqmAdWYBUQHRUcNuB06gv07MvFwXT+AUXaRe5jbvM0u2zTOlm7fBObBOtu9DQs
         +TmjSGtk3ad89cfCZTBztQNTI2/Y3O+MDyJYDKaOB1ReObGwXbpLdyDyV1fNdeO0IIYl
         leHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777826795; x=1778431595; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lV+PWS6h5YsTugRvYXVkVMVA3Y637YXU6QnwmmlucsU=;
        b=O7mirwxhKoGHdF7qwcn6tB1O2nhIu69d+7+TMdOYEi14IHFdRsrzTtMHsXUaXurhdW
         g1mESP+rsjWRaBMfteverf7JIG1yhr8BFL0lIfgrfq/JaDj2MJ0BAr0WZfsUYbff37nM
         94/OVg4MMxvU+8Doyn/OQdQHJGYiq1IZOzrYVgzluab/GHwld9n9z6aUkgbZF3r5g++Q
         E0NItFpbHQRpxgJx6+5Vor1EQ8vWwVUsDTRiT1B65Jud1o9Rz+wsgeV/bvc2ippgbxiX
         P6HJfZxxj/9cIKoxYWIK1pToG064/snK7R7i88zajaFpwsFHhxE97GvGDseZv5RtQDYf
         05Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777826795; x=1778431595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lV+PWS6h5YsTugRvYXVkVMVA3Y637YXU6QnwmmlucsU=;
        b=hgj2vLpE0A5mA/CUJ7B4zKqhB+Xr+JNNN6FVhLz8fRFdAoHkznTyPFCQf3bRxRxyM+
         7kxHTHtyCSMJcvk82xkXCaRB7ORkoR566PJ9foIdmEyRGooCZZv8F8BPgNaKNot2Gnc/
         LFQSvNS/wvhnbKNuc3aBXukuY2OeLd3QsMZm3Dm0f2DFJG2FQ/HT/GDv8QGPd5t60JD5
         cSEMevUghiCirZtpizx8NqqcKu/2k8Gq0nPOKqF4d1OjBN8I5mPRGUqA5dP20kOjqHi0
         utYp54M1RpZgfR/fwhE9Fc//suKvV39m7YJesujL1Z1K8Z0wQmadc/xMvObI8kbtNXhA
         cOyg==
X-Forwarded-Encrypted: i=1; AFNElJ9uR6KUAkGcTBE0K+eeg4gkNolgTWqag4DrZwYoXUKBMJcP281ha4Q/h6N2kWTBzinGe+4QszI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTKyk6/qxJpCejTGZtf1rI9A9czFa9S/1lMz2sy7FlVf6r1ETs
	YuQUY0sBqD5Jp8Zgo3bvYt7EUphlgqXCNDk74Z0NcYZyqP+YgMQbwskHPTVsMA1EfFqZeQ0VIFV
	THod5LD4PugLoBbag3ms+hR0mlnIYMJrJS8cCjwMU
X-Gm-Gg: AeBDievkUSXWYDEdzhvfqgYCd0DEDsG+yHqDOWVGMVjN0cf1RstWThyka9j1dDvVCgU
	OrkpGRV/z2il7exKFj//co94zGlXbJAKnsnRRJDoGVqw4xL+uvQ5J8KegA3mb1G31j+EoxkIYE+
	JfSIUS2CMQW3Xwebm+dGdAInNBzSdPRp4f6D8hOAePMPKF9tXvnzaRbzaN5DLjaSn5i0tu0EXQu
	qDJrtEsdjELcC1aI0anTWtGnKl6nGRt7K6Wa8b97gcqyR53UMg/BWT5/EZTO/NVWrI9HhzlJf6b
	8tt5DUSYfAlFkenD8u8/znVtgTtJ
X-Received: by 2002:a17:90b:3e46:b0:35e:5ae3:298a with SMTP id
 98e67ed59e1d1-3650cece2d0mr6631879a91.18.1777826795343; Sun, 03 May 2026
 09:46:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777036497.git.noodles@meta.com> <7734099f5e7fda5480bca016a9e6707983325fbd.camel@linux.ibm.com>
 <afMlgstqahnZg68h@e129823.arm.com> <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
 <CAHC9VhRsnmPp2KmQAns5uq5qXX5EF2xQQzyfTgrPi4O9AXyPpg@mail.gmail.com> <ba4bf28314b679474a6a8da6298e548e54b3754c.camel@linux.ibm.com>
In-Reply-To: <ba4bf28314b679474a6a8da6298e548e54b3754c.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 3 May 2026 12:46:23 -0400
X-Gm-Features: AVHnY4L2at1Ee87namZ-f-yBAzCWpTyJONd_xc3EwssaGjpCZndG6MYs1AyLIxg
Message-ID: <CAHC9VhRE2kRr1fdDf6xgQgpSrtvqtP8Vy9LVGJhDZFUbzLKGmQ@mail.gmail.com>
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

On Thu, Apr 30, 2026 at 9:51=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> wr=
ote:
> On Thu, 2026-04-30 at 18:35 -0400, Paul Moore wrote:
> > On Thu, Apr 30, 2026 at 5:39=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com=
> wrote:
> > > On Thu, 2026-04-30 at 10:48 +0100, Yeoreum Yun wrote:
> > > > With above change I confirmed there is no meaurement log
> > > > between boot_aggregate and boot_aggregate_late except "kernel_versi=
on"
> > > > But this is ignorable since this UTS measurement is done in
> > > > "ima_init_core() (old: ima_init())" and it is part of ima initialis=
ation.
> > > >
> > > > 1. ima_policy=3Dtcb
> > > >
> > > >   # cat /sys/kernel/security/ima/ascii_runtime_measurements
> > > >   10 0adefe762c149c7cec19da62f0da1297fcfbffff ima-ng sha256:0000000=
000000000000000000000000000000000000000000000000000000000 boot_aggregate
> > > >   10 4e5d73ebadfd8f850cb93ce4de755ba148a9a7d5 ima-ng sha256:0000000=
000000000000000000000000000000000000000000000000000000000 boot_aggregate_la=
te
> > > >   10 7c23cc970eceec906f7a41bc2fbde770d7092209 ima-ng sha256:72ade6a=
e3d35cfe5ede7a77b1c0ed1d1782a899445fdcb219c0e994a084a70d5 /bin/busybox
> > > >   10 17ec669c65c401e5e85875cf2962eb7d8c47595f ima-ng sha256:dc6b013=
e9768d9b13bcd6678470448090138ca831f4771a43ce3988d8e54ffce /lib/ld-linux-aar=
ch64.so.1
> > > >   10 58679a66ac1de17f02595625a8fbeafa259a4c81 ima-ng sha256:494f62b=
cfb2fcf1b427d5092fafa62c8df39a83b4a64402620b28846724f237f /usr/lib/libtirpc=
.so.3.0.0
> > > >   10 42f74ee200434576e33be153830b3d55bbe6d2bf ima-ng sha256:a18856b=
4f6927bc2b8dd4608c0768b8f98544a161b85bf4a64419131243ad300 /lib/libresolv.so=
.2
> > > >   10 626b4f7bd4f123d18d3a3d8719ed0ae19ee5f331 ima-ng sha256:b8d442d=
e5d31c3f9d1bbb98785f04d4a23dc53442b286d85d4b355927cbe9af4 /lib/libc.so.6
> > > >   10 655a200869696207646377a58cab417fd35b09d2 ima-ng sha256:ad46146=
b6dd32b47213e5327f1bb2f962ef838a4b707ef7445fa2dbc9019b44f /etc/inittab
> > > >   10 81353202685e022fcd0069a3b2fc4eaa6b1db537 ima-ng sha256:74d698f=
e0a6862050af29083aa591c960ec1f67be960047e96bb6be5fc2bc0c0 /bin/mount
> > > >   10 ae64184ee607ef8f3aa08ab52cb548318534fd4b ima-ng sha256:27846b5=
7e8234c6a9611b00351f581a54ad6f9a1920b9aa18ceb0ae28e4f7564 /lib/libmount.so.=
1.1.0
> > > >   10 5ea01f34e7705d1bdb936fd576e2aeb5fd78dab9 ima-ng sha256:3d2a414=
ec0355fcf0910224fb4a3c53e13d98731a35241edfdf4fb911ed9b210 /lib/libblkid.so.=
1.1.0
> > > >   10 22c48b4853594a08a73ad4ae6dbe6f2c2bebc6c5 ima-ng sha256:e3b0c44=
298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 /run/utmp
> > > >   10 3024ea5021f8a5d9fb4bd519d599bdca43b7fb93 ima-ng sha256:71ea9ff=
e2b30e5a9bdceff78785cf281cc41544474db8dc4605a06a597ce1edc /etc/fstab
> > > >   10 2e7530a0f56420991ac7611734cea4774b92b9ef ima-ng sha256:df4697d=
699442cfe73db7cc8b4c1b37e8a31e75e01f66a0d70134ac812fa683b /bin/mkdir
> > > >   10 3ad117a863aa1ed7b7c09e1d106f84abf7d2ae96 ima-ng sha256:c19a710=
989b43222431b02399273dba409fe10ca8eefff88eaa936fa695f8324 /bin/ln
> > > >   10 4141c82cb516ac3c846e0b08abcd6abeee7efa1a ima-ng sha256:b75d7f2=
8772f71715a941c77e07e3922815391dd9cc5718ad21f2231c2da09bb /etc/hostname
> > > >   10 dfcedd3c7dc3ed42e09219804504489ab264e2e3 ima-ng sha256:dc1615d=
f9f2012b20b81ffad8e07e16293039ba7fd897854ca3646d6cfea0c0f /etc/init.d/rcS
> > > >   ...
> > > >
> > > > 2. ima_policy=3Dcritical_data
> > > >
> > > >   # cat /sys/kernel/security/ima/ascii_runtime_measurements
> > > >   10 0adefe762c149c7cec19da62f0da1297fcfbffff ima-ng sha256:0000000=
000000000000000000000000000000000000000000000000000000000 boot_aggregate
> > > >   10 49ab61dd97ea2f759edcb6c6a3387ac67f0aa576 ima-buf sha256:0c907a=
ab3261194f16b0c2a422a82f145bc9b9ecb8fdb633fa43e3e5379f0af2 kernel_version 3=
72e312e302d7263312b // Ignorable since it's generated by ima_init(_core)().
> > > >   10 4e5d73ebadfd8f850cb93ce4de755ba148a9a7d5 ima-ng sha256:0000000=
000000000000000000000000000000000000000000000000000000000 boot_aggregate_la=
te
> > > >
> > > > Therefore, init_ima() could move into late_initcall_sync like v1 di=
d:
> > > >   - https://lore.kernel.org/all/20260417175759.3191279-2-yeoreum.yu=
n@arm.com/
> > >
> > > Thanks, Yeoreum.  It's a bit premature to claim it's "safe" to move t=
he
> > > initcall.  Hopefully others will respond.
> >
> > Is it not possible to look at the code and determine if it is safe or
> > not?  Or is the initialization of TPM devices at boot done in a random
> > order with respect to the initcall levels?
>
> The TPM is normally initialized at the device_initcall, except when other
> resources are not ready.
>
> (Abbreviated) AI explanation:
>    If the TPM's first probe succeeds at device_initcall with no deferral,=
 IMA
>    finds it fine. It is only when the TPM is pushed onto the deferred lis=
t that
>    late_initcall can execute before the retry succeeds, leaving
>    tpm_default_chip() returning NULL.

I really hope you are using AI only to phrase a response and not as a
substitute for actually investigating the code and determining what is
happening.

Regardless, assuming you always want IMA to leverage a TPMs when they
exist, your reply suggests that using an initcall based IMA init
scheme, even a late-sync initcall, may not be sufficient because
deferred TPM initialization could happen later, yes?

--=20
paul-moore.com
