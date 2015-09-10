From: Julien Grall <julien.grall@citrix.com>
Subject: Re: [PATCH v4 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Thu, 10 Sep 2015 17:23:17 +0100
Message-ID: <55F1AE75.6000405@citrix.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
 <1440604845-28229-4-git-send-email-marc.zyngier@arm.com>
 <55F08731.3050402@citrix.com> <55F15353.2000800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 075E640FAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 12:23:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fghFJppLMjsG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2015 12:23:46 -0400 (EDT)
Received: from SMTP02.CITRIX.COM (smtp02.citrix.com [66.165.176.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8798040FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 12:23:46 -0400 (EDT)
In-Reply-To: <55F15353.2000800@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Ian Campbell <ian.campbell@citrix.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jiang Liu <jiang.liu@linux.intel.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/09/15 10:54, Marc Zyngier wrote:
> Hi Julian,

Hi Marc,

> On 09/09/15 20:23, Julien Grall wrote:
>> Hi,
>>
>> I've been trying the latest linus/master (a794b4f), which include this
>> patch, as baremetal kernel on X-gene. This is failing on early boot
>> without much log.
>>
>> After bisecting the tree, I found the error coming from this patch.
>> While this patch is valid, it made me remembered that X-Gene (at least
>> the first version) as an odd GICv2.
>>
>> The GICC is divided in 2 area of 4K, each one aligned at a 64KB address.
>> This means that, the address of GICC_DIR won't be 0x1000 but 0x10000.
> 
> Not really. I already mentioned that one a while ago:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/332249.html

Sorry I haven't seen this thread on the ML.

> The first page of GIC is aliased over the first 64kB, and the second 
> page aliased over the second 64kB. So you get a consistent mapping if 
> you use (base + 0xF000) to address GICC. Also, the DT that's in 
> mainline is showing a 4kB CPU interface, which doesn't enable 
> EOImode==1.
> You must be using a firmware that's newer than mine, since 
> I'm perfectly able to boot my Mustang with these patches.

My U-boot firmware is:

U-Boot 2013.04-mustang_sw_1.15.12 (May 20 2015 - 10:03:33)

The interrupt controller node looks like:

interrupt-controller@78090000 {
                reg = <0x0 0x78090000 0x0 0x10000 0x0 0x780a0000 0x0
0x20000 0x0 0x780c0000 0x0 0x10000 0x0 0x780e0000 0x0 0x20000>;
                interrupts = <0x1 0x9 0xf04>;
                compatible = "arm,cortex-a15-gic";
                #interrupt-cells = <0x3>;
                phandle = <0x1>;
                interrupt-controller;
                linux,phandle = <0x1>;
        };

Note that we have a recent firmware which correct the GICD region to use
the non-secure one rather than the secure. See [1] for more details.

> 
>> We had the same issue on Xen when we did the first port of X-gene [1].
>> Although, we choose to add a quirk in Xen for this platform in order to
>> map contiguously in the virtual memory the 2 part of GICC.
>>
>> Note that, back then, Ian suggested to extend the bindings to support a
>> such platform [2]. AFAICT, there was no follow-up on it.
> 
> The main problem here is not to update the binding, but the fact that 
> you *cannot* update the DT on x-gene (the firmware will replace your 
> GIC node with what it thinks it is), and the APM guys can't be bothered 
> to fix their stuff.
> 
> In the meantime, can you give the following patch a shot? My Mustang is 
> wired to a 4kB CPU interface, so I'll need your help to test it.

I applied the two patches on top of linus/master and I'm able to boot
correctly on X-gene. Thank you!

Regards,

[1] http://lists.xen.org/archives/html/xen-devel/2015-04/msg02816.html

-- 
Julien Grall
