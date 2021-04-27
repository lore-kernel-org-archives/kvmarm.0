Return-Path: <SRS0=XU7X=JY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A109C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 17:58:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B606613C6
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 17:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B606613C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0004C4B15E;
	Tue, 27 Apr 2021 13:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tWrQaMnd-rmp; Tue, 27 Apr 2021 13:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9C9E4B195;
	Tue, 27 Apr 2021 13:58:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC104B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 13:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nbNZwlboytHZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Apr 2021 13:58:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F3224B15C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 13:58:51 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 325AA60BBB;
 Tue, 27 Apr 2021 17:58:47 +0000 (UTC)
Date: Tue, 27 Apr 2021 18:58:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v11 5/6] KVM: arm64: ioctl to fetch/store tags in a guest
Message-ID: <20210427175844.GB17872@arm.com>
References: <20210416154309.22129-1-steven.price@arm.com>
 <20210416154309.22129-6-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210416154309.22129-6-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Apr 16, 2021 at 04:43:08PM +0100, Steven Price wrote:
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 24223adae150..2b85a047c37d 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -184,6 +184,20 @@ struct kvm_vcpu_events {
>  	__u32 reserved[12];
>  };
>  
> +struct kvm_arm_copy_mte_tags {
> +	__u64 guest_ipa;
> +	__u64 length;
> +	union {
> +		void __user *addr;
> +		__u64 padding;
> +	};
> +	__u64 flags;
> +	__u64 reserved[2];
> +};

I know Marc asked for some reserved space in here but I'm not sure it's
the right place. And what's with the union of a 64-bit pointer and
64-bit padding, it doesn't change any layout? Maybe add the two reserved
values to the union in case we want to store something else in the
future.

Or maybe I'm missing something, I haven't checked how other KVM ioctls
work.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
