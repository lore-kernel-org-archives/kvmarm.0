From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: Re: [kvm-unit-tests PATCH] Support micro operation measurement on
 arm64
Date: Mon, 18 Dec 2017 15:58:49 -0500
Message-ID: <CAO+sbHGU6EUUHQynAaA33T-ThUwA=5f9yq_Uq2mLtXRcHN02Ew@mail.gmail.com>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <20171218181440.yggldvw6lry6wsza@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48BBB49D6A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 15:55:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oco5oQraZpXB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 15:55:35 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56ED549D46
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 15:55:35 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id vBIKvPAD002362
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 15:59:20 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id E94AE6D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 15:59:20 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id D353682
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 15:59:20 -0500 (EST)
Received: from mail-io0-f198.google.com (mail-io0-f198.google.com
 [209.85.223.198])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id vBIKxKTG002806
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 15:59:20 -0500
Received: by mail-io0-f198.google.com with SMTP id t73so9682426iof.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 12:59:20 -0800 (PST)
In-Reply-To: <20171218181440.yggldvw6lry6wsza@hawk.localdomain>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 18, 2017 at 1:14 PM, Andrew Jones <drjones@redhat.com> wrote:
> Hi Shih-Wei,
>
> Thanks for doing this! Porting Christoffer's selftests to kvm-unit-tests
> has been on the kvm-unit-tests' TODO list since it was first introduced.
>
> On Fri, Dec 15, 2017 at 04:15:38PM -0500, Shih-Wei Li wrote:
>> The patch provides support for quantifying the cost of micro level
>> operations on arm64 hardware. The supported operations include hypercall,
>> mmio accesses, EOI virtual interrupt, and IPI send. Measurements are
>> currently obtained using timer counters. Further modifications in KVM
>> will be required to support timestamping using cycle counters, as KVM
>> now disables accesses to the PMU counters from the VM.
>
> KVM only disables access when userspace tells it to, which it doesn't
> do by default. Is there something else missing keeping the PMU counters
> from being used?

Thanks for the feedback! What I meant by PMU counters here was for
"CPU cycle counter" specifically. I'm not aware of a way to enable the
PMU cycle counter from QEMU, did I miss something here?

>
>>
>> We iterate each of the tests for millions of times and output their
>> average, minimum and maximum cost in timer counts. Instruction barriers
>
> Can we reduce the number of iterations and still get valid results? The
> test takes so long that of all the platforms I tested it on timed out
> before it completed, except seattle. The default timeout for kvm-unit-
> tests is 90 seconds. I'd rather a unit test execute in much shorter time
> than that too, in order to keep people encouraged to run them frequently.
> If these tests must run a long time, then I think we should add them to
> the nodefault group.

I think it's possible to reduce the timeout without losing accuracy. I
can look into this further.

>
>> were used before and after taking timestamps to avoid out-of-order
>> execution or pipelining from skewing our measurements.
>>
>> To improve precision in the measurements, one should consider pinning
>> each VCPU to a specific physical CPU (PCPU) and ensure no other task
>> could run on that PCPU to skew the results. This can be achieved by
>> enabling QMP server in the QEMU command in unittest.cfg for micro test,
>> allowing a client program to get the thread_id for each VCPU thread
>> from the QMP server. Based on the information, the client program can
>> then pin the corresponding VCPUs to dedicated PCPUs and isolate
>> interrupts and tasks from those PCPUs.
>
> To isolate the CPUs one would need to boot the host with the isolcpus
> kernel command line option. Pinning the VCPUs is pretty easy though,
> so we could provide a script that does that in kvm-unit-tests and then
> always use it for this test. The script could also warn if we're
> pinning to CPUs that haven't been isolated.
>

My intention was to support VCPU pinning as an optional feature,
so the users that care about extra precision can add qmp option in
QEMU config and run the script to pin VCPUs. Otherwise, the test can
be conducted in a fashion similar to what's done in vmexit on x86.

>>
>> The patch has been tested on arm64 hardware including AMD Seattle and
>> ThunderX2, which has GICv2 and GICv3 respectively.
>
> I tried thunderx2, amberwing, mustang, and seattle. Only seattle
> completed, the rest timed out.

I have only tested the code by invoking test directly using make
standalone like the following. I did notice that it took ~90 seconds
to finish the test itself.
./"tests/micro-cost"

Thanks,
Shih-Wei

>
> Thanks,
> drew
>
>>
>> Shih-Wei Li (1):
>>   arm64: add micro test
>>
>>  arm/Makefile.common |   1 +
>>  arm/micro-test.c    | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg   |   6 ++
>>  3 files changed, 296 insertions(+)
>>  create mode 100644 arm/micro-test.c
>>
>> --
>> 1.9.1
>>
>>
