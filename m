From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Tue, 29 Mar 2016 14:12:09 +0100
Message-ID: <56FA7F29.4060005@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 25/03/16 02:04, Andre Przywara wrote:
> Please have a look at the series, review it and give the code some
> serious testing (and possibly debugging). All feedback is appreciated.

I see that with the new vgic implementation kvmtool starts throwing:

kvm [1273]: Unable to register VGICv3 redist MMIO regions

for --cpus 58 and above, where with the old vgic it is quite happy with
up to 255 cpus.

Cheers
Vladimir
