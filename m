Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233623E48B
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 22:59:52 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-49d0f24a815so695894e0c.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 15:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696373992; x=1696978792; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VuLZmgaV89lzOHymPqsmAC6abj1UTBHkava0gPj509c=;
        b=vKm+/ceCo0YB1IyShNykhWEykoEE3JoyemRHhz9Ji6W0fxujdu0ZaT/szcQ0mCf7uS
         aZv6rkSaAkTJGrplcj+BfKucGish9qansxnZj5TCjt8WWyCgLKe/qPibuuJuW+653xLN
         EqvDXiju+C4vOlFvGlMfERYUvX63gC41c5rpZUj2RRngi6jjZGA4dQO/p1mgYSiePenP
         EcUz3iAM7d9td0kQqfNMYXmhLQqnwEynhMzSe+cBVmlp1tsbvAx6twrF+0UNfYm6LIVU
         4rncfx6PSYS/1QsVU/JExgofjYH9Xa4j/g2S3UAIj6HmBaZhLMF8nNwKxRedmt1ibeII
         I6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696373992; x=1696978792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VuLZmgaV89lzOHymPqsmAC6abj1UTBHkava0gPj509c=;
        b=UxCgf6IqAONSNZc+ZQTEzMbYRm9dD4Pc/38iPCEACsTmoojFPWACiLUIu3rzTg3yFI
         5PmLfrDT7qd1Y6URzvlA6iPdC/b2M57JUHsjqyXZyR4xzHtNthflD0q4De5V9mRGtOwI
         ezolg4isf/yiD97Qa6K1N4maQMo8O0OLfrYKMnqowTi6cR2/VRiwPDWmNZPvwSREiuRr
         XWuNFICK9Q5kS13djIQkWShMCPi0MSvuNHuwh+HKBcLwtNRO6Ju2ZTAUeYy4mmK1x0b7
         3retL+Q17/z8CupaxrnxWArb0FcY6XGnDGF4fFqVU8qCPUopMEjys+bO2TQnN82vOpMP
         W1Cg==
X-Gm-Message-State: AOJu0YxkQKd4xiYy8IO5APqC6myBKYC8C1G069R21J/iD2UBmXCUxQKy
	LyEH27Y4eCUuIzw9M2uM3tgb/GD8hGuQKM8Xb28H4Q==
X-Google-Smtp-Source: AGHT+IHt/5hi86I5tWmFhMD1MR9ouSEy0bKqsB0WSgB1we3wcIPiKRqguWhLnlbBZgNBr6PNxrWaK8kmhmE6ei5mSik=
X-Received: by 2002:a1f:4887:0:b0:493:3491:ce89 with SMTP id
 v129-20020a1f4887000000b004933491ce89mr587565vka.14.1696373991201; Tue, 03
 Oct 2023 15:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com> <ZRtxoaJdVF1C2Mvy@google.com>
In-Reply-To: <ZRtxoaJdVF1C2Mvy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 3 Oct 2023 15:59:15 -0700
Message-ID: <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
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

On Mon, Oct 2, 2023 at 6:43=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> > - I should go drop the patches annotating kvm_vcpu_read/write_page
> > from my series
>
> Hold up on that.  I'd prefer to keep them as there's still value in givin=
g userspace
> debug information.  All I'm proposing is that we would firmly state in th=
e
> documentation that those paths must be treated as informational-only.

Userspace would then need to know whether annotations were performed
from reliable/unreliable paths though, right? That'd imply another
flag bit beyond the current R/W/E bits.

> > - The helper function [a] for filling the memory_fault field
> > (downgraded back into the current union) can drop the "has the field
> > already been filled?" check/WARN.
>
> That would need to be dropped regardless because it's user-triggered (sad=
ly).

Well the current v5 of the series uses a non-userspace visible canary-
it seems like there'd still be value in that if we were to keep the
annotations in potentially unreliable spots. Although perhaps that
test failure you noticed [1] is a good counter-argument, since it
shows a known case where a current flow does multiple writes to the
memory_fault member.

[1] https://lore.kernel.org/all/202309141107.30863e9d-oliver.sang@intel.com

> Anyways, don't do anything just yet.

:salutes:
