From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 13/16] KVM: arm64: Remove eager host SVE state saving
Date: Thu, 10 May 2018 17:53:27 +0100
Message-ID: <20180510165327.dhj2ijbjsi3xvmqu@armageddon.cambridge.arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-14-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1525882385-29181-14-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 05:13:02PM +0100, Dave P Martin wrote:
> Now that the host SVE context can be saved on demand from Hyp,
> there is no longer any need to save this state in advance before
> entering the guest.
> 
> This patch removes the relevant call to
> kvm_fpsimd_flush_cpu_state().
> 
> Since the problem that function was intended to solve now no longer
> exists, the function and its dependencies are also deleted.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
