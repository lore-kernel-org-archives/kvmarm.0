From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: its_alloc_tables() - with all BASER marked none
Date: Thu, 15 Oct 2015 18:10:40 +0100
Message-ID: <561FDE10.3090309@arm.com>
References: <561F01B8.9060700@samsung.com> <561F5ACA.30105@arm.com>
 <561FDD83.1030902@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D66C041022
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 13:08:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qy2WKFdTl05Y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 13:08:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0EC040FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 13:08:23 -0400 (EDT)
In-Reply-To: <561FDD83.1030902@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/10/15 18:08, Mario Smarduch wrote:
> 
> 
> On 10/15/2015 12:50 AM, Marc Zyngier wrote:
>> On 15/10/15 02:30, Mario Smarduch wrote:
>>> If its_init()/its_probe()/its_alloc_tables() finds all GITS_BASER type none, it
>>> continues with ITS initialization.
>>>
>>> Is there a reason to continue?
>>
>> Of course. There is nothing that *mandates* the ITS to request memory
>> from the operating system. The HW could perfectly come with its own
>> memory and not need anything at all.
>>
>>> Started to look through this code recently - little confused here.
>>
>> Only the beginning! ;-)
> 
> Well at this time the beginning of console freeze close to  "ITS: using cache
> flushing for cmd queue". Poked around CBASER and noticed Inner cache bits are
> updated but not sticky so it got me wondering.
> 
> Appears like I need to look elsewhere, like maybe my environment.

Out of curiosity, is that on a FastModel? Or on some actual HW?

	M.
-- 
Jazz is not dead. It just smells funny...
