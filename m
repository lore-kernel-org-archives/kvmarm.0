From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH kvmtool] arm: Allow command line for firmware
Date: Thu, 31 Jan 2019 13:40:26 +0000
Message-ID: <1bdd0e8d-22fe-64d7-ac04-f8684a0e9eb3@arm.com>
References: <20190125154308.185131-1-andre.przywara@arm.com>
 <20190130182010.GE18558@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C7E4A2F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:40:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XGD3o-m4I31q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 08:40:30 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 608D04A2B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:40:30 -0500 (EST)
In-Reply-To: <20190130182010.GE18558@fuggles.cambridge.arm.com>
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
To: Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 30/01/2019 18:20, Will Deacon wrote:
> On Fri, Jan 25, 2019 at 03:43:08PM +0000, Andre Przywara wrote:
>> When loading a firmware instead of a kernel, we can still pass on any
>> *user-provided* command line, as /chosen/bootargs is a generic device tree
>> feature. We just need to make sure to not pass our mangled-for-Linux
>> version.
>>
>> This allows to run "firmware" images which make use of a command line,
>> still are not Linux kernels, like kvm-unit-tests.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Hi Will,
>>
>> this goes on top of Julien's firmware series (which did not yet appear
>> on kernel.org?)
>> This fixes an issue with some kvm-unit-tests support. [1]
> 
> Does kvm-unit-tests break if we pass the modified command line? I'm wary of
> passing something different depending on whether the payload is firmware or
> kernel, because there's a pretty fine line between the two (and the firmware
> may even just forward the thing on to the kernel it loads).
> 

Yes, this is why I removed it initially for the firmware case.

In the EFI case, the DT is just passed as is to Linux, however the Linux
EFI stub retrieves the command line from EFI, and the command line in
the DT is ignored. So to avoid confusion, I wanted to prevent passing a
command line that just gets ignored.

However the command line property of the chosen node is not linux
specific and some other OS/firmware/bootloader could rely on it. So I'm
not sure what's the best move here.

Cheers,

-- 
Julien Thierry
