From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: [PATCH] updated: arm64: KVM: vgic: deal with GIC sub-page
 alignment
Date: Sun, 10 Jul 2016 15:49:24 +0900
Message-ID: <aab79b94-04aa-8c68-b1f4-3c2124514041@riken.jp>
References: <5775F854.3060306@riken.jp> <57762C8A.8060105@arm.com>
 <f2630ba4-1e97-ccfc-cfe2-525a21c215e6@riken.jp> <577635EE.1010002@arm.com>
 <d91a1d8b-8a83-e676-0d5c-decad046662f@riken.jp>
 <20160709110849.4d398647@arm.com>
 <543776d0-fa4b-3105-a6f4-de3df847b9a7@riken.jp>
 <20160709210901.6fea00e8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D80B412D0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jul 2016 02:43:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2PPKZIJHO8Zt for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Jul 2016 02:43:44 -0400 (EDT)
Received: from postman.riken.jp (postman2.riken.jp [134.160.33.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1981A412C2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jul 2016 02:43:43 -0400 (EDT)
In-Reply-To: <20160709210901.6fea00e8@arm.com>
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

I was issuing the command on host which was booted up with acpi=force.

Booting up the same system with acpi=off, the probing message is there

[    2.106248] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 
counters available

and the support is there too:

$ perf stat sleep 1

  Performance counter stats for 'sleep 1':

           0.624936      task-clock:u (msec)       #    0.001 CPUs 
utilized
                  0      context-switches:u        #    0.000 K/sec 

                  0      cpu-migrations:u          #    0.000 K/sec 

                 35      page-faults:u             #    0.056 M/sec 

            389,265      cycles:u                  #    0.623 GHz 

            184,079      instructions:u            #    0.47  insn per 
cycle
    <not supported>      branches:u 

              4,828      branch-misses:u           #    0.00% of all 
branches

        1.013477604 seconds time elapsed

I'll apply the PMU probing patches for ACPI platforms and see if that helps.

On 7/10/16 5:09 AM, Marc Zyngier wrote:
>>
>> $ perf stat sleep 5
>>
>>   Performance counter stats for 'sleep 5':
>>
>>            0.589480      task-clock:u (msec)       #    0.000 CPUs
>> utilized
>>                   0      context-switches:u        #    0.000 K/sec
>>
>>                   0      cpu-migrations:u          #    0.000 K/sec
>>
>>                  35      page-faults:u             #    0.059 M/sec
>>
>>     <not supported>      cycles:u
>>
>>     <not supported>      instructions:u
>>
>>     <not supported>      branches:u
>>
>>     <not supported>      branch-misses:u
>>
>>
>>         5.024683421 seconds time elapsed
>>
>> Userland is Fedora 24.
>
> I'm pretty sure your QEMU doesn't have PMU support. Can you show the
> PMU probe messages in the guest? And/or dump the guest DTB?
>
> Thanks,
>
> 	M.
>
