Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C75C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 09:17:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC18A61A81
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 09:17:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CC18A61A81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CF834B0A3;
	Fri,  1 Oct 2021 05:17:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bott2wJXN2O8; Fri,  1 Oct 2021 05:17:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BA714B0B4;
	Fri,  1 Oct 2021 05:17:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9B244B0A3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 05:17:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J0BL0q8trLku for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 05:17:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB6BF49DE7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 05:17:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633079864;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DGyCDTmKE3Puz9hbd1Bqa93m33TW7tkrO1GY0BEiFrw=;
 b=G8Jl4WIKybM+gbcJax7zMZCw3ZEU2m9u551hCKS16JVEO7DJOd0IsOiVp9aJMUdjrrHgJT
 MszqJ/XlzOn3w9bdqN+qvjwLLnJ8WNDgr/+1lRE25I4ENeneZAmE1JgDKJv69vRf4NkY0I
 2HIAmdhQZAawn6qQcfiyhuxGF8DTAI0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-jmgli2xbOwyiX08n5KR03w-1; Fri, 01 Oct 2021 05:17:43 -0400
X-MC-Unique: jmgli2xbOwyiX08n5KR03w-1
Received: by mail-wr1-f71.google.com with SMTP id
 j15-20020a5d564f000000b00160698bf7e9so2601067wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 02:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=DGyCDTmKE3Puz9hbd1Bqa93m33TW7tkrO1GY0BEiFrw=;
 b=RO5xAA99vDqC7GHqyxSkvUWxqHUr8si8d2/GBsKFiN8stPW9ztB6ELFg0tYx1HBX5O
 UnzWW+PbUo+XbXBQZmeLlqfFaWK7wjjgcDbJ0KYNwRe92AXcB7NRobMThi0Rdlw4UjzG
 2gW1iQm0LnjKFou5Y4TzqOnawTA5DEWd4sMDnIpTtBZqQrjlWHnOhepFqJm5K7+fWUS4
 ZonNSI8R9cHaDoBfDXpef+sHi8kMGYVBkHz6wFWcdnyYppRwRP7wYHjbGd2VYN4UgSYB
 tigNcNNsbF9hjLKu7Ub7DvOPo5Iu/vxI9LUJo7lrDfB/1LJuFEoB7ghMMQdaUwPrpWzg
 glDA==
X-Gm-Message-State: AOAM5310qVN2C7+F9YTgY9RW2RFzCAJdAqj73MGUoUp8gVR5ENamT5jC
 g74t0mczNs0bohltpBhYbyyOInNKsGMwWV832e43cIYYBYFN4N7Cmpv+9uRVYNCzkoocmxfWjZj
 vZarQBbrzH7t5F/Ce/GsJgTbk
X-Received: by 2002:a5d:50cf:: with SMTP id f15mr11412196wrt.237.1633079862450; 
 Fri, 01 Oct 2021 02:17:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykQN7F6N2QxuVMMTUM6KC2ZEoYFdxkECApzvn9zqqq6yIts+XecYdFr57VC3hfX4SQo9I9wA==
X-Received: by 2002:a5d:50cf:: with SMTP id f15mr11412163wrt.237.1633079862215; 
 Fri, 01 Oct 2021 02:17:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id n186sm7166424wme.31.2021.10.01.02.17.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 01 Oct 2021 02:17:41 -0700 (PDT)
Message-ID: <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
Date: Fri, 1 Oct 2021 11:17:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
To: Marcelo Tosatti <mtosatti@redhat.com>, Oliver Upton <oupton@google.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210930191416.GA19068@fuller.cnet>
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

On 30/09/21 21:14, Marcelo Tosatti wrote:
>> +   new_off_n = t_0 + off_n + (k_1 - k_0) * freq - t_1
> Hi Oliver,
> 
> This won't advance the TSC values themselves, right?

Why not?  It affects the TSC offset in the vmcs, so the TSC in the VM is 
advanced too.

Paolo

> This (advancing the TSC values by the realtime elapsed time) would be
> awesome because TSC clock_gettime() vdso is faster, and some
> applications prefer to just read from TSC directly.
> See "x86: kvmguest: use TSC clocksource if invariant TSC is exposed".
> 
> The advancement with this patchset only applies to kvmclock.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
