Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1934185E
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 10:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668077818;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EI4/m9Qd02qpE1/nZDW14QUuG36/1JG5M4vfvVB0x/4=;
	b=LPgMRyc5JqWJYqg7yRdgfRji4pDr8piYSFhqr9vWi1OlhJ46lAIiiwWqC3+lqgM5JjmlSL
	u1+IA9msvp4NEWASI5EyZglvFQMSsA0TIvTiOJuN7Mp09Mb4uWGPti30nifX3Fk/CCSei/
	egfT8s3+tKdgzUiDWTwepiBu1tDRASU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-8pMJ5VrTM4SNvvdH64v-sg-1; Thu, 10 Nov 2022 05:56:53 -0500
X-MC-Unique: 8pMJ5VrTM4SNvvdH64v-sg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3957885A59D;
	Thu, 10 Nov 2022 10:56:52 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 306B240C6F73;
	Thu, 10 Nov 2022 10:56:45 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
 catalin.marinas@arm.com, andrew.jones@linux.dev, ajones@ventanamicro.com,
 bgardon@google.com, dmatlack@google.com, will@kernel.org,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, pbonzini@redhat.com,
 peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
 shan.gavin@gmail.com
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
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86sfirp0lm.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Message-ID: <20221110105643.O6BZpDTPE_pNSmIjufFU8dv5-b41wZBo0FUnnfw8e6c@z>

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

