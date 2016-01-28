From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/11] arm/pci: Device tree PCI probing
Date: Thu, 28 Jan 2016 17:40:00 +0100
Message-ID: <20160128164000.GD3807@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <06ff365af0d7579d0e4e431fad2492379533c290.1452341807.git.agordeev@redhat.com>
 <20160113151307.GA10709@hawk.localdomain>
 <20160128151719.GA26275@dhcp-27-118.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F36E4053F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 11:35:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gi-Wd8pRL6pP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2016 11:35:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46B2F40402
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 11:35:02 -0500 (EST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
 (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
 by mx1.redhat.com (Postfix) with ESMTPS id E5A892EBD12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 16:40:04 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <20160128151719.GA26275@dhcp-27-118.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Gordeev <agordeev@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 28, 2016 at 04:17:19PM +0100, Alexander Gordeev wrote:
> On Wed, Jan 13, 2016 at 04:13:07PM +0100, Andrew Jones wrote:
> > > +	assert(dt_get_nr_cells(node, &nac_root, &nsc_root) == 0);
> > 
> > Sorry the starter code I sent you had statements inside asserts().
> > We avoid those now, see commit 18ab6cadf
> 
> Hmm.. the commit does not appear addressing the described
> in changelog condition '...if somebody introduces a switch to
> "#define assert(...) /*nothing*/"...' as to-be-void asserts
> are not followed by return value checks (even when seemingly
> possible). If it worth following this pattern?
>

The asserts on return values that we've left are only there out
of paranoia. It's highly unlikely the return codes will not be
their expected values, but if they were, then it'd be good to
halt immediately, rather than continue on making the issue more
difficult to debug.

Now, it's also highly unlikely we'll ever run kvm-unit-tests with
a no-op assert() function, but I'm glad Thomas suggested we avoid
embedding actual functionality in them, as it's now the more correct
way to use assert().

Thanks,
drew
