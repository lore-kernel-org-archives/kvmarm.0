Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6693C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 143C260EFD
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 143C260EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 743BA4B130;
	Fri, 24 Sep 2021 05:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xjcKO3jErlhr; Fri, 24 Sep 2021 05:28:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8974B10D;
	Fri, 24 Sep 2021 05:28:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FAA4B101
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B9ensnydqX1s for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 05:28:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 372BF406E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:28:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632475715;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IoDPw1naO7tilFKWpbIB0mjp/4gXU+WPMdM7pLJKoHA=;
 b=CoMAtPViKwhvpZCGGlddeE2FnHzAHeTK9S76iJBv8v+ngCMq+6LzBQY1g/+9xPBOBT0k+/
 Ko3a0PlxIvqPy/K/44oFl+TPj50In5hXV9D146z/soDHURjLcOsK1iyyHKDQFpXLswBqWl
 plx3VyIyIw2AGBSe2q4xWs4tAlXs4c8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-ulLUIzJAOkCVKrPbnNDpPg-1; Fri, 24 Sep 2021 05:28:31 -0400
X-MC-Unique: ulLUIzJAOkCVKrPbnNDpPg-1
Received: by mail-ed1-f69.google.com with SMTP id
 c7-20020a05640227c700b003d27f41f1d4so9587384ede.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 02:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=IoDPw1naO7tilFKWpbIB0mjp/4gXU+WPMdM7pLJKoHA=;
 b=gUExxyCWM/msyKK9swmFtlEJvV55PNt96pwJWrgEmyziVVA+nsh6ieb8USlEciyNsa
 WGX0u5TWoO10os4cQpiTZ6NQ3MBzYFjFcX0QB6ZIL7TsN0xIOBEzj5xSZGWCEbSQEuHu
 gqLTpsaL05x56u0skDV/E207YBiYG1Cwl1j/QBX5ckdF631F3AXutrcg8li3lRRr/bD9
 u9c67kOqIGr351pgo/UUDAWTrm6npHD4cb6kkQCqeZlYleDZKCBMQ27ZGM0cElqbRxCq
 LDbQ/RKSbH7c9jOlAuByMMwT61J8u20tsluNdbmnVTylFyxtoAfk2kXTWFHhYupv7ZW/
 XefQ==
X-Gm-Message-State: AOAM531iPjOJsz99YJEV16d1+Uawm5jXlqQtCXu56+kkkc5AeiL/xqvv
 pthygZ9a+nlvyrMWmFFl0GLVcnFo2X5rLt9Pf/haPWZUJEi//aDA5/+fU2nBgVcMo3sdmf0fgvO
 IsbS0jHWNo+/F5LcqYEQGMbh2
X-Received: by 2002:a05:6402:397:: with SMTP id
 o23mr3937693edv.59.1632475710478; 
 Fri, 24 Sep 2021 02:28:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh74xZ8KOA0BU0tWlr2IZ19X6YEnrfIAboOpOI5qSEDDf3VV5te0ekyXZWkyb0hkI6Io5dng==
X-Received: by 2002:a05:6402:397:: with SMTP id
 o23mr3937667edv.59.1632475710253; 
 Fri, 24 Sep 2021 02:28:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id b14sm5403970edy.56.2021.09.24.02.28.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Sep 2021 02:28:29 -0700 (PDT)
Message-ID: <de3ff2de-da79-fd0c-c90b-f767414b0b69@redhat.com>
Date: Fri, 24 Sep 2021 11:28:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v7 5/6] KVM: x86: Refactor tsc synchronization code
To: Sean Christopherson <seanjc@google.com>, Oliver Upton <oupton@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-6-oupton@google.com> <YTEkRfTFyoh+HQyT@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YTEkRfTFyoh+HQyT@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
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

On 02/09/21 21:21, Sean Christopherson wrote:
> 
>> +	if (!matched) {
>> +		...
>> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
>> +		kvm->arch.nr_vcpus_matched_tsc = 0;
>> +	} else if (!already_matched) {
>> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
>> +		kvm->arch.nr_vcpus_matched_tsc++;
>> +	}
>> +
>> +	kvm_track_tsc_matching(vcpu);
>> +	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
>
> This unlock is imbalanced if matched and already_matched are both true.  It's not
> immediately obvious that that_can't_  happen, and if it truly can't happen then
> conditionally locking is pointless (because it's not actually conditional).

This is IMO another reason to unify tsc_write_lock and 
pvclock_gtod_sync_lock.  The chances of contention are pretty slim.  As 
soon as I sort out the next -rc3 pull request I'll send out my version 
of Oliver's patches.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
