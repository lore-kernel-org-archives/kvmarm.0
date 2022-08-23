Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486D4C32774
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 13:58:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A71954D380;
	Tue, 23 Aug 2022 09:58:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BQHP38SILCsz; Tue, 23 Aug 2022 09:58:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0D0A4D388;
	Tue, 23 Aug 2022 09:58:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B83384D385
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 09:58:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sR6l4Ah56z+w for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 09:58:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DAFF4D380
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 09:58:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661263104;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=YHVefDGXU83xWUJyLerizfLITJD1h0bvpZUJLhnlk24=;
 b=AXO1SNmNaxNAq3ngFOkjpwKd9OjFxUtQlCxgejQIg8YZhdDKJzOyAzsl0mGVGXKUuO3hpU
 dxBSGLCI7QSqq5QwrWgBYdTx5HvdDZpa7Fm4cD8qFL0wMh389YJCml7DFA11upm7Hy0FHT
 o9nsIdQoVq8WoDhDI1ANKETuLGKrX5A=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-65nbs69kMm60F7DjlSCTFg-1; Tue, 23 Aug 2022 09:58:23 -0400
X-MC-Unique: 65nbs69kMm60F7DjlSCTFg-1
Received: by mail-qt1-f197.google.com with SMTP id
 cm10-20020a05622a250a00b003437b745ccdso10608106qtb.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 06:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=YHVefDGXU83xWUJyLerizfLITJD1h0bvpZUJLhnlk24=;
 b=XQYB2g/GHhb1cW81yf4kGirjPzgLYZ9MNSmF48nw2xIzzikhLmCqLVJo3cmelH/CWo
 5z25Ke/JUbi7xiymsEvIDcZ1KcXz70mPVctDvjarvsneho8BkCZ0bkjwRHgVSFE5+e7U
 2AliJFsMLDXR20FtZJP1ngj64UA1KF9z2IHTpuAibF/oza3T9L+nYvSP5EEsZV95iHDN
 8cyhqH50ETyLGphvtdnwNzBVi4nH2o0uBD7EnpNn5XyVnTc3NLpaM6zwrSdFFSZkheoR
 WY71zmQ41DXsFPGKXqZTOOH0e9B8nF9DEUGKn1BOoXJFNsOX6Dlp2dPJ0XLxtkiZIq+m
 vv1Q==
X-Gm-Message-State: ACgBeo0uVtpEDf7hzRZh9VmR8oAt6pQTtpdrI7G9Zx2rYSCsxGwJzgeF
 N6aPVQDIGdFx5XfKmxI068X/MXb3UL5y3jMqKhs1BeqQaDA1/m3UJ7UqWApkZK+H/yIbj55h8G1
 Lzi2Simq2XxjEqJtjJMJP/Dbj
X-Received: by 2002:ac8:5b15:0:b0:343:6789:193a with SMTP id
 m21-20020ac85b15000000b003436789193amr19117276qtw.647.1661263102679; 
 Tue, 23 Aug 2022 06:58:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7gd2yWDFVr17SP2RU0l4eAn5No/A726n2hPHBkND28yI2ySau6/YWpTWAdi0/4trPHGWQO6g==
X-Received: by 2002:ac8:5b15:0:b0:343:6789:193a with SMTP id
 m21-20020ac85b15000000b003436789193amr19117247qtw.647.1661263102418; 
 Tue, 23 Aug 2022 06:58:22 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
 by smtp.gmail.com with ESMTPSA id
 g7-20020a05620a40c700b006a6ebde4799sm12544646qko.90.2022.08.23.06.58.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Aug 2022 06:58:21 -0700 (PDT)
Date: Tue, 23 Aug 2022 09:58:19 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <YwTc++Lz6lh3aR4F@xz-m1.local>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
MIME-Version: 1.0
In-Reply-To: <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, Marc Zyngier <maz@kernel.org>,
 shan.gavin@gmail.com, drjones@redhat.com, will@kernel.org, zhenyzha@redhat.com,
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

On Tue, Aug 23, 2022 at 03:22:17PM +1000, Gavin Shan wrote:
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 986cee6fbc7f..0b41feb6fb7d 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -747,6 +747,12 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> >   		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> >   			return kvm_vcpu_suspend(vcpu);
> > +
> > +		if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu)) {
> > +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> > +			trace_kvm_dirty_ring_exit(vcpu);
> > +			return 0;
> > +		}
> >   	}
> >   	return 1;
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index f4c2a6eb1666..08b2f01164fa 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -149,6 +149,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> >   void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> >   {
> > +	struct kvm_vcpu *vcpu = container_of(ring, struct kvm_vcpu, dirty_ring);
> >   	struct kvm_dirty_gfn *entry;
> >   	/* It should never get full */
> > @@ -166,6 +167,9 @@ void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> >   	kvm_dirty_gfn_set_dirtied(entry);
> >   	ring->dirty_index++;
> >   	trace_kvm_dirty_ring_push(ring, slot, offset);
> > +
> > +	if (kvm_dirty_ring_soft_full(vcpu))
> > +		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> >   }
> >   struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
> > 
> 
> Ok, thanks for the details, Marc. I will adopt your code in next revision :)

Note that there can be a slight difference with the old/new code, in that
an (especially malicious) userapp can logically ignore the DIRTY_RING_FULL
vmexit and keep kicking VCPU_RUN with the new code.

Unlike the old code, the 2nd/3rd/... KVM_RUN will still run in the new code
until the next dirty pfn being pushed to the ring, then it'll request ring
full exit again.

Each time it exits the ring grows 1.

At last iiuc it can easily hit the ring full and trigger the warning at the
entry of kvm_dirty_ring_push():

	/* It should never get full */
	WARN_ON_ONCE(kvm_dirty_ring_full(ring));

We did that because kvm_dirty_ring_push() was previously designed to not be
able to fail at all (e.g., in the old bitmap world we never will fail too).
We can't because we can't lose any dirty page or migration could silently
fail too (consider when we do user exit due to ring full and migration just
completed; there could be unsynced pages on src/dst).

So even though the old approach will need to read kvm->dirty_ring_size for
every entrance which is a pity, it will avoid issue above.

Side note: for x86 the dirty ring check was put at the entrance not because
it needs to be the highest priority - it should really be the same when
check kvm requests. It's just that it'll be the fastest way to fail
properly if needed before loading mmu, disabling preemption/irq, etc.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
