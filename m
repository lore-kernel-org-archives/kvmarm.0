Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD19BECAAA1
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 22:17:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C32D4B7E7;
	Sat, 17 Sep 2022 18:17:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kUiWsLCfRuQ3; Sat, 17 Sep 2022 18:17:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32D564B7EF;
	Sat, 17 Sep 2022 18:17:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EA0D4B7E7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 18:17:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qliFf+0BqXAt for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Sep 2022 18:17:05 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47BF14B766
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 18:17:05 -0400 (EDT)
Date: Sat, 17 Sep 2022 22:17:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663453024;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rj/6CKELmx8vxHervBV7XvLj7YZJrJGD0FTLGMcPyQo=;
 b=D/jORQXVDWWJMhTHaHw3mS0GzFVH+mrtMtFNOmhdi3DDAgviqbmqn0xi9TvfWQDK/Y0jNe
 hNhwCLCKl+aJ59Mk/4YrXMsBYm7Ao8GVQjHapBAPURUQ41FV4D7EuE/+1fVeba0806w5QH
 7aP35Q9D3Ft/5N0ketutLlXUh/9cHf4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 06/13] KVM: selftests: Stash backing_src_type in
 struct userspace_mem_region
Message-ID: <YyZHXOYOmGFm6MKu@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-7-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-7-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, maz@kernel.org,
 bgardon@google.com, pbonzini@redhat.com, axelrasmussen@google.com,
 kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Tue, Sep 06, 2022 at 06:09:23PM +0000, Ricardo Koller wrote:
> Add the backing_src_type into struct userspace_mem_region. This struct already
> stores a lot of info about memory regions, except the backing source type.
> This info will be used by a future commit in order to determine the method for
> punching a hole.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
