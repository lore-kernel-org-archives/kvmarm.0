Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE43C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 14:17:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87F3E61159
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 14:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 87F3E61159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F584B0E6;
	Fri,  1 Oct 2021 10:17:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dV-pMXKNNCpl; Fri,  1 Oct 2021 10:17:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA644B099;
	Fri,  1 Oct 2021 10:17:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D50B4ACC9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 10:17:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9NygyIYRHgGa for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 10:17:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D22E4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 10:17:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633097838;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QXYa/6pNkGh7DhVVHoCv6tDp16H1ut5Qth6GnXzzM4k=;
 b=g8OWk5r965i+mPxZAdnBSX5JsxmfjHo/Ynm4Lc8V4guc920a6ZVkdQvguBsMdTkKiX7tf+
 zrUwHMcDnY53tHHX577dHcUGhR4Qdf0gKgFbHpZ9jjeeE0ninJaaboo+ibJBGZHcUN8Nbc
 vSYhX0nsAncTm00Mj5jf+e17GL8lc4A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-fM4nZqAHMue9cOh2IWK0yg-1; Fri, 01 Oct 2021 10:17:06 -0400
X-MC-Unique: fM4nZqAHMue9cOh2IWK0yg-1
Received: by mail-ed1-f72.google.com with SMTP id
 u17-20020a50d511000000b003daa3828c13so10503618edi.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 07:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=QXYa/6pNkGh7DhVVHoCv6tDp16H1ut5Qth6GnXzzM4k=;
 b=W3oCc8cCmz7IEsxpGC6GmnUm/VCW77IMoFjlRLcx/F3Vdl22Dw29HS5uMLwgcZleFe
 OTgFbWh2VQQNj3nyyHZd88EYHY2PdbontNMBvOMTJlZ/wIsM4Hv4OQy2r61fsS38J6Xl
 fskD4064tTWBUrQhfE4kN3UYaj65yx55qzdUDXLQQ9aiFOuYOq9n9nM09l261r4FeXwV
 PKUR7fMWsBBTXUAkOIjhUcYDP6G3nYpgW1u6QfYsLw5YlqMacDbCzU56UsWdvqr5x+pm
 bpVF45N4LGAefmpXEkbC6rH+QDpf3tmly22v/xx94aRtbb5Jg08rda+JYtGb98HQ3S6j
 wSdQ==
X-Gm-Message-State: AOAM532yMYsKVM77E6ZzYExXZiJg01LI6Vw0RTZgB4TypRhbR7Y+FsG/
 XT+cgSW/QpbXB8LSIIaNTN2/PJPwX26AaXrv/GMZgSc+QN50Wsxe7h7nlLrkJLnPBjG/BsmGWK0
 /L08C+m586HgwB5QCVVs2DOtw
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr14606957eds.166.1633097824765; 
 Fri, 01 Oct 2021 07:17:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCiMsXBYCQ8UWIYXEv0CCzQitsksl4VwheKReCDgqX9Kwx4ytTAjcLaQ0AagoSgyQ5wyZQng==
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr14606924eds.166.1633097824509; 
 Fri, 01 Oct 2021 07:17:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id f25sm1228903ejb.34.2021.10.01.07.17.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 01 Oct 2021 07:17:03 -0700 (PDT)
Message-ID: <b39b08ff-b4cf-0409-5b70-3484441517fc@redhat.com>
Date: Fri, 1 Oct 2021 16:17:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
To: Thomas Gleixner <tglx@linutronix.de>,
 Marcelo Tosatti <mtosatti@redhat.com>, Oliver Upton <oupton@google.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <20210929185629.GA10933@fuller.cnet> <20210930192107.GB19068@fuller.cnet>
 <871r557jls.ffs@tglx>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <871r557jls.ffs@tglx>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 01/10/21 01:02, Thomas Gleixner wrote:
> 
>   Now the proposed change is creating exactly the same problem:
> 
>   +	if (data.flags & KVM_CLOCK_REALTIME) {
>   +		u64 now_real_ns = ktime_get_real_ns();
>   +
>   +		/*
>   +		 * Avoid stepping the kvmclock backwards.
>   +		 */
>   +		if (now_real_ns > data.realtime)
>   +			data.clock += now_real_ns - data.realtime;
>   +	}

Indeed, though it's opt-in (you can always not pass KVM_CLOCK_REALTIME 
and then the kernel will not muck with the value you gave it).

> virt came along and created a hard to solve circular dependency
> problem:
> 
>    - If CLOCK_MONOTONIC stops for too long then NTP/PTP gets out of
>      sync, but everything else is happy.
>      
>    - If CLOCK_MONOTONIC jumps too far forward, then all hell breaks
>      lose, but NTP/PTP is happy.

Yes, I agree that this sums it up.

For example QEMU (meaning: Marcelo :)) has gone for the former and 
"hoping" that NTP/PTP sorts it out sooner or later.  The clock in 
nanoseconds is sent out to the destination and restored.

Google's userspace instead went for the latter.  The reason is that 
they've always started running on the destination before finishing the 
memory copy[1], therefore it's much easier to bound the CLOCK_MONOTONIC 
jump.

I do like very much the cooperative S2IDLE or even S3 way to handle the 
brownout during live migration.  However if your stopping time is 
bounded, these patches are nice because, on current processors that have 
TSC scaling, they make it possible to keep the illusion of the TSC 
running.  Of course that's a big "if"; however, you can always bound the 
stopping time by aborting the restart on the destination machine once 
you get close enough to the limit.

Paolo

[1] see https://dl.acm.org/doi/pdf/10.1145/3296975.3186415, figure 3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
