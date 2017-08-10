From: Andrew Jones <drjones@redhat.com>
Subject: Re: kvm-unit-tests arm ptimer test
Date: Thu, 10 Aug 2017 11:12:27 +0200
Message-ID: <20170810091227.bsgpwynre2eflvvz@kamzik.brq.redhat.com>
References: <b1a2b7f6-565b-0702-b038-02e7400d30c7@cavium.com>
 <7676eb49-144d-9592-e320-cd31793d1913@cavium.com>
 <417ba96f-8ec0-f366-1105-a9cdd3bcb2d8@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5170C49C29
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 05:11:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s9ggaBY57W+O for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Aug 2017 05:10:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FA1740A86
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 05:10:59 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <417ba96f-8ec0-f366-1105-a9cdd3bcb2d8@cavium.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Kalra, Ashish" <Ashish.Kalra@cavium.com>
Cc: cdall@linaro.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 10, 2017 at 12:33:08PM +0530, Kalra, Ashish wrote:
> 
> Just realized that KVM/ARM now supports EL1 physical timer emulation
> for guests and had a look at the patch set that enables VMs to use the EL1
> physical timer through trap-and-emulate for arm64. I am using an
> older KVM release which is causing guest termination on physical
> timer access.

I had some proposed changes that would skip (output SKIP) the physical
timer tests when running on old KVM. We didn't bother with them, though,
because kvm-unit-tests is really meant to always test the latest KVM.
But, now that I see those changes would have saved you some grief, I
guess we should have gone ahead and applied them. I'll send a patch
later today.

Thanks,
drew
