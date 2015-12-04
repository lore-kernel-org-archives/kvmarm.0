From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 2/4] KVM: arm64: Remove const from struct sys_reg_params
Date: Fri, 04 Dec 2015 13:00:41 +0000
Message-ID: <56618E79.7050700@arm.com>
References: <cover.1449230499.git.p.fedin@samsung.com> <5a0277da769bbb2e6e5383ba0daaa0cd0660d645.1449230499.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5a0277da769bbb2e6e5383ba0daaa0cd0660d645.1449230499.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/12/15 12:03, Pavel Fedin wrote:
> Further rework is going to introduce a dedicated storage for transfer
> register value in struct sys_reg_params. Before doing this we have to
> remove 'const' modifiers from it in all accessor functions and their
> callers.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm64/kvm/sys_regs.c            | 36 ++++++++++++++++++------------------
>  arch/arm64/kvm/sys_regs.h            |  4 ++--
>  arch/arm64/kvm/sys_regs_generic_v8.c |  2 +-
>  3 files changed, 21 insertions(+), 21 deletions(-)

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
