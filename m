From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 1/2] config: move x86 kvm_guest.config to a common locaton
Date: Fri, 23 Sep 2016 01:11:37 +0200
Message-ID: <20160922231132.GB25134@potion>
References: <20160908184102.8592-1-robh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160908184102.8592-1-robh@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

2016-09-08 13:41-0500, Rob Herring:
> kvm_guest.config is useful for KVM guests on other arches, and nothing
> in it appears to be x86 specific, so just move the whole file. Kbuild
> will find it in either location.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: kvm@vger.kernel.org
> ---

Applied them both to kvm/queue, thanks.
