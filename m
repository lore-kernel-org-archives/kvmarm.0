Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C881B552
	for <kvmarm@lists.linux.dev>; Fri, 11 Nov 2022 23:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668210226;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SL1C4N4MhlJR5mFY0fBJfzPIf2BifFdJBYUYia1GgkQ=;
	b=bYly+wsKoUuTnx0vqbaRCE5zGiO7AiMklz2WrlrxqgVuzNueUooKnn6JBuASSoC+8Gt9rI
	eRL90MTNv+YIrAJmDmxub6xYeDSHXW6hT4QjE8n96bwSIY0sW2HmVwy2C1QRt+9mytT9Lx
	qTIDtGrgUWh28bYOMpS7bHIxm7qlpnE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-FlL4DXDBPImPH3-FbfKO2Q-1; Fri, 11 Nov 2022 18:43:41 -0500
X-MC-Unique: FlL4DXDBPImPH3-FbfKO2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D6D729DD993;
	Fri, 11 Nov 2022 23:43:40 +0000 (UTC)
Received: from [10.67.24.81] (unknown [10.67.24.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B11E140EBF5;
	Fri, 11 Nov 2022 23:43:31 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with
 bitmap
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
 catalin.marinas@arm.com, andrew.jones@linux.dev, ajones@ventanamicro.com,
 bgardon@google.com, dmatlack@google.com, will@kernel.org,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, pbonzini@redhat.com,
 peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
 shan.gavin@gmail.com
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com> <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
 <Y27T+1Y8w0U6j63k@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c95c9912-0ca9-88e5-8b51-0c6826cf49b9@redhat.com>
Date: Sat, 12 Nov 2022 07:43:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y27T+1Y8w0U6j63k@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Message-ID: <20221111234328.rFqfSR1guZ1wYfpg-vRyqnuGi_NYoswN3nbY0P5TeMQ@z>

Hi Sean,

On 11/12/22 7:00 AM, Sean Christopherson wrote:
> On Sat, Nov 12, 2022, Gavin Shan wrote:
>> On 11/11/22 11:19 PM, Marc Zyngier wrote:
>>> On Thu, 10 Nov 2022 23:47:41 +0000,
>>> Gavin Shan <gshan@redhat.com> wrote:
>>> But that I don't get. Or rather, I don't get the commit message that
>>> matches this hunk. Do we want to catch the case where all of the
>>> following are true:
>>>
>>> - we don't have a vcpu,
>>> - we're allowed to log non-vcpu dirtying
>>> - we *only* have the ring?
> 
> As written, no, because the resulting WARN will be user-triggerable.  As mentioned
> earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
> logging is enabled with a bitmap, then this code can WARN.
> 

I assume you're saying to reject the command when dirty ring is enabled __without__
a bitmap. vgic/its is the upper layer of dirty dirty. To me, it's a bad idea for the
upper layer needs to worry too much about the lower layer.

>>> If so, can we please capture that in the commit message?
>>>
>>
>> Nice catch! This particular case needs to be warned explicitly. Without
>> the patch, kernel crash is triggered. With this patch applied, the error
>> or warning is dropped silently. We either check memslot->dirty_bitmap
>> in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
>> I personally the later one. Let me post a formal patch on top of your
>> 'next' branch where the commit log will be improved accordingly.
> 
> As above, a full WARN is not a viable option unless ARM commits to rejecting
> KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
> or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
> that they shot themselves in the foot after the fact seems rather pointless if
> KVM could have prevented the self-inflicted wound in the first place.
> 
> [*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
> 

Without a message printed by WARN, kernel crash or pr_warn_ratelimited(), it
will be hard for userspace to know what's going on, because the dirty bits
have been dropped silently. I think we still survive since we have WARN
message for other known cases where no running vcpu context exists.

So if I'm correct, what we need to do is to improve the commit message to
address Marc's concerns here? :)

Thanks,
Gavin


