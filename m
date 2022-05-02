Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F45C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 07:57:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 293074B18F;
	Mon,  2 May 2022 03:57:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pz8O6AZr3P13; Mon,  2 May 2022 03:57:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB2D4B172;
	Mon,  2 May 2022 03:57:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96C474B172
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:57:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RnE2GPuDCYec for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 03:57:49 -0400 (EDT)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BF624B16F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:57:49 -0400 (EDT)
Received: by mail-il1-f179.google.com with SMTP id h11so2844173ila.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 00:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1o9QvsSc9YvDxD2nqC58JtY0N0kXxGCwYzz2Lmsq/vM=;
 b=MNmDR6LjeUsEmew0Wgu4RMGdcP3a67dvAeYb3t+/boWi6E2nguLti110ZCe6hmqhAp
 WFYU9c+2WimTW4RRNJiQDX7UXlwzXXk9Ox1GSlRjaydYWLJHIkUsCJA4DcCdZn5SNWS/
 THwRA8qduVTQLbfKY8i7e0lO5jOqBYyNAhxmui6j3j3Tqq972XM0Hcx24DvRFgSVC6Vj
 3GoMrAJ3Ou16Wxf1hVIxob/akH9YmTbYFCyKtk/5BJ/WK8bYgc8wJp898qq71I3pXLzn
 3lblg+rpDU4+TNByilE5nE0Os1+C3y4pniRvZcg0a4d5YO2kspkG3Ci+jBKI5pXu6kRo
 Kadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1o9QvsSc9YvDxD2nqC58JtY0N0kXxGCwYzz2Lmsq/vM=;
 b=a96MK0sKPyb2nF8hjtqzRG7KkwopRs6oci376rMh2zrfMymESxU4OO37TJQAGXspi9
 xep/ShZWHHVrNXZPhKWm4l0UtaRo4zji0uJx9VTBLM3RdtjXsAmftArIpav0PN4FRT5a
 +c8/RfwjG/yaUgdYFTfkHqrVbcI+AWTVQOVHG5OI4UyA6ppw2wPaVuIC+aDxz4pN0W5O
 HIgbbaRgtI4QlMBjmZygo+NjFTGoQm6OVTFMaa2QjTwzy9bJuxdiEWIQYcHeBHb06nON
 D9SN0h8st1y4YIJ2Wk2Q4old2OwQkg5cumriYrwylwQhir1SgJa2cM9f9SouTZ+lN/vw
 tBlA==
X-Gm-Message-State: AOAM531jAujPtkhoXzJTsmU2nElV2gN32l2IVR/nnO+8GM6fRvdRDG/y
 wcl5Arxa0caQ8OeAcei8aM/oXQ==
X-Google-Smtp-Source: ABdhPJyz8XwenD+BQv29WOkJK8BBwVUoVg1aIa+1DN8PDqrLcq2aA8A7u2gdNelUEuD9J3o774/Ezw==
X-Received: by 2002:a05:6e02:1a29:b0:2cc:36d8:5d59 with SMTP id
 g9-20020a056e021a2900b002cc36d85d59mr4223708ile.137.1651478268460; 
 Mon, 02 May 2022 00:57:48 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 o65-20020a022244000000b0032b3a7817d5sm2882449jao.153.2022.05.02.00.57.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 May 2022 00:57:47 -0700 (PDT)
Date: Mon, 2 May 2022 07:57:44 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 03/18] KVM: arm64: Add SDEI virtualization
 infrastructure
Message-ID: <Ym+O+JLU5e9NUs39@google.com>
References: <YmMiyt/TDjJt0mdG@google.com>
 <36899ea9-e8bd-27b2-8dfb-75b76eab50d7@redhat.com>
 <YmRI7Bh7fWCYLUGT@google.com>
 <0e26da1a-00bb-3d63-a8bf-6cd3271b0a38@redhat.com>
 <Ymr45B+8xTlhi7vk@google.com>
 <96711526-c4f3-3b50-c015-beba8cc9fcc9@redhat.com>
 <Ym1EztjkJIHrg4Qz@google.com>
 <62f06a03-d6fc-3803-a2d2-7a85cf733459@redhat.com>
 <Ym9So9YariC0M7Zu@google.com>
 <2d631426-17fd-e7e3-5c62-eda547732bb7@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2d631426-17fd-e7e3-5c62-eda547732bb7@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, May 02, 2022 at 03:25:40PM +0800, Gavin Shan wrote:
