From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Intermittent guest kernel crashes with v4.5-rc6.
Date: Mon, 18 Apr 2016 17:00:25 +0100
Message-ID: <57150499.5090706@arm.com>
References: <56D6F113.9020605@codeaurora.org> <56D6F5CC.5020101@arm.com>
 <56D6FFDE.9050704@codeaurora.org> <56D7023C.7050309@arm.com>
 <56D70B31.70608@codeaurora.org> <56D72464.4080903@arm.com>
 <56D83B4A.1050401@codeaurora.org> <56D8443C.7060107@arm.com>
 <56D849AF.2040606@codeaurora.org> <56D84C73.3070305@arm.com>
 <56DE48B6.4060705@codeaurora.org> <571503B3.6060001@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06F3F49BD5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 11:58:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3W1iR0CHHuyz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2016 11:58:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8FB849BD3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 11:58:33 -0400 (EDT)
In-Reply-To: <571503B3.6060001@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>, Shanker Donthineni <shankerd@codeaurora.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 18/04/16 16:56, Christopher Covington wrote:

>>> OK. Please keep me posted about your findings. Also maybe involving some
>>> HW people ouwld be a good idea (running something in an emulator, for
>>> example...).
> 
> This has been confirmed to be a hardware defect with a firmware workaround.

Good to know. Hopefully performance is not too much impacted by the
workaround.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
