From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 22/22] KVM: arm64: vgic-v3:
 KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
Date: Wed, 26 Apr 2017 17:05:47 +0530
Message-ID: <CACJhumdp33HYaidM9BEmV42+T7Os3CttBCNL7gei-jK0vSPSAA@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-23-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C38C540BDD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:32:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0OZBvh3dEEs5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 07:32:57 -0400 (EDT)
Received: from mail-lf0-f68.google.com (mail-lf0-f68.google.com
 [209.85.215.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D568A40A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:32:56 -0400 (EDT)
Received: by mail-lf0-f68.google.com with SMTP id 75so24532836lfs.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:35:48 -0700 (PDT)
In-Reply-To: <1492164934-988-23-git-send-email-eric.auger@redhat.com>
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
> This patch adds a new attribute to GICV3 KVM device
> KVM_DEV_ARM_VGIC_GRP_CTRL group. This Allows the userspace to
> flush all GICR pending tables into guest RAM. At the moment
> we do not offer any restore control as the sync is implicit.
>
> As we need the PENDBASER_ADDRESS() in vgic-v3, let's move its
> definition in the irqchip header. We restore the full length
> of the field, ie [51:16]. Same for PROPBASER_ADDRESS with full
> field length of [51:12].
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
