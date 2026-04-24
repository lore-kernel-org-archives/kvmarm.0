Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B734251B
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 21:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777064946; cv=pass; b=H30zXAr+ElCZye/m/wJMWsnUY91YlCNIIcOC3dKXDzsH/Zlr7rOz3GnXUwIL1jjBiYOWW0Xlw7WLmcuA0sQiC9BRZSXAJlxnBzspb3f+mHKhh1I/MHHc+q0b7v2MUNKw4eBuuGLjctjr1JU8o5ss77IJiagEwRWDOe+a7XmER+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777064946; c=relaxed/simple;
	bh=zeoP/9P2pLhahz91nxn+4EYf85rGHyQaiFHaei/lRpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PQPM6z/PE26vlsgijDwIWQVAa6mAxg4wpjkVLHuxqWuIfusOKOlMGBX5kg3uoFWMbhvC0/sfQsAVwZXAIZ+KMuFkzfhSWcvuggTNPp+ZwfyL5U6W7t6CCzPiyNbffi7GzvWT1MDOU7hAuR8olOhnv1Au24CEcWscanwJ6+wUks0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=fCO/vddy; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="fCO/vddy"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8296dabef74so6976705b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 14:09:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777064944; cv=none;
        d=google.com; s=arc-20240605;
        b=BEbHpd3UP4d0zDoHtHSwRXUDdkd7IiHWP/JneyL+Af3j9PZKf8VeEsF0QRb9zjMdR4
         tjo0jE0W+XSfyjqsGDmvPy42Y5+LfxT5lxiW7gRTkQy7dMgGkcRSLu2oHBB264YLrx/6
         AgyAwIlb9ZdCPlrbqDVdU4oKr568p7dIPozSfhzpfuRztg2NBeQC8Bqv4gUFF0t5Zmlm
         WY5cAIXstaKOj/SaiqBDlWHasyC8P4+9J4xCU43dyvszb6DKAGBXXlT9m3AK5l5wOw8B
         8SmDcU2VTyHsvVQtzBbDfcKVFyc55xcV19d9WgWSiwJ4t2nHbQiN0OQBISmoWdjD6FP3
         kf/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n1d+xjduzAM/MSTs6YplaFj6vz27O1vUoV9FGHND4Bg=;
        fh=PpFNktkSDI7XIZl9XtwXVcq6H0NBjRptS3dXpGSr0qs=;
        b=Snc8uRC/1ujrpuTIWZkgRMnZjGdi+BeTgaDqC8gSVUHSSo3LY8EtoEjZWRVmOKlUpO
         NKC+gFMjDkOU6DzIdNOuoAdbwqOAwnePoi4l1hJxaS0ko5CxATNWPA13fRivyjbMh4ro
         j8ItB8GnrZMsg50wUtqWMdmf1ARFB2HafEF+8vK8N5bLpeL8mcTuUVGGVnybxrGRq/xg
         hnbzIqI8It5zNlVH1OtKwvPaKypLT5pa8BHApCJ21fV7LYxbMcvbI22Kt4L3VsVWFQHB
         J+4LZmvJ4XZ5siZ23Z2Fmk/y07JmR4Mwvn7HSu1nMB0BUqJihY3T4apJyPzEqSQwd/rG
         6wiQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777064944; x=1777669744; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1d+xjduzAM/MSTs6YplaFj6vz27O1vUoV9FGHND4Bg=;
        b=fCO/vddyXG/GvFPmF10LePXWmbbzzOOJddAnCIaDNLcKy1O4dNHWcePZExPurngfTm
         s1y/TiG/EL3qvAvhzWsipun4UtQp+UTcgtDMqrcE8uA1nv3HxJJpSh7seKvmBsQLq+F2
         I8wLjlrpUhfI9Kx3l/gI2T2pIsVyBrdbRQfAtwZpImmvr2zMQqk0gCpPjs2bpOMHeFDR
         LuW3S8wnrGTor9P2jG5kEuuCEBYYp72EeYGl9pijIt1Bz/7kmN8XWOnOiNjso0u1aPDe
         XnjRqIDve5jSYQpSm31sN/8GsMtvuerTZGGJs7rVkRZXH3eB7ngaWyvhooPVe0geTdl6
         K8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777064944; x=1777669744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n1d+xjduzAM/MSTs6YplaFj6vz27O1vUoV9FGHND4Bg=;
        b=WhjhFK6SC92IiPLUVjTihl/QWB2jAp47bWNJhYI8dRjONz8c2K+awChf0MLUIh0sV/
         ZM6yRwJDlntdK++LvoeOm2cmacU5M4l+Ty+88Gv9Rlg968vArmIiTeOzlsHBngLzdSj9
         jSTUoEiHQ/GzINyWIw4+RATly74lYwEpOQc4qcG9nqzqZxelPUpQREUHB3tnvtUSl2YD
         tTKXSI+RlBc2vDQ95ZxIRzhRCEBc5pVbg9Rve1+PMbjrrE1EPYXoOuUdJWgg8SWRqnHH
         TP11/Pgkr+Qy0UBzEFoRfaQ2xlYi6sgXbeca51ESh1bwFqk0AFQ4MPJaPcif+bTd+opk
         w3EA==
