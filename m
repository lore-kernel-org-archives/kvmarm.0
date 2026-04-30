Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD7138B14D
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 22:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777588564; cv=pass; b=d4GB53U8S4ip8bQMruKMSOQE0owfE1gZInhReXwXcOQ/diDnF9EVD54/A3trmlK28lwb+exuDosntcqhFRgER4nhR6Zvot2bJeOmElAy+q+wxxWWKc1qr0je1OUbtTHWcStLsQnjp0hwIZlZ8tzyvmFgQTLwTgx5nfy/8zXRH6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777588564; c=relaxed/simple;
	bh=RupXQyAldnCzNNGczOH42PPaEYMriYyLdhvSATo5FwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hLclvJgs03nd/PrOnc6/EzPzexH1SynGc7SAiy8OBc70D7lPeXJenhAFjsJjnleyPOXRTWP7ChPVABCU+2I9Ctsj5XewXohaiyBWnbqX+qc33K/4YeGAgSV47DbifznVML5sqkdZKHYa/isl2ZiqWp80DRemAX4eRvLMqoPC78w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=IJlM7xCe; arc=pass smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="IJlM7xCe"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so1681395a91.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 15:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777588563; cv=none;
        d=google.com; s=arc-20240605;
        b=dnj0eTVjfozQIA8s5aJIcp6q3y6oDJw9jL7BQsEeojMFuqSz6c6zw4gHe0h/Ysls7V
         OiVXkwa1WVsVt8Wng/0gDRVHNx2p14vuJwqyYT2X1xV6gzIF2ihpBdwMG/7iu3KiEXGJ
         UJn7jGM3nWGQ1w8jXr8XWYsv5zfeOgoJmPj9mrVY1EZVOPDEvBi8O9/1TnQEVnUXno2N
         Jc3jX9VPF5OhuAogW5TYEGJe25f3F5KuChrBZTe9A4BDvzP4tWge1FeYAa9NAL2SXAoz
         OwUrIHAmFtSA24hA1KnD9ZrIIxo6wIKCrLgqhVH3d79oefwY7vH0OWyIlIqWAJ4j7koB
         jXrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HdHOWqrJRE/TIxXfheRFRvDV3pWT8VAKvfg7GHpSJqI=;
        fh=It1lo18oc23YfrRHvwUBUKJwaN+Aa6Vq+AmPDRFl1HU=;
        b=FKShFWeoS124izs2J7HOW2SSmPI5GVkDbstC0sFvK/vfYIhvWtr9jluCUgEVsPkTzC
         gFEutQMsciXjsAahipGqHKkZ1oJFODFVysdEmY0kedkTCBThwRBrl0T093qV/hmrCDaL
         bcCuOlj/TV9RxNz0+BePfD2e3PoY28JKxNHGNiuhoh2CwsOSPBEcRDgrFHN3UwuuF709
         awIfgUcVR80AKOwpkaRiGgHln+bLCCImSAml46Wc43jHuiguD+n1F4RJnaDKEI0ggRLr
         Bn3TQSYVyAfrzgIMm0Z4GNqN2jfiUmZ9KPZiElD1gNsqMkOPl9roVlB39Ct5EOJsInYu
         R44w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777588563; x=1778193363; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdHOWqrJRE/TIxXfheRFRvDV3pWT8VAKvfg7GHpSJqI=;
        b=IJlM7xCeBl4gIJWU9zPWaqbDV7fVLXljUttyDwaMGG2XsQ10JhK3zb4sh3NPlPdZck
         yvussYA+TOLlif4bziMKa5qLn+v3KbN1utdGE3VLJdVxMRjwMZbE8WOeh2PK6shXMM+/
         gP36bRJ7+Kfbf4GvhLwtW97o2eneYiGb2Vi5WEDvyeTRW9r4loqhDrYcgNUccY4vki4T
         F0UZ/FgkFFuYldyl8swM/phqncIhB9z71W2XLKrpRCQowUf+7BNy/liTWIQR1FYIQ34y
         emjQiPvRh3BMzJ3O6y+AJNJr1Vb4NzTeCw+cnbHSYj8gGYzdGGrczAPypfcG65ivFZ4q
         V09g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777588563; x=1778193363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HdHOWqrJRE/TIxXfheRFRvDV3pWT8VAKvfg7GHpSJqI=;
        b=ixelMAoKPVVuY6qOcFz9ScPIm9xmeBhUj5bB5tsv4VfqV4C7UXp1ihweoM/YnoXxR3
         O9aVPVS40p/nyWRiTdITLavzAqz9jFEstybX8SzARJ4+KwuFBLHSW5+qCBRlzEfixPNQ
         UrKflBmGCtpwXy5tuwgNYFKy81gTNo//tqSy/u3wU4nZGAQsTMv7hsXs1ozJAtjTej6X
         FR1do6v7AhF4mgBNkLA1buxVXy2Ln5/ikHUlSoQW0M4NW7a8dex5S/lPJvmEVM0pmpU4
         aRxQa2goLoLI8ivJOw/mbiR8/JgJr3vhiyLPf68UdcAbpXNIJJTvEgalA5x6VuLAj1kJ
         vEoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8b3eS3n1MVRo6Y0vckRsHWhxP+XDLTCj+HmXuUffG/i33r61xfaFvL5+SZBBpEbCZh1RsQGyw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyoo2iHgvTSEV2IXeHghKD+ry+V4jXk/0JSK8C/Lo3/SBAXOs9m
	wzOf7BdXsO80n5KGvDBVvSstAosfrtAMpO0jARt75l18IyXCP0q4Nzea7qXje1eMNZ7PU8V6zSm
	DnL5YzrxQj4n+AC3y0PmIvwlz4px5smbmbha0lcqv
