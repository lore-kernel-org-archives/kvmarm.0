From: Eric Auger <eric.auger@linaro.org>
Subject: Re: PCIe passthrough support on ARM
Date: Thu, 4 Feb 2016 18:30:34 +0100
Message-ID: <56B38ABA.3090403@linaro.org>
References: <20160204165355.GA10442@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF3D48532
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 12:25:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UxeZfNY4V2jb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 12:25:28 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7CAE48531
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 12:25:27 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id 128so37702048wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2016 09:30:57 -0800 (PST)
Received: from [192.168.2.12] (LMontsouris-657-1-37-90.w80-11.abo.wanadoo.fr.
 [80.11.198.90])
 by smtp.googlemail.com with ESMTPSA id gt7sm12287800wjc.1.2016.02.04.09.30.54
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLSv1/SSLv3 cipher=OTHER);
 Thu, 04 Feb 2016 09:30:54 -0800 (PST)
In-Reply-To: <20160204165355.GA10442@codethink.co.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Edward,
On 02/04/2016 05:53 PM, Edward Cragg wrote:
> Hi,
> 
> I'm involved in planning a project for which there is a requirement for PCIe
> passthrough in KVM on ARMv8. We have no hardware to test on at the moment.
> 
> I understand that virtualisation support for ARM is quite young, and it seems
> like support is trickling in at the moment for this sort of thing.
> 
> Is anyone working on PCIe passthrough on ARM platforms who might be able to
> share some insight into what would be required to support this?
Yes I am currently working on this topic at the moment and especially on
ARM PCIe passthrough with MSI enabled. I did not test PCIe passthrough
with legacy INTx (MSI disabled) but this should work already with
upstreamed QEMU and kernel.

With MSI enabled, the code is not upstreamed yet.

I have a QEMU series:

[RFC v2 0/8] KVM PCI/MSI passthrough with mach-virt
(https://www.mail-archive.com/qemu-devel@nongnu.org/msg349574.html)

and a kernel series:
[PATCH 00/10] KVM PCIe/MSI passthrough on ARM/ARM64"
  (https://lkml.org/lkml/2016/1/26/371)

This is functional, tested on v8 AMD HW with a GICv2M (single MSI frame).

This is in an early stage, especially on kernel side since lots of
issues still need to be addressed, especially handling proper IRQ isolation.

What kind of MSI controller do you plan to use?

Hope this helps

Best Regards

Eric

> 
> Thanks,
> 
> Ed
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
