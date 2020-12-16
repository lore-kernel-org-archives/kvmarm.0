Return-Path: <SRS0=5C08=FU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF869C2BBD4
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 08:45:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC20E207BC
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 08:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC20E207BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E2F4B53C;
	Wed, 16 Dec 2020 03:45:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XCC6D-a16ZXG; Wed, 16 Dec 2020 03:45:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BD854B51E;
	Wed, 16 Dec 2020 03:45:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B326B4B51E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 03:45:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nnpCtk7GyilE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2020 03:45:50 -0500 (EST)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C2B34B4E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 03:45:50 -0500 (EST)
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.57])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4CwpbG5F5Rz13VK8;
 Wed, 16 Dec 2020 16:44:42 +0800 (CST)
Received: from [10.174.185.135] (10.174.185.135) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 16 Dec 2020 16:45:45 +0800
Subject: Re: [PATCH v2 0/6] KVM: arm64: VCPU preempted check support
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
References: <20191226135833.1052-1-yezengruan@huawei.com>
 <20200113121240.GC3260@willie-the-truck>
 <b1d23a82d6a7caa79a99597fb83472be@kernel.org>
From: yezengruan <yezengruan@huawei.com>
Message-ID: <6c1f0896-b78f-c92f-4c3b-9ab17400487b@huawei.com>
Date: Wed, 16 Dec 2020 16:45:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b1d23a82d6a7caa79a99597fb83472be@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.135]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Cc: daniel.lezcano@linaro.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 peterz@infradead.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
 steven.price@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8508733694924940806=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8508733694924940806==
Content-Type: multipart/alternative;
	boundary="------------43CA695FE1BBE3490CBD148C"
Content-Language: en-US

--------------43CA695FE1BBE3490CBD148C
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On 2020/1/15 22:14, Marc Zyngier wrote:
> On 2020-01-13 12:12, Will Deacon wrote:
>> [+PeterZ]
>>
>> On Thu, Dec 26, 2019 at 09:58:27PM +0800, Zengruan Ye wrote:
>>> This patch set aims to support the vcpu_is_preempted() functionality
>>> under KVM/arm64, which allowing the guest to obtain the VCPU is
>>> currently running or not. This will enhance lock performance on
>>> overcommitted hosts (more runnable VCPUs than physical CPUs in the
>>> system) as doing busy waits for preempted VCPUs will hurt system
>>> performance far worse than early yielding.
>>>
>>> We have observed some performace improvements in uninx benchmark tests.
>>>
>>> unix benchmark result:
>>>   host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 CPUs
>>>   guest: kernel 5.5.0-rc1, 16 VCPUs
>>>
>>>                test-case                |    after-patch    |   before-patch
>>> ----------------------------------------+-------------------+------------------
>>>  Dhrystone 2 using register variables   | 334600751.0 lps   | 335319028.3 lps
>>>  Double-Precision Whetstone             |     32856.1 MWIPS |     32849.6 MWIPS
>>>  Execl Throughput                       |      3662.1 lps   |      2718.0 lps
>>>  File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |    158011.8 KBps
>>>  File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |     37664.0 KBps
>>>  File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |    441108.8 KBps
>>>  Pipe Throughput                        |   6405029.6 lps   |   6021457.6 lps
>>>  Pipe-based Context Switching           |    185872.7 lps   |    184255.3 lps
>>>  Process Creation                       |      4025.7 lps   |      3706.6 lps
>>>  Shell Scripts (1 concurrent)           |      6745.6 lpm   |      6436.1 lpm
>>>  Shell Scripts (8 concurrent)           |       998.7 lpm   |       931.1 lpm
>>>  System Call Overhead                   |   3913363.1 lps   |   3883287.8 lps
>>> ----------------------------------------+-------------------+------------------
>>>  System Benchmarks Index Score          |      1835.1       |      1327.6
>>
>> Interesting, thanks for the numbers.
>>
>> So it looks like there is a decent improvement to be had from targetted vCPU
>> wakeup, but I really dislike the explicit PV interface and it's already been
>> shown to interact badly with the WFE-based polling in smp_cond_load_*().
>>
>> Rather than expose a divergent interface, I would instead like to explore an
>> improvement to smp_cond_load_*() and see how that performs before we commit
>> to something more intrusive. Marc and I looked at this very briefly in the
>> past, and the basic idea is to register all of the WFE sites with the
>> hypervisor, indicating which register contains the address being spun on
>> and which register contains the "bad" value. That way, you don't bother
>> rescheduling a vCPU if the value at the address is still bad, because you
>> know it will exit immediately.
>>
>> Of course, the devil is in the details because when I say "address", that's
>> a guest virtual address, so you need to play some tricks in the hypervisor
>> so that you have a separate mapping for the lockword (it's enough to keep
>> track of the physical address).
>>
>> Our hacks are here but we basically ran out of time to work on them beyond
>> an unoptimised and hacky prototype:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy
>>
>> Marc -- how would you prefer to handle this?
>
> Let me try and rebase this thing to a modern kernel (I doubt it applies without
> conflicts to mainline). We can then have discussion about its merit on the list
> once I post it. It'd be good to have a pointer to the benchamrks that have been
> used here.

