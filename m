Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BA91B282
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dembSY+F"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-672096e0e89so5662106d6.1
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 07:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698934645; x=1699539445; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7O2KSplInLsDb19B+zn/jm8iaKKD/NZ+yWSezVEL04=;
        b=dembSY+F9vrcgINo1hryM2EAAv8Ck9GMmRcKb1OfEAl/v6kynYIMjgNUWA1sBLTLLb
         9R91W6Md1qMCc7w0PTPAY+hYzDmV17zlY8xgSjkQQn8hVc+ShmfFiaS9Zx5BmAiRwWH5
         YAmcgnASkT66x+dfCdUcNi+wItiuqsKp8ImMQzYrXph2vpD61qq/fjCWtLR1WDO5JSjO
         fGFtP3LiEx8px3gVcAjzevCV0lz3tMSf8+GgbuF5PUJvHWnXb5R1NUfNSfAPAKJAcuZ0
         5kirg9j4JV+DUmHDeevilZMUuzYBcUAQxDjMCPmUhIjDb0ao0Cd+N6J4wmHP7+3YVcqa
         lOxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698934645; x=1699539445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c7O2KSplInLsDb19B+zn/jm8iaKKD/NZ+yWSezVEL04=;
        b=popH+O/TGKGNvUy+3HZTxndqKbwAbz+Wbk/yZooU1h2XNSBN1NPw/aYix2jhTKJZYi
         l4wBDUHtLTRSpMIH2Mnxm7seE+SW94lSIug1W9zCQQ52mn3upWqtSZxJ1WhzT/12Ok0Q
         ekrS6vw0TsGhuCQLJ23JGPc1CTmzH0F5P/azy1/e5/rig4eqvUxhA7eLK3JcITwWTpsN
         5nbxbItTlb2w3Tn141R29xHIBuWyvV7U68jAAK2fbNVsrlUl1jiX5qx0tgkLPbnU5xgf
         raNrw7AEIVTJZMlrWObD2vKwNohSDFvLKsAmWEp2jw2XPbOKSmtQ9eFyHJwIxsoe/Bf9
         sY7g==
X-Gm-Message-State: AOJu0Yzk/KWC6wr1jE+v7hEgz23vxoZYgZz926IsECVQP26OoEH2PxAT
	e5T4GNKgGFU6Dh0DcfYB0dDbiofH9Uz5RgaWOzWIJQ==
X-Google-Smtp-Source: AGHT+IGAosxm/0woyiCy5wtpQ5hw9PNiMnNT8Y+nXK7zRiDLlPKvw69895suNy2q5wz5DwPz9Dn0X+ha5Vtg4tVBUZc=
X-Received: by 2002:a05:6214:d88:b0:66d:3a0f:97a with SMTP id
 e8-20020a0562140d8800b0066d3a0f097amr20020837qve.6.1698934645120; Thu, 02 Nov
 2023 07:17:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-19-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-19-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 2 Nov 2023 14:16:49 +0000
Message-ID: <CA+EHjTwXdntKGMjb8Zj1M3iVVN5NX6iLwbzJjE72j_eVczTQYw@mail.gmail.com>
Subject: Re: [PATCH v13 18/35] KVM: x86: "Reset" vcpu->run->exit_reason early
 in KVM_RUN
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 7:23=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Initialize run->exit_reason to KVM_EXIT_UNKNOWN early in KVM_RUN to reduc=
e
> the probability of exiting to userspace with a stale run->exit_reason tha=
t
> *appears* to be valid.
>
> To support fd-based guest memory (guest memory without a corresponding
> userspace virtual address), KVM will exit to userspace for various memory
> related errors, which userspace *may* be able to resolve, instead of usin=
g
> e.g. BUS_MCEERR_AR.  And in the more distant future, KVM will also likely
> utilize the same functionality to let userspace "intercept" and handle
> memory faults when the userspace mapping is missing, i.e. when fast gup()
> fails.
>
> Because many of KVM's internal APIs related to guest memory use '0' to
> indicate "success, continue on" and not "exit to userspace", reporting
> memory faults/errors to userspace will set run->exit_reason and
> corresponding fields in the run structure fields in conjunction with a
> a non-zero, negative return code, e.g. -EFAULT or -EHWPOISON.  And becaus=
e
> KVM already returns  -EFAULT in many paths, there's a relatively high
> probability that KVM could return -EFAULT without setting run->exit_reaso=
n,
> in which case reporting KVM_EXIT_UNKNOWN is much better than reporting
> whatever exit reason happened to be in the run structure.
>
> Note, KVM must wait until after run->immediate_exit is serviced to
> sanitize run->exit_reason as KVM's ABI is that run->exit_reason is
> preserved across KVM_RUN when run->immediate_exit is true.
>
> Link: https://lore.kernel.org/all/20230908222905.1321305-1-amoorthy@googl=
e.com
> Link: https://lore.kernel.org/all/ZFFbwOXZ5uI%2Fgdaf@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ee3cd8c3c0ef..f41dbb1465a0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10963,6 +10963,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  {
>         int r;
>
> +       vcpu->run->exit_reason =3D KVM_EXIT_UNKNOWN;
>         vcpu->arch.l1tf_flush_l1d =3D true;
>
>         for (;;) {
> --
> 2.42.0.820.g83a721a137-goog
>
