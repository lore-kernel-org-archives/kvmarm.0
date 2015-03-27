From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 08/11] KVM: arm/arm64: prepare GICv2 emulation to be
 handled by kvm_io_bus
Date: Fri, 27 Mar 2015 17:01:01 +0100
Message-ID: <20150327160101.GD5121@cbox>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
 <1427380778-942-9-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427380778-942-9-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>, kvmarm@lists.cs.columbia.edu, n.nikolaev@virtualopensystems.com, eric.auger@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 26, 2015 at 02:39:35PM +0000, Andre Przywara wrote:
> Using the framework provided by the recent vgic.c changes we register
> a kvm_io_bus device when initializing the virtual GICv2.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
