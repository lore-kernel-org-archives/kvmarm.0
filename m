Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6F417E
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667953082;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pKwa5tgicgCC2L/+x5ouXLtSmYc/paCMnoq3Or0x2cg=;
	b=fvrn5yt3wz1/ikY9B+OWxNilrs9bO3kLFdaRHE9SrvXmfiaiQ9sC0kQLL1qmI111HV8liI
	A7F8cwKFwdNil5c9dmrOykBtkzvo+xOyip0HxNY4u5A5lyeHw745LLxIpENXuzGgvqm8YF
	j4L+w2ImqDJIgnaZzLWfQUFa86CNeWs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-6EHJWeOTMTmD7uTq523Tbw-1; Tue, 08 Nov 2022 19:17:56 -0500
X-MC-Unique: 6EHJWeOTMTmD7uTq523Tbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3FFB380392A;
	Wed,  9 Nov 2022 00:17:55 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F66E111E3E4;
	Wed,  9 Nov 2022 00:17:49 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, ajones@ventanamicro.com, bgardon@google.com,
 dmatlack@google.com, will@kernel.org, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, pbonzini@redhat.com, maz@kernel.org,
 peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
 shan.gavin@gmail.com
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com> <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
Date: Wed, 9 Nov 2022 08:17:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y2rurDmCrXZaxY8F@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Message-ID: <20221109001746.x50u3KnfC3vp0cDpXI7255MwfdTT-ekYnkf9kUWTN9U@z>

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

