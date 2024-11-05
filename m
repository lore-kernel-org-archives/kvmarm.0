Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB581D5CEB
	for <kvmarm@lists.linux.dev>; Tue,  5 Nov 2024 21:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843790; cv=none; b=nLnGewV7+Ud8iGARelhLqUNxfSme0c/2Iwj1hf+JMeP5oR3LqOwmRvB/1HVJAp61XZBszkLBStEfScNvvAsxhksH42bRvf2TN4t49l1KjHD/DFUktBw/2mHSJPFhpIBvyGb2OXuQPniCkuTc41Umak4lcToWr64uzYMEvpArmxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843790; c=relaxed/simple;
	bh=pVej0gBt4tUYgFnrRPfvfJ1Kuat+zoGImUSeqO9gRwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=unpkMQWeUd+uXWBvuiK8L00CGjE3pU22CLgzwfKsGE13I9HwHdosBiZSWP9xDv10E8EclMWcCzgKMcC+WA813GTBAnlJNeOEJUyhWQmyZnVgK18CyTbXdPpn0yPQplYyhdnR9eX2HbEaqsb//w2lMguIeaJzjbckf7mjZhc1Y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ScVUyZwB; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ScVUyZwB"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539f7606199so3653317e87.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Nov 2024 13:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730843787; x=1731448587; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wXtAUZpo/eZv9N34VGkN0x5RoW3L2kZwJ65Z3JqvyA=;
        b=ScVUyZwBqeMsVx9TdeALCyfQt+uKYyEwbq+bd/V5iBg6k14tZOq0n+g/aGjKe8IwUz
         lfEIZOnh1WUqtXU1Fmq1YGueos7wKzlzRHpX6H38+PivcNn7a9SjT6yxbvu29H11JYkp
         CD+lYc8ubbUh0XoHNCJ8TZ4lwmZKyjlmaotQ+6al5HGeo/JzimXduNp4+1RlNhAcjMPu
         mJi0cptie6VmcYrvHiaeqcmSbQIaeyzpjzArkuV4p6+5xl59EJd6FxR3c/TPIWigl9qH
         9azVFQpQtsJ6HXmxhkCUDYHTbfP0gA4qcuN60YU5yquAk8ICv9xoTx/pICEW5C1l7+On
         7VPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730843787; x=1731448587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5wXtAUZpo/eZv9N34VGkN0x5RoW3L2kZwJ65Z3JqvyA=;
        b=WG2vfvSAnUbRLzGzD5+nTPOLzKwe+BpYlpDdz7LsyVcrbmxZqbM4L4tSCZ7+4gVJJX
         ro/zvQ4sfYhkgkOz/EaJFjGFCj6K3YQcLiIWENzHdH9f8BxeiQxpGn7ksmOKXITn+001
         2wCAtXdkzwHNhyPZ1Pt8uPznaA2GJQUBZ4kA7quTGg+KT+oVZykyiciF/r5Rq1qHYAfP
         Yx34SnaJSp22inteZg9ENcH/7L3EAssh6svAFdka8p4nKM04xCIffHrF988or6n/sQNO
         X+nooQuQhQVZhhERmwbcJaBPmffald8MDI8wY/G6FqK6XNDz5ps2GgwyTIk1/776Ts/w
         odGg==
X-Forwarded-Encrypted: i=1; AJvYcCUV8FPRn+nMvgJ06/ymhD92B8wUUJtghYRuE1kNJJXS4y++v08R9TQtJhNgexrMjLq8ICdAoT0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHg1NuzPAwAinBNgj0JKg4kIew2JOcPHcX6RCYPqXqwjfK0gcK
	Gf8Ty30nLd7CpQitZPFSMiwNSA5+Sv/QUJzs3m3K/UtPorJxzb9jSM1c4etD6IuoR/7XuXImOQ0
	Rbd6V2xjH8IueDPFPMWVN7vhUMNDKvvAOBP35
X-Google-Smtp-Source: AGHT+IG1+f/ZA6qSL99d7qn8w74pDe+0ftoUHGp5Hxjh0+8ykvXijLN2604KYOE83QwClmrIDEAPur/UKnYI6c3tcfY=
X-Received: by 2002:a05:6512:31cc:b0:531:4c6d:b8ef with SMTP id
 2adb3069b0e04-53b7ecd5232mr14841438e87.6.1730843786817; Tue, 05 Nov 2024
 13:56:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241105193422.1094875-1-jingzhangos@google.com> <ZyqPMdH4anLEIq8G@linux.dev>
In-Reply-To: <ZyqPMdH4anLEIq8G@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 5 Nov 2024 13:56:14 -0800
Message-ID: <CAAdAUthd+c71BTSEvQvCZoYE2vQPHabofK=947MspU1hUbZd+w@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] Fix a bug in VGIC ITS tables' save/restore
To: Oliver Upton <oliver.upton@linux.dev>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 1:33=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Jing,
>
> On Tue, Nov 05, 2024 at 11:34:18AM -0800, Jing Zhang wrote:
> > The core issue stems from the static linked list implementation of DTEs=
/ITEs,
> > requiring a full table scan to locate the list head during restoration.=
 This
> > scan increases the likelihood of encountering orphaned entries.  To rec=
tify
> > this, the patch series introduces a dummy head to the list, enabling im=
mediate
> > access to the list head and bypassing the scan. This optimization not o=
nly
> > resolves the bug but also significantly enhances restore performance,
> > particularly in edge cases where valid entries reside at the end of the=
 table.
>
> I think we need a more targeted fix (i.e. Kunkun's patch) to stop the
> bleeding + backport it to stable.
>
> Then we can have a separate discussion about improving the save/restore
> performance with your approach.

Yes, I'll respin Kunkun's patch soon. This patch series has the
selftest which we can use for verification.

>
> --
> Thanks,
> Oliver

Thanks,
Jing
