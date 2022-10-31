Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F6B8F76
	for <kvmarm@lists.linux.dev>; Mon, 31 Oct 2022 22:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667256528;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BC6zO98Q8uKfNSR6EZGsLuEsjcHYX+7BdvJInvGMYP0=;
	b=hTlcgYAoyhyiZxq2kot3B6nZ7nS0G/rXdabNKFFCipXx3jZXTRn8dkLRJfbcTO0G8uvb2Q
	V6xIpPex4sQSJRI1O/lH4IhTlFLKGZhgV8I/1baqD+6Mum+RGr3IiCrLoob1umU7IzeA5G
	z4CYqwwIDa0R2aTX588kQAsXlCtsqXE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-3jRxnHRDO4ah6fqU3o_hDw-1; Mon, 31 Oct 2022 18:48:47 -0400
X-MC-Unique: 3jRxnHRDO4ah6fqU3o_hDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BAD785A583;
	Mon, 31 Oct 2022 22:48:46 +0000 (UTC)
Received: from [10.64.54.151] (vpn2-54-151.bne.redhat.com [10.64.54.151])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BEB082166B29;
	Mon, 31 Oct 2022 22:48:39 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
To: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peterx@redhat.com,
 will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
 shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, shan.gavin@gmail.com
References: <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com> <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org> <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org> <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
 <36c97b96-1427-ce05-8fce-fd21c4711af9@redhat.com>
 <Y1wIj/sdJw7VMiY5@google.com> <9e57cd7616974c783cce5026d61d310b@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b6ae2d5c-4974-6e1a-e65d-206104ba97ed@redhat.com>
Date: Tue, 1 Nov 2022 06:48:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9e57cd7616974c783cce5026d61d310b@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Message-ID: <20221031224837.w09k7kpJU6Ifo6bngbqCc3bHZslD2nnC8RvDclTNfn0@z>

On 10/31/22 5:08 PM, Marc Zyngier wrote:
> On 2022-10-28 17:51, Sean Christopherson wrote:
>> On Fri, Oct 28, 2022, Gavin Shan wrote:
>>> On 10/28/22 2:30 AM, Marc Zyngier wrote:
>>> > On Thu, 27 Oct 2022 18:44:51 +0100,
>>> > > On Thu, Oct 27, 2022, Marc Zyngier wrote:
>>> > > > On Tue, 25 Oct 2022 18:47:12 +0100, Sean Christopherson <seanjc@google.com> wrote:

[...]

>>>
>>> It's really a 'major surgery' and I would like to make sure I fully understand
>>> 'a completely separate API for writing guest memory without an associated vCPU",
>>> before I'm going to working on v7 for this.
>>>
>>> There are 7 functions and 2 macros involved as below. I assume Sean is suggesting
>>> to add another argument, whose name can be 'has_vcpu', for these functions and macros?
>>
>> No.
>>
>> As March suggested, for your series just implement the hacky arch opt-out, don't
> 
> Please call me April.
> 
>> try and do surgery at this time as that's likely going to be a
>> months-long effort
>> that touches a lot of cross-arch code.
>>
>> E.g. I believe the ARM opt-out (opt-in?) for the above hack would be
>>
>> bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
>> {
>>     return vgic_has_its(kvm);
>> }
> 
> Although that will probably lead to the expected effect,
> this helper should only return true when the ITS is actively
> dumped.
> 

Thanks, Marc. It makes sense to return true only when vgic/its tables
are being saved. Lets have more discussion in PATCH[v7 5/9] since Oliver
has other concerns there :)

Thanks,
Gavin


