From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 13/22] KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
 group
Date: Sun, 09 Apr 2017 11:09:53 +0100
Message-ID: <86h91xc2oe.fsf@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-14-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F2E40D85
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Apr 2017 06:08:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5AqkxEHdXicf for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Apr 2017 06:08:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA84840D7A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Apr 2017 06:08:05 -0400 (EDT)
In-Reply-To: <1490607072-21610-14-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Mon, 27 Mar 2017 11:31:03 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27 2017 at 10:31:03 AM, Eric Auger <eric.auger@redhat.com> wrote:
> Introduce a new group aiming at saving/restoring the ITS
> tables to/from the guest memory.
>
> We hold the vcpus lock during the save and restore to make
> sure no vcpu is running.
>
> At this stage the functionality is not yet implemented. Only
> the skeleton is put in place.
>
> The ABI revision supposed to have been set through IIDR user
> write is checked before the table restoration. This guarantees
> this vITS knows how to restore the saved tables.

This last point hints at the kernel side being able to deal with
multiple versions of the ABI. As I mentioned before, this requires some
clarification on what we plan to support, and whether or not we are able
to deprecate ABIs in the long run

One thing that is not clear to me is that although you want to be able
to restore the vITS using a given ABI, should you be able to save it
using that same ABI? Or does a restore/save cycle act as an ABI upgrade
for this VM?

I'd also like to see some infrastructure in the code to support this, in
the form of a per-ABI array of support functions (even if we only have
one ABI for the time being). Although that's not required ATM, it would
certainly halp me understanding what is ABI-specific and what's not.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
