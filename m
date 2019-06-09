Return-Path: <SRS0=IwiB=UI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C3CC28EBD
	for <kvmarm@archiver.kernel.org>; Sun,  9 Jun 2019 09:37:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32C9A208E4
	for <kvmarm@archiver.kernel.org>; Sun,  9 Jun 2019 09:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32C9A208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB8A4A4F8;
	Sun,  9 Jun 2019 05:37:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N74j2MVvAQt0; Sun,  9 Jun 2019 05:37:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BB84A512;
	Sun,  9 Jun 2019 05:37:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7F94A50C
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Jun 2019 05:37:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kviPCiitzQBF for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Jun 2019 05:37:22 -0400 (EDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47D364A4F9
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Jun 2019 05:37:22 -0400 (EDT)
Received: by mail-wm1-f52.google.com with SMTP id c66so5805896wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Jun 2019 02:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=N/JT6wxx8SnEUHFdFMXDjIDadpkBg6G764joNYPh7l8=;
 b=DnQToNskziR/Dien1HkZBccjZvYJyaqtfaTJw61GvHU96KYmblJ2EceyFeQvgk5t3Q
 MofCamnL19fc1e0ddEZW0UInPXjJu13I+/SebXkCUtrIPCktdaqmIiOZt67OvTMJ6Wo3
 vuDoG04/Hm2HtxsKePf0OhceTZioHcKwo1WXP43hR5gmO3Mi8nPMH3jSWhXlzzTKMhDP
 kp4Qy/HO5fuJ8cE3y0PyQLc7LMEUcjIfqLAKFuNDbJAFKncXk/CdkoMeAomLpHncCiER
 laD8zhuYteHHua5T43Snt2uwHYYKS7Hx/KZDLdjA4vVODu6hPCIe7yqVsf+g/X56pxID
 C9Kg==
X-Gm-Message-State: APjAAAXx3lZXKuzwaXBm1/3c59UUiOAUSXKRekF8Q8uGqoUApdb67msz
 fxlRLemfaqbAF13eKI8JOtAIj1EurCY=
X-Google-Smtp-Source: APXvYqyAtJD90KBreJ8YMy512INUJXccvzCGcpA/XJQQf/F7Ze/ETljJlq57FHnss/Ayp0CtUHfiww==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr9949310wmc.77.1560073041026; 
 Sun, 09 Jun 2019 02:37:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8cc3:8abd:4519:2cd6?
 ([2001:b07:6468:f312:8cc3:8abd:4519:2cd6])
 by smtp.gmail.com with ESMTPSA id b5sm7097123wru.69.2019.06.09.02.37.20
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Sun, 09 Jun 2019 02:37:20 -0700 (PDT)
Subject: Re: Reference count on pages held in secondary MMUs
To: Christoffer Dall <christoffer.dall@arm.com>, kvm@vger.kernel.org
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
Date: Sun, 9 Jun 2019 11:37:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190609081805.GC21798@e113682-lin.lund.arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu
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

On 09/06/19 10:18, Christoffer Dall wrote:
> In some sense, we are thus maintaining a 'hidden', or internal,
> reference to the page, which is not counted anywhere.
> 
> I am wondering if it would be equally valid to take a reference on the
> page, and remove that reference when unmapping via MMU notifiers, and if
> so, if there would be any advantages/drawbacks in doing so?

If I understand correctly, I think the MMU notifier would not fire if
you took an actual reference; the page would be pinned in memory and
could not be swapped out.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
