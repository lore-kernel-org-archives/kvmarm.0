Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BDD7E
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 19:39:30 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id h2so14313123pgp.4
        for <kvmarm@lists.linux.dev>; Tue, 01 Nov 2022 12:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tnEODX2baOxy8d43W9uFCYaWlAQWT5w4AwPUA+Xic0c=;
        b=NWg9Qf4jep8QtwAzp6LlGIBZ9WQD30RO5yMyObW05gSJG0RMgAVotBdXfDg/PFd7xS
         wCgCLMtq5WSobjNO9MYRFanOAIe42cCUImyWBJwXI8lQ1IxIx07DZtoRY54cUC4l3g5S
         UG9dDF1oqM0F4NJQBNPBytpWImiAMW/09OKcI+od9oiV/Khh+0eTOsRQ/FXclq4kKpE4
         IdLvAE1X9Umsd54HDWZuQPvjoOdvKQ+0x3WcG/43TeY0YpKQrcpZVVnrmUlXN6EoA1/J
         VNt0Oux+EbMueltF5UC/wafegmCKmhF/wOFdvOcmi+hzEKeFg9bK6RlnOmaRXyMP/fN+
         T/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnEODX2baOxy8d43W9uFCYaWlAQWT5w4AwPUA+Xic0c=;
        b=KhaUzIbOf90sS/FkWxHlp0lsDn/BJ89rMTMmRoKfPIKt5fossFSWBOwLuUzZ+8O0Nd
         Vh1ZDc9liBXBx570YrSeqfZ3kpKV0PIVNxcIO3FEam3GWWOfFyyt214r3OtpOt+lhaOZ
         7P+Xxn+tM87B4Y/4/de5Z3xtzxkFc6lRbrhWPqGAmjlm/LbPennf0pzayxuYzwcH3F7B
         76KU5V+5mnsrxn5zUVHCu2WT6qfKJLpLEnH+5+b+YzlORRfo6Q4m+hdabgIn6Sj58AXL
         egG5Gj/fGhc5KHSLZfsOtzS2TWbCeiNiT/JS8m/ej/8CWsGPoIuuAkeU5fGB/ZYpGXOy
         qPbQ==
X-Gm-Message-State: ACrzQf1vOgdsvGhmtY/N5Maxf7KztxG836LwETyOgkiI+gsF8LL80/CU
	RJ4jYh5ZuN3vW5WNCwM99/kgTg==
X-Google-Smtp-Source: AMsMyM7y1Oh83Y/hQ+zELq6lqCQy6nyQlUDKZUw2/ZCPUhQWvl3BJiU2S+q1OeuYAM5aix2PbSxXSQ==
X-Received: by 2002:a63:89c3:0:b0:46e:d2d9:a960 with SMTP id v186-20020a6389c3000000b0046ed2d9a960mr18383448pgd.329.1667331569800;
        Tue, 01 Nov 2022 12:39:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b7-20020aa78ec7000000b0056262811c5fsm6862296pfr.59.2022.11.01.12.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 12:39:29 -0700 (PDT)
Date: Tue, 1 Nov 2022 19:39:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
	james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2F17Y7YG5Z9XnOJ@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-2-gshan@redhat.com>
Message-ID: <20221101193925.MjOyjWXSMtbohJwhcSNkQECW0oF5_gu_jEFa_ykv_mI@z>

On Mon, Oct 31, 2022, Gavin Shan wrote:
> The VCPU isn't expected to be runnable when the dirty ring becomes soft
> full, until the dirty pages are harvested and the dirty ring is reset
> from userspace. So there is a check in each guest's entrace to see if
> the dirty ring is soft full or not. The VCPU is stopped from running if
> its dirty ring has been soft full. The similar check will be needed when
> the feature is going to be supported on ARM64. As Marc Zyngier suggested,
> a new event will avoid pointless overhead to check the size of the dirty
> ring ('vcpu->kvm->dirty_ring_size') in each guest's entrance.
> 
> Add KVM_REQ_DIRTY_RING_SOFT_FULL. The event is raised when the dirty ring
> becomes soft full in kvm_dirty_ring_push(). The event is cleared in the
> check, done in the newly added helper kvm_dirty_ring_check_request(), or
> when the dirty ring is reset by userspace. Since the VCPU is not runnable
> when the dirty ring becomes soft full, the KVM_REQ_DIRTY_RING_SOFT_FULL
> event is always set to prevent the VCPU from running until the dirty pages
> are harvested and the dirty ring is reset by userspace.
> 
> kvm_dirty_ring_soft_full() becomes a private function with the newly added
> helper kvm_dirty_ring_check_request(). The alignment for the various event
> definitions in kvm_host.h is changed to tab character by the way. In order
> to avoid using 'container_of()', the argument @ring is replaced by @vcpu
> in kvm_dirty_ring_push() and kvm_dirty_ring_reset(). The argument @kvm to
> kvm_dirty_ring_reset() is dropped since it can be retrieved from the VCPU.
> 
> Link: https://lore.kernel.org/kvmarm/87lerkwtm5.wl-maz@kernel.org
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> @@ -142,13 +144,17 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>  
>  	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>  
> +	if (!kvm_dirty_ring_soft_full(ring))
> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> +

Marc, Peter, and/or Paolo, can you confirm that clearing the request here won't
cause ordering problems?  Logically, this makes perfect sense (to me, since I
suggested it), but I'm mildly concerned I'm overlooking an edge case where KVM
could end up with a soft-full ring but no pending request.

>  	trace_kvm_dirty_ring_reset(ring);
>  
>  	return count;
>  }
>  
