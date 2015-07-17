From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 02/10] arm/arm64: KVM: Move vgic handling to a
 non-preemptible section
Date: Sat, 18 Jul 2015 00:15:27 +0200
Message-ID: <20150717221527.GI14024@cbox>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
 <1436378202-20224-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F68258DD3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q4G6CGNRr1-g for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 18:03:13 -0400 (EDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC38658DD1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:12 -0400 (EDT)
Received: by lagw2 with SMTP id w2so68263173lag.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 15:15:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436378202-20224-3-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 06:56:34PM +0100, Marc Zyngier wrote:
> As we're about to introduce some serious GIC-poking to the vgic code,
> it is important to make sure that we're going to poke the part of
> the GIC that belongs to the CPU we're about to run on (otherwise,
> we'd end up with some unexpected interrupts firing)...
> =

> Introducing a non-preemptible section in kvm_arch_vcpu_ioctl_run
> prevents the problem from occuring.
> =

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
