From: "Kalra, Ashish" <Ashish.Kalra@cavium.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Tue, 1 May 2018 20:27:56 +0530
Message-ID: <61a11d00-cc9c-bc17-eec0-0296085026e7@cavium.com>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
 <20171218191037.wjocr7jbf5ua2duj@hawk.localdomain>
 <20171220170030.zvz3oounirnlhcfi@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 404B040192
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 May 2018 10:48:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WHmduG4orHZa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 May 2018 10:48:34 -0400 (EDT)
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0078.outbound.protection.outlook.com [104.47.32.78])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DFCB402C7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 May 2018 10:48:34 -0400 (EDT)
In-Reply-To: <20171220170030.zvz3oounirnlhcfi@hawk.localdomain>
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
To: Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hello Shih-Wei,

This exception is probably due to a bug in the hvc_test (hvc call) code,
and there is a generic bug in the hvc test code.
In the function hvc_test(), local variables c1, c2 get mapped to 
registers (typically x1 & x2) and those are "clobbered" across the hvc 
call, hence, c1 gets clobbered and we get a large cycle count for 
hvc_test (c2 - 0), which messes-up the hvc test measurements.

As per SMC64/HVC64 ABI definitions, x0-x18 can be clobbered across
HVC/SMC calls.

Currently, i am using your micro-benchmark code with the following
hack applied ...

+register unsigned long c1_hvc asm ("x19"); 
 

static unsigned long hvc_test(void) 
 

{
+     unsigned long c2;
-     unsigned long c1, c2;
 
 
 
 
 

+     c1_hvc = read_cc();
-     c1 = read_cc();
      asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0"); 
 

      c2 = read_cc();
+     return CYCLE_COUNT(c1_hvc, c2);
-     return CYCLE_COUNT(c1, c2); 
 

}

Thanks,
Ashish

On 12/20/2017 10:30 PM, Andrew Jones wrote:
> On Mon, Dec 18, 2017 at 08:10:37PM +0100, Andrew Jones wrote:
>> I just tried on TCG now. It doesn't run. It gets
>>
>> Timer Frequency 62500000 Hz (Output in timer count)
>> Unhandled exception ec=0 (UNKNOWN)
>> Vector: 4 (el1h_sync)
>> ESR_EL1:         02000000, ec=0 (UNKNOWN)
>> FAR_EL1: 0000000000000000 (not valid)
>> Exception frame registers:
>> pc : [<0000000040080088>] lr : [<00000000400803e8>] pstate: 800003c5
>> sp : 00000000400aff90
>> x29: 0000000000000000 x28: 0000000000000000
>> x27: 0000000040090000 x26: 0000000040090c60
>> x25: 0000000040090000 x24: 000000001fffffff
>> x23: 0000000000000000 x22: 0000000000000000
>> x21: 0000000000000040 x20: 0000000000000000
>> x19: 0000000000000000 x18: 00000000400b0000
>> x17: 0000000000000000 x16: 0000000000000000
>> x15: 00000000400afe8c x14: 00000000400b0000
>> x13: 00000000400afecc x12: 0000000000001680
>> x11: 0000000000000000 x10: 6666666666666667
>> x9 : 0000000000000030 x8 : 0000000000000030
>> x7 : 00000000400af670 x6 : 00000000400af673
>> x5 : 00000000400af678 x4 : 00000000000007b7
>> x3 : 00000000400af6ec x2 : 0000000040090000
>> x1 : 000000000015909e x0 : 000000004b000000
>>
> 
> I looked into this. It's due to the hvc call. The exception goes away if
> you add '-machine virtualization=yes' to the qemu command line. But as
> there's no point in running it, and it's way too slow, then the
> 'accel = kvm' added in v2 of the patch is the right thing to do.
> 
> Thanks,
> drew
> 
