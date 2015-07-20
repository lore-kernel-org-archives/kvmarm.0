From: Claudio Fontana <claudio.fontana@huawei.com>
Subject: Re: [PATCH 07/12] util/util.c: avoid clang error on vsnprintf
Date: Mon, 20 Jul 2015 16:28:44 +0200
Message-ID: <55AD059C.6010701@huawei.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
 <1437148938-5394-8-git-send-email-andre.przywara@arm.com>
 <20150717165028.GE8055@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 298B358E81
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2015 10:16:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r6fGOtNRqPwM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jul 2015 10:16:52 -0400 (EDT)
Received: from lhrrgout.huawei.com (lhrrgout.huawei.com [194.213.3.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94CD358E7C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2015 10:16:52 -0400 (EDT)
In-Reply-To: <20150717165028.GE8055@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17.07.2015 18:50, Will Deacon wrote:
> On Fri, Jul 17, 2015 at 05:02:13PM +0100, Andre Przywara wrote:
>> clang by default doesn't seem to like printf calls with non-literal
>> format strings.
>> Add the proper pragma to disable this warning in the report function
>> to make kvmtool compile with clang. Despite its GCC name, clang also
>> accepts this.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  util/util.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/util/util.c b/util/util.c
>> index 1877105..825da3f 100644
>> --- a/util/util.c
>> +++ b/util/util.c
>> @@ -10,6 +10,7 @@
>>  #include <sys/stat.h>
>>  #include <sys/statfs.h>
>>  
>> +#pragma GCC diagnostic ignored "-Wformat-nonliteral"
> 
> Urgh! I think we need to figure out a better way to keep clang happy in
> this regard, if we decide that we care about building with it.
> 
> Will
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

Hi,

what about adding -Wno-format-nonliteral to the CFLAGS when compiling with clang?

This could be set up by configure script or equivalent mechanism, ..?

Ciao,

Claudio
