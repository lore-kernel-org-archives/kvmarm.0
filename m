Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF3EC28D13
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 03:09:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3E544D0F4;
	Mon, 22 Aug 2022 23:09:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HG6067brUXM8; Mon, 22 Aug 2022 23:09:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 539A04D0F9;
	Mon, 22 Aug 2022 23:09:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71B614D0F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 23:09:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N2i4MO41Ubgd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 23:09:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18C2E4D0F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 23:09:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661224184;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PdyIPdKorQDXK1tldjSfL+LVZR0k6xko4u2KPDklhbE=;
 b=QwydER2+2JyOgIfJY7YFq8Feb7hIiPnKTn5a6U8cX7305qTaILwMmOvZgDiVOlw3HTTWrz
 B9TUPRTk5yRhpkIWJ5Mm+VrrK5GRR0EFxVs2tL6BAaSmGP7p6U77VSuHf7U2nAAA7jnDP6
 xId6xZ0XPrPe7TgLJsnHjy8jciHKXMM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-d3zYu98qMW-lWG9QS1UrQg-1; Mon, 22 Aug 2022 23:09:42 -0400
X-MC-Unique: d3zYu98qMW-lWG9QS1UrQg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EADE185A79C;
 Tue, 23 Aug 2022 03:09:41 +0000 (UTC)
Received: from [10.64.54.16] (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E92E492C3B;
 Tue, 23 Aug 2022 03:09:32 +0000 (UTC)
Subject: Re: [PATCH v1 3/5] KVM: selftests: Dirty host pages in dirty_log_test
From: Gavin Shan <gshan@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-4-gshan@redhat.com>
 <20220819052805.qnhw2d3arxixzvhl@kamzik>
 <3abb690f-e616-630f-ba40-e590ec8bb5c1@redhat.com>
Message-ID: <0496fe72-e3da-9778-b307-eb5cc157e8fe@redhat.com>
Date: Tue, 23 Aug 2022 13:09:28 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <3abb690f-e616-630f-ba40-e590ec8bb5c1@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, maz@kernel.org,
 shan.gavin@gmail.com, drjones@redhat.com, will@kernel.org, zhenyzha@redhat.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com
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

Hi Drew,

On 8/22/22 4:29 PM, Gavin Shan wrote:
> On 8/19/22 3:28 PM, Andrew Jones wrote:
>> On Fri, Aug 19, 2022 at 08:55:59AM +0800, Gavin Shan wrote:
>>> It's assumed that 1024 host pages, instead of guest pages, are dirtied
>>> in each iteration in guest_code(). The current implementation misses
>>> the case of mismatched page sizes in host and guest. For example,
>>> ARM64 could have 64KB page size in guest, but 4KB page size in host.
>>> (TEST_PAGES_PER_LOOP / 16), instead of TEST_PAGES_PER_LOOP, host pages
>>> are dirtied in every iteration.
>>>
>>> Fix the issue by touching all sub-pages when we have mismatched
>>> page sizes in host and guest.
>>
>> I'll let the dirty-log test authors decide what's best to do for this
>> test, but I'd think we should let the guest continue dirtying its
>> pages without knowledge of the host pages. Then, adjust the host test
>> code to assert all sub-pages, other than the ones it expects the guest
>> to have written, remain untouched.
>>
> 
> I don't think what is clarified in the change log is correct. The current
> implementation already had the logic to handle the mismatched page sizes
> in vm_dirty_log_verify() where 'step' is used for it by fetching value
> from vm_num_host_pages(mode, 1). Please ignore this patch for now, as
> explained below.
> 
> The issue I have is the 'dirty_log_test' hangs when I have 4KB host page size
> and 64KB guest page size. It seems the vcpu doesn't exit due to full ring
> buffer state or kick-off. I will have more investigations to figure out the
> root cause.
> 

[...]

Please ignore this PATCH[3/5], I think this should be fixed by selecting
correct dirty ring count and the fix will be folded to PATCH[5/5] in next
revision.

In dirty_log_test, we have 1GB memory for guest to write and make them
dirty. When we have mismatch page sizes on host and guest, which is either
4kb-host-64kb-guest or 64kb-host-4kb-guest apart from 16kb case, 16384 host
pages are dirtied in each iteration. The default dirty ring count is 65536.
So the vcpu never exit due to full-dirty-ring-buffer state. This leads the
guest's code keep running and the dirty log isn't collected by the main
thread.

     #define TEST_DIRTY_RING_COUNT           65536

     dirty_pages_per_iteration = (0x40000000 / 0x10000)
                               = 0x4000
                               = 16384

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
