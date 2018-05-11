From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: kvm_read_guest_page() missing kvm->srcu read lock?
Date: Fri, 11 May 2018 18:44:24 +0200
Message-ID: <b70a483f-d68e-05f8-0664-f9f6e80eeadd@redhat.com>
References: <32913bee-6ccc-cab7-65fb-fb6896c3d19c@arm.com>
 <6a60301f-1fb7-a60a-d47a-85f7ea79b1a7@redhat.com>
 <e7683868-2174-b3a6-9487-9d8892af5f39@arm.com>
 <7a24f679-142b-9283-b7dc-f3d8e70c420a@redhat.com>
 <59750e07-2c69-a63e-bad4-25f7c21febbf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1154028A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 May 2018 12:34:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJibEOq32Hvs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 May 2018 12:34:20 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99617400D4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 May 2018 12:34:20 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id a67-v6so3622942wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 May 2018 09:44:28 -0700 (PDT)
In-Reply-To: <59750e07-2c69-a63e-bad4-25f7c21febbf@arm.com>
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
Cc: James Hogan <james.hogan@imgtec.com>, Marc Zyngier <marc.zyngier@arm.com>, Jan Glauber <jan.glauber@caviumnetworks.com>, Paul Mackerras <paulus@ozlabs.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, David Gibson <david@gibson.dropbear.id.au>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/05/2018 15:25, Andre Przywara wrote:
> - I couldn't find any protection for the usage in
> arch/powerpc/kvm/powerpc.c, but the call chain is quite convoluted
> there, so I might have missed something. It would be good if someone
> more familiar with this code would take a look.

I also didn't find anything, I got up to kvmppc_handle_exit_pr in
book3s_pr.c and kvmppc_handle_exit in booke.c, then the callers are
assembly and I decided it's buggy. :)

>> Adding the srcu_read_lock/unlock directly in kvm_arch_vcpu_ioctl_run and
>> any other ioctls that need it is best, but in any case adding more pairs
>> is safe because they can be nested.
>
> So I added a small wrapper around kvm_read_guest(), which takes and
> drops the lock. Will send out the patch shortly. If powerpc needs it, I
> am happy to provide this wrapper in kvm_main.c instead of some arm
> header file instead.

I think that risks having some performance impact, though perhaps
mitigated by ARM having many virtual devices in the core.  Moving it
above would be better, to the equivalent of POWER's kvmppc_handle_exit*
functions.

Paolo
