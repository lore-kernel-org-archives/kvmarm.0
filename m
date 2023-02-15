Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428527B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:23:58 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id i3-20020a170902cf0300b00198bc9ba4edso11260656plg.21
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z8XgdVCHLDGerl9CH+Uw77y0aKIOybxdkgSS6TMAQV8=;
        b=L9Nbpj1siBLBB5Us+5f2jfjwucMHajEh5TTAXnrzu0MDKW+uDkRTop5aVVgWSK39Ms
         ferXEibNt/uBTq/2nba+l3gljLCjNEXabcIW8275zZD0kxjYU2bvdW7RVWaDSviG89LX
         ++GR1H/GjnlOM6FZoSqhniNoqeMlz9K3dWz3x0cJC/zE0nWOiTZzzi1m7y7zswHc8Mpr
         1/Gi8Ze/k1F5nKlV2cqCQBJO/mZx7eXCLYJo9nOnd8xDx6gdE4Q91+i8ClCZ6twtNr6o
         2q0nQpmzLq28/sZ4AMWH6N6dSk5QWuf4n3If6OwkNuH1WyUkRMG0MZzdx2iKPLpjmYUK
         zyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8XgdVCHLDGerl9CH+Uw77y0aKIOybxdkgSS6TMAQV8=;
        b=tEQPtCXw0pxfE5TBUgQBYZs1l9VF8MJh6kCIRRKlbZjE3M7GDx5Jy0e3l0SP0XqqBc
         3ueeSVxuq3t9K14fnDTLE8BwOKXWUMxWVjL+emCJgcHkhYOJ2XZ2Q6H+W+LG9x6k5luz
         +r3hicho/hi2KF3R3DHCN+WyjsM0XsUHWDY2Tl+cX2qbTSNpe5OAQQxu+E90WU2ODeTr
         d0JiQfFvpkCS6U3hwrUNKpW6Ynyh+0fRDXNsbVc2m6b3CU6jmXsQU3LUJKUT+mXNyOH8
         aD4mx0aJiBL4xwaPCLDfpTN6TMCJ1DUfz8txJ0j3LGxKo8XjHoyH7vuMEpuIXzkjXzH8
         ghxg==
X-Gm-Message-State: AO0yUKWciYlOHB6qdQSNefSCF3Mp5RO62XZpisB0zggQL5EiDbFDauMX
	afTD/lCL8mmD0ZBpzKabBZFcIwymDBE=
X-Google-Smtp-Source: AK7set/5+mb1fmC9ApA1Q0S/ZUsqTBh3iCFHMq2Yet5Kr4wXEEW+Hq5OID645zh77eKCD/N0sQDwphsMA7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6d45:0:b0:4fb:919b:d9a2 with SMTP id
 i66-20020a636d45000000b004fb919bd9a2mr471594pgc.4.1676481837656; Wed, 15 Feb
 2023 09:23:57 -0800 (PST)
Date: Wed, 15 Feb 2023 09:23:55 -0800
In-Reply-To: <20230215011614.725983-7-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-7-amoorthy@google.com>
Message-ID: <Y+0VK6vZpMqAQ2Dc@google.com>
Subject: Re: [PATCH 6/8] kvm/x86: Add mem fault exit on EPT violations
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Houghton <jthoughton@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 15, 2023, Anish Moorthy wrote:
> With the relevant kvm cap enabled, EPT violations will exit to userspace
> w/ reason KVM_EXIT_MEMORY_FAULT instead of resolving the fault via slow
> get_user_pages.

Similar to the other patch's feedback, please rewrite the changelog to phrase the
changes as commands, not as descriptions of the resulting behavior.

> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Suggested-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++++++++++---
>  arch/x86/kvm/x86.c     |  1 +
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index aeb240b339f54..28af8d60adee6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4201,6 +4201,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
>  	bool async;
> +	bool mem_fault_nowait;
>  
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> @@ -4230,9 +4231,25 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	}
>  
>  	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +	mem_fault_nowait = memory_faults_enabled(vcpu->kvm);
> +
> +	fault->pfn = __gfn_to_pfn_memslot(
> +		slot, fault->gfn,
> +		mem_fault_nowait,

Hrm, as prep work for this series, I think we should first clean up the pile o'
bools.  This came up before when the "interruptible" flag was added[*].  We punted
then, but I think it's time to bite the bullet, especially since "nowait" and
"async" need to be mutually exclusive.

[*] https://lore.kernel.org/all/YrR9i3yHzh5ftOxB@google.com

> +		false,
> +		mem_fault_nowait ? NULL : &async,
> +		fault->write, &fault->map_writable,
> +		&fault->hva);

Same comments as the other patch: follow kernel style, not google3's madness :-)

> +	if (mem_fault_nowait) {
> +		if (fault->pfn == KVM_PFN_ERR_FAULT) {
> +			vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +			vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
> +			vcpu->run->memory_fault.size = PAGE_SIZE;

This belongs in a separate patch, and the exit stuff should be filled in by
kvm_handle_error_pfn().  Then this if-statement goes away entirely because the
"if (!async)" will always evaluate true in the nowait case.

> +		}
> +		return RET_PF_CONTINUE;
> +	}
> +
>  	if (!async)
>  		return RET_PF_CONTINUE; /* *pfn has correct page already */
>  
