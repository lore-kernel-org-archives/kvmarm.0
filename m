From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH 3/3] KVM: ARM64: Fix guest dead loop when register
 accessor returns false
Date: Wed, 13 Jan 2016 14:20:58 +0000 (UTC)
Message-ID: <loom.20160113T151455-579@post.gmane.org>
References: <1452676601-14796-1-git-send-email-zhaoshenglong@huawei.com>
 <1452676601-14796-4-git-send-email-zhaoshenglong@huawei.com>
 <56962EDE.9070106@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E8A49B0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 09:36:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vJrAzBoFS4Oo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 09:36:03 -0500 (EST)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C961B49B06
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 09:36:03 -0500 (EST)
Received: from list by plane.gmane.org with local (Exim 4.69)
 (envelope-from <gcekad-kvmarm@m.gmane.org>) id 1aJMaj-0000ha-JM
 for kvmarm@lists.cs.columbia.edu; Wed, 13 Jan 2016 15:40:05 +0100
Received: from 104.237.91.78 ([104.237.91.78])
 by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
 id 1AlnuQ-0007hv-00
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 15:40:05 +0100
Received: from shannon.zhao by 104.237.91.78 with local (Gmexim 0.1 (Debian))
 id 1AlnuQ-0007hv-00
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 15:40:05 +0100
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Marc Zyngier <marc.zyngier <at> arm.com> writes:

> Good catch again, but I'd rather approach this in a way that is similar
> to the patch I posted last year, unifying some of the paths between
> the 32 and 64 accesses (the code paths are really pointlessly different).
> 
> I have the below patch, fully untested. What we could also do would be
> to take your patch as a fix, and then consider refactoring the beast...
> 
> Thoughts?
> 
I think maybe the small patch could be taken since it could be easy to backport 
to stable kernel. But both are fine to me. So up to you?

Thanks,
