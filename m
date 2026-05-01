Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5483FAE09
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777654387; cv=pass; b=k3qovvQNkv49Ba+ELrmbIKFrqFhbNdQEi7ghSEaartpDvgsUrhhd+WRpgqngOb7Dczjt33dArgV9ehY0e7u+2Xm3HvNRucpOx1mVAHDcPkeEISGIj0SPKJ5CcdWerbANtFIZpWwcHYEpp80UwWnYSG2fKnQeJyWi4o4kSUGEmv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777654387; c=relaxed/simple;
	bh=WSrgqxvCEtEbSAkkq6kSmJHoDqoYrXnYhDZynqlvszA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gh8uSJO36mDSm30BS5PX4tGrAqyWB/5Ho1i9Dy6Xrel+iVLT3Cd/wXo+Tnp+h8K/Cyl3osGdK8+95CJk99sdju9WmN8fEvs/51ivzelVv0sNkgNsZHSig5pS+g4LTcm2ZbKAAfFoIDKqP8MkKizwQybMmb219w+CoU4wZO8P6tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dQ88ukAm; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQ88ukAm"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79495b1aaa7so23992617b3.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 09:53:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777654383; cv=none;
        d=google.com; s=arc-20240605;
        b=B+f8KGnJcxhGDnCQHKzaC5TdGB401RhkiWPQEkipK9D+4rwVZoAmWPQ+cXvKv223cb
         8YBdCSCM5c/BcW0xn80i1IS9sV0d3Il/lBuHg5tg8ERETtEvuB0ASCxSyirQOpLdc9gc
         5pvYidag6hQPxjEF9BxbGYPab20Eqcx0w6eBaRa2RCoCljYSJ1Akt/Tg+6Rp8oCS0bsf
         CWrkD1cDBpl6mgsNdnjYpzY9DXofabvZuwa8anpcvjYu1rGkzNIjTcEZWdEwlDix61KE
         CaAU3elwN/OZNLSqSRDXdUHTYAX7oSoXdI68xPz5XQnrQDTtGF+N2TDA/CfkKa5DL9w3
         UbHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m2pmJ+PIvMF9iZdCIqPnjJW6ZghDHC4WOLVBAyACT7E=;
        fh=gAGWEmAcfp9V6s6kaht9R4ma3yv5t3PbST1Devxo6Zw=;
        b=cKpWpUqSfFcXcFoFyJMI6CvD94PxqqkySNd1V8W9fg9EDsaxTGzOeA6ktnV9ZsF7Sw
         QfFuJ7GQjai8aDBeWkUfjXx6mV6BvA9d76oSrbAIGhUH8lUZQGho+D39KGIjfHyvMMQS
         SPSpQChwF0+r9WGDhTmoArcD08L1MmgCF7LQsjDrH9seF2RirzNVo1XRkAMmXO28i77t
         gUO4bdwjnVL5LUEEMWEcWvn8rxjohAUdakA77bDKYjsm5X+ibqo8ndPnqhDbsLsAgrtf
         xO0NY4xhdFk6gCJqjEN/wi4D/OYXBWnpdR4iibWm3bYeXhC7zHmG1mTXI9cW1Ra/Rt6/
         wXeA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777654383; x=1778259183; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2pmJ+PIvMF9iZdCIqPnjJW6ZghDHC4WOLVBAyACT7E=;
        b=dQ88ukAmeM3pmL5h/qNidcMpZD3wLjxEsF51ii9qlM3Y+aTYpD+DXmPcU12lBZVYbq
         2LQuKOeW+Ko7e4CC60vIRCKnASw3S0ECG1phrWJ6PypDMX3FNMX39/e/6Cux7WzASwZF
         rWBmhNQgPJHRSK3SSZbRBAUujg4hdIXGCZPOqSxhlxLWg3Bq31E4nlHWnSvGKyjoK3li
         lErz8XFOFc7bSfkMNbUlWCO0eEcKChTyQJ61ZVqtLglhoVHYcc6j+B6wOKkd57+OVzO3
         WsfQXkUfEdHVgKQlYMEjBrkMPH9xOT9v2UgyRZXODa5q0VcnPsaiurumWrTRvhz5q4ob
         GUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777654383; x=1778259183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m2pmJ+PIvMF9iZdCIqPnjJW6ZghDHC4WOLVBAyACT7E=;
        b=NpExnBvL+cX1uG29hofDS3JnyyKynB6on8ESZYXjAjTTlvpgGA4aCk+R/theEUXLo7
         aU8TIWBly1evqbJLScH3Wmq50/PwqnvMn+fb0PNa6p8WhiuiZ49YAV5jzvBcYNUwpJZd
         2Mm4llCv/pC2LmttIimxZa9ZHqi40fiZ+jTyUnsCmnIjAT45ij8ST53UGyWJtZSFza+U
         Pls4Cp4F7QM5mUc/vdBXLDIgWEvcS81Ej1S6tg1YM1KL8I30uQwdupkwq/mvmU/CEZJJ
         Tp3CfyzWVRtP/FZcfSAk1gfdM6YdMYGnTVgFdauiF4d08WDHJ/nWqTdspPxs4fVlE3+F
         jEEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+8V8EYC58xo20JKuRSLhJP9FZELIUr0UWR8eqR90IFTTRBJG+mmm3uiLnnp1VIMeuxmqttszQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqxhbsS6uu9l+1HA30c01ojtJrZf+fCT5FZt/FVg8dRgmm8+mN
	0UzKxdRcFtmVTBkS4RdN1/6nBAw5rwOf+Ga1K+yR7YyxPk+bqdDia3cgPxl0ltJxo9Lr0WLsbvl
	gFU+a7hFbSFvI4XBpR8Vc8DGfXaiFE8c=
