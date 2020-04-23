Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C634C55186
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 09:26:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 093A121569
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 09:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GvAnHRSD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 093A121569
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51E084B0BF;
	Thu, 23 Apr 2020 05:26:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9w39cqoScQnj; Thu, 23 Apr 2020 05:26:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 632F44B107;
	Thu, 23 Apr 2020 05:26:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55BF54B15B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 05:26:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ivpxRkShREKV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 05:26:10 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5625F4B107
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 05:26:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587633970;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MGgmr4DwO0KzfyPWlPuSjwCWCAlutT/YH5ClZ1SR4T4=;
 b=GvAnHRSD/ptgzPjwurhto7PzVLpikhHg54JNw5S2YZVnYLoE3Ig+moKxpCG3uWoVjTbWHW
 1vSSnf9kawTIi4wigaUnBRdwmSO0jsjGzittZ8X58dY3Pohfy4TmOb9Bri30Zefq3A/70F
 LuMQvvHvsDCxeT5ATQ01FGJZn6hlA2U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-jR0vp98zMaac397TiSe39Q-1; Thu, 23 Apr 2020 05:26:07 -0400
X-MC-Unique: jR0vp98zMaac397TiSe39Q-1
Received: by mail-wm1-f70.google.com with SMTP id b203so2058714wmd.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 02:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=MGgmr4DwO0KzfyPWlPuSjwCWCAlutT/YH5ClZ1SR4T4=;
 b=E+B2mT403gtTV5Ptk+trAfhhkEM4Qzay0F/lnZ/KMhd7Ndz1dfWKxNZ0u1Ujnl84BY
 ZE3IJHG5lUalCqwMu/vRxtb9z5AFci6KsgttlE1BHEaC497OaAWRwrhFFn9jwsV5B84r
 1MuXRqPLtAQVJ94cK09EYF0i4ds/E7DSYkGN+9umt8dOS3hj99xuSSTFdmYEcASjdsMP
 ytf8mx3XXXjD4HoA3on9HTlxlTXoPyxtD1RsiIkVz7qNZ7BtQURO3so8pvplx0mwEDoE
 RaFKGo18l5MFj8LEzrleMWf7t0yPMEj9gU8sFQG8KFCpTcOBQlmR9iVU94lxc/I5J2YU
 hRGQ==
X-Gm-Message-State: AGi0PuYJP0baCNAbQnA+5X1X0q0SkaPqWdyLVxE6AOF1TIpPP4TpsKeO
 O97AucbU5fHhjY0JOk0++0KhSisFi224gPMifD2eLFHIn+lwjp47260znonjThO4oj9kqOb87BI
 Vu+M8Z1D64OOV+Jiqd7koIh2g
X-Received: by 2002:adf:ee91:: with SMTP id b17mr3881558wro.109.1587633966466; 
 Thu, 23 Apr 2020 02:26:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKViKVqjhZYWHhmD4gX+L181e384ppt9H3dp83Sm4GYTaac8jfbTOwhBotE8r0qEIg2tyXvIA==
X-Received: by 2002:adf:ee91:: with SMTP id b17mr3881512wro.109.1587633966196; 
 Thu, 23 Apr 2020 02:26:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926?
 ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
 by smtp.gmail.com with ESMTPSA id z18sm2779590wrw.41.2020.04.23.02.26.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Apr 2020 02:26:05 -0700 (PDT)
Subject: Re: [PATCH 4/5] kvm: Replace vcpu->swait with rcuwait
To: Peter Zijlstra <peterz@infradead.org>
References: <20200422040739.18601-1-dave@stgolabs.net>
 <20200422040739.18601-5-dave@stgolabs.net> <20200423094140.69909bbb@why>
 <f07f6f55-9339-04b0-3877-d3240abd6d9c@redhat.com>
 <20200423091911.GP20730@hirez.programming.kicks-ass.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a1e2aa6-64b2-f642-1e19-d3f5684d70b3@redhat.com>
Date: Thu, 23 Apr 2020 11:26:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423091911.GP20730@hirez.programming.kicks-ass.net>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Davidlohr Bueso <dave@stgolabs.net>, kvm@vger.kernel.org,
 Davidlohr Bueso <dbueso@suse.de>, Marc Zyngier <maz@kernel.org>,
 bigeasy@linutronix.de, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 will@kernel.org, joel@joelfernandes.org, tglx@linutronix.de,
 torvalds@linux-foundation.org, kvmarm@lists.cs.columbia.edu
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

On 23/04/20 11:19, Peter Zijlstra wrote:
>>
>> 1) Davidlohr, please post only patches 1-3 to "equalize" the swait and
>> rcuwait APIs.
>>
>> 2) Peter, please prepare a topic branch for those, or provide Acked-by
> I don't think I have anything that conflicts with this, so sure, take
> the whole thing through KVM.
> 
> For 1-3 (and I'll send a small niggle for 3 right after this):
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Great thanks.  I assume you have no issue with rcuwait_active either.

Paolo

> I'll keep 5 as it is unrelated.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
