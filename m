Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E98C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 00:18:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E0D4B82C;
	Tue,  8 Nov 2022 19:18:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NkAZ4xdBXTKZ; Tue,  8 Nov 2022 19:18:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0F44B831;
	Tue,  8 Nov 2022 19:18:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C56D4B823
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:18:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rhcQU6opquoM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 19:18:00 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F8C4B81C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:18:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667953079;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pKwa5tgicgCC2L/+x5ouXLtSmYc/paCMnoq3Or0x2cg=;
 b=c2Uji1l4QYlBOrm66E7d955tQa+gLYiD5GbMUlBr2Qois/eXXF08xr7s0YSA5JA7GXbM9v
 RmRJRhipY8UXK2tGlaaPNdhM/PRchhoJGRjhWa05tCKYnhfAbmZv1tekIvUG+aiI06hqTk
 IQ3HJJN3d/k8BsG3I09LLpFM/eYubL8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-6EHJWeOTMTmD7uTq523Tbw-1; Tue, 08 Nov 2022 19:17:56 -0500
X-MC-Unique: 6EHJWeOTMTmD7uTq523Tbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3FFB380392A;
 Wed,  9 Nov 2022 00:17:55 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F66E111E3E4;
 Wed,  9 Nov 2022 00:17:49 +0000 (UTC)
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Sean Christopherson <seanjc@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com> <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
Date: Wed, 9 Nov 2022 08:17:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2rurDmCrXZaxY8F@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Sean,

On 11/9/22 8:05 AM, Sean Christopherson wrote:
> On Wed, Nov 09, 2022, Gavin Shan wrote:
>> On 11/9/22 12:25 AM, Sean Christopherson wrote:
>>> I have no objection to disallowing userspace from disabling the combo, but I
>>> think it's worth requiring cap->args[0] to be '0' just in case we change our minds
>>> in the future.
>>>
>>
>> I assume you're suggesting to have non-zero value in cap->args[0] to enable the
>> capability.
>>
>>      if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>>          !kvm->dirty_ring_size || !cap->args[0])
>>          return r;
> 
> I was actually thinking of taking the lazy route and requiring userspace to zero
> the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
> forget that `cap->flags` exists.
> 
> Just this?
> 
> 	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> 	    !kvm->dirty_ring_size || cap->flags)
> 		return r;
> 
> It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
> that's seems quite unlikely and not the end of the world if it does happen.  And
> on the other hand, requiring '0' is less weird and less annoying for userspace
> _now_.
> 

I don't quiet understand the term "lazy route". So you're still thinking of the
possibility to allow disabling the capability in future? If so, cap->flags or
cap->args[0] can be used. For now, we just need a binding between cap->flags/args[0]
with the operation of enabling the capability. For example, "cap->flags == 0x0"
means to enable the capability for now, and "cap->flags != 0x0" to disable the
capability in future.

The suggested changes look good to me in either way. Sean, can I grab your
reviewed-by with your comments addressed? I'm making next revision (v10)
a final one :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
