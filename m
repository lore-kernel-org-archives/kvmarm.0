Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DC2C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 03:56:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2868540BDF;
	Wed, 16 Feb 2022 22:56:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aipeoEEiEvn0; Wed, 16 Feb 2022 22:56:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02C7441071;
	Wed, 16 Feb 2022 22:56:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08A9408A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 22:56:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lc+RbxOzhbmV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Feb 2022 22:56:08 -0500 (EST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
 [209.85.208.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D72BD40015
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 22:56:07 -0500 (EST)
Received: by mail-lj1-f170.google.com with SMTP id r20so6403789ljj.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 19:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vGLw56RZKhiWCoemgAzhNBngh8470bgB/uGqFoyd97s=;
 b=s/jKdaCx1c5Zknn67tB5iKEw70fP3Ww/w3R3N4KF26eZY0B7drVF2pIkj2awBEIpqA
 C9bNqqw77AnCB/xdkuNXlqvxUSMhMiFrMGeTvKBovUckUgCK6ruT+QOdmycPoK4WFI8b
 aPUG/ZHmXuqnE9XL7l7gy141RxJs44/WVZQJc/tE1oE4OZpBVHGhA+Y4lNpTDeKv//m8
 Yfqdi30vW7oCaTLyN3CAY6l+54fcZ9XJn8MY5pWfAMfiz8Z7j0C2gCBreMIUJ1L2ATuX
 7cmGJ9OP4Xxx3nls8q3AeSmEAE4WYzRLehstFnQG6uGEXa/oATeyrtR+fsS0eb26LNV+
 +KrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vGLw56RZKhiWCoemgAzhNBngh8470bgB/uGqFoyd97s=;
 b=PVEdyCUNfEmfzkIidAvD+pwT1yDbG39Qr7+mhZ4plnl5UimlH09R5VqOMtv3ffoM29
 3sdCOfXZDvM8QxlLbe7ClWTnlLH+NFsKdeoY+Nt/YF/cEFgBU9X/91v3y6EQvME8FEXu
 Bjkj1WGCf4HZOvUtwTrU3TcIdE+Mo1pNk1e9Rw9+XMchABeQ1ocbLq5N/Q7FH9SYI4Yx
 L9+slk7G74giMat7KJLIuzADadzymJLJaIxZbthpbmPJRkIdj0O9tpV3dP6mzYVwEuTK
 au2a6001MxCck6epevwxvXoCNX+Jy/KLfJMNzlmhNa41AtPwi7+RtdkmM/8FF+RNsNhe
 5tfA==
X-Gm-Message-State: AOAM533DEK2IPD44d9PUfGGN1yP8sTNtNoE8ElOcds4mpqMcTLh0n2Xi
 Kc+HOha48aAp9Fhq9thiXVGQSqAQLXypFPJJFA/NWQ==
X-Google-Smtp-Source: ABdhPJzA7AvxxXTvomAuL2mrvPmtha3aKyUkxODv/5sSEeLdgib/0wWu0Z7GezyZLwNPCO+11W5CUPLZhD2BHe8ilDI=
X-Received: by 2002:a2e:b16e:0:b0:244:d368:57e with SMTP id
 a14-20020a2eb16e000000b00244d368057emr865694ljm.251.1645070166217; Wed, 16
 Feb 2022 19:56:06 -0800 (PST)
MIME-Version: 1.0
References: <20220217034947.180935-1-reijiw@google.com>
In-Reply-To: <20220217034947.180935-1-reijiw@google.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 16 Feb 2022 19:55:55 -0800
Message-ID: <CAOQ_Qsj4fHf4X1ysJ93D_f+582p66vSqEVznXyS6xtsBT_MH8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: selftests: kvm_vm_elf_load() and elfhdr_get()
 should close fd
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Feb 16, 2022 at 7:50 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> kvm_vm_elf_load() and elfhdr_get() open one file each, but they
> never close the opened file descriptor.  If a test repeatedly
> creates and destroys a VM with vm_create_with_vcpus(), which
> (directly or indirectly) calls those two functions, the test
> might end up getting a open failure with EMFILE.
> Fix those two functions to close the file descriptor.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/lib/elf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> index 13e8e3dcf984..9b23537a3caa 100644
> --- a/tools/testing/selftests/kvm/lib/elf.c
> +++ b/tools/testing/selftests/kvm/lib/elf.c
> @@ -91,6 +91,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
>                 "  hdrp->e_shentsize: %x\n"
>                 "  expected: %zx",
>                 hdrp->e_shentsize, sizeof(Elf64_Shdr));
> +       close(fd);
>  }
>
>  /* VM ELF Load
> @@ -190,4 +191,5 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>                                 phdr.p_filesz);
>                 }
>         }
> +       close(fd);
>  }
> --
> 2.35.1.473.g83b2b277ed-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