X-Gm-Gg: AeBDieuM4NAfafphB+okcqfXNFlToSvxf+kHHCE4oK6XAfkeN6Y6teOf15p144ag07Q
	kndjC0eXb9vaLzeDVEaf0aF6exPC1D6XS4IGxrSMP64qN7Xco/fzsMNXvuYqMvXvwiwfd23+bIU
	CzAK3kwAnIHQvUd3EMiiUy/bLRkK0vBUsw7xUrLUgX2/1fqHD7F/HdYpurqGqUpPIn72vjfBGOk
	RdZwPQ1SMQ7njfzztZ02axFts9co80KwUfHYZgwb1AUAq9lDrIEGbTPU2bJMA3dENygzyyIFGCU
	6Gd7esreta4L5mWKSTp8x4UgUJsUSIZBPmfBu4OMf3faEaoOIJIikd/+CoHd9Y+sWt2aQhAi+Ct
	5N9W0AlIlye8WiQak38M4jvjphlpoqYc=
X-Received: by 2002:a05:690c:c4e9:b0:79a:b1e1:49cd with SMTP id
 00721157ae682-7bd77126443mr1403037b3.33.1777654382869; Fri, 01 May 2026
 09:53:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777036497.git.noodles@meta.com> <7734099f5e7fda5480bca016a9e6707983325fbd.camel@linux.ibm.com>
 <afMlgstqahnZg68h@e129823.arm.com> <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
In-Reply-To: <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
From: David Safford <david.safford@gmail.com>
Date: Fri, 1 May 2026 12:52:51 -0400
X-Gm-Features: AVHnY4JVldFvGpRy8AVR9UIjGcDa3SwPwwl5jSipOcT4G7P3qCyc6tJtsxpRfB0
Message-ID: <CAGWfHUW+AX0Hpuw5Vr5iTSaJKQJ+O_4nWWmU1UR8Z_3XFctHZg@mail.gmail.com>
Subject: Re: [PATCH] ima: debugging late_initcall_sync measurements
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jonathan McDowell <noodles@earth.li>, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com, 
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca, 
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com, 
	sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 5:43=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> wr=
ote:
>
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
snip
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
>
> Mimi

I have also run with this patch on a number of bare metal and virtual machi=
nes,
running everything from default Fedora 44 to a version with everything turn=
ed on
(uefi secure boot, UKI with sdboot stub measurements, IMA measurement
and appraisal enabled,
all systemd measurements on, and systemd using the TPM for root
partition decryption.)
I too see only the kernel_version event between the normal and late
calls, if ima_policy=3Dcritical_data.

dave
