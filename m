From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC 0/8] Provide the EL1 physical timer to the VM
Date: Tue, 17 Jan 2017 12:15:24 -0500
Message-ID: <CAHyh4xiWxE_EE=ysdOAf_--p_ZZVLDSy+QcD8qY_G7xr3n0HVw@mail.gmail.com>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
 <b15297e4-1b30-27f8-dd43-fb1a85bd2cd5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0217D4044D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 12:13:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id psc0eqrPduVY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 12:13:35 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45437400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 12:13:34 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0HHATvk035490
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 12:15:27 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 6E5CD81
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 12:15:27 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 15BF981
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 12:15:27 -0500 (EST)
Received: from mail-oi0-f69.google.com (mail-oi0-f69.google.com
 [209.85.218.69])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0HHFQrH051300
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 12:15:26 -0500
Received: by mail-oi0-f69.google.com with SMTP id a194so209808900oib.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 09:15:26 -0800 (PST)
Received: from mail-ot0-f182.google.com (mail-ot0-f182.google.com.
 [74.125.82.182])
 by smtp.gmail.com with ESMTPSA id m33sm12816528otd.11.2017.01.17.09.15.25
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 17 Jan 2017 09:15:25 -0800 (PST)
Received: by mail-ot0-f182.google.com with SMTP id 65so67052119otq.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 09:15:25 -0800 (PST)
In-Reply-To: <b15297e4-1b30-27f8-dd43-fb1a85bd2cd5@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 17, 2017 at 12:09 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 26/12/16 17:11, Jintack Lim wrote:
>> The ARM architecture defines the EL1 physical timer and the virtual
>> timer, and it is reasonable for an OS to expect to be able to access
>> both.  However, the current KVM implementation does not provide the EL1
>> physical timer to VMs but terminates VMs on access to the timer.
>>
>> On VHE systems, this would be as simple as allowing full access to the
>> EL1 physical timer to VMs because the KVM host does not use the EL1
>> physical timer.  However, on non-VHE systems, the KVM host already uses
>> the EL1 physical timer which prevents us from granting full access of
>> the EL1 physical timer to VMs.
>>
>> This patchset enables VMs to use the EL1 physical timer through
>> trap-and-emulate.  The KVM host emulates each EL1 physical timer
>> register access and sets up the background timer accordingly.  When the
>> background timer expires, the KVM host injects EL1 physical timer
>> interrupts to the VM.  Alternatively, it's also possible to allow VMs to
>> access the EL1 physical timer without trapping.  However, this requires
>> somehow using the EL2 physical timer for the Linux host while running
>> the VM instead of the EL1 physical timer.  Right now I just implemented
>> trap-and-emulate because this was straightforward to do, and I leave it
>> to future work to determine if transferring the EL1 physical timer state
>> to the EL2 timer provides any performance benefit.
>>
>> This feature will be useful for any OS that wishes to access the EL1
>> physical timer. Nested virtualization is one of those use cases. A
>> nested hypervisor running inside a VM would think it has full access to
>> the hardware and naturally tries to use the EL1 physical timer as Linux
>> would do. Other nested hypervisors may try to use the EL2 physical timer
>> as Xen would do, but supporting the EL2 physical timer to the VM is out
>> of scope of this patchset. This patchset will make it easy to add the
>> EL2 timer support in the future, though.
>>
>> Note, Linux VMs booting in EL1 will be unaffected by this patch set and
>> will continue to use only the virtual timer and this patch set will
>> therefore not introduce any performance degredation as a result of
>> trap-and-emulate.
>
> Hi Jintack,
>
> Any chance you could address Christoffer's comments and respin this
> series? This looks like a good enhancement to our emulation, and
> definitely a requirement for the nested work, so I'm obviously keen on it.

Hi Marc,

Yes, I plan to respin this patch series this week.

Thanks,
Jintack

>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
