From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 21/22] KVM: arm64: vgic-its: Fix pending table sync
Date: Wed, 26 Apr 2017 17:05:15 +0530
Message-ID: <CACJhumdH=duE3qPqvH5yC2=Tvthk_dz4TqTaw-gy+oiZi9bYMQ@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-22-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EC8440C30
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:32:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ubd1IvQi+9u6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 07:32:25 -0400 (EDT)
Received: from mail-lf0-f67.google.com (mail-lf0-f67.google.com
 [209.85.215.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AB7940C2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:32:25 -0400 (EDT)
Received: by mail-lf0-f67.google.com with SMTP id 88so24527455lfr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:35:16 -0700 (PDT)
In-Reply-To: <1492164934-988-22-git-send-email-eric.auger@redhat.com>
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
> In its_sync_lpi_pending_table() we currently ignore the
> target_vcpu of the LPIs. We sync the pending bit found in
> the vcpu pending table even if the LPI is not targeting it.
>
> Also in vgic_its_cmd_handle_invall() we are supposed to
> read the config table data for the LPIs associated to the
> collection ID. At the moment we refresh all LPI config
> information.
>
> This patch passes a vpcu to vgic_copy_lpi_list() so that
> this latter returns a snapshot of the LPIs targeting this
> CPU and only those.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
