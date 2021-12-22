Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23663C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Dec 2021 20:07:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C96EE40BDC;
	Wed, 22 Dec 2021 15:07:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H4yt7R5l4l6B; Wed, 22 Dec 2021 15:07:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9666B40FB2;
	Wed, 22 Dec 2021 15:07:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2CD40BC1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 14:16:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mxp7tm4RsJD6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Dec 2021 14:15:58 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DA6E40BB2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 14:15:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1640200558; x=1671736558;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=TeYxz3KQe/lbMhq6pt4M9UXFRISH6KSuuJ/067pvTBI=;
 b=f8LLSIN8hNGUyfpm7wJH4LvZJs5vgVxFzZufBO/UfxETFl6oAFaiVL/V
 psINL+DevuGNo0hn+jzky+1PjLRhlmuFQyvfGZUkc5IRCaiIXYLsEyXvt
 9nh5NRDa1MHGvFlwu4weZn+ni9+BeyGnB5CfSCyWS+iscGknfM3Hb8c8F
 CISlpNt5ocATpDB4lJ1z0J0JpM2RTl/wVWNaZcohRQWxfLaGq1TZdJ1de
 3sE/VkajCFD1tew/rk1FCHI8Qs+oxXtOvWpAk0ee7RELbDSbOX6HwACa3
 X+H2kc48XkpCStqYLCMFAwIPSLJe5TmkYrhfINEAFvjCLl2PzpjIfMWIH Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="220705338"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; d="scan'208";a="220705338"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Dec 2021 11:15:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; d="scan'208";a="685131404"
Received: from smile.fi.intel.com ([10.237.72.61])
 by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Dec 2021 11:15:54 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
 (envelope-from <andriy.shevchenko@linux.intel.com>)
 id 1n074G-000vp5-O0; Wed, 22 Dec 2021 21:14:28 +0200
Date: Wed, 22 Dec 2021 21:14:28 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/1] KVM: arm64: vgic: Replace kernel.h with the
 necessary inclusions
Message-ID: <YcN5FKnbT9BHLn9f@smile.fi.intel.com>
References: <20211222165552.69288-1-andriy.shevchenko@linux.intel.com>
 <8735mk1pgt.wl-maz@kernel.org>
 <YcNtpnxbyDA/CGgc@smile.fi.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YcNtpnxbyDA/CGgc@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Mailman-Approved-At: Wed, 22 Dec 2021 15:07:42 -0500
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Dec 22, 2021 at 08:25:43PM +0200, Andy Shevchenko wrote:
> On Wed, Dec 22, 2021 at 06:09:22PM +0000, Marc Zyngier wrote:
> > On Wed, 22 Dec 2021 16:55:52 +0000,
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > > 
> > > When kernel.h is used in the headers it adds a lot into dependency hell,
> > > especially when there are circular dependencies are involved.
> > 
> > Which circular dependencies? What problem are you solving?
> 
> In particular moving bitmap_*alloc() APIs to the headers.
> 
> But this may be a side effect of what I realized during the attempts
> of solving that issue. In any case there is no need to take entire
> mess of kernel.h in another header.

For the record  `make headerdep` doesn't make any difference with
or without this patch. But I consider it's better not to use kernel.h
in the headers due to a full mess behind it.

-- 
With Best Regards,
Andy Shevchenko


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
