Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CDAC38145
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 00:19:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86EEA4B242;
	Thu,  1 Sep 2022 20:19:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LxDkKo+AcUJ8; Thu,  1 Sep 2022 20:19:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A7F349EC3;
	Thu,  1 Sep 2022 20:19:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C355549EC3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 20:19:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UkQ+iYKIS1S9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2022 20:19:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9118F49EBC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 20:19:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1662077993;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dO2Mn5n5WZ/MoIF+K7eeDvmnGSBHo08xkcQ+P3b4bKQ=;
 b=PR97N8GBIP3oRjUE0ZmzIrDPsFYxWnOd+tAGOuuQiuvMg/Xfu7a5HWblUeRL/RnO9a9MoY
 nopCXMF0kzJkgaN9z8crbSCOlHdkkBpXDcBkPIuHQCcQmVNq+Z9Y3LbC9KttYzdp+SkUuj
 rAIp8mm8XRI9A3VFSNJOH0bMlFDvPB8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-MnUEqDsfPiewPi_I8PDK-w-1; Thu, 01 Sep 2022 20:19:50 -0400
X-MC-Unique: MnUEqDsfPiewPi_I8PDK-w-1
Received: by mail-ej1-f70.google.com with SMTP id
 qf22-20020a1709077f1600b00741638c5f3cso157235ejc.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2022 17:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=dO2Mn5n5WZ/MoIF+K7eeDvmnGSBHo08xkcQ+P3b4bKQ=;
 b=oqAEfCijKXg0222thY+wMFrd1kg3Vd1d4BGRrcC2tsAavHlYh6XuJysxvyEXJ7/fVS
 0zGZtE9qtDrDHiN4NAVAY7U4wc7qiflQGAHon7M92iGhPrMf6Fvv5OgEj68u9pFfZrJT
 wn7QaV9gbRZE0deeFl0NJ5fq+NBS6/FbvsMUYHzMSNblEdkjUTvRRJttc0/gPPcXnNDr
 CKu7QFoyuSIUkG1uBHKvHl7n5ENRQQydKK9Cyn4MQFj/yTQ4hQhUnFEz8oQjq6BJaBwA
 a6VSAIE9XcIJY1cuJBNm4tFoiHaJDnTXz4soqH/bBvU6ZhW85aOpHSKIuXU4Xw26s0GS
 fGEQ==
X-Gm-Message-State: ACgBeo1mCXU3dJ9iyIR4aeuoN43D7jpTUGlcC0ZJiU24R15Fo7qclwno
 u36DikQR3ksb9VNKLTQdO12avmBGog4ypbLcd5UbQD4KdMwQinjeH6xUC2Yqhi+D0nneRtgFC5i
 3jSYQC5jvvshIRk3+eRvwT9w3
X-Received: by 2002:a17:906:4795:b0:73d:d6e8:52a7 with SMTP id
 cw21-20020a170906479500b0073dd6e852a7mr23729566ejc.59.1662077988841; 
 Thu, 01 Sep 2022 17:19:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR71etqoXM4HGXVz/MwtlqW3T8BbNkFPT5a/e9qOoDZWnrG77GI6lD81PpRdFOR9EqVhGDa/oA==
X-Received: by 2002:a17:906:4795:b0:73d:d6e8:52a7 with SMTP id
 cw21-20020a170906479500b0073dd6e852a7mr23729550ejc.59.1662077988617; 
 Thu, 01 Sep 2022 17:19:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 lb14-20020a170907784e00b00741a0c3f4cdsm352041ejc.189.2022.09.01.17.19.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 01 Sep 2022 17:19:48 -0700 (PDT)
Message-ID: <44a42d03-4dd1-3f1c-3a60-7c2a6a7d417a@redhat.com>
Date: Fri, 2 Sep 2022 02:19:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
To: Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com> <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org> <YwTn2r6FLCx9mAU7@google.com>
 <87a67uwve8.wl-maz@kernel.org>
 <99364855-b4e9-8a69-e1ca-ed09d103e4c8@redhat.com>
 <874jxzvxak.wl-maz@kernel.org> <Yw4hyEAyivKT35vQ@xz-m1.local>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
In-Reply-To: <Yw4hyEAyivKT35vQ@xz-m1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, will@kernel.org,
 shan.gavin@gmail.com, drjones@redhat.com, zhenyzha@redhat.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 8/30/22 16:42, Peter Xu wrote:
> Marc,
> 
> I thought we won't hit this as long as we properly take care of other
> orderings of (a) gfn push, and (b) gfn collect, but after a second thought
> I think it's indeed logically possible that with a reversed ordering here
> we can be reading some garbage gfn before (a) happens butt also read the
> valid flag after (b).
> 
> It seems we must have all the barriers correctly applied always.  If that's
> correct, do you perhaps mean something like this to just add the last piece
> of barrier?

Okay, so I thought about it some more and it's quite tricky.

Strictly speaking, the synchronization is just between userspace and 
kernel. The fact that the actual producer of dirty pages is in another 
CPU is a red herring, because reset only cares about harvested pages.

In other words, the dirty page ring is essentially two ring buffers in 
one and we only care about the "harvested ring", not the "produced ring".

On the other hand, it may happen that userspace has set more RESET flags 
while the ioctl is ongoing:


     CPU0                     CPU1               CPU2
                                                 fill gfn0
                                                 store-rel flags for gfn0
                                                 fill gfn1
                                                 store-rel flags for gfn1
     load-acq flags for gfn0
     set RESET for gfn0
     load-acq flags for gfn1
     set RESET for gfn1
     do ioctl! ----------->
                              ioctl(RESET_RINGS)
                                                 fill gfn2
                                                 store-rel flags for gfn2
     load-acq flags for gfn2
     set RESET for gfn2
                              process gfn0
                              process gfn1
                              process gfn2
     do ioctl!
     etc.

The three load-acquire in CPU0 synchronize with the three store-release 
in CPU2, but CPU0 and CPU1 are only synchronized up to gfn1 and CPU1 may 
miss gfn2's fields other than flags.

The kernel must be able to cope with invalid values of the fields, and 
userspace will invoke the ioctl once more.  However, once the RESET flag 
is cleared on gfn2, it is lost forever, therefore in the above scenario 
CPU1 must read the correct value of gfn2's fields.

Therefore RESET must be set with a store-release, that will synchronize 
with a load-acquire in CPU1 as you suggested.

Paolo

> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index f4c2a6eb1666..ea620bfb012d 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -84,7 +84,7 @@ static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
>  
>  static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>  {
> -       return gfn->flags & KVM_DIRTY_GFN_F_RESET;
> +       return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>  }
>  
>  int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> ===8<===
> 
> Thanks,
> 
> -- 
> Peter Xu
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
