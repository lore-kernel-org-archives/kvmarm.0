From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Intermittent guest kernel crashes with v4.5-rc6.
Date: Wed, 2 Mar 2016 14:48:51 +0000
Message-ID: <56D6FD53.3050208@arm.com>
References: <56D6F113.9020605@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93BAF41145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 09:41:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id abqH5GPFT1qZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2016 09:41:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAFA0410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 09:41:43 -0500 (EST)
In-Reply-To: <56D6F113.9020605@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/03/16 13:56, Shanker Donthineni wrote:
> 
> For some reason v4.5-rc6 kernel is not stable for guest machines on 
> Qualcomm server platforms.
> We are getting IABT translation faults while booting the guest kernel. 
> The problem disappears with
> the following code snippet (insert "dsb ish" instruction just before 
> switching to EL1 guest). I am
> using v4.5-rc6 kernel for both host and guest machines.
> 
> Please let me know if you have any thoughts or ideas for tracing this 
> problem.

Another thing you can try is find out how far up you can move that dsb,
up to the point where it starts crashing again.

Also, how reproducible is it? Every time? Randomly?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
