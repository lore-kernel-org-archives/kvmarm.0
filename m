Return-Path: <SRS0=qAha=3U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48363C2D0DB
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jan 2020 18:56:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D134B20707
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jan 2020 18:56:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D134B20707
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5913F4A7E4;
	Fri, 31 Jan 2020 13:56:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hak8Rqjzsr1q; Fri, 31 Jan 2020 13:56:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF6A4A52C;
	Fri, 31 Jan 2020 13:56:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 163374A52C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jan 2020 13:56:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YxAG3GH2uGIj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jan 2020 13:56:00 -0500 (EST)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 165814A4E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jan 2020 13:55:59 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 31 Jan 2020 10:55:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; d="scan'208";a="253419672"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2020 10:55:32 -0800
Date: Fri, 31 Jan 2020 10:55:32 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] KVM: x86: Set kvm_x86_ops only after
 ->hardware_setup() completes
Message-ID: <20200131185531.GB18946@linux.intel.com>
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
 <20200130001023.24339-6-sean.j.christopherson@intel.com>
 <44e0c550-7dcc-bfed-07c4-907e61d476a1@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <44e0c550-7dcc-bfed-07c4-907e61d476a1@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
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

On Thu, Jan 30, 2020 at 06:44:09AM +0100, Paolo Bonzini wrote:
> On 30/01/20 01:10, Sean Christopherson wrote:
> > Set kvm_x86_ops with the vendor's ops only after ->hardware_setup()
> > completes to "prevent" using kvm_x86_ops before they are ready, i.e. to
> > generate a null pointer fault instead of silently consuming unconfigured
> > state.
> 
> What about even copying kvm_x86_ops by value, so that they can be
> accessed with "kvm_x86_ops.callback()" and save one memory access?

Oooh, I like that idea.  And {svm,vmx}_x86_ops could be marked __initdata
to save a few bytes and force all the runtime stuff through kvm_x86_ops.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
