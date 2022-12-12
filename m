Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA80C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 10:36:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B701B4B9C7;
	Mon, 12 Dec 2022 05:36:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UYZxqITMlsyD; Mon, 12 Dec 2022 05:36:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E0D4B999;
	Mon, 12 Dec 2022 05:36:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25ACE4B918
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 05:36:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ApvygC0Scb3Q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 05:36:23 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5C84B911
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 05:36:23 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670841382;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mQe1vPVAoLefYVtJgOMADA9UsAQ3Kxq8XGAB/nV1Q60=;
 b=KlAay9MJGpxeE6NzBHN8eaGv9IigyHXkeGe5B2F4fmy9KJnp/x83LWn7mTcQEhdeCkao9I
 aiHhPS1JQHswfErvLzQib0xsqbPx5TMvGOQqJX/ffj0TqK5XxqqGwZiciso3zmqWe/2XvM
 HHUaIHqKfCZ0aCBckp4/zooIi3CVxbc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-467-Sxp3yWZ7OHu3V5ufYYNMbA-1; Mon, 12 Dec 2022 05:36:21 -0500
X-MC-Unique: Sxp3yWZ7OHu3V5ufYYNMbA-1
Received: by mail-wm1-f70.google.com with SMTP id
 125-20020a1c0283000000b003d1d8d7f266so3156668wmc.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 02:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=mQe1vPVAoLefYVtJgOMADA9UsAQ3Kxq8XGAB/nV1Q60=;
 b=Sn1OfQGvPh4ylUoheDoKi7OlSgJTWLGx3BENwUG19A7iy2N3otTFpgY7ZieliJcd23
 39gsOpcUpHgrAGxl50NUPq5I9TbsATjdQjp6cSGArAdLzvEpZyO6YKJx+izdxeHwJwA2
 Vd9fACu5d+88MDYTk2sT4CNRPOJWzDBhoQUG43TqzzGHFEUzeXFBpY8Cna3p1QgFt9K2
 6ruQzIDaWzQgFTKqn/9H8S6wA4m9SKiocUJ4Sf1YyX9RdPAKJT+oxpn51Kgm3n5BzhaA
 dVAhmWlsjLhRfntBR/rKRPBpt6mpKPUgDemq3XOviQkfzIreTE9VQkNcUND43hQXtaeW
 k9LQ==
X-Gm-Message-State: ANoB5pndAMCyvASOl1YwU/r7F1hF1jlILhYzHqMwxyJr2kOIIg4xQxEj
 pGy9NjIRtG1LsLaGHTHCbx6WZ7hpOu8AYaTzjKa9gLMPnQcsmF5VI+VsnIXfjl8WHSVnszwkNpu
 Z4bJEcoCjs7ZZvH30AxMROT0s
X-Received: by 2002:a5d:564a:0:b0:24c:f1ca:b2df with SMTP id
 j10-20020a5d564a000000b0024cf1cab2dfmr5988137wrw.67.1670841380634; 
 Mon, 12 Dec 2022 02:36:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5yfwj5UnZ7QW7iYJjXIjnpYQh7U361r5HLW6PWTGWDdexdLTapuWofhSkU9q9aAnLfd+7YDA==
X-Received: by 2002:a5d:564a:0:b0:24c:f1ca:b2df with SMTP id
 j10-20020a5d564a000000b0024cf1cab2dfmr5988117wrw.67.1670841380414; 
 Mon, 12 Dec 2022 02:36:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 bp8-20020a5d5a88000000b00241e8d00b79sm10772956wrb.54.2022.12.12.02.36.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 02:36:19 -0800 (PST)
Message-ID: <42dbdb4d-13da-cd6b-e2ad-95b0cb0ff04e@redhat.com>
Date: Mon, 12 Dec 2022 11:36:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 12/9/22 02:52, Oliver Upton wrote:
> The combination of the pool-based ucall implementation + page_fault_test
> resulted in some 'fun' bugs. As has always been the case, KVM selftests
> is a house of cards.
> 
> Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
> be squashed into Paolo's merge resolution, if desired.
> 
> Tested on Ampere Altra and a Skylake box, since there was a decent
> amount of munging in architecture-generic code.
> 
> v1 -> v2:
>   - Collect R-b from Sean (thanks!)
>   - Use a common routine for split and contiguous VA spaces, with
>     commentary on why arm64 is different since we all get to look at it
>     now. (Sean)
>   - Don't identity map the ucall MMIO hole
>   - Fix an off-by-one issue in the accounting of virtual memory,
>     discovered in fighting with #2
>   - Fix an infinite loop in ucall_alloc(), discovered fighting with the
>     ucall_init() v. kvm_vm_elf_load() ordering issue

Queued 3+5, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
