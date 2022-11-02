Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCECC4167B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:11:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2EE84B955;
	Wed,  2 Nov 2022 12:11:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5BQWlPBUbHkW; Wed,  2 Nov 2022 12:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1CB74B95A;
	Wed,  2 Nov 2022 12:11:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4215D4B93C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:11:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SNA+z7jPvoIK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:11:12 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B8804B941
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:11:12 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id b29so16789084pfp.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=xjbiGog+CMLFws9ba0e8gTV0L7Jl5w0vMwDQ7UNnmBw=;
 b=fg5ss+yu7hOd7zMQAayXu1r5V5FRoeiX0Ib8rbO1Hbpnplg28DwPoTzY3KXbp2IM5l
 c8LhKRuFMH0LpjHZqJ/2MO63rmotIEtPBD0D+rrJYFHPwGvPjKFUWsaM0f6Or6MD+PMa
 xWZBW7C28NlVRSBqddoR8LLJS5WgYHillPL2TPvWLB/q/bsrRkhbFv47BZ6Sjtk0FQVM
 enNFn/n81hHrMVGNCRCSpNhDfglnUMmtyta2ATX+wgX831Gh9RjaU/U3AQkd3cynJHeo
 U+5ETSrGJcaCiKGZdkgrI0jt9/jJ9kNO/LscVkh2clSBXP1iXeLU5+XbUTtSax048fuO
 WbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=xjbiGog+CMLFws9ba0e8gTV0L7Jl5w0vMwDQ7UNnmBw=;
 b=d6XFMql/dDxE0kN9cp/GDV4BoFSpmJ7RWbzzMKUPXITkDx2lCqFSagw5AzLdmez4mn
 tLnnmmrPG9IsWpWokho/ak2tkbWTTlE0zL/1j/ALyGDGbSNc1f/xxMEnbA5gLhDAv+6A
 xWQxN5Zu8tv1L7EwzzhFDQITlje2LFuizCe9fzcX+ShCF/UBZpdY12NUrDcU/vlH0Sku
 AI7e32JLKxL5YmULqBxdgHXjOyBZCw6gz3fJCqUDp/+Fn4to6kdGqNQcTM7D2vUlALw3
 R39z7WmVToKuupkcuUc9ZOZ63xUrVq4H1dad+SEFkd6Ww2i3Ofi7C0kvLOC5oOJsTZYy
 IOgA==
X-Gm-Message-State: ACrzQf1sy2yxA0sE9+9dklQqHFRSceUUMuZgwcm4mGJ3ihDJA9BxRy83
 scc7fkUVg7I1CNm5pUodP9WxQg==
X-Google-Smtp-Source: AMsMyM40y/EP1XZjLr8u5d95J50ow6Qq/UpZGFYNazWh9EsURT6JqjOG9NRHwf0ExoNxySlBc1J0Zw==
X-Received: by 2002:a63:8b42:0:b0:46f:5bd0:1ae2 with SMTP id
 j63-20020a638b42000000b0046f5bd01ae2mr21786579pge.422.1667405471018; 
 Wed, 02 Nov 2022 09:11:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 a15-20020a170902710f00b001885041d7b8sm77000pll.293.2022.11.02.09.11.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:11:10 -0700 (PDT)
Date: Wed, 2 Nov 2022 16:11:07 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KWm8wiL3jBryMI@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com> <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <867d0de4b0.wl-maz@kernel.org>
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

On Wed, Nov 02, 2022, Marc Zyngier wrote:
> On Wed, 02 Nov 2022 14:29:26 +0000, Peter Xu <peterx@redhat.com> wrote:
> > However I don't see anything stops a simple "race" to trigger like below:
> > 
> >           recycle thread                   vcpu thread
> >           --------------                   -----------
> >       if (!dirty_ring_soft_full)                                   <--- not full
> >                                         dirty_ring_push();
> >                                         if (dirty_ring_soft_full)  <--- full due to the push
> >                                             set_request(SOFT_FULL);
> >           clear_request(SOFT_FULL);                                <--- can wrongly clear the request?
> >
> 
> Hmmm, well spotted. That's another ugly effect of the recycle thread
> playing with someone else's toys.
> 
> > But I don't think that's a huge matter, as it'll just let the vcpu to have
> > one more chance to do another round of KVM_RUN.  Normally I think it means
> > there can be one more dirty GFN (perhaps there're cases that it can push >1
> > gfns for one KVM_RUN cycle?  I never figured out the details here, but
> > still..) pushed to the ring so closer to the hard limit, but we have had a
> > buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
> > that's still fine, but maybe worth a short comment here?
> > 
> > I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
> > cycle.  It would be good if there's an answer to that from anyone.
> 
> This is dangerous, and I'd rather not go there.
> 
> It is starting to look like we need the recycle thread to get out of
> the way. And to be honest:
> 
> +	if (!kvm_dirty_ring_soft_full(ring))
> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> 
> seems rather superfluous. Only clearing the flag in the vcpu entry
> path feels much saner, and I can't see anything that would break.
> 
> Thoughts?

I've no objections to dropping the clear on reset, I suggested it primarily so
that it would be easier to understand what action causes the dirty ring to become
not-full.  I agree that the explicit clear is unnecessary from a functional
perspective.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
