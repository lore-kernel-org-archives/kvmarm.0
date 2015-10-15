From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: its_alloc_tables() - with all BASER marked none
Date: Thu, 15 Oct 2015 08:50:34 +0100
Message-ID: <561F5ACA.30105@arm.com>
References: <561F01B8.9060700@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 243DB410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 03:48:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id klT7Sjq9Z3oQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 03:48:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0567E41022
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 03:48:18 -0400 (EDT)
In-Reply-To: <561F01B8.9060700@samsung.com>
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

On 15/10/15 02:30, Mario Smarduch wrote:
> If its_init()/its_probe()/its_alloc_tables() finds all GITS_BASER type none, it
> continues with ITS initialization.
> 
> Is there a reason to continue?

Of course. There is nothing that *mandates* the ITS to request memory
from the operating system. The HW could perfectly come with its own
memory and not need anything at all.

> Started to look through this code recently - little confused here.

Only the beginning! ;-)

	M.
-- 
Jazz is not dead. It just smells funny...
