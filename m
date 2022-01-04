Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA09C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 14:05:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 169B349F0B;
	Tue,  4 Jan 2022 09:05:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mu86rRBjHkOF; Tue,  4 Jan 2022 09:05:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBB049F44;
	Tue,  4 Jan 2022 09:05:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7275949F5B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 08:47:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5gD-g-m6bot3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 08:47:11 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E0C549F2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 08:47:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1641304031; x=1672840031;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=giCDfeerhSB/M4N2G4n+FT62UWoiMv/yX0S2mawmUU4=;
 b=E2BRNlszywgGZW0jk5D9nctEtiIqyzdgnhUpdrd9RIOoxwBlxo2n1cPu
 UbWERkvdjdNezGjj4LeMhn0phDJhCC0OnGdq0KI10NA3i2Vk7YXARrHjf
 gjT3pZh5pUBNj9y+bHWunWsCAJaVl4uMmk50O4m5IMdAp+r1e6787Oux+
 59VaoFpTl/w1QxSfKZNnwLMi7YJeC7lLqX+ndMzQD1IvSDRRMwWAmVhRo
 x/XHySo4TSjlyP7XbOGhRRGMrqtS456Q+wLyUjZV4saqS5D10IwWqKrSx
 jbF+p7bR1CPppuyV9cOEaTR3RI8RVCDQpAysWQq7QI34hQr/mHJLJS976 w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="305577088"
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; d="scan'208";a="305577088"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Jan 2022 05:47:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; d="scan'208";a="488198643"
Received: from smile.fi.intel.com ([10.237.72.61])
 by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Jan 2022 05:47:05 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
 (envelope-from <andriy.shevchenko@linux.intel.com>)
 id 1n4k8J-006DjC-Hk; Tue, 04 Jan 2022 15:45:47 +0200
Date: Tue, 4 Jan 2022 15:45:47 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/1] KVM: arm64: vgic: Replace kernel.h with the
 necessary inclusions
Message-ID: <YdRPi65NyiigKPPG@smile.fi.intel.com>
References: <20211222165552.69288-1-andriy.shevchenko@linux.intel.com>
 <8735mk1pgt.wl-maz@kernel.org>
 <YcNtpnxbyDA/CGgc@smile.fi.intel.com>
 <YcN5FKnbT9BHLn9f@smile.fi.intel.com>
 <87iluzvcn4.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87iluzvcn4.wl-maz@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Mailman-Approved-At: Tue, 04 Jan 2022 09:05:56 -0500
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

On Tue, Jan 04, 2022 at 01:44:31PM +0000, Marc Zyngier wrote:
> On Wed, 22 Dec 2021 19:14:28 +0000,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > On Wed, Dec 22, 2021 at 08:25:43PM +0200, Andy Shevchenko wrote:
> > > On Wed, Dec 22, 2021 at 06:09:22PM +0000, Marc Zyngier wrote:
> > > > On Wed, 22 Dec 2021 16:55:52 +0000,
> > > > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > > > > 
> > > > > When kernel.h is used in the headers it adds a lot into dependency hell,
> > > > > especially when there are circular dependencies are involved.
> > > > 
> > > > Which circular dependencies? What problem are you solving?
> > > 
> > > In particular moving bitmap_*alloc() APIs to the headers.
> > > 
> > > But this may be a side effect of what I realized during the attempts
> > > of solving that issue. In any case there is no need to take entire
> > > mess of kernel.h in another header.
> > 
> > For the record  `make headerdep` doesn't make any difference with
> > or without this patch. But I consider it's better not to use kernel.h
> > in the headers due to a full mess behind it.
> 
> Can you then please write a commit message that matches what this is
> actually doing instead of mentioning a problem that doesn't seem to
> exist?

Sure, thanks for review!

-- 
With Best Regards,
Andy Shevchenko


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
