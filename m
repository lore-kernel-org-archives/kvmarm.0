From: Christoffer Dall <cdall@cs.columbia.edu>
Subject: Re: VCPU hotplug on KVM/ARM
Date: Tue, 27 Feb 2018 11:47:08 +0100
Message-ID: <20180227104708.GA11391@cbox>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EE0F402C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 05:40:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uriKG6lTG9oR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 05:40:18 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4CB6402B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 05:40:18 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id w128so17181445wmw.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 02:47:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: bthakur@codeaurora.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Bhupinder,

On Tue, Feb 27, 2018 at 03:01:17PM +0530, bthakur@codeaurora.org wrote:
> I hope it is the right forum to post my query.
> 
>  
> 
> I am currently looking at the possibility of adding a new VCPU to a running
> guest VM in KVM/ARM. I see that currently, it is not allowed to add a new
> VCPU to a guest VM, if it is already initialized. The first check in
> kvm_arch_vcpu_create() returns failure if it is already initialized.
> 

This would require a major rework of a lot of logic surrounding the GIC
and other parts of KVM initialization.

>  
> 
> There was some work done in QEMU to add support for VCPU hotplug:
> https://lists.gnu.org/archive/html/qemu-arm/2017-05/msg00404.html
> 
>  
> 
> But I am looking at the KVM side for enabling adding a new VCPU. If you can
> point me to any relevant work/resources, which I can refer to then it will
> help me.
> 

I don't have any specific pointers, but I was always told that the way
we were going to do CPU hotplug would be to instantiate a large number
of VCPUs, and hotplug would be equivalent to turning on a VCPU which was
previously powered off.

Is this not still a feasible solution?

How does VCPU hotplug work on x86?

Thanks,
-Christoffer
