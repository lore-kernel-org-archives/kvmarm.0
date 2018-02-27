From: bthakur@codeaurora.org
Subject: Re: VCPU hotplug on KVM/ARM
Date: Tue, 27 Feb 2018 17:34:28 +0530
Message-ID: <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
 <20180227104708.GA11391@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E2540257
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:57:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id anE79hWLht2h for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:57:37 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EC224017F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:57:37 -0500 (EST)
In-Reply-To: <20180227104708.GA11391@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@cs.columbia.edu>
Cc: Christoffer Dall <christofferdall@christofferdall.dk>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

Thanks for your reply.

On 2018-02-27 16:17, Christoffer Dall wrote:
> Hi Bhupinder,
> 
> On Tue, Feb 27, 2018 at 03:01:17PM +0530, bthakur@codeaurora.org wrote:
>> I hope it is the right forum to post my query.
>> 
>> 
>> 
>> I am currently looking at the possibility of adding a new VCPU to a 
>> running
>> guest VM in KVM/ARM. I see that currently, it is not allowed to add a 
>> new
>> VCPU to a guest VM, if it is already initialized. The first check in
>> kvm_arch_vcpu_create() returns failure if it is already initialized.
>> 
> 
> This would require a major rework of a lot of logic surrounding the GIC
> and other parts of KVM initialization.
> 
>> 
>> 
>> There was some work done in QEMU to add support for VCPU hotplug:
>> https://lists.gnu.org/archive/html/qemu-arm/2017-05/msg00404.html
>> 
>> 
>> 
>> But I am looking at the KVM side for enabling adding a new VCPU. If 
>> you can
>> point me to any relevant work/resources, which I can refer to then it 
>> will
>> help me.
>> 
> 
> I don't have any specific pointers, but I was always told that the way
> we were going to do CPU hotplug would be to instantiate a large number
> of VCPUs, and hotplug would be equivalent to turning on a VCPU which 
> was
> previously powered off.
> 
> Is this not still a feasible solution?
It should be a feasible solution provided the guest VM is not able to 
control the onlining/offlining of VCPUs. It should be controlled by the 
Host.

> 
> How does VCPU hotplug work on x86?
On x86, you can add a vcpu through libvirt setvcpu command and it shows 
up in the guest VM as a new CPU if you do lscpu.

> 
> Thanks,
> -Christoffer

Regards,
Bhupinder
