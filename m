Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00513C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 11:18:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D7A8207F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 11:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h1FOTvg2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D7A8207F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0C7D4B14D;
	Mon, 18 May 2020 07:18:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eDOx8lXTHJCx; Mon, 18 May 2020 07:18:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2024B18A;
	Mon, 18 May 2020 07:18:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3754B185
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 07:18:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X9iQMSwtc9Bv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 07:18:28 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF924B149
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 07:18:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1589800708;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dxiBECMHFAplzz2KB29O/LRSLdFzNsUzEToTKNWFHYs=;
 b=h1FOTvg2S+c1egPCZdGtvP6YOqoW1ZtlQq5YEJWsXWvupreE90whGjCNev/jstjCmCpOUt
 HqCmzEAJwneC4UNRwYwf7zypDxCVjJ2fYHziVNxiBFAtpiY2va4xjvsByJua6FJScGfeR+
 ZI2PeBPSnCYE2TJLItwWskkwnt0jAnM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-4-xdB0oPOGGfYa8iWEqCjQ-1; Mon, 18 May 2020 07:18:26 -0400
X-MC-Unique: 4-xdB0oPOGGfYa8iWEqCjQ-1
Received: by mail-wm1-f70.google.com with SMTP id v23so2959644wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 04:18:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=dxiBECMHFAplzz2KB29O/LRSLdFzNsUzEToTKNWFHYs=;
 b=Za5DzbH38vpWHxFbYQbU+2nFYIr/QAw99Ckw6oV6t3HWt3ZqZP7Urbt/H6UANUhG86
 IXw+qxoMJNzJmv6y7FgqAk3ubPtn5u4F2Kw9kwZk9JmjJloHhB4WoSJnw5ToOi4/YS+W
 Iofv74+x4DfnXNHI4Reh7Ig5apY4GYbc62IV97Xl8YW4tZbHFVI0WSCbANP89uMVkD6X
 UpnBP8hhvI9crOQ6HjnybeXHlFb/K1LBfbOQVshPI2616KBXZBa4TTt4s9BOlEGpzYxZ
 fZ0HWSxZ1usjqKVtgxF/pVVHB2Ctv6jmKnCIVCi1wgIEsMEeX0vSQVhln7Ry/qfxQW4f
 BblQ==
X-Gm-Message-State: AOAM531mFw1CBNjiayGqOH/lsvaSN8b0O6HANkZW+elGrkLUsuRMLp1G
 tIx09JneC1A477SHuKOt4nf4XAHqkc2E7NFN7vokYfSo+aScL8Qk4qFnqi0tPGpToW0p7+jaiig
 rdyYaB3AGppHQW6cugMgQFfUG
X-Received: by 2002:adf:f786:: with SMTP id q6mr19058398wrp.120.1589800705062; 
 Mon, 18 May 2020 04:18:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNLwMrbe3B5c0qaCQ/YjHTYYnwcj/Jnv2tH5S7lfJMD5adLyh8g16sr+0JKvnyuDSUcvQdGA==
X-Received: by 2002:adf:f786:: with SMTP id q6mr19058368wrp.120.1589800704864; 
 Mon, 18 May 2020 04:18:24 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
 by smtp.gmail.com with ESMTPSA id r2sm16417514wrg.84.2020.05.18.04.18.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 18 May 2020 04:18:24 -0700 (PDT)
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
To: Anastassios Nanos <ananos@nubificus.co.uk>, Marc Zyngier <maz@kernel.org>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
 <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
 <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <760e0927-d3a7-a8c6-b769-55f43a65e095@redhat.com>
Date: Mon, 18 May 2020 13:18:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On 18/05/20 10:45, Anastassios Nanos wrote:
> Being in the kernel saves us from doing unneccessary mode switches.
> Of course there are optimizations for handling I/O on QEMU/KVM VMs
> (virtio/vhost), but essentially what happens is removing mode-switches (and
> exits) for I/O operations -- is there a good reason not to address that
> directly? a guest running in the kernel exits because of an I/O request,
> which gets processed and forwarded directly to the relevant subsystem *in*
> the kernel (net/block etc.).

In high-performance configurations, most of the time virtio devices are
processed in another thread that polls on the virtio rings.  In this
setup, the rings are configured to not cause a vmexit at all; this has
much smaller latency than even a lightweight (kernel-only) vmexit,
basically corresponding to writing an L1 cache line back to L2.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
