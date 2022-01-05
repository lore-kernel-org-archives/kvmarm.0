Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46558C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 16:25:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 922574B205;
	Wed,  5 Jan 2022 11:25:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AEb7-oYYJPxN; Wed,  5 Jan 2022 11:25:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89E784B1F4;
	Wed,  5 Jan 2022 11:25:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C5BA4B1F0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 11:25:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5wIj4bqHwybE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 11:25:28 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D3C4B1F2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 11:25:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641399927;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hknNMTwFhbYpQSmz5No5xN0sw1+0JrW2QZ6zSfztptA=;
 b=LotPmB9duB95Yd1X9hIOyzlhzBtugDh3bAVkWJqDKkuIUW/VZcVo1DhcHK9wCoI8cMdZDj
 Rlu8GrE7fA5d9Hdyw0uBO1Ryp5IeW42Sj5WV5rtZT9D74FgBT5idwFQrUoUPonNQPaxZpd
 Hxz7pmS47Dzmw65SUeGBR9Cj4lLuiQA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-Q31rndeqPZmoCw7KL3iG6A-1; Wed, 05 Jan 2022 11:25:24 -0500
X-MC-Unique: Q31rndeqPZmoCw7KL3iG6A-1
Received: by mail-qv1-f69.google.com with SMTP id
 iw6-20020a0562140f2600b004118fe44fa1so30496302qvb.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 08:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hknNMTwFhbYpQSmz5No5xN0sw1+0JrW2QZ6zSfztptA=;
 b=VsI5QVxtRxMxgEz8qu31V0jbnF3OdphStU3n9LLFXkORxlv+ersbRmmblvtv6LUo+d
 fldu7Fecm0t/t225yW3TkXMZqbvwmSJArST3qVR/4YI3t4LvkyOP/ae7lKanLkAiOB6E
 5YoSjfLuKyT45/ssx3wWBB0Qr/2snhESYKrpnFfq51GtYrzsj6xvUJo7pcPlulagCax+
 AkY37010vhLo0LXVfstk5Zs81z3weH61lczVqNyEB9R5o9004mLguIb2txNlC1+TXtR4
 NhVucqKzvgNGHNVrWNG1DvCWkP0ycT95IWhazsBpbiU3yVLmoM4YKqoLZKzVxH+QsGUg
 Fb8g==
X-Gm-Message-State: AOAM5303R+QlZPgoOwzJdftohjYp9iUU81Gf7vfuCmPCca7Agc+kuGGZ
 A7s0ng+7EmWCwz/2OsRtfH6DPrpk16Vn+cZgrlECqdP2RW/6VGsSCRf5WaISdp7XVdlKg5iwT/L
 XLM0Wu/sBgB2n7RX9qhpDrA22
X-Received: by 2002:a05:6214:4015:: with SMTP id
 kd21mr51294316qvb.41.1641399924300; 
 Wed, 05 Jan 2022 08:25:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlKHgt/quzEpSNY3x5FQOure6fAVMboTj7d0dDxEXUBGTvUItt4q2D6fkCkEzFQ7R/QFrV9w==
X-Received: by 2002:a05:6214:4015:: with SMTP id
 kd21mr51294296qvb.41.1641399924089; 
 Wed, 05 Jan 2022 08:25:24 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id f12sm34865877qtj.93.2022.01.05.08.25.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Jan 2022 08:25:23 -0800 (PST)
Date: Wed, 5 Jan 2022 17:25:19 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] hw/arm/virt: KVM: Enable PAuth when supported by the host
Message-ID: <20220105162519.5kjtkhphv3sdyaw4@gator>
References: <20211228182347.1025501-1-maz@kernel.org>
 <20220103134601.7cumwbza32wja3ei@gator>
 <878rvwzocq.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <878rvwzocq.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>,
 qemu-devel@nongnu.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jan 03, 2022 at 06:05:41PM +0000, Marc Zyngier wrote:
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > Thanks for considering a documentation update. In this case, though, I
> > think we should delete the "TCG VCPU Features" pauth paragraph, rather
> > than add a new "KVM VCPU Features" pauth paragraph. We don't need to
> > document each CPU feature. We just document complex ones, like sve*,
> > KVM specific ones (kvm-*), and TCG specific ones (now only pauth-impdef).
> 
> Sure, works for me. Do we need to keep a trace of the available
> options?

For arm we need to extend target/arm/helper.c:arm_cpu_list() to output
the possible flags like x86 does. On x86 doing this

  qemu-system-x86_64 -cpu help

not only gives us a list of cpu types, but also a list of flags we can
provide to the cpus (although not all flags will work on all cpus...)
On arm doing this

  qemu-system-aarch64 -cpu help

only gives us a list of cpu types.


> I'm not sure how a user is supposed to find out about those
> (I always end-up grepping through the code base, and something tells
> me I'm doing it wrong...). The QMP stuff flies way over my head.
>

Indeed, currently grepping is less awkward than probing with QMP.
With an extension to target/arm/helper.c:arm_cpu_list() we can
avoid grepping too. I've just added this to my TODO [again]. It
was there once already, but fell off the bottom...

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
