From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 0/7] kvmtool: Cleanup kernel loading
Date: Mon, 2 Nov 2015 16:03:03 +0000
Message-ID: <56378937.8050504@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
 <20151102145846.GH29657@arm.com>
 <CAK7xexmj2wKknkeMQA7Jj5d_cmfe4PtY4B3vGavesT_V8VoBMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5488748B41
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 10:59:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ovHL-imP6Ucl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2015 10:59:27 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E08DF412C2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 10:59:26 -0500 (EST)
In-Reply-To: <CAK7xexmj2wKknkeMQA7Jj5d_cmfe4PtY4B3vGavesT_V8VoBMA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dimitri,

On 02/11/15 15:17, Dimitri John Ledkov wrote:
> On 2 November 2015 at 14:58, Will Deacon <will.deacon@arm.com> wrote:
>> On Fri, Oct 30, 2015 at 06:26:53PM +0000, Andre Przywara wrote:
>>> Hi,
>>
>> Hello Andre,
>>
>>> this series cleans up kvmtool's kernel loading functionality a bit.
>>> It has been broken out of a previous series I sent [1] and contains
>>> just the cleanup and bug fix parts, which should be less controversial
>>> and thus easier to merge ;-)
>>> I will resend the pipe loading part later on as a separate series.
>>>
>>> The first patch properly abstracts kernel loading to move
>>> responsibility into each architecture's code. It removes quite some
>>> ugly code from the generic kvm.c file.
>>> The later patches address the naive usage of read(2) to, well, read
>>> data from files. Doing this without coping with the subtleties of
>>> the UNIX read semantics (returning with less or none data read is not
>>> an error) can provoke hard to debug failures.
>>> So these patches make use of the existing and one new wrapper function
>>> to make sure we read everything we actually wanted to.
>>> The last patch moves the ARM kernel loading code into the proper
>>> location to be in line with the other architectures.
>>>
>>> Please have a look and give some comments!
>>
>> Looks good to me, but I'd like to see some comments from some mips/ppc/x86
>> people on the changes you're making over there.
> 
> Looks mostly good to me, as one of the kvmtool down streams. Over at
> https://github.com/clearlinux/kvmtool we have some patches to tweak
> the x86 boot flow, which will need rebasing/retweaking) specifically
> this commit here -
> https://github.com/clearlinux/kvmtool/commit/a8dee709f85735d16739d0eda0cc00d3c1b17477

Awesome - I was actually thinking about coding something like this!
In the last week I move the MIPS ELF loading out of mips/ into /elf.c to
be able to load kvm-unit-tests' tests (which are Multiboot/ELF). As
multiboot requires entering in protected mode, I was thinking about
changing kvmtool to support entering a guest directly in protected mode
- seems like this is mostly what you've done here already.

Looks like we should both post our patches to merge them somehow ;-)

Cheers,
Andre.
