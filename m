From: Jan Bolke <jan.bolke@synopsys.com>
Subject: RE: Instruction/Cycle Counting in Guest Using the Kvm PMU
Date: Thu, 29 Nov 2018 11:30:55 +0000
Message-ID: <93B846538060DA46A9945E98A2E521E9A87BEA@DE02WEMBXB.internal.synopsys.com>
References: <93B846538060DA46A9945E98A2E521E9A87A9C@DE02WEMBXB.internal.synopsys.com>
 <0e9adc4e-20e3-5648-3ef6-64c9e16f780d@arm.com>
 <20181123132704.GN42987@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E60A04A331
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Nov 2018 06:31:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ux0eUtA4ZQfj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Nov 2018 06:31:00 -0500 (EST)
Received: from smtprelay.synopsys.com (smtprelay.synopsys.com [198.182.60.111])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 505E44A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Nov 2018 06:31:00 -0500 (EST)
In-Reply-To: <20181123132704.GN42987@e119886-lin.cambridge.arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>, James Morse <james.morse@arm.com>
Cc: Jan Bolke <jan.bolke@synopsys.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
And thanks for the fast replies.

>The PMU emulation works by creating a perf event in the host, however it is pinned to the KVM process, so the the real PMU counters are stopped and started as the KVM process is >scheduled in and out. This means that it will include any CPU time associated with that process of which your guest is only a subset of.

Thanks for the clarification.
As this is the case, the counted cycles from the host should deliver a larger number than the executed instructions inside the guest.

>The patchset that James refers to will ensure that the underlying real PMU counters underlying the guest only events will only be enabled upon entering the guest (and disabled on >leaving). Thus you will need to apply this (to your host) for more accurate counting. (You could also then use the perf modifiers in the host to counter guest cycles, e.g. perf -e >instructions:G).

So I applied your patch to a 4.19.5 kernel and also your other Patchseries for the perf events in the host [0].
So what I do now is running :
perf stat -e instructions:G -- ./run_loop_in_kvm.

Run_loop_in_kvm is a small c program who starts a vm and executes a little loop in the guest and then exits.
I get a output from perf like the following:
	159732   instructions:Gu
     ....
My Problem is, I am still not sure how to interpret these values as my bare metal code runs a loop for 1048577 times 
which executes 3 instructions in every run.

My question is how comes this discrepancy of the counted values.
The perf counting from the host delivers a value significantly smaller than the number of instructions in the guest.

I am struggling to interpret the perf counter values as an indication how many instructions my guest performed.
What am I missing?

Also I get the following output for perf stat -e cycles:G ls: 647284 cyles:Gu.
Is this a indicator that my guest/host modifiers do not work or am I misunderstanding the whole concept here?
Sorry for the silly question and thanks in advance!

>Also you may want to refer to kvm-unit-tests are there are test cases that demonstrate bare metal code for PMU enabling.
Thanks for the hint, these tests are very useful examples!

[0]: http://lists.infradead.org/pipermail/linux-arm-kernel/2018-November/614985.html
