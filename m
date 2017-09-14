From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 3/3] kvm: arm/arm64: vgic-its: fix return value for
 restore
Date: Wed, 13 Sep 2017 22:35:16 -0700
Message-ID: <20170914053516.GO1631@lvm>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-4-git-send-email-wanghaibin.wang@huawei.com>
 <fd0534b6-7e95-45cd-f90d-188c93a98f4a@redhat.com>
 <20170913200248.GK1631@lvm>
 <6246fa89-50cb-488a-008c-1290ced290e7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE01B4104E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 01:32:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eGIRIjaIi+wo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Sep 2017 01:32:37 -0400 (EDT)
Received: from mail-pf0-f170.google.com (mail-pf0-f170.google.com
 [209.85.192.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6BBA40FAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 01:32:37 -0400 (EDT)
Received: by mail-pf0-f170.google.com with SMTP id e1so3573874pfk.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 22:35:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6246fa89-50cb-488a-008c-1290ced290e7@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 13, 2017 at 11:25:01PM +0200, Auger Eric wrote:
> Hi,
> 
> On 13/09/2017 22:02, Christoffer Dall wrote:
> > Hi Eric,
> > 
> > On Wed, Sep 06, 2017 at 05:18:35PM +0200, Auger Eric wrote:
> >> Hi Wanghaibin,
> >>
> >> On 06/09/2017 15:05, wanghaibin wrote:
> >>> This patch fix the migrate restore tables failure.
> >>>
> >>> The same scene, at the destination, the restore tables interface traversal guest
> >>> memory, and check the dte/ite is valid or not.
> >>> If all dtes/ites are invalid, we will do try next one, and the last it will take
> >>> the 1 return value, but currently, it be treated as error. That's not correct.
> >> There's indeed a bug here! In case all entries are invalid we shouldn't
> >> return an error.
> >>
> >> One solution could be to relax the error checking in scan_its_table()
> >> and do not return 1 when the whole length has been scanned. This would
> >> fix your issue.
> If you do not return 1 in scan_its_table if the whole size has been
> scanned, you achieve the same thing as in this patch and you simplify
> the error handling.

Yes, but then you have to rework the scan function otherwise to work
with indirect tables, and I'm not sure that becomes more pretty.

> >>
> >> drawback of that change:
> >> at the moment we check the consistency of the entry data (next offset
> >> field). At the moment if the next_offset points to an entry outside of
> >> the table scope we are able to return an error (for top level tables).
> >>
> >> Otherwise, if we want to keep that check, I think we would need to add a
> >> bool *valid parameter to entry_fn_t. in scan_its_table() we would return
> >> 1 only if last fn() call returns valid and len <= 0.
> >>
> > 
> > I don't really understand what you're proposing.
> The above method or Wanghaibin's patch removes a consistency check on
> the entry next offset field. But maybe this is better to drop it and
> have a code that gains in readability.
> 

Can you show me an alternative better patch and we can compare?

Thanks,
-Christoffer
