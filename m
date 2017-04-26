From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 08/22] KVM: arm64: vgic-its: Implement
 vgic_mmio_uaccess_write_its_creadr
Date: Wed, 26 Apr 2017 16:54:53 +0530
Message-ID: <CACJhumcnS-TS9GL7krxccMEjTwzGPo7y0OgAqbi9WSFXhWv1gw@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-9-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC0540C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:22:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6pVExqdsYxm7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 07:22:03 -0400 (EDT)
Received: from mail-lf0-f68.google.com (mail-lf0-f68.google.com
 [209.85.215.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 234FE40C28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:22:03 -0400 (EDT)
Received: by mail-lf0-f68.google.com with SMTP id 75so24490511lfs.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:24:54 -0700 (PDT)
In-Reply-To: <1492164934-988-9-git-send-email-eric.auger@redhat.com>
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
> GITS_CREADR needs to be restored so let's implement the associated
> uaccess_write_its callback. The write only is allowed if the its
> is disabled.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
