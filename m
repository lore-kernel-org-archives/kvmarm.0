Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4DAC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:40:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 700184B8B4;
	Wed, 16 Nov 2022 12:40:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D4s3XHKLbZ-p; Wed, 16 Nov 2022 12:40:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DCDB4B886;
	Wed, 16 Nov 2022 12:40:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAA9A4B882
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:40:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tvR9Uh6OMPvx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:40:54 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A71EA4B872
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:40:54 -0500 (EST)
Date: Wed, 16 Nov 2022 17:40:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668620453;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UeHzaO43ieDLq7wwhIBNc0s+wJATCXogm0raxMCfGWE=;
 b=pqyd2RsnfABs06vS5s5WxiQGhS1jRoM4fH9iQsAOtiiS8O6XHYiigIlXxmCrSjoF4nMzly
 pY5mZkvWrJSuVRNxiqWNrnZenDNsvOeGKDMFOO0zdxlmTp4wH0/E5dYOxICw9PktqrNXG/
 6DZliVD5ffi7Gn6qCuvX0xTylIrybgY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 03/12] KVM: arm64: Block unsafe FF-A calls from the host
Message-ID: <Y3UgoIlukWSrT1WY@google.com>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-4-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221116170335.2341003-4-qperret@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kernel-team@android.com, Andrew Walbran <qwandor@google.com>,
 Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
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

On Wed, Nov 16, 2022 at 05:03:26PM +0000, Quentin Perret wrote:
> From: Will Deacon <will@kernel.org>
> 
> When KVM is initialised in protected mode, we must take care to filter
> certain FFA calls from the host kernel so that the integrity of guest
> and hypervisor memory is maintained and is not made available to the
> secure world.
> 
> As a first step, intercept and block all memory-related FF-A SMC calls
> from the host to EL3. This puts the framework in place for handling them
> properly.

Shouldn't FFA_FEATURES interception actually precede this patch? At this
point in the series we're outright lying about the supported features to
the host.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
