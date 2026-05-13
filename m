Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79FD41C30F
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778676247; cv=none; b=JhpqQLXgLzLYVFMwYzlYZSCYXVywBfP0lsZVax6eoJ0fjVBeKLrVkVyz044iiTq+YjCD++D6X8R5jWZdTfKR6FwacmDk9ruUWikTQ175hkod2cxph1P2UIX/jtPiZ8fQcbrVndhupoenDhVEDiJHL1qey3eTFhKtvC9PoeerFfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778676247; c=relaxed/simple;
	bh=U1yovwocJyt4iBBN2hMuvWGhooDrsAQSGxPcJ2jhBZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o95aCG0jm32sUeK3FXvKnjuF4rxwLEwxeUMdJlKG/rDewoxmw2U4ZCilG65nt+otMge8k/HiCqLN+aQWxJ5ZsnNRh2H3xG05PyXbZOoqeBV8qsyyGhik0IexueQdLCOf6yhUCSdYjQGb7/WMMKo+oRxQ6Hp7xY5Omapz5Yvd2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D6PNqCKT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6PNqCKT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778676245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qCqqmvyfBRoByfly7X2wP/YX/5z+CJ5QvZWJz06fuzM=;
	b=D6PNqCKTVXDGzBD/JKKPy9ZXoFubRTWl3W6s50vzGBgsrrx/8bleQ0ZZn3XaY5zoYUlxap
	lB6jNDZFeBvh3UUBZbUlC7r4YR3uu78nOwXaQnnL3DaQgxE2VNo6C8tqq1JoMT6+EFSBUq
	BqhwHc7PLcbGs600++sIwl9PYYQDM4M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-V10L4c38NFm5JVp7kK65ow-1; Wed,
 13 May 2026 08:43:58 -0400
X-MC-Unique: V10L4c38NFm5JVp7kK65ow-1
X-Mimecast-MFC-AGG-ID: V10L4c38NFm5JVp7kK65ow_1778676234
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66C65180034E;
	Wed, 13 May 2026 12:43:53 +0000 (UTC)
Received: from [10.44.50.86] (unknown [10.44.50.86])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 070DE180034E;
	Wed, 13 May 2026 12:43:44 +0000 (UTC)
Message-ID: <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
Date: Wed, 13 May 2026 14:43:42 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility
 expectations
To: David Woodhouse <dwmw2@infradead.org>, Marc Zyngier <maz@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
 <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com>
 <86h5obya2r.wl-maz@kernel.org>
 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: K5u9j8lKi2GgkFVV2VXmCxw3QhZGY8TpD5Tai6AYMCM_1778676234
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/13/26 11:24, David Woodhouse wrote:
> On Wed, 2026-05-13 at 09:42 +0100, Marc Zyngier wrote:
>> If userspace is not a total joke, it will read all the ID registers,
>> and configure what it wants to see, assuming it is a feature that can
>> be configured (not everything can, because the architecture itself is
>> not fully backward compatible).
>>
>> Yes, this is buggy at times, because the combinatorial explosion of
>> CPU capabilities and supported features makes it pretty hard to test
>> (and really nobody actually does). But overall, it works, and QEMU is
>> growing an infrastructure to manage it in a "user friendly" way.
> 
> Yes, that is precisely what I'm asking for. I'm prepared to deal with
> the fact that KVM/Arm64 is not a stable and mature platform like x86
> is, and that userspace has to find all the random changes from one
> version to the next, and explicitly pin things down to be compatible.
> 
> All I'm asking for is that KVM makes it *possible* to pin things down
> to the behaviour of previously released Linux/KVM kernels.
> 
>> But really, this isn't what David is asking. He's demanding "bug for
>> bug" compatibility. For that, we have two possible cases:
> 
> No, I am not asking you to meet that bar. I merely observed that x86
> does and that it would be nice. But we are a *long* way from that.

x86 doesn't do bug-for-bug compatibility, thankfully - we have quirks 
but only 11 of them, or about one per year since we started adding them. 
  We only add quirks, generally speaking, when 1) we change the way file 
descriptors are initialized, 2) guests in the wild were relying on it, 
or 3) it prevends restoring state saved from an old kernel.  Is there 
anything else?

So you're asking something not really far from this:

>> - this is a behaviour that is not allowed by the architecture: we fix
>>    it for good. We do that on every release. Some minor, some much more
>>    visible. And there is no way we will add this sort of "bring the
>>    bugs back" type of behaviours. Specially when it is really obvious
>>    that no SW can make any reasonable use of the defect. We allow
>>    userspace to keep behaving as before, but the guest will not see a
>>    non-compliant behaviour.

... where for example 
https://lore.kernel.org/kvm/e03f092dfbb7d391a6bf2797ba01e122ba080bcd.camel@infradead.org/ 
is an example of a bug that "no SW can make any reasonable use of".

> Marc, this is complete nonsense and you should know better.
> Once a behaviour is present in a released version of Linux/KVM, we
> can't just declare it "wrong" and unilaterally impose a change in
> guest-visible behaviour on *running* guests as a side-effect of a
> kernel upgrade.
> 
> The criterion for *KVM* to remain compatible is "once it has been in a
> released version of the kernel". Not "once it is in the architecture".

That is *also* obviously nonsense though, isn't it (see example above)? 
The truth is in the middle, "once it is in the architecture" is likely 
too narrow but "once it is in a Linux release" is way too broad.  And 
besides, both miss the point of *configurability* which is the basis of 
it all.

The main difference between x86 and Arm is the default state at 
creation; x86 defaults to a blank slate, mostly; and when we didn't do 
that, we regretted it later (cue the STUFF_FEATURE_MSRS quirk).  It's 
too late to change the behavior for Arm, but I think we can agree that 
patches such as 
https://lore.kernel.org/kvm/20260511113558.3325004-2-dwmw2@infradead.org/ 
("KVM: arm64: vgic: Allow userspace to set IIDR revision 1") are what 
the letter and spirit of this proposal is about.

Marc did not mention having to deal with guests in the wild.  Let's 
ignore it for now because even defining "guests in the wild" is hard; 
and anyway it's not related to the patch that triggered the discussion.

So we have the third case, "restoring state saved from an old kernel". 
If this case arises, I do believe that Arm will have to deal with it and 
introduce quirks or KVM_GET/SET_REG hacks.  Maybe it hasn't happened 
yet, lucky you.

Overall, even if we may disagree about the details, are we really on 
terribly distant grounds, or are we not?

Paolo

