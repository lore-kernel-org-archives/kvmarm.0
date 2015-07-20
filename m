From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 07/12] util/util.c: avoid clang error on vsnprintf
Date: Mon, 20 Jul 2015 15:46:03 +0100
Message-ID: <55AD09AB.20009@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
 <1437148938-5394-8-git-send-email-andre.przywara@arm.com>
 <20150717165028.GE8055@arm.com> <55AD059C.6010701@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55AD059C.6010701@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Claudio Fontana <claudio.fontana@huawei.com>, Will Deacon <Will.Deacon@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Claudio,

On 20/07/15 15:28, Claudio Fontana wrote:
> On 17.07.2015 18:50, Will Deacon wrote:
>> On Fri, Jul 17, 2015 at 05:02:13PM +0100, Andre Przywara wrote:
>>> clang by default doesn't seem to like printf calls with non-literal
>>> format strings.
>>> Add the proper pragma to disable this warning in the report function
>>> to make kvmtool compile with clang. Despite its GCC name, clang also
>>> accepts this.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  util/util.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/util/util.c b/util/util.c
>>> index 1877105..825da3f 100644
>>> --- a/util/util.c
>>> +++ b/util/util.c
>>> @@ -10,6 +10,7 @@
>>>  #include <sys/stat.h>
>>>  #include <sys/statfs.h>
>>>  
>>> +#pragma GCC diagnostic ignored "-Wformat-nonliteral"
>>
>> Urgh! I think we need to figure out a better way to keep clang happy in
>> this regard, if we decide that we care about building with it.
>>
>> Will
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>>
> 
> Hi,
> 
> what about adding -Wno-format-nonliteral to the CFLAGS when compiling with clang?
> 
> This could be set up by configure script or equivalent mechanism, ..?

GCC also knows about this warning (it's just not enabled in -Wall), so
we could simply add -Wno-format-nonliteral to CFLAGS regardless of the
compiler used.

If that sounds useful, I can respin, also addressing Szabolcs' comment.

Cheers,
Andre.
