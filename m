Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF86C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 13:56:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D49BB613B0
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 13:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D49BB613B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE7E4B3C0;
	Tue, 20 Apr 2021 09:56:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fHHvHyAH-CSw; Tue, 20 Apr 2021 09:56:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CAC04B15B;
	Tue, 20 Apr 2021 09:56:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94E324B11D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:56:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MbDVbKURtUiZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 09:56:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3726C4B103
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:56:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618926993;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2swGFScfNKtndGubsPyzcMB/R/9UWctxaEjz506YT0I=;
 b=i5qMX7rR6a6dQanEzIZMc9zReuhmekT6n2E9Xw4w1rxBtKRgoe+0o1VqZlxXFhUW7dRmmG
 nusbCdb1IgO+8pB3vbp3WhQbJVZ/RruZV8X7Tgj5eLl7lhQmdWTj/xSt8zYR7g0v/D25mo
 Rc1sMxaW6g+1RUtYN438qyuOP8HjXlY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-vDf0d8skMBufe1zfv4iW7A-1; Tue, 20 Apr 2021 09:56:30 -0400
X-MC-Unique: vDf0d8skMBufe1zfv4iW7A-1
Received: by mail-wm1-f70.google.com with SMTP id
 26-20020a05600c021ab029012e366eff83so2660388wmi.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 06:56:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:organization:subject
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=2swGFScfNKtndGubsPyzcMB/R/9UWctxaEjz506YT0I=;
 b=tDfcbUHhCdplP8tEv8uh6PdI0bSynA/gOmewmi62A+V35xte7wEYbqMaKactp/6SUa
 mVt2G/Y6Ig9poV+mqytKj/QsAndtmwQijzol1UQkfeNf4P+148rfchG345ZIw5CDMU99
 DXyEr6fCnPGs6+GVposxcML32SLddRLpmdkERUfIcDZfQb8rydF+1ii9baPgQ2qnrWJx
 Cwp3PbsPvJiqSdLwaYjqgb4csoZEKuQPoi/RCZih31UvcQFQCL+URPFrbGOo/Rqf5CjH
 jrF49OrlgtcopTfNrmkePqttc7Iz8VDUFTkm+6dPf+mewhtDPUWOJkUtZUzHbsILTC/o
 /GFQ==
X-Gm-Message-State: AOAM530e2QfgMCi1DrcYYeuzA+2wYYoqryhP2VaoiueYWH8RkRQNfaXY
 1+pGSwiKr1Zv+KvQ7/bdEVGRqx/uDP5pC2sAkcUsUoegv/Np70yl/4fLeNtWe24Ru+nUPfPNQJb
 nHAMB+3rdg7nj8jspMKQ6dN5W
X-Received: by 2002:a1c:7714:: with SMTP id t20mr4773904wmi.24.1618926989455; 
 Tue, 20 Apr 2021 06:56:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXffdbVbO4EhLxZXboPYwUyY34Zz8JQIixcWjehp7ikNXXuUMfZAGOffqPbzkJhVg2Dv9JJQ==
X-Received: by 2002:a1c:7714:: with SMTP id t20mr4773877wmi.24.1618926989194; 
 Tue, 20 Apr 2021 06:56:29 -0700 (PDT)
Received: from [192.168.3.132] (p4ff2390a.dip0.t-ipconnect.de. [79.242.57.10])
 by smtp.gmail.com with ESMTPSA id
 c18sm27378176wrn.92.2021.04.20.06.56.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Apr 2021 06:56:28 -0700 (PDT)
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-3-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 2/4] memblock: update initialization of reserved pages
Message-ID: <ed8f10a0-9b68-1d12-0305-90fd378af6b9@redhat.com>
Date: Tue, 20 Apr 2021 15:56:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210420090925.7457-3-rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
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

On 20.04.21 11:09, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> The struct pages representing a reserved memory region are initialized
> using reserve_bootmem_range() function. This function is called for each
> reserved region just before the memory is freed from memblock to the buddy
> page allocator.
> 
> The struct pages for MEMBLOCK_NOMAP regions are kept with the default
> values set by the memory map initialization which makes it necessary to
> have a special treatment for such pages in pfn_valid() and
> pfn_valid_within().

Just a general question while thinking about it:

Would we right now initialize the memmap of these pages already via 
memmap_init_zone()->memmap_init_range()? (IOW, not marking the 
PageReserved?)

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
