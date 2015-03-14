From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 03/12] KVM: arm/arm64: remove now unneeded include
 directory from Makefile
Date: Sat, 14 Mar 2015 15:43:44 +0100
Message-ID: <20150314144344.GJ10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D65D948D9A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:36:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rQOda7py4v-f for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Mar 2015 10:36:54 -0400 (EDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0870C48D92
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:36:53 -0400 (EDT)
Received: by lbbzq9 with SMTP id zq9so6785043lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 07:43:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426263012-22935-4-git-send-email-andre.przywara@arm.com>
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

On Fri, Mar 13, 2015 at 04:10:03PM +0000, Andre Przywara wrote:
> virt/kvm was never really a good include directory for anything else
> than locally included headers.
> With the move of iodev.h there is no need anymore to add this
> directory the compiler's include path, so remove it from the arm and
> arm64 kvm Makefile.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
