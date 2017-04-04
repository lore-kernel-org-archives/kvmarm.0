From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 22:10:15 +0200
Message-ID: <63209d09-0c45-0bb2-322b-e422f1360df7@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com> <20170404160417.GN11752@cbox>
 <20170404175718.su4tjx3psyez3qee@kamzik.brq.redhat.com>
 <20170404190438.GF31208@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDC9940A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 16:08:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5h7MuNXO8kwD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 16:08:09 -0400 (EDT)
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA81040A63
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 16:08:08 -0400 (EDT)
Received: by mail-wr0-f193.google.com with SMTP id w43so43600445wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 13:10:21 -0700 (PDT)
In-Reply-To: <20170404190438.GF31208@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 21:04, Christoffer Dall wrote:
>  - (On a related work, I suddenly felt it weird that
>    kvm_make_all_cpus_request() doesn't wake up sleeping VCPUs, but only
>    sends an IPI; does this mean that calling this function should be
>    followed by a kick() for each VCPU?  Maybe Radim was looking at this
>    in his series already.)

Yes, kvm_make_all_cpus_request in x86 is only used for "non urgent"
requests, i.e. things to do before the next guest entry.

>  - In the explanation you wrote, you use the term 'we' a lot, but when
>    talking about SMP barriers, I think it only makes sense to talk about
>    actions and observations between multiple CPUs and we have to be
>    specific about which CPU observes or does what with respect to the
>    other.  Maybe I'm being a stickler here, but there something here
>    which is making me uneasy.

The write1-mb-if(read2) / write2-mb-if(read1) pattern is pretty common,
so I think it is justified to cut the ordering on the reasoning and just
focus on what the two memory locations and conditions mean.  But I'd
wait for v3, since I'm sure that Drew also understands the
synchronization better.

>  - Finally, it feels very hard to prove the correctness of this, and
>    equally hard to test it (given how long we've been running with
>    apparently racy code).  I would hope that we could abstract some of
>    this into architecture generic things, that someone who eat memory
>    barriers for breakfast could help us verify, but again, maybe this is
>    Radim's series I'm asking for here.

What I can do here is to suggest copying the paradigms from x86, which
is quite battle tested (Windows hammers it really hard).

For QEMU I did use model checking in the past for some similarly hairy
synchronization code, but that is really just "executable documentation"
because the model is not written in C.

Paolo