> Oliver, how about to adjust struct kvm_sdei_vcpu like below. With the
> changes, struct kvm_sdei_vcpu::unregistering is dropped, to match with
> the specification strictly.
> 
>    struct kvm_sdei_vcpu {
>        unsigned long registered;
>        unsigned long enabled;
>        unsigned long running;        // renamed from 'active' to match the specification strictly
>        unsigned long pending;        // event pending for delivery
>           :
>    };
> 
>    state                          @registered  @enabled  @running  @pending
>    --------------------------------------------------------------------------------
>    unregistered                   0            0         0/1       0
>    registered-disabled            1            0         0         0/1
>    registered-enabled             1            1         0/1       0/1
>    handler-running                0/1          0/1       1         0/1
> 
> We can use the specific encoding to represent the unregistration-pending.
> 
>    state                          @registered  @enabled  @running  @pending
>    -------------------------------------------------------------------------
>    handler-running                0            0          1        0

Right, this is what I had in mind. This encodes the
'handler-unregister-pending' state.

> Thanks for your valuable comments, Oliver. I'm not starting to work on
> v7 yet. I also would like to make everything clear before that. In that
> case, it will be easier for you to review next revision :)
> 
> > > > >           unsigned long pending;       /* the event is pending for delivery and handling */
> > > > >           unsigned long active;        /* the event is currently being handled           */
> > > > > 
> > > > >           :
> > > > >           <this part is just like what you suggested>
> > > > >       };
> > > > > 
> > > > > I rename @pending to @unregister. Besides, there are two states added:
> > > > > 
> > > > >      @pending: Indicate there has one event has been injected. The next step
> > > > >                for the event is to deliver it for handling. For one particular
> > > > >                event, we allow one pending event in the maximum.
> > > > 
> > > > Right, if an event retriggers when it is pending we still dispatch a
> > > > single event to the guest. And since we're only doing normal priority
> > > > events, it is entirely implementation defined which gets dispatched
> > > > first.
> > > > 
> > > 
> > > Yep, we will simply rely on find_first_bit() for the priority. It means
> > > the software signaled event, whose number is zero, will have the highest
> > > priority.
> > > 
> > > > >      @active:  Indicate the event is currently being handled. The information
> > > > >                stored in 'struct kvm_sdei_event_context' instance can be
> > > > >                correlated with the event.
> > > > 
> > > > Does this need to be a bitmap though? We can't ever have more than one
> > > > SDEI event active at a time since this is private to a vCPU.
> > > > 
> > > 
> > > Yes, one event is active at most on one particular vCPU. So tt don't
> > > have to be a bitmap necessarily. The reason I proposed to use bitmap
> > > for this state is to having all (event) states represented by bitmaps.
> > > In this way, all states are managed in a unified fashion. The alternative
> > > way is to have "unsigned long active_event", which traces the active
> > > event number. It also consumes 8-bytes when live migration is concerned.
> > > So I prefer a bitmap :)
> > > 
> > 
> > The small benefit of using the event number is that we can address all
> > events in 8 bytes, whereas we'd need to extend the bitmap for >64
> > events. I suppose we'll run into that issue either way, since the
> > pending, registered, and enabled portions are also bitmaps.
> > 
> > When live migration is in scope we should probably bark at userspace if
> > it attempts to set more than a single bit in the register.
> > 
> 
> Even it's unlikely to support the shared event, bitmap will help in that
> case. I'm not sure about other VMM, the pseudo firmware registers are
> almost transparent to user space in QEMU. They're accessed and no one
> cares the values reading from and writing to these registers in QEMU ;-)

Regardless of whether userspace actually manipulates the registers we
should still reject unsupported values. For example:

Let's say the VM is started on a kernel that introduced yet another SDEI
widget outside of your series. The VM was migrated back to an older
kernel w/o the SDEI widget, and as such the VMM attempts to set the
widget bit. Since the old kernel doesn't know what to do with the value
it should return EINVAL to userspace.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