X-Gm-Gg: AeBDieu3ZW7xnEUpcAjqN0koX0PkXqoNcnebq9LJZLOj5xqMkua3wwS4MMPZyXg6NZt
	Ip/GTOqZZrcxzKWJ3+r2TztRQpMHkqf7UrKn6KkpR2PKeOIz0b4cA6FhYIK7W1GWsG4Dsl2EGSJ
	6exyOoLJwfAa8yQnDLIqvr8jmlS6vaAW61/GBvxB7nuzE9XXPKdaE7Xi1o2V2arKgumOicNmqrb
	ANw+kFdThJ0z28jz8XHnETlk0cEvhWR73US6hv9f+YXbV1LYqs7izYKx4d699fIcRbLlspjAQ6Q
	y0otIOqNkiupVqDbKw==
X-Received: by 2002:a17:90b:3911:b0:35e:5929:d78d with SMTP id
 98e67ed59e1d1-364c2f0a149mr5141150a91.3.1777588562768; Thu, 30 Apr 2026
 15:36:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777036497.git.noodles@meta.com> <7734099f5e7fda5480bca016a9e6707983325fbd.camel@linux.ibm.com>
 <afMlgstqahnZg68h@e129823.arm.com> <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
In-Reply-To: <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 30 Apr 2026 18:35:51 -0400
X-Gm-Features: AVHnY4LdKYNPArKuQ8yWbQCW6t_Frk0rXn10CBP9XbvLgaV8zkcfCZpOFGUTse8
Message-ID: <CAHC9VhRsnmPp2KmQAns5uq5qXX5EF2xQQzyfTgrPi4O9AXyPpg@mail.gmail.com>
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

