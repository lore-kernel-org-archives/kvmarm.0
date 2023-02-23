Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BB82F2A
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 17:14:00 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536bbaeceeaso137925457b3.11
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 09:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m9a3DVsbLLCiizvc2aec2wajhEpcLeonWEm+iefIJpg=;
        b=j3+/xNXOW39AcGdiBKIT1ULTMkq8kVSikEDQybzdeJTRA37B2kpy80N5M1Dei878R4
         GaXaFfuMncInfPEX5RJTGpdyozZsflbRf0Gbtl9jxACTZgei3XQt5U/WYSeMd7/i64ow
         U135uPNxlmsPv4ItCwhl7oyYE5w1QhCJKJqaOclKSAWU/aWhnoTHIOiSvrruZaqQt8na
         Uh+YugdR1H4UVdnaJ09b/cgGqLEYVq8/f44xVjwZH2YLIIBd4i/f1Jr7SEfqqKiHZfK4
         er44ZBZpMwi5PZXjKu21H2yJPHQNutcaEZjY0olLohqu9AmYfM91IghN2CDVI97loorS
         tx3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m9a3DVsbLLCiizvc2aec2wajhEpcLeonWEm+iefIJpg=;
        b=BVe8QG1z2zkO0IEo//yU0nbvY/dnqIZN5qZ5K7+y6dp5+LT9ZHnzUmcz4UQ7295Y27
         TdGt+PS1Pc12aAvpOUijDiBMEfcCDEWeE7xIi0gIZTreMmGmJK8r88iCyPKOV1+/cuzq
         5Isjbzd/XqMgefSHpQHx6JitYyB6ZHQeUX6jneE21J10y3DVDkLs/JhUxQWEM9EyUvLz
         Uwz2pGIycilD23mYT+VWALXHcTqoqcyyt9DevOtrr6SLuW2KDgCFM8e9edrGAhgI9dP/
         gN8qIJFqnwJKTncaLxqKIh73k7oJ0ueED2DoYRM+jUf8gtiPj80XGoXa+aZTdhx9xnb7
         lCXA==
X-Gm-Message-State: AO0yUKXu8dJqy1oAdDGXmC9WadQpY1DivwcuAToZwPvpdlE54JFvU+OO
	nkB/X2dHZXtH5LjxFkW2m7yfqzgAkCI=
X-Google-Smtp-Source: AK7set/sBYiVXprfoygydPUN0hrU35/k2bW+OOgTOU9cAUD3HKKiCHjKS7O05xDs1Rmfdd/bjv5qKqc6wMY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c9:b0:855:fdcb:4467 with SMTP id
 w9-20020a05690210c900b00855fdcb4467mr3661788ybu.0.1677172439635; Thu, 23 Feb
 2023 09:13:59 -0800 (PST)
Date: Thu, 23 Feb 2023 09:13:58 -0800
In-Reply-To: <20230217041230.2417228-2-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-2-yuzhao@google.com>
Message-ID: <Y/ee1s3XPGa62SFV@google.com>
Subject: Re: [PATCH mm-unstable v1 1/5] mm/kvm: add mmu_notifier_test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 16, 2023, Yu Zhao wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9c60384b5ae0..1b465df4a93d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -875,6 +875,63 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
>  	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
>  }
>  
> +static bool kvm_test_clear_young(struct kvm *kvm, unsigned long start,
> +				 unsigned long end, unsigned long *bitmap)
> +{
> +	int i;
> +	int key;
> +	bool success = true;
> +
> +	trace_kvm_age_hva(start, end);
> +
> +	key = srcu_read_lock(&kvm->srcu);
> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct interval_tree_node *node;
> +		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
> +
> +		kvm_for_each_memslot_in_hva_range(node, slots, start, end - 1) {
> +			gfn_t lsb_gfn;
> +			unsigned long hva_start, hva_end;
> +			struct kvm_gfn_range range = {
> +				.slot = container_of(node, struct kvm_memory_slot,
> +						     hva_node[slots->node_idx]),
> +			};
> +
> +			hva_start = max(start, range.slot->userspace_addr);
> +			hva_end = min(end - 1, range.slot->userspace_addr +
> +					       range.slot->npages * PAGE_SIZE - 1);
> +
> +			range.start = hva_to_gfn_memslot(hva_start, range.slot);
> +			range.end = hva_to_gfn_memslot(hva_end, range.slot) + 1;
> +
> +			if (WARN_ON_ONCE(range.end <= range.start))
> +				continue;

Extend __kvm_handle_hva_range() instead of copy-pasting.  At a very quick glance,
I believe all that is needed is (minus sanity checks):

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..3296ae2cf6fa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -544,6 +544,7 @@ struct kvm_hva_range {
        hva_handler_t handler;
        on_lock_fn_t on_lock;
        on_unlock_fn_t on_unlock;
+       bool lockless;
        bool flush_on_ret;
        bool may_block;
 };
@@ -616,7 +617,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
                        gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
                        gfn_range.slot = slot;
 
-                       if (!locked) {
+                       if (!range->lockless && !locked) {
                                locked = true;
                                KVM_MMU_LOCK(kvm);
                                if (!IS_KVM_NULL_FN(range->on_lock))

> +
> +			/* see the comments on the generic kvm_arch_has_test_clear_young() */
> +			lsb_gfn = hva_to_gfn_memslot(end - 1, range.slot);
> +
> +			success = kvm_arch_test_clear_young(kvm, &range, lsb_gfn, bitmap);
> +			if (!success)
> +				break;
> +		}
> +	}
> +
> +	srcu_read_unlock(&kvm->srcu, key);
> +
> +	return success;
> +}
