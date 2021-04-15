Return-Path: <SRS0=5CXi=JM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EC4C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 15 Apr 2021 09:30:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E68D461222
	for <kvmarm@archiver.kernel.org>; Thu, 15 Apr 2021 09:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E68D461222
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3B34B63C;
	Thu, 15 Apr 2021 05:30:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sLBhhaASBHYa; Thu, 15 Apr 2021 05:30:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57D1C4B646;
	Thu, 15 Apr 2021 05:30:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 293774B626
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 05:30:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W1KQzW7ifKtq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Apr 2021 05:30:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0DDF4B455
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 05:30:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618479018;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MW/mRgvf+zkYoiSHfMZp2dDTVVI25+tYOHvOtleD70I=;
 b=VVIZREslz8VzRQq7MhrD1H6qoFA1+3UgOAU+aCmpMmjV0bdEhP8Yt9oSaMDi2NxS1evinQ
 x8bLztxrduY7G4cxC57MM3U8rAe7ARqBz+CAhLT4xpeLJT0uOYIP/Ndrt2ak0d0YfrJ9MX
 c3MugtSjGncvX718ac8PouQhCVC03Ng=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-kvJGFWpLPmW0drWNojwAjg-1; Thu, 15 Apr 2021 05:30:14 -0400
X-MC-Unique: kvJGFWpLPmW0drWNojwAjg-1
Received: by mail-wm1-f69.google.com with SMTP id
 x20-20020a7bc2140000b029012bb4d2b5d6so2683330wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 02:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=MW/mRgvf+zkYoiSHfMZp2dDTVVI25+tYOHvOtleD70I=;
 b=jYaulIJxxJJ1pv1DEHPK++z9bSov5gMdePmCXlQTqricEBvOvIvuGfK4/Lh0U/xPrr
 BI6kpk3YgpcSGvoHrir87t2wXK3O2L/L5oKjzbNMu7LhE6MXIUi6/5t9ZtOCE7CWqMwK
 3/uqlpqFE6nuj2+fWfS5upmIRrybxFm21zBVnW8sl3YYIMWX8dxywGw42Qj39WYU8n6G
 yUQ9Y8xHsUkUxQcEwk3VXiEYqpyNamsMwFiUqH+UB0Ejyb1iNid0m5qqQiNFEzzvh143
 MN/ne/+9IJrz9jMvuYNUy544Nj+eMtBwvu4RmsT3+hifNXY8pdptzg+PmrVnJH4gebVz
 p8IA==
X-Gm-Message-State: AOAM531xmFHOE8k9oIJZVopeQ9B82XMP2kqSfQAaImkq6tGaA2hVEUqW
 1fARPphgMSblfYIHJH04E62sRbGKS1W14zET4HyxIZZHwwwVEW+Fg8M6Mzcw05rvAogTrzrSRjM
 a/Hzh0NjKBaxdqMOx1jPbCKVR
X-Received: by 2002:a5d:6a84:: with SMTP id s4mr2472825wru.92.1618479013339;
 Thu, 15 Apr 2021 02:30:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8b0HIW4SQWI0F4SN4CcB7oMoecgIFl/eiaSw1ft7FPToZP8/z36BeeQADlUaxJ82PzDz6Hg==
X-Received: by 2002:a5d:6a84:: with SMTP id s4mr2472795wru.92.1618479013135;
 Thu, 15 Apr 2021 02:30:13 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6392.dip0.t-ipconnect.de. [91.12.99.146])
 by smtp.gmail.com with ESMTPSA id
 p17sm1659280wmq.47.2021.04.15.02.30.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 15 Apr 2021 02:30:12 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 1/3] memblock: update initialization of reserved
 pages
To: Mike Rapoport <rppt@kernel.org>
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-2-rppt@kernel.org>
 <0c48f98c-7454-1458-15a5-cc5a7e1fb7cd@redhat.com>
 <CAMj1kXGw97epyP2HdHjA8Yp6+VF1j5xmd0AgVBBv3k+h_B610w@mail.gmail.com>
 <3811547a-9057-3c80-3805-2e658488ac99@redhat.com>
 <YHdPmtpzFxHE9mAt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <f5503130-c0e7-329f-86c4-727ece1c860f@redhat.com>
Date: Thu, 15 Apr 2021 11:30:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YHdPmtpzFxHE9mAt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mike Rapoport <rppt@linux.ibm.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

> Not sure we really need a new pagetype here, PG_Reserved seems to be quite
> enough to say "don't touch this".  I generally agree that we could make
> PG_Reserved a PageType and then have several sub-types for reserved memory.
> This definitely will add clarity but I'm not sure that this justifies
> amount of churn and effort required to audit uses of PageResrved().
>   
>> Then, we could mostly avoid having to query memblock at runtime to figure
>> out that this is special memory. This would obviously be an extension to
>> this series. Just a thought.
> 
> Stop pushing memblock out of kernel! ;-)

Can't stop. Won't stop. :D

It's lovely for booting up a kernel until we have other data-structures 
in place ;)


-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
