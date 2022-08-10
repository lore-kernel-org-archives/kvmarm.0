Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5002BC00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 12:36:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6B834D8CA;
	Wed, 10 Aug 2022 08:36:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KNa+hiPfPbRb; Wed, 10 Aug 2022 08:36:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B914D87E;
	Wed, 10 Aug 2022 08:36:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FEC54D87E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:36:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RKvGgPmnfXIt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 08:36:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F197C4D870
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:36:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660134963;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=87CTfpJXv+5cfHg/lnngjOgN/RrqyzIAd1Oqc8i/xvY=;
 b=CPXV9rH9TmF+bA0oEZ3dkiTztZ+QFJFIC3rkvagF9+7CP3bDT0/ptWLhmXg3unsCcS+0A5
 592QCzXJ+jgBYWkdu0yolfSVQDzg5N623UV9JDU+1B5xhe7sRrNxqczh0VQOZfuAvDVavr
 fVJ+aCi1FTt5wCVR1AJWOfIsS37Rm90=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-dJi7oxlMM3u982YHV6q42g-1; Wed, 10 Aug 2022 08:36:00 -0400
X-MC-Unique: dJi7oxlMM3u982YHV6q42g-1
Received: by mail-ej1-f71.google.com with SMTP id
 qb27-20020a1709077e9b00b0073160a55fd7so2543880ejc.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:36:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=87CTfpJXv+5cfHg/lnngjOgN/RrqyzIAd1Oqc8i/xvY=;
 b=AMFcvP5V2HWtOlQ1Agy6BX80AcMOfXGoVGX9JoqOBHhLEjRTK2oICOqzLY5tmGdXYo
 y+gECXojKP0udkgq1hwBtGOaAq41ydnkkkfmRZ8b9LKMhZkDjzLI+gQJqr/s6BV6DzgX
 0tED6OYhAei4w8dbCJy2DFek4U8oCSqnu0wsNS/j1Pg0JItJ4dC+O5mbwz6Z93dkQklD
 HRumPzWYTWDS0Pdw/UW6taabprQzh7NX3XdjphLmuXyXbdCDrgUBuThBD+zgTmNycHBR
 S5u426xEbV6w2a1F4wxWZQYK1qUF+qHm1GEvquUnbICCeSOKk7b3tFUCI1lvZaTZuVyB
 fy/A==
X-Gm-Message-State: ACgBeo3iQXeIwJGs5p1iP6KHjYtv6bbLH78mJPvh+nO4VVuj0dDFcksR
 vG47hYxanQEUJi1bLfK37sRD8YPeVF3rRsbokKjEBSzfaQNcjtyY8BO3jqxutDw11tFrt0KmZbK
 XcRJZR8ZFZzkVYkK1+AVety32
X-Received: by 2002:a17:907:7f9f:b0:733:76c:44c9 with SMTP id
 qk31-20020a1709077f9f00b00733076c44c9mr2231306ejc.642.1660134959425; 
 Wed, 10 Aug 2022 05:35:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4VclOIWxDOiejEyzXNHWLBzTYbNnvJLzw2rnHm34/ZQmU9fDQpff2RJbtcZ+lFjHCJIwCYxQ==
X-Received: by 2002:a17:907:7f9f:b0:733:76c:44c9 with SMTP id
 qk31-20020a1709077f9f00b00733076c44c9mr2231285ejc.642.1660134959206; 
 Wed, 10 Aug 2022 05:35:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 ky16-20020a170907779000b00730a73cbe08sm2246142ejc.169.2022.08.10.05.35.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Aug 2022 05:35:58 -0700 (PDT)
Message-ID: <c95aec97-6fbd-dca5-6aa6-b8242d5a379a@redhat.com>
Date: Wed, 10 Aug 2022 14:35:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Gavin Shan <gshan@redhat.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
 <1014177394.115022.1660052656961.JavaMail.zimbra@efficios.com>
 <YvLT1fd8ddybF5Uw@google.com>
 <8c1f33b4-a5a1-fcfa-4521-36253ffa22c8@redhat.com>
 <1316061904.375.1660134559269.JavaMail.zimbra@efficios.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1316061904.375.1660134559269.JavaMail.zimbra@efficios.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu <yihyu@redhat.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>, maz <maz@kernel.org>,
 shuah <shuah@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On 8/10/22 14:29, Mathieu Desnoyers wrote:
>> - By design, selftests/rseq and selftests/kvm are parallel. It's going to
>> introduce
>>    unnecessary dependency for selftests/kvm to use selftests/rseq/librseq.so. To
>>    me,
>>    it makes the maintainability even harder.
> In terms of build system, yes, selftests/rseq and selftests/kvm are side-by-side,
> and I agree it is odd to have a cross-dependency.
> 
> That's where moving rseq.c to tools/lib/ makes sense.
> 
>> - What selftests/kvm needs is rseq-thread-pointer.h, which accounts for ~5% of
>>    functionalities, provided by selftests/rseq/librseq.so.
> I've never seen this type of argument used to prevent using a library before, except
> on extremely memory-constrained devices, which is not our target here.

I agree.

To me, the main argument against moving librseq to tools/lib is a 
variant of the build-system argument, namely that recursive Make 
sucks[1] and selftests/kvm right now does not use tools/lib.  So, for a 
single-file library, it may be simply not worth the hassle.

On the other hand, if "somebody else" does the work, I would have no 
problem with having selftests/kvm depend on tools/lib, not at all.

Thanks,

Paolo

[1] Kbuild is a marvel that makes it work, but it works because there 
are no such cross-subdirectory dependencies and anyway 
tools/testing/selftests does not use Kbuild.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
