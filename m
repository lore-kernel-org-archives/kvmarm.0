From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] scripts: Speedup MAX_SMP check
Date: Wed, 30 Jan 2019 12:54:45 +0100
Message-ID: <ef6a38b4-52b2-18b2-dfe2-2580b8a95e72@redhat.com>
References: <20180903105845.13942-1-christoffer.dall@arm.com>
 <20180903122550.7js3albkzcmej6i4@kamzik.brq.redhat.com>
 <20181030121930.GC12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EAFF4A321
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 06:54:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hndz663Y-IY3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 06:54:50 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21B754A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 06:54:50 -0500 (EST)
In-Reply-To: <20181030121930.GC12057@e113682-lin.lund.arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>, Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/10/18 13:19, Christoffer Dall wrote:
> On Mon, Sep 03, 2018 at 02:25:50PM +0200, Andrew Jones wrote:
>> On Mon, Sep 03, 2018 at 12:58:45PM +0200, Christoffer Dall wrote:
>>> The current MAX_SMP check launches QEMU for every value of the SMP
>>> parameter to check if the SMP parameter based on the native is higher
>>> than the QEMU maximum supported configuration.
>>>
>>> On something like a TX2, which has 224 threads, this takes a very long
>>> time where the test script just sits there with no output.
>>>
>>> Reduce the wait time by taking the log2 of MAX_SMP in each iteration of
>>> the loop instead.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> ---
>>>  scripts/runtime.bash | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>>> index a31ae91..1e2c288 100644
>>> --- a/scripts/runtime.bash
>>> +++ b/scripts/runtime.bash
>>> @@ -140,5 +140,5 @@ function run()
>>>  # just remove it...
>>>  while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
>>>  		|& grep -qi 'exceeds max CPUs'; do
>>> -	((--MAX_SMP))
>>> +	MAX_SMP=$((MAX_SMP >> 1))
>>>  done
>>> -- 
>>> 2.7.4
>>>
>>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>
>>
> 
> Paolo, if you're ok with this patch, could you apply it?
> 
> (I failed to CC you the first time around, only had the kvm list.)
> 
> Thanks,
> 
>     Christoffer
> 

Queued now.

Paolo
