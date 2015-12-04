From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Get rid of old vcpu_reg()
Date: Fri, 04 Dec 2015 11:23:58 +0000
Message-ID: <566177CE.6090404@arm.com>
References: <cover.1449224338.git.p.fedin@samsung.com> <98601c9db3aac80d60e3cbbca1c567db359038f0.1449224339.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <98601c9db3aac80d60e3cbbca1c567db359038f0.1449224339.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/12/15 10:26, Pavel Fedin wrote:
> Using oldstyle vcpu_reg() accessor is proven to be inappropriate and
> unsafe on ARM64. This patch converts the rest of use cases to new
> accessors and completely removes vcpu_reg() on ARM64.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
