From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH kvmtool v2 00/13] Implement reset of virtio devices
Date: Tue, 22 Jan 2019 11:51:42 +0000
Message-ID: <e690e8ab-6784-c9c5-5d2c-98d51be2b5fd@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
 <20190122070729.GA10214@brain-police>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66AF44A3AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 06:52:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7jCIwQw9pIxp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 06:52:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F28F4A393
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 06:52:00 -0500 (EST)
In-Reply-To: <20190122070729.GA10214@brain-police>
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
To: Will Deacon <will.deacon@arm.com>, Julien Thierry <Julien.Thierry@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kraxel@redhat.com" <kraxel@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/01/2019 07:07, Will Deacon wrote:
> On Thu, Jan 10, 2019 at 02:12:37PM +0000, Julien Thierry wrote:
>> This series was developped by Jean-Philippe and is needed for a series
>> I'll be posting shortly after to load firmwares on arm kvmtool.
>>
>> Currently, when a guest tries to reset a device, a lot of ressources
>> aren't reset (threads keep running, virtio queue keep their state, etc).
>>
>> When the guest only does the reset to initialize the device and there
>> were no previous users, there is no noticeable issue. But when a guest
>> has a firmare + Linux, if the firmware uses a virtio device, Linux will
>> fail to probe that device.
>>
>> This series aim to properly reset the virtio resources when the guests
>> requests it.
>>
>> Reset of net vhost is unsupported for now.
>>
>> Patch 1 is a bug fix on ioeventfd
>> Patch 2-6 provide the core support so devices can implement their reset
>> Patch 7-13 implements the reset for the various virtio devices
> 
> Cheers, I'll pick this up. There's a vague comment in patch 10 about aio
> being busted. If that's the case then we should either fix it or remove
> it...

Thanks! I think my main concern with aio was that the iocb structures
are allocated on the stack, and get trashed after io_submit(). The aio
man says that control block should remain valid until the I/O completes
(which might still apply even if we're using raw iocb instead of aiocb -
I can't find where the kernel copies those buffers). I'll take a better
look and implement reset if possible.

Thanks,
Jean
