From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v9 0/6] KVM: arm/arm64: gsi routing support
Date: Fri, 22 Jul 2016 19:13:54 +0200
Message-ID: <20160722171354.GC11512@potion>
References: <1469204442-3220-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469204442-3220-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-22 16:20+0000, Eric Auger:
> With the advent of GICv3 ITS in-kernel emulation, KVM MSI routing
> becomes mandated for proper VIRTIO-PCI vhost integration.

Changes to interfaces and common code look ok,

Acked-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>

Good work.
