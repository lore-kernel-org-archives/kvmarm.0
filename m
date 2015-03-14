From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 01/12] KVM: Redesign kvm_io_bus_ API to pass VCPU
 structure to the callbacks.
Date: Sat, 14 Mar 2015 15:43:36 +0100
Message-ID: <20150314144336.GI10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68F6B48D92
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:36:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wWOouj2n9l6X for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Mar 2015 10:36:46 -0400 (EDT)
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B01648D95
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:36:45 -0400 (EDT)
Received: by lamx15 with SMTP id x15so9874873lam.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 07:43:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426263012-22935-2-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 13, 2015 at 04:10:01PM +0000, Andre Przywara wrote:
> From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> 
> This is needed in e.g. ARM vGIC emulation, where the MMIO handling
> depends on the VCPU that does the access.
> 
> Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Acked-by: Paolo Bonzini <pbonzini at redhat.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
