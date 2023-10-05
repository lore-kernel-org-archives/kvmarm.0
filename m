Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657D12B74
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e9NSsfig"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-57de6e502fcso834991eaf.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 15:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696543676; x=1697148476; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVEDH7DIG0wbfSQq3l//NlGrUn25Tt5fS9CoqUlLrR0=;
        b=e9NSsfigdixOmsilxYq5Ma/1uO+/UGgH9enQbDTajjDS6OTZxn7vN7xfZA1T98lCCs
         0oC/4XhwDI8gqCYK5bwC6pb1+TriP6gbYRvUpbKsp8cBGM7ktPoBiZinvDzZVPcylw0P
         lYBCHdbhDbZ4QKfQSQ3udJz/JIP2C2gOLSaD1wN5zBCf3bTl4Xz2fJaEnvrLsaz6wwTs
         UwL+p4vgzyAgioiKuGTWz0nG3tcg/5bFpc8StsKKUNPaPnMLWILel16/YgAmiRMfxMRI
         3T+sy5rmgcMQimewLwWqg5Y5amCCHE2oazLbtzWmGz5vy9KSFp8Jn1DUjtecflmtZfuu
         6d1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696543676; x=1697148476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVEDH7DIG0wbfSQq3l//NlGrUn25Tt5fS9CoqUlLrR0=;
        b=YwfV4ZRgXU6TWZkYv9tI1rbptfgrEkfnefr/WKgRsmIp49H6dJcNgK3zq9tBtO2QVL
         x05OoNUET2a0yNzAre1VlJYJPzPnqTyEprAggK03DaCJlwjy8TIpyNJ/zyfFybgDAwA9
         ajwri+OGJLEjwS4uOR1H0F02PtAUYJx/p12SpIvwKvvysLf5NpqxRvvfaDjoKydG4o2Q
         bjl0zfOryzHEHbbxvknqrlRwYXYtDEzXfb12AugRDU4IB9H4fpPGaBqJvjPCXIVLnooS
         wXFYfv374FT5Hxm6dCNmg+V9QOT7PWNKKSaYmf/0N10tsAb0NC4y7LBG5wTmX//nBanA
         aoxQ==
X-Gm-Message-State: AOJu0YymW84+jKYRB7eG0Rw2rWmkvJ6DeNEziNsFb1YWQRHTfnOQ559h
	sb5BzcQyrehyBP013vlfEwLcgJ0Z77HwJKdbXXp5pQ==
X-Google-Smtp-Source: AGHT+IEZBLWG7MHKbRYLlAd2jmfuZ64eocXXaB5o38fDnCbh9AkI5WYrmKeXE/dRrdn/9j/liwFQcw/a3M1v6AdfJBQ=
X-Received: by 2002:a4a:270d:0:b0:57b:4f1e:96e4 with SMTP id
 l13-20020a4a270d000000b0057b4f1e96e4mr6802480oof.1.1696543676303; Thu, 05 Oct
 2023 15:07:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
 <ZRyn0nPQpbVpz8ah@google.com>
In-Reply-To: <ZRyn0nPQpbVpz8ah@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 5 Oct 2023 15:07:19 -0700
Message-ID: <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 3, 2023 at 4:46=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace coul=
d be
> "unreliable" is if something other than a memory_fault exit clobbered the=
 union,
> but didn't signal its KVM_EXIT_* reason.  And that would be an egregious =
bug that
> isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption woul=
d affect
> each and every other KVM_EXIT_* reason.

Keep in mind the case where an "unreliable" annotation sets up a
KVM_EXIT_MEMORY_FAULT, KVM_RUN ends up continuing, then something
unrelated comes up and causes KVM_RUN to EFAULT. Although this at
least is a case of "outdated" information rather than blatant
corruption.

IIRC the last time this came up we said that there's minimal harm in
userspace acting on the outdated info, but it seems like another good
argument for just restricting the annotations to paths we know are
reliable. What if the second EFAULT above is fatal (as I understand
all are today) and sets up subsequent KVM_RUNs to crash and burn
somehow? Seems like that'd be a safety issue.
