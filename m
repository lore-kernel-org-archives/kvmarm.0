From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally
Date: Wed, 21 Oct 2015 15:45:20 +0200
Message-ID: <9140096.cYCnE2rDUr@wuerfel>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org> <1445357947-6022-4-git-send-email-christoffer.dall@linaro.org> <672714208.55851501.1445370665940.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <672714208.55851501.1445370665940.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tuesday 20 October 2015 15:51:05 Paolo Bonzini wrote:
> Should this be "select" or "depends on"? Not a blocker, can always be fixed in 4.4.

We have lots of 'select ARM_GIC' in the tree for platforms that use one, using
'depends on' will limit KVM support to being available only if at least one
of them is being used.

The only platform I can think of that uses ARMv7ve without actually having
a GIC is BCM2836 (Raspberry Pi 2). Can we actually run KVM on a platform
like that? If so, 'depends on' might be better, otherwise let's stay with
'select'.

Note that ARM_GIC is not a user-visible option, you can only turn it on
by picking one or more platforms that have a GIC.

	Arnd
