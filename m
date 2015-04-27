From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v12 3/4] hw/arm/virt: add dynamic sysbus device support
Date: Mon, 27 Apr 2015 19:04:04 +0200
Message-ID: <553E6C04.1050805@suse.de>
References: <1429888773-11730-1-git-send-email-eric.auger@linaro.org>
 <1429888773-11730-4-git-send-email-eric.auger@linaro.org>
 <553E3C71.1040001@suse.de> <553E6ABB.1070703@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 706F84E97D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 12:57:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GiQSaL977dtf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 12:57:36 -0400 (EDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4EFA4E950
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 12:57:35 -0400 (EDT)
In-Reply-To: <553E6ABB.1070703@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>, Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/27/2015 06:58 PM, Christopher Covington wrote:
> Hi Alex,
>
> On 04/27/2015 09:41 AM, Alexander Graf wrote:
>
>>> --- a/hw/arm/virt.c
>>> +++ b/hw/arm/virt.c
>>> @@ -131,6 +138,7 @@ static const MemMapEntry a15memmap[] = {
>>>        [VIRT_FW_CFG] =     { 0x09020000, 0x0000000a },
>>>        [VIRT_MMIO] =       { 0x0a000000, 0x00000200 },
>>>        /* ...repeating for a total of NUM_VIRTIO_TRANSPORTS, each of that
>>> size */
>>> +    [VIRT_PLATFORM_BUS] =   { 0x0c000000, 0x02000000 },
>> Peter, would you have a hard time if we just get rid of VIRT_MMIO completely
>> and allow users to create the mmio-virtio bridges using -device for -M
>> virt-2.4 and above?
>>
>> At the end of the day, I'm fairly sure people will end up virtio-pci anyway
>> and it's just a big waste of address space to keep VIRT_MMIO around, no?
> I'm not sure I have an opinion one way or the other, but I would like to
> understand the "big waste" argument. Is there something that users are eager
> to reuse this address space for, like more RAM?

It will get used for platform device assignment. If we only reserve 32MB 
we will quickly run out of address space to map devices into.


Alex
