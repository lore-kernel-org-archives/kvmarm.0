Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E639CC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 10 Oct 2022 23:58:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0FA4B62D;
	Mon, 10 Oct 2022 19:58:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 09rm24CZO44M; Mon, 10 Oct 2022 19:58:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 079744B27C;
	Mon, 10 Oct 2022 19:58:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75ED54B285
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 19:58:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q-ITDiv4uXfC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 19:58:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6557410F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 19:58:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665446307;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JIsDIJXslnCkYxiomdkb+PtqaJT0FSBWfC7isRuL0W8=;
 b=MiLF7D225CIFXwuCcaufqG2HJ1KKiT210h66FBNceQij69JSdt9clTr+NObwx++kRjK2L7
 eK++tTHpfKByX+vkE1CKahRjyIKRNhpFVR/JvPiQAqiZKBjhwq0nPzZcIb9H8+y/7xZfvt
 D/xvDsGdUQkcT7srv22cHpbJD5zoLRg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-Gb6UDjdxMZ2xvAo8V4yZBw-1; Mon, 10 Oct 2022 19:58:22 -0400
X-MC-Unique: Gb6UDjdxMZ2xvAo8V4yZBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4403C80280D;
 Mon, 10 Oct 2022 23:58:21 +0000 (UTC)
Received: from [10.64.54.52] (vpn2-54-52.bne.redhat.com [10.64.54.52])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CC56404CD91;
 Mon, 10 Oct 2022 23:58:14 +0000 (UTC)
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
To: Peter Xu <peterx@redhat.com>, Oliver Upton <oliver.upton@linux.dev>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com> <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com> <Y0SvexjbHN78XVcq@xz-m1.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ec0e7a97-3a4a-3fbc-6cf4-5de24ec09378@redhat.com>
Date: Tue, 11 Oct 2022 07:58:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y0SvexjbHN78XVcq@xz-m1.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Peter and Oliver,

On 10/11/22 7:49 AM, Peter Xu wrote:
> On Mon, Oct 10, 2022 at 11:18:55PM +0000, Oliver Upton wrote:
>> On Fri, Oct 07, 2022 at 10:31:49AM -0400, Peter Xu wrote:
>>
>> [...]
>>
>>>> - In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
>>>>    true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL
>>>
>>> What I wanted to do is to decouple the ACQ_REL with ALLOW_BITMAP, so mostly
>>> as what you suggested, except..
>>
>> +1
>>

Agreed.

[...]

>>
>>> Then if the userspace wants to use the bitmap altogether with the ring, it
>>> needs to first detect KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP and enable it
>>> before it enables KVM_CAP_DIRTY_LOG_RING.
>>>
>>> One trick on ALLOW_BITMAP is in mark_page_dirty_in_slot() - after we allow
>>> !vcpu case we'll need to make sure it won't accidentally try to set bitmap
>>> for !ALLOW_BITMAP, because in that case the bitmap pointer is NULL so
>>> set_bit_le() will directly crash the kernel.
>>>
>>> We could keep the old flavor of having a WARN_ON_ONCE(!vcpu &&
>>> !ALLOW_BITMAP) then return, but since now the userspace can easily trigger
>>> this (e.g. on ARM, a malicious userapp can have DIRTY_RING &&
>>> !ALLOW_BITMAP, then it can simply trigger the gic ioctl to trigger host
>>> warning), I think the better approach is we can kill the process in that
>>> case.  Not sure whether there's anything better we can do.
>>
>> I don't believe !ALLOW_BITMAP && DIRTY_RING is a valid configuration for
>> arm64 given the fact that we'll dirty memory outside of a vCPU context.
> 
> Yes it's not, but after Gavin's current series it'll be possible, IOW a
> malicious app can leverage this to trigger host warning, which is IMHO not
> wanted.
> 
>>
>> Could ALLOW_BITMAP be a requirement of DIRTY_RING, thereby making
>> userspace fail fast? Otherwise (at least on arm64) your VM is DOA on the
>> target. With that the old WARN() could be preserved, as you suggest.
> 
> It's just that x86 doesn't need the bitmap, so it'll be a pure waste there
> otherwise.  It's not only about the memory that will be wasted (that's
> guest mem size / 32k), but also the sync() process for x86 will be all
> zeros and totally meaningless - note that the sync() of bitmap will be part
> of VM downtime in this case (we need to sync() after turning VM off), so it
> will make x86 downtime larger but without any benefit.
> 

Besides, old QEMU won't work if ALLOW_BITMAP is required to enable DIRTY_RING,
if I'm correct.

>> On
>> top of that there would no longer be a need to test for memslot creation
>> when userspace attempts to enable KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP.
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
