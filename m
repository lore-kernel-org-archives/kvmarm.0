Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0B1C07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 15:34:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4245D61404
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 15:34:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4245D61404
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4314B0FE;
	Fri,  4 Jun 2021 11:34:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8a79yt7jE9os; Fri,  4 Jun 2021 11:34:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8D74B0D0;
	Fri,  4 Jun 2021 11:34:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C3BF4B0C8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 11:34:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id swoDPASkhZzD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 11:34:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2B784B0C3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 11:34:48 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC37361402;
 Fri,  4 Jun 2021 15:34:44 +0000 (UTC)
Date: Fri, 4 Jun 2021 16:34:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v13 7/8] KVM: arm64: ioctl to fetch/store tags in a guest
Message-ID: <20210604153441.GG31173@arm.com>
References: <20210524104513.13258-1-steven.price@arm.com>
 <20210524104513.13258-8-steven.price@arm.com>
 <20210603171336.GH20338@arm.com>
 <02c7682e-5fb6-29eb-9105-02e3521756a2@arm.com>
 <20210604114233.GE31173@arm.com>
 <b3c869e3-b693-5e3f-3748-1c62b01e9b22@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b3c869e3-b693-5e3f-3748-1c62b01e9b22@arm.com>
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

On Fri, Jun 04, 2021 at 02:09:50PM +0100, Steven Price wrote:
> On 04/06/2021 12:42, Catalin Marinas wrote:
> > On Fri, Jun 04, 2021 at 12:15:56PM +0100, Steven Price wrote:
> >> On 03/06/2021 18:13, Catalin Marinas wrote:
> >>> On Mon, May 24, 2021 at 11:45:12AM +0100, Steven Price wrote:
> >>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >>>> index 24223adae150..b3edde68bc3e 100644
> >>>> --- a/arch/arm64/include/uapi/asm/kvm.h
> >>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >>>> @@ -184,6 +184,17 @@ struct kvm_vcpu_events {
> >>>>  	__u32 reserved[12];
> >>>>  };
> >>>>  
> >>>> +struct kvm_arm_copy_mte_tags {
> >>>> +	__u64 guest_ipa;
> >>>> +	__u64 length;
> >>>> +	void __user *addr;
> >>>> +	__u64 flags;
> >>>> +	__u64 reserved[2];
> >>>> +};
> >>>> +
> >>>> +#define KVM_ARM_TAGS_TO_GUEST		0
> >>>> +#define KVM_ARM_TAGS_FROM_GUEST		1
> >>>> +
> >>>>  /* If you need to interpret the index values, here is the key: */
> >>>>  #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
> >>>>  #define KVM_REG_ARM_COPROC_SHIFT	16
> >>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> >>>> index e89a5e275e25..baa33359e477 100644
> >>>> --- a/arch/arm64/kvm/arm.c
> >>>> +++ b/arch/arm64/kvm/arm.c
> >>>> @@ -1345,6 +1345,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >>>>  
> >>>>  		return 0;
> >>>>  	}
> >>>> +	case KVM_ARM_MTE_COPY_TAGS: {
> >>>> +		struct kvm_arm_copy_mte_tags copy_tags;
> >>>> +
> >>>> +		if (copy_from_user(&copy_tags, argp, sizeof(copy_tags)))
> >>>> +			return -EFAULT;
> >>>> +		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
> >>>> +	}
> >>>
> >>> I wonder whether we need an update of the user structure following a
> >>> fault, like how much was copied etc. In case of an error, some tags were
> >>> copied and the VMM may want to skip the page before continuing. But here
> >>> there's no such information provided.
> >>>
> >>> On the ptrace interface, we return 0 on the syscall if any bytes were
> >>> copied and update iov_len to such number. Maybe you want to still return
> >>> an error here but updating copy_tags.length would be nice (and, of
> >>> course, a copy_to_user() back).
> >>
> >> Good idea - as you suggest I'll make it update length with the number of
> >> bytes not processed. Although in general I think we're expecting the VMM
> >> to know where the memory is so this is more of a programming error - but
> >> could still be useful for debugging.
> > 
> > Or update it to the number of bytes copied to be consistent with
> > ptrace()'s iov.len. On success, the structure is effectively left
> > unchanged.
> 
> I was avoiding that because it confuses the error code when the initial
> copy_from_user() fails. In that case the structure is clearly unchanged,
> so you can only tell from a -EFAULT return that nothing happened. By
> returning the number of bytes left you can return an error code along
> with the information that the copy only half completed.
> 
> It also seems cleaner to leave the structure unchanged if e.g. the flags
> or reserved fields are invalid rather than having to set length=0 to
> signal that nothing was done.
> 
> Although I do feel like arguing whether to use a ptrace() interface or a
> copy_{to,from}_user() interface is somewhat ridiculous considering
> neither are exactly considered good.
> 
> Rather than changing the structure we could return either an error code
> (if nothing was copied) or the number of bytes left. That way ioctl()==0
> means complete success, >0 means partial success and <0 means complete
> failure and provides a detailed error code. The ioctl() can be repeated
> (with adjusted pointers) if it returns >0 and a detailed error is needed.

That would be more like read/write (nearly, those always return the
amount copied). Anyway, I don't have any strong preference, I'll leave
the details up to you as long as there is some indication of how much
was copied or left.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
