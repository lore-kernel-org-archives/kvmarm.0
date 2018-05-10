From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: kvm_read_guest_page() missing kvm->srcu read lock?
Date: Thu, 10 May 2018 19:43:33 +0200
Message-ID: <6a60301f-1fb7-a60a-d47a-85f7ea79b1a7@redhat.com>
References: <32913bee-6ccc-cab7-65fb-fb6896c3d19c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 413B4402AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 May 2018 13:33:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZGZHH8nkLUSE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 May 2018 13:33:32 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8804640196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 May 2018 13:33:32 -0400 (EDT)
In-Reply-To: <32913bee-6ccc-cab7-65fb-fb6896c3d19c@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Glauber <jan.glauber@caviumnetworks.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/2018 19:41, Andre Przywara wrote:
> Hi,
> 
> Jan posted an lockdep splat complaining about a suspicious
> rcu_dereference_check:
> https://lists.cs.columbia.edu/pipermail/kvmarm/2018-May/031116.html
> 
> The gist of that is:
> ...
> [ 1025.695517]  dump_stack+0x9c/0xd4
> [ 1025.695524]  lockdep_rcu_suspicious+0xcc/0x118
> [ 1025.695537]  gfn_to_memslot+0x174/0x190
> [ 1025.695546]  kvm_read_guest+0x50/0xb0
> [ 1025.695553]  vgic_its_check_id.isra.0+0x114/0x148
> ...
> I chased that down and wonder if kvm_read_guest{,_page} is supposed to
> be called inside a kvm->srcu critical section?
> 
> We have a check that suggests that eventually someone needs to enter the
> SRCU criticial section:
> static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm,
> 						  int as_id)
> {
>         return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
>                         lockdep_is_held(&kvm->slots_lock) ||
>                         !refcount_read(&kvm->users_count));
> }
> 
> If I get this correctly this mean for accessing kvm->memslots we either
> need to be inside an srcu critical section or hold the kvm->slots_lock
> (for updates only).
> 
> If I am not mistaken, it is not necessary for *callers* of
> kvm_read_guest_page() to do this, as this could be entirely contained
> inside this function - since we only use the reference to the memslot
> entry while doing the copy_from_user(), and the data is safe afterwards
> from an RCU point of view because it has been *copied*.

Yes, it's the caller's responsibility.  srcu_read_lock/unlock is pretty
expensive so KVM assumes that the topmost callers do it.

Paolo
