Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FCFC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 14:48:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 379F04B20D;
	Tue, 14 Dec 2021 09:48:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oyH5EE4zSSRF; Tue, 14 Dec 2021 09:48:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E00A4B1BF;
	Tue, 14 Dec 2021 09:48:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B90214B0ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:48:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XOtFScBVTVK0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 09:48:42 -0500 (EST)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F9AA4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:48:42 -0500 (EST)
Received: by mail-io1-f50.google.com with SMTP id p23so24498000iod.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GLws1fv1VvQ+JdMbCyDoHLq+rkRsysRGV91MeqRMLdM=;
 b=eviPoIzpJMZdqH8yuSUhoKHalI4tyZogPyEoK8h12DRJoxZ0Ab7m31ZEODVknuaUcK
 WvUVetw7Alaz4hJSjVAWjhx7KCT5kx/lOgBR+hC0BcDwiEStS301DAsf2gy4tAmQkiB4
 WfwWMsaZHzfsY69AxbS9wLCyQZXDDni+SPH8F6ioe13dcus2bBNrG6zAVFu7RocBzMgh
 +uYvoeYFBRJReekBk/AkCZpxAXDLQPPWrxL4XoZObuiURRFgb0ZcFTgxeZDmPplF+63A
 owOfqrAQ9Fre27IS9uvk8WtFqJuHNK27IoUeVwcojxXSCUdOROipbAGl10vnihs+9rYV
 OggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GLws1fv1VvQ+JdMbCyDoHLq+rkRsysRGV91MeqRMLdM=;
 b=uXS36um5ApZPSjszWM6utyntMlQLqvvNIAxCy04EhYWIFvZZAXtMm4KjSMAoQZxx6j
 W7jBEd6mdje/7778j1WI4X21zInK0l4FSjFZkXldi/5dX1pJDiGXLfHRST6UhPL6KCyS
 f4TWms3NWBgUY251xZTmeaA3W5Iv2aNy0j4Sd46I+CH0Y+yjfxUdMj0mXNmlXHEvucvf
 EDk1kOvi7xUyA9vnj/E0Oop07yMitE4qLhUSmXMW+YhYjb2CLIdNqrX7KVL5x/jqlQ5o
 jc6ZSmE9th4Z4daf53QG9OdLC5sAsQAfRwaJ+aBBpmtx+dpaB8p3KElo+KIs61xfk1UG
 TXQA==
X-Gm-Message-State: AOAM532Qkta1kDYYdD2r0S3CTXyuR6I9ILFRFlQOA8V/fJl/QyTjZ9j4
 uVad9/GlyDLnl3j7fqfnoKMLCEvhLdvuNJydp3XdxQ==
X-Google-Smtp-Source: ABdhPJwDobqQ0ytVa0HxNlcgE4bESeMZUOEn4HcyugZoluHpS2Q4fWuEd3GtI+jUITR45jghm1HTYm2iOEJoB2ew/AQ=
X-Received: by 2002:a02:6945:: with SMTP id e66mr3303073jac.620.1639493321703; 
 Tue, 14 Dec 2021 06:48:41 -0800 (PST)
MIME-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-11-qperret@google.com>
In-Reply-To: <20211201170411.1561936-11-qperret@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Tue, 14 Dec 2021 14:48:30 +0000
Message-ID: <CA+_y_2HKwtm5839QyEY9D8PaZWky_Zvn3msrw2gcR2Z7UZgObQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] KVM: arm64: Introduce wrappers for host and hyp
 spin lock accessors
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, 1 Dec 2021 at 17:04, 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> From: Will Deacon <will@kernel.org>
>
> In preparation for adding additional locked sections for manipulating
> page-tables at EL2, introduce some simple wrappers around the host and
> hypervisor locks so that it's a bit easier to read and bit more difficult
> to take the wrong lock (or even take them in the wrong order).
Looks good, but how does this help prevent taking locks in the wrong order?

>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 32 ++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index c1a90dd022b8..757dfefe3aeb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -27,6 +27,26 @@ static struct hyp_pool host_s2_pool;
>
>  const u8 pkvm_hyp_id = 1;
>
> +static void host_lock_component(void)
> +{
> +       hyp_spin_lock(&host_kvm.lock);
> +}
> +
> +static void host_unlock_component(void)
> +{
> +       hyp_spin_unlock(&host_kvm.lock);
> +}
> +
> +static void hyp_lock_component(void)
> +{
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +}
> +
> +static void hyp_unlock_component(void)
> +{
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +}
> +
>  static void *host_s2_zalloc_pages_exact(size_t size)
>  {
>         void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
> @@ -338,14 +358,14 @@ static int host_stage2_idmap(u64 addr)
>
>         prot = is_memory ? PKVM_HOST_MEM_PROT : PKVM_HOST_MMIO_PROT;
>
> -       hyp_spin_lock(&host_kvm.lock);
> +       host_lock_component();
>         ret = host_stage2_adjust_range(addr, &range);
>         if (ret)
>                 goto unlock;
>
>         ret = host_stage2_idmap_locked(range.start, range.end - range.start, prot);
>  unlock:
> -       hyp_spin_unlock(&host_kvm.lock);
> +       host_unlock_component();
>
>         return ret;
>  }
> @@ -369,8 +389,8 @@ int __pkvm_host_share_hyp(u64 pfn)
>         if (!addr_is_memory(addr))
>                 return -EINVAL;
>
> -       hyp_spin_lock(&host_kvm.lock);
> -       hyp_spin_lock(&pkvm_pgd_lock);
> +       host_lock_component();
> +       hyp_lock_component();
>
>         ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, NULL);
>         if (ret)
> @@ -432,8 +452,8 @@ int __pkvm_host_share_hyp(u64 pfn)
>         BUG_ON(ret);
>
>  unlock:
> -       hyp_spin_unlock(&pkvm_pgd_lock);
> -       hyp_spin_unlock(&host_kvm.lock);
> +       hyp_unlock_component();
> +       host_unlock_component();
>
>         return ret;
>  }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
