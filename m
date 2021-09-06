Return-Path: <SRS0=b97j=N4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6E9C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 10:30:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F087F61051
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 10:30:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F087F61051
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7061E4B2E0;
	Mon,  6 Sep 2021 06:30:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8rn3Sun1VNYn; Mon,  6 Sep 2021 06:30:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70F484B284;
	Mon,  6 Sep 2021 06:30:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3494C4B268
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 06:30:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LLIqG4x4+EC8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 06:30:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D6D84B256
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 06:30:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630924241;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DsJzjdFaAaFnFOTOkzUAnviexzjsd3SYfhlH0e4oIgM=;
 b=TH74SiGU/ymqUn3OO+IH3S1vtKhq73RPg56Lj1QnncoOcBeQ8bz/QcvjUrulLCHUg4+rQ2
 vv5u+O8y3sECWL+JXgWGi07v4vGrzjtmXWmd5czMSB5ZivWaELBc+HxAmEXUgU5bTkeCXL
 EQkXR3NLZdc3QhAQh1W3wRaJ6rD6oAc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521--SlFUIRJNLaWFd3yrI33JA-1; Mon, 06 Sep 2021 06:30:40 -0400
X-MC-Unique: -SlFUIRJNLaWFd3yrI33JA-1
Received: by mail-ed1-f70.google.com with SMTP id
 y19-20020a056402441300b003cd8ce2b987so3483612eda.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Sep 2021 03:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=DsJzjdFaAaFnFOTOkzUAnviexzjsd3SYfhlH0e4oIgM=;
 b=Js1bRqInwE7l7S9EP33KrUqT9RQCjZ7aUxjKJu7rffyu52ke1OeG6f6LTmA4JVFFC/
 N5RTrBpo4rostdbRPRmWIEkGlr32qPGzZaaVssuHJO93wvheFR4NOHnN5TlAQlsX/DU8
 RJK+jMzx7XxVRTwIhmOxwwiR/I6h6IkwXsglAcYmcvt6+mSEOomv3bIHzN4Ir+KZFQvk
 v7/MF3XEBFAT62kfINvLCcZWdsJX0n13b70uxMgGfHd+hmljhhdaV/9ZuImABBCCHUmh
 uEico8OrYVOR2MpiTRHHLNjKQtZP96HIyRUPxX1V2ob41lgZ7ijT0HayJ7TB3Dog176D
 kccg==
X-Gm-Message-State: AOAM531aTgRALVKNLXfcpy2d2hyitlE4j9mhpibnDSczDEkmQP+TMkx8
 ThfSrOh/9vU7f53GH0rBek4ZdxmVxnOWFP/WlEpaHTnMHYuzJNC5l3ATjU8GOq5QeplGT3yAgVA
 r4pT9Du6rDQCYpeH1cWzC+xvP
X-Received: by 2002:a17:906:840f:: with SMTP id
 n15mr12968720ejx.460.1630924238813; 
 Mon, 06 Sep 2021 03:30:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMCUYgL2nI/1IEAUywDA6nmrVd/9sY5LrgsiYBRKNUDcBu6hkVNrMNtcvgdOVBU63XaIaC/A==
X-Received: by 2002:a17:906:840f:: with SMTP id
 n15mr12968698ejx.460.1630924238631; 
 Mon, 06 Sep 2021 03:30:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id bt24sm3713982ejb.77.2021.09.06.03.30.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 06 Sep 2021 03:30:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: stats: Add VM stat for remote tlb flush requests
To: Marc Zyngier <maz@kernel.org>, Jing Zhang <jingzhangos@google.com>
References: <20210817002639.3856694-1-jingzhangos@google.com>
 <87v943rx32.wl-maz@kernel.org>
 <CAAdAUtjFdEX73fTDu-+gGfPR=KqvvSzVRZ=vVGJe=8=iAJOv1A@mail.gmail.com>
 <87eeaqsnk1.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <05e2a8e3-c9ae-cd0d-7e72-d32e93c58ace@redhat.com>
Date: Mon, 6 Sep 2021 12:30:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87eeaqsnk1.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: David Matlack <dmatlack@google.com>, Peter Shier <pshier@google.com>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, KVM <kvm@vger.kernel.org>
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

On 18/08/21 18:52, Marc Zyngier wrote:
> Yes, this is what I meant, as I only quoted the bit that was redundant.
> 
>> These two counters would have the same value for arm64, but not for
>> others (at least x86).
> Sure. It is just that this patch does two things at once, but doesn't
> advertise it.

All in all, Jing's new stat is more appropriate than the one I used. 
I'll fix the conflict when pulling from you.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
