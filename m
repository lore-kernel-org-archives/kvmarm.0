Return-Path: <SRS0=y5YY=NU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DEFC432BE
	for <kvmarm@archiver.kernel.org>; Sun, 29 Aug 2021 02:35:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52ABF60E99
	for <kvmarm@archiver.kernel.org>; Sun, 29 Aug 2021 02:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 52ABF60E99
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2A314B0BB;
	Sat, 28 Aug 2021 22:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5GA7pgfcXwQE; Sat, 28 Aug 2021 22:35:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F594B132;
	Sat, 28 Aug 2021 22:35:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A7E54B12D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Aug 2021 22:35:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cvYGV9psMzNQ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Aug 2021 22:35:36 -0400 (EDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE81A4B0BB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Aug 2021 22:35:35 -0400 (EDT)
Received: by mail-il1-f176.google.com with SMTP id l10so11777607ilh.8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Aug 2021 19:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=RudsPPL2jXFkdPRzt+igCskpzL+QGPjfc2x3ccwPC9w=;
 b=J9dShv8oT22vhmmqH2pkP0XLxIOEJ7tW9eSIEdnG1fyr3GwcpVNpmGYZWHtUTPwbdc
 lKZST7xRrEZtCCb+YWt8Xhzpj6P/kSiXR0smrgRiSTf5HtapPENUniwt6x6XneYgBx0f
 MhIbbwvej2DS9j87DesFkvJyYr27DVk+uIr34OeQabcGSnyM56UwM+VJQyZowkGY0Neh
 OsWFl9GKalS1FqlEsxb3bHlOl0fYVMlSmFGYXE7WCyXLDSvB9bwTTYN1vCxZ84vvyh5r
 lSjypE12DhI1TxK1lGSxbhqQx8NkclxW++kh+LZbm+cV6BzzD9CA8RVPG7HK+8BEXDGe
 18qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=RudsPPL2jXFkdPRzt+igCskpzL+QGPjfc2x3ccwPC9w=;
 b=FD1IDjz+dFZ3sHevff3HfHrImhV/dqYbVwr/0QVzqPzU4QFKmAbMdCrfuSK/4b1XEL
 j3HOYaOs7W9A4Fr9cAte7uZ0ixbDJghzFp11FVsSYleBQAupQNNlwpK8ZKOl0a3CHqan
 mKVYTILPYjD+yBEXgj4BQrXoOXTb0KbrKCLYlnhannFj/JkEdS3YEK0cArp1xjNpqRkC
 TS4qEwdBqmxAH6A6PJBn6b10IDHlqYCShmIlwNob6H/1/ewD+/M8vPofduS8it+SYXwY
 UsmF4iC8HnOr5fnbgehhIhul9Ofiri5dIeKhMsGVJLB2R+X+oK2GlW8hlv2M31/QygN1
 UfMA==
X-Gm-Message-State: AOAM532Fdf21Y90MIMxa2o/2K7dqz8CradmjAcPWRzYAZdAGxyNz+LBS
 FKRygGd2oBmL76+tn+22T+rz/w==
X-Google-Smtp-Source: ABdhPJwqUHMTxEkDQA8hFpGHHEo0tu8/O2NMjK/5E7lfYuh/Mo0XzToNBlb9dDEkFv0S5CWvSmaOLA==
X-Received: by 2002:a92:cda4:: with SMTP id g4mr11981754ild.236.1630204534995; 
 Sat, 28 Aug 2021 19:35:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id h11sm1851451ilc.7.2021.08.28.19.35.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 28 Aug 2021 19:35:34 -0700 (PDT)
Date: Sun, 29 Aug 2021 02:35:30 +0000
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v7 3/7] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
Message-ID: <YSryci4dSuRAEg+g@google.com>
References: <20210816001217.3063400-1-oupton@google.com>
 <20210816001217.3063400-4-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210816001217.3063400-4-oupton@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Mon, Aug 16, 2021 at 12:12:13AM +0000, Oliver Upton wrote:
> Allow userspace to access the guest's virtual counter-timer offset
> through the ONE_REG interface. The value read or written is defined to
> be an offset from the guest's physical counter-timer. Add some
> documentation to clarify how a VMM should use this and the existing
> CNTVCT_EL0.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Hrm...

I was mulling on this patch a bit more and had a thought. As previously
discussed, the patch implements virtual offsets by broadcasting the same
offset to all vCPUs in a guest. I wonder if this may tolerate bad
practices from userspace that will break when KVM supports NV.

Consider that a nested guest may set CNTVOFF_EL2 to whatever value it
wants. Presumably, we will need to patch the handling of CNTVOFF_EL2 to
*not* broadcast to all vCPUs to save/restore NV properly. If a maligned
VMM only wrote to a single vCPU, banking on this broadcasting
implementation, it will fall flat on its face when handling an NV guest.

So, should we preemptively move to the new way of the world, wherein
userspace accesses to CNTVOFF_EL2 are vCPU-local rather than VM-wide?

No strong opinions in either direction, but figured I'd address it since
I'll need to respin this series anyway to fix ECV+nVHE.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
