From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v7 15/24] KVM: arm64: vgic-its: Read config and pending
 bit in add_lpi()
Date: Mon, 8 May 2017 14:28:13 +0200
Message-ID: <20170508122813.GG28342@cbox>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
 <1494084283-12723-16-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494084283-12723-16-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, May 06, 2017 at 05:24:34PM +0200, Eric Auger wrote:
> When creating the lpi we now ask the redistributor what is the state
> of the LPI (priority, enabled, pending).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>
