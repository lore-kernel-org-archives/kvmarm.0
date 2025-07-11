Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C55A237162
	for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 23:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278353; cv=none; b=otZRBROOu/ayrtTG3JBTsBAjc5MoNV97bZOm8b7WRUDvUcoyrDYb+1K7chnI21rkkBanrW9sUfHO2nsyNiRp4aa9xm/OsEmPUrB/esV2NhoghJZFGzQnoNQaSW4PeurA8gaRXkqPcMqT+gwnjUG3ZHODBFl0NexBp2DZMvoCoJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278353; c=relaxed/simple;
	bh=TQJvcadu4ytpBW1WlcQqcacJL5F7BEX/XlwUQ3jSJG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dwcSRhM+nljodZ8TyoX4gSRP6rhm53g0tpcOqeUXUAIwHDVmbR/Gfbva2KGw4e62kcasmJzL2Xo/5PvSgGEsHX2OrRS8HZkCZqUmN40TxuoG+ilVnVu8wj+GYxSqMZCckZvrDueIxnyW098alsrH8xKhyDjwsaSKkkjcp1b1vWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PouCvY+Q; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PouCvY+Q"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so25925e9.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 16:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752278350; x=1752883150; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0HSRL4HugeXUFVF2xbav3ajCDx1kDmGqq3aBhMDxm4=;
        b=PouCvY+Q7Td5Rz30MCh7tRRm/3fKDnt6LSw+fjDkSg8iBRv8CpZ/Z85y+DzITrmWor
         YWfbpwc/le66KuT8/GTbeTDjw8T5EEgrcdQt3wzPmIcyO5FN247tAJfU1zTj7ouJLb2n
         aiZkDfU3b1CMBcCCCg376EgAcOA6J5YVHTamCxp3ZY7lZSM6DL4Y9Gg3JvxkkZbeDmNc
         7k3W/Xsjm/xpbBQWl2fPt/h268531a8sox715NCBGztNZUxW0g5OpwKhAeVEZG02BsY5
         4bX3T69JKCIGGpHBhAT4VXJKoF1zeJ8hMSmwddtNAWGVnYfD/Zq24eA8d0ULagO6T+hO
         LUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752278350; x=1752883150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0HSRL4HugeXUFVF2xbav3ajCDx1kDmGqq3aBhMDxm4=;
        b=NmdaNcWFIyCtECd5G31ja7pABXiLDlZBi++2mLAvhtbnUqWcU07xCpPNLJknsya0F0
         AVcDnbPA800WQHyPst/1CuAEl9jKjIP5SMNSBEA+n61Ma/irluzUiajmDR87aiHQUO0C
         bY92ym7XDfv3yqfMCHcPqp3eikYRIh3i+MHbvXiQTgUFUviwhmSaQbYkf9zudae8W1fx
         GY3FxgXS1jHT2qcfocHYGk+/6RLHPgsFWc8NsDo82VEHvajqazIz7JOIK5WNVQd//X0v
         NfFiH0fgk4Hkb7jIePCTWz9xtnocJwO7UDZUp0JoXBE7I5ibOY8Dvxr2pzh/+giwH9yx
         QPnA==
X-Forwarded-Encrypted: i=1; AJvYcCUaGR4L6ZDhWVKDE/fJsC357hpDtl67xkeULGTq0Wp17jZROzy/F5OVhfbdIpoJdIGW52PuPQo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWsrvvo5VvvMyfdpaWs+ZOwPdBVhuxPbIpO1K9/6ypRBsrGiMz
	T0WwNHn9SBrSEp9JWdrcZ4zK3ycSX03TyG6E6FTM4cPdIfK+wc8yXvuKyZbeENJ9KY+ju6mtY7z
	flfmQf/8/wMDFhMJhMP0K2twKy57mdMdAxMIzwUdg
X-Gm-Gg: ASbGncvLrTpBgvGc9XAdskLv7cIDUT0jxBfxzRXALI87FtjdBaytwe+dzbIxcBrT/i8
	ITMOdEHCrFcSR4sdbtJn4GhZxxj6GwwKPOlIh2t39+TdNsWEO+s1fkOB0tYtc9OrlMGKVzcnbpK
	OfZtPpU2RDgX7dMwM2MB6xs8cH8wLPLNabgT7Iv45NCP2eZVDkUdE+JCs8tcNmgNRHpwXmxaecN
	CysDo4cJt5O2z0QXePKrHbR5m7gOblOEkSzAg==
X-Google-Smtp-Source: AGHT+IH0Yb8i1HbshEYkUfB7pKBzNAZY2a47ozdMS6Ea9eu6/2JNmyxFqwJwxTVebnT7h+QOEYO+783uFnTjwj1f5T4=
X-Received: by 2002:a05:600c:4302:b0:442:feea:622d with SMTP id
 5b1f17b1804b1-45604731777mr157355e9.1.1752278349565; Fri, 11 Jul 2025
 16:59:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250604050902.3944054-1-jiaqiyan@google.com> <20250604050902.3944054-4-jiaqiyan@google.com>
 <aHFpIpIfqVCQZVgG@linux.dev>
In-Reply-To: <aHFpIpIfqVCQZVgG@linux.dev>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 11 Jul 2025 16:58:57 -0700
X-Gm-Features: Ac12FXws7N7R5NhC74hDyERmsam_JiCP8QqW0Zl8h8Z88cj84PQ3Wo91uK-jnvY
Message-ID: <CACw3F51xRWr5LXz4-JhK+mjizY7D7Oa+GrJ-OZHktfPzFGKeiw@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: Allow userspace to inject external
 instruction aborts
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 12:42=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Wed, Jun 04, 2025 at 05:08:58AM +0000, Jiaqi Yan wrote:
> > From: Raghavendra Rao Ananta <rananta@google.com>
> >
> > When KVM returns to userspace for KVM_EXIT_ARM_SEA, the userspace is
> > encouraged to inject the abort into the guest via KVM_SET_VCPU_EVENTS.
> >
> > KVM_SET_VCPU_EVENTS currently only allows injecting external data abort=
s.
> > However, the synchronous external abort that caused KVM_EXIT_ARM_SEA
> > is possible to be an instruction abort. Userspace is already able to
> > tell if an abort is due to data or instruction via kvm_run.arm_sea.esr,
> > by checking its Exception Class value.
> >
> > Extend the KVM_SET_VCPU_EVENTS ioctl to allow injecting instruction
> > abort into the guest.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
> Hmm. Since we expose an ESR value to userspace I get the feeling that we
> should allow the user to supply an ISS for the external abort, similar
> to what we already do for SErrors.

Oh, I will create something in v3, by extending kvm_vcpu_events to
something like:

struct {
  __u8 serror_pending;
  __u8 serror_has_esr;
  __u8 ext_dabt_pending;
  __u8 ext_iabt_pending;
  __u8 ext_abt_has_esr;  // <=3D new
  /* Align it to 8 bytes */
  __u8 pad[3];
  union {
    __u64 serror_esr;
    __u64 ext_abt_esr;  // <=3D new
  };
} exception;

One question about the naming since we cannot change it once
committed. Taking the existing SError injection as example, although
the name in kvm_vcpu_events is serror_has_esr, it is essentially just
the ISS fields of the ESR (which is also written in virt/kvm/api.rst).
Why named after "esr" instead of "iss"? The only reason I can think of
is, KVM wants to leave the room to accept more fields than ISS from
userspace. Does this reason apply to external aborts? Asking in case
if "iss" is a better name in kvm_vcpu_events, maybe for external
aborts, we should use ext_abt_has_iss?

>
> Thanks,
> Oliver
