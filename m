Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A836CC38A2C
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62B3220784
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UcTzm7uI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62B3220784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E094B206;
	Wed, 15 Apr 2020 05:23:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RIi-PjxX-kIm; Wed, 15 Apr 2020 05:23:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D00E4B22E;
	Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EEA04B18D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 05:08:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5PSLiBse8E0k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 05:07:59 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 658C34B0F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 05:07:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586941679;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/EXNpOGZswAeAZPkceeFE/XM7sXAwUaoIFU9vZ0wVCE=;
 b=UcTzm7uICWtO7ji/wKvxFy3p0SaCmZB7hRxQmE1x1IaWwSiEpq3xadw9M0I4DOnE5iAtt6
 +Y3kVI9v6IlWROtJLLph01dV+OyqT91FBB6lRSgp8t4aivR4RLFbdCXOpJMchZw7Z1JSb6
 SSkvTyVQtAuZ/HDkFEULF3B/AVOuWsg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-2_QOMZBFOOKtSlc2Q-6SSQ-1; Wed, 15 Apr 2020 05:07:57 -0400
X-MC-Unique: 2_QOMZBFOOKtSlc2Q-6SSQ-1
Received: by mail-wm1-f71.google.com with SMTP id f8so5480447wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 02:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=lisOMIPYzGEOUKW/w9q538cTmyUuHd07/Sojgyr8MlQ=;
 b=Yn2nAWs0UVKb0jpty7esrs+0OpaPFUv1asXTXoOpvHnBkNEQLHso/hAV6or6ZwkC7r
 9Fi0P8zwjyYEHFB3oX2TR075Sn6vC/1kbqcRiSqb8hsDhcT92YT1cUR9pvnrRYtickaO
 tmvXHWxgadqhhW/XP1NSffMLCtwX8sSiRh5CYtOgud7KLkXOIRJLZhTQSELUdSox1I+w
 A/QyjKM2qw+/98hEY1PzU9uUTq9EGE9X58qzyNkBdJt8WxxD5hnmFikkKMEjWsma6vp9
 5O88gEX3xjrA0pvEVBzwT3Z9YJHp9kUJrjbnRu2CuuNtf8ss0KyeHUfNApXbzwkMIRjp
 8xuw==
X-Gm-Message-State: AGi0PuYuVUUTJSO/SzgcvmV987UW2yf0C2YFisH2+GnNpUth8FE8wTQn
 W8NA4LgWCFe1DuwpnkQ6MVaMQSwUfIHRbBqQYz50mXQ8yuS2byj8juzzn4bDP9gv/b/XTuiTjxm
 DBn98fDis/MX2wlIr7/9X/fVV
X-Received: by 2002:a5d:6841:: with SMTP id o1mr27977385wrw.412.1586941676332; 
 Wed, 15 Apr 2020 02:07:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypIXD/p9LNlXg20pn+U/yQCcvvORh177d5YZbgu7SsoqIprQYNJ2FhjSis/HsfEJeQMW+4tCHg==
X-Received: by 2002:a5d:6841:: with SMTP id o1mr27977353wrw.412.1586941676047; 
 Wed, 15 Apr 2020 02:07:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id e5sm23214697wru.92.2020.04.15.02.07.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Apr 2020 02:07:55 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
In-Reply-To: <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <875ze2ywhy.fsf@vitty.brq.redhat.com>
 <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
Date: Wed, 15 Apr 2020 11:07:53 +0200
Message-ID: <87a73dxgk6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Wed, 15 Apr 2020 05:23:47 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, maz@kernel.org, joro@8bytes.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 mingo@redhat.com, bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
 tglx@linutronix.de, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com
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

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:

> On 2020/4/14 22:26, Vitaly Kuznetsov wrote:
>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
>> 
>>> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
>>> where vcpu->run is the kvm_run parameter, so it has been replaced.
>>>
>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 8 ++++----
>>>   virt/kvm/arm/arm.c | 2 +-
>>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 3bf2ecafd027..70e3f4abbd4d 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>   		r = -EAGAIN;
>>>   		if (signal_pending(current)) {
>>>   			r = -EINTR;
>>> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
>>> +			kvm_run->exit_reason = KVM_EXIT_INTR;
>> 
>> I have a more generic question: why do we need to pass 'kvm_run' to
>> kvm_arch_vcpu_ioctl_run() if it can be extracted from 'struct kvm_vcpu'?
>> The only call site looks like
>> 
>> virt/kvm/kvm_main.c:            r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
>> 
>
> In the earlier version, kvm_run is used to pass parameters with user 
> mode and is not included in the vcpu structure, so it has been retained 
> until now.
>

In case this is no longer needed I'd suggest we drop 'kvm_run' parameter
and extract it from 'struct kvm_vcpu' when needed. This looks like a
natural add-on to your cleanup patch.

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
