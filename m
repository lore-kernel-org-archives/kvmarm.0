From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Tue, 25 Apr 2017 10:22:23 +0100
Message-ID: <cd617c59-b922-3a61-1eb9-71144ce4c77a@arm.com>
References: <20161216105634.235457-1-arnd@arndb.de>
 <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/04/17 20:52, Kees Cook wrote:
> Was there a conclusion to this discussion? I didn't see anything
> definitive in the thread...
>
> Notes below...
>
> On Fri, Dec 16, 2016 at 3:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> [Fixed linux-arm-kernel mailing list address, sorry for the duplicate,
>>  I'm not reposting all the ugly patches though, unless someone really
>>  wants them, https://lkml.org/lkml/2016/12/16/174 has a copy]
>>
>> On Friday, December 16, 2016 11:56:21 AM CET Arnd Bergmann wrote:
>>> I had some fun doing build testing with older gcc versions, building
>>> every release from 4.0 through 7.0 and running that on my randconfig
>>> setup to see what comes out.
>>>
>>> First of all, gcc-4.9 and higher is basically warning-free everywhere,
>>> although gcc-7 introduces some interesting new warnings (I have started
>>> doing patches for those as well). gcc-4.8 is probably good, too, and
>>> gcc-4.6 and 4.7 at least don't produce build failures in general, though
>>> the level of false-positive warnings increases (we could decide to turn
>>> those off for older compilers for build test purposes).
>>>
>>> In gcc-4.5 and below, dead code elimination is not as good as later,
>>> causing a couple of link errors, and some of them have no good workaround
>>> (see patch 1). It would be nice to declare that version too old, but
>>> several older distros that are still in wide use ship with compilers
>>> earlier than 4.6:
>>>
>>>  RHEL6:               gcc-4.4
>
> This appears to have support until July 31, 2018. (Though it's using a
> 2.6 kernel.)
>
>>>  Debian 6:    gcc-4.4
>
> This went fully unsupported on Feb 29, 2016.
>
>>>  Ubuntu 10.04:        gcc-4.4
>
> This went fully unsupported on Apr 30, 2015.
>
>>>  SLES11:      gcc-4.3
>
> General support ends Mar 31 2019, fully unsupported 31 Mar 2022. (And
> like RHEL6 is using a 2.6 kernel.)

fyi, SLES11 upgraded to kernel 3.0, in SP2.

https://www.novell.com/support/kb/doc.php?id=3594951

Cheers
Suzuki
