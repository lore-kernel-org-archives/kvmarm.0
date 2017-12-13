From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC v2] arm64: KVM: KVM API extensions for SVE
Date: Wed, 13 Dec 2017 16:58:16 +0000
Message-ID: <CAFEAcA-Rogf9m7GMPD3PKs7miEpx-bMMn72Y+2=eF4oiCdLqqw@mail.gmail.com>
References: <20171213165543.GO22781@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 200A049D6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 11:55:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5+4jZDXH3O25 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 11:55:05 -0500 (EST)
Received: from mail-ot0-f181.google.com (mail-ot0-f181.google.com
 [74.125.82.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2782040651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 11:55:04 -0500 (EST)
Received: by mail-ot0-f181.google.com with SMTP id i1so2517287oth.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 08:58:36 -0800 (PST)
In-Reply-To: <20171213165543.GO22781@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Libvirt <libvir-list@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 December 2017 at 16:55, Dave Martin <Dave.Martin@arm.com> wrote:
> Vector length control:
>
> Some means is needed to determine the set of vector lengths visible
> to guest software running on a vcpu.
>
> When a vcpu is created, the set would be defaulted to the maximal set
> that can be supported while permitting each vcpu to run on any host
> CPU.  SVE has some virtualisation quirks which mean that this set may
> exclude some vector lengths that are available for host userspace
> applications.  The common case should be that the sets are the same
> however.
>
>  * New ioctl KVM_ARM_VCPU_{SET,GET}_SVE_VLS to set or retrieve the set of
>    vector lengths available to the guest.
>
>    Adding random vcpu ioctls
>
>    To configure a non-default set of vector lengths,
>    KVM_ARM_VCPU_SET_SVE_VLS can be called: this would only be permitted
>    before the vcpu is first run.
>
>    This is primarily intended for supporting migration, by providing a
>    robust check that the destination node will run the vcpu correctly.
>    In a cluster with non-uniform SVE implementation across nodes, this
>    also allows a specific set of VLs to be requested that the caller
>    knows is usable across the whole cluster.
>
>    For migration purposes, userspace would need to do
>    KVM_ARM_VCPU_GET_SVE_VLS at the origin node and store the returned
>    set as VM metadata: on the destination node,
>    KVM_ARM_VCPU_SET_SVE_VLS should be used to request that exact set of
>    VLs: if the destination node can't support that set of VLs, the call
>    will fail.

Can we just do this with the existing ONE_REG APIs? If you
expose this via those, then QEMU doesn't need to do anything
for migration at all. This is the same way we (intend to)
check any optional-feature compatibility at each end, for
instance features exposed in guest-visible ID registers.
It's just that the "register" for the SVE vector-lengths case
is one that's not visible to the guest.

thanks
-- PMM
