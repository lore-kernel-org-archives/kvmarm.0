Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54B2C433ED
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 08:44:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B6AC61430
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 08:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B6AC61430
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7661A4B6C7;
	Mon, 10 May 2021 04:44:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RhoAZkXsCXIy; Mon, 10 May 2021 04:44:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40F134B6E2;
	Mon, 10 May 2021 04:44:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCBB04B6C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 04:44:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CEeUBw1fItKl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 04:44:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E13324B6B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 04:44:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620636252;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zcdJnihZR9fwljqxuJT0xreg/nDhm4mw3gRoSNdwurw=;
 b=VzFOInCzDC7Edc10EZBwN+fuY6nh3RzoUffj7eHZcNwD978szx18BUODLjy8+s/4T8L4Mw
 N9lTbC0HIjtbM5Hc+Qtins9UOj0tX6zv9oVbYdUZiR6pNDz97kD477umlWT8vnZ68pm2jC
 M8wkwl7PhSp532os0rM8FMM+5asfo6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-Zf--0QeyNEqyfUYpL9tg4g-1; Mon, 10 May 2021 04:44:10 -0400
X-MC-Unique: Zf--0QeyNEqyfUYpL9tg4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0826980ED8B;
 Mon, 10 May 2021 08:44:08 +0000 (UTC)
Received: from [10.36.113.168] (ovpn-113-168.ams2.redhat.com [10.36.113.168])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17B645D9F2;
 Mon, 10 May 2021 08:43:59 +0000 (UTC)
Subject: Re: [PATCH 15/56] KVM: arm64: Add build rules for separate VHE/nVHE
 object files
To: Marc Zyngier <maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-16-maz@kernel.org>
 <2ff3a1cb-a310-7963-4171-bd1e7d08e39b@redhat.com>
 <871ralnjmq.wl-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <3f3d1fe9-048c-90b4-1cd9-db0f97544479@redhat.com>
Date: Mon, 10 May 2021 10:43:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <871ralnjmq.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 5/5/21 8:03 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Tue, 04 May 2021 15:47:36 +0100,
> Auger Eric <eric.auger@redhat.com> wrote:
>>
>> Hi David, Marc,
>>
>> On 8/5/20 7:56 PM, Marc Zyngier wrote:
>>> From: David Brazdil <dbrazdil@google.com>
>>>
>>> Add new folders arch/arm64/kvm/hyp/{vhe,nvhe} and Makefiles for building code
>>> that runs in EL2 under VHE/nVHE KVM, repsectivelly. Add an include folder for
>>> hyp-specific header files which will include code common to VHE/nVHE.
>>>
>>> Build nVHE code with -D__KVM_NVHE_HYPERVISOR__, VHE code with
>>> -D__KVM_VHE_HYPERVISOR__.
>>>
>>> Under nVHE compile each source file into a `.hyp.tmp.o` object first, then
>>> prefix all its symbols with "__kvm_nvhe_" using `objcopy` and produce
>>> a `.hyp.o`. Suffixes were chosen so that it would be possible for VHE and nVHE
>>> to share some source files, but compiled with different CFLAGS.
>>>
>>> The nVHE ELF symbol prefix is added to kallsyms.c as ignored. EL2-only symbols
>>> will never appear in EL1 stack traces.
>>>
>>> Due to symbol prefixing, add a section in image-vars.h for aliases of symbols
>>> that are defined in nVHE EL2 and accessed by kernel in EL1 or vice versa.
>>>
>>> Signed-off-by: David Brazdil <dbrazdil@google.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Link: https://lore.kernel.org/r/20200625131420.71444-4-dbrazdil@google.com
>>> ---
>>>  arch/arm64/kernel/image-vars.h   | 14 +++++++++++++
>>>  arch/arm64/kvm/hyp/Makefile      | 10 +++++++---
>>>  arch/arm64/kvm/hyp/nvhe/Makefile | 34 ++++++++++++++++++++++++++++++++
>>>  arch/arm64/kvm/hyp/vhe/Makefile  | 17 ++++++++++++++++
>>>  scripts/kallsyms.c               |  1 +
>>>  5 files changed, 73 insertions(+), 3 deletions(-)
>>>  create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile
>>>  create mode 100644 arch/arm64/kvm/hyp/vhe/Makefile
> 
> [...]
> 
>>> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
>>> index 6dc3078649fa..0096cd965332 100644
>>> --- a/scripts/kallsyms.c
>>> +++ b/scripts/kallsyms.c
>>> @@ -109,6 +109,7 @@ static bool is_ignored_symbol(const char *name, char type)
>>>  		".LASANPC",		/* s390 kasan local symbols */
>>>  		"__crc_",		/* modversions */
>>>  		"__efistub_",		/* arm64 EFI stub namespace */
>>> +		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
>> The addition of this line seems to have introduced errors on the
>> 'vmlinux symtab matches kallsyms' perf test (perf test -v 1) which fails
>> on aarch64 for all __kvm_nvhe_ prefixed symbols, like
>>
>> ERR : <addr> : __kvm_nvhe___invalid not on kallsyms
>> ERR : <addr> : __kvm_nvhe___do_hyp_init not on kallsyms
>> ERR : <addr> : __kvm_nvhe___kvm_handle_stub_hvc not on kallsyms
>> ERR : <addr> : __kvm_nvhe_reset not on kallsyms
>> ../..
>>
>> I understand we willingly hided those symbols from /proc/kallsyms. Do
>> you confirm the right fix is to upgrade the perf test suite accordingly?
> 
> Hmmm. This test always fail here, no matter whether I have this line
> or not:

sorry Marc I missed your reply,
> 
> <quote>
> maz@big-leg-emma:~$ sudo perf_5.10 test -v 1
>  1: vmlinux symtab matches kallsyms                                 :
> --- start ---
> test child forked, pid 664
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> /proc/{kallsyms,modules} inconsistency while looking for "[bpf]" module!
> Looking at the vmlinux_path (8 entries long)
> symsrc__init: cannot get elf header.
> symsrc__init: cannot get elf header.
> Couldn't find a vmlinux that matches the kernel running on this machine, skipping test
> test child finished with -2
> ---- end ----
> vmlinux symtab matches kallsyms: Skip
> </quote>
> 
> Rookie question: How do you provide a kernel to the test framework?
On my end I compiled and installed a kernel and compiled perf from that
same kernel. Should work. I don't know how to point to a specific vmlinux

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