X-Forwarded-Encrypted: i=1; AFNElJ8aGX2l/BA6+Y7VN/ehmM7b2rQqCLc+TffRjo6rDBsMySKW102duDkEAarSe/h5iHKpQTq0g18=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoE1QPxg6gtEFBH9GeoUvllDERpp9zLd6lE/po/f6uNIbeJb/2
	+4H2fQAqcGFqY7+a8eizXFVbLGd+TmeA+xdSG9JUg62GUipRYjk2CEAZHtmedbPP3Sr/rSGdli7
	/E25cxsax1WjjpHWqXSo5yQi7igZZeLk0mam51O0J
X-Gm-Gg: AeBDieulwUGty0MUEX0T+Bo3LO7B3pcrZO7JT0APUgRTEm7gJ9HEjThI1etwkzrvJL1
	crSBVDn8SXK8yvQrmZWART7jdmC571oQJsgemG5qyJZXUvQa+QtTk8PrFmayQ1EQD4hkDNEtAPs
	5K5VhsJcb7WJ90nwVdVT4HC04Bx9WsoKGwPvW87cxf3PnE4uWcUtyJQhyQAymLBkQYKKOhC60rA
	cLgD9yxseaxtaDWEj+ycFpwnm6PdsxGTofY3zUVivvVxmpbr1qnI+xnzf3fi84/vXhRW8KJ8j04
	d3UsCWG2Avriwz7Bhg==
X-Received: by 2002:a05:6a00:b4b:b0:81f:3f03:6846 with SMTP id
 d2e1a72fcca58-82f8c97b854mr34295308b3a.47.1777064943538; Fri, 24 Apr 2026
 14:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aeoAlVEwzRUPrlVe@e129823.arm.com> <aeoRxWPyOHGJd+Jh@e129823.arm.com>
 <aeoWO2Cwo04YYu2l@earth.li> <bd908e28298d968740d03c97bc7e441de188b7b4.camel@linux.ibm.com>
 <aeokwrC86WI7uT+K@e129823.arm.com> <aeomlp3I0eVE5mce@earth.li>
 <aeotq8nPVu4wvEx5@e129823.arm.com> <e4e242ae5533d5762a3647186a178764881bf9ff.camel@linux.ibm.com>
 <aephL3MzYoqFGaT5@e129823.arm.com> <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
 <aesGU8a3mbVzvteH@e129823.arm.com> <CAHC9VhSaT_quKYnpFjAfqvL07JNbWMgM6c4pB9F46NHawX3DCA@mail.gmail.com>
 <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com>
