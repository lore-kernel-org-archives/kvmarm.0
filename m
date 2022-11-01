Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25268C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  1 Nov 2022 19:39:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E704BAC1;
	Tue,  1 Nov 2022 15:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JdloP2KqAfyg; Tue,  1 Nov 2022 15:39:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6669A4BAC2;
	Tue,  1 Nov 2022 15:39:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 834D24BAB1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 15:39:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q9RvknT6RrT1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 15:39:31 -0400 (EDT)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3198A4BA2B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 15:39:31 -0400 (EDT)
Received: by mail-pf1-f179.google.com with SMTP id 130so14406940pfu.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2022 12:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=zg1ylwFbHOB9+NiTrqgNIpDjxaw+qSqR/kyoeoWEHuK8gkevAPzOtNG8B3vFv2zCas
 mz0bjHyiH65O9SAVQtSxqm/sSrta8kR+SKNtWzYxoi8caDrn6gxgIh0d+sHIsYikhmWX
 LFeLbvza7zpqS7bZzOVygC0hNtwbt/OTCF5xM7A+yFweD2gKXZKNRzFt59dXSbNlnER3
 mxkG9E0SRJQJUKQC/d9K3fVJdf4VpMk+boPRA0t7r2RDPp4uiKtcktIM1LJFgQ6MWIKX
 9qdt4kbr7GqaPIDosaTrcM/4I0b4sCIRb3/Q/6jxzi877zaDZjFyPRf2aD0ikH8tGuA7
 bjRA==
X-Gm-Message-State: ACrzQf3oRXvD5otCIzw8AMO/n+wRynXlBRvIHVFjHnbZKZfPw6xAg7YG
 rIfhJ31tFA9OJL8R05pEOnBCWA==
X-Google-Smtp-Source: AMsMyM7y1Oh83Y/hQ+zELq6lqCQy6nyQlUDKZUw2/ZCPUhQWvl3BJiU2S+q1OeuYAM5aix2PbSxXSQ==
X-Received: by 2002:a63:89c3:0:b0:46e:d2d9:a960 with SMTP id
 v186-20020a6389c3000000b0046ed2d9a960mr18383448pgd.329.1667331569800; 
 Tue, 01 Nov 2022 12:39:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 b7-20020aa78ec7000000b0056262811c5fsm6862296pfr.59.2022.11.01.12.39.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Nov 2022 12:39:29 -0700 (PDT)
Date: Tue, 1 Nov 2022 19:39:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2F17Y7YG5Z9XnOJ@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-2-gshan@redhat.com>
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
