Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2286BC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 06:32:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 803F46103D
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 06:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 803F46103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E924A4B101;
	Thu, 23 Sep 2021 02:32:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QOOBqS7B6gU1; Thu, 23 Sep 2021 02:32:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A78B14B139;
	Thu, 23 Sep 2021 02:32:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D024F4B101
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 02:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BJhU-n08hawn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 02:32:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F674A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 02:32:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632378762;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wer52oLwmCEPNBpGXyNvVz16UMTo82CYLIugW7yIubM=;
 b=Xs5eUQAOAvpAMEiwP5Ek0XyLtEfFTHPa/i4wOotZVe4cTn754pNoVmUDgL961c4snZw9qi
 f3DE43SeERo+VS8rENMXIhwJsVW8EiqRZnZE4p4GPO6ePjHyD9UlDDvMzrCQDHfs1dW4s1
 TLyD/IropwLz5CpOgCI4uBjtvzoK70E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-BmEi1nl_N_yJzfc01GfzhQ-1; Thu, 23 Sep 2021 02:32:40 -0400
X-MC-Unique: BmEi1nl_N_yJzfc01GfzhQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E57CB801B3D;
 Thu, 23 Sep 2021 06:32:38 +0000 (UTC)
Received: from [10.64.54.113] (vpn2-54-113.bne.redhat.com [10.64.54.113])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B54E86CA20;
 Thu, 23 Sep 2021 06:32:32 +0000 (UTC)
Subject: Re: [PATCH] Documentation, dt, numa: Add note to empty NUMA node
To: Ard Biesheuvel <ardb@kernel.org>, Rob Herring <robh@kernel.org>
References: <20210906041424.115473-1-gshan@redhat.com>
 <CAL_JsqLccwTEhzonvdOOox+D6=3gHxbDbtsXTJpqtQfuxA4xvg@mail.gmail.com>
 <CAMj1kXFgnbuQzqf4rnpzn+Ez-sL3859q=1z_PkE1Mgd3SL19rA@mail.gmail.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <197ced59-49b0-a981-6e04-96405164daba@redhat.com>
Date: Thu, 23 Sep 2021 16:32:29 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXFgnbuQzqf4rnpzn+Ez-sL3859q=1z_PkE1Mgd3SL19rA@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 shan.gavin@gmail.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

Hi Rob and Ard,

On 9/22/21 9:05 PM, Ard Biesheuvel wrote:
> On Tue, 21 Sept 2021 at 21:45, Rob Herring <robh@kernel.org> wrote:
>> On Sun, Sep 5, 2021 at 11:16 PM Gavin Shan <gshan@redhat.com> wrote:
>>>
>>> The empty memory nodes, where no memory resides in, are allowed.
>>> For these empty memory nodes, the 'len' of 'reg' property is zero.
>>> The NUMA node IDs are still valid and parsed, but memory may be
>>> added to them through hotplug afterwards. Currently, QEMU fails
>>> to boot when multiple empty memory nodes are specified. It's
>>> caused by device-tree population failure and duplicated memory
>>> node names.
> 
> Those memory regions are known in advance, right? So wouldn't it be
> better to use something like 'status = "disabled"' here?
> 

Yes, these memory regions are known in advance. For the empty nodes,
their 'len' property is zero and it's equal to disabled state.

>>
>> I still don't like the fake addresses. I can't really give suggestions
>> on alternative ways to fix this with you just presenting a solution.
>>
> 
> Agreed. Please try to explain what the problem is, and why this is the
> best way to solve it. Please include other solutions that were
> considered and rejected if any exist.
> 
>> What is the failure you see? Can we relax the kernel's expectations?
>> What about UEFI boot as the memory nodes aren't used (or maybe they
>> are for NUMA?) How does this work with ACPI?
>>
> 
> The EFI memory map only needs to describe the memory that was present
> at boot. More memory can be represented as ACPI objects, including
> coldplugged memory that is already present at boot. None of this
> involves the memory nodes in DT.
> 

I'm using the following command line to start a virtual machine (VM).
There are 4 NUMA nodes specified, but the last two are empty. In QEMU,
the device-tree nodes are populated to represent these 4 NUMA nodes.
Unfortunately, QEMU fails to start because of the conflicting names
for the empty node are found, as the following error message indicates.

    /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64        \
    -accel kvm -machine virt,gic-version=host                      \
    -cpu host -smp 4,sockets=2,cores=2,threads=1                   \
    -m 1024M,slots=16,maxmem=64G                                   \
    -object memory-backend-ram,id=mem0,size=512M                   \
    -object memory-backend-ram,id=mem1,size=512M                   \
    -numa node,nodeid=0,cpus=0-1,memdev=mem0                       \
    -numa node,nodeid=1,cpus=2-3,memdev=mem1                       \
    -numa node,nodeid=2                                            \
    -numa node,nodeid=3                                            \
      :
    -device virtio-balloon-pci,id=balloon0,free-page-reporting=yes
      :
      :
    qemu-system-aarch64: FDT: Failed to create subnode /memory@80000000: FDT_ERR_EXISTS

