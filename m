Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB376D3F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 21:20:35 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bb2fae9b286so1130040276.3
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 14:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686777634; x=1689369634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x6hmc6akWZOXS6z57inXO64YQNQW6poAh6GVOTwAKPI=;
        b=wIvB/HT/XmzHwNVWmyp4gmc9ivMsqG6Vv+COxc694rcZRkSui7P0fdvEyRLm/RIo8c
         7C6nStlgSUi8l94T+XiRi7phPIx5ApGS2Dxfld5jVKNyn/Z9mFWzz/8yfdF7uPsWHBs9
         ZusULuK0gkIyHC73eD9oSibp9POPfmzMbBrXe3+yfDY9aAYMYBniUjH8PPMVbYFKOVAF
         BzjUIVjJmzBJIagyUMDpv1vwgDxiFO2x9nzlYnnrWQ9N+yMM9YCTFx++JKDpP2rzfdJn
         OWlV0iUsEDO9vzdxXcNsHrQ02mCED5KCVK2hoa3DaSDo2pxCP5VSUMfv5Y0mA12Q34d/
         2L0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686777634; x=1689369634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x6hmc6akWZOXS6z57inXO64YQNQW6poAh6GVOTwAKPI=;
        b=HGFem2xhmwZ+v5HA36U+U2WMudmpUVO8otArzOuPSe0xhVaLtH0jkRrtOE8RHpwwiy
         fwmB4s+DWSe8CdjgWcL+58WR1PfzNxf4ruhG/6EJcBgCIFFa9JdLX+B1tXsCzTvSuR1Y
         33kZgSSlLFkuUmT93u+GJEsA3dhZ9FhHZ2nnc37afJ/Mxf3t0/v9By1yWc4znJ1TnTQ/
         P3SDBPBF951hroSTw3FGBq22noSVtY6x/VAKSzoIqW64/JT9ORZ1u1hhGOAYRYJA5REo
         r8iJT6oOWl5w5e9brcEEEGBBN38Jb/tkiSjXmqGHocf4hb+yLQMv8wu6MshJ5KNhzSQV
         5Ahg==
X-Gm-Message-State: AC+VfDzG/p7N4mr6bu6F33iUTg4MclcW06Ly0ZcDuBJCwZjk/8nvOiqM
	ePeLd6z9LzWJPN+TnKvi5/qOjIYmw2Y=
X-Google-Smtp-Source: ACHHUZ7/OAjVtrru1qxA+/Rr5tOMBJ37bkvlWQL8ZDLr371hkMHH9s1uHK7jXpwqUhzy6BE8Id0Xvpy0vvs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e6c7:0:b0:bc6:8b95:5bd6 with SMTP id
 d190-20020a25e6c7000000b00bc68b955bd6mr451694ybh.1.1686777634367; Wed, 14 Jun
 2023 14:20:34 -0700 (PDT)
Date: Wed, 14 Jun 2023 14:20:32 -0700
In-Reply-To: <20230602161921.208564-10-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
Message-ID: <ZIovIBVLIM69E5Bo@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 69a221f71914..abbc5dd72292 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2297,4 +2297,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>   */
>  inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
>  				     uint64_t gpa, uint64_t len, uint64_t flags);
> +
> +static inline bool kvm_slot_nowait_on_fault(
> +	const struct kvm_memory_slot *slot)

Just when I was starting to think that we had beat all of the Google3 out of you :-)

And predicate helpers in KVM typically have "is" or "has" in the name, so that it's
clear the helper queries, versus e.g. sets the flag or something. 

> +{
> +	return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;

KVM is anything but consistent, but if the helper is likely to be called without
a known good memslot, it probably makes sense to have the helper check for NULL,
e.g.

static inline bool kvm_is_slot_nowait_on_fault(const struct kvm_memory_slot *slot)
{
	return slot && slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
}

However, do we actually need to force vendor code to query nowait?  At a glance,
the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslot() are
in flows that play nice with nowait or that don't support it at all.  So I *think*
we can do this?

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be06b09e9104..78024318286d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2403,6 +2403,11 @@ static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
        return slot->flags & KVM_MEM_READONLY;
 }
 
+static bool memslot_is_nowait_on_fault(const struct kvm_memory_slot *slot)
+{
+       return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
+}
+
 static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
                                       gfn_t *nr_pages, bool write)
 {
@@ -2730,6 +2735,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
                writable = NULL;
        }
 
+       if (async && memslot_is_nowait_on_fault(slot)) {
+               *async = false;
+               async = NULL;
+       }
+
        return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
                          writable);
 }

Ah, crud.  The above highlights something I missed in v3.  The memslot NOWAIT
flag isn't tied to FOLL_NOWAIT, it's really truly a "fast-only" flag.  And even
more confusingly, KVM does set FOLL_NOWAIT, but for the async #PF case, which will
get even more confusing if/when KVM uses FOLL_NOWAIT internally.

Drat.  I really like the NOWAIT name, but unfortunately it doesn't do what as the
name says.

I still don't love "fast-only" as that bleeds kernel internals to userspace.
Anyone have ideas?  Maybe something about not installing new mappings?
