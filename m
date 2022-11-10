Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801BCC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 10:57:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E074BA91;
	Thu, 10 Nov 2022 05:57:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WXxxB0PYFs5F; Thu, 10 Nov 2022 05:56:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7AC14BA63;
	Thu, 10 Nov 2022 05:56:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF73C4BA59
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 05:56:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yYIyZ9iBJfqG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 05:56:56 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B26654BA22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 05:56:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668077816;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EI4/m9Qd02qpE1/nZDW14QUuG36/1JG5M4vfvVB0x/4=;
 b=ZZzHIWiUD48U2bctS7TMgrYTVoFKf5/RmzXvN7l4DgqVvrgqjDiXHfSA1g+524He2bkkB9
 JLvSUSOI4wZNOa9hozh4zCohSESqsANBXo/9fonadp2DpoCZu/jIQRTYMkf55ka1Qowa70
 MIvOYgcysRdpOaLsX8SGeGjcbBN3NYk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-8pMJ5VrTM4SNvvdH64v-sg-1; Thu, 10 Nov 2022 05:56:53 -0500
X-MC-Unique: 8pMJ5VrTM4SNvvdH64v-sg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3957885A59D;
 Thu, 10 Nov 2022 10:56:52 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 306B240C6F73;
 Thu, 10 Nov 2022 10:56:45 +0000 (UTC)
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Marc Zyngier <maz@kernel.org>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com> <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
 <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
 <Y2r1ErahBE3+Dsv8@google.com>
 <672eb11b-19db-9a9f-1898-8d2af0d45724@redhat.com>
 <86sfirp0lm.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <94d9e15f-103b-304b-65a4-a9c60e590965@redhat.com>
Date: Thu, 10 Nov 2022 18:56:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <86sfirp0lm.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvm@vger.kernel.org, bgardon@google.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

Hi Marc,

On 11/10/22 6:25 PM, Marc Zyngier wrote:
> On Wed, 09 Nov 2022 00:51:21 +0000,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> On 11/9/22 8:32 AM, Sean Christopherson wrote:
>>> That said, there're no remaining issues that can't be sorted out
>>> on top, so don't hold up v10 if I don't look at it in a timely
>>> manner for whatever reason.  I agree with Marc that it'd be good
>>> to get this in -next sooner than later.
>>>
>>
>> Sure. I would give v9 a few days, prior to posting v10. I'm not sure
>> if other people still have concerns. If there are more comments, I
>> want to address all of them in v10 :)
> 
> Please post v10 ASAP. I'm a bit behind on queuing stuff, and I'll be
> travelling next week, making it a bit more difficult to be on top of
> things. So whatever I can put into -next now is good.
> 

Thanks, Marc. v10 was just posted :)

https://lore.kernel.org/kvmarm/20221110104914.31280-1-gshan@redhat.com/T/#t

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
