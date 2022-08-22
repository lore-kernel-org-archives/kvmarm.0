Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A1AC28D13
	for <kvmarm@archiver.kernel.org>; Mon, 22 Aug 2022 18:56:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29B9D4CAAE;
	Mon, 22 Aug 2022 14:56:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rrztqLDHCn-U; Mon, 22 Aug 2022 14:56:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4F6F4CAAB;
	Mon, 22 Aug 2022 14:56:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8244CAA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 14:56:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ttHyCF8FzP8P for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 14:56:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4290B4CAA5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 14:56:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661194560;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6Sc/GFE/h4auZJmdG2OSNqDhNL2VL4Oyu1Hp2vRC3HE=;
 b=Nw83tg1/OYHthpzCVXPi7OuUSWE05fgMc+kx9OOP51J5BMydsfnfsLYY4AKv23jdOSKczs
 Tt5QyBR4QpD06R5zcxQq53A7+h2L1BFTE1D1AC0xBXZ9mH+BDRbJN5Y96f9Z4tZy1KAb7e
 mS1eYRvzOh0G2wMAHAUYV269KglW2lc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-400-u75xnk5WOIqrVdHAxnobwQ-1; Mon, 22 Aug 2022 14:55:58 -0400
X-MC-Unique: u75xnk5WOIqrVdHAxnobwQ-1
Received: by mail-qv1-f69.google.com with SMTP id
 s5-20020ad45005000000b00496db0fd2eeso2200623qvo.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 11:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=6Sc/GFE/h4auZJmdG2OSNqDhNL2VL4Oyu1Hp2vRC3HE=;
 b=xsyG1bYknXEs3Bn65jTNM7i5BSTLsiO8jd+KzZ+goFVLCTtzzkYl6Cat8nMHTKtfbt
 mHemw0QqOqKMDE/iesY3jVdqt0cAJCv5XrwagIgOQcBV2zRu6KPlsyybr7uU2/LyyO9H
 rsow8bnDkjRdJp+87784eyR8ZPjw5lpsGfWE7kAW2yaLkmlfqNn2maxNt2JyGTEtBVUe
 Jn+P0+iv9eje1qKGoyBmn4pVUdDIgv9bC47PR2hgChA34hKJBj+tLjx3mhe1wLsYuhK+
 aD73qk/9Uw7vAlVHy5BS4bheHoMMm+gn/IjQLyxixVXhftZ9MxLE7z9gRQRRDilpZZxY
 be8Q==
X-Gm-Message-State: ACgBeo2o7BS+I2rHBkz6buFQ05bdBroY31lhuRje7XUAZNBSif+MEHTF
 SbkFxjQbVS9xO1wUTTFe60pUTVw9mOreC4EfCDtZ7ogOIepoLnY7S0GSzsNmfqbFIqNmMbfBDQd
 LUdcAJU6kxKoK5qy2NRmXDFlZ
X-Received: by 2002:a05:622a:451:b0:344:ad2f:692c with SMTP id
 o17-20020a05622a045100b00344ad2f692cmr9157284qtx.604.1661194558425; 
 Mon, 22 Aug 2022 11:55:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4SPwSXVCYhU6Mx1Y/ng2/oG6o7hMCWS3u5m4ddUxyWRbRC8YCvqK2IPkivSnUKC63Wynm2Tg==
X-Received: by 2002:a05:622a:451:b0:344:ad2f:692c with SMTP id
 o17-20020a05622a045100b00344ad2f692cmr9157248qtx.604.1661194558179; 
 Mon, 22 Aug 2022 11:55:58 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
 by smtp.gmail.com with ESMTPSA id
 n1-20020ac86741000000b0031eebfcb369sm9093468qtp.97.2022.08.22.11.55.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Aug 2022 11:55:57 -0700 (PDT)
Date: Mon, 22 Aug 2022 14:55:55 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <YwPRO0r2sfzcbgyz@xz-m1.local>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
MIME-Version: 1.0
In-Reply-To: <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
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

Hi, Gavin,

On Mon, Aug 22, 2022 at 11:58:20AM +1000, Gavin Shan wrote:
> > For context, the documentation says:
> > 
> > <quote>
> > - if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
> >    KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE. [...]
> > </quote>
> > 
> > What is the reason for picking this particular value?
> > 
> 
> It's inherited from x86. I don't think it has to be this particular value.
> The value is used to distinguish the region's owners like kvm_run, KVM_PIO_PAGE_OFFSET,
> KVM_COALESCED_MMIO_PAGE_OFFSET, and KVM_DIRTY_LOG_PAGE_OFFSET.
> 
> How about to have 2 for KVM_DIRTY_LOG_PAGE_OFFSET in next revision?
> The virtual area is cheap, I guess it's also nice to use x86's
> pattern to have 64 for KVM_DIRTY_LOG_PAGE_OFFSET.
> 
>     #define KVM_COALESCED_MMIO_PAGE_OFFSET   1
>     #define KVM_DIRTY_LOG_PAGE_OFFSET        2

It was chosen not to be continuous of previous used offset because it'll be
the 1st vcpu region that can cover multiple & dynamic number of pages.  I
wanted to leave the 3-63 (x86 used offset 2 already) for small fields so
they can be continuous, which looks a little bit cleaner.

Currently how many pages it'll use depends on the size set by the user,
though there's a max size limited by KVM_DIRTY_RING_MAX_ENTRIES, which is a
maximum of 1MB memory.

So I think setting it to 2 is okay, as long as we keep the rest 1MB address
space for the per-vcpu ring structure, so any new vcpu fields (even if only
1 page will be needed) need to be after that maximum size of the ring.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
