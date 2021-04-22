Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65E5C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 15:16:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E15C613F5
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 15:16:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E15C613F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD9F4B3DF;
	Thu, 22 Apr 2021 11:16:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vD4SXCfmT9pz; Thu, 22 Apr 2021 11:16:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59BB44B407;
	Thu, 22 Apr 2021 11:16:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4664B3DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 11:16:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E7PeivmIP5Kv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 11:16:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94CE44B3D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 11:16:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2731D13A1;
 Thu, 22 Apr 2021 08:16:52 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 838F33F73B;
 Thu, 22 Apr 2021 08:16:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm with
 --target
To: Andrew Jones <drjones@redhat.com>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
 <20210420165101.irbx2upgqbazkvlt@gator.home>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
Date: Thu, 22 Apr 2021 16:17:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420165101.irbx2upgqbazkvlt@gator.home>
Content-Language: en-US
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Drew,

On 4/20/21 5:51 PM, Andrew Jones wrote:
> Hi Alex,
>
> On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
>> This is an RFC because it's not exactly clear to me that this is the best
>> approach. I'm also open to using a different name for the new option, maybe
>> something like --platform if it makes more sense.
> I like 'target'.
>
>> I see two use cases for the patch:
>>
>> 1. Using different files when compiling kvm-unit-tests to run as an EFI app
>> as opposed to a KVM guest (described in the commit message).
>>
>> 2. This is speculation on my part, but I can see extending
>> arm/unittests.cfg with a "target" test option which can be used to decide
>> which tests need to be run based on the configure --target value. For
>> example, migration tests don't make much sense on kvmtool, which doesn't
>> have migration support. Similarly, the micro-bench test doesn't make much
>> sense (to me, at least) as an EFI app. Of course, this is only useful if
>> there are automated scripts to run the tests under kvmtool or EFI, which
>> doesn't look likely at the moment, so I left it out of the commit message.
> Sounds like a good idea. unittests.cfg could get a new option 'targets'
> where a list of targets is given. If targets is not present, then the
> test assumes it's for all targets. Might be nice to also accept !<target>
> syntax. E.g.
>
> # builds/runs for all targets
> [mytest]
> file = mytest.flat
>
> # builds/runs for given targets
> [mytest2]
> file = mytest2.flat
> targets = qemu,kvmtool
>
> # builds/runs for all targets except disabled targets
> [mytest3]
> file = mytest3.flat
> targets = !kvmtool

That's sounds like a good idea, but to be honest, I would wait until someone
actually needs it before implementing it. That way we don't risk not taking a use
case into account and then having to rework it.

>
> And it wouldn't bother me to have special logic for kvmtool's lack of
> migration put directly in scripts/runtime.bash

Good to keep in mind when support is added.

>
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 132389c7dd59..0d5cb51df4f4 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -132,7 +132,7 @@ function run()
>      }
>  
>      cmdline=$(get_cmdline $kernel)
> -    if grep -qw "migration" <<<$groups ; then
> +    if grep -qw "migration" <<<$groups && [ "$TARGET" != "kvmtool" ]; then
>          cmdline="MIGRATION=yes $cmdline"
>      fi
>      if [ "$verbose" = "yes" ]; then
>
>> Using --vmm will trigger a warning. I was thinking about removing it entirely in
>> a about a year's time, but that's not set in stone. Note that qemu users
>> (probably the vast majority of people) will not be affected by this change as
>> long as they weren't setting --vmm explicitely to its default value of "qemu".
>>
> While we'd risk automated configure+build tools, like git{hub,lab} CI,
> failing, I think the risk is pretty low right now that anybody is using
> the option. Also, we might as well make them change sooner than later by
> failing configure. IOW, I'd just do s/vmm/target/g to rename it now. If
> we are concerned about the disruption, then I'd just make vmm an alias
> for target and not bother deprecating it ever.

I also think it will not be too bad if we make the change now, but I'm not sure
what you mean by making vmm an alias of target. The patch ignores --vmm is it's
not specified, and if it is specified on the configure command line, then it must
match the value of --target, otherwise configure fails.

Thanks,

Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
