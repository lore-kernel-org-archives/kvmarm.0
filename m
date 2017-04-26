From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 09/22] KVM: arm64: vgic-its: Introduce migration ABI
 infrastructure
Date: Wed, 26 Apr 2017 16:57:12 +0530
Message-ID: <CACJhumcwKV5KVSuDCGA87maXMZ1JfCL-8tt=+ZtsNUR2r1L6ow@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-10-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AAA540C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:24:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vNXPgL7ne7dV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 07:24:22 -0400 (EDT)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 723D540C28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 07:24:22 -0400 (EDT)
Received: by mail-lf0-f65.google.com with SMTP id x72so24497674lfb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:27:14 -0700 (PDT)
In-Reply-To: <1492164934-988-10-git-send-email-eric.auger@redhat.com>
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
> We plan to support different migration ABIs, ie. characterizing
> the ITS table layout format in guest RAM. Typically a new ABI will
> be needed if vLPIs get supported for nested use case.
>
> So let's introduce an array of supported ABIs (at the moment a single
> ABI is supported though). The following characteristics are foreseen
> to vary with the ABI: size of table entries, save/restore operation.
>
> By default the MAX_ABI_REV is applied on its creation. In subsequent
> patches we will introduce a way for the userspace to change the ABI
> in use.
>
> The entry sizes now are set according to the ABI version and not
> hardcoded anymore.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
