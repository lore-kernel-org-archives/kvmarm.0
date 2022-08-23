Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455FEC32772
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 21:20:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A93444C7F2;
	Tue, 23 Aug 2022 17:20:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DWPpBZmC2kym; Tue, 23 Aug 2022 17:20:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25F184C7F8;
	Tue, 23 Aug 2022 17:20:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A511A4C7F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 17:20:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JbikI9Tv7pxH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 17:20:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 450734C7E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 17:20:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661289637;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=kDxp6lecacjb98wPWPmNSJC/XwpRER4yjzQFhNWbLNM=;
 b=LapdVoMNAGWTWjgpYmYLQ4vonCfDxnRcX87VFp6LI/MIQza07lHAjkG3gwtlJAYFErD5ZC
 60BfNaR7hrlV0Fy/hozixRuxTUGU8S9k0b3HbsS/5yq/qcB5cYO4Diaum/llojJurNEnF2
 6EV0BP1QnUatMkqkNRh0GZoPmsl2x00=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-27Khq6L7Pi2Cz9QoWgyVxQ-1; Tue, 23 Aug 2022 17:20:35 -0400
X-MC-Unique: 27Khq6L7Pi2Cz9QoWgyVxQ-1
Received: by mail-qt1-f198.google.com with SMTP id
 bq11-20020a05622a1c0b00b003434f125b77so11655178qtb.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 14:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=kDxp6lecacjb98wPWPmNSJC/XwpRER4yjzQFhNWbLNM=;
 b=P5in64l8gIEBs4mzcQVarwmiM/ylwhabBh4brLVn3Eqs+/wDwsjGOKdzefLbtTL1dM
 V+cHv+O3PF3cKS7c3ke0DVDQ54gQgYryyInbLouulKzehe+uFBMSoR211EBO97sgMisK
 LSJADYkhjWKkv4OB7NTu58RMPSI/GIF3WK0x8vbas2YOxJfQcpV6P947jLdgQz6Yz0sH
 N4xdFnoElaVI+l2zynA7NcVjKhM1w/gV3MKbiHv4hFl98p12QLi8rVJMUq1whLJPyi3p
 3bip5PeH0W8eM8xIBNYHex3CatoP0hkPcY+ImYSSZZEsZMjFatnmGgZtolclMqh7w2s4
 qg1g==
X-Gm-Message-State: ACgBeo166r9IulOkmJryw1qZvAp5WGyIYMe2E/no3BQ7RSiWUP8cMny8
 UmC7Uiza4nhiNaE5IyT2Uyr2EkJnaI3pwbzNviUI4/mDy82VaaJXuchjn0IcLw3NJObWFMs0rhI
 xik/Qnz/4VcsoyRy/Cqh4W5WR
X-Received: by 2002:a05:6214:260e:b0:496:a6eb:94f8 with SMTP id
 gu14-20020a056214260e00b00496a6eb94f8mr22195738qvb.85.1661289635341; 
 Tue, 23 Aug 2022 14:20:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4GdFOFVsCT3Z0e/Gt12h73jfCtvxPLR/EbAAo1gDtVfbTot9LLeAXrj+uVOfZeMFzXQ4FYkQ==
X-Received: by 2002:a05:6214:260e:b0:496:a6eb:94f8 with SMTP id
 gu14-20020a056214260e00b00496a6eb94f8mr22195695qvb.85.1661289634982; 
 Tue, 23 Aug 2022 14:20:34 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
 by smtp.gmail.com with ESMTPSA id
 q8-20020a05620a2a4800b006bb756ce754sm14406977qkp.55.2022.08.23.14.20.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Aug 2022 14:20:34 -0700 (PDT)
Date: Tue, 23 Aug 2022 17:20:32 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <YwVEoM1pj2MPCELp@xz-m1.local>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
 <YwTc++Lz6lh3aR4F@xz-m1.local> <87bksawz0w.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87bksawz0w.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, will@kernel.org,
 shan.gavin@gmail.com, drjones@redhat.com, zhenyzha@redhat.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com
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

On Tue, Aug 23, 2022 at 08:17:03PM +0100, Marc Zyngier wrote:
> I don't think we really need this check on the hot path. All we need
> is to make the request sticky until userspace gets their act together
> and consumes elements in the ring. Something like:
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 986cee6fbc7f..e8ed5e1af159 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -747,6 +747,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>  			return kvm_vcpu_suspend(vcpu);
> +
> +		if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
> +		    kvm_dirty_ring_soft_full(vcpu)) {
> +			kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> +			trace_kvm_dirty_ring_exit(vcpu);
> +			return 0;
> +		}
>  	}
>  
>  	return 1;

Right, this seems working.  We can also use kvm_test_request() here.

> 
> 
> However, I'm a bit concerned by the reset side of things. It iterates
> over the vcpus and expects the view of each ring to be consistent,
> even if userspace is hacking at it from another CPU. For example, I
> can't see what guarantees that the kernel observes the writes from
> userspace in the order they are being performed (the documentation
> provides no requirements other than "it must collect the dirty GFNs in
> sequence", which doesn't mean much from an ordering perspective).
> 
> I can see that working on a strongly ordered architecture, but on
> something as relaxed as ARM, the CPUs may^Wwill aggressively reorder
> stuff that isn't explicitly ordered. I have the feeling that a CAS
> operation on both sides would be enough, but someone who actually
> understands how this works should have a look...

I definitely don't think I 100% understand all the ordering things since
they're complicated.. but my understanding is that the reset procedure
didn't need memory barrier (unlike pushing, where we have explicit wmb),
because we assumed the userapp is not hostile so logically it should only
modify the flags which is a 32bit field, assuming atomicity guaranteed.

IIRC we used to discuss similar questions on "what if the user is hostile
and wants to hack the process by messing up with the ring", and our
conclusion was as long as the process wouldn't mess up anything outside
itself it should be okay. E.g. It should not be able to either cause the
host to misfunction, or trigger kernel warnings in dmesg, etc..

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
