Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63850C48BD1
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:23:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E214D6128A
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E214D6128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3A9A40629;
	Thu, 10 Jun 2021 02:23:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fq5G1X5CbEPQ; Thu, 10 Jun 2021 02:23:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA8D40799;
	Thu, 10 Jun 2021 02:23:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A6E40629
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:23:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ErLFk0qnX0Q5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 02:23:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D51F0405D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:23:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623306194;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=y9OIQ37NN86b1J9AvzEspXWjtjFLEFdsV3WicIqcSRs=;
 b=XqCdTFXlCEVriHRkID0BZXZtRSn7odO7dehcOwhd4GxbFdzQtNyzDr8n5Yx1jtbagNPlSs
 kGZtxDUCtZuNBa3x2EXEofe6VZLIFC0JJdS5HFOBtzIaueod18WRO6BvCkXTyJAJcr8Y3X
 gBh5dk5w7Xn5Z919WOW0vCj4dwMq9oE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194--hT6UE-WPIOc8aC4vC2H9w-1; Thu, 10 Jun 2021 02:23:13 -0400
X-MC-Unique: -hT6UE-WPIOc8aC4vC2H9w-1
Received: by mail-wm1-f70.google.com with SMTP id
 j6-20020a05600c1906b029019e9c982271so3470533wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 23:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=y9OIQ37NN86b1J9AvzEspXWjtjFLEFdsV3WicIqcSRs=;
 b=KWWPiUtQDTEuCcsw/xE0vJQIvmsUqrtlno8laEsYkn7cRrgPMliZKueJwhr/im+cJY
 +/+xYtLUS8o2bf2aib3/1zqUl/w6awwuSerqRdhU02JU3Y3w0yjm2RYzAxqZ1fkhGHX6
 Rdq7jO/PPKYmARlZa0h0/A+IhZQDxeJt7YVd3NFU5fBLuVjNFf6gqfsag5b2DuaM2VnF
 8KixlIiK3ESUJGyrmlmeii3IHpSsXU5iGKmJlFW/7nqE+wvGArBJVAQy1Otse0JdNu74
 ryQpK4cmdUMbP606I3ELIAQJ/zey0PqQQaRr9KLbg4X2QIQnvMY9o5hApkXA8XA37ZIA
 7PBg==
X-Gm-Message-State: AOAM531cvUI8xYRETyXc1U0YOHX6otTWVGxaTwmr4wBplJ8Nto12l+SN
 Q3KbjiEIiK1/KlY+3VXgtxd+66/uZnWVbG8cErID7RBQ0b+plAiTOcc861GyNE6Y7Vl1iwa2im3
 ahPA9kniXCXNkgHFXNJzBKCb+
X-Received: by 2002:a1c:4304:: with SMTP id q4mr12694521wma.89.1623306176584; 
 Wed, 09 Jun 2021 23:22:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZTfWBq0Fv/sP2kbhWGpCObvkcy+Kk8Uv1WxLCdGVISIn/nfvKSLGOLnAS9rw4rbGo0hCx6w==
X-Received: by 2002:a1c:4304:: with SMTP id q4mr12694493wma.89.1623306176334; 
 Wed, 09 Jun 2021 23:22:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m132sm1862894wmf.10.2021.06.09.23.22.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 23:22:55 -0700 (PDT)
To: Oliver Upton <oupton@google.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
 <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
 <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
Message-ID: <7b57ce79-6a17-70ac-4639-47a0df463e49@redhat.com>
Date: Thu, 10 Jun 2021 08:22:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

On 10/06/21 00:04, Oliver Upton wrote:
>> Your approach still needs to use the "quirky" approach to host-initiated
>> MSR_IA32_TSC_ADJUST writes, which write the MSR without affecting the
>> VMCS offset.  This is just a documentation issue.
> 
> My suggested ioctl for the vCPU will still exist, and it will still
> affect the VMCS tsc offset, right? However, we need to do one of the
> following:
> 
> - Stash the guest's MSR_IA32_TSC_ADJUST value in the
> kvm_system_counter_state structure. During
> KVM_SET_SYSTEM_COUNTER_STATE, check to see if the field is valid. If
> so, treat it as a dumb value (i.e. show it to the guest but don't fold
> it into the offset).

Yes, it's already folded into the guestTSC-hostTSC offset that the 
caller provides.

> - Inform userspace that it must still migrate MSR_IA32_TSC_ADJUST, and
> continue to our quirky behavior around host-initiated writes of the
> MSR.
> 
> This is why Maxim's spin migrated a value for IA32_TSC_ADJUST, right?

Yes, so that he could then remove (optionally) the quirk for 
host-initiated writes to the TSC and TSC_ADJUST MSRs.

> Doing so ensures we don't have any guest-observable consequences due
> to our migration of TSC state. To me, adding the guest IA32_TSC_ADJUST
> MSR into the new counter state structure is probably best. No strong
> opinions in either direction on this point, though:)

Either is good for me, since documentation will be very important either 
way.  This is a complex API to use due to the possibility of skewed TSCs.

Just one thing, please don't introduce a new ioctl and use 
KVM_GET_DEVICE_ATTR/KVM_SET_DEVICE_ATTR/KVM_HAS_DEVICE_ATTR.

Christian, based on what Oliver mentions here, it's probably useful for 
s390 to have functionality to get/set kvm->arch.epoch and kvm->arch.epdx 
in addition to the absolute TOD values that you are migrating now.

Paolo

>> 1) In the kernel:
>>
>> * KVM_GET_CLOCK should also return kvmclock_ns - realtime_ns and
>> host_TSC.  It should set two flags in struct kvm_clock_data saying that
>> the respective fields are valid.
>>
>> * KVM_SET_CLOCK checks the flag for kvmclock_ns - realtime_ns.  If set,
>> it looks at the kvmclock_ns - realtime_ns field and disregards the
>> kvmclock_ns field.
>>
>> 2) On the source, userspace will:
>>
>> * per-VM: invoke KVM_GET_CLOCK.  Migrate kvmclock_ns - realtime_ns and
>> kvmclock_ns.  Stash host_TSC for subsequent use.
>>
>> * per-vCPU: retrieve guest_TSC - host_TSC with your new ioctl.  Sum it
>> to the stashed host_TSC value; migrate the resulting value (a guest TSC).
>>
>> 3) On the destination:
>>
>> * per-VM: Pass the migrated kvmclock_ns - realtime_ns to KVM_SET_CLOCK.
>>   Use KVM_GET_CLOCK to get a consistent pair of kvmclock_ns ("newNS"
>> below) and host TSC ("newHostTSC").  Stash them for subsequent use,
>> together with the migrated kvmclock_ns value ("sourceNS") that you
>> haven't used yet.
>>
>> * per-vCPU: using the data of the previous step, and the sourceGuestTSC
>> in the migration stream, compute sourceGuestTSC + (newNS - sourceNS) *
>> freq - newHostTSC.  This is the TSC offset to be passed to your new ioctl.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