Hi Marc, Will,

My apologies for the slow reply. Just checking what is the latest on this
PV cond yield prototype?

https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy

Recently, I re-doed the unixbench test comparison between vCPU preempted check
and PV cond yield. The results are as follows:


unix benchmark result:
  host:  kernel 5.10.0-rc6, HiSilicon Kunpeng920, 8 CPUs
  guest: kernel 5.10.0-rc6, 16 VCPUs
                                       | 5.10.0-rc6 | pv_cond_yield | vcpu_is_preempted
 System Benchmarks Index Values        |    INDEX   |      INDEX    |      INDEX
---------------------------------------+------------+---------------+-------------------
 Dhrystone 2 using register variables  |  29164.0   |    29156.9    |    29207.2
 Double-Precision Whetstone            |   6807.6   |     6789.2    |     6912.1
 Execl Throughput                      |    856.7   |     1195.6    |      863.1
 File Copy 1024 bufsize 2000 maxblocks |    189.9   |      923.5    |     1094.2
 File Copy 256 bufsize 500 maxblocks   |    121.9   |      578.4    |      588.7
 File Copy 4096 bufsize 8000 maxblocks |    419.9   |     1992.0    |     2733.7
 Pipe Throughput                       |   6727.2   |     6670.2    |     6743.2
 Pipe-based Context Switching          |    486.9   |      547.0    |      471.9
 Process Creation                      |    353.4   |      345.1    |      338.5
 Shell Scripts (1 concurrent)          |   3187.2   |     1432.2    |     2798.7
 Shell Scripts (8 concurrent)          |   3410.5   |     1360.1    |     2672.9
 System Call Overhead                  |   2967.0   |     3273.9    |     3497.9
---------------------------------------+------------+---------------+-------------------
 System Benchmarks Index Score         |   1410.0   |     1885.8    |     2128.5


Thanks,

Zengruan

>
> Thanks,
>
>         M.



--------------43CA695FE1BBE3490CBD148C
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix"><font face="Consolas">On 2020/1/15
        22:14, Marc Zyngier wrote:<br>
      </font></div>
    <blockquote type="cite"
      cite="mid:b1d23a82d6a7caa79a99597fb83472be@kernel.org"><font
        face="Consolas">On 2020-01-13 12:12, Will Deacon wrote:
        <br>
      </font>
      <blockquote type="cite"><font face="Consolas">[+PeterZ]
          <br>
        </font>
        <font face="Consolas"><br>
          On Thu, Dec 26, 2019 at 09:58:27PM +0800, Zengruan Ye wrote:
          <br>
        </font>
        <blockquote type="cite"><font face="Consolas">This patch set
            aims to support the vcpu_is_preempted() functionality
            <br>
            under KVM/arm64, which allowing the guest to obtain the VCPU
            is
            <br>
            currently running or not. This will enhance lock performance
            on
            <br>
            overcommitted hosts (more runnable VCPUs than physical CPUs
            in the
            <br>
            system) as doing busy waits for preempted VCPUs will hurt
            system
            <br>
            performance far worse than early yielding.
            <br>
          </font>
          <font face="Consolas"><br>
            We have observed some performace improvements in uninx
            benchmark tests.
            <br>
          </font>
          <font face="Consolas"><br>
            unix benchmark result:
            <br>
              host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 CPUs
            <br>
              guest: kernel 5.5.0-rc1, 16 VCPUs
            <br>
          </font>
          <font face="Consolas"><br>
                           test-case                |    after-patch   
            |   before-patch
            <br>
----------------------------------------+-------------------+------------------
            <br>
             Dhrystone 2 using register variables   | 334600751.0 lps  
            | 335319028.3 lps
            <br>
             Double-Precision Whetstone             |     32856.1 MWIPS
            |     32849.6 MWIPS
            <br>
             Execl Throughput                       |      3662.1 lps  
            |      2718.0 lps
            <br>
             File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps 
            |    158011.8 KBps
            <br>
             File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps 
            |     37664.0 KBps
            <br>
             File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps 
            |    441108.8 KBps
            <br>
             Pipe Throughput                        |   6405029.6 lps  
            |   6021457.6 lps
            <br>
             Pipe-based Context Switching           |    185872.7 lps  
            |    184255.3 lps
            <br>
             Process Creation                       |      4025.7 lps  
            |      3706.6 lps
            <br>
             Shell Scripts (1 concurrent)           |      6745.6 lpm  
            |      6436.1 lpm
            <br>
             Shell Scripts (8 concurrent)           |       998.7 lpm  
            |       931.1 lpm
            <br>
             System Call Overhead                   |   3913363.1 lps  
            |   3883287.8 lps
            <br>
