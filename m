Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDCFFA3740
	for <kvmarm@archiver.kernel.org>; Mon, 31 Oct 2022 09:19:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 709A84BAD6;
	Mon, 31 Oct 2022 05:19:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yGg0r+kuvlVq; Mon, 31 Oct 2022 05:19:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 427714BAAD;
	Mon, 31 Oct 2022 05:19:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1E734BA36
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 05:18:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Glxs6RUC5sWL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Oct 2022 05:18:58 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCC674BA0C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 05:18:58 -0400 (EDT)
Date: Mon, 31 Oct 2022 09:18:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667207937;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UNUd2hX0hdMkIdzwLXRZNRwHJG+w0L3BFPgCSF2V2h4=;
 b=CaGONynma9CEbwNZEVDG+yImQsIJB5eeX0/0rXtRLfnfNR59VQBxdGKz6OlFPOb+BKcSaZ
 1R55TELwMkeAGgecUypT465F9EutTVn2+LKfa+q0uToOuYVa05UhmGaWelJJn3Hobqz5kz
 jptzmt0+r8P9aPbHrF1iijrimPgKgtM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 3/9] KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL}
 prior to enabling them
Message-ID: <Y1+S9FC6GTpYehwJ@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-4-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Mon, Oct 31, 2022 at 08:36:15AM +0800, Gavin Shan wrote:
> There are two capabilities related to ring-based dirty page tracking:
> KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL. Both are
> supported by x86. However, arm64 supports KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> only when the feature is supported on arm64. The userspace doesn't have
> to enable the advertised capability, meaning KVM_CAP_DIRTY_LOG_RING can
> be enabled on arm64 by userspace and it's wrong.
> 
> Fix it by double checking if the capability has been advertised prior to
> enabling it. It's rejected to enable the capability if it hasn't been
> advertised.
> 
> Fixes: 17601bfed909 ("KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

This patch should be picked up separate from this series for 6.1. The
original patch went through kvmarm and I think there are a few other
arm64 fixes to be sent out anyway.

Marc, can you grab this? :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
