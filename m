Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45446C07E9D
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 21:23:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 771A9410F3;
	Fri, 23 Sep 2022 17:23:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SwlHfXIeh4Hs; Fri, 23 Sep 2022 17:23:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A35441049;
	Fri, 23 Sep 2022 17:23:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92EA840FF0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 17:23:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p2JHu0rI9hIM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2022 17:23:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 148A140F93
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 17:23:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663968217;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=dzXh0+CoJNH91B/Mg2iO2pFEjhzK8NyAmEI4nXxYRnc=;
 b=dtzxMu6CPSd8lK3JQhvGdrmn3yFVaDefbDPPUbfq6zE98cgm7i+9GRxPWvadOaI8vG3x8M
 UL0nR/4ajCJg7JpCoAhyPaqrDtBSUxj4VpHMsjXcYbHsfg5fP7ASj+40NbtWdFm17nB/GX
 AQvLVzLtAzPrU/ftETbW2so+MyaYxs8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-Zy-hihmHPtOvn93XtJSxOA-1; Fri, 23 Sep 2022 17:23:36 -0400
X-MC-Unique: Zy-hihmHPtOvn93XtJSxOA-1
Received: by mail-qv1-f70.google.com with SMTP id
 mo5-20020a056214330500b004ad711537a6so701041qvb.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 14:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=dzXh0+CoJNH91B/Mg2iO2pFEjhzK8NyAmEI4nXxYRnc=;
 b=awTjRvQpedvdfjhGl56iX7SUHDb7wAEqyWRNShqTfJO6D7n95EeX24jN9fsvvh53Ua
 nJgwNMCO7ZQzmXNEeAKlK7EEzhCrZO3RjSOsK1lBLW7UE8MMC+ChWfXrLwxLXptfplfs
 t1Gv3zbnV8vidtloD58L4LE8quvvFhqFBJSgL/DpRnkvrUMIWIU1jtij95trKwM3FDRS
 16aCPQZsoiZFqCWTxqiRX2Bb68Rvhz16BNlOnMgUW1YTZ/FPWM/Ws4flkV/kJJkaIGRo
 r9pYGA+r8AAwhsE8vkl7NXT/NaGGybOz9DZmm5CJ6RdFh/rbj6x761kOdAw/4PE5Wlik
 O+CQ==
X-Gm-Message-State: ACrzQf1uzaSrsPPSaQ1NHdT6xLPR11vSs5LrCSXRF8y6TP11/y8T3vA4
 p6vgA5YXsKJRuYgxG7AmmCZrNhmCLQ1OoRf16cjaFiXDPSrSqgwBjIEq8HgsusHbOFIvU+CbKR8
 vc3e5WW2cGyy9XG3m+aVEwM6NP4TDWkYrVuPqI3lk
X-Received: by 2002:a05:6214:20e2:b0:4ac:b9a6:17be with SMTP id
 2-20020a05621420e200b004acb9a617bemr8449763qvk.104.1663968216188; 
 Fri, 23 Sep 2022 14:23:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5lnCVE0oF1CeOwhWMt+zra+pW8iEWs2xYytQYPLLN6K6WHAULJ7rvF08Tq1RB6zdF4hB5Qv0ei81ym5VjyNj4=
X-Received: by 2002:a05:6214:20e2:b0:4ac:b9a6:17be with SMTP id
 2-20020a05621420e200b004acb9a617bemr8449743qvk.104.1663968215982; Fri, 23 Sep
 2022 14:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local> <87czbmjhbh.wl-maz@kernel.org>
 <Yy36Stppz4tYBPiP@x1n>
In-Reply-To: <Yy36Stppz4tYBPiP@x1n>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 23 Sep 2022 23:23:24 +0200
Message-ID: <CABgObfakosSMDYnT+W1zFJCRwPcM7VaY-FJzRs_9NivvhfjnyA@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
To: Peter Xu <peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm <kvm@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>,
 Will Deacon <will@kernel.org>, Shan Gavin <shan.gavin@gmail.com>,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Zhenyu Zhang <zhenyzha@redhat.com>, Shuah Khan <shuah@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>
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

Il ven 23 set 2022, 20:26 Peter Xu <peterx@redhat.com> ha scritto:
>
> > Someone will show up with an old userspace which probes for the sole
> > existing capability, and things start failing subtly. It is quite
> > likely that the userspace code is built for all architectures,
>
> I didn't quite follow here.  Since both kvm/qemu dirty ring was only
> supported on x86, I don't see the risk.

Say you run a new ARM kernel on old userspace, and the new kernel uses
KVM_CAP_DIRTY_LOG_RING. Userspace will try to use the dirty page ring
buffer even though it lacks the memory barriers that were just
introduced in QEMU.

The new capability means "the dirty page ring buffer is supported and,
by the way, you're supposed to do everything right with respect to
ordering of loads and stores; you can't get away without it like you
could on x86".

Paolo

>
> Assuming we've the old binary.
>
> If to run on old kernel, it'll work like before.
>
> If to run on new kernel, the kernel will behave stricter on memory barriers
> but should still be compatible with the old behavior (not vice versa, so
> I'll understand if we're loosing the ordering, but we're not..).
>
> Any further elaboration would be greatly helpful.
>
> Thanks,
>
> > and we
> > want to make sure that userspace actively buys into the new ordering
> > requirements. A simple way to do this is to expose a new capability,
> > making the new requirement obvious. Architectures with relaxed
> > ordering semantics will only implement the new one, while x86 will
> > implement both.
>
> --
> Peter Xu
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
