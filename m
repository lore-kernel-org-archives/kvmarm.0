Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF48C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 06:36:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACE93610D1
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 06:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ACE93610D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 259404B0C2;
	Thu, 23 Sep 2021 02:36:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1pWXqRvf9UAI; Thu, 23 Sep 2021 02:36:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA944B120;
	Thu, 23 Sep 2021 02:36:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBFFD4B101
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 02:36:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kTcdFxc3QkbX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 02:36:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9FD74B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 02:36:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632378985;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BpRl3ktTmfUHJQChKKvJO7RT2jCwywVDHGvSYX38WaU=;
 b=fuIByrMeOJIkCqI5nnkJmNwax9Jg0pKDK/a7WKYEvmFKGZdvlbohuafHN6v0OosJJISq/U
 phy6hcaVY6IMDKWTEUOlLx/zxblJb6vyJdiqVZvUP0K/8nEPqaNXefBDp9y7jmcXbrjoYL
 49OdC2cYqHNgE1hi3wqLDw6BXMH8U3I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-PtLFfck-PuGwJihHtShT3Q-1; Thu, 23 Sep 2021 02:36:24 -0400
X-MC-Unique: PtLFfck-PuGwJihHtShT3Q-1
Received: by mail-ed1-f72.google.com with SMTP id
 l29-20020a50d6dd000000b003d80214566cso5718635edj.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 23:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=BpRl3ktTmfUHJQChKKvJO7RT2jCwywVDHGvSYX38WaU=;
 b=jxMZlnsKV46PYqBIKkQFbdiqjhRhwVD97Hh/BdrtdaYhKUekUUlM3IWV2bWgoKyb+q
 PYT6BLQwAwEZ+aahezqHXsADnLPZsAmVLEwd9tCvfamc/43tKIARvaxVcgAQoAoJKEH5
 wst6OzbdIb9K1uGbBwcFDkcbHWqLBT0SHGc3viBz0jSv21RAtW/p+fa3rlfMbVJtIhI1
 uUOuiJ7eNDzxDacgVD/+nqHSts69gCLBcUBNYuL3JVYXvkDAwljZvRiGNNtZCE1bu9wZ
 kEXd++UDlo27jMkSCxJVjCmPZlE9rI1JMY9h1Yk7Fr5SWrfw7oFP5KY0TV5p1dnkCTHE
 RuJQ==
X-Gm-Message-State: AOAM531fNXU8QxCZQLRvYxl4/NBxqYGkWtiK6CvCHdPZvz0R36FP4I3L
 42OXRhCh2J4pni6alOJrYx7I+WOpCmhfXHja/vfxZD61h2TXgPs21GrFMBPJ0qr7h/+B1tK9wea
 HyHG6FIdhnt+3j9wtnHwpo2VL
X-Received: by 2002:a50:cd9d:: with SMTP id p29mr3720573edi.30.1632378983300; 
 Wed, 22 Sep 2021 23:36:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6sZGyumEooB67Yh4xUEZVzihaXUP8VPx9KEAKK3nYB6vOFaIoZiqKnq0MxX6rIHNLDqioeQ==
X-Received: by 2002:a50:cd9d:: with SMTP id p29mr3720550edi.30.1632378983068; 
 Wed, 22 Sep 2021 23:36:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id hz15sm2344103ejc.119.2021.09.22.23.36.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Sep 2021 23:36:22 -0700 (PDT)
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
 <YUtyVEpMBityBBNl@google.com> <875yusv3vm.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1e77794-de94-1fb7-c7d3-a80c34f770a4@redhat.com>
Date: Thu, 23 Sep 2021 08:36:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <875yusv3vm.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Aaron Lewis <aaronlewis@google.com>, KVM <kvm@vger.kernel.org>,
 Venkatesh Srinivas <venkateshs@google.com>, Peter Shier <pshier@google.com>,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
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

On 22/09/21 20:53, Marc Zyngier wrote:
> I definitely regret adding the current KVM trace points, as they
> don't show what I need, and I can't change them as they are ABI.

I disagree that they are ABI.  And even if you don't want to change 
them, you can always add parameters or remove them.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