On Thu, Apr 30, 2026 at 5:39=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> wr=
ote:
> On Thu, 2026-04-30 at 10:48 +0100, Yeoreum Yun wrote:
> > With above change I confirmed there is no meaurement log
> > between boot_aggregate and boot_aggregate_late except "kernel_version"
> > But this is ignorable since this UTS measurement is done in
> > "ima_init_core() (old: ima_init())" and it is part of ima initialisatio=
n.
> >
> > 1. ima_policy=3Dtcb
> >
> >   # cat /sys/kernel/security/ima/ascii_runtime_measurements
> >   10 0adefe762c149c7cec19da62f0da1297fcfbffff ima-ng sha256:00000000000=
00000000000000000000000000000000000000000000000000000 boot_aggregate
> >   10 4e5d73ebadfd8f850cb93ce4de755ba148a9a7d5 ima-ng sha256:00000000000=
00000000000000000000000000000000000000000000000000000 boot_aggregate_late
> >   10 7c23cc970eceec906f7a41bc2fbde770d7092209 ima-ng sha256:72ade6ae3d3=
5cfe5ede7a77b1c0ed1d1782a899445fdcb219c0e994a084a70d5 /bin/busybox
> >   10 17ec669c65c401e5e85875cf2962eb7d8c47595f ima-ng sha256:dc6b013e976=
8d9b13bcd6678470448090138ca831f4771a43ce3988d8e54ffce /lib/ld-linux-aarch64=
.so.1
> >   10 58679a66ac1de17f02595625a8fbeafa259a4c81 ima-ng sha256:494f62bcfb2=
fcf1b427d5092fafa62c8df39a83b4a64402620b28846724f237f /usr/lib/libtirpc.so.=
3.0.0
> >   10 42f74ee200434576e33be153830b3d55bbe6d2bf ima-ng sha256:a18856b4f69=
27bc2b8dd4608c0768b8f98544a161b85bf4a64419131243ad300 /lib/libresolv.so.2
> >   10 626b4f7bd4f123d18d3a3d8719ed0ae19ee5f331 ima-ng sha256:b8d442de5d3=
1c3f9d1bbb98785f04d4a23dc53442b286d85d4b355927cbe9af4 /lib/libc.so.6
> >   10 655a200869696207646377a58cab417fd35b09d2 ima-ng sha256:ad46146b6dd=
32b47213e5327f1bb2f962ef838a4b707ef7445fa2dbc9019b44f /etc/inittab
> >   10 81353202685e022fcd0069a3b2fc4eaa6b1db537 ima-ng sha256:74d698fe0a6=
862050af29083aa591c960ec1f67be960047e96bb6be5fc2bc0c0 /bin/mount
> >   10 ae64184ee607ef8f3aa08ab52cb548318534fd4b ima-ng sha256:27846b57e82=
34c6a9611b00351f581a54ad6f9a1920b9aa18ceb0ae28e4f7564 /lib/libmount.so.1.1.=
0
> >   10 5ea01f34e7705d1bdb936fd576e2aeb5fd78dab9 ima-ng sha256:3d2a414ec03=
55fcf0910224fb4a3c53e13d98731a35241edfdf4fb911ed9b210 /lib/libblkid.so.1.1.=
0
> >   10 22c48b4853594a08a73ad4ae6dbe6f2c2bebc6c5 ima-ng sha256:e3b0c44298f=
c1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 /run/utmp
> >   10 3024ea5021f8a5d9fb4bd519d599bdca43b7fb93 ima-ng sha256:71ea9ffe2b3=
0e5a9bdceff78785cf281cc41544474db8dc4605a06a597ce1edc /etc/fstab
> >   10 2e7530a0f56420991ac7611734cea4774b92b9ef ima-ng sha256:df4697d6994=
42cfe73db7cc8b4c1b37e8a31e75e01f66a0d70134ac812fa683b /bin/mkdir
> >   10 3ad117a863aa1ed7b7c09e1d106f84abf7d2ae96 ima-ng sha256:c19a710989b=
43222431b02399273dba409fe10ca8eefff88eaa936fa695f8324 /bin/ln
> >   10 4141c82cb516ac3c846e0b08abcd6abeee7efa1a ima-ng sha256:b75d7f28772=
f71715a941c77e07e3922815391dd9cc5718ad21f2231c2da09bb /etc/hostname
> >   10 dfcedd3c7dc3ed42e09219804504489ab264e2e3 ima-ng sha256:dc1615df9f2=
012b20b81ffad8e07e16293039ba7fd897854ca3646d6cfea0c0f /etc/init.d/rcS
> >   ...
> >
> > 2. ima_policy=3Dcritical_data
> >
> >   # cat /sys/kernel/security/ima/ascii_runtime_measurements
> >   10 0adefe762c149c7cec19da62f0da1297fcfbffff ima-ng sha256:00000000000=
00000000000000000000000000000000000000000000000000000 boot_aggregate
> >   10 49ab61dd97ea2f759edcb6c6a3387ac67f0aa576 ima-buf sha256:0c907aab32=
61194f16b0c2a422a82f145bc9b9ecb8fdb633fa43e3e5379f0af2 kernel_version 372e3=
12e302d7263312b // Ignorable since it's generated by ima_init(_core)().
> >   10 4e5d73ebadfd8f850cb93ce4de755ba148a9a7d5 ima-ng sha256:00000000000=
00000000000000000000000000000000000000000000000000000 boot_aggregate_late
> >
> > Therefore, init_ima() could move into late_initcall_sync like v1 did:
> >   - https://lore.kernel.org/all/20260417175759.3191279-2-yeoreum.yun@ar=
m.com/
>
> Thanks, Yeoreum.  It's a bit premature to claim it's "safe" to move the
> initcall.  Hopefully others will respond.

Is it not possible to look at the code and determine if it is safe or
not?  Or is the initialization of TPM devices at boot done in a random
order with respect to the initcall levels?

--=20
paul-moore.com
