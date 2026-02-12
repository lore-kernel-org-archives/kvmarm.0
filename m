Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EB0346E64
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770897765; cv=none; b=Rhp12rTkpr3JZKDE/CA1m3Vzqd/9WS72u6MH8+MBJ8MO4GsKlTorPTMUmi6mDA4HtNNC//erFscK2cZaHg/5nJsKhpy8pCHbzF6RgsZEo+y+MfNnnXgVnRAiZdMpxXEes2u5NQQrD3odo/5K1TgmwmbxW1bvQIgIY0oi2VjJzyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770897765; c=relaxed/simple;
	bh=oKiv1mgxYCZhjF1ZCNUYvQoVr2uFvFUEnOUFfUVBhx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fNMcFkxDQFVW67Y78ueDHtNyc0YH+DwO4fziz03rgArq4oftDSfI+nKinBhE9riJsCGsVu8wQWuPjMJVzE5uVhex85vkd/gAVZT9uFUtzAEZIc9Z7HnIdiwTpsKFCsYChmmGeAwAElGs+NyIJ+ahMn/RHinxUjut0X5Tn2CIE+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=tr/A7jO+; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="tr/A7jO+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=M4H+0Tu/tjDbE6J8H2Tr2N8hxKmd9h6e4cXFQ7psSqI=;
	b=tr/A7jO+Jul3GAN576nhUp0xDhA9FFDzx8LFaQFpyldAXd73wSc4unSX9yJ8ZmoGVClIOL6P7
	7n/rR6ZHDFQRPbR5PfHhau3LI2qXND9Jml3miPk1Rs03zfzn5WOSfJAF59GB74+ZUQM2EDRcQ5W
	O8U56x2necYqqIW8BQHH6nA=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fBYhp15fMzRhVD;
	Thu, 12 Feb 2026 19:58:02 +0800 (CST)
Received: from kwepemj500003.china.huawei.com (unknown [7.202.194.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 96A312012A;
	Thu, 12 Feb 2026 20:02:40 +0800 (CST)
Received: from [100.102.28.14] (100.102.28.14) by
 kwepemj500003.china.huawei.com (7.202.194.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Feb 2026 20:02:39 +0800
Message-ID: <2b29bbc8-c588-4ce0-b249-5cc544338ec1@huawei.com>
Date: Thu, 12 Feb 2026 20:02:33 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] arm64: tlb: call kvm_call_hyp once during
 kvm_tlb_flush_vmid_range
To: Marc Zyngier <maz@kernel.org>
CC: "rananta@google.com" <rananta@google.com>, "will@kernel.org"
	<will@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, zhengchuan <zhengchuan@huawei.com>,
	Xiexiangyou <xiexiangyou@huawei.com>, "guoqixin (A)" <guoqixin2@huawei.com>,
	"Mawen (Wayne)" <wayne.ma@huawei.com>
References: <42bcdd9100bf4c63b79d2b72bd6db951@huawei.com>
 <86wm0massi.wl-maz@kernel.org>
From: "yezhenyu (A)" <yezhenyu2@huawei.com>
In-Reply-To: <86wm0massi.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj500003.china.huawei.com (7.202.194.33)

Thanks for your review.

On 2026/2/9 22:35, Marc Zyngier wrote:
> On Mon, 09 Feb 2026 13:14:07 +0000,
> "yezhenyu (A)" <yezhenyu2@huawei.com> wrote:
>>
>>  From 9982be89f55bd99b3683337223284f0011ed248e Mon Sep 17 00:00:00 2001
>> From: eillon <yezhenyu2@huawei.com>
>> Date: Mon, 9 Feb 2026 19:48:46 +0800
>> Subject: [RFC][PATCH v1] arm64: tlb: call kvm_call_hyp once during
>>   kvm_tlb_flush_vmid_range
>>
>> The kvm_tlb_flush_vmid_range() function is performance-critical
>> during live migration, but there is a while loop when the system
>> support flush tlb by range when the size is larger than MAX_TLBI_RANGE_PAGES.
>>
>> This results in frequent entry to kvm_call_hyp() and then a large
> 
> What is the cost of kvm_call_hyp()?
> 

Most cost of kvm_tlb_flush_vmid_range() is __tlb_switch_to_host(), which
is called in every __kvm_tlb_flush_vmid/__kvm_tlb_flush_vmid_range.

>> amount of time is spent in kvm_clear_dirty_log_protect() during
>> migration(more than 50%).
> 
> 50% of what time? The guest's run-time? The time spent doing TLBIs
> compared to the time spent in kvm_clear_dirty_log_protect()?
> 

kvm_clear_dirty_log_protect() cost more than 50% time during
ram_find_and_save_block(), but not every time.
I captured the flame graph during the live migration, and the
distribution of several key functions is as follows(sorry I
cannot transfer the SVG files outside my company):

     ram_find_and_save_block(): 84.01%
         memory_region_clear_dirty_bitmap(): 33.40%
             kvm_clear_dirty_log_protect(): 26.74%
                 kvm_arch_flush_remote_tlbs_range(): 9.67%
                     __tlb_switch_to_host(): 9.51%
                 kvm_arch_mmu_enable_log_dirty_pt_masked(): 9.38%
         ram_save_target_page_legacy(): 43.41%

The memory_region_clear_dirty_bitmap() cost about 40% of
ram_find_and_save_block(), and the kvm_arch_flush_remote_tlbs_range()
cost about 29% of memory_region_clear_dirty_bitmap().

And after the patch apply, the distribution of several key functions is
as follows:

     ram_find_and_save_block(): 53.84%
         memory_region_clear_dirty_bitmap(): 2.28%
             kvm_clear_dirty_log_protect(): 1.75%
                 kvm_arch_flush_remote_tlbs_range(): 0.03%
                     __tlb_switch_to_host(): 0.03%
                 kvm_arch_mmu_enable_log_dirty_pt_masked(): 0.96%
         ram_save_target_page_legacy(): 38.97%

The memory_region_clear_dirty_bitmap() cost about 4% of
ram_find_and_save_block(), and the kvm_arch_flush_remote_tlbs_range()
cost about 1% of memory_region_clear_dirty_bitmap().

>> So, when the address range is large than
>> MAX_TLBI_RANGE_PAGES, directly call __kvm_tlb_flush_vmid to
>> optimize performance.
> 
> Multiple things here:
> 
> - there is no SoB, which means that patch cannot be considered for
>    merging
> 
If there are no other issues with this patch, I can resend it with the
SoB (Signed-off-by) tag.


> - there is no data showing how this change improves the situation for
>    a large enough set of workloads
> 
> - there is no description of a test that could be run on multiple
>    implementations to check whether this change has a positive or
>    negative impact

This patch affected the migration bandwidth during the live migration.
With the same physical bandwidth, the optimization effect of this patch
can be observed by monitoring the real live migration bandwidth.

I have test this in an RDMA-like environment, the physical bandwidth is
about 100GBps; without this patch, the migration bandwidth is below 10
GBps, and after this patch apply, the migration bandwidth can reach 50
GBps.

> 
> If you want to progress this sort of things, you will need to address
> these points.
> 
> Thanks,
> 
> 	M.
> 

