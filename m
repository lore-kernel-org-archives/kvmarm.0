Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D632EC16
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 19:26:46 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-25e803def73so407502a91.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 12:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686770805; x=1689362805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMoZVBBfAkPJKgsC9TR9d3GGxsO25gF0HsErm4KOn9w=;
        b=VUAau8TOMKQ3oHB9kg8YFP7Oq22r/p+u3cdV5cLi1CW8fh3wktB0cNjzHumTXCKhVX
         MxntIO6xZR11kSqSPcaD1PJGjmeOgWZXDpmzfeoaMhfdyZr6z1hhV62a6OzrwEMxbWDg
         uWktLUI7ZBBfYBxbcd3H80W/W1z0a2uBsONuBy3NxGtuBb+8kiw/HOjXzQdRkVe+VVHX
         wSR9OvDo9qVg23ER08IIdyUWfEcBtENty+CHaEoZVy5uMoEcptz2tqJYPsffLSxFfooS
         U9/rA82ugPJckLF8Dg9UlEepEZqHSTf7wcaHOZzyBwkD7/K2MjrPUtGLOdZNNtRcU/LU
         spWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686770805; x=1689362805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMoZVBBfAkPJKgsC9TR9d3GGxsO25gF0HsErm4KOn9w=;
        b=gI/CGmt6ZhgnUeR1sfldqWkKpFpP2AKUFb2QA6Qpgzp6Hn8c73bOYFjFlNIPsgvdZ/
         hVkmUPxM1rRKyzWtwiVrhlwHkPVFZlO+C2cqS1Br1cgXuu9xR/56hHSt/8HqxMjhAfsQ
         auekf9ibbKt+MbRzQjdSNdHLlncKdSSYvfh/NtkpUUhx8OgtM1sVlPR3wkp0k5FzXUO9
         bUCtldi8xP1RPujq2Ukg/HrIVVIfXFzMVdpZjiWSIsqX1XobPgNfWJForgX6JiJ9cKLd
         ydo8ruObywQErHlH4+H/zLygqa45ECvJ1fB0vx5c3suB1h1NMBoGYeqhDxwpmOHb46N7
         h9Rg==
X-Gm-Message-State: AC+VfDyqosiH9/RP2kH6ftixjmtMH6QUsgq5USdbrU8FfJLlpO7wW97u
	Clu/G1LW0Cp7EuTE2zPzLRTE3F9eqmY=
X-Google-Smtp-Source: ACHHUZ7UY/1dGDE3Zk8+hssNCDQ9Ipi/kqHb2vuOsuwkF68VkWgX3v+6zrE0+PsnZX+5BgxV70uRL71I0MU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a684:b0:25b:ea08:d641 with SMTP id
 d4-20020a17090aa68400b0025bea08d641mr412405pjq.7.1686770805592; Wed, 14 Jun
 2023 12:26:45 -0700 (PDT)
Date: Wed, 14 Jun 2023 12:26:43 -0700
In-Reply-To: <20230602161921.208564-8-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-8-amoorthy@google.com>
Message-ID: <ZIoUc2hLd0zMOhO+@google.com>
Subject: Re: [PATCH v4 07/16] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
> duplicate the "if (writable)" block. Fix this by bringing all
> kvm_is_error_hva() cases under one conditional.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b9d2606f9251..05d6e7e3994d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2711,16 +2711,14 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>  	if (hva)
>  		*hva = addr;
>  
> -	if (addr == KVM_HVA_ERR_RO_BAD) {
> -		if (writable)
> -			*writable = false;
> -		return KVM_PFN_ERR_RO_FAULT;
> -	}
> -
>  	if (kvm_is_error_hva(addr)) {
>  		if (writable)
>  			*writable = false;
> -		return KVM_PFN_NOSLOT;
> +
> +		if (addr == KVM_HVA_ERR_RO_BAD)
> +			return KVM_PFN_ERR_RO_FAULT;
> +		else
> +			return KVM_PFN_NOSLOT;

Similar to an earlier patch, preferred style for terminal if-statements is

		if (addr == KVM_HVA_ERR_RO_BAD)
			return KVM_PFN_ERR_RO_FAULT;

		return KVM_PFN_NOSLOT;

Again, there are reasons for the style/rule.  In this case, it will yield a smaller
diff (obviously not a huge deal, but helpful), and it makes it more obvious that
the taken path of "if (kvm_is_error_hva(addr))" is itself terminal.

Alternatively, a ternary operator is often used for these types of things, though
in this case I much prefer the above, as I find the below hard to read.

		return addr == KVM_HVA_ERR_RO_BAD ? KVM_PFN_ERR_RO_FAULT :
						    KVM_PFN_NOSLOT;
