Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B2EC07E9D
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 22:34:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BF70413E2;
	Fri, 23 Sep 2022 18:34:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nLzKepmyHIIp; Fri, 23 Sep 2022 18:34:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BFA410F1;
	Fri, 23 Sep 2022 18:34:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC60440E25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 18:34:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ze2BUxqtdIdZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2022 18:34:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D356040BD9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 18:34:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663972456;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QjPylOtZhZgJWUTi5JLfx6pIoX24SMuAcw+6N7ICti0=;
 b=TDGVEtC5rCiOhaCKLyMhV8IZJc584Cup8BTmXuYLeoslMbwH3PAe6qaMDz90TxPUV6p10O
 gkBn+tJrp5HCV2cjKFdJwA52ZAkKMCEoue2yNtYW/IjA0HLqyj8R8P7aNsJ5HL61yAzaq1
 LqGFue3s1JLdeOgwpGzVNeP9lAIKLJM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-531-mFrTTNloMKizpLqb2zX3kg-1; Fri, 23 Sep 2022 18:34:15 -0400
X-MC-Unique: mFrTTNloMKizpLqb2zX3kg-1
Received: by mail-qk1-f197.google.com with SMTP id
 v15-20020a05620a0f0f00b006ceab647023so1006245qkl.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 15:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=QjPylOtZhZgJWUTi5JLfx6pIoX24SMuAcw+6N7ICti0=;
 b=R9D95KOhuAy7TxztPaItUF++81M1slTeuOPWJh4yfIPQITbgax5La3Di6gaTsZDh4e
 30jyo2QpfglDeMks0JVjgXkpmT3by6Hr2AWOjWVK3QfwHhpexHhfT/AktDq5MPHMUDm6
 OES2FnZnj7JRgaGoan8TKl40RseFb1GcyU6LHSIBAw6qRqK1YJNxeZJCmefES6Z57FZU
 cc87O4lbt1yBy3syN7SYVQ7KeKba7EZIA9bCJNWTYoq65HTT9h6XX+M9kiUfAJ2YT0tE
 +FgI80m1EKeiRvkzJO5gjlxGxAukTOF/5UZDDMcc7gF2h1XvLBagP6bu2PvecwI4kR6f
 PxEg==
X-Gm-Message-State: ACrzQf3/H857fLI1rpNk+7j3aE7VyvWYeTEaNL9mFmLpbGFdRhP0tL7z
 P3+qdDNMfulg7L0FtIjaYbFK1Twlr75Uo09UX3gY0VpOdsZA9Lgk5JKf5ynyWWQSq2OxU+Ivu8P
 FYlUD1j3kD1gJqZQ/XnZOT3/Q
X-Received: by 2002:a05:6214:d05:b0:4ac:daac:f1c4 with SMTP id
 5-20020a0562140d0500b004acdaacf1c4mr8791539qvh.84.1663972454993; 
 Fri, 23 Sep 2022 15:34:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7FZ8svHWLCr/HF5fZzqZANH67wTnrKlJonLnDKcL/yasAB8/oLErHjl3FwG3KhZjNbvOKFsw==
X-Received: by 2002:a05:6214:d05:b0:4ac:daac:f1c4 with SMTP id
 5-20020a0562140d0500b004acdaacf1c4mr8791515qvh.84.1663972454749; 
 Fri, 23 Sep 2022 15:34:14 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 u5-20020a37ab05000000b006b8e8c657ccsm6521149qke.117.2022.09.23.15.34.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Sep 2022 15:34:14 -0700 (PDT)
Date: Fri, 23 Sep 2022 18:34:12 -0400
From: Peter Xu <peterx@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <Yy40ZPS4Lp0S6pkf@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local> <87czbmjhbh.wl-maz@kernel.org>
 <Yy36Stppz4tYBPiP@x1n>
 <CABgObfakosSMDYnT+W1zFJCRwPcM7VaY-FJzRs_9NivvhfjnyA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABgObfakosSMDYnT+W1zFJCRwPcM7VaY-FJzRs_9NivvhfjnyA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Fri, Sep 23, 2022 at 11:23:24PM +0200, Paolo Bonzini wrote:
> Il ven 23 set 2022, 20:26 Peter Xu <peterx@redhat.com> ha scritto:
> >
> > > Someone will show up with an old userspace which probes for the sole
> > > existing capability, and things start failing subtly. It is quite
> > > likely that the userspace code is built for all architectures,
> >
> > I didn't quite follow here.  Since both kvm/qemu dirty ring was only
> > supported on x86, I don't see the risk.
> 
> Say you run a new ARM kernel on old userspace, and the new kernel uses
> KVM_CAP_DIRTY_LOG_RING. Userspace will try to use the dirty page ring
> buffer even though it lacks the memory barriers that were just
> introduced in QEMU.
> 
> The new capability means "the dirty page ring buffer is supported and,
> by the way, you're supposed to do everything right with respect to
> ordering of loads and stores; you can't get away without it like you
> could on x86".

I understand now, thanks both.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
