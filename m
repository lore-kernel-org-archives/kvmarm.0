Return-Path: <SRS0=rNEr=FT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB32BC4361B
	for <kvmarm@archiver.kernel.org>; Tue, 15 Dec 2020 09:15:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19EB722225
	for <kvmarm@archiver.kernel.org>; Tue, 15 Dec 2020 09:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19EB722225
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 652D94B312;
	Tue, 15 Dec 2020 04:15:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VlXoPvAtB8Pu; Tue, 15 Dec 2020 04:15:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D0484B60A;
	Tue, 15 Dec 2020 04:15:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B93534B5A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2020 04:15:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AjxtGsv4dxDU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2020 04:15:21 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B44A24B5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2020 04:15:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1608023721;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=O8vOwmavx8ihSPDbAxUEl+n9azXIzCxQySB+gxrmz0c=;
 b=eqjn3c9nVS8Wusry+P1DHSG+ZSQYsdRi08RKHFkgG2dGLGgE38+HVq0hn+RD/zyRTWU+UM
 2PimUJsz7BBcZD8saITXONM9mtFEJ7tk59c9H+WnMSJGSqPGcV2SNVwtZE1mi2qWDbKdql
 RPLSqOwYiLGG8xvPwlKJ15NQV3neWPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590--Sn2KTchP_WvY6HMSz-iNA-1; Tue, 15 Dec 2020 04:15:17 -0500
X-MC-Unique: -Sn2KTchP_WvY6HMSz-iNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 447851935780;
 Tue, 15 Dec 2020 09:15:16 +0000 (UTC)
Received: from [10.36.116.173] (ovpn-116-173.ams2.redhat.com [10.36.116.173])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C08971CBE;
 Tue, 15 Dec 2020 09:15:13 +0000 (UTC)
Subject: Re: [PATCH 5/5] KVM: arm64: Remove redundant call to
 kvm_pmu_vcpu_reset()
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
 <20201201150157.223625-6-alexandru.elisei@arm.com>
 <9f68ed5e-371e-6c0c-7ba3-b14ff059430f@redhat.com>
 <eba17923-3e33-3e3d-0cf0-8f66d389146b@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <594ae6f5-ad00-6279-e963-8b047c0209d6@redhat.com>
Date: Tue, 15 Dec 2020 10:15:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <eba17923-3e33-3e3d-0cf0-8f66d389146b@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

Hi Alexandru,

On 12/14/20 3:02 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> Thanks for having a look!
> 
> On 12/14/20 1:48 PM, Auger Eric wrote:
>> Alexandru,
>>
>> On 12/1/20 4:01 PM, Alexandru Elisei wrote:
>>> KVM_ARM_VCPU_INIT ioctl calls kvm_reset_vcpu(), which in turn resets the
>>> PMU with a call to kvm_pmu_vcpu_reset(). The function zeroes the PMU
>>> chained counters bitmap and stops all the counters with a perf event
>>> attached. Because it is called before the VCPU has had the chance to run,
>>> no perf events are in use and none are released.
>>>
>>> kvm_arm_pmu_v3_enable(), called by kvm_vcpu_first_run_init() only if the
>>> VCPU has not been initialized, also resets the PMU. kvm_pmu_vcpu_reset() in
>> This sounds strange to me. kvm_vcpu_first_run_init() only is called if
>> kvm_vcpu_initialized(vcpu) is true.
> 
> Typo on my part, the "not" should not be there. kvm_vcpu_first_run_init() is
> called only if kvm_vcpu_initialized() returns true in kvm_arch_vcpu_ioctl_run().
> 
>>> this case does the exact same thing as the previous call, so remove it.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  arch/arm64/kvm/pmu-emul.c | 2 --
>>>  1 file changed, 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>> index 398f6df1bbe4..4ad66a532e38 100644
>>> --- a/arch/arm64/kvm/pmu-emul.c
>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>> @@ -850,8 +850,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>>>  		   return -EINVAL;
>>>  	}
>>>  
>>> -	kvm_pmu_vcpu_reset(vcpu);
>>> -
>> this patch does not apply for me (vcpu->arch.pmu.ready = true; ?)
> 
> I should have mentioned it in the cover letter, this is on top of Marc's pmu-undef
> branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-undef
> 
> it should work on top of commit 7521c3a9e630 ("KVM: arm64: Get ready of the PMU
> ready state"), the branch was rebased since I sent the patches.
OK noted.

Thanks

Eric
> 
> Thanks,
> Alex
>>
>> Thanks
>>
>> Eric
>>>  	return 0;
>>>  }
>>>  
>>>
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
