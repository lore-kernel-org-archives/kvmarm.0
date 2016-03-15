From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [Question] Linux 3.10 supporting AArch64 KVM
Date: Tue, 15 Mar 2016 11:43:12 +0000
Message-ID: <56E7F550.4030501@arm.com>
References: <CAG=tD+-ChHd4c+f0Y8PGcJUpb32nWSv34yfNDwY3JEU7AV+KQg@mail.gmail.com>
 <20160313181852.GB15988@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5A3C49B2E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2016 07:42:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KZpB1qR2vN3Q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2016 07:42:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6159949B2C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2016 07:42:54 -0400 (EDT)
In-Reply-To: <20160313181852.GB15988@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Fernando Endo <fernando.endo2@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 13/03/16 18:18, Christoffer Dall wrote:
> On Sat, Mar 12, 2016 at 12:22:17PM +0100, Fernando Endo wrote:
>> Hello,
>>
>> I'd like to know what kernel versions KVM is known to work for AArch64.
>> More specifically, if the Linux 3.10 of the Nvidia Tegra TX1 could support
>> KVM.
>>
>> The released 3.10 kernel does not have the KVM flags enabled, so I suspect
>> that this version does not actually support KVM for AArch64.
> 
> I believe KVM for AArch64 was merged in 3.9, but it was a very early
> version of the code, so I wouldn't recommend basing anything off that.

That was KVM for AArch32. AArch64 support was merged in 3.11 IIRC. But I
wouldn't want to run anything based on this indeed. We've fixed so many
bugs it's not even funny!

> 
> You could look at the backports for LSK 3.10
> (https://git.linaro.org/?p=kernel/linux-linaro-stable.git;a=shortlog;h=refs/heads/linux-linaro-lsk-v3.10)
> but I can't make any promises of the quality of that code.
> 
> Does the Tegra TX1 board you have even boot Linux in EL2 or haven an
> open bootloader?  If not, I would expect this to be your biggest
> troubles.

I have seen traces indicating that the kernel is indeed entered at EL2.
Also, mainline seems to run on TX1, at least to some extent.

Fernando: if you're eager to try KVM on this system, mainline might be a
much better option (assuming you don't need any of the fancy stuff).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
