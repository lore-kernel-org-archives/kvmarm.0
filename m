From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 1/3] kvm: arm/arm64: vgic-vits: separate
 vgic_its_free_list() function
Date: Sat, 16 Sep 2017 15:17:55 -0700
Message-ID: <20170916221755.GA4087@lvm>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-2-git-send-email-wanghaibin.wang@huawei.com>
 <20170913191405.GH1631@lvm> <59BC8579.5030700@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B6F40FB0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Sep 2017 18:15:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IjxH1l9W0yBn for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Sep 2017 18:15:25 -0400 (EDT)
Received: from mail-pg0-f50.google.com (mail-pg0-f50.google.com [74.125.83.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B49240FAF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Sep 2017 18:15:25 -0400 (EDT)
Received: by mail-pg0-f50.google.com with SMTP id c137so3226904pga.11
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Sep 2017 15:18:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <59BC8579.5030700@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 16, 2017 at 09:59:21AM +0800, wanghaibin wrote:
> On 2017/9/14 3:14, Christoffer Dall wrote:
> 
> > On Wed, Sep 06, 2017 at 09:05:08PM +0800, wanghaibin wrote:
> >> We slightly refactor vgic_its_destroy, separate vgic_its_free_list()
> >> function for later patch invoke.
> >>
> >> The patch also take a functional change. If the its->device_list.next
> > 
> > I don't see a functional change in this patch?
> 
> 
> I mean, if this check can its->device_list.next happened, this patch will
> free the its structure compared with the original implementation.
> 

I really cannot see how this patch alone changes anything at all.

Thanks,
-Christoffer
