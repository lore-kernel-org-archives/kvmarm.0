From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] arm/arm64: Use argv_find() for test
 names
Date: Mon, 28 Jan 2019 12:16:21 +0000
Message-ID: <6f5f5547-e88a-6098-7ad0-aba466a1b800@arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-8-alexandru.elisei@arm.com>
 <20190124130732.cjht5dc77m72s2kj@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 550E84A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 07:16:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lxvAuxTJc+gj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 07:16:28 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BA3C4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 07:16:28 -0500 (EST)
In-Reply-To: <20190124130732.cjht5dc77m72s2kj@kamzik.brq.redhat.com>
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
To: Andrew Jones <drjones@redhat.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 1/24/19 1:07 PM, Andrew Jones wrote:
> On Thu, Jan 24, 2019 at 11:16:34AM +0000, Alexandru Elisei wrote:
>> Instead of aborting the test when an unexpected parameter is found, use
>> argv_find() to search for the desired parameter. On arm and arm64, this
>> allows kvm-unit-tests to be used with virtual machine monitors like kvmtool
>> which automatically adds parameters to the kernel command line.
>>
>> For example, to run the gicv3-ipi test the following command was used:
>>
>> lkvm run -k gic.flat -c 8 -m 410 -p "ipi" --irqchip=gicv3
>>
>> The resulting kernel command line that was passed to kvm-unit-tests was:
>>
>> "console=ttyS0 rw rootflags=trans=virtio,version=9p2000.L,cache=loose rootfstype=9p init=/virt/init  ip=dhcp ipi"
> Why not write a patch for kvmtool that provides a new command line
> parameter which says to not add any kernel parameters other than what
> is provided with '-p'? Giving the user full control over the kernel
> command line seems like a feature kvmtool would want anyway.
>
> Thanks,
> drew

A patch to remove the kvmtool kernel command line has been posted [1]. I will
drop patches 6 and 7, thank you for the feedback.

[1] https://www.spinics.net/lists/kvm/msg181009.html
