Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388F8C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 18:23:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B17561B65
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 18:23:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B17561B65
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AE8140CC5;
	Mon, 20 Sep 2021 14:23:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RUn0MpAaAX6m; Mon, 20 Sep 2021 14:23:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03A4A49DE7;
	Mon, 20 Sep 2021 14:23:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F956405EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 14:23:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ukWuHDKMCCvS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 14:22:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC4B940573
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 14:22:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632162178;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vRI2avQuBNPO4mZTVFj4yY0DXqukEShEdAk6taZEnJk=;
 b=QKfpsv+CskZC0k7tcN6emdKmlWaqNvhAps6iyIIecmKzfcpg87kOInNT/MuJW4iMnp1mog
 ZV1e3RDIP7Ms7bL772mu9T98YBXqg9K3esf0A6qLf5p0LrV26qEPN28MQAOw3xQHVLdvMi
 0nluoyfz6ZDgyNETtaeHurCC1JLp+1U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-hY1GBFVaPXKXToFlNtdkbg-1; Mon, 20 Sep 2021 14:22:55 -0400
X-MC-Unique: hY1GBFVaPXKXToFlNtdkbg-1
Received: by mail-ed1-f70.google.com with SMTP id
 m20-20020aa7c2d4000000b003d1add00b8aso16492445edp.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 11:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=vRI2avQuBNPO4mZTVFj4yY0DXqukEShEdAk6taZEnJk=;
 b=JYaDOBLX4dzasgjtCN2nQwaWvnQNpftLEkvxlIR2dLItXI+PL9sUqCNbp7UeKS3CAU
 JAvhqe3FcSuRKVlxigTmxGJq/18NXiU8qoztNAYlzcexZrVfjIzO2vD7+zNhyjCL8W6+
 6VYQttbdnU5//gRUqmz4gPEVM3eWEoXR8wAftXdQo6zIyjgGf9Z8El8ubFfvIqlEdUhZ
 7qH11rcDRSyz3CPwaLp4/1a96LMjJ/0oMr4UyP/ICfCpHLMQOnGhiK/kfyNnUya6Kl5X
 DHkHi1q+cvkczHitDSZsjwI/xsbO0HmVK+SASF2SF9RpomCD02vng2RlGIxAa3uUDajH
 Tmzg==
X-Gm-Message-State: AOAM530fixsF5ShthTe0NoWuEFrrkwYRSdHksrl/uJBweqJXQREEQdca
 0kpXiNbmrmd07utITozueC5XRajaxJl/wi4rNwuLMUGh/bbOiysKdzFgBg4ean71h3YF8HHqQi9
 BbBe0NZFZ66x/KHdackflbsVo
X-Received: by 2002:a17:907:76b2:: with SMTP id
 jw18mr31101769ejc.120.1632162173781; 
 Mon, 20 Sep 2021 11:22:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSoRFsPRM/7K22YQ1jPmATj4IuvLfgFOqCYFtPnEIPU80lrUpqlQ2FpuvfaQh3tH7XvhJmFg==
X-Received: by 2002:a17:907:76b2:: with SMTP id
 jw18mr31101728ejc.120.1632162173428; 
 Mon, 20 Sep 2021 11:22:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id w25sm7281095edi.22.2021.09.20.11.22.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 20 Sep 2021 11:22:52 -0700 (PDT)
To: Marc Zyngier <maz@kernel.org>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828201336.GD4353@worktop.programming.kicks-ass.net>
 <YUO5J/jTMa2KGbsq@google.com>
 <YURDqVZ1UXKCiKPV@hirez.programming.kicks-ass.net>
 <662e93f9-e858-689d-d203-742731ecad2c@redhat.com>
 <87tuifv3mb.wl-maz@kernel.org>
 <7a5825d1-d6e9-8ac8-5df2-cce693525da7@redhat.com>
 <87o88nuzzc.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <0eb2d4b1-23a4-c318-9f91-8dce78c6c8ad@redhat.com>
Date: Mon, 20 Sep 2021 20:22:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87o88nuzzc.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Like Xu <like.xu.linux@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Greentime Hu <green.hu@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 20/09/21 15:40, Marc Zyngier wrote:
>>> At least not before we
>>> declare the arm64 single kernel image policy to be obsolete.
>>
>> --verbose please.:)   I am sure you're right, but I don't understand
>> the link between the two.
>
> To start making KVM/arm64 modular, you'd have to build it such as
> there is no support for the nVHE hypervisor anymore. Which would mean
> two different configs (one that can only work with VHE, and one for
> the rest) and contradicts the current single kernel image policy.

Ah okay, I interpreted the policy as "it's possible to build a single 
kernel image but it would be possible to build an image for a subset of 
the features as well".

In that case you could have one config that can work either with or 
without VHE (and supports y/n) and one config that can only work with 
VHE (and supports y/m/n).  The code to enter VHE EL2 would of course 
always be builtin.

> It is bad enough that we have to support 3 sets of page sizes.
> Doubling the validation space for the sake of being able to unload KVM
> seems a dubious prospect.

It's not even a configuration that matches kconfig very well, since it 
does have a way to build something *only as a module*, but not a way to 
build something only as built-in.

That said, if you had the possibility to unload/reload KVM, you'll 
quickly become unable to live without it. :)

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
