From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 10/22] KVM: arm64: vgic-its: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Wed, 26 Apr 2017 16:57:57 +0530
Message-ID: <CACJhumfjJLn=jJMhoNMQ2vg27XEya8msoOM4V1Fs__Y8ghdizg@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-11-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C35F40C2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:25:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u-BL-9Gnr-zE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 07:25:07 -0400 (EDT)
Received: from mail-lf0-f68.google.com (mail-lf0-f68.google.com
 [209.85.215.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66D6C40C28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:25:07 -0400 (EDT)
Received: by mail-lf0-f68.google.com with SMTP id 88so24498742lfr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:27:58 -0700 (PDT)
In-Reply-To: <1492164934-988-11-git-send-email-eric.auger@redhat.com>
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
> The GITS_IIDR revision field is used to encode the migration ABI
> revision. So we need to restore it to check the table layout is
> readable by the destination.
>
> By writing the IIDR, userspace thus force the ABI revision to be
> used and this msut be less or equal than the max revision KVM supports.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
