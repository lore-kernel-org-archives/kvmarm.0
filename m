Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD50C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 07:38:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DA849EF3;
	Mon,  2 May 2022 03:38:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jYmgibzUZcQz; Mon,  2 May 2022 03:38:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983544B0D0;
	Mon,  2 May 2022 03:38:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3FA49F05
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:38:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYPJ77t4UeR2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 03:38:34 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D298C49EF3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:38:34 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id f2so15018825ioh.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 00:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GPkNxE2r6P0xG3q/R7zfqzTrygEF3DAcqbdmgZiq2s0=;
 b=sCjuqeXJ9DCpoV1lQZ3M1xkzDHYEbWrrb+jsdTHqJB+kPx7YW+DS0fPHMMusOaTbBf
 UwISChxKC4zWaO+uzfsdTxi9lOWf9OIgLc1PMUTvLrQ9T36aA1+Ey6n3dPew/979MJhs
 KQflJzjLOIEmkUKeRMdbBeUcWVKeqG0DaybXe6oNqhLxvwSMmvEAVs+rcQw9n0OkOqqN
 yUQ7o+/qUit8hGWFJfsmlowJWJIPyt/XqRZFjwidmDTYkt1lw/32UNLfB+gFPBvhn0jT
 yTM/T2R4627TLJ4HSM+J4G63hU/xfkd45M62WWnyGObjL/s5dqrufqvVn/CDY4GGUjSx
 wh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GPkNxE2r6P0xG3q/R7zfqzTrygEF3DAcqbdmgZiq2s0=;
 b=ilFPSqYfw3lBRmDTovLEHKiPdCyHmv2BzPciMXXvERjD4K8RbeTQDaAPx7aE3sBS2I
 Eh4mT4bYW7qjhTT9AbUAx1ieQ0g13BpSaVaSpPeEuLZgAUhwBQ+hW/ViKaShfZSH1Loi
 F6gQCCpSG/ar8/vPftYb1CYW97WS0bdwwBHdBqYQw1GBnX9UhBNOjpQuHm+ArdctmKJ0
 uCsLzRXTOXP19LNORR0iMBX8C+NpfmjJHACFVLs6uerai1CoTLfVcHOLqEa48wkGTuqR
 5u9ztucrF5yPoxgLGMZaoRinrosrxlSTmgH32x2G928ZlgXJQSHfcMkqB0ggmZ2NW48+
 F2Qg==
X-Gm-Message-State: AOAM530FkTUwQF02mTKUvNxH3NdLzwUpEfx0pWlIOdExW1jn1j3484uD
 4pjjnaHepnGsRMyQUASz+4gyYg==
X-Google-Smtp-Source: ABdhPJyjhIe2znQiZB9jWAMBJcQm0B6Fv4anyhMrjJ5mNDxihDCEre28mU7PNuGJ+PLTTB3+fTcdGg==
X-Received: by 2002:a05:6638:2494:b0:32b:4c44:aaf1 with SMTP id
 x20-20020a056638249400b0032b4c44aaf1mr4447202jat.224.1651477113989; 
 Mon, 02 May 2022 00:38:33 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 a10-20020a92330a000000b002cde6e352c8sm2507300ilf.18.2022.05.02.00.38.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 May 2022 00:38:33 -0700 (PDT)
Date: Mon, 2 May 2022 07:38:29 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 13/18] KVM: arm64: Support
 SDEI_EVENT_{COMPLETE,COMPLETE_AND_RESUME} hypercall
Message-ID: <Ym+KdY2y2vzMeDOL@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-14-gshan@redhat.com>
 <Ym4tzRL0iMxyumJe@google.com>
 <ba094956-2e58-4913-527a-af79475ee949@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ba094956-2e58-4913-527a-af79475ee949@redhat.com>
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

On Mon, May 02, 2022 at 02:19:30PM +0800, Gavin Shan wrote:
> Hi Oliver,
> 
> On 5/1/22 2:50 PM, Oliver Upton wrote:
> > On Sun, Apr 03, 2022 at 11:39:06PM +0800, Gavin Shan wrote:
> > > This supports SDEI_EVENT_{COMPLETE, COMPLETE_AND_RESUME} hypercall.
> > > They are used by guest to notify the completion of event in its
> > > handler. The previously interrupted or preempted context is restored
> > > like below.
> > > 
> > >     * x0 - x17, PC and PState are restored to what values we had in
> > >       the interrupted or preempted context.
> > > 
> > >     * If it's SDEI_EVENT_COMPLETE_AND_RESUME hypercall, IRQ exception
> > >       is injected.
> > 
> > I don't think that's how COMPLETE_AND_RESUME works. The caller specifies an
> > address at which it would like to begin execution within the client
> > exception level.
> > 
> > SDEI spec suggests this behaves like a synchronous exception. DEN 0054C
> > 5.2.2 'Event Resume Context' speaks more about how it is supposed to
> > work.
> > 
> 
> It's actually the linux convention. If the event handler, which was
> specified in previous hypercall to EVENT_REGISTER, returns success,
> the (linux) client calls into COMPLETE_AND_RESUME and the resume
> address is specified with FIQ vector offset. More details can be
> found from arch/arm64/kernel::sdei.c::do_sdei_event().

Right -- but look at what its doing. It returns the address at which it
wants to resume execution.

arch/arm64/kernel.entry.S::__sdei_asm_handler winds up passing this as
an argument to COMPLETE_AND_RESUME. Also, what would happen if we run
something that isn't Linux inside of KVM? This is why I suggested
implementing COMPLETE_AND_RESUME in line with the specification, not
based on what the kernel is presently doing.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
