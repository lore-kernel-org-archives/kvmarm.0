From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 08/22] KVM: arm64: ITS: Implement vgic_mmio_uaccess_write_its_iidr
Date: Sat, 08 Apr 2017 11:42:27 +0100
Message-ID: <864lxzch9o.fsf@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
        <1490607072-21610-9-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1490607072-21610-9-git-send-email-eric.auger@redhat.com> (Eric
        Auger's message of "Mon, 27 Mar 2017 11:30:58 +0200")
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27 2017 at 10:30:58 AM, Eric Auger <eric.auger@redhat.com> wrote:
> The GITS_IIDR revision field is used to encode the version of the
> table layout (ABI). So we need to restore it to check the table
> layout to be restored is compatible with the destination vITS.
>
> The user selected revision is stored in the user_revision field.
> It will be compared against the REV num at table restoration time.

Why isn't it sufficient to keep it GITS_IIDR RO and let userspace find
out about the ABI revision that the kernel understands?

Or are we planning on supporting multiple ABIs in the kernel? If so, do
we have a deprecation policy/plan? I don't mind either way, but it would
be good to document it...

Maybe it is documented already and I missed it (which is perfectly
possible!).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
