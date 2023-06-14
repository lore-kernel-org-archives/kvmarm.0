Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8188F74
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 12:28:30 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-3f9d619103dso172381cf.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 05:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686745709; x=1689337709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RWp1GSa1iVrR/gkhCLlSHzUXoyA8xu5TUgKxG/0iXE=;
        b=XMls8vVHJsWXkcMU3k+sdL9oFwWkx7On44gyfOhi9i9Q7VO5887jHk2RKMPnicHbRA
         Xhnq9Mz87opchiA6GKhiRdKv/ET8G7G74ZkbuyhsFas5ZT7KKnfzJbzicEcjiJGaE46T
         7o6NiR/qKDScEy5Z3ZsdWZgFXnCV5+GioL1CIL7NOayTnpZ2djL7yo8XS0aNCnL7Z56I
         C0PMRJBONZO7qBRSbl/6RKqgIIJZrv7rTQedTFhvR7xzgJ0VdK+xIkr/iyrNClx4htyI
         RX5X2cmxEYo139BMcPyD/a7JJNVqsCTFZIbn9Kc1xoNKqB6alUEjpFsxKD2TDzd9FZFO
         sazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686745709; x=1689337709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1RWp1GSa1iVrR/gkhCLlSHzUXoyA8xu5TUgKxG/0iXE=;
        b=GKSX29d9Yg1yGW+gHIysVaHGEinyRbZ2gh5D/fkMWWxpXZ6k0QxRskVFt9hUT/snyt
         c4V4L6w+HMGCCjq/RAUqkzXSHFem51WiZSc4B2/m9IUtyxxeR+6nuswdI4XWxTgf3Puh
         M+JUwmhbGRiWdYnRVPM9E1r3jy+BNNdOudIoP21+TKtIDw7ItF+IoSg1cma6NVnxrRss
         FFCqp+Nr3KtM+Ewq5dZSpDWxUtUoVOkUeuDSLGsrSB0ho/hldHfai9HJQlyylbfG7C4h
         zwSDGZhCyMQ7AQOVja7ewYXMmFgBqBqzaXlj6IjtPTaapgZT1u5fDDq1YeTbT7Gx95X1
         jFXA==
X-Gm-Message-State: AC+VfDzMDrM2iqnyRhmf4bHOfzNLkefFgvguaWrMbmoOX6LXQMnqUuvY
	PuorWBH/J9p54l6gOps7YV7yhVqzRNX64RhAZ2a8Nw==
X-Google-Smtp-Source: ACHHUZ5dqL77liI4l+c08Guv5ROvl3QHRcpLv2NCdISXswAWjKdvZWOFuyr+PEbvd1f47DparMcXIZFsJ15tekvYmBU=
X-Received: by 2002:a05:622a:19a7:b0:3ef:5f97:258f with SMTP id
 u39-20020a05622a19a700b003ef5f97258fmr227795qtc.16.1686745709282; Wed, 14 Jun
 2023 05:28:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230516141531.791492-1-smostafa@google.com> <168665854178.2681974.13725664134174024912.b4-ty@linux.dev>
 <ZIiY8lrLKv4amCu7@google.com>
In-Reply-To: <ZIiY8lrLKv4amCu7@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Wed, 14 Jun 2023 13:28:18 +0100
Message-ID: <CAFgf54q=hr9OoNdfDnMD3_4OHN6sz4928gYgvmz6bdSEpztUUw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Use different pointer authentication keys for pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, 
	kaleshsingh@google.com, tabba@google.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, james.morse@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 13, 2023 at 5:27=E2=80=AFPM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> Hi Oliver,
>
> On Tue, Jun 13, 2023 at 12:16:02PM +0000, Oliver Upton wrote:
> > On Tue, 16 May 2023 14:15:31 +0000, Mostafa Saleh wrote:
> > > When the kernel is compiled with CONFIG_ARM64_PTR_AUTH_KERNEL, it
> > > uses Armv8.3-Pauth for return address protection for the kernel code
> > > including nvhe code in EL2.
> > >
> > > Same keys are used in both kernel(EL1) and nvhe code(EL2), this is
> > > fine for nvhe but not when running in protected mode(pKVM) as the hos=
t
> > > can't be trusted.
> > >
> > > [...]
> >
> > Applied to kvmarm/next, thanks!
> >
> > [1/1] KVM: arm64: Use different pointer authentication keys for pKVM
> >       https://git.kernel.org/kvmarm/kvmarm/c/fb737685beee
> >
> > --
>
> Thanks! I did more testing and I found a bug in this patch.
>
> It seems there is another entry point for the kenrel where pauth was
> not handled properly "kvm_host_psci_cpu_entry", I will investigate this
> further and send V2.
>
> Sorry for the inconvenience!
>
> Thanks,
> Mostafa

I investigated the problem further and actually the bug is missing
isb() after updating
Pauth system registers at EL2, I sent a v2 with this fix.

Although when entering from kvm_host_psci_cpu_entry, the hyp keys are not u=
sed,
but this call directly exists to the host, so I believe this should be fine=
.
