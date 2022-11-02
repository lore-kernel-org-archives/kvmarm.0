Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEBF6D18
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 16:11:11 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 64so355055pgc.5
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 09:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=CvrNB5XxJiSve646tIQrpYaVoPFSVLVMtTZ2NiWMNv2VTqFMD/bUMK8k3+Wjg6dGyl
         Or4Hb2LdEODwhDmqMU60lbKwjlFyX8AOZmlfl6s5FRp5jJ8ppTelqIP5gqap7b3N8Ezh
         CWtt3QZ2iW9AgXVoVWgrXPGlGeH8YeH2SRdzT5dcMcqSsXui2IDUVK9Y54S84kMPm4qr
         JUC3BemLJpIjLZWYNVUE8GgtnqE8np5LXkO+Co8xqpNg5dfb2hmKO2UnWec9/OncAeYm
         S1aCSo13zY9GyFZwmbovTO9GSCadLNAhTPkt34OVwNmrx97+8zX0OjGvMEZTPvehHYcE
         Klsg==
X-Gm-Message-State: ACrzQf12zRZc/2XFtAt2pOSVk8i7RrdqQ3pTKhoWN1AN4ihSsWY1DzCR
	vPyU5G/gW9E3pzPOxD9UmbG6pA==
X-Google-Smtp-Source: AMsMyM40y/EP1XZjLr8u5d95J50ow6Qq/UpZGFYNazWh9EsURT6JqjOG9NRHwf0ExoNxySlBc1J0Zw==
X-Received: by 2002:a63:8b42:0:b0:46f:5bd0:1ae2 with SMTP id j63-20020a638b42000000b0046f5bd01ae2mr21786579pge.422.1667405471018;
        Wed, 02 Nov 2022 09:11:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902710f00b001885041d7b8sm77000pll.293.2022.11.02.09.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:11:10 -0700 (PDT)
Date: Wed, 2 Nov 2022 16:11:07 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, oliver.upton@linux.dev, james.morse@arm.com,
	shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KWm8wiL3jBryMI@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867d0de4b0.wl-maz@kernel.org>
Message-ID: <20221102161107.g97C3NuRgwhG5QNpDCh69_x5YQ9rpKj8qaDW73HjtQI@z>

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
