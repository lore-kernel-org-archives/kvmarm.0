Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740E2F2A
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 17:43:33 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id k3-20020a170902ce0300b0019ca6e66303so2943786plg.18
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 09:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uEW2x7lvcZVgNquM9X5miuc098m/bUXcKiqyROdfsvA=;
        b=GnEFv8ZYEKJq2FLsbqFXmOIsxOoE4EVShbkz1ukBp++CxWl81cjyx0bklp6nXH3I70
         1Dn7JrVCVuKLElNcGdQ1U6YXznFPEHlKh91jnsTXumsHU8puSiTvyoKnzjCVZbQPKnWS
         QXdxzapoB+4T797LXxDe2I0aHK2NBTy6Rw4ivHdiib/6jaI04ABl+Dtf1ReAAkKNrGSl
         8NHnqSqy6ru6z4leh6bzy1EQMm6tgE5IBBFzAYn+bp+FpfKImc6YedR1CZMkmMlPEp36
         c2HXP4yjSNThuM60YRVKyVgt+SlF71LlRuX35DyTXLuiC4Od9uaQKbklKgKjNGtAO3hZ
         O4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uEW2x7lvcZVgNquM9X5miuc098m/bUXcKiqyROdfsvA=;
        b=K2qMtXmQiSeR/DzI8iybCaNqIbF89pTV7gqbhPFQbTCswrFAUsuxMzMZV3g0KahLW9
         UMISEahkztDHxBPU5OKHt31zk5w1IHrPKNcDPq0SDTALgz8jcTCtrYR8+ZyPdn93ByNn
         RqOcHedOQhmM240V+1o7053dukBJcAUTkPFGzocaO0gr304DmyDsEMtLzre3B5jbIyc1
         C/WBDC4QUAbwHwxY8iSY9vEiGx7mrXYGnxAoeTI+3Vb5sCmVP3hZj0cC6BO6X84tfC+I
         ExNZOAXj5Px44JF3dIqgl5eGYwfMug3pgbD7TLNMzliHsIozu3X7DEnOnJFWNwingOs/
         Hwqw==
X-Gm-Message-State: AO0yUKXcALprDEcFkizlGWJHqM051e43Y92QmX+VYZGcBn9nsnSauJqf
	uDx3CTA6NCo9Mi7sAbzzKp7y1mqdHqY=
X-Google-Smtp-Source: AK7set83+Pnlpt5peCqIhQBtdMvaXZZfXzsbtxsBRoLRt6jnUdFR+O/gyNEyxZMgKJ7oNYHyvpri8MhadHU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6944:0:b0:4fd:2170:b2da with SMTP id
 w4-20020a656944000000b004fd2170b2damr1506614pgq.0.1677174212817; Thu, 23 Feb
 2023 09:43:32 -0800 (PST)
Date: Thu, 23 Feb 2023 09:43:31 -0800
In-Reply-To: <20230217041230.2417228-6-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
Message-ID: <Y/elw7CTvVWt0Js6@google.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 16, 2023, Yu Zhao wrote:
> An existing selftest can quickly demonstrate the effectiveness of this
> patch. On a generic workstation equipped with 128 CPUs and 256GB DRAM:

Not my area of maintenance, but a non-existent changelog (for all intents and
purposes) for a change of this size and complexity is not acceptable.

>   $ sudo max_guest_memory_test -c 64 -m 250 -s 250
> 
>   MGLRU      run2
>   ---------------
>   Before    ~600s
>   After      ~50s
>   Off       ~250s
> 
>   kswapd (MGLRU before)
>     100.00%  balance_pgdat
>       100.00%  shrink_node
>         100.00%  shrink_one
>           99.97%  try_to_shrink_lruvec
>             99.06%  evict_folios
>               97.41%  shrink_folio_list
>                 31.33%  folio_referenced
>                   31.06%  rmap_walk_file
>                     30.89%  folio_referenced_one
>                       20.83%  __mmu_notifier_clear_flush_young
>                         20.54%  kvm_mmu_notifier_clear_flush_young
>   =>                      19.34%  _raw_write_lock
> 
>   kswapd (MGLRU after)
>     100.00%  balance_pgdat
>       100.00%  shrink_node
>         100.00%  shrink_one
>           99.97%  try_to_shrink_lruvec
>             99.51%  evict_folios
>               71.70%  shrink_folio_list
>                 7.08%  folio_referenced
>                   6.78%  rmap_walk_file
>                     6.72%  folio_referenced_one
>                       5.60%  lru_gen_look_around
>   =>                    1.53%  __mmu_notifier_test_clear_young

Do you happen to know how much of the improvement is due to batching, and how
much is due to using a walkless walk?

> @@ -5699,6 +5797,9 @@ static ssize_t show_enabled(struct kobject *kobj, struct kobj_attribute *attr, c
>  	if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
>  		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
>  
> +	if (kvm_arch_has_test_clear_young() && get_cap(LRU_GEN_SPTE_WALK))
> +		caps |= BIT(LRU_GEN_SPTE_WALK);

As alluded to in patch 1, unless batching the walks even if KVM does _not_ support
a lockless walk is somehow _worse_ than using the existing mmu_notifier_clear_flush_young(),
I think batching the calls should be conditional only on LRU_GEN_SPTE_WALK.  Or
if we want to avoid batching when there are no mmu_notifier listeners, probe
mmu_notifiers.  But don't call into KVM directly.
