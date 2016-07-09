From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: [PATCH] updated: arm64: KVM: vgic: deal with GIC sub-page
 alignment
Date: Sat, 9 Jul 2016 09:34:28 +0900
Message-ID: <620184e0-31e0-bacc-053c-d96d984ade2d@riken.jp>
References: <5775F854.3060306@riken.jp> <57762C8A.8060105@arm.com>
 <f2630ba4-1e97-ccfc-cfe2-525a21c215e6@riken.jp> <577635EE.1010002@arm.com>
 <d91a1d8b-8a83-e676-0d5c-decad046662f@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96360499A1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2016 20:29:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ihtzMVNWLzki for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2016 20:29:12 -0400 (EDT)
Received: from postman.riken.jp (postman2.riken.jp [134.160.33.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D462A412DD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2016 20:29:11 -0400 (EDT)
In-Reply-To: <d91a1d8b-8a83-e676-0d5c-decad046662f@riken.jp>
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
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Forgot to mention that all tests/attempts were done on an ACPI-based
system.

On 7/9/16 9:27 AM, Itaru Kitayama wrote:
> Marc,
>
> I'm at the latest commit, fa9301d in the gicv-align branch at the
> moment, with that an unmodified QEMU guest boots fine on a 64Kb page
> granular host, thanks to the trapping you introduced.
> (I wanted to get some performance statistics of the new feature with
> perf, but on arm64 most of them are unsupported)
>
> However, if I rebuild the kernel using defconfig with only the kernel
> page size changed to 16Kb it does not boot at least on Overdrive 3000.
>
>
> On 7/1/16 6:20 PM, Marc Zyngier wrote:
>> On 01/07/16 09:59, Itaru Kitayama wrote:
>>> Marc,
>>> That's good news. Can I assume you'd keep the
>>> KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET attribute, or would you introduce new
>>> ones? I ask because either way we need the userland support, be it QEMU
>>> or kvmtool. I'm carrying the small QEMU patch at this moment.
>>
>> You can look at the kvm-arm64/gicv-align branch in my tree, which
>> contains some of the stuff. At the moment, the attribute is named
>> KVM_DEV_ARM_VGIC_GRP_GICC_OFFSET, but I don't mind changing the name.
>>
>> Thanks,
>>
>>     M.
