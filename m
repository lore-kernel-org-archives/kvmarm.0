Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1692C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 16:41:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D80B4B274;
	Thu, 21 Apr 2022 12:41:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G-SCpMFYY4Et; Thu, 21 Apr 2022 12:41:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B01A4B236;
	Thu, 21 Apr 2022 12:41:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C0754B1D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:41:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U4bvb0RXyY2m for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:41:01 -0400 (EDT)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F1284B1D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:41:01 -0400 (EDT)
Received: by mail-il1-f173.google.com with SMTP id f5so3402622ilj.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=zJ2PGSI6AkHDlxF/GNqF8HmtNwa9bQE1NjwYidDeeG4=;
 b=pb+EWMdmgz1SYFX5XMH36PJu8yBtqr0Vp8AGddG8kaiOE9UKasHUfSsrOs+kJgSuXR
 OKFrxOBeYXDavmOeFnwrkdLL4nrogRXknJiEortPNN9IvfWb8G+Nd6qlAWgieJnihyTv
 bdZgytwpwpts9HrOXNDERUlnemXOUdayTIjMlMen7VrjysCHLtHhwnpMsskmUJnPLeru
 DTDn/wXdO8zWEHnAZtRNNPaB46buoPfiZ5vWQle6tdzev3eBZl4u/WHtpRquc/yNM/gE
 VyGcIVWlh+r6XYvo4+irYPo8nPKy9YfO/PULBFjDZMDLESvIdrXpn77TvcarqOxmgu2u
 ZWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zJ2PGSI6AkHDlxF/GNqF8HmtNwa9bQE1NjwYidDeeG4=;
 b=M9e/s5e07eqH2NfHtRC560Ay+SyL/8HKEeLYRagMhg/a4GB4yYLhEyKEWx7Fsg8rOi
 ImVkm69ltMqXQ9kCYBErY3AE7ET8nDFOzuuwFVobVBrBCNu77vaIeO8DORd5OzH38YIP
 ZCn8pSCaqOivLlFza81JKQEu/V++sOSK9KuDCIgJHhTxpPOHBpYsop5njHK3VLi8iuD1
 aH8ROuIGUyT5mD6gGkNcJd4q+In6q+S7YfSS0HHjxinwFdVvFUEfIAV3+NAnIG2kT2Qa
 fk9kqxcBG3yRXRU+3v7JA7w1pTplivRyllzOc67Srg+/mHRCe9SpR72tR8ef15+Cnm4b
 hDog==
X-Gm-Message-State: AOAM533hpYpTo2OkAysLIdX4ZhjQhtkuSwP3eSh7PxjybEDWtiS0LjqY
 tTD8uz+AIC3s6VVmao/i5+5o0w==
X-Google-Smtp-Source: ABdhPJznCuS8lVwwartmfDZ1hMkeoqvEWgOgvlXvcS6SugJ8SjoFWUQHCgUp+HIoFk3yQVSQ1VLNBA==
X-Received: by 2002:a92:6c08:0:b0:2c6:123f:48c9 with SMTP id
 h8-20020a926c08000000b002c6123f48c9mr301117ilc.22.1650559260642; 
 Thu, 21 Apr 2022 09:41:00 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 j12-20020a6b310c000000b0065744ce0180sm117650ioa.8.2022.04.21.09.40.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Apr 2022 09:40:59 -0700 (PDT)
Date: Thu, 21 Apr 2022 16:40:56 +0000
From: Oliver Upton <oupton@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmGJGIrNVmdqYJj8@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YmFactP0GnSp3vEv@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 21, 2022 at 01:21:54PM +0000, Quentin Perret wrote:
> Hi Oliver,
> 
> On Friday 15 Apr 2022 at 21:58:53 (+0000), Oliver Upton wrote:
> > Breaking a table pte is insufficient to guarantee ownership of an
> > unlinked subtree. Parallel software walkers could be traversing
> > substructures and changing their mappings.
> > 
> > Recurse through the unlinked subtree and lock all descendent ptes
> > to take ownership of the subtree. Since the ptes are actually being
> > evicted, return table ptes back to the table walker to ensure child
> > tables are also traversed. Note that this is done both in both the
> > pre-order and leaf visitors as the underlying pte remains volatile until
> > it is unlinked.
> 
> Still trying to get the full picture of the series so bear with me. IIUC
> the case you're dealing with here is when we're coallescing a table into
> a block with concurrent walkers making changes in the sub-tree. I
> believe this should happen when turning dirty logging off?

Yup, I think that's the only time we wind up collapsing tables.

> Why do we need to recursively lock the entire sub-tree at all in this
> case? As long as the table is turned into a locked invalid PTE, what
> concurrent walkers are doing in the sub-tree should be irrelevant no?
> None of the changes they do will be made visible to the hardware anyway.
> So as long as the sub-tree isn't freed under their feet (which should be
> the point of the RCU protection) this should be all fine? Is there a
> case where this is not actually true?

The problem arises when you're trying to actually free an unlinked
subtree. All bets are off until the next RCU grace period. What would
stop another software walker from installing a table to a PTE that I've
already visited? I think we'd wind up leaking a table page in this case
as the walker doing the table collapse assumes it has successfully freed
everything underneath.

The other option would be to not touch the subtree at all until the rcu
callback, as at that point software will not tweak the tables any more.
No need for atomics/spinning and can just do a boring traversal. Of
course, I lazily avoided this option because it would be a bit more code
but isn't too awfully complicated.

Does this paint a better picture, or have I only managed to confuse even
more? :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
