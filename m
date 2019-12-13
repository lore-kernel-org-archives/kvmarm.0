Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A97C3B1A2
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED939246B1
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED939246B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D754A500;
	Fri, 13 Dec 2019 15:01:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GSw5bNMr7Yvo; Fri, 13 Dec 2019 15:01:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C37994AC77;
	Fri, 13 Dec 2019 15:01:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 385C14A500
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 15:01:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YBnmCZI-0jv3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 15:01:54 -0500 (EST)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 453AC4A4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 15:01:54 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 13 Dec 2019 12:01:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; d="scan'208";a="208563026"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by orsmga008.jf.intel.com with ESMTP; 13 Dec 2019 12:01:51 -0800
Date: Fri, 13 Dec 2019 12:01:51 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 00/15] KVM: Dynamically size memslot arrays
Message-ID: <20191213200151.GF31552@linux.intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
 <20191203221433.GK19877@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191203221433.GK19877@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Tue, Dec 03, 2019 at 02:14:33PM -0800, Sean Christopherson wrote:
> On Thu, Oct 24, 2019 at 04:07:29PM -0700, Sean Christopherson wrote:
> > The end goal of this series is to dynamically size the memslot array so
> > that KVM allocates memory based on the number of memslots in use, as
> > opposed to unconditionally allocating memory for the maximum number of
> > memslots.  On x86, each memslot consumes 88 bytes, and so with 2 address
> > spaces of 512 memslots, each VM consumes ~90k bytes for the memslots.
> > E.g. given a VM that uses a total of 30 memslots, dynamic sizing reduces
> > the memory footprint from 90k to ~2.6k bytes.
> > 
> > The changes required to support dynamic sizing are relatively small,
> > e.g. are essentially contained in patches 14/15 and 15/15.  Patches 1-13
> > clean up the memslot code, which has gotten quite crusty, especially
> > __kvm_set_memory_region().  The clean up is likely not strictly necessary
> > to switch to dynamic sizing, but I didn't have a remotely reasonable
> > level of confidence in the correctness of the dynamic sizing without first
> > doing the clean up.
> > 
> > Christoffer, I added your Tested-by to the patches that I was confident
> > would be fully tested based on the desription of what you tested.  Let me
> > know if you disagree with any of 'em.
> > 
> > v3:
> >   - Fix build errors on PPC and MIPS due to missed params during
> >     refactoring [kbuild test robot].
> >   - Rename the helpers for update_memslots() and add comments describing
> >     the new algorithm and how it interacts with searching [Paolo].
> >   - Remove the unnecessary and obnoxious warning regarding memslots being
> >     a flexible array [Paolo].
> >   - Fix typos in the changelog of patch 09/15 [Christoffer].
> >   - Collect tags [Christoffer].
> > 
> > v2:
> >   - Split "Drop kvm_arch_create_memslot()" into three patches to move
> >     minor functional changes to standalone patches [Janosch].
> >   - Rebase to latest kvm/queue (f0574a1cea5b, "KVM: x86: fix ...")
> >   - Collect an Acked-by and a Reviewed-by
> 
> Paolo, do you want me to rebase this to the latest kvm/queue?

Ping.

Applies cleanly on the current kvm/queue and nothing caught fire in
testing (though I only re-tested the series as a whole).
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
