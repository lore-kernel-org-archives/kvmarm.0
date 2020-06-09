Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F08C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A94D20760
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="jGKUzdkM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A94D20760
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 381694B2BD;
	Wed, 10 Jun 2020 07:20:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TaN+b0-CjeRQ; Wed, 10 Jun 2020 07:20:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E521A4B2D2;
	Wed, 10 Jun 2020 07:20:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0448E4B1B0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 18:57:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LclIk8-2sqyw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 18:57:47 -0400 (EDT)
Received: from mail-ua1-f65.google.com (mail-ua1-f65.google.com
 [209.85.222.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23BA34B199
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 18:57:47 -0400 (EDT)
Received: by mail-ua1-f65.google.com with SMTP id t26so181697ual.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Jun 2020 15:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Xl5EexOSop6lv+UL7XlaACYBiSImdbhXFtk47GA4aNo=;
 b=jGKUzdkMHAPPrsDAO+KgKuAkBcwZtqhUNuimhvROzoJ9soMzQeLhFacPERf2F1XAt1
 d2bGPLktS4oAbDypyJsO1bp4jOu+yrHrzisYt7q9+K1Hi0hoL3YOduunxwK7YD7Qt7z0
 y3licW0I0Hm1qOPCUTKLoyKQp/3B2kLD9SN+DIFf4qUocN8tZ+JcyuvkpeJa+Nx5P9Na
 1hfqO82s7cJ49zBil2iU4uF0YAvQfZ67+OT8TQ3PAwA47G7EZ666/1ojukkE3Jpdnxbt
 eMot5sAzs9ckGI/LQ9GzRveHRIuIi8iCm7iWgocOAu+Hv9q8sX3vAn7FZhDyBYP80Kmo
 spbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Xl5EexOSop6lv+UL7XlaACYBiSImdbhXFtk47GA4aNo=;
 b=cdo6ZTCZH0Wz3eVikhbKrwjszxQXL/S3oV/J3za/i732vYELsaeVUFqChoPlKB/ULp
 YzbJDxAwglZlirIipyql88+RKUgmEgJEhMI/WdQpW5vxPhqufLXbVukcTYrucMMWF6HX
 AtXyLyx4NgVUJ7O8bNsXi+aKhy+bL1Ui8OoNHj8lwb+TF9h3otPWoV4zXrmROmosUAZc
 zuSLIugiuGGY3HqkTDQ5G152gv8/0dFtM8TQ3aSa0s8zYjyjSs1Y4LDnN+Gh/+J24G9N
 joSJPw97H1qgX0MU+5LVHWeXjer8VPvguG9XwNRWHTUg/rtZOmomPtXWQXM8NFyAstpX
 sbrw==
X-Gm-Message-State: AOAM533cPRpHJhXS/q34Tw5uxyv9VXhCxKpyLayPFEZ0ahdWdMgk6YTU
 hQqorV/gYBh+cqQfc0xoRKvVrOsKy9vVzSquQV6hVQ==
X-Google-Smtp-Source: ABdhPJw+x8rHkvjQXtHjLxkujrakxTirbbawkFrKZAQkOg8tp5FX1PiZ/3qyVw3h4kYT7bC0/YyoJYi+dfxe0RsUL8o=
X-Received: by 2002:ab0:70c9:: with SMTP id r9mr536687ual.15.1591743466435;
 Tue, 09 Jun 2020 15:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-5-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-5-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Tue, 9 Jun 2020 15:57:35 -0700
Message-ID: <CANgfPd8p=SzkWucGm=a-ajRMfYmY1sPjeXBeZ6cHeAviQg9pag@mail.gmail.com>
Subject: Re: [PATCH 04/21] KVM: x86/mmu: Remove superfluous gotos from
 mmu_topup_memory_caches()
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 10 Jun 2020 07:20:46 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Return errors directly from mmu_topup_memory_caches() instead of
> branching to a label that does the same.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 36c90f004ef4..ba70de24a5b0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1100,13 +1100,11 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
>                                    8 + PTE_PREFETCH_NUM);
>         if (r)
> -               goto out;
> +               return r;
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache, 8);
>         if (r)
> -               goto out;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
> -out:
> -       return r;
> +               return r;
> +       return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
