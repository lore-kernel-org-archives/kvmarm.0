Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88347C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Dec 2021 20:07:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC8640C67;
	Wed, 22 Dec 2021 15:07:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bem6dAIVeaOe; Wed, 22 Dec 2021 15:07:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AFE640D74;
	Wed, 22 Dec 2021 15:07:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AAC040C52
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 13:27:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tlfMDtc-zVjD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Dec 2021 13:27:11 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CFEB40BBE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 13:27:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1640197631; x=1671733631;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=uN531P6eAKoDlmobwFM1DNbNSTwy3I5gzy72Rjv6Q/8=;
 b=ky2Ej+TBcTK3+x/AEls30ELg9nFFWW06SpZpd4OUz8lpELNOnDIXJmzj
 XoS7NKhRdcP63hQ+hncK0mtKSXNF0WT15aLUqypqPeAbGt1zVch5i8iQ4
 Up+pegXKTuahVoMsnNXDClmSC5DtkyvqfCUc7aoXbTZBaKdww5YgTnekO
 zhZVEYendn3ywoDkkQouUWz9dopS4tBnkrJfoBEHLYwVUpIbzW108wySg
 SwDK1KiuDi4ZteWUGLDCmBAyQeNJJyUn8EyUxCFRRLhiZMRjPYmUyy6Su
 CYWtjNNtmR2sfdaIUF2FK8Mbl+TY/1aamPAyiPfLZ19BtLECV8cJeze2+ Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="304056010"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; d="scan'208";a="304056010"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Dec 2021 10:27:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; d="scan'208";a="587098653"
Received: from smile.fi.intel.com ([10.237.72.61])
 by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Dec 2021 10:27:08 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
 (envelope-from <andriy.shevchenko@linux.intel.com>)
 id 1n06J5-000uwc-2x; Wed, 22 Dec 2021 20:25:43 +0200
Date: Wed, 22 Dec 2021 20:25:42 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/1] KVM: arm64: vgic: Replace kernel.h with the
 necessary inclusions
Message-ID: <YcNtpnxbyDA/CGgc@smile.fi.intel.com>
References: <20211222165552.69288-1-andriy.shevchenko@linux.intel.com>
 <8735mk1pgt.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735mk1pgt.wl-maz@kernel.org>
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

On Wed, Dec 22, 2021 at 06:09:22PM +0000, Marc Zyngier wrote:
> On Wed, 22 Dec 2021 16:55:52 +0000,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > 
> > When kernel.h is used in the headers it adds a lot into dependency hell,
> > especially when there are circular dependencies are involved.
> 
> Which circular dependencies? What problem are you solving?

In particular moving bitmap_*alloc() APIs to the headers.

But this may be a side effect of what I realized during the attempts
of solving that issue. In any case there is no need to take entire
mess of kernel.h in another header.

-- 
With Best Regards,
Andy Shevchenko


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
