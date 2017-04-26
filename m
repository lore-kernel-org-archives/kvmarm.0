From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 20/22] KVM: arm64: vgic-its: Device table save/restore
Date: Wed, 26 Apr 2017 17:04:39 +0530
Message-ID: <CACJhume3UQUzKBAuQcqWPMWCPBG6oayARVBNU7Rwk1yD7CDPKg@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-21-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DCDA40C2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:31:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wjsUlk3x6Ay0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 07:31:49 -0400 (EDT)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B6CD40BDD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:31:49 -0400 (EDT)
Received: by mail-lf0-f65.google.com with SMTP id 75so24528401lfs.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:34:40 -0700 (PDT)
In-Reply-To: <1492164934-988-21-git-send-email-eric.auger@redhat.com>
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
> This patch saves the device table entries into guest RAM.
> Both flat table and 2 stage tables are supported. DeviceId
> indexing is used.
>
> For each device listed in the device table, we also save
> the translation table using the vgic_its_save/restore_itt
> routines.
>
> On restore, devices are re-allocated and their ite are
> re-built.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
