From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 07/22] KVM: arm64: vgic-its: Implement
 vgic_its_has_attr_regs and attr_regs_access
Date: Wed, 26 Apr 2017 16:54:12 +0530
Message-ID: <CACJhumcH+L1P-r4o5bHD7y5EoF-WPq3bAw0iXaqjUmnh7GQSoA@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 897CE40C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:21:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iPpoOQ1vVc9M for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 07:21:22 -0400 (EDT)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9780440C28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:21:22 -0400 (EDT)
Received: by mail-lf0-f65.google.com with SMTP id i3so24524550lfh.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:24:14 -0700 (PDT)
In-Reply-To: <1492164934-988-8-git-send-email-eric.auger@redhat.com>
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
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 3:45 PM, Eric Auger <eric.auger@redhat.com> wrote:
> This patch implements vgic_its_has_attr_regs and vgic_its_attr_regs_access
> upon the MMIO framework. VGIC ITS KVM device KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> group becomes functional.
>
> At least GITS_CREADR and GITS_IIDR require to differentiate a guest write
> action from a user access. As such let's introduce a new uaccess_its_write
> vgic_register_region callback.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
