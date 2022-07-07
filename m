Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36908C43334
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jul 2022 20:59:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA5B4B83D;
	Thu,  7 Jul 2022 16:59:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6UJVuaHznfO4; Thu,  7 Jul 2022 16:59:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F05D4B861;
	Thu,  7 Jul 2022 16:59:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0FA4B861
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 16:59:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FXW7RWEe5mFW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2022 16:59:46 -0400 (EDT)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 887BE4B83D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 16:59:46 -0400 (EDT)
Received: by mail-pg1-f175.google.com with SMTP id o18so19481529pgu.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jul 2022 13:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=A5MhBcXf8LVQ9gbV4fE8wcZW4gjzBdDH9411SgBm9nA=;
 b=JZQC6m6xR5sT0Jada7pN2ctPDZoVBgPNmsmVFV9xaOD0K1VcjdaDGI+Dbb9m6z+j0M
 HQZao2MwdnxdUCyFyWlgXqE0vhn5k0x3cFJEqeUSkVEsaLaami6rP5dYbVbdIFtecFK0
 bszrtlQ/BBq6HtrtoG8nU1E+PvhE0lLr6U7Movo+h1ZN1VwhTvdz1ZHCpBxehT1XrGLp
 ldw665ro4GytFHnalr0o9hUTUOKVZe4kPdeCD4oNOEE/cifAyBR7BH7HyjVvjpbMGLv/
 wuBFBMUf1JFMK20mDchKuifuX9NzhPRD+zMlfMD3Uo00M9pihW0RWuo1fPBLXJlg8Qnc
 EHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=A5MhBcXf8LVQ9gbV4fE8wcZW4gjzBdDH9411SgBm9nA=;
 b=aO9LCGG8YuAcu28M2gRJh1MXeRUjYdxKs2fgAyFecc5oTlnYrnghUu8Vly77xOj2d3
 2kgAhWMm6kbTQjv6BcP7oRvj8dj9Z4J2JWnostwAPEykLPk0206qeb1KQsZzAkjpR16a
 zmfCEo4/4j6KVygFyfBNknOXrIxlAli9T+pVf35gIss7I56W1PpLctBjnXFSbqtTeGe8
 9nmd8b7WkXQmLmBdqUvbyzzaql6nZNrcN5Ui34BJUyZvYrWFUhiJOosLC1tSD136jUqh
 cprV7+vwBw+wLBkIo+v69VA5N1IDiM2otES/2tq4OQhHMIik5GI0K9z8cN+rUzbLEjwx
 mDiw==
X-Gm-Message-State: AJIora9ugwsQHoQKJRxYYpcwBzubfOi90UjG90NemX5P6XlDD93Ajn/4
 Zn2CoB0MyJ6lsKETuFQ3A7PSKQ==
X-Google-Smtp-Source: AGRyM1sARh3FSc0YJzBOfjfu9tVk8n9I1lJXGq5XAEdqRD+A3gMvMxGVzqr9kHPYDPOxaQ6woa23oA==
X-Received: by 2002:a63:4756:0:b0:412:88b5:2a23 with SMTP id
 w22-20020a634756000000b0041288b52a23mr11516pgk.442.1657227585430; 
 Thu, 07 Jul 2022 13:59:45 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 rt5-20020a17090b508500b001ef8ac4c681sm22733pjb.0.2022.07.07.13.59.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Jul 2022 13:59:44 -0700 (PDT)
Date: Thu, 7 Jul 2022 20:59:41 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <YsdJPeVOqlj4cf2a@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-2-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Huang@google.com,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> We keep track of several kernel memory stats (total kernel memory, page
> tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> per-memcg, etc). These stats give insights to users to how much memory
> is used by the kernel and for what purposes.
> 
> Currently, memory used by kvm mmu is not accounted in any of those

Nit, capitalize KVM (mainly to be consistent).

> @@ -1085,6 +1086,9 @@ KernelStack
>                Memory consumed by the kernel stacks of all tasks
>  PageTables
>                Memory consumed by userspace page tables
> +SecPageTables
> +              Memory consumed by secondary page tables, this currently
> +	      currently includes KVM mmu allocations on x86 and arm64.

Nit, this line has a tab instead of eight spaces.  Not sure if it actually matters,
there are plenty of tabs elsewhere in the file, but all the entries in this block
use only spaces.

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index aab70355d64f3..13190d298c986 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -216,6 +216,7 @@ enum node_stat_item {
>  	NR_KERNEL_SCS_KB,	/* measured in KiB */
>  #endif
>  	NR_PAGETABLE,		/* used for pagetables */
> +	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */

Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
is messy, so I totally understand why you included it, but in this case it's unnecessary
and potentially confusing.

And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
(using IS_ENABLED() because KVM can be built as a module)?  That could be removed
if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
stats the depend on a single feature seems to be the status quo for this code.

>  #ifdef CONFIG_SWAP
>  	NR_SWAPCACHE,
>  #endif
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
