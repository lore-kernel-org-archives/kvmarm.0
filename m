From: David Hildenbrand <david@redhat.com>
Subject: Re: [Qemu-devel] VCPU hotplug on KVM/ARM
Date: Tue, 31 Jul 2018 12:57:06 +0200
Message-ID: <577ab1f4-e644-8106-b380-14b8532989ee@redhat.com>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
 <20180227104708.GA11391@cbox>
 <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
 <20180227124604.GA2373@cbox>
 <20180227132131.fipafmnb56a7fj76@kamzik.brq.redhat.com>
 <b589d714-4f12-e450-7ca5-e55fed4d1705@oracle.com>
 <74427c65-b860-d576-04f9-766253285210@arm.com>
 <20180725122806.g2gpvdbrbdkriprg@kamzik.brq.redhat.com>
 <202a2c63-1a3e-7f01-850c-4fb5e48f43e7@arm.com>
 <20180731122710.142a97c4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32107408AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jul 2018 06:57:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6x9jYldYh070 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jul 2018 06:57:17 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1894140217
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jul 2018 06:57:17 -0400 (EDT)
In-Reply-To: <20180731122710.142a97c4@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Igor Mammedov <imammedo@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <cdall@kernel.org>, cohuck@redhat.com, qemu-devel@nongnu.org, borntraeger@de.ibm.com, Christoffer Dall <christofferdall@christofferdall.dk>, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, David Gibson <david@gibson.dropbear.id.au>
List-Id: kvmarm@lists.cs.columbia.edu

On 31.07.2018 12:27, Igor Mammedov wrote:
> On Wed, 25 Jul 2018 14:07:12 +0100
> Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
>> On 25/07/18 13:28, Andrew Jones wrote:
>>> On Wed, Jul 25, 2018 at 11:40:54AM +0100, Marc Zyngier wrote:  
>>>> On 24/07/18 19:35, Maran Wilson wrote:  
>>>>> It's been a few months since this email thread died off. Has anyone 
>>>>> started working on a potential solution that would allow VCPU hotplug on 
>>>>> KVM/ARM ? Or is this a project that is still waiting for an owner who 
>>>>> has the time and inclination to get started?  
>>>>
>>>> This is typically a project for someone who would have this particular
>>>> itch to scratch, and who has a demonstrable need for this functionality.
>>>>
>>>> Work wise, it would have to include adding physical CPU hotplug support
>>>> to the arm64 kernel as a precondition, before worrying about doing it in
>>>> KVM.
>>>>
>>>> For KVM itself, particular area of interests would be:
>>>> - Making GICv3 redistributors magically appear in the IPA space
>>>> - Live resizing of GICv3 structures
>>>> - Dynamic allocation of MPIDR, and mapping with vcpu_id  
>>>
>>> I have CPU topology description patches on the QEMU list now[*]. A next
>>> step for me is to this MPIDR work. I probably won't get to it until the
>>> end of August though.
>>>
>>> [*] http://lists.nongnu.org/archive/html/qemu-devel/2018-07/msg01168.html
>>>   
>>>>
>>>> This should keep someone busy for a good couple of weeks (give or take a
>>>> few months).  
>>>
>>> :-)
>>>   
>>>>
>>>> That being said, I'd rather see support in QEMU first, creating all the
>>>> vcpu/redistributors upfront, and signalling the hotplug event via the
>>>> virtual firmware. And then post some numbers to show that creating all
>>>> the vcpus upfront is not acceptable.  
>>>
>>> I think the upfront allocation, allocating all possible cpus, but only
>>> activating all present cpus, was the planned approach. What were the
>>> concerns about that approach? Just vcpu memory overhead for too many
>>> overly ambitious VM configs?  
>>
>> I don't have any ARM-specific concern about that, and I think this is
>> the right approach. It has the good property of not requiring much
>> change in the kernel (other than actually supporting CPU hotplug).
> for x86 we allocate VCPUs dynamically (both QEMU and KVM)
> CCing ppc/s390 folks as I don't recall how it's implemented there.

s390x: also handled that way. Dynamically allocated.

Unplug: not supported by the architecture and fenced.

I remember a discussion where people said dynamically creating/deleting
VCPUs (and therefore threads) is preferred, because then there is no way
on earth a malicious guest could make use of such a CPU (in case there
would be a subtle BUG in QEMU).

-- 

Thanks,

David / dhildenb
