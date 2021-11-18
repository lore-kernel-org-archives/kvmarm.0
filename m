Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B91C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 12:04:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7478F6135E
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 12:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7478F6135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E65394B125;
	Thu, 18 Nov 2021 07:04:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wYUPGgKlJCdx; Thu, 18 Nov 2021 07:04:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C015D4B134;
	Thu, 18 Nov 2021 07:04:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5CCC4B125
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 07:04:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c-3n45x8yo3Y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 07:04:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6F94B119
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 07:04:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637237064;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=W5Ghb5uAlf942gVdbek0yVdXvRxLK8U0BDO6Bp0gMAI=;
 b=JSPbHF3ENpOolrthgXfyiTyy84c6bAcd1pFyzBQ3YO+UNBX+nw9jZz+Upoo+nDOvNEh3cZ
 Ce/v3E+WatSI1Cnl5vqMrJla7KljJYXgECyBjW7g5eHTQ5y8ryQxP20yXAmW2AIokoh4mr
 WaoXH6y9jl6vj3pvmPgQIZoYnYONpCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-k6mdJvwXNi-BzEtUcDvh4A-1; Thu, 18 Nov 2021 07:04:21 -0500
X-MC-Unique: k6mdJvwXNi-BzEtUcDvh4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81DF11006AA1;
 Thu, 18 Nov 2021 12:04:17 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 377E05F4EE;
 Thu, 18 Nov 2021 12:04:09 +0000 (UTC)
Message-ID: <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com>
Date: Thu, 18 Nov 2021 13:04:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
 <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On 11/17/21 22:09, David Woodhouse wrote:
>>   {
>> -	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>> +	struct kvm_vcpu *running_vcpu = kvm_get_running_vcpu();
>>
>> +	WARN_ON_ONCE(vcpu && vcpu != running_vcpu);
>>   	WARN_ON_ONCE(vcpu->kvm != kvm);
> Ah, that one needs to be changed to check running_vcpu instead. Or this
> needs to go first:
> 
> I think I prefer making the vCPU a required argument. If anyone's going to
> pull a vCPU pointer out of their posterior, let the caller do it.
> 

I understand that feeling, but still using the running vCPU is by far 
the common case, and it's not worth adding a new function parameter to 
all call sites.

What about using a separate function, possibly __-prefixed, for the case 
where you have a very specific vCPU?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
