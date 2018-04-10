From: James Morse <james.morse@arm.com>
Subject: Re: Compiling KVM/ARM as a separate kernel module.
Date: Tue, 10 Apr 2018 10:48:51 +0100
Message-ID: <3503fcbb-5e80-0421-ec46-8f765c195243@arm.com>
References: <CAE3G1Z_HJqkWeGEESTVg+5yarWND7KR-QLOL1sRu_ey-xGZdKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67DA949FD3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 05:43:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c2OFCpekcinw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Apr 2018 05:42:56 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D0D49FD2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 05:42:56 -0400 (EDT)
In-Reply-To: <CAE3G1Z_HJqkWeGEESTVg+5yarWND7KR-QLOL1sRu_ey-xGZdKw@mail.gmail.com>
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
To: Mike Bazov <mike@perception-point.io>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mike,

On 10/04/18 09:23, Mike Bazov wrote:
> I'm trying to compile the KVM/ARM as a separate kernel module, just like
> the x86 modules. When i compile the x86 modules, i get the "kvm.ko" and
> "kvm-intel.ko" as an output. Is there any way of compiling the KVM/ARM as
> modules as well?

Not today. KVM has to map its code to run in a different CPU mode, the code that
does this assumes its physically contiguous and part of the kernel text.


> There is also no option for specifying "M" (modular) in the menuconfig when
> choosing the virtualization and KVM option, like in x86.

No, because its not supported. On arm/arm64 KVM is either built as part of the
kernel, or not.

Why do you need KVM as a loadable module?


Thanks,

James
