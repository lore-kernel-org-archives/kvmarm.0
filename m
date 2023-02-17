Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669FA376
	for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 04:20:33 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id c22so1473951vsk.12
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 20:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EzJhoV3HmsUkNrfCb9SHGhf85+7gyTZEICckTTZh/aE=;
        b=guZJ0aqVsAObTjuj7XNytr+ADm4zAmp5kFomgta8H/V9agYhSTr6o1f5t6byBbQtNR
         LCahRg6zjHEs07Oc7PqjYUY/tAINKb6gCSN9SVVK1qv9xw3hIb0Lxv+hTjQxq2Dw515d
         YW8A97ln7/4+it2hWhQ+3h52ky8N9GgenEovFel6wIha3BRl6oiiTJWxaNnVSqqzZ5w7
         1EIkoExQzX+JQZiH1bjKl3VX3fzQM6zWgqS4n8HJiKZXfc6EP1cQInYk5aOULHFKvaee
         kU0uis/PgBthxAf5wR7/pAc24CoQ71uLazQep8X2hP8EbEgS5NpqiJEJCFkMqOBKm1zv
         Hrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EzJhoV3HmsUkNrfCb9SHGhf85+7gyTZEICckTTZh/aE=;
        b=SUjsE9gxUp537OaKJi/iScrd5+8drIoUK8i7tYUIAieMbTHXUA6hCKnO9gbYvvQIvm
         dkJ8KtykU/N86i3edNNGjI+OEVO5Ld4s3EGAL7kbWLE9GGMqC1nNt5SPOU4u9FBLLY4w
         yZUHGwJUtJwlO+/khv2sdlSF+KQUjqrgrmyxm4L+o0LBf67AygblMGqxjEhgAuYIshN/
         yImNfrR4iRCS7I6FY23FaL2bSPu9AWCFm0/Eldqcgew9SrnoQxc5NAH0fqrl6aAltcS8
         ynIKD09kqcwlGutr4birzlpLCX5UtQ9UgmBFMgUyfoMA0vFBSd2kDG8LpQ8xb1US6tdm
         B8AQ==
X-Gm-Message-State: AO0yUKX/0GgesYyt7a1Ip3E31EARCbsgqFc5TrFsN7NGvlRGIh+akJu3
	Nxot+MT+iSoaHljsdCDLbmKjJDSSxz++kxwEHRZqrg==
X-Google-Smtp-Source: AK7set/C7m3gRJtF2smsD9KrApMl+5if6kuQRwt+IEmk635RYBoR+6RvbwCDqKIob+I+QiZWOyrqu86cui6jAk+Etew=
X-Received: by 2002:a67:cf47:0:b0:411:c1a0:c787 with SMTP id
 f7-20020a67cf47000000b00411c1a0c787mr1602398vsm.26.1676607632191; Thu, 16 Feb
 2023 20:20:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
In-Reply-To: <20230217041230.2417228-3-yuzhao@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 16 Feb 2023 21:19:55 -0700
Message-ID: <CAOUHufYsiFx=AqnZ6gDCjEHq4cN6XVXF6fPRvGpaXJbbmvoCPQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
To: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
>
> This patch adds kvm_arch_test_clear_young() for the vast majority of
> VMs that are not nested and run on hardware that sets the accessed bit
> in TDP MMU page tables.
>
> It relies on two techniques, RCU and cmpxchg, to safely test and clear
> the accessed bit without taking the MMU lock. The former protects KVM
> page tables from being freed while the latter clears the accessed bit
> atomically against both the hardware and other software page table
> walkers.
>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 27 ++++++++++++++++++++++
>  arch/x86/kvm/mmu/spte.h         | 12 ----------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 41 +++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+), 12 deletions(-)

Adding Sean and David.

Can you please add other interested parties that I've missed?

Thanks.
