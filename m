Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3596B376
	for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 04:24:47 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id h10so4303514vsu.11
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 20:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PJu4vps/ydzm+bD68RapcHOeOMmzQwBmAiW7NmBj0zU=;
        b=N9QazQscN5/bMrTwGxOfAtM8xQD0zg2C7V00UxsuXtYfAz5LVfV9yZkceaMx30llQS
         MbtMbGZSrDyQ8f+5wFmT5KPHG7yoVHYuRGjV/K+K1/YBzfts3DWsIWEL2wK13NHsBONL
         3WSw5YTZ0a5gR+5SW3CY0ht9ZWgZiEHmWxeYTUfbfTwp27jM0ayQIQmuMeH32n16zCMS
         LlHALD1+pwPBgt3KwWvli37N4+ulQIAdwqaKEMOyIYnaNF0PxJI5iNKryPEMJ1JxgseD
         cL+jVcKxymHBK7RZixjBM3EahjNXB2uD4wOmYf/cmuvuGiqT2+UiebhqO4obZD3C2vfh
         jyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJu4vps/ydzm+bD68RapcHOeOMmzQwBmAiW7NmBj0zU=;
        b=ZFpI8w57Blc48OCXx05/TyFAYkXNOYQYFOWWb8M1l88TEouINdMYngm5m29pDgKh6H
         HYttvG7V2820uC6/ihyPlHNbiaLiROZa+l73tFKIEN71d0Tt/OrBb1Zag/nPmygMIO2C
         2m3Au5x/JtZfHiucbq6sgWaahbJWML5I2n9TYxXLzdLiGvy9wEUoQVBxJ1Xg3arMbk+e
         qjw+oR5nJgi1QMMDevhIzrcfa8cPepZqv5UdBX2kB2QQEmrNiVYaFvPW5K5W/+VAq4bj
         i01bDGImLFOC7dECzzgQkyQrkLN7bnFfY3d7LbEBJ/GfPze28VdsDnJ/Mhxe5iZ50XA6
         3nqA==
X-Gm-Message-State: AO0yUKWmSf+ylWdNhwp3I5AIHWqARCsqpRWA1BaVfkUUVyceWWPLu3RC
	8TCXKmyEzZVu0/p68drGrZ75FDaPgWdzebGtm2Valw==
X-Google-Smtp-Source: AK7set+Yem2rWelUagYff1NdlU4Jg460e39X+mAJEfXHa9zcbTd/sITo7f0UTvcIS0NfZcWWeb2tTMWiIhTxmfPdL/A=
X-Received: by 2002:a67:cf47:0:b0:411:c1a0:c787 with SMTP id
 f7-20020a67cf47000000b00411c1a0c787mr1603908vsm.26.1676607885989; Thu, 16 Feb
 2023 20:24:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-5-yuzhao@google.com>
In-Reply-To: <20230217041230.2417228-5-yuzhao@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 16 Feb 2023 21:24:09 -0700
Message-ID: <CAOUHufbjbaBtNQX-uSOUQEDoH9nAE0nC7L+ssoPF3WHpQuiwuw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 4/5] kvm/powerpc: add kvm_arch_test_clear_young()
To: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
>
> This patch adds kvm_arch_test_clear_young() for the vast majority of
> VMs that are not nested and run on hardware with Radix MMU enabled.
>
> It relies on two techniques, RCU and cmpxchg, to safely test and clear
> the accessed bit without taking the MMU lock. The former protects KVM
> page tables from being freed while the latter clears the accessed bit
> atomically against both the hardware and other software page table
> walkers.
>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h    | 18 ++++++
>  arch/powerpc/include/asm/kvm_ppc.h     | 14 +----
>  arch/powerpc/kvm/book3s.c              |  7 +++
>  arch/powerpc/kvm/book3s.h              |  2 +
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 78 +++++++++++++++++++++++++-
>  arch/powerpc/kvm/book3s_hv.c           | 10 ++--
>  6 files changed, 110 insertions(+), 19 deletions(-)

Adding Michael, Nicholas and Christophe.

I'm not sure who I should add for this patch. Can you please add any
interested parties that I've missed?

Thank you.