----------------------------------------+-------------------+------------------
            <br>
             System Benchmarks Index Score          |      1835.1      
            |      1327.6
            <br>
          </font></blockquote>
        <font face="Consolas"><br>
          Interesting, thanks for the numbers.
          <br>
        </font>
        <font face="Consolas"><br>
          So it looks like there is a decent improvement to be had from
          targetted vCPU
          <br>
          wakeup, but I really dislike the explicit PV interface and
          it's already been
          <br>
          shown to interact badly with the WFE-based polling in
          smp_cond_load_*().
          <br>
        </font>
        <font face="Consolas"><br>
          Rather than expose a divergent interface, I would instead like
          to explore an
          <br>
          improvement to smp_cond_load_*() and see how that performs
          before we commit
          <br>
          to something more intrusive. Marc and I looked at this very
          briefly in the
          <br>
          past, and the basic idea is to register all of the WFE sites
          with the
          <br>
          hypervisor, indicating which register contains the address
          being spun on
          <br>
          and which register contains the "bad" value. That way, you
          don't bother
          <br>
          rescheduling a vCPU if the value at the address is still bad,
          because you
          <br>
          know it will exit immediately.
          <br>
        </font>
        <font face="Consolas"><br>
          Of course, the devil is in the details because when I say
          "address", that's
          <br>
          a guest virtual address, so you need to play some tricks in
          the hypervisor
          <br>
          so that you have a separate mapping for the lockword (it's
          enough to keep
          <br>
          track of the physical address).
          <br>
        </font>
        <font face="Consolas"><br>
          Our hacks are here but we basically ran out of time to work on
          them beyond
          <br>
          an unoptimised and hacky prototype:
          <br>
        </font>
        <font face="Consolas"><br>
<a class="moz-txt-link-freetext" href="https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy">https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy</a>
          <br>
        </font>
        <font face="Consolas"><br>
          Marc -- how would you prefer to handle this?
          <br>
        </font></blockquote>
      <font face="Consolas"><br>
        Let me try and rebase this thing to a modern kernel (I doubt it
        applies without
        <br>
        conflicts to mainline). We can then have discussion about its
        merit on the list
        <br>
        once I post it. It'd be good to have a pointer to the benchamrks
        that have been
        <br>
        used here.
        <br>
      </font></blockquote>
    <p><font face="Consolas">Hi Marc, Will,<br>
        <br>
        My apologies for the slow reply. Just checking what is the
        latest on this<br>
        PV cond yield prototype?<br>
        <br>
<a class="moz-txt-link-freetext" href="https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy">https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy</a><br>
        <br>
        Recently, I re-doed the unixbench test comparison between vCPU
        preempted check<br>
        and PV cond yield. The results are as follows:<br>
        <br>
        <br>
        unix benchmark result:<br>
          host:  kernel 5.10.0-rc6, HiSilicon Kunpeng920, 8 CPUs<br>
          guest: kernel 5.10.0-rc6, 16 VCPUs<br>
                                               | 5.10.0-rc6 |
        pv_cond_yield | vcpu_is_preempted<br>
         System Benchmarks Index Values        |    INDEX   |     
        INDEX    |      INDEX<br>
---------------------------------------+------------+---------------+-------------------<br>
         Dhrystone 2 using register variables  |  29164.0   |   
        29156.9    |    29207.2<br>
         Double-Precision Whetstone            |   6807.6   |    
        6789.2    |     6912.1<br>
         Execl Throughput                      |    856.7   |    
        1195.6    |      863.1<br>
         File Copy 1024 bufsize 2000 maxblocks |    189.9   |     
        923.5    |     1094.2<br>
         File Copy 256 bufsize 500 maxblocks   |    121.9   |     
        578.4    |      588.7<br>
         File Copy 4096 bufsize 8000 maxblocks |    419.9   |    
        1992.0    |     2733.7<br>
         Pipe Throughput                       |   6727.2   |    
        6670.2    |     6743.2<br>
         Pipe-based Context Switching          |    486.9   |     
        547.0    |      471.9<br>
         Process Creation                      |    353.4   |     
        345.1    |      338.5<br>
         Shell Scripts (1 concurrent)          |   3187.2   |    
        1432.2    |     2798.7<br>
         Shell Scripts (8 concurrent)          |   3410.5   |    
        1360.1    |     2672.9<br>
         System Call Overhead                  |   2967.0   |    
        3273.9    |     3497.9<br>
---------------------------------------+------------+---------------+-------------------<br>
         System Benchmarks Index Score         |   1410.0   |    
        1885.8    |     2128.5<br>
        <br>
        <br>
        Thanks,<br>
        <br>
        Zengruan<br>
        <br>
      </font></p>
    <blockquote type="cite"
      cite="mid:b1d23a82d6a7caa79a99597fb83472be@kernel.org">
      <font face="Consolas"><br>
        Thanks,
        <br>
      </font>
      <font face="Consolas"><br>
                M.
        <br>
      </font>
    </blockquote>
    <p><font face="Consolas"><br>
      </font></p>
  </body>
</html>

--------------43CA695FE1BBE3490CBD148C--

--===============8508733694924940806==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8508733694924940806==--
