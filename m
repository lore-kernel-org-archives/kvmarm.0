Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD5154AB
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 22:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sMeVPyBC"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-27763c2c27dso1373884a91.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 15:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696545989; x=1697150789; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BFNKMdFnPveldc0HQ7aZGfenM2ZrJbvkhgfmrxqt94M=;
        b=sMeVPyBCzUKQDRUd2+yCWcy/qbJJFIZpARFyYf3JX/lF+nc7h2qdyGhtk6y6Wt7hFl
         JEQ5QtwHFyNJoJ7JOnZk1a8ypvuA6M3FlWaKE6Yt1PIgOTcF482iCS4AdMmz8tqBfori
         wwLgojC26YY/zXYbPeTII45V6FvXXaRCR4tN6CshVTwfhkbEkPRcmBhD5Ny243AUtY3/
         J9SYhed9StI27vAiYi+nVFTUSRWGT0/qlZCwDO3CczI3OQODr27zfwXFpVP1vCtoJWX6
         AMwYiwdTHdYaKe0RsVdTWzdCa2FEs2fYbmLodJwqmiBdCW+9tYSwPrtUpYV1FX1xWheH
         y7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696545989; x=1697150789;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BFNKMdFnPveldc0HQ7aZGfenM2ZrJbvkhgfmrxqt94M=;
        b=kfS2uMlNpdaeZ6uOP/iwRPXXGX+la+uMdLOHraBcWHRz95CgQtseuhHqjslJv13zL1
         ih60TyEVeIhlJatBes7/01hS9oJxwi9vQz5OXhdGyyPwBP9jrNhJipUkxwE0mDihIUci
         ognjEfP31UWHzuAk2NzoBk5QdB6HvX6j0xmZtwLzwbIODa+g/JR8nNLgAVEmTGLzhzwg
         5JLRNjumnevKIQ3ra8W5H/uwb+8sCjmWFAcq96109Iup+YiTp4W4g6Ukue+LO2eErKE3
         HiGJXU8izyxxopLgMQGn1nI1w7IDADVtUH3hUFp/6j76Pfldh0QLdFExsUAc6EVgqxLn
         ZydQ==
X-Gm-Message-State: AOJu0YwJcvaiZQpLVnjI6/9AUQU12LI0v6y2Vgo5jV3a5sD77DdrWefv
	n8q6AymIrsU9AGAMevUEUnRH/MjrwSg=
X-Google-Smtp-Source: AGHT+IEtahwBg2Zwge0uEd3Ui7DNj7uWo5yXZrXRWofh6Qbm+2xT8gySHKj0YTx2KOHMFuyEUr32wAYCdkY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:e06:b0:279:9aa1:402c with SMTP id
 ge6-20020a17090b0e0600b002799aa1402cmr104744pjb.7.1696545989346; Thu, 05 Oct
 2023 15:46:29 -0700 (PDT)
Date: Thu, 5 Oct 2023 15:46:27 -0700
In-Reply-To: <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
 <ZRyn0nPQpbVpz8ah@google.com> <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
Message-ID: <ZR88w9W62qsZDro-@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05, 2023, Anish Moorthy wrote:
> On Tue, Oct 3, 2023 at 4:46=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace co=
uld be
> > "unreliable" is if something other than a memory_fault exit clobbered t=
he union,
> > but didn't signal its KVM_EXIT_* reason.  And that would be an egregiou=
s bug that
> > isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption wo=
uld affect
> > each and every other KVM_EXIT_* reason.
>=20
> Keep in mind the case where an "unreliable" annotation sets up a
> KVM_EXIT_MEMORY_FAULT, KVM_RUN ends up continuing, then something
> unrelated comes up and causes KVM_RUN to EFAULT. Although this at
> least is a case of "outdated" information rather than blatant
> corruption.

Drat, I managed to forget about that.

> IIRC the last time this came up we said that there's minimal harm in
> userspace acting on the outdated info, but it seems like another good
> argument for just restricting the annotations to paths we know are
> reliable. What if the second EFAULT above is fatal (as I understand
> all are today) and sets up subsequent KVM_RUNs to crash and burn
> somehow? Seems like that'd be a safety issue.

For your series, let's omit=20

  KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page

and just fill memory_fault for the page fault paths.  That will be easier t=
o
document too since we can simply say that if the exit reason is KVM_EXIT_ME=
MORY_FAULT,
then run->memory_fault is valid and fresh.

Adding a flag or whatever to mark the data as trustworthy would be the alte=
rnative,
but that's effectively adding ABI that says "KVM is buggy, sorry".

My dream of having KVM always return useful information for -EFAULT will ha=
ve to
wait for another day.
