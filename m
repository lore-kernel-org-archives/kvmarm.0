From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: kvm: report original PAR_EL1 upon panic
Date: Tue, 24 Nov 2015 18:20:37 +0100
Message-ID: <20151124172037.GC18855@cbox>
References: <1447682309-5875-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1447682309-5875-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 16, 2015 at 01:58:29PM +0000, Mark Rutland wrote:
> If we call __kvm_hyp_panic while a guest context is active, we call
> __restore_sysregs before acquiring the system register values for the
> panic, in the process throwing away the PAR_EL1 value at the point of
> the panic.
> 
> This patch modifies __kvm_hyp_panic to stash the PAR_EL1 value prior to
> restoring host register values, enabling us to report the original
> values at the point of the panic.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>

Thanks, applied.

-Christoffer