According to device-tree specification, the memory device-tree node's
name is following the format 'memory@base-address'. For the empty
NUMA nodes, their base addresses aren't determined. The device-tree
specification doesn't indicate what 'base-address' should be assigned
for the empty nodes. So I proposed this patch because I think the
linux device-tree binding documentation is best place to get this
documented.

ACPI is different story. The NUMA nodes are represented by SRAT
(System Resource Affinity Table). In the above example, there are
4 SRATs. We needn't assign names to the tables and we don't have
the conflicting names as we do in device-tree case.

By the way, QEMU currently prevents to expose SRATs for empty NUMA
nodes. I need submit QEMU patch to break the limitation in future.
With the limitation, the hot-added memory is always put into the
last NUMA node and it's not exactly customer wants.


>>> As device-tree specification indicates, the 'unit-address' of
>>> these empty memory nodes, part of their names, are the equivalents
>>> to 'base-address'. Unfortunately, I finds difficulty to get where
>>> the assignment of 'base-address' is properly documented for these
>>> empty memory nodes. So lets add a section for empty memory nodes
>>> to cover this in NUMA binding document. The 'unit-address',
>>> equivalent to 'base-address' in the 'reg' property of these empty
>>> memory nodes is specified to be the summation of highest memory
>>> address plus the NUMA node ID.
>>>
>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>> Acked-by: Randy Dunlap <rdunlap@infradead.org>
>>> ---
>>>   Documentation/devicetree/bindings/numa.txt | 60 +++++++++++++++++++++-
>>>   1 file changed, 59 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/numa.txt b/Documentation/devicetree/bindings/numa.txt
>>> index 21b35053ca5a..82f047bc8dd6 100644
>>> --- a/Documentation/devicetree/bindings/numa.txt
>>> +++ b/Documentation/devicetree/bindings/numa.txt
>>> @@ -103,7 +103,65 @@ Example:
>>>                  };
>>>
>>>   ==============================================================================
>>> -4 - Example dts
>>> +4 - Empty memory nodes
>>> +==============================================================================
>>> +
>>> +Empty memory nodes, which no memory resides in, are allowed. The 'length'
>>> +field of the 'reg' property is zero. However, the 'base-address' is a
>>> +dummy and invalid address, which is the summation of highest memory address
>>> +plus the NUMA node ID. The NUMA node IDs and distance maps are still valid
>>> +and memory may be added into them through hotplug afterwards.
>>> +
>>> +Example:
>>> +
>>> +       memory@0 {
>>> +               device_type = "memory";
>>> +               reg = <0x0 0x0 0x0 0x80000000>;
>>> +               numa-node-id = <0>;
>>> +       };
>>> +
>>> +       memory@80000000 {
>>> +               device_type = "memory";
>>> +               reg = <0x0 0x80000000 0x0 0x80000000>;
>>> +               numa-node-id = <1>;
>>> +       };
>>> +
>>> +       /* Empty memory node */
>>> +       memory@100000002 {
>>> +               device_type = "memory";
>>> +               reg = <0x1 0x2 0x0 0x0>;
>>> +               numa-node-id = <2>;
>>> +       };
>>> +
>>> +       /* Empty memory node */
>>> +       memory@100000003 {
>>> +               device_type = "memory";
>>> +               reg = <0x1 0x3 0x0 0x0>;
>>> +               numa-node-id = <3>;
>>> +       };
>>
>> Do you really need the memory nodes here or just some way to define
>> numa node id's 2 and 3 as valid?
>>

It's the way to define NUMA node IDs are valid. Besides, the 'reg'
property provides 'base-address', which is part of the device-tree
node's name, as described in this patch.

>>
>>> +
>>> +       distance-map {
>>> +               compatible = "numa-distance-map-v1";
>>> +               distance-matrix = <0 0  10>,
>>> +                                 <0 1  20>,
>>> +                                 <0 2  40>,
>>> +                                 <0 3  20>,
>>> +                                 <1 0  20>,
>>> +                                 <1 1  10>,
>>> +                                 <1 2  20>,
>>> +                                 <1 3  40>,
>>> +                                 <2 0  40>,
>>> +                                 <2 1  20>,
>>> +                                 <2 2  10>,
>>> +                                 <2 3  20>,
>>> +                                 <3 0  20>,
>>> +                                 <3 1  40>,
>>> +                                 <3 2  20>,
>>> +                                 <3 3  10>;
>>> +       };
>>> +
>>> +==============================================================================
>>> +5 - Example dts
>>>   ==============================================================================
>>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
