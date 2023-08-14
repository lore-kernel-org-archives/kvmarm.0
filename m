Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A05C2FF
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 17:26:05 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2b9aa1d3029so70985471fa.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 10:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692033963; x=1692638763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHxmrdCePoUqIzSXCIXwM34KYJsPYFh6NJ6Wh+gnmsI=;
        b=r2uHFOiA5ciFaude5QhUyCx0VtHHjcB1mo9ATxg+zSnWITEBxwppqBk7UT3gmL2Scg
         p6hvgxAv9KZ6AxvaPk3uTHhRJdptHZaR8bs8s4BCsTd7ZCnt7A4mwI9haoGf2WOvfeag
         2CBX4YgX4MPBR57j7dPd9V6dqVszlmXx26DjqopwRoBMyUfAvodxo7LsGtZKSkC5CT2J
         BT+qENyOSpoVpiBrWz5b5VZkWZaVgTZuOcm/CE++8uTcC/8OVedx44j4NioXr8p139WF
         bHzFIVqPGC/36ITOKcuSs7fItQL1qP65GxyZ2f7rNtv/yvaUWgG/BlK0t1RB2dlEJTVc
         5uTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692033963; x=1692638763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHxmrdCePoUqIzSXCIXwM34KYJsPYFh6NJ6Wh+gnmsI=;
        b=L200mTRHkMr/1qGRptb5X38+4UdJ77lWmGC/cdI41td3FeQVQiQpI8sgqKupNjG9mP
         Tkghx294eei/tgPCaXMLVbBlalpBX1H+Bi73XJC7/8vlbQS9vx6FLsHxCgCdWjEtwbiR
         hiQN+jcwGGzqo6Pcyv2fKLfSXwgqj+fLyQUcC3be9aCwUnW35jl0iyD6RvFhrHzc3wnC
         0Sqo70behUMyI0t7hRB+9ClPYHDPDLB1wMb/2CEECYBoRqkc+48KKQvrA9dnqcAD5mXL
         r0s6Xt2AzgvYUg6qo4wYCUYDg5VNO/N0Z2F+wedY5+3dBa5LrrxsFlYMseXvbALrRqxL
         F+SA==
X-Gm-Message-State: AOJu0YxT9FUM+2U+KH0eaPSDeWfqbjKwep4wgBBRn7HhThjNtfLQEuZi
	5SshQ4d4jzGhROpqPMFC5TFcKALFGJYMDSrbdWjagQ==
X-Google-Smtp-Source: AGHT+IEvx93qXFm31EQx1g9kLgdZVLbmq0ikWNBsU81HycBg7bjfUMdmtwNMJShtvqZaEdMGjKolTwK33HGQ1mTqrkc=
X-Received: by 2002:a2e:87cc:0:b0:2b5:80e0:f18e with SMTP id
 v12-20020a2e87cc000000b002b580e0f18emr7319550ljj.3.1692033963034; Mon, 14 Aug
 2023 10:26:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-3-jingzhangos@google.com> <878raex8g0.fsf@redhat.com>
In-Reply-To: <878raex8g0.fsf@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 14 Aug 2023 10:25:51 -0700
Message-ID: <CAAdAUtivsxqpSE_0BL_OftxzwR=e5Rnugb69Ln841ooJqVXgmA@mail.gmail.com>
Subject: Re: [PATCH v8 02/11] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
To: Cornelia Huck <cohuck@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 14, 2023 at 2:46=E2=80=AFAM Cornelia Huck <cohuck@redhat.com> w=
rote:
>
> On Mon, Aug 07 2023, Jing Zhang <jingzhangos@google.com> wrote:
>
> > Add some basic documentation on how to get feature ID register writable
> > masks from userspace.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index c0ddd3035462..92a9b20f970e 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6068,6 +6068,35 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 register=
s using the SET_ONE_REG
> >  interface. No error will be returned, but the resulting offset will no=
t be
> >  applied.
> >
> > +4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
> > +-------------------------------------------
> > +
> > +:Capability: none
> > +:Architectures: arm64
> > +:Type: vm ioctl
> > +:Parameters: struct reg_mask_range (in/out)
> > +:Returns: 0 on success, < 0 on error
> > +
> > +
> > +::
> > +
> > +        #define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
> > +
> > +        struct reg_mask_range {
> > +                __u64 addr;             /* Pointer to mask array */
> > +                __u64 reserved[7];
> > +        };
> > +
> > +This ioctl would copy the writable masks for feature ID registers to u=
serspace.
> > +The Feature ID space is defined as the System register space in AArch6=
4 with
> > +op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-7}, op2=3D=3D{=
0-7}.
> > +To get the index in the mask array pointed by ``addr`` for a specified=
 feature
> > +ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn,=
 crm, op2)``.
> > +This allows the userspace to know upfront whether it can actually twea=
k the
> > +contents of a feature ID register or not.
> > +The ``reserved[7]`` is reserved for future use to add other register s=
pace. For
> > +feature ID registers, it should be 0, otherwise, KVM may return error.
>
> In case of future extensions, this means that userspace needs to figure
> out what the kernel supports via different content in reg_mask_range
> (i.e. try with a value in one of the currently reserved fields and fall
> back to using addr only if that doesn't work.) Can we do better?
>
> Maybe we could introduce a capability that returns the supported ranges
> as flags, i.e. now we would return 1 for id regs masks, and for the
> future case where we have some values in the next reserved field we
> could return 1 & 2 etc. Would make life easier for userspace that needs
> to work with different kernels, but might be overkill if reserved[] is
> more like an insurance without any concrete plans for extensions.
>

Maybe it'd be better to leave this to whenever we do need to add other
range support?

Jing