In-Reply-To: <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 24 Apr 2026 17:08:51 -0400
X-Gm-Features: AQROBzD9P2TWOpZi4hSjY4N4Nov3CnXh30sPXe4h_cg3LpJPQQpo1U__Q_DVo84
Message-ID: <CAHC9VhTW3=RJ8L91RWXYYA9tFjfSXGN-DMEEwdiD6big9H57Ew@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, roberto.sassu@huawei.com, 
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

On Fri, Apr 24, 2026 at 4:58=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> wr=
ote:
> On Fri, 2026-04-24 at 16:15 -0400, Paul Moore wrote:
> > On Fri, Apr 24, 2026 at 1:57=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.co=
m> wrote:
> > > > On Thu, Apr 23, 2026 at 2:13=E2=80=AFPM Yeoreum Yun <yeoreum.yun@ar=
m.com> wrote:
> > > > >
> > > > > Sounds good. Once the patch is posted, I=E2=80=99ll review it as =
well.
> > > > > Sorry again for the noise, and thanks for your patience ;)
> > > >
> > > > My apologies for not getting a chance to look at this patchset soon=
er.
> > > >
> > > > This seems like an obvious, perhaps even stupid, question, but I ha=
ve
> > > > to ask: if IMA can be properly initialized via late_initcall_sync()=
,
> > > > why not simply do the initialization in late_initcall_sync() and dr=
op
> > > > the late_initcall() initialization?
> > > >
> > > > Does any IMA functionality suffer if initialization waits until
> > > > late_initcall_sync()?  If so, it seems non-critical if waiting unti=
l
> > > > _sync() is acceptable, as it appears in these patches/comments.
> > >
> > > This is the way first patch did, and here is some discussion for this
> > > (Might you have seen, but in case of you missed):
> > >   - https://lore.kernel.org/all/a6a0e15286c983d720de227c6827adbe976c5=
b9b.camel@linux.ibm.com/
> >
> > Thanks for the pointer.
> >
> > Unfortunately, my concern remains the same: it's either "safe" to
> > initialize IMA at late_initcall_sync() or it isn't.  Attempting to
> > initialize IMA twice seems both odd and wrong.
>
> Agreed.  However, IMA should be initialized as soon as the TPM becomes
> available, not delayed.
>
> In patch 2/4 patch description, Jonathan describes the reasoning:
>
> Unfortunately some TPM drivers (such as Arm FF-A, or SPI attached TPM
> devices) are not reliably available during the initcall_late stage,
> resulting in a log error:
>
>   ima: No TPM chip found, activating TPM-bypass!
>
> and no measurements into the TPM by IMA. We can avoid this by doing IMA
> init in the initcall_late_sync stage, after the drivers have completed
> their init + registration.
>
> Rather than do this everywhere, and needlessly delay the initialisation
> of IMA when there is no need to do so, we continue to try to initialise
> at the earlier stage, only deferring to the later point if the TPM is
> not available yet.

Once again, that heavily implies that it is safe to initialize IMA in late-=
sync.

Put another way, what breaks if IMA's initialization is delayed to
late-sync?  If the answer is nothing, just move the initialization to
late-sync.  However, if something *is* broken and we are just doing
this because of TPM delays at boot, this patchset just creates
additional problems and we need a different solution.  I can't
envision a scenario where it makes sense to attempt initialization
twice.

> > I understand the need to ensure that the TPM is available, but if it
> > isn't safe to wait to initialize IMA at late_initcall_sync() then it
> > would seem like this is a bad option and we need another mechanism to
> > synchronize IMA with TPM devices.  If it is safe to initalize IMA in
> > late_initcall_sync(), just do that and be done with it.
>
> Within the same initcall level there is no way of ordering the initializa=
tion.
> Yeorum attempted to address the ordering issue in commit 0e0546eabcd6
> ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initca=
ll"),
> which is being reverted in this patch set.
>
> Ordering within an initcall level needs to be fixed, but for now retrying=
 at
> late_initcall_sync works for some, hopefully most, cases.

That's not a good answer.  Ignoring the TPM issue for a moment, can
you confirm that moving IMA's initialization to late-sync is safe?  If
not, why is this approach being considered?

--=20
paul-moore.com
