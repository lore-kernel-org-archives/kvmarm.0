From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Tue, 03 Mar 2015 19:13:48 +0100
Message-ID: <54F5F9DC.3020206@redhat.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <54F5F090.6090707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E68D478B5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 13:08:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G6t1GIRjNnSz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Mar 2015 13:08:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCA9D478A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 13:08:03 -0500 (EST)
In-Reply-To: <54F5F090.6090707@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/03/15 18:34, Alexander Graf wrote:
> On 02/19/2015 11:54 AM, Ard Biesheuvel wrote:
>> This is a 0th order approximation of how we could potentially force
>> the guest
>> to avoid uncached mappings, at least from the moment the MMU is on.
>> (Before
>> that, all of memory is implicitly classified as Device-nGnRnE)
>>
>> The idea (patch #2) is to trap writes to MAIR_EL1, and replace
>> uncached mappings
>> with cached ones. This way, there is no need to mangle any guest page
>> tables.
>>
>> The downside is that, to do this correctly, we need to always trap
>> writes to
>> the VM sysreg group, which includes registers that the guest may write
>> to very
>> often. To reduce the associated performance hit, patch #1 introduces a
>> fast path
>> for EL2 to perform trivial sysreg writes on behalf of the guest,
>> without the
>> need for a full world switch to the host and back.
>>
>> The main purpose of these patches is to quantify the performance hit, and
>> verify whether the MAIR_EL1 handling works correctly.
> 
> I gave this a quick spin on a VM running with QEMU.
> 
>   * VGA output is still distorted, I get random junk black lines in the
> output in between
>   * When I add -device nec-usb-xhci -device usb-kbd the VM doesn't even
> boot up

Do you also have the dirty page tracking patches in your host kernel? I
needed both (and got them via Drew's backport, thanks) and then both VGA
and USB started working fine.

Without the MAIR patches, I got cache-line size "random" corruptions in
the VGA display (16 pixel wide small segments). Without dirty page
tracking, big chunks (sometimes even almost the entire screen) was blank.

Regarding USB, unless you have both of the patchsets in the host kernel,
the guest will indeed crash early during boot. Gerd confirmed for me
that "usb controller (all uhci/ehci/xhci) pci regions see both read
(status bits) and write (control bits) access". So if there's any
corruption in there, on read, that looks like a malfunctioning piece of
hw for the guest kernel, and in this case it happens to crash.

> With TCG, both bits work fine.

Yep.

Thanks
Laszlo
