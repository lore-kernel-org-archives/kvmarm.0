Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A9EC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 20:15:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5414240E76;
	Fri,  4 Nov 2022 16:15:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z3+M1erKTmmp; Fri,  4 Nov 2022 16:15:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A94240EEF;
	Fri,  4 Nov 2022 16:15:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF62940E71
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 16:15:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0rjwQpOiggHg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 16:15:07 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F4F740E00
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 16:15:07 -0400 (EDT)
Date: Fri, 4 Nov 2022 20:12:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667592767;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=e1MPhNwvfG4enmJTG4TrEJFHNNzuRv9rFUtE3O6Q7fQ=;
 b=UdfYU32+A3e2WuPMtlWhM79eOtsaVNdMBblK1AnJ7zGMgHIWpWD0/BOJkU4Th/r6giXD0d
 6W72w9Dze+eqzJHt5FAtlqYfeISDy1r5dzSyrFKVWDDxWxst1wH0Vhs98qaQmZ2zes2cAw
 GaDjgSMTUdryq6i49X0zgHyo7fZjTU4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2VyMwAlg7U9pXzV@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
 <Y2RPhwIUsGLQ2cz/@google.com>
 <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
 <Y2RlfkyQMCtD6Rbh@google.com>
 <d7e45de0-bff6-7d8c-4bf4-1a09e8acb726@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d7e45de0-bff6-7d8c-4bf4-1a09e8acb726@redhat.com>
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

On Fri, Nov 04, 2022 at 02:57:15PM +0800, Gavin Shan wrote:
> On 11/4/22 9:06 AM, Oliver Upton wrote:

[...]

> > Just to make sure we're on the same page, there's two issues:
> > 
> >   (1) If DIRTY_LOG_RING is enabled before memslot creation and
> >       RING_WITH_BITMAP is enabled after memslots have been created w/
> >       dirty logging enabled, memslot->dirty_bitmap == NULL and the
> >       kernel will fault when attempting to save the ITS tables.
> > 
> >   (2) Not your code, but a similar issue. If DIRTY_LOG_RING[_ACQ_REL] is
> >       enabled after memslots have been created w/ dirty logging enabled,
> >       memslot->dirty_bitmap != NULL and that memory is wasted until the
> >       memslot is freed.
> > 
> > I don't expect you to fix #2, though I've mentioned it because using the
> > same approach to #1 and #2 would be nice.
> > 
> 
> Yes, I got your points. Case (2) is still possible to happen with QEMU
> excluded. However, QEMU is always enabling DIRTY_LOG_RING[_ACQ_REL] before
> any memory slot is created. I agree that we need to ensure there are no
> memory slots when DIRTY_LOG_RING[_ACQ_REL] is enabled.
> 
> For case (1), we can ensure RING_WTIH_BITMAP is enabled before any memory
> slot is added, as below. QEMU needs a new helper (as above) to enable it
> on board's level.
> 
> Lets fix both with a new helper in PATCH[v8 4/9] like below?

I agree that we should address (1) like this, but in (2) requiring that
no memslots were created before enabling the existing capabilities would
be a change in ABI. If we can get away with that, great, but otherwise
we may need to delete the bitmaps associated with all memslots when the
cap is enabled.

>   static inline bool kvm_vm_has_memslot_pages(struct kvm *kvm)
>   {
>       bool has_memslot_pages;
> 
>       mutex_lock(&kvm->slots_lock);
> 
>       has_memslot_pages = !!kvm->nr_memslot_pages;
> 
>       mutex_unlock(&kvm->slots_lock);
> 
>       return has_memslot_pages;
>   }

Do we need to build another helper for this? kvm_memslots_empty() will
tell you whether or not a memslot has been created by checking the gfn
tree.

On top of that, the memslot check and setting
kvm->dirty_ring_with_bitmap must happen behind the slots_lock. Otherwise
you could still wind up creating memslots w/o bitmaps.


Something like:


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 91cf51a25394..420cc101a16e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4588,6 +4588,32 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 			return -EINVAL;
 
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
+
+	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
+		struct kvm_memslots *slots;
+		int r = -EINVAL;
+
+		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
+		    !kvm->dirty_ring_size)
+			return r;
+
+		mutex_lock(&kvm->slots_lock);
+
+		slots = kvm_memslots(kvm);
+
+		/*
+		 * Avoid a race between memslot creation and enabling the ring +
+		 * bitmap capability to guarantee that no memslots have been
+		 * created without a bitmap.
+		 */
+		if (kvm_memslots_empty(slots)) {
+			kvm->dirty_ring_with_bitmap = cap->args[0];
+			r = 0;
+		}
+
+		mutex_unlock(&kvm->slots_lock);
+		return r;
+	}
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
