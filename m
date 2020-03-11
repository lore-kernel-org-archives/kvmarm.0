Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51A7C10F25
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 07:20:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 670002192A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 07:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 670002192A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A464A4BE;
	Wed, 11 Mar 2020 03:20:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wzHZYGQ2ucXA; Wed, 11 Mar 2020 03:20:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A327E4A4C0;
	Wed, 11 Mar 2020 03:20:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E60884A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 03:20:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a3dlOKwiEtRL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 03:20:13 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 774FF4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 03:20:13 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 1D0CEFE6F693335B3302;
 Wed, 11 Mar 2020 15:20:06 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.230) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0;
 Wed, 11 Mar 2020 15:19:55 +0800
Subject: Re: [RFC] KVM: arm64: support enabling dirty log graually in small
 chunks
To: Marc Zyngier <maz@kernel.org>
References: <20200309085727.1106-1-zhukeqian1@huawei.com>
 <4b85699ec1d354cc73f5302560231f86@misterjones.org>
 <64925c8b-af3d-beb5-bc9b-66ef1e47f92d@huawei.com>
 <a642a79ea9190542a9098e4c9dc5a9f2@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <9ddefc54-dd5b-0555-0aaa-00a3a23febcf@huawei.com>
Date: Wed, 11 Mar 2020 15:19:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <a642a79ea9190542a9098e4c9dc5a9f2@kernel.org>
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>, Jay
 Zhou <jianjay.zhou@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On 2020/3/10 21:16, Marc Zyngier wrote:
> On 2020-03-10 08:26, zhukeqian wrote:
>> Hi Marc,
>>
>> On 2020/3/9 19:45, Marc Zyngier wrote:
>>> Kegian,
> 
> [...]
> 
>>> Is there a userspace counterpart to it?
>>>
>> As this KVM/x86 related changes have not been merged to mainline
>> kernel, some little modification is needed on mainline Qemu.
> 
> Could you please point me to these changes?
I made some changes locally listed below.

However, Qemu can choose to enable KVM_DIRTY_LOG_INITIALLY_SET or not.
Here I made no judgement on dirty_log_manual_caps because I just want
to verify the optimization of this patch.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 439a4efe52..1611f644a4 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2007,14 +2007,16 @@ static int kvm_init(MachineState *ms)
     s->coalesced_pio = s->coalesced_mmio &&
                        kvm_check_extension(s, KVM_CAP_COALESCED_PIO);

-    s->manual_dirty_log_protect =
+    uint64_t dirty_log_manual_caps =
         kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
-    if (s->manual_dirty_log_protect) {
-        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
+    if (dirty_log_manual_caps) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
+                                dirty_log_manual_caps);
         if (ret) {
             warn_report("Trying to enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
                         "but failed.  Falling back to the legacy mode. ");
-            s->manual_dirty_log_protect = false;
+        } else {
+            s->manual_dirty_log_protect = true;
         }
     }

> 
>> As I tested this patch on a 128GB RAM Linux VM with no huge pages, the
>> time of enabling dirty log will decrease obviously.
> 
> I'm not sure how realistic that is. Not having huge pages tends to lead
> to pretty bad performance in general...
Sure, this has no effect on guests which are all of huge pages.

For my understanding, once a guest has normal pages (maybe are initialized
at beginning or dissloved from huge pages), it can benefit from this patch.
> 
> Thanks,
> 
>         M.
Pretty thanks for your review.

Thanks,
Keqian

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
