Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D2BC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 06:11:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 208944B0B6;
	Fri, 25 Mar 2022 02:11:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m1bJdy3S8lG1; Fri, 25 Mar 2022 02:11:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0DB44B0B9;
	Fri, 25 Mar 2022 02:11:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AA744B0B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 02:11:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lmJs2U+dUpSM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 02:11:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08D849F38
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 02:11:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648188694;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wuTRsT/Tz6ofz67ssIJ6RwjRRnXFcLV1cw3Q00t4VHc=;
 b=RfKoT5tciV009QvJCBWFej0ijY2vSNL3rO29jgYUxveuD1GX/gMRIK3SxEiZFE7BFMgPcZ
 gzDB93l3Tb0ZGbzZ0WVhq8Ywm7oXMxGsv02/ky4F7iDoi4a22mJNjJ5RMZn8PJNOHYlmtp
 FkMTCQisFlsmuhBNiLp4jEYCxiggNZ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-LzbVV2nSPrSAJp3HCQboTA-1; Fri, 25 Mar 2022 02:11:33 -0400
X-MC-Unique: LzbVV2nSPrSAJp3HCQboTA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4883801E67;
 Fri, 25 Mar 2022 06:11:22 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B6273401053;
 Fri, 25 Mar 2022 06:11:14 +0000 (UTC)
Subject: Re: [PATCH v5 03/22] KVM: arm64: Support SDEI_VERSION hypercall
To: Oliver Upton <oupton@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-4-gshan@redhat.com> <YjoPxLAMIPobBzS0@google.com>
 <d8e151e5-080b-dc87-b7e0-9031a7928853@redhat.com>
 <YjtLVqBbL0jyFFZy@google.com>
 <6f217836-45fb-8833-7bb1-5dc822826f56@redhat.com>
 <YjwiQ10CE5AtoM4Y@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <09814baf-3107-5fa9-f92c-cc271f384c4a@redhat.com>
Date: Fri, 25 Mar 2022 14:11:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YjwiQ10CE5AtoM4Y@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Oliver,

On 3/24/22 3:48 PM, Oliver Upton wrote:
> On Thu, Mar 24, 2022 at 12:07:34PM +0800, Gavin Shan wrote:
> 
> [...]
> 
>>>> Yeah, I was sticky to the pattern of "KVM". However, I think it's good
>>>> to reuse the existing one. Lets use ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
>>>> if you agree. Its first two characters are "VM" at least.
>>>
>>> Sounds fine to me. The only other nit I'd say is we should define a
>>> macro for it too, something like:
>>>
>>>     #define KVM_SDEI_VENDOR	ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
>>>
>>
>> Agreed, and the macro will be put into arch/arm64/include/asm/kvm_sdei.h.
>> arch/arm64/include/uapi/asm/kvm_sdei_state.h isn't the right place because
>> the dependent macro ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 isn't exposed by
>> ABI.
> 
> The argument could definitely be made that our vendor ID should be
> promoted to UAPI. Even though linux is the only known user of our
> vendor-specific hypercalls, nothing is stopping other software from
> using them. Beyond that, these values should really never change anyway.
> 
> It isn't a big deal if you add it to internal headers, either, as the
> only known consumer will be the kernel.
> 

Sure. Lets add it into include/asm/kvm_sdei.h in next respin. We can
expose it when it is needed. For now, I do think Linux is the only
user.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
