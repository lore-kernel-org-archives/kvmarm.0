Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CD91FA8
	for <kvmarm@lists.linux.dev>; Sat, 30 Sep 2023 13:35:02 +0000 (UTC)
Received: from [192.168.2.47] (109-252-153-31.dynamic.spd-mgts.ru [109.252.153.31])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: dmitry.osipenko)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id E6BE46607295;
	Sat, 30 Sep 2023 14:34:59 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1696080900;
	bh=0PxsPvfhCxmuM8OOhVgn6qAqAky1OTiS500Dk0oUnj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NnJO2sB5C/86P2N1XLfIArFDbs/Wsi5YJZMvJG2bjYx+4nIsfc4XaeQvwjBZHcq2L
	 0IEskSh8jnMUO/bMBAbDeTJCwCBpedvgfrQyA+xM8Rlvl6/38dqCQp7qWKFU6iQVgZ
	 JTJHcRqBQOZS/GSJL2N014ZqmwdX5VT6DR0vVufQC2YVH9jVIH7SfpiHGxqgrkEjMV
	 yg472WlCqYmatismPMGmEHWDyrk4QcDOsc4HhY4FZTV8k69woEeBJqUeuottXbCX0S
	 bBNSYm1iV1iyQ411HF/JXpDYfupBBfDBPQfgQgDjOQ40SpJldtTmo++l73VH7R6zPk
	 pLjh+yGdNi6WQ==
Message-ID: <9771886a-d60d-b273-9f0c-ba663acb1db8@collabora.com>
Date: Sat, 30 Sep 2023 16:34:57 +0300
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
Content-Language: en-US
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <d272613e-aed9-4cbc-26dd-78bc8fca2650@collabora.com>
 <20230919022504.3153043-1-stevensd@chromium.org>
From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <20230919022504.3153043-1-stevensd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/19/23 05:25, David Stevens wrote:
> On Mon, Sep 18, 2023 at 6:53 PM Dmitry Osipenko <dmitry.osipenko@collabora.com> wrote:
>>
>> On 9/11/23 05:16, David Stevens wrote:
>>> --- a/arch/x86/kvm/mmu/paging_tmpl.h
>>> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
>>> @@ -848,7 +848,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>>>  
>>>  out_unlock:
>>>       write_unlock(&vcpu->kvm->mmu_lock);
>>> -     kvm_release_pfn_clean(fault->pfn);
>>> +     if (fault->is_refcounted_page)
>>> +             kvm_set_page_accessed(pfn_to_page(fault->pfn));
>>
>> The other similar occurrences in the code that replaced
>> kvm_release_pfn_clean() with kvm_set_page_accessed() did it under the
>> held mmu_lock.
>>
>> Does kvm_set_page_accessed() needs to be invoked under the lock?
> 
> It looks like I made a mistake when folding the v8->v9 delta into the stack of
> patches to get a clean v9 series. v8 of the series returned pfns without
> reference counts from __kvm_follow_pfn, so the x86 MMU needed to mark the pages
> as accessed under the lock. v9 instead returns pfns with a refcount (i.e. does
> the same thing as __gfn_to_pfn_memslot), so the x86 MMU should instead call
> kvm_release_page_clean outside of the lock. I've included the corrected version
> of this patch in this email.
[snip]

I tested this series + the corrected version of the patch on Intel TGL using virgl/venus/virtio-intel on both qemu and crosvm on top of the recent linux-next. All is working good. Feel free to add my t-b to the v10:

Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com> # virgl+venus+virtio-intel+i915

-- 
Best regards,
Dmitry

